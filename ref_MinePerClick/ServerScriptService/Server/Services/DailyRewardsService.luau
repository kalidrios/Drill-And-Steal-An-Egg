--[[
	DailyRewardsService: Ежедневные награды с 30-дневным стриком
	- Игрок может получить награду раз в 24 часа
	- Стрик растёт каждый день подряд, на 30-й день сбрасывается
	- Если игрок пропустил день — стрик сбрасывается
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- lazy

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ClaimDailyRemote = Remotes:WaitForChild("Server"):WaitForChild("ClaimDailyReward")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

-- Награды по дням стрика (30 дней, затем цикл)
local DAILY_REWARDS = {
	[1] = { Cash = 1000, Strength = 500 },
	[2] = { Cash = 2500, Strength = 1000 },
	[3] = { Cash = 5000, Strength = 2000 },
	[4] = { Cash = 10000, Strength = 4000 },
	[5] = { Cash = 20000, Strength = 7500 },
	[6] = { Cash = 35000, Strength = 12000 },
	[7] = { Cash = 75000, Strength = 25000 }, -- Неделя 1

	[8] = { Cash = 100000, Strength = 35000 },
	[9] = { Cash = 125000, Strength = 45000 },
	[10] = { Cash = 150000, Strength = 60000 },
	[11] = { Cash = 200000, Strength = 80000 },
	[12] = { Cash = 250000, Strength = 100000 },
	[13] = { Cash = 350000, Strength = 135000 },
	[14] = { Cash = 500000, Strength = 200000 }, -- Неделя 2

	[15] = { Cash = 600000, Strength = 250000 },
	[16] = { Cash = 750000, Strength = 300000 },
	[17] = { Cash = 900000, Strength = 375000 },
	[18] = { Cash = 1100000, Strength = 450000 },
	[19] = { Cash = 1300000, Strength = 550000 },
	[20] = { Cash = 1600000, Strength = 650000 },
	[21] = { Cash = 2000000, Strength = 850000 }, -- Неделя 3

	[22] = { Cash = 2400000, Strength = 1000000 },
	[23] = { Cash = 2800000, Strength = 1200000 },
	[24] = { Cash = 3300000, Strength = 1400000 },
	[25] = { Cash = 3900000, Strength = 1650000 },
	[26] = { Cash = 4600000, Strength = 1900000 },
	[27] = { Cash = 5400000, Strength = 2200000 },
	[28] = { Cash = 6300000, Strength = 2600000 },
	[29] = { Cash = 7500000, Strength = 3100000 },
	[30] = { Cash = 10000000, Strength = 5000000 }, -- 30-й день (Джекпот)
}

-- Кулдаун между наградами (24 часа в секундах)
local COOLDOWN = 86400

local DailyRewardsService = {}

--- Проверяет, может ли игрок получить награду
function DailyRewardsService.CanClaim(player)
	local profile = DataService.GetProfile(player)
	if not profile then return false, 0 end

	local data = profile.Data
	local lastClaim = data.DailyRewardLastClaim or 0
	local now = os.time()

	if now - lastClaim >= COOLDOWN then
		return true, 0
	end

	return false, (COOLDOWN - (now - lastClaim))
end

--- Выдаёт ежедневную награду игроку
function DailyRewardsService.ClaimReward(player)
	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local replica = profile.Replica
	local now = os.time()
	local lastClaim = data.DailyRewardLastClaim or 0

	-- Проверка кулдауна
	if now - lastClaim < COOLDOWN then
		local remaining = COOLDOWN - (now - lastClaim)
		local hoursLeft = math.floor(remaining / 3600)
		NotificationRemote:FireClient(player, "Daily Reward", "Come back in " .. hoursLeft .. " hours!")
		return
	end

	-- Расчёт стрика
	local currentStreak = data.DailyRewardStreak or 0

	-- Если прошло больше 48 часов с последнего клейма — стрик сбрасывается
	if lastClaim > 0 and (now - lastClaim) > (COOLDOWN * 2) then
		currentStreak = 0
	end

	-- Увеличиваем стрик (максимум 30, затем цикл)
	currentStreak = currentStreak + 1
	if currentStreak > 30 then currentStreak = 1 end

	-- Получаем награду для текущего дня
	local reward = DAILY_REWARDS[currentStreak] or DAILY_REWARDS[1]

	-- Выдаём награды
	local rewardTexts = {}
	if reward.Cash and reward.Cash > 0 then
		replica:SetValue({"Cash"}, data.Cash + reward.Cash)
		table.insert(rewardTexts, "$" .. tostring(reward.Cash))
	end
	if reward.Strength and reward.Strength > 0 then
		replica:SetValue({"Strength"}, data.Strength + reward.Strength)
		table.insert(rewardTexts, tostring(reward.Strength) .. " Strength")
	end

	-- Сохраняем стрик и время клейма
	replica:SetValue({"DailyRewardStreak"}, currentStreak)
	replica:SetValue({"DailyRewardLastClaim"}, now)

	-- Обновляем leaderstats
	DataService.UpdateLeaderstats(player)

	-- Уведомляем игрока
	local rewardStr = table.concat(rewardTexts, ", ")
	NotificationRemote:FireClient(player, "Daily Reward Day " .. currentStreak .. "!", "You received: " .. rewardStr)
end

function DailyRewardsService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	ClaimDailyRemote.OnServerEvent:Connect(function(player)
		DailyRewardsService.ClaimReward(player)
	end)

	print("[DailyRewardsService]: Started")
end

return DailyRewardsService