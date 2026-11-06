--[[
	CodesService: Обработка промокодов, выдача наград
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- lazy
local Databases = ReplicatedStorage:WaitForChild("Databases")
local CodesList = require(Databases:WaitForChild("CodesList"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RedeemCodeRemote = Remotes:WaitForChild("Server"):WaitForChild("RedeemCode")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

local CodesService = {}

--- Проверяет и активирует промокод для игрока
function CodesService.RedeemCode(player, code)
	if type(code) ~= "string" then return end

	-- Нормализуем код: uppercase, обрезаем пробелы
	code = code:upper():gsub("%s+", "")

	if code == "" then
		NotificationRemote:FireClient(player, "Invalid Code", "Please enter a valid code!")
		return
	end

	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local replica = profile.Replica

	-- Проверяем, не использовал ли игрок уже этот код
	if data.RedeemedCodes and data.RedeemedCodes[code] then
		NotificationRemote:FireClient(player, "Already Redeemed", "You have already redeemed this code!")
		return
	end

	-- Ищем код в базе
	local codeData = CodesList[code]
	if not codeData then
		NotificationRemote:FireClient(player, "Invalid Code", "This code does not exist!")
		return
	end

	-- Проверка срока действия
	if codeData.ExpiresAt and codeData.ExpiresAt > 0 and os.time() > codeData.ExpiresAt then
		NotificationRemote:FireClient(player, "Expired Code", "This code has expired!")
		return
	end

	-- Проверка лимита использований
	if codeData.MaxUses and codeData.MaxUses > 0 and codeData.Uses >= codeData.MaxUses then
		NotificationRemote:FireClient(player, "Code Used Up", "This code has reached its maximum uses!")
		return
	end

	-- Выдаём награды
	local rewards = codeData.Rewards or {}
	local rewardTexts = {}

	if rewards.Cash and rewards.Cash > 0 then
		replica:SetValue({"Cash"}, data.Cash + rewards.Cash)
		table.insert(rewardTexts, "$" .. tostring(rewards.Cash))
	end
	if rewards.Strength and rewards.Strength > 0 then
		replica:SetValue({"Strength"}, data.Strength + rewards.Strength)
		table.insert(rewardTexts, tostring(rewards.Strength) .. " Strength")
	end

	-- Отмечаем код как использованный
	replica:SetValue({"RedeemedCodes", code}, true)

	-- Увеличиваем счётчик использований
	codeData.Uses = (codeData.Uses or 0) + 1

	-- Обновляем leaderstats
	DataService.UpdateLeaderstats(player)

	-- Уведомляем игрока
	local rewardStr = table.concat(rewardTexts, ", ")
	if rewardStr == "" then rewardStr = "No rewards" end
	NotificationRemote:FireClient(player, "Code Redeemed!", "You received: " .. rewardStr)
end

function CodesService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	RedeemCodeRemote.OnServerEvent:Connect(function(player, code)
		CodesService.RedeemCode(player, code)
	end)

	print("[CodesService]: Started")
end

return CodesService