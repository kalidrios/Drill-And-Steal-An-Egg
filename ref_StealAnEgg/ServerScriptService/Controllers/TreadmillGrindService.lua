-- ServerScriptService.Controllers.TreadmillGrindService
-- "Caminar en tu cinta te sube la velocidad poco a poco" -- standing on your own plot's
-- treadmill grants SpeedPower over time, using the game's real formula
-- (ReplicatedStorage.Library.Util.TreadmillUtil.ResolveSpeedPowerPerSecond, confirmed safe to
-- require and tested directly: ~8 SpeedPower/sec at the starter treadmill from a fresh profile).
--
-- Detection is a simple server-side proximity check against Plots.<N>.TreadmillBottom (the
-- physical belt part, confirmed to exist on every plot) -- not a perfect region match to
-- whatever zone the original client used, but a safe, honest approximation: stand within the
-- belt's footprint and you grind, same as the real game's core loop.
--
-- FEATURE (user request: "al rozar la treadmill se te pone ahi y mira hacia los videos" --
-- stepping on your treadmill is supposed to trigger a whole "active session": camera looks at
-- a video wall, TreadmillUI shows a speed-gain projection, etc). Root cause found reading the
-- client: SEVEN different controllers (TreadmillUI, TreadmillCharacterPresentationController,
-- TreadmillVideoController, MusicController, ActiveAssetsController, TreadmillStaticController,
-- TreadmillShiftLockController, SlowToggle, GameResetTimer, EggPlacementController) all listen
-- for "Treadmills: ActiveTreadmillChanged" and are FULLY built to react to it -- but nothing on
-- the server ever fired it (confirmed: zero matches anywhere in ServerScriptService), so none of
-- that ever activated -- same "client built, server never wired" pattern as everywhere else in
-- this project. Now fires it using the same on-treadmill detection this service already has.
-- Contract confirmed by reading TreadmillUI's handler in full: fires (treadmillId: string,
-- speedMultiplier: number, nextAwardServerTime: number, mediaFeedState: table) to activate, or
-- just (nil) to deactivate. treadmillId must be a real Treadmills.Directory key (= config._id,
-- confirmed via Treadmills.lua's own t4[v._id]=i indexing).

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)
local SpeedService = require(game.ServerScriptService.Controllers.SpeedService)
local PlotService = require(game.ServerScriptService.Controllers.PlotService)
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil)
local Treadmills = require(ReplicatedStorage.Directory.Treadmills)

-- BUG FIX (user report 2026-09-02: "cuando piso la treadmill me congela pero no me sube" --
-- player froze on the belt but got zero SpeedPower. Root cause in the Play log:
--   [TreadmillGrindService] ResolveSpeedPowerPerSecond failed for <name> (no gain this tick):
--   ReplicatedStorage.Library.Util.TreadmillUtil:245: invalid argument #1 to 'floor' (number
--   expected, got nil)
-- TreadmillUtil.ResolveSpeedBoostTierIndex(profile) does math.floor(profile.SpeedBoostTierIndex)
-- with no nil coercion; profiles saved before that field existed have it as nil, so every tick
-- errors out of the pcall below and the elseif type(gain) == "number" branch never runs -> no
-- gain awarded. Same pattern is likely for the other numeric stat fields the util walks. Fill
-- the missing defaults directly on the live profile (Database.Get returns the real table so the
-- backfill sticks, and this also self-heals the DB on the next autosave). Values match
-- ReplicatedStorage.Library.Modules.DefaultStats exactly.
local function ensureStatDefaults(profile)
	if profile.SpeedBoostTierIndex == nil then profile.SpeedBoostTierIndex = 0 end
	if profile.TemporarySpeedBoostRemainingSeconds == nil then profile.TemporarySpeedBoostRemainingSeconds = 0 end
	if profile.TemporarySpeedBoostActiveStartedAt == nil then profile.TemporarySpeedBoostActiveStartedAt = 0 end
	if profile.SpeedPower == nil then profile.SpeedPower = 10 end
	if profile.TreadmillUpgradeLevel == nil then profile.TreadmillUpgradeLevel = 1 end
	if profile.BaseUpgradeLevel == nil then profile.BaseUpgradeLevel = 0 end
	if profile.Rebirth == nil then profile.Rebirth = 0 end
	if profile.EquippedTrail == nil then profile.EquippedTrail = nil end -- explicit nil is fine
	if profile.TrailInventory == nil then profile.TrailInventory = {} end
	if profile.Gamepasses == nil then profile.Gamepasses = {} end
end

local Network = ReplicatedStorage:WaitForChild("Network")
local ActiveTreadmillEventRemote = Network:WaitForChild("Treadmills: ActiveTreadmillChanged")
local RequestUnequipRemote = Network:WaitForChild("Treadmills: RequestUnequip")
local RequestEquipStaticRemote = Network:WaitForChild("Treadmills: RequestEquipStatic")

local PlotsFolder = Workspace:WaitForChild("Plots")

local TreadmillGrindService = {}
local wasOnTreadmill = {} -- Player -> boolean, to only fire on actual on/off transitions
local TICK_INTERVAL = 0.2 -- seconds; see the two BUG FIX comments below the loop for why
local jumpCooldownUntil = {} -- Player -> os.clock() timestamp; see BUG FIX below RequestUnequipRemote
local JUMP_COOLDOWN_SECONDS = 3

-- BUG FIX (real Play log from the user, 2026-08-24: "me salgo y sigue dandome dinero" / "solo
-- saltando deja de ganar velocidad" -- once onTreadmill went true it was NEVER re-checked
-- against position again (see the removed "Once active, only the jump-triggered RequestUnequip
-- handler... turns it off" branch below), so walking off the belt without jumping left the
-- session running forever and kept granting SpeedPower. Confirmed directly in the user's own
-- log: rel drifted from (-0.5,3.0,-6.6) to (-10.5,2.9,17.4) -- way outside the declared
-- tolerance -- while onTreadmill kept printing true).
-- offTreadmillSince tracks, per player, the moment geometry FIRST left tolerance while a
-- session was active. Position is re-checked every tick again (so leaving the belt actually
-- ends the session reliably), but the session only actually turns off once the player has been
-- continuously off-geometry for EXIT_GRACE_SECONDS -- this is what the ORIGINAL report ("me
-- muevo sin querer y ya se va") really needed: a debounce against one bad tick of physics
-- jitter/settling, not a permanent disable of the exit check.
local offTreadmillSince = {} -- Player -> os.clock() timestamp
local EXIT_GRACE_SECONDS = 1

Players.PlayerRemoving:Connect(function(player)
	wasOnTreadmill[player] = nil
	jumpCooldownUntil[player] = nil
	offTreadmillSince[player] = nil
end)

-- BUG FIX (user report: "la treadmill como se me pone corriendo y para salir de la treadmill
-- tengo que saltar" -- jumping calls this remote (see TreadmillUI's UserInputService.
-- JumpRequest handler), but it was FAIL-stubbed, so the exit never actually worked). Mirrors
-- the "off" branch the poll loop below already fires, just triggered immediately instead of
-- waiting up to 1s for the next tick.
-- BUG FIX (user's own log: "TreadmillStaticController: [Warning] Static treadmill entry
-- rejected: Not available" -- fires whenever a player stands near their OWN idle/static
-- treadmill, right before it registers the model in RuntimeInstanceRegistry; no arguments are
-- sent, this is just a "yes, you're allowed to be here" ack tied to a purely client-side
-- raycast against the player's own rendered model, nothing to validate server-side).
RequestEquipStaticRemote.OnServerInvoke = function(_player)
	return true
end

-- BUG FIX (user report, confirmed in a real Play log: jumps straight up with WalkSpeed=0 so
-- there's no horizontal air control -- you land right back on the same spot on the belt,
-- re-triggering onTreadmill on the very next tick and re-activating the session immediately).
-- Suppress re-detection for a few seconds after a jump-exit so there's time to actually walk
-- away before the poll below is allowed to turn it back on.
RequestUnequipRemote.OnServerInvoke = function(player)
	jumpCooldownUntil[player] = os.clock() + JUMP_COOLDOWN_SECONDS
	offTreadmillSince[player] = nil

	if wasOnTreadmill[player] then
		wasOnTreadmill[player] = false
		local ok, err = pcall(function()
			ActiveTreadmillEventRemote:FireClient(player, nil)
		end)
		if not ok then
			warn("[TreadmillGrindService] Failed firing ActiveTreadmillChanged (manual unequip) for " .. player.Name .. ": " .. tostring(err))
		end
	end
	return true
end

local function isOnTreadmill(hrp, treadmillBottom)
	local relative = treadmillBottom.CFrame:PointToObjectSpace(hrp.Position)
	local size = treadmillBottom.Size
	return math.abs(relative.X) <= size.X / 2 + 1
		and math.abs(relative.Z) <= size.Z / 2 + 1
		and math.abs(relative.Y) <= size.Y / 2 + 10 -- generous vertical allowance (standing on top)
end

-- DIAGNOSTIC (user report: "al tocar la treadmill no se me sube" -- could not reproduce live,
-- the MCP plugin loses its server-target connection during a running playtest, so this couldn't
-- be root-caused directly this session). TreadmillBottom.Size.Y is ~0.001 (a thin flat trigger
-- plate, same "collapsed part" pattern seen elsewhere in this rip), so the vertical tolerance
-- above is doing all the work -- widened it a bit as a safe first guess, but the real cause
-- might be horizontal (wrong plot part, or the visual belt not aligned with this detector) or
-- something else entirely. This prints the exact relative offsets (throttled to once per 5s per
-- player) so next time paste the Output and it'll show exactly why the check does/doesn't pass,
-- instead of guessing again blind.
local lastDiagAt = {}
local function diagLog(player, hrp, treadmillBottom, passed)
	local now = os.clock()
	if lastDiagAt[player] and now - lastDiagAt[player] < 5 then
		return
	end
	lastDiagAt[player] = now
	local relative = treadmillBottom.CFrame:PointToObjectSpace(hrp.Position)
	local size = treadmillBottom.Size
	print(("[TreadmillGrindService DIAG] %s onTreadmill=%s rel=(%.1f,%.1f,%.1f) size=(%.2f,%.2f,%.2f) tolerance=(X:%.1f Y:%.1f Z:%.1f)")
		:format(player.Name, tostring(passed), relative.X, relative.Y, relative.Z,
			size.X, size.Y, size.Z, size.X / 2 + 1, size.Y / 2 + 10, size.Z / 2 + 1))
end

Players.PlayerRemoving:Connect(function(player)
	lastDiagAt[player] = nil
end)

task.spawn(function()
	while true do
		-- BUG FIX (user report: "vas tan rapido que no cuenta" -- walking onto the treadmill
		-- fast enough could cross the belt within the old 1s sample window without ever being
		-- caught standing on it). Sampled more often for the INITIAL step-on detection. The gain
		-- below is scaled by TICK_INTERVAL to compensate (ResolveSpeedPowerPerSecond returns a
		-- PER-SECOND rate -- ticking 5x more often without scaling would have handed out 5x the
		-- real SpeedPower/sec, a real balance/exploit bug, not just a detection fix).
		task.wait(TICK_INTERVAL)
		for _, player in ipairs(Players:GetPlayers()) do
			local profile = Database.Get(player)
			local plotId = PlotService.GetPlotId(player)
			local character = player.Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			if profile and plotId and hrp then
				ensureStatDefaults(profile)
				local plot = PlotsFolder:FindFirstChild(tostring(plotId))
				local treadmillBottom = plot and plot:FindFirstChild("TreadmillBottom")
				local onTreadmill
				if wasOnTreadmill[player] then
					-- See the offTreadmillSince BUG FIX comment near the top of this file:
					-- keep re-checking geometry (so walking away actually ends the session and
					-- stops the money/SpeedPower grant), but debounce the exit by
					-- EXIT_GRACE_SECONDS so one bad tick of physics jitter/settling on the
					-- belt's collider doesn't instantly kill a session the player never left.
					local stillOnGeometry = treadmillBottom and isOnTreadmill(hrp, treadmillBottom)
					if stillOnGeometry then
						offTreadmillSince[player] = nil
						onTreadmill = true
					else
						local since = offTreadmillSince[player]
						if since == nil then
							since = os.clock()
							offTreadmillSince[player] = since
						end
						onTreadmill = (os.clock() - since) < EXIT_GRACE_SECONDS
						if not onTreadmill then
							offTreadmillSince[player] = nil
						end
					end
				elseif (jumpCooldownUntil[player] or 0) > os.clock() then
					onTreadmill = false
				else
					onTreadmill = treadmillBottom and isOnTreadmill(hrp, treadmillBottom)
				end
				if treadmillBottom then
					diagLog(player, hrp, treadmillBottom, onTreadmill)
				end

				local config = Treadmills.GetByUpgradeLevel(profile.TreadmillUpgradeLevel or 1)

				-- Only fire on an actual on/off transition, not every tick -- matches how
				-- TreadmillUI's handler treats it as a session start/end, not a per-tick update.
				if onTreadmill ~= wasOnTreadmill[player] then
					wasOnTreadmill[player] = onTreadmill
					if onTreadmill and config then
						local multiplier = config.SpeedMultiplier or 1
						local nextAwardAt = Workspace:GetServerTimeNow() + 1
						local mediaFeedState = profile.TreadmillMediaFeedState or {}
						local ok, err = pcall(function()
							ActiveTreadmillEventRemote:FireClient(player, config._id, multiplier, nextAwardAt, mediaFeedState)
						end)
						if not ok then
							warn("[TreadmillGrindService] Failed firing ActiveTreadmillChanged (on) for " .. player.Name .. ": " .. tostring(err))
						end
					else
						local ok, err = pcall(function()
							ActiveTreadmillEventRemote:FireClient(player, nil)
						end)
						if not ok then
							warn("[TreadmillGrindService] Failed firing ActiveTreadmillChanged (off) for " .. player.Name .. ": " .. tostring(err))
						end
					end
				end

				if onTreadmill then
					local multiplier = (config and config.SpeedMultiplier) or 1
					local ok, gain = pcall(TreadmillUtil.ResolveSpeedPowerPerSecond, profile, multiplier)
					if not ok then
						warn("[TreadmillGrindService] ResolveSpeedPowerPerSecond failed for " .. player.Name .. " (no gain this tick): " .. tostring(gain))
					elseif type(gain) == "number" and gain > 0 then
						profile.SpeedPower = (profile.SpeedPower or 10) + gain * TICK_INTERVAL
						Database.Set(player, { SpeedPower = profile.SpeedPower })
						SpeedService.Refresh(player)
					end
				end
			end
		end
	end
end)

return TreadmillGrindService
