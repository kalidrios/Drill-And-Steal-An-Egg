local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)
local EggService = require(game.ServerScriptService.Controllers.EggService)
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil)
local EggScaleUtil = require(ReplicatedStorage.Library.Util.EggScaleUtil)
local Assets = require(ReplicatedStorage.Directory.Assets)
local Areas = require(ReplicatedStorage.Directory.Areas)
local AreaEggSlotIdentity = require(ReplicatedStorage.Library.Util.AreaEggSlotIdentity)
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil)

local Network = ReplicatedStorage:WaitForChild("Network")
local RequestAreaEggSnapshotRemote = Network:WaitForChild("Eggs: RequestAreaEggSnapshot")
local RequestAreaEggCarryRemote = Network:WaitForChild("Eggs: RequestAreaEggCarry")
local RequestAreaEggDropRemote = Network:WaitForChild("Eggs: RequestAreaEggDrop")
local AreaEggUpdatedRemote = Network:WaitForChild("Eggs: AreaEggUpdated")
local AreaEggRemovedRemote = Network:WaitForChild("Eggs: AreaEggRemoved")
local AreaEggCarryStateRemote = Network:WaitForChild("Eggs: AreaEggCarryState")
local AreaEggClaimFeedbackRemote = Network:WaitForChild("Eggs: AreaEggClaimFeedback")
local AreaEggResetStartCountdownRemote = Network:WaitForChild("Eggs: AreaEggResetStartCountdown")
local RequestAreaEggRareSpawnPresentationsRemote = Network:WaitForChild("Eggs: RequestAreaEggRareSpawnPresentations")
local ForestHitRemote = Network:WaitForChild("Guards: ForestHit")
local ForestDepositRemote = Network:WaitForChild("Guards: ForestDeposit")

local SpeedHitWarningRemote = Network:WaitForChild("Guards: SpeedHitWarning")
local SpeedHitOfferRemote = Network:WaitForChild("Guards: SpeedHitOffer")

local SPEED_HIT_OFFER_PRODUCT_ID = nil 
local SPEED_HIT_OFFER_AMOUNT = 500 

local GuardAreasFolder = Workspace:WaitForChild("__OBJECTS"):WaitForChild("Areas"):WaitForChild("GuardAreas")

for _, area in ipairs(GuardAreasFolder:GetChildren()) do
	local nests = area:FindFirstChild("Nests")
	if nests then
		for _, nest in ipairs(nests:GetChildren()) do
			if nest:IsA("Model") and not nest:FindFirstChild("EggSpotBottom", true) then
				local spot = Instance.new("Part")
				spot.Name = "EggSpotBottom"
				spot.Size = Vector3.new(0.2, 0.2, 0.2)
				spot.Transparency = 1
				spot.CanCollide = false
				spot.CanTouch = false
				spot.CanQuery = false
				spot.Anchored = true
				spot.CFrame = nest:GetPivot() * CFrame.new(0, 1, 0)
				spot.Parent = nest
			end
		end
	end
end

local ZONE_NAMES = { "Forest", "Snow", "Jungle", "Desert", "Volcano", "Abyss Ocean", "Lake", "Prehistoric", "Cosmic" }
local RESPAWN_DELAY_SECONDS = 20

warn("[AreaEggService] MODULE LOADED -- if you see this, the server-side piece is running.")

local AreaEggService = {}

local records = {} -- uid -> AreaEggRecord
local nestOccupant = {} -- "AreaId:NestId" -> uid
local nestModelByUid = {} -- uid -> Nest Model (for respawn scheduling)
local carryByPlayer = {} -- Player -> uid
local version = 0



local zoneModel = {} -- AreaId -> Model
local zoneNests = {} -- AreaId -> array<Model> (sorted, index+1 = Slot number)

for _, name in ipairs(ZONE_NAMES) do
	local model = GuardAreasFolder:FindFirstChild(name)
	if model then
		zoneModel[name] = model
		local ok, nests = pcall(AreaEggSlotIdentity.GetSortedNests, model)
		if ok then
			zoneNests[name] = nests
		else
			warn("[AreaEggService] Failed to read nests for " .. name .. ": " .. tostring(nests))
		end
	end
end

local function nestKey(areaId, nestId)
	return areaId .. ":" .. nestId
end

local function weightedPick(dropTable)
	local total = 0
	for _, entry in ipairs(dropTable) do
		total += entry[2]
	end
	local roll = math.random() * total
	local acc = 0
	for _, entry in ipairs(dropTable) do
		acc += entry[2]
		if roll <= acc then
			return entry[1]
		end
	end
	return dropTable[#dropTable][1]
end

-- NOTE: this used to also roll a separate invented "5% chance -> rare creature x3 scale"
-- on top of this. Removed: EggItemUtil.BuildSavedEgg (called below, same as every other egg
-- source in the game) ALREADY rolls AssetScale from a real weighted table
-- (WeightedScaleRollUtil + the 11-tier list in EggItemUtil) that goes from ~0.1x (diminuto) all
-- the way to ~35x (colosal, ~1 in 25 million), with ~80% landing near 1x -- the exact "a veces
-- pequeño, un poco mas grande, normal, un poquitin mas, uno gigante" gradient the user remembers
-- from the real game. The invented bolt-on was redundant with (and inconsistent alongside) a
-- system that was already real and already being called.
local function pickCategoryFor(areaId)
	local area = Areas.Directory[areaId]
	if area and area.DropTable and #area.DropTable > 0 then
		return weightedPick(area.DropTable)
	end
	return "Chicken"
end

-- BUG FIX (user report: "el nest donde tiene que estar el huevo es muchisimo mas enorme que el
-- huevo"): the NestScale formula below (session-10 fix, still correct as far as it goes) reuses
-- the EXACT SAME visual-scale multiplier the creature itself renders at
-- (EggScaleUtil.GetPreGrowthVisualScale(1, AssetScale, category)) and applies it to the Nest
-- prop. Verified live in Studio: every "NestModel" is ~5.6 studs wide at Scale=1 regardless of
-- area, while creature templates (ReplicatedStorage.Assets.Models.Eggs) range from well under 1
-- stud (Chicken: ~0.7) to several studs (Mammoth: ~5.2) at that SAME Scale=1 baseline. Reusing
-- one multiplier on two objects with wildly different base sizes doesn't make them match -- it
-- preserves whatever disproportion already existed at 1x (nest ~8x wider than a baseline
-- Chicken) and, for high-tier creatures pushing the multiplier toward its 8x cap, balloons that
-- into a ~45-stud slab. Confirmed with the real EggScaleUtil formula across AssetScale 1-35 for
-- Chicken/Mammoth/Cyclops Gorilla before writing this fix.
-- Fix: derive NestScale from the CREATURE's actual rendered footprint (same template + same
-- formula EggRenderer.RenderVisual uses client-side) divided by the Nest model's own true
-- unscaled footprint, so the nest is sized to actually frame whatever is currently sitting in
-- it instead of drifting independently. The nest's true unscaled size is recovered as
-- currentSize/currentScale rather than assumed -- ScaleTo is the only thing that ever touches
-- this shared, reused-in-place map instance's size, so that division is safe even across
-- however many previous eggs/sessions already scaled it.
local EggTemplatesFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Eggs")
local NEST_TO_EGG_FOOTPRINT_RATIO = 1.2
local MIN_NEST_SCALE = 0.15
local MAX_NEST_SCALE = 3.0

local function resolveNestScale(nestModel, category, assetScale)
	local eggVisualScale = EggScaleUtil.GetPreGrowthVisualScale(1, assetScale or 1, category)

	local ok, result = pcall(function()
		local template = EggTemplatesFolder:FindFirstChild(category)
		if not template then
			return nil
		end

		local currentNestScale = nestModel:GetScale()
		local _, nestCurrentSize = nestModel:GetBoundingBox()
		local nestBaseSize = nestCurrentSize / currentNestScale
		local nestBaseFootprint = math.max(nestBaseSize.X, nestBaseSize.Z)

		if nestBaseFootprint <= 0 then
			return nil
		end

		local _, templateSize = template:GetBoundingBox()
		local eggFootprint = math.max(templateSize.X, templateSize.Z) * eggVisualScale

		return math.clamp((eggFootprint * NEST_TO_EGG_FOOTPRINT_RATIO) / nestBaseFootprint, MIN_NEST_SCALE, MAX_NEST_SCALE)
	end)

	if ok and result then
		return result
	end

	-- Fall back to the old (still not-wrong, just not-footprint-aware) behavior if anything
	-- above didn't resolve (missing template, zero-size nest, etc.) rather than erroring the
	-- whole spawn.
	return eggVisualScale
end

local attemptCarry -- forward-declared, assigned further down

local function scheduleRespawn(areaId, nestModel, nestId)
	task.delay(RESPAWN_DELAY_SECONDS, function()
		if nestOccupant[nestKey(areaId, nestId)] == nil then
			AreaEggService.SpawnIntoNest(areaId, nestModel, nestId)
		end
	end)
end

function AreaEggService.SpawnIntoNest(areaId, nestModel, nestId)
	local category = pickCategoryFor(areaId)
	local ok, egg = pcall(EggItemUtil.BuildSavedEgg, category)
	if not ok then
		warn("[AreaEggService] BuildSavedEgg failed for " .. tostring(category) .. ": " .. tostring(egg))
		return
	end

	local zone = zoneModel[areaId]
	local bounds = zone and zone:FindFirstChild("Bounds")
	local eggSpotBottom = nestModel:FindFirstChild("EggSpotBottom", true)

	version += 1
	local uid = EggService.NewUid("AreaEgg")
	local record = {
		Uid = uid,
		AreaId = areaId,
		NestId = nestId,
		AssetCategory = egg.AssetCategory,
		AssetScale = egg.AssetScale,
		AssetEyeColor = egg.AssetEyeColor,
		AssetColorSeed = egg.AssetColorSeed,
		AssetColorIndex = egg.AssetColorIndex,
		Mutations = egg.Mutations or {},
		BaseMutation = egg.BaseMutation,
		-- The nest tracks the egg's visual size -- see resolveNestScale() above for why this is
		-- no longer just the egg's raw visual-scale multiplier reused on the nest prop.
		NestScale = resolveNestScale(nestModel, egg.AssetCategory, egg.AssetScale),
		BottomCFrame = (eggSpotBottom and eggSpotBottom.CFrame) or CFrame.new(),
		BoundsCFrame = (bounds and bounds.CFrame) or CFrame.new(),
		BoundsSize = (bounds and bounds.Size) or Vector3.new(0, 0, 0),
		-- "Slot" (not "Dropped"!) is the state the client's AreaEggs.lua actually spawns a fresh
		-- visual for when no prior model exists (renderSlot -> renderClientEgg fallback).
		-- "Dropped" only re-binds a model that's ALREADY parented in Workspace (mid-carry drop);
		-- for a never-before-rendered nest egg it silently does nothing. This was the exact bug
		-- behind "no salen los huevos en los Nest".
		State = "Slot",
		CarrierUserId = nil,
		DroppedAt = os.time(),
		Version = version,
	}

	records[uid] = record
	nestOccupant[nestKey(areaId, nestId)] = uid
	nestModelByUid[uid] = nestModel
	AreaEggUpdatedRemote:FireAllClients(record)

	return record
end

local function clearNestOccupant(uid)
	local record = records[uid]
	if not record then
		return
	end
	local key = nestKey(record.AreaId, record.NestId)
	if nestOccupant[key] == uid then
		nestOccupant[key] = nil
	end
end

-- A carried egg is successfully brought to safety: hand it to the player as a normal
-- (unplaced) personal egg -- from here on the existing EggService place/grow/hatch loop
-- takes over, exactly matching "si coges el huevo lo puedes poner en tu plot".
local function claimAreaEgg(player, record)
	if not player or not record or not records[record.Uid] then
		return false
	end

	local profile = Database.Get(player) or Database.WaitForProfile(player, 5)
	if not profile then
		warn("[AreaEggService] Refused to consume stolen egg " .. tostring(record.Uid) .. " because profile is not loaded for " .. player.Name)
		return false
	end

	profile.EggInventory = profile.EggInventory or {}
	local egg = {
		AssetCategory = record.AssetCategory,
		AssetScale = record.AssetScale,
		AssetEyeColor = record.AssetEyeColor,
		AssetColorSeed = record.AssetColorSeed,
		AssetColorIndex = record.AssetColorIndex,
		Mutations = record.Mutations,
		BaseMutation = record.BaseMutation,
		IsStolenDNA = true,
	}
	local uid = EggService.NewUid("Egg")
	profile.EggInventory[uid] = egg
	local okSet, setErr = pcall(Database.SetAndBroadcast, player, { EggInventory = profile.EggInventory })
	if not okSet then
		profile.EggInventory[uid] = nil
		warn("[AreaEggService] Failed to add stolen egg to inventory for " .. player.Name .. ": " .. tostring(setErr))
		return false
	end

	local okTool, EggServiceForTool = pcall(require, game.ServerScriptService.Controllers.EggService)
	if okTool and EggServiceForTool.GrantEggTool then
		local okGrant, granted = pcall(EggServiceForTool.GrantEggTool, player, uid, egg)
		if not okGrant or granted ~= true then
			warn("[AreaEggService] Failed to create stolen egg tool for " .. player.Name .. ": " .. tostring(granted))
		end
	end
	print("[AreaEggService] Claimed stolen egg " .. uid .. " for " .. player.Name)

	local config = Assets.Directory[record.AssetCategory]
	AreaEggClaimFeedbackRemote:FireClient(player, {
		AssetCategory = record.AssetCategory,
		DisplayName = (config and config.DisplayName) or record.AssetCategory,
		Rarity = (config and config.Rarity and config.Rarity._id) or "Common",
		Color = (config and config.Rarity and config.Rarity.Color) or Color3.new(1, 1, 1),
		Position = record.BottomCFrame.Position,
	})

	carryByPlayer[player] = nil
	records[record.Uid] = nil
	local nestModel = nestModelByUid[record.Uid]
	nestModelByUid[record.Uid] = nil
	AreaEggRemovedRemote:FireAllClients(record.Uid)

	-- BUG FIX (user report: al llegar a la safe zone "me sigue saliendo el drop run y lo rojo
	-- de fondo" -- the tense run-back screen effects/music never turn off after a successful
	-- claim). Root cause: this function is the ONE place every successful claim funnels through
	-- (instant non-Forest pickup AND the new Forest safe-zone deposit), but it never told the
	-- client the carry ended -- only AreaEggRemovedRemote fired. AreaEggs.lua's own carried-egg
	-- hand visual already has a documented workaround listening to AreaEggRemoved for exactly
	-- this reason, but CarryRunBackEffects.lua (the red vignette/music) ONLY listens to
	-- AreaEggCarryStateChanged and has no such fallback -- it just never finds out. Every other
	-- carry-ending path (drop, guard catch) already fires this; claiming was the one gap.
	AreaEggCarryStateRemote:FireClient(player, {
		IsCarrying = false,
		SpeedMultiplier = 1
	})

	if nestModel then
		scheduleRespawn(record.AreaId, nestModel, record.NestId)
	end
end

local function returnToNest(record, reason)
	version += 1
	record.State = "Slot" -- back in its home nest slot, same as a fresh spawn (see SpawnIntoNest)
	record.CarrierUserId = nil
	record.DroppedAt = os.time()
	record.Version = version
	nestOccupant[nestKey(record.AreaId, record.NestId)] = record.Uid
	AreaEggUpdatedRemote:FireAllClients(record)
end

-- Initial population: fill every nest in every zone (small stagger so we're not building 84
-- creature configs' worth of eggs in a single frame). 0.25s/nest across 9 zones x5 nests could
-- take over 11s to finish -- tightened to 0.05s (~2.3s worst case) so "no aparecen los huevos"
-- reports aren't just someone checking before the stagger finishes.
do
	local delayIndex = 0
	local spawnedCount = 0
	local totalNests = 0
	local totalZones = 0
	for _, nests in pairs(zoneNests) do
		totalNests += #nests
		totalZones += 1
	end
	for areaId, nests in pairs(zoneNests) do
		for _, nestModel in ipairs(nests) do
			local ok, nestId = pcall(AreaEggSlotIdentity.GetNestId, zoneModel[areaId], nestModel)
			if ok then
				delayIndex += 1
				task.delay(delayIndex * 0.05, function()
					AreaEggService.SpawnIntoNest(areaId, nestModel, nestId)
					spawnedCount += 1
					if spawnedCount == totalNests then
						warn(string.format("[AreaEggService] Initial population done: %d/%d nests filled across %d zones.", spawnedCount, totalNests, totalZones))
					end
				end)
			else
				warn("[AreaEggService] GetNestId failed for " .. areaId .. ": " .. tostring(nestId))
			end
		end
	end
end

-- FEATURE (user report: "los huevos se suponen que se tienen que resetear" + the "Night"
-- countdown wall/UI only ever showing once per session at best): confirmed nothing server-side
-- ever fired "Eggs: AreaEggResetStartCountdown" -- the remote the client's ResetStartTimer.lua
-- (wall reveal, 3-2-1 countdown, "ALL EGG RESET!") is entirely built to react to. The client
-- only self-triggers it ONCE, at script load, IF the player happens to join mid-night
-- (AreaEggResetTimeUtil.IsNight is a pure/deterministic function of Workspace:GetServerTimeNow()
-- -- no server round-trip needed to know "is it night", confirmed reading it in full). But
-- nothing ever re-fires for a night that starts WHILE a player is already in the game, and
-- nothing ever actually resets the wild nest eggs either -- the whole night/day cycle was
-- visual-only for whoever happened to load in at the right second, with zero gameplay effect.
-- Fix: a lightweight poll loop that (a) broadcasts the same countdown payload the client
-- already knows how to render whenever a new night starts, so it repeats every cycle for
-- everyone, and (b) actually respawns the wild nests once each day begins, skipping any egg
-- currently Carried/Dropped so a night reset can never yank an egg out from mid-heist.

-- FEATURE (user request: "puede tocar secret egg un eternal lunar dragon egg... dime que
-- porcentaje hay de cada uno y cuando toca aparece el mensaje en gui justo cuando sale el 3 2 1,
-- por ejemplo 'Eternal Lunar Dragon egg spawned in volcano'"). This whole announcement pipeline
-- was ALREADY fully built client-side (ResetStartTimer.lua's requestJoinRareSpawnPresentations
-- polls Eggs: RequestAreaEggRareSpawnPresentations until ready, then announceRareSpawns shows a
-- top notification + chat message per entry, timed to when the countdown actually completes --
-- confirmed by reading it) but the server-side handler for that remote was FAIL/stub-answering
-- "ready, none pending" always (same EggService.lua fallback pattern as RequestAreaEggSnapshot),
-- so nothing was ever announced regardless of what spawned. Real per-zone spawn odds confirmed
-- live from Areas.Directory[zone].DropTable (the same weights pickCategoryFor already rolls from
-- below) -- e.g. Cosmic: Eternal Lunar Dragon 0.31%, Unicorn (Divine) 0.023%; Volcano: Cerberus
-- (Secret) 0.62%, Dragon/Ascended Vermilion Phoenix (Eternal) ~0.2% each -- every zone has its
-- own tiny-odds Secret/Eternal/Divine tail. RARE_SPAWN_MIN_RARITY_NUMBER=8 catches exactly that
-- tail (Secret=8, Cosmic-tier zone rarity string "Cosmic" itself is only RarityNumber 7 so it's
-- deliberately excluded -- those already show up too often to feel like a special announcement).
local RARE_SPAWN_MIN_RARITY_NUMBER = 8
local lastRareSpawnPresentations = {}

local function resetAllNests()
	local rareSpawns = {}

	for areaId, nests in pairs(zoneNests) do
		for _, nestModel in ipairs(nests) do
			local ok, nestId = pcall(AreaEggSlotIdentity.GetNestId, zoneModel[areaId], nestModel)

			if ok then
				local key = nestKey(areaId, nestId)
				local uid = nestOccupant[key]
				local record = uid and records[uid]

				if not (record and record.State ~= "Slot") then
					if record then
						records[uid] = nil
						nestOccupant[key] = nil
						nestModelByUid[uid] = nil
						AreaEggRemovedRemote:FireAllClients(uid)
					end

					local newRecord = AreaEggService.SpawnIntoNest(areaId, nestModel, nestId)
					if newRecord then
						local config = Assets.Directory[newRecord.AssetCategory]
						local rarity = config and config.Rarity
						if rarity and type(rarity.RarityNumber) == "number" and rarity.RarityNumber >= RARE_SPAWN_MIN_RARITY_NUMBER then
							local displayName = (config.DisplayName and config.DisplayName ~= "" and config.DisplayName) or newRecord.AssetCategory
							table.insert(rareSpawns, {
								EggUid = newRecord.Uid,
								Message = displayName .. " egg spawned in " .. areaId .. "!",
								RarityId = rarity._id or "Secret",
							})
						end
					end
				end
			end
		end
	end

	lastRareSpawnPresentations = rareSpawns
	warn("[AreaEggService] Night reset: all available nests respawned. Rare spawns: " .. #rareSpawns)
end

RequestAreaEggRareSpawnPresentationsRemote.OnServerInvoke = function(_player)
	return true, lastRareSpawnPresentations
end

task.spawn(function()
	local lastAnnouncedDayStartsAt = nil
	local lastResetDayStartsAt = nil

	while true do
		local ok, err = pcall(function()
			local now = Workspace:GetServerTimeNow()

			if AreaEggResetTimeUtil.IsNight(now) then
				local dayStartsAt = AreaEggResetTimeUtil.GetNextResetAt(now)

				if lastAnnouncedDayStartsAt ~= dayStartsAt then
					lastAnnouncedDayStartsAt = dayStartsAt
					-- DIAGNOSTIC (user report: "lo de la night no va, no aparece el bloque" --
					-- could not root-cause statically this session, the wiring reads correct
					-- end to end: this broadcast, EggCmds.handleAreaEggResetStartCountdown,
					-- ResetStartTimer.startSequence/runCountdown, AreaEggResetWall.Reveal. Left
					-- unable to playtest live again (MCP plugin loses its target connection
					-- during Play). Prints so next time this is confirmed to fire at all, and
					-- with what dayStartsAt/player count, instead of guessing blind a 4th time.
					print(("[AreaEggService] Night started, broadcasting AreaEggResetStartCountdown to %d player(s), dayStartsAt=%.1f (in %.1fs)")
						:format(#Players:GetPlayers(), dayStartsAt, dayStartsAt - now))
					AreaEggResetStartCountdownRemote:FireAllClients({
						DayStartsAt = dayStartsAt,
						RareSpawns = {}
					})
				end
			elseif lastAnnouncedDayStartsAt ~= nil and lastResetDayStartsAt ~= lastAnnouncedDayStartsAt and now >= lastAnnouncedDayStartsAt then
				lastResetDayStartsAt = lastAnnouncedDayStartsAt
				resetAllNests()
			end
		end)

		if not ok then
			warn("[AreaEggService] Night cycle watcher error: " .. tostring(err))
		end

		task.wait(1)
	end
end)

RequestAreaEggSnapshotRemote.OnServerInvoke = function(_player)
	local list = {}
	for _, record in pairs(records) do
		table.insert(list, record)
	end
	return { Records = list, ServerTime = os.time() }
end

attemptCarry = function(player, uid)
	if type(uid) ~= "string" then
		return false, "Invalid request"
	end
	if carryByPlayer[player] then
		return false, "Already carrying an egg"
	end
	local record = records[uid]
	-- "Dropped" (added alongside the guard-catch drop mechanic below) is an egg that fell
	-- outside the guard's zone when its previous carrier got caught -- per the user's spec
	-- ("si esta fuera de su zona lo puedes volver a coger"), anyone can pick it back up.
	if not record or (record.State ~= "Slot" and record.State ~= "Dropped") then
		return false, "Egg not available"
	end

	version += 1
	record.State = "Carried"
	record.CarrierUserId = player.UserId
	record.Version = version
	clearNestOccupant(uid)
	carryByPlayer[player] = uid

	AreaEggUpdatedRemote:FireAllClients(record)
	AreaEggCarryStateRemote:FireClient(player, {
		IsCarrying = true,
		Uid = record.Uid,
		AreaId = record.AreaId,
		AssetCategory = record.AssetCategory,
		RunBackWakeDelayRequired = false,
		SpeedMultiplier = 1,
	})

	return true
end

RequestAreaEggCarryRemote.OnServerInvoke = function(player, args)
	if type(args) ~= "table" then
		return false, "Invalid request"
	end
	return attemptCarry(player, args.Uid)
end

-- BUG FIX v2 (user report: first version claimed the egg the moment you left the SOURCE zone's
-- own bounds -- "cojo un huevo de la zona 2 y para tenerlo en mi inventario tengo que pasar por
-- la zona 1 y luego a la safe zone, ahi me lo da, pues esta mal, me lo da cuando llego a la
-- zona 1" -- since zones sit right next to each other, leaving zone 2 usually means walking
-- straight into zone 1's own bounds, which counted as "safe" even though zone 1 is still a wild
-- zone, not the actual safe hub). Fixed to require being outside ALL 9 zones' Bounds at once,
-- not just the one the egg came from -- cached once at module load (every zone folder under
-- GuardAreasFolder has its own Bounds part, confirmed structurally identical to Forest's).
local zoneBoundsParts = {}
for _, zoneName in ipairs(ZONE_NAMES) do
	local zoneModel = GuardAreasFolder:FindFirstChild(zoneName)
	local bounds = zoneModel and zoneModel:FindFirstChild("Bounds")
	if bounds then
		zoneBoundsParts[zoneName] = bounds
	end
end

local safeZonePart = Workspace:FindFirstChild("GameplayZ", true)
if safeZonePart and not safeZonePart:IsA("BasePart") then
	safeZonePart = nil
end

local function isInsideAnyZone(position)
	for _, bounds in pairs(zoneBoundsParts) do
		local relative = bounds.CFrame:PointToObjectSpace(position)
		local halfSize = bounds.Size * 0.5
		if math.abs(relative.X) <= halfSize.X and math.abs(relative.Z) <= halfSize.Z then
			return true
		end
	end
	return false
end

local function isInSafeZone(position)
	if not safeZonePart then
		return false
	end
	local relative = safeZonePart.CFrame:PointToObjectSpace(position)
	local halfSize = safeZonePart.Size * 0.5
	return math.abs(relative.X) <= halfSize.X and math.abs(relative.Z) <= halfSize.Z
end

-- BUG FIX (user report: "al robar los huevos de zone 2 o otra zona que no sea Forest le das al
-- prompt para robar e huir pero se roba automaticamente eso esta mal tiene que llegar a la safe
-- zone como el Forest"). Used to claim non-Forest eggs the INSTANT you picked them up -- no
-- run-back at all. Explicitly NOT fixed by building a chasing guard for the other 8 zones
-- (confirmed with the user -- not wanted, no threat needed there, just the "carry it home"
-- requirement). Instead this claims it once the carrier is outside every wild zone's bounds
-- (see isInsideAnyZone above). Forest is untouched -- it keeps its own real client-driven
-- Guards: ForestDeposit flow.
task.spawn(function()
	while true do
		task.wait(1)
		for player, uid in pairs(carryByPlayer) do
			local record = records[uid]
			if record and record.AreaId ~= "Forest" then
				local character = player.Character
				local hrp = character and character:FindFirstChild("HumanoidRootPart")
				if hrp and isInSafeZone(hrp.Position) then
					claimAreaEgg(player, record)
				end
			end
		end
	end
end)

RequestAreaEggDropRemote.OnServerInvoke = function(player, _args)
	local uid = carryByPlayer[player]
	if not uid then
		return false, "Not carrying anything"
	end
	local record = records[uid]
	carryByPlayer[player] = nil
	if record then
		returnToNest(record, "PlayerRequest")
	end
	AreaEggCarryStateRemote:FireClient(player, { IsCarrying = false, SpeedMultiplier = 1 })
	return true
end

-- The guard caught the carrying player. FEATURE (user request): previously this instantly
-- teleported the egg back to its nest ("returnToNest"), with no physical drop and no chance to
-- recover it. Now it DROPS at the player's position instead (State = "Dropped", matching the
-- schema's existing GuardHit DropReason and the client's already-working Dropped-state
-- rendering in AreaEggs.lua -- renderDropped just unwelds/repositions the model that's already
-- in the player's hand, confirmed by reading it). What happens next is already fully wired and
-- needed no further changes: ForestGuardRuntime's _tryRegisterDropped checks
-- GuardAreaLookupUtil.IsWorldPositionInsideXZBounds(zone.Bounds, dropPosition) -- inside the
-- zone, it registers with GuardEggRetrievalComponent and the guard walks over and carries it
-- home (see the ForestDeposit "Deposited" branch below); outside the zone, that check just
-- returns early and the egg sits there in "Dropped" state, pickable by attemptCarry (now allows
-- State == "Dropped" too, see above) -- exactly "si el huevo cae en la zona el guardia lo vuelve
-- a su sitio, si esta fuera de su zona lo puedes volver a coger".
ForestHitRemote.OnServerEvent:Connect(function(player, args)
	if type(args) ~= "table" or type(args.EggUid) ~= "string" then
		return
	end
	if carryByPlayer[player] ~= args.EggUid then
		return
	end
	local record = records[args.EggUid]
	if not record then
		return
	end
	carryByPlayer[player] = nil
	if record then
		local dropCFrame = nil
		local character = player.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			local _, yaw, _ = rootPart.CFrame:ToOrientation()
			dropCFrame = CFrame.new(rootPart.Position - Vector3.new(0, rootPart.Size.Y / 2, 0)) * CFrame.Angles(0, yaw, 0)
		elseif typeof(args.GuardCFrame) == "CFrame" then
			dropCFrame = args.GuardCFrame
		else
			dropCFrame = record.BottomCFrame
		end

		version += 1
		record.State = "Dropped"
		record.CarrierUserId = nil
		record.DroppedAt = os.time()
		record.BottomCFrame = dropCFrame
		record.BoundsCFrame = dropCFrame
		record.Version = version
		AreaEggUpdatedRemote:FireAllClients(record)
	end
	AreaEggCarryStateRemote:FireClient(player, { IsCarrying = false, SpeedMultiplier = 1 })

	-- Guard caught you -- show the free warning always, and the paid speed-boost offer only if a
	-- real product exists to sell (see SPEED_HIT_OFFER_PRODUCT_ID above).
	local ok, err = pcall(function()
		SpeedHitWarningRemote:FireClient(player)
		if SPEED_HIT_OFFER_PRODUCT_ID then
			SpeedHitOfferRemote:FireClient(player, SPEED_HIT_OFFER_PRODUCT_ID, SPEED_HIT_OFFER_AMOUNT)
		end
	end)
	if not ok then
		warn("[AreaEggService] Failed firing SpeedHitWarning/SpeedHitOffer for " .. player.Name .. ": " .. tostring(err))
	end
end)

-- "Attached" = picked up in-hand client-side (informational, state already Carried).
-- "Deposited" has two distinct real senders sharing the same event/Kind (confirmed by reading
-- both): (1) the CARRYING player reaching the safe zone (ForestGuardRuntime's own safe-zone
-- watcher) -- claim it for them, unchanged from before; (2) the GUARD's client-simulated
-- GuardEggRetrievalComponent finishing walking a DROPPED (uncarried) egg back to its nest
-- (_handleRetrievalEvent's "Deposited" branch) -- nobody is its carrier at that point, so the
-- claim branch below correctly no-ops for it; this was the missing piece that returns it to
-- "Slot" server-side so it isn't stuck as "Dropped" forever (and so it can be requested via the
-- normal RequestAreaEggCarry flow again, matching what's already visually sitting in its nest).
ForestDepositRemote.OnServerEvent:Connect(function(player, args)
	if type(args) ~= "table" or type(args.EggUid) ~= "string" then
		return
	end
	if args.Kind == "Attached" then
		return
	end
	if carryByPlayer[player] == args.EggUid then
		local record = records[args.EggUid]
		if record then
			claimAreaEgg(player, record)
		else
			carryByPlayer[player] = nil
		end
		return
	end
	local record = records[args.EggUid]
	if record and record.State == "Dropped" then
		returnToNest(record)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local uid = carryByPlayer[player]
	carryByPlayer[player] = nil
	if uid then
		local record = records[uid]
		if record then
			returnToNest(record)
		end
	end
end)

task.delay(3, function()
	local repaired = 0
	local checked = 0
	for areaId, nests in pairs(zoneNests) do
		for _, nestModel in ipairs(nests) do
			checked += 1
			local okId, nestId = pcall(AreaEggSlotIdentity.GetNestId, zoneModel[areaId], nestModel)
			if okId and nestOccupant[nestKey(areaId, nestId)] == nil then
				local okSpawn, result = pcall(AreaEggService.SpawnIntoNest, areaId, nestModel, nestId)
				if okSpawn and result then
					repaired += 1
				else
					warn("[AreaEggService] Retry spawn failed for " .. areaId .. "/" .. tostring(nestId) .. ": " .. tostring(result))
				end
			end
		end
	end
	warn(string.format("[AreaEggService] Spawn verification: checked %d nests, repaired %d empty nests.", checked, repaired))
end)

return AreaEggService
