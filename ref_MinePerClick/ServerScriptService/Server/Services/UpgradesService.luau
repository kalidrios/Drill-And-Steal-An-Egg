--[[
	UpgradesService: Апгрейды размера рюкзака и скорости ходьбы (с поддержкой Robux)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

local DataService -- lazy
local Databases = ReplicatedStorage:WaitForChild("Databases")
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local UpgradesHelper = require(Helpers:WaitForChild("UpgradesHelper"))
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local UpgradeSlotRemote = Remotes:WaitForChild("Server"):WaitForChild("UpgradeSlot")
local UpgradeWalkspeedRemote = Remotes:WaitForChild("Server"):WaitForChild("UpgradeWalkspeed")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

local UpgradesService = {}

--- Апгрейд слотов рюкзака
function UpgradesService.BuySlot(player, method)
	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local replica = profile.Replica

	if method == "Cash" then
		local currentSize = data.BackpackSize or 3
		if currentSize >= UpgradesHelper.MaxBackpackSize then
			NotificationRemote:FireClient(player, "Maxed Out", "Your backpack size is already at maximum!")
			return
		end

		local cost = UpgradesHelper:GetBackpackUpgradeCost(currentSize)
		if data.Cash < cost then
			NotificationRemote:FireClient(player, "Not Enough Coins", "You need $" .. tostring(cost) .. " to upgrade!")
			return
		end

		replica:SetValue({"Cash"}, data.Cash - cost)
		replica:SetValue({"BackpackSize"}, currentSize + 1)

		DataService.UpdateLeaderstats(player)
		NotificationRemote:FireClient(player, "Upgraded!", "Your backpack size is now " .. tostring(currentSize + 1))
	elseif method == "Robux" then
		-- Промптим покупку DevProduct +1 Slot
		local productId = Config.Products and Config.Products.Upgrades and Config.Products.Upgrades["+1 Slot"]
		if productId then
			MarketplaceService:PromptProductPurchase(player, productId)
		else
			NotificationRemote:FireClient(player, "Not Available", "Robux purchases are currently unavailable.")
		end
	end
end

--- Обновление скорости персонажа
function UpgradesService.ApplyWalkspeed(player, extraSpeed)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 25 + (extraSpeed or 0)
		end
	end
end

--- Апгрейд скорости ходьбы
function UpgradesService.BuyWalkspeed(player, method)
	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local replica = profile.Replica
	local currentExtraSpeed = data.ExtraWalkSpeed or 0

	if method == "Cash" then
		if 25 + currentExtraSpeed >= UpgradesHelper.MaxWalkspeed then
			NotificationRemote:FireClient(player, "Maxed Out", "Your walkspeed is already at maximum!")
			return
		end

		local cost = UpgradesHelper:GetWalkspeedUpgradeCost(currentExtraSpeed)
		if data.Cash < cost then
			NotificationRemote:FireClient(player, "Not Enough Coins", "You need $" .. tostring(cost) .. " to upgrade!")
			return
		end

		local newExtraSpeed = currentExtraSpeed + 1

		replica:SetValue({"Cash"}, data.Cash - cost)
		replica:SetValue({"ExtraWalkSpeed"}, newExtraSpeed)

		-- Применяем скорость к персонажу
		UpgradesService.ApplyWalkspeed(player, newExtraSpeed)

		DataService.UpdateLeaderstats(player)
		NotificationRemote:FireClient(player, "Upgraded!", "Your walkspeed has been increased!")
	elseif method == "Robux" then
		-- Промптим покупку DevProduct +1 Walkspeed
		local productId = Config.Products and Config.Products.Upgrades and Config.Products.Upgrades["+1 Walkspeed"]
		if productId then
			MarketplaceService:PromptProductPurchase(player, productId)
		else
			NotificationRemote:FireClient(player, "Not Available", "Robux purchases are currently unavailable.")
		end
	end
end

function UpgradesService.OnCharacterAdded(self, player, character)
	-- Восстанавливаем скорость при спавне персонажа
	task.defer(function()
		local profile = DataService and DataService.GetProfile(player)
		if profile then
			local extraSpeed = profile.Data.ExtraWalkSpeed or 0
			UpgradesService.ApplyWalkspeed(player, extraSpeed)
		end
	end)
end

function UpgradesService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	UpgradeSlotRemote.OnServerEvent:Connect(function(player, method)
		if method ~= "Cash" and method ~= "Robux" then return end
		UpgradesService.BuySlot(player, method)
	end)

	UpgradeWalkspeedRemote.OnServerEvent:Connect(function(player, method)
		if method ~= "Cash" and method ~= "Robux" then return end
		UpgradesService.BuyWalkspeed(player, method)
	end)

	print("[UpgradesService]: Started")
end

return UpgradesService