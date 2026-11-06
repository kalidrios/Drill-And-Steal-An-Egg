--[[
	GiftingService: Передача лута между игроками
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local DataService -- lazy

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GiftLootRemote = Remotes:WaitForChild("Server"):WaitForChild("GiftLoot")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

local GiftingService = {}

-- Дебаунс: 3 секунды между подарками
local GIFT_DEBOUNCE = 3
local lastGiftTime = {}

function GiftingService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	GiftLootRemote.OnServerEvent:Connect(function(player, targetUserId)
		if type(targetUserId) ~= "number" then return end

		-- Дебаунс
		local now = os.clock()
		if lastGiftTime[player] and (now - lastGiftTime[player]) < GIFT_DEBOUNCE then
			return
		end
		lastGiftTime[player] = now

		-- Нельзя дарить самому себе
		if targetUserId == player.UserId then return end

		-- Находим целевого игрока
		local targetPlayer = Players:GetPlayerByUserId(targetUserId)
		if not targetPlayer then
			NotificationRemote:FireClient(player, "Error", "Player not found!")
			return
		end

		-- Профили
		local senderProfile = DataService.GetProfile(player)
		local targetProfile = DataService.GetProfile(targetPlayer)
		if not senderProfile or not targetProfile then return end

		-- Ищем предмет в руках (экипированный Tool с UniqueId)
		local character = player.Character
		if not character then return end

		local tool = character:FindFirstChildOfClass("Tool")
		if not tool then
			NotificationRemote:FireClient(player, "Error", "Hold an item to gift it!")
			return
		end

		local uniqueId = tool:GetAttribute("UniqueId")
		if not uniqueId then
			NotificationRemote:FireClient(player, "Error", "This item cannot be gifted!")
			return
		end

		local itemData = senderProfile.Data.Inventory[uniqueId]
		if not itemData then return end
		if itemData.IsFavorited then
			NotificationRemote:FireClient(player, "Error", "Unfavorite the item first!")
			return
		end
		if itemData.InTraitMachine then
			NotificationRemote:FireClient(player, "Error", "Item is in the Trait Machine!")
			return
		end

		-- Удаляем у отправителя
		senderProfile.Replica:SetValue({"Inventory", uniqueId}, nil)
		DataService.UpdateInventoryCount(player)
		tool:Destroy()

		-- Создаём новый уникальный ID для получателя
		local newUniqueId = HttpService:GenerateGUID(false)
		local newItemData = {
			ItemId = itemData.ItemId,
			InTraitMachine = false,
			IsFavorited = false,
			InBackpack = false,
		}

		-- Добавляем получателю
		targetProfile.Replica:SetValue({"Inventory", newUniqueId}, newItemData)
		DataService.UpdateInventoryCount(targetPlayer)

		-- Добавляем в индекс получателя
		if not table.find(targetProfile.Data.InventoryIndex, itemData.ItemId) then
			targetProfile.Replica:ArrayInsert({"InventoryIndex"}, itemData.ItemId)
		end

		-- Уведомления
		NotificationRemote:FireClient(player, "Gifted!", "You gifted an item to " .. targetPlayer.Name .. "!")
		NotificationRemote:FireClient(targetPlayer, "Gift Received!", player.Name .. " gifted you an item!")

		-- Перевыдаём инструменты получателю
		local SellingService = require(ServerScriptService.Server.Services.SellingService)
		SellingService.GiveInventoryTools(targetPlayer)
	end)

	-- Cleanup
	Players.PlayerRemoving:Connect(function(player)
		lastGiftTime[player] = nil
	end)

	print("[GiftingService]: Started")
end

return GiftingService