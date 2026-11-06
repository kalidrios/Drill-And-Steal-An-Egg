--[[
	DataService: Профили игроков, DataStore, Leaderstats, Replica
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local GroupService = game:GetService("GroupService")

local ReplicaService = require(ServerScriptService.Server.Modules.ReplicaService)

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GroupRewardRemote = Remotes:WaitForChild("Server"):WaitForChild("GroupReward")
local FavoriteItemRemote = Remotes:WaitForChild("Server"):WaitForChild("FavoriteItem")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")
local ShowOfflineEarningsRemote = Remotes:WaitForChild("Client"):WaitForChild("ShowOfflineEarnings")

local DEFAULT_PROFILE = {
	Cash = 0,
	Strength = 0,
	Rebirths = 0,
	Inventory = {},
	BackpackSize = 3,
	ExtraWalkSpeed = 0,
	EquippedPickaxeId = "Wood Pickaxe",
	Pickaxes = { "Wood Pickaxe" },
	Purchases = {
		CashMultiplier = 1,
		SlotUpgrades = 0,
		WalkspeedUpgrades = 0,
		Multiplier = 1,
	},
	TraitIndex = {},
	GroupRewardClaimed = false,
	InventoryIndex = {},
	LastOnline = 0,
	TutorialCompleted = false,
	TraitMachine = {
		StartedAt = 0,
		Duration = 0,
	},
	Auras = {},
	EquippedAuraId = "",
	WallsBroken = 0,
	RedeemedCodes = {},
	DailyRewardStreak = 0,
	DailyRewardLastClaim = 0,
	PlaytimeSeconds = 0,
	TotalPlaytime = 0,
	PlaytimeRewardsClaimed = {},
}

local DataService = {
	Profiles = {},
	_saving = {},
}


local function DeepCopy(original)
	if type(original) ~= "table" then return original end
	local copy = {}
	for k, v in pairs(original) do
		copy[DeepCopy(k)] = DeepCopy(v)
	end
	return copy
end

local function Reconcile(data, template)
	for key, defaultValue in pairs(template) do
		if data[key] == nil then
			data[key] = DeepCopy(defaultValue)
		elseif type(defaultValue) == "table" and type(data[key]) == "table" then
			Reconcile(data[key], defaultValue)
		end
	end
end

-- Константы для retry-логики DataStore
local DATASTORE_MAX_RETRIES = 3
local DATASTORE_RETRY_DELAY = 2 -- секунды между попытками

local function LoadPlayerData(player)
	if RunService:IsStudio() then
		return DeepCopy(DEFAULT_PROFILE)
	end
	local key = "Player_" .. player.UserId
	local result = nil
	local success = false
	local lastErr = nil

	-- Retry-логика: до 3 попыток с задержкой
	for attempt = 1, DATASTORE_MAX_RETRIES do
		success, lastErr = pcall(function()
			result = PlayerDataStore:GetAsync(key)
		end)
		if success then
			break
		end
		warn(("[DataService]: Load attempt %d/%d failed for %s: %s"):format(attempt, DATASTORE_MAX_RETRIES, player.Name, tostring(lastErr)))
		if attempt < DATASTORE_MAX_RETRIES then
			task.wait(DATASTORE_RETRY_DELAY * attempt) -- экспоненциальная задержка
		end
	end

	if not success then
		warn("[DataService]: All load attempts failed for", player.Name, lastErr)
		return nil
	end
	if result then
		Reconcile(result, DEFAULT_PROFILE)
		return result
	else
		return DeepCopy(DEFAULT_PROFILE)
	end
end

local function SavePlayerData(player)
	local profile = DataService.Profiles[player]
	if not profile then return end
	if DataService._saving[player] then return end
	if RunService:IsStudio() then return end
	DataService._saving[player] = true
	local key = "Player_" .. player.UserId
	local data = profile.Data
	data.LastOnline = os.time()

	-- Retry-логика: до 3 попыток с задержкой
	local success = false
	local lastErr = nil
	for attempt = 1, DATASTORE_MAX_RETRIES do
		success, lastErr = pcall(function()
			PlayerDataStore:SetAsync(key, data)
		end)
		if success then
			break
		end
		warn(("[DataService]: Save attempt %d/%d failed for %s: %s"):format(attempt, DATASTORE_MAX_RETRIES, player.Name, tostring(lastErr)))
		if attempt < DATASTORE_MAX_RETRIES then
			task.wait(DATASTORE_RETRY_DELAY * attempt)
		end
	end
	if not success then
		warn("[DataService]: All save attempts failed for", player.Name, lastErr)
	end
	DataService._saving[player] = nil
end

local function CreateLeaderstats(player, data)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	local coins = Instance.new("NumberValue")
	coins.Name = "Cash"
	coins.Value = data.Cash
	coins.Parent = leaderstats
	local strength = Instance.new("NumberValue")
	strength.Name = "Strength"
	strength.Value = data.Strength
	strength.Parent = leaderstats
	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Value = data.Rebirths
	rebirths.Parent = leaderstats
	local timeVal = Instance.new("StringValue")
	timeVal.Name = "Time"
	local Formatting = require(ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Formatting"))
	timeVal.Value = Formatting:FormatTime(data.TotalPlaytime or 0)
	timeVal.Parent = leaderstats
	leaderstats.Parent = player
	return leaderstats
end

function DataService.UpdateLeaderstats(player)
	local profile = DataService.Profiles[player]
	if not profile then return end
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	local coins = leaderstats:FindFirstChild("Cash")
	local strength = leaderstats:FindFirstChild("Strength")
	local rebirths = leaderstats:FindFirstChild("Rebirths")
	local timeVal = leaderstats:FindFirstChild("Time")
	if coins then coins.Value = profile.Data.Cash end
	if strength then strength.Value = profile.Data.Strength end
	if rebirths then rebirths.Value = profile.Data.Rebirths end
	if timeVal then
		local Formatting = require(ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Formatting"))
		timeVal.Value = Formatting:FormatTime(profile.Data.TotalPlaytime or 0)
	end
end

function DataService.UpdateInventoryCount(player)
	local profile = DataService.Profiles[player]
	if not profile then return end
	local count = DataService.GetInventoryCount(player)
	local dataFolder = player:FindFirstChild("data")
	if dataFolder then
		local storage = dataFolder:FindFirstChild("Storage")
		if storage then
			storage.Value = count
		end
	end
end

function DataService.GetProfile(player)
	return DataService.Profiles[player]
end

function DataService.GetReplica(player)
	local profile = DataService.Profiles[player]
	return profile and profile.Replica
end

function DataService.GetData(player)
	local profile = DataService.Profiles[player]
	return profile and profile.Data
end

function DataService.GetInventoryCount(player)
	local data = DataService.GetData(player)
	if not data then return 0 end
	local count = 0
	for _, item in pairs(data.Inventory) do
		if item.InBackpack then
			count += 1
		end
	end
	return count
end

local function ProcessOfflineEarnings(player, data)
	local lastOnline = data.LastOnline or 0
	if lastOnline <= 0 then return end
	local elapsed = os.time() - lastOnline
	if elapsed < 60 then return end
	elapsed = math.min(elapsed, 86400) -- максимум 24 часа

	-- Расчёт скорости дохода на основе кирки и множителей
	local PickaxeList = require(ReplicatedStorage.Databases.PickaxeList)
	local LevelsHelper = require(ReplicatedStorage.Helpers.LevelsHelper)
	local AurasList = require(ReplicatedStorage.Databases.AurasList)

	local pickaxeData = PickaxeList[data.EquippedPickaxeId]
	local pickaxeStrength = if pickaxeData then pickaxeData.Strength else 1
	local rebirthMultiplier = LevelsHelper:GetStrengthMultiplier(data.Rebirths)
	local purchaseMultiplier = data.Purchases.Multiplier or 1
	local auraConfig = AurasList[data.EquippedAuraId]
	local auraMultiplier = if auraConfig then auraConfig.Multiplier else 1

	-- Активная скорость Strength в секунду (примерно 2 клика/сек)
	local strengthPerSecond = math.floor(pickaxeStrength * rebirthMultiplier * purchaseMultiplier * auraMultiplier) * 2
	-- Офлайн-доход = 50% от активной скорости, ограничено сверху текущим Strength
	local strengthEarned = math.floor(elapsed * strengthPerSecond * 0.5)

	-- Cash: 50% от текущего Cash в час (пропорционально времени)
	local cashPerSecond = (data.Cash * 0.5) / 3600
	local cashEarned = math.floor(elapsed * cashPerSecond)

	-- Минимум 1, если игрок что-то заработал
	if strengthPerSecond > 0 and strengthEarned < 1 then strengthEarned = 1 end

	if strengthEarned > 0 then
		data.Strength = data.Strength + strengthEarned
	end
	if cashEarned > 0 then
		data.Cash = data.Cash + cashEarned
	end
	task.delay(3, function()
		if player.Parent and (strengthEarned > 0 or cashEarned > 0) then
			ShowOfflineEarningsRemote:FireClient(player, strengthEarned, cashEarned)
		end
	end)
end


function DataService.OnPlayerAdded(self, player)
	local data = LoadPlayerData(player)
	if not data then
		player:Kick("Failed to load your data. Please rejoin.")
		return
	end
	if not data.InventoryIndex then data.InventoryIndex = {} end
	if not data.TraitIndex then data.TraitIndex = {} end
	ProcessOfflineEarnings(player, data)
	local replica = ReplicaService.NewReplica({
		ClassToken = "Profile",
		Tags = { Player = player },
		Data = data,
		Replication = player,
	})
	local profile = { Data = data, Replica = replica }
	DataService.Profiles[player] = profile
	CreateLeaderstats(player, data)
	for _, item in pairs(data.Inventory) do
		if not table.find(data.InventoryIndex, item.ItemId) then
			replica:ArrayInsert({"InventoryIndex"}, item.ItemId)
		end
	end
	local dataFolder = Instance.new("Folder")
	dataFolder.Name = "data"
	local storage = Instance.new("IntValue")
	storage.Name = "Storage"
	storage.Value = DataService.GetInventoryCount(player)
	storage.Parent = dataFolder
	dataFolder.Parent = player
	print("[DataService]: Profile loaded for", player.Name)
end

function DataService.Start(self)
	local Analytics = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Analytics")
	local TutorialComplete = Analytics:WaitForChild("TutorialComplete")
	TutorialComplete.OnServerEvent:Connect(function(player)
		local profile = DataService.Profiles[player]
		if profile then profile.Replica:SetValue({"TutorialCompleted"}, true) end
	end)

	-- GroupReward: проверка членства в группе и выдача награды
	GroupRewardRemote.OnServerEvent:Connect(function(player)
		local profile = DataService.Profiles[player]
		if not profile then return end
		local data = profile.Data
		local replica = profile.Replica
		if data.GroupRewardClaimed then
			NotificationRemote:FireClient(player, "Already Claimed", "You have already claimed the group reward!")
			return
		end
		local inGroup = false
		local success = pcall(function() inGroup = player:IsInGroup(Config.GroupId) end)
		if not success then
			NotificationRemote:FireClient(player, "Error", "Failed to verify group membership. Try again.")
			return
		end
		if not inGroup then
			NotificationRemote:FireClient(player, "Not in Group", "Join our group first to claim the reward!")
			return
		end
		local reward = 5000
		replica:SetValue({"Cash"}, data.Cash + reward)
		replica:SetValue({"GroupRewardClaimed"}, true)
		DataService.UpdateLeaderstats(player)
		NotificationRemote:FireClient(player, "Group Reward!", "You received $" .. tostring(reward) .. " for being in the group!")
	end)


	-- FavoriteItem: toggle IsFavorited
	FavoriteItemRemote.OnServerEvent:Connect(function(player, uniqueId)
		if type(uniqueId) ~= "string" then return end
		local profile = DataService.Profiles[player]
		if not profile then return end
		local item = profile.Data.Inventory[uniqueId]
		if not item then return end
		local newFavorited = not item.IsFavorited
		profile.Replica:SetValue({"Inventory", uniqueId, "IsFavorited"}, newFavorited)
	end)

	Players.PlayerRemoving:Connect(function(player)
		SavePlayerData(player)
		local profile = DataService.Profiles[player]
		if profile then
			if profile.Replica then profile.Replica:Destroy() end
			DataService.Profiles[player] = nil
		end
	end)

	game:BindToClose(function()
		for _, player in ipairs(Players:GetPlayers()) do
			task.spawn(SavePlayerData, player)
		end
		if not RunService:IsStudio() then task.wait(3) end
	end)

	-- Автосохранение каждые 120 секунд
	task.spawn(function()
		while true do
			task.wait(120)
			for _, player in ipairs(Players:GetPlayers()) do
				task.spawn(SavePlayerData, player)
			end
		end
	end)

	print("[DataService]: Started")
end

return DataService