-- ServerScriptService.Controllers.AssetService
-- Owns profile.Inventory (hatched pets, AssetItemData shape from EggItemUtil.BuildAssetItemData)
-- and profile.EquippedAssets (uids currently "out" following the player). Contract confirmed
-- by reading ReplicatedStorage.Library.Client.AssetCmds in full:
--   ActiveAssets: RequestEquip(uid) -> (ok, extra?, err?)
--   ActiveAssets: RequestUnequip(uid) -> (ok, err?)
--   ActiveAssets: RequestEquipLimit() -> number
--   ActiveAssets: RequestRuntimeSnapshot() -> array<{OwnerUserId, Records}>
-- and ReplicatedStorage.Library.Types.AssetRuntime (STRICT schema -- no extra fields allowed):
--   RuntimeAssetRecord = {OwnerUserId, UID, ItemData, MoneyPerSecond, Seed, IsFirstPlacement?}
-- The client already renders/animates equipped pets purely from this broadcast data (confirmed
-- in AssetCmds -- it just materializes records into a snapshot signal, no server-side pet AI
-- needed). MoneyPerSecond per pet comes from ReplicatedStorage.Directory.Assets[Category].EarningRate.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)
local Assets = require(ReplicatedStorage.Directory.Assets)
local GetPriceValueForItem = require(ReplicatedStorage.Library.Util.GetPriceValueForItem)
local PlayerMoneyPerSecondUtil = require(ReplicatedStorage.Library.Util.PlayerMoneyPerSecondUtil)
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil)
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization)

local Network = ReplicatedStorage:WaitForChild("Network")
local RequestEquipRemote = Network:WaitForChild("ActiveAssets: RequestEquip")
local RequestUnequipRemote = Network:WaitForChild("ActiveAssets: RequestUnequip")
local RequestEquipLimitRemote = Network:WaitForChild("ActiveAssets: RequestEquipLimit")
local RequestSellRemote = Network:WaitForChild("ActiveAssets: RequestSell")
local RequestRuntimeSnapshotRemote = Network:WaitForChild("ActiveAssets: RequestRuntimeSnapshot")
local RuntimeOwnerUpdatedRemote = Network:WaitForChild("ActiveAssets: RuntimeOwnerUpdated")
local RuntimeOwnerClearedRemote = Network:WaitForChild("ActiveAssets: RuntimeOwnerCleared")
local MoneyCollectedRemote = Network:WaitForChild("ActiveAssets: MoneyCollected")

local SellAssetRemote = Network:WaitForChild("AssetInventory: SellAsset")
local SellAllAssetsRemote = Network:WaitForChild("AssetInventory: SellAllAssets")
local SetFavoriteRemote = Network:WaitForChild("AssetInventory: SetFavorite")

-- FEATURE (user request: "arregla mas bugs" -- found via the same "client fully built, server
-- stubbed FAIL" pattern as everything else in this project). Contract confirmed by reading
-- StarterPlayer...GUI.PetList.requestEquipBest (Backpack.EQUIP_BEST -> (ok, err?), no args) and
-- BackpackController.Main.requestEquipBestStatusRefresh (Backpack.GET_EQUIP_BEST_STATUS ->
-- {wouldChange: boolean} -- only element [1] is ever read). Non-monetary, self-contained --
-- unlike ActiveAssets: RequestStealTarget (real money, needs a whole ServerScriptService.
-- Controllers.AssetDnaStealService + FFlags.Purchases gate, deliberately NOT attempted here)
-- and OfflineAssets (also real but bigger, has its own Robux multiplier upsell path) -- both
-- left stubbed, documented for the user instead of guessed at blind.
local EquipBestRemote = Network:WaitForChild("Backpack: EquipBest")
local GetEquipBestStatusRemote = Network:WaitForChild("Backpack: GetEquipBestStatus")

-- FEATURE 2 (same request: "arregla mas bugs seguros"). profile.AutoSellRarities ALREADY existed
-- in the schema (DefaultStats/Database/SchemaFields.lua: t.map(t.string, t.boolean)) and the
-- entire client tab was already built (BackpackController.Main: buildAutoSellSlots/
-- serializeAutoSellState/initializeAutoSellUI) -- only the server side was missing (StubService
-- FAIL_ONLY). Contract confirmed by reading Main directly: SetAutoSellState's payload is the
-- FULL desired {[rarityId]: true} map (not a delta), reply is {ok: boolean, mapOrErrorString};
-- GetAutoSellState reply is {map}. Rarity ids come from Assets.Directory[category].Rarity._id,
-- same field buildAutoSellSlots reads client-side to build the rarity toggle list.
local GetAutoSellStateRemote = Network:WaitForChild("Backpack: GetAutoSellState")
local SetAutoSellStateRemote = Network:WaitForChild("Backpack: SetAutoSellState")

-- Same tiers as PlotService.BASE_TIERS (copied literally from ReplicatedStorage.Directory.Bases,
-- which still can't be require()'d -- see PlotService for why).
local BASE_MAX_ASSETS = {
	[0] = 7, [1] = 7, [2] = 9, [3] = 10, [4] = 11, [5] = 12,
	[6] = 13, [7] = 14, [8] = 15, [9] = 16, [10] = 17, [11] = 18,
}

local AssetService = {}
local lastEquipBestAt = {}

local function equipCapacity(profile)
	return BASE_MAX_ASSETS[profile.BaseUpgradeLevel or 0] or BASE_MAX_ASSETS[0]
end

-- Per-pet $/sec, using the game's own rate formula (factors in scale, rebirth, gamepasses,
-- products -- confirmed by reading ReplicatedStorage.Library.Util.PlayerMoneyPerSecondUtil,
-- which calls this same AssetGenerationUtil.GetRate per equipped item).
local function earningRateFor(profile, itemData)
	local ok, deserialized = pcall(AssetItemSerialization.Deserialize, itemData)
	if not ok then
		warn("[AssetService] AssetItemSerialization.Deserialize failed for " .. tostring(itemData and itemData.Category) .. " (rate=0): " .. tostring(deserialized))
		return 0
	end
	local ok2, rate = pcall(
		AssetGenerationUtil.GetRate,
		deserialized,
		profile.Rebirth or 0,
		profile.Gamepasses or {},
		profile.Products or {}
	)
	if not ok2 then
		warn("[AssetService] AssetGenerationUtil.GetRate failed for " .. tostring(itemData and itemData.Category) .. " (rate=0): " .. tostring(rate))
		return 0
	end
	if type(rate) ~= "number" then
		warn("[AssetService] AssetGenerationUtil.GetRate returned non-number for " .. tostring(itemData and itemData.Category) .. ": " .. tostring(rate))
		return 0
	end
	return math.max(rate, 0)
end

-- Exported for OfflineAssetsService, which needs this exact same per-pet formula to value how
-- much a player's currently-equipped pets earned while they were away.
AssetService.EarningRateFor = earningRateFor

-- Ranks every owned pet by the game's own $/sec formula (same one the pen tick and the client
-- preview both already use) and picks the top `equipCapacity(profile)` of them by uid.
local function computeBestSelection(profile)
	local candidates = {}
	for uid, itemData in pairs(profile.Inventory) do
		table.insert(candidates, { uid = uid, rate = earningRateFor(profile, itemData) })
	end
	table.sort(candidates, function(a, b)
		return a.rate > b.rate
	end)
	local capacity = equipCapacity(profile)
	local selected = {}
	for i = 1, math.min(capacity, #candidates) do
		table.insert(selected, candidates[i].uid)
	end
	return selected
end

-- Set-equality (order doesn't matter) -- used to answer "would pressing Equip Best actually
-- change anything right now" for the status/badge check.
local function sameAssetSelection(a, b)
	if #a ~= #b then
		return false
	end
	local bSet = {}
	for _, uid in ipairs(b) do
		bSet[uid] = true
	end
	for _, uid in ipairs(a) do
		if not bSet[uid] then
			return false
		end
	end
	return true
end

local function buildRuntimeRecords(player, profile)
	local records = {}
	local any = false
	for _, uid in ipairs(profile.EquippedAssets) do
		local itemData = profile.Inventory[uid]
		if itemData then
			local clone = table.clone(itemData)
			clone.Mutations = itemData.Mutations and table.clone(itemData.Mutations) or {}
			records[uid] = {
				OwnerUserId = player.UserId,
				UID = uid,
				ItemData = clone,
				MoneyPerSecond = earningRateFor(profile, itemData),
				Seed = itemData.ColorSeed or 0,
				IsFirstPlacement = false,
			}
			any = true
		end
	end
	return records, any
end

local function broadcastOwner(player)
	local profile = Database.Get(player)
	if not profile then
		return
	end
	local records, any = buildRuntimeRecords(player, profile)
	if any then
		RuntimeOwnerUpdatedRemote:FireAllClients({ OwnerUserId = player.UserId, Records = records })
	else
		RuntimeOwnerClearedRemote:FireAllClients({ OwnerUserId = player.UserId })
	end
end

local function removeFromEquipped(profile, uid)
	for i, existing in ipairs(profile.EquippedAssets) do
		if existing == uid then
			table.remove(profile.EquippedAssets, i)
			return true
		end
	end
	return false
end

Database.OnLoaded(function(player)
	-- Nothing to seed; Inventory/EquippedAssets already default to {} in DefaultStats.
end)

Players.PlayerRemoving:Connect(function(player)
	RuntimeOwnerClearedRemote:FireAllClients({ OwnerUserId = player.UserId })
	lastEquipBestAt[player] = nil
end)

-- BUG FIX (user report 2026-09-03: "when placing down like a pet, it bugs and still has it
-- on ur hands, for other players"): AssetToolEquipController on the client destroys the Tool
-- locally after a successful equip, but that Destroy() only removes the Tool from the local
-- viewer -- if the Tool was created by any code path that puts it into the player's
-- Character/Backpack server-side (BackpackController's replicated slot builders,
-- server-side inventory sync, etc), the Tool stays parented server-side and every OTHER
-- client keeps seeing it welded to the character. This runs server-side inside the same
-- equip handler that added the pet to EquippedAssets, and destroys any Tool whose UID
-- attribute matches the just-equipped pet, wherever it currently lives (Character while
-- equipped, or Backpack if it was un-equipped between requests). Because the destroy
-- happens on the server, it replicates to every client.
local function destroyPetToolsWithUid(player, uid)
	if type(uid) ~= "string" then return end
	for _, container in ipairs({ player:FindFirstChild("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("ItemType") == "Asset" and child:GetAttribute("UID") == uid then
					child:Destroy()
				end
			end
		end
	end
end

RequestEquipRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	if not profile then
		return false, nil, "Profile not loaded"
	end
	if type(uid) ~= "string" then
		return false, nil, "Invalid pet"
	end
	local itemData = profile.Inventory[uid]
	if not itemData then
		return false, nil, "Pet not found"
	end
	for _, existing in ipairs(profile.EquippedAssets) do
		if existing == uid then
			-- Already equipped -- still make sure no lingering Tool is hanging on the character.
			destroyPetToolsWithUid(player, uid)
			return true, nil, nil
		end
	end
	if #profile.EquippedAssets >= equipCapacity(profile) then
		return false, nil, "Pet pen is full"
	end
	table.insert(profile.EquippedAssets, uid)
	Database.Set(player, { EquippedAssets = profile.EquippedAssets })
	broadcastOwner(player)
	destroyPetToolsWithUid(player, uid)
	return true, nil, nil
end

RequestUnequipRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end
	if type(uid) ~= "string" then
		return false, "Invalid pet"
	end
	if removeFromEquipped(profile, uid) then
		Database.Set(player, { EquippedAssets = profile.EquippedAssets })
		broadcastOwner(player)

		if profile.Inventory[uid] == nil then
			warn("[AssetService] Unequipped pet was missing from Inventory: " .. tostring(uid))
		end

		-- BUG FIX (user report: "el unequip al darle a una pet no te devuelve la pet, esta mal"):
		-- this only ever removed the pet from EquippedAssets (the pet correctly leaves the plot)
		-- but never gave the player back a physical Tool for it -- that only happens today via
		-- populateAssetBackpack, wired to CharacterAdded, so the pet just vanished until your
		-- next respawn. Same bug class already fixed once for AmonetizationPurchaseService's
		-- podium purchases (see EggService.GrantAssetTool's own comment) -- this call site was
		-- just missed. Required lazily (not at module top) because EggService requires
		-- AssetService itself -- a top-level require here would be a circular require and error.
		local itemData = profile.Inventory[uid]
		if itemData then
			local ok, EggService = pcall(require, game.ServerScriptService.Controllers.EggService)
			if ok and EggService.GrantAssetToolWithRetry then
				task.spawn(EggService.GrantAssetToolWithRetry, player, uid, itemData)
			elseif ok and EggService.GrantAssetTool then
				local granted = EggService.GrantAssetTool(player, uid, itemData)
				if not granted then
					warn("[AssetService] Failed to return pet to Backpack after unequip: " .. tostring(uid))
				end
			elseif not ok then
				warn("[AssetService] Failed to load EggService for unequip: " .. tostring(EggService))
			end
		end
	end
	return true, nil
end

RequestEquipLimitRemote.OnServerInvoke = function(player)
	local profile = Database.Get(player)
	if not profile then
		return 0
	end
	return equipCapacity(profile)
end

EquipBestRemote.OnServerInvoke = function(player)
	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end
	local now = os.clock()
	if lastEquipBestAt[player] and now - lastEquipBestAt[player] < 5.0 then
		return false, "Please wait a bit before equipping bests again!"
	end
	lastEquipBestAt[player] = now
	profile.EquippedAssets = computeBestSelection(profile)
	Database.Set(player, { EquippedAssets = profile.EquippedAssets })
	broadcastOwner(player)
	return true
end

GetEquipBestStatusRemote.OnServerInvoke = function(player)
	local profile = Database.Get(player)
	if not profile then
		return { false }
	end
	return { not sameAssetSelection(computeBestSelection(profile), profile.EquippedAssets) }
end

RequestRuntimeSnapshotRemote.OnServerInvoke = function(_player)
	local snapshot = {}
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		local profile = Database.Get(otherPlayer)
		if profile then
			local records, any = buildRuntimeRecords(otherPlayer, profile)
			if any then
				table.insert(snapshot, { OwnerUserId = otherPlayer.UserId, Records = records })
			end
		end
	end
	return snapshot
end

local function sellOne(player, profile, uid)
	local itemData = profile.Inventory[uid]
	if not itemData then
		return 0
	end
	local ok, price = pcall(GetPriceValueForItem, itemData)
	if not ok then
		warn("[AssetService] GetPriceValueForItem failed for " .. tostring(itemData.Category) .. " (selling for 0): " .. tostring(price))
		price = 0
	end
	-- 🟡 MODDED REBALANCE (user: "okey x1.33" -- sell price). Was 0.8x (80% of value); now pays
	-- OUT more than the pet's own listed value.
	local sellPrice = math.floor((price or 0) * 1.33)
	profile.Inventory[uid] = nil
	removeFromEquipped(profile, uid)
	return sellPrice
end

local function rarityIdForItem(itemData)
	local config = itemData and Assets.Directory[itemData.Category]
	local rarity = config and config.Rarity
	return rarity and rarity._id
end

-- Called by EggService right after granting a hatched pet, so a rarity the player has toggled
-- on in the AutoSell tab gets sold the instant it's granted instead of sitting in Inventory.
-- Mirrors sellOne's contract -- does NOT touch profile.Money, the caller adds the returned price.
function AssetService.MaybeAutoSell(player, profile, uid)
	local itemData = profile.Inventory[uid]
	if not itemData then
		return false, 0
	end
	local rarities = profile.AutoSellRarities
	if type(rarities) ~= "table" then
		return false, 0
	end
	local rarityId = rarityIdForItem(itemData)
	if not rarityId or not rarities[rarityId] then
		return false, 0
	end
	local sellPrice = sellOne(player, profile, uid)
	return true, sellPrice
end

GetAutoSellStateRemote.OnServerInvoke = function(player)
	local profile = Database.Get(player)
	if not profile then
		return { {} }
	end
	return { profile.AutoSellRarities or {} }
end

SetAutoSellStateRemote.OnServerInvoke = function(player, desiredMap)
	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end
	if type(desiredMap) ~= "table" then
		return false, "Invalid request"
	end

	-- Validate against real rarity ids (same source of truth the client UI itself is built
	-- from) instead of trusting the client payload's keys blindly.
	local validRarities = {}
	for _, config in pairs(Assets.Directory) do
		local rarity = config.Rarity
		if rarity and type(rarity._id) == "string" then
			validRarities[rarity._id] = true
		end
	end

	local cleaned = {}
	for k, v in pairs(desiredMap) do
		if v == true and type(k) == "string" and validRarities[k] then
			cleaned[k] = true
		end
	end

	profile.AutoSellRarities = cleaned
	Database.Set(player, { AutoSellRarities = cleaned })
	return true, cleaned
end

RequestSellRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end
	if type(uid) ~= "string" or not profile.Inventory[uid] then
		return false, "Pet not found"
	end
	local sellPrice = sellOne(player, profile, uid)
	Database.SetAndBroadcast(player, {
		Money = (profile.Money or 0) + sellPrice,
		Inventory = profile.Inventory,
		EquippedAssets = profile.EquippedAssets,
	})
	broadcastOwner(player)
	return true, nil
end

SellAssetRemote.OnServerEvent:Connect(function(player, uid)
	local profile = Database.Get(player)
	if not profile or type(uid) ~= "string" or not profile.Inventory[uid] then
		return
	end
	local sellPrice = sellOne(player, profile, uid)
	Database.SetAndBroadcast(player, {
		Money = (profile.Money or 0) + sellPrice,
		Inventory = profile.Inventory,
		EquippedAssets = profile.EquippedAssets,
	})
	broadcastOwner(player)
end)

SellAllAssetsRemote.OnServerEvent:Connect(function(player)
	local profile = Database.Get(player)
	if not profile then
		return
	end
	local total = 0
	local uids = {}
	for uid in pairs(profile.Inventory) do
		table.insert(uids, uid)
	end
	for _, uid in ipairs(uids) do
		total += sellOne(player, profile, uid)
	end
	if total > 0 then
		Database.SetAndBroadcast(player, {
			Money = (profile.Money or 0) + total,
			Inventory = profile.Inventory,
			EquippedAssets = profile.EquippedAssets,
		})
		broadcastOwner(player)
	end
end)

SetFavoriteRemote.OnServerEvent:Connect(function(player, uid, favorite)
	local profile = Database.Get(player)
	if not profile or type(uid) ~= "string" then
		return
	end
	profile.FavoriteAssets = profile.FavoriteAssets or {}
	profile.FavoriteAssets[uid] = favorite and true or nil
	Database.Set(player, { FavoriteAssets = profile.FavoriteAssets })
end)

-- Money-per-second income from equipped pets, using the game's own total formula.
-- BUG FIX (user report: constant spam every ~1s in the log -- "MoneyUpdate:346: invalid
-- argument #1 to 'ipairs' (table expected, got number)" AND the identical error in
-- ActiveAssetsController:307, both on the SAME remote "ActiveAssets: MoneyCollected"). Root
-- cause: this loop fired that remote with a raw number (`total`), but BOTH client listeners do
-- `for _, v in ipairs(payload) do local uid = v.uid ... end` -- they need an ARRAY of
-- {uid, amount} records (one per equipped pet that earned that tick), not a lump sum. Switched
-- to earningRateFor (already used by EquipBest/computeBestSelection above, itself confirmed to
-- match PlayerMoneyPerSecondUtil.GetTotalForProfile's own per-item formula) to build that array
-- and sum it for the same total instead.
task.spawn(function()
	while true do
		task.wait(1)
		for _, player in ipairs(Players:GetPlayers()) do
			local profile = Database.Get(player)
			if profile and #profile.EquippedAssets > 0 then
				local records = {}
				local total = 0
				for _, uid in ipairs(profile.EquippedAssets) do
					local itemData = profile.Inventory[uid]
					if itemData then
						local rate = earningRateFor(profile, itemData)
						if rate > 0 then
							total += rate
							table.insert(records, { uid = uid, amount = rate })
						end
					end
				end
				if total > 0 then
					Database.Set(player, { Money = (profile.Money or 0) + total })
					MoneyCollectedRemote:FireClient(player, records)
				end
			end
		end
	end
end)

return AssetService
