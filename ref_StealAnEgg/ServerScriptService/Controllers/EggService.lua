-- ServerScriptService.Controllers.EggService
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil)
local Assets = require(ReplicatedStorage.Directory.Assets)
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay)
local AssetService = require(script.Parent.AssetService)

local Network = ReplicatedStorage:WaitForChild("Network")
local RequestRuntimeSnapshotRemote = Network:WaitForChild("Eggs: RequestRuntimeSnapshot")
local RequestEggRecordRemote = Network:WaitForChild("Eggs: RequestEggRecord")
local RequestEquipToolRemote = Network:WaitForChild("Eggs: RequestEquipTool")
local RequestUnequipToolRemote = Network:WaitForChild("Eggs: RequestUnequipTool")
local RequestPlaceEggRemote = Network:WaitForChild("Eggs: RequestPlaceEgg")
local RequestSkipGrowthRemote = Network:WaitForChild("Eggs: RequestSkipGrowth")
local RequestHatchEggRemote = Network:WaitForChild("Eggs: RequestHatchEgg")
local RequestCompleteHatchEggRemote = Network:WaitForChild("Eggs: RequestCompleteHatchEgg")
local RuntimeOwnerUpdatedRemote = Network:WaitForChild("Eggs: RuntimeOwnerUpdated")
local RuntimeOwnerClearedRemote = Network:WaitForChild("Eggs: RuntimeOwnerCleared")
local RequestAreaEggSnapshotRemote = Network:WaitForChild("Eggs: RequestAreaEggSnapshot")
local RequestAreaEggRareSpawnPresentationsRemote = Network:WaitForChild("Eggs: RequestAreaEggRareSpawnPresentations")

local EggService = {}
local uidCounter = 0
local function newUid(prefix)
	uidCounter += 1
	return string.format("%s_%d_%d", prefix, os.time(), uidCounter)
end
EggService.NewUid = newUid

function EggService.RollNewEgg(category)
	return EggItemUtil.BuildSavedEgg(category)
end

local function toRuntimeRecord(egg, growthSpeedMultiplier)
	local placement = nil
	if egg.Placement then
		placement = {
			LocalCFrame = CFrame.new(table.unpack(egg.Placement.LocalCFrame)),
			PlacedAt = egg.Placement.PlacedAt,
			GrowthDuration = egg.Placement.GrowthDuration,
			GrowthCreditSeconds = egg.Placement.GrowthCreditSeconds,
			NightGrowthPeriodIndex = egg.Placement.NightGrowthPeriodIndex,
			NightGrowthCreditSeconds = egg.Placement.NightGrowthCreditSeconds,
			ReadyAt = egg.Placement.ReadyAt,
		}
	end
	return {
		AssetCategory = egg.AssetCategory,
		AssetScale = egg.AssetScale,
		AssetEyeColor = egg.AssetEyeColor,
		AssetColorSeed = egg.AssetColorSeed,
		AssetColorIndex = egg.AssetColorIndex,
		Mutations = egg.Mutations,
		BaseMutation = egg.BaseMutation,
		AssetGender = egg.AssetGender,
		AssetPersonality = egg.AssetPersonality,
		IsStolenDNA = egg.IsStolenDNA,
		Placement = placement,
		GrowthSpeedMultiplier = growthSpeedMultiplier or 1,
	}
end

local function growthSpeedMultiplierFor(player)
	local ok, mult = pcall(EggItemUtil.GetGrowthSpeedMultiplier, player:GetAttribute("MonetizationX2GrowthGamepassOwned") == true)
	return ok and mult or 1
end

local function placedRecordsFor(profile, growthSpeedMultiplier)
	local records = {}
	local any = false
	for uid, egg in pairs(profile.EggInventory) do
		if egg.Placement then
			records[uid] = toRuntimeRecord(egg, growthSpeedMultiplier)
			any = true
		end
	end
	return records, any
end

local function broadcastOwnerRecords(player)
	local profile = Database.Get(player)
	if not profile then return end
	local records, any = placedRecordsFor(profile, growthSpeedMultiplierFor(player))
	if any then
		RuntimeOwnerUpdatedRemote:FireAllClients({ OwnerUserId = player.UserId, Records = records })
	else
		RuntimeOwnerClearedRemote:FireAllClients({ OwnerUserId = player.UserId })
	end
end
EggService.BroadcastOwnerRecords = broadcastOwnerRecords

local function destroyExistingEggTool(player)
	for _, container in ipairs({ player:FindFirstChild("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
					child:Destroy()
				end
			end
		end
	end
end

local function grantEggTool(player, uid, egg)
	local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack then return false end
	destroyExistingEggTool(player)
	local tool = Instance.new("Tool")
	tool.Name = (egg.AssetCategory or "Egg") .. " Egg"
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 1, 1)
	handle.Transparency = 1
	handle.CanCollide = false
	handle.Massless = true
	handle.Parent = tool
	tool:SetAttribute("ItemType", "AssetEgg")
	tool:SetAttribute("UID", uid)
	tool:SetAttribute("Category", egg.AssetCategory)
	tool.Parent = backpack
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid:EquipTool(tool) end
	return true
end
EggService.GrantEggTool = grantEggTool

local function withPlacementForMath(egg)
	local clone = table.clone(egg)
	clone.Placement = table.clone(egg.Placement)
	clone.Placement.LocalCFrame = CFrame.new(table.unpack(egg.Placement.LocalCFrame))
	return clone
end

local function isReady(egg, now, growthSpeedMultiplier)
	if not egg.Placement then return false end
	if egg.Placement.ReadyAt ~= nil then return true end
	local ok, ready = pcall(function()
		local record = withPlacementForMath(egg)
		local nightCredit = EggItemUtil.GetCurrentNightGrowthCreditSeconds(record, now, growthSpeedMultiplier or 1)
		return EggItemUtil.IsGrowthReady(record, now, growthSpeedMultiplier or 1, nightCredit)
	end)
	return ok and ready or false
end

function EggService.GrantEgg(player, category)
	local profile = Database.Get(player)
	if not profile then return nil end
	local ok, egg = pcall(EggItemUtil.BuildSavedEgg, category)
	if not ok then return nil end
	local uid = newUid("Egg")
	profile.EggInventory[uid] = egg
	Database.Set(player, { EggInventory = profile.EggInventory })
	return uid
end

Players.PlayerRemoving:Connect(function(player)
	RuntimeOwnerClearedRemote:FireAllClients({ OwnerUserId = player.UserId })
end)

RequestRuntimeSnapshotRemote.OnServerInvoke = function()
	local snapshot = {}
	for _, player in ipairs(Players:GetPlayers()) do
		local profile = Database.Get(player)
		if profile then
			local records, any = placedRecordsFor(profile, growthSpeedMultiplierFor(player))
			if any then table.insert(snapshot, { OwnerUserId = player.UserId, Records = records }) end
		end
	end
	return snapshot
end

RequestEggRecordRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	local egg = profile and type(uid) == "string" and profile.EggInventory[uid]
	return egg and toRuntimeRecord(egg, growthSpeedMultiplierFor(player)) or nil
end

RequestEquipToolRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	if not profile then return false, "Profile not loaded" end
	if type(uid) ~= "string" then return false, "Invalid egg" end
	local egg = profile.EggInventory[uid]
	if not egg then return false, "Egg not found" end
	if egg.Placement then return false, "Egg is already placed" end
	if not grantEggTool(player, uid, egg) then return false, "No backpack" end
	return true
end

RequestUnequipToolRemote.OnServerInvoke = function(player)
	destroyExistingEggTool(player)
	return true
end

RequestPlaceEggRemote.OnServerInvoke = function(player, args)
	local profile = Database.Get(player)
	if not profile then return false, "Profile not loaded" end
	if type(args) ~= "table" or type(args.Uid) ~= "string" or typeof(args.LocalCFrame) ~= "CFrame" then return false, "Invalid request" end
	local egg = profile.EggInventory[args.Uid]
	if not egg then return false, "Egg not found" end
	if egg.Placement then return false, "Already placed" end
	egg.Placement = { LocalCFrame = { args.LocalCFrame:GetComponents() }, PlacedAt = os.time(), GrowthDuration = 50, ReadyAt = nil }
	destroyExistingEggTool(player)
	Database.Set(player, { EggInventory = profile.EggInventory })
	broadcastOwnerRecords(player)
	return true
end

RequestSkipGrowthRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	local egg = profile and type(uid) == "string" and profile.EggInventory[uid]
	if not egg or not egg.Placement then return false, "Egg not placed" end
	egg.Placement.ReadyAt = os.time()
	Database.Set(player, { EggInventory = profile.EggInventory })
	broadcastOwnerRecords(player)
	return true
end

RequestHatchEggRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	local egg = profile and type(uid) == "string" and profile.EggInventory[uid]
	if not egg or not egg.Placement then return false, "Egg not placed" end
	return isReady(egg, os.time(), growthSpeedMultiplierFor(player)) and true or false, "Egg is not ready yet"
end

local function findExistingAssetTool(player, uid)
	for _, container in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("UID") == uid then return child end
			end
		end
	end
	return nil
end

local function grantAssetTool(player, uid, itemData)
	local existing = findExistingAssetTool(player, uid)
	local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack then
		warn("[EggService] Backpack unavailable while returning pet " .. tostring(uid))
		return false
	end
	if existing then
		if existing.Parent == player.Character then
			existing.Parent = backpack
		end
		return true
	end
	local ok, err = pcall(ItemDisplay.CreateTool, itemData, uid, player)
	if not ok then
		warn("[EggService] ItemDisplay.CreateTool failed for " .. tostring(uid) .. ": " .. tostring(err))
		return false
	end
	return findExistingAssetTool(player, uid) ~= nil
end
EggService.GrantAssetTool = grantAssetTool

local function grantAssetToolWithRetry(player, uid, itemData)
	for attempt = 1, 3 do
		if grantAssetTool(player, uid, itemData) then
			return true
		end
		if attempt < 3 then
			task.wait(0.15)
		end
	end
	warn("[EggService] Could not return pet to Backpack after retries: " .. tostring(uid))
	return false
end
EggService.GrantAssetToolWithRetry = grantAssetToolWithRetry
EggService.GrantAssetTool = grantAssetTool

local function populateAssetBackpack(player)
	local profile = Database.Get(player)
	if not profile or not profile.Inventory then return end
	local backpack = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack then return end
	for uid, itemData in pairs(profile.Inventory) do grantAssetTool(player, uid, itemData) end
end

Database.OnLoaded(function(player)
	task.defer(populateAssetBackpack, player)
end)
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.defer(populateAssetBackpack, player)
	end)
end)
for _, player in ipairs(Players:GetPlayers()) do
	player.CharacterAdded:Connect(function() task.defer(populateAssetBackpack, player) end)
	if player.Character then task.defer(populateAssetBackpack, player) end
end

RequestCompleteHatchEggRemote.OnServerInvoke = function(player, uid)
	local profile = Database.Get(player)
	local egg = profile and type(uid) == "string" and profile.EggInventory[uid]
	if not egg or not egg.Placement then return false, "Egg not placed" end
	if not isReady(egg, os.time(), growthSpeedMultiplierFor(player)) then return false, "Egg is not ready yet" end
	local ok, itemData = pcall(EggItemUtil.BuildAssetItemData, withPlacementForMath(egg))
	if not ok then warn("[EggService] BuildAssetItemData failed: " .. tostring(itemData)); return false, "Failed to hatch" end
	local petUid = newUid("Pet")
	profile.Inventory[petUid] = itemData
	profile.EggInventory[uid] = nil
	local autoSold, autoSellPrice = AssetService.MaybeAutoSell(player, profile, petUid)
	if autoSold then profile.Money = (profile.Money or 0) + autoSellPrice end
	profile.HasPlacedFirstEgg = true
	profile.Index[egg.AssetCategory] = true
	if not autoSold then task.spawn(grantAssetTool, player, petUid, itemData) end
	Database.SetAndBroadcast(player, { EggInventory = profile.EggInventory, Inventory = profile.Inventory, Money = profile.Money, HasPlacedFirstEgg = true, Index = profile.Index })
	broadcastOwnerRecords(player)
	return true, nil, petUid
end

RequestAreaEggSnapshotRemote.OnServerInvoke = function() return { Records = {}, ServerTime = os.time() } end
RequestAreaEggRareSpawnPresentationsRemote.OnServerInvoke = function() return true, {} end

return EggService