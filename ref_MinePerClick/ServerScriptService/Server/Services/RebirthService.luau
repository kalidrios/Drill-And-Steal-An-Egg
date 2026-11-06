--[[
	RebirthService: Логика ребиртов и сброса прогресса (с поддержкой Skip Rebirth)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

local DataService -- lazy
local PickaxeService -- lazy
local StageService -- lazy
local Databases = ReplicatedStorage:WaitForChild("Databases")
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local LevelsHelper = require(Helpers:WaitForChild("LevelsHelper"))
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RebirthRemote = Remotes:WaitForChild("Server"):WaitForChild("Rebirth")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

local RebirthService = {}

function RebirthService.DoRebirth(player)
	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local replica = profile.Replica

	-- Расчет уровня
	local currentLevel, _, _ = LevelsHelper:GetLevel(data.Strength)
	local requiredLevel = LevelsHelper:GetRequiredRebirthLevel(data.Rebirths)

	if currentLevel < requiredLevel then
		NotificationRemote:FireClient(
			player,
			"Cannot Rebirth",
			("You need to reach Level %d to Rebirth!"):format(requiredLevel)
		)
		return
	end

	RebirthService.ForceRebirth(player)
end

--- ForceRebirth: выполняет ребирт без проверки требований (для Skip Rebirth)
function RebirthService.ForceRebirth(player)
	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local replica = profile.Replica

	-- Сброс прогресса: сбрасываем только силу в 1 и увеличиваем ребирты
	replica:SetValue({"Strength"}, 1)
	replica:SetValue({"Rebirths"}, data.Rebirths + 1)

	-- Сброс стен
	StageService.ResetAllWalls(player)

	-- Обновление лидербордов
	DataService.UpdateLeaderstats(player)
end

function RebirthService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)
	PickaxeService = require(ServerScriptService.Server.Services.PickaxeService)
	StageService = require(ServerScriptService.Server.Services.StageService)

	RebirthRemote.OnServerEvent:Connect(function(player, action)
		if action == "Rebirth" then
			RebirthService.DoRebirth(player)
		elseif action == "Skip" then
			-- Промптим покупку Skip Rebirth DevProduct
			local skipProductId = Config.Products and Config.Products["Skip Rebirth"]
			if skipProductId then
				MarketplaceService:PromptProductPurchase(player, skipProductId)
			else
				NotificationRemote:FireClient(
					player,
					"Not Available",
					"Skip Rebirth is currently unavailable."
				)
			end
		end
	end)

	print("[RebirthService]: Started")
end

return RebirthService