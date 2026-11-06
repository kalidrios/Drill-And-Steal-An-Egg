--[[
	PlaytimeRewardsService: Серверный сервис наград за время в игре
	- Отслеживает время онлайн каждого игрока в текущей сессии (PlaytimeSeconds)
	- Сбрасывает время и полученные награды при перезаходе, поощряя игроков не выходить из игры
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- lazy

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ClaimPlaytimeRemote = Remotes:WaitForChild("Server"):WaitForChild("ClaimPlaytimeReward")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

-- Прогрессия наград за время в секундах
local PLAYTIME_REWARDS = {
	[1] = { Seconds = 300, Cash = 2500, Strength = 1000, Title = "5 Minutes" },       -- 5 мин
	[2] = { Seconds = 600, Cash = 5000, Strength = 2500, Title = "10 Minutes" },      -- 10 мин
	[3] = { Seconds = 900, Cash = 10000, Strength = 5000, Title = "15 Minutes" },     -- 15 мин
	[4] = { Seconds = 1200, Cash = 25000, Strength = 10000, Title = "20 Minutes" },   -- 20 мин
	[5] = { Seconds = 1800, Cash = 50000, Strength = 25000, Title = "30 Minutes" },   -- 30 мин
	[6] = { Seconds = 2700, Cash = 100000, Strength = 50000, Title = "45 Minutes" },  -- 45 мин
	[7] = { Seconds = 3600, Cash = 250000, Strength = 100000, Title = "1 Hour" },     -- 60 мин
	[8] = { Seconds = 5400, Cash = 500000, Strength = 250000, Title = "1.5 Hours" },  -- 90 мин
	[9] = { Seconds = 7200, Cash = 1000000, Strength = 500000, Title = "2 Hours" },   -- 120 мин
}

local PlaytimeRewardsService = {}

function PlaytimeRewardsService.ClaimReward(player, giftId)
	if type(giftId) ~= "number" then return end
	local reward = PLAYTIME_REWARDS[giftId]
	if not reward then return end

	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local replica = profile.Replica

	-- Проверка: уже получено в этой сессии?
	local claimed = data.PlaytimeRewardsClaimed or {}
	if claimed[tostring(giftId)] then
		NotificationRemote:FireClient(player, "Playtime Reward", "Reward already claimed inside this session!")
		return
	end

	-- Проверка: достаточно ли времени в текущей сессии?
	local currentSeconds = data.PlaytimeSeconds or 0
	if currentSeconds < reward.Seconds then
		NotificationRemote:FireClient(player, "Playtime Reward", "You need more playtime in this session to claim this reward!")
		return
	end

	-- Выдаём награду
	if reward.Cash and reward.Cash > 0 then
		replica:SetValue({"Cash"}, data.Cash + reward.Cash)
	end
	if reward.Strength and reward.Strength > 0 then
		replica:SetValue({"Strength"}, data.Strength + reward.Strength)
	end

	-- Отмечаем как полученное в этой сессии
	replica:SetValue({"PlaytimeRewardsClaimed", tostring(giftId)}, true)

	-- Обновляем leaderstats
	DataService.UpdateLeaderstats(player)

	-- Уведомляем игрока
	NotificationRemote:FireClient(player, "Playtime Reward Claimed!", "You received reward for " .. reward.Title .. "!")
end

function PlaytimeRewardsService.OnPlayerAdded(self, player)
	task.spawn(function()
		local profile = DataService.GetProfile(player)
		while not profile and player.Parent do
			task.wait(0.5)
			profile = DataService.GetProfile(player)
		end
		if profile and profile.Data and profile.Replica then
			-- Сброс таймера и наград при перезаходе в игру (сессионная механика)
			profile.Data.PlaytimeSeconds = 0
			profile.Data.PlaytimeRewardsClaimed = {}
			profile.Replica:SetValue({"PlaytimeSeconds"}, 0)
			profile.Replica:SetValue({"PlaytimeRewardsClaimed"}, {})
		end
	end)
end

function PlaytimeRewardsService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	ClaimPlaytimeRemote.OnServerEvent:Connect(function(player, giftId)
		PlaytimeRewardsService.ClaimReward(player, giftId)
	end)

	-- Сброс при выходе
	Players.PlayerRemoving:Connect(function(player)
		local profile = DataService.GetProfile(player)
		if profile and profile.Data then
			profile.Data.PlaytimeSeconds = 0
			profile.Data.PlaytimeRewardsClaimed = {}
		end
	end)

	-- Цикл учёта онлайна в сессии и общего времени каждую секунду (секунду в секунду)
	task.spawn(function()
		while true do
			task.wait(1)
			for _, player in ipairs(Players:GetPlayers()) do
				local profile = DataService.GetProfile(player)
				if profile and profile.Data and profile.Replica then
					profile.Data.PlaytimeSeconds = (profile.Data.PlaytimeSeconds or 0) + 1
					profile.Data.TotalPlaytime = (profile.Data.TotalPlaytime or 0) + 1
					profile.Replica:SetValue({"PlaytimeSeconds"}, profile.Data.PlaytimeSeconds)
					profile.Replica:SetValue({"TotalPlaytime"}, profile.Data.TotalPlaytime)
					DataService.UpdateLeaderstats(player)
				end
			end
		end
	end)

	print("[PlaytimeRewardsService]: Started (Session Reset Mode)")
end

return PlaytimeRewardsService