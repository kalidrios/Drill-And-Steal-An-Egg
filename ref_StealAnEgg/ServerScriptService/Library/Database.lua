local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local Network = ReplicatedStorage:WaitForChild("Network")
local statsRemote = Network:FindFirstChild("New Stats")
local profileStore = DataStoreService:GetDataStore("PlayerProfiles_v3")

local Database = {}
local profiles = {}
local loadedProfiles = {}
local loadingProfiles = {}
local savingProfiles = {}
local loadedCallbacks = {}
local fieldCallbacks = {}

local defaults = {
	Money = 0,
	Rebirth = 0,
	SpeedPower = 10,
	EggInventory = {},
	Inventory = {},
	EquippedAssets = {},
	FusionSlots = {},
	AutoSellRarities = {},
	BaseUpgradeLevel = 0,
	TreadmillUpgradeLevel = 1,
	Gamepasses = {},
	Products = {},
	Settings = {},
	Index = {},
	FavoriteAssets = {},
	PlacedAssets = {},
}

local function cloneValue(value)
	if type(value) ~= "table" then
		return value
	end
	local result = {}
	for key, nested in pairs(value) do
		result[key] = cloneValue(nested)
	end
	return result
end

local function mergeDefaults(saved, template)
	local result = {}
	if type(saved) == "table" then
		for key, value in pairs(saved) do
			if type(value) == "table" then
				result[key] = cloneValue(value)
			elseif type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
				result[key] = value
			end
		end
	end
	for key, value in pairs(template) do
		if result[key] == nil then
			result[key] = cloneValue(value)
		end
	end
	result.BaseUpgradeLevel = math.max(0, math.floor(tonumber(result.BaseUpgradeLevel) or 0))
	result.TreadmillUpgradeLevel = math.max(1, math.floor(tonumber(result.TreadmillUpgradeLevel) or 1))
	return result
end

local function fireLoaded(player, profile)
	if loadedProfiles[player] then
		return
	end
	loadedProfiles[player] = true
	if statsRemote then
		statsRemote:FireClient(player, profile)
	end
	for _, callback in ipairs(loadedCallbacks) do
		task.spawn(callback, player, profile)
	end
end

local function loadProfile(player)
	if loadingProfiles[player] or loadedProfiles[player] or not player.Parent then
		return
	end
	loadingProfiles[player] = true
	local key = "Player_" .. tostring(player.UserId)
	local success, saved = false, nil
	for attempt = 1, 3 do
		success, saved = pcall(function()
			return profileStore:GetAsync(key)
		end)
		if success then
			break
		end
		warn("[Database] Load attempt " .. tostring(attempt) .. " failed for " .. player.Name .. ": " .. tostring(saved))
		task.wait(attempt)
	end
	loadingProfiles[player] = nil
	if not player.Parent then
		return
	end
	if not success then
		warn("[Database] Profile for " .. player.Name .. " was not loaded; refusing to create/save a default profile")
		return
	end
	profiles[player] = mergeDefaults(saved, defaults)
	fireLoaded(player, profiles[player])
	print("[Database] Loaded profile for " .. player.Name)
end

local function serializable(value)
	if type(value) ~= "table" then
		if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
			return value
		end
		return nil
	end
	local result = {}
	for key, nested in pairs(value) do
		local clean = serializable(nested)
		if clean ~= nil and (type(key) == "string" or type(key) == "number") then
			result[key] = clean
		end
	end
	return result
end

local function saveProfile(player, reason)
	local profile = profiles[player]
	if not profile or not loadedProfiles[player] then
		warn("[Database] Skipping unsafe save for " .. player.Name .. " (profile was not loaded)")
		return false
	end
	if savingProfiles[player] then
		return savingProfiles[player]
	end
	savingProfiles[player] = true
	local payload = serializable(cloneValue(profile))
	local key = "Player_" .. tostring(player.UserId)
	local success, err = false, nil
	for attempt = 1, 3 do
		success, err = pcall(function()
			profileStore:UpdateAsync(key, function()
				return payload
			end)
		end)
		if success then
			break
		end
		warn("[Database] Save attempt " .. tostring(attempt) .. " failed for " .. player.Name .. ": " .. tostring(err))
		task.wait(attempt)
	end
	savingProfiles[player] = nil
	if not success then
		warn("[Database] Failed to save " .. player.Name .. " (" .. tostring(reason) .. "): " .. tostring(err))
		return false
	end
	print("[Database] Saved profile for " .. player.Name .. " (" .. tostring(reason) .. ")")
	return true
end

function Database.Get(player)
	return profiles[player]
end

function Database.WaitForProfile(player, timeout)
	local deadline = os.clock() + (timeout or 30)
	while not loadedProfiles[player] and player.Parent and os.clock() < deadline do
		task.wait()
	end
	return profiles[player]
end

function Database.UnsafeGetProfileAwait(player)
	return profiles[player], loadedProfiles[player] == true
end

function Database.IsPlayerLoaded(player)
	return loadedProfiles[player] == true
end

function Database.OnLoaded(callback)
	table.insert(loadedCallbacks, callback)
	for player, profile in pairs(profiles) do
		if loadedProfiles[player] then
			task.spawn(callback, player, profile)
		end
	end
end

function Database.OnFieldChanged(field, callback)
	fieldCallbacks[field] = fieldCallbacks[field] or {}
	table.insert(fieldCallbacks[field], callback)
end

function Database.Set(player, changes)
	local profile = profiles[player]
	if not profile or not loadedProfiles[player] then
		return nil
	end
	for field, value in pairs(changes) do
		profile[field] = value
		for _, callback in ipairs(fieldCallbacks[field] or {}) do
			task.spawn(callback, player, value)
		end
	end
	if statsRemote then
		statsRemote:FireClient(player, changes)
	end
	return profile
end

function Database.SetAndBroadcast(player, changes)
	return Database.Set(player, changes)
end

function Database.UpdateProfileImmutable(player, updater)
	local profile = profiles[player]
	if not profile or not loadedProfiles[player] then
		return nil
	end
	local updated = updater(cloneValue(profile))
	if type(updated) == "table" then
		profiles[player] = updated
	end
	return profiles[player]
end

function Database.ResetProfile(player)
	profiles[player] = cloneValue(defaults)
	loadedProfiles[player] = true
	return profiles[player]
end

Players.PlayerAdded:Connect(function(player)
	task.spawn(loadProfile, player)
end)

Players.PlayerRemoving:Connect(function(player)
	saveProfile(player, "PlayerRemoving")
	profiles[player] = nil
	loadedProfiles[player] = nil
	loadingProfiles[player] = nil
	savingProfiles[player] = nil
end)

task.spawn(function()
	while true do
		task.wait(60)
		for _, player in ipairs(Players:GetPlayers()) do
			saveProfile(player, "Autosave")
		end
	end
end)

game:BindToClose(function()
	local remaining = 0
	for _, player in ipairs(Players:GetPlayers()) do
		remaining += 1
		task.spawn(function()
			saveProfile(player, "BindToClose")
			remaining -= 1
		end)
	end
	local deadline = os.clock() + 25
	while remaining > 0 and os.clock() < deadline do
		task.wait()
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(loadProfile, player)
end

return Database