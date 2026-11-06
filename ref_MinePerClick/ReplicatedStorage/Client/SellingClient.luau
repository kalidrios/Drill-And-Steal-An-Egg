-- SellingClient: Управление продажей лута, интерфейсом рюкзака и кнопок продажи

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local SellingHelper = require(Helpers:WaitForChild("SellingHelper"))

require(Helpers:WaitForChild("IndexHelper"))

local Replica = DataClient:GetReplica()
local Data = Replica.Data
local Databases = ReplicatedStorage:WaitForChild("Databases")
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local Signals = require(Databases:WaitForChild("Signals"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SellLootRemote = Remotes:WaitForChild("Server"):WaitForChild("SellLoot")
local SellAllLootRemote = Remotes:WaitForChild("Server"):WaitForChild("SellAllLoot")
local SellingHolder = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("SellingFrame"):WaitForChild("SellingScrollingFrame"):WaitForChild("Holder")
local TemplateFrame = SellingHolder:WaitForChild("Template")
local SellAllButton = SellingHolder:WaitForChild("Sell All")

local SellingClient = {
	--- Подсчитывает суммарную стоимость продажи всего неблокированного инвентаря
	GetTotalRevenue = function(self)
		local sum = 0

		for uniqueId, itemData in pairs(Data.Inventory) do
			if not (itemData.InTraitMachine or itemData.IsFavorited) then
				sum = sum + SellingHelper:GetRevenue(itemData, Data.Rebirths, Data.Purchases.CashMultiplier, Data.TraitIndex, 1)
			end
		end

		return sum
	end
}

--- Обновляет отображение цены в кнопке "Sell All"
function SellingClient.UpdateSellAllFrame(self)
	local totalRevenue = SellingClient:GetTotalRevenue()
	SellAllButton:WaitForChild("Amount").Text = ("+$%*"):format((Formatting:FormatNumber(totalRevenue)))
end

--- Создаёт плашку предмета в прокручиваемом меню продажи
function SellingClient.CreateFrame(self, uniqueId, itemData)
	if SellingHolder:FindFirstChild(uniqueId) then
		return
	end

	if itemData.InTraitMachine then
		return
	end

	if itemData.IsFavorited then
		return
	end

	local itemConfig = ItemsList[itemData.ItemId]
	if not itemConfig then
		return
	end

	local revenue = SellingHelper:GetRevenue(itemData, Data.Rebirths, Data.Purchases.CashMultiplier, Data.TraitIndex, 1)
	if revenue then
		local clonedFrame = TemplateFrame:Clone()

		clonedFrame.Name = uniqueId
		clonedFrame:WaitForChild("Icon").Image = itemConfig.ImageId
		clonedFrame:WaitForChild("Title").Text = itemConfig.Name
		clonedFrame:WaitForChild("Amount").Text = ("+$%*"):format((Formatting:FormatNumber(revenue)))
		clonedFrame.Visible = true
		clonedFrame.Parent = SellingHolder

		clonedFrame:WaitForChild("SellButton").Activated:Connect(function()
			SellLootRemote:FireServer(uniqueId)
		end)

		SellingClient:UpdateSellAllFrame()
	end
end

--- Удаляет плашку предмета
function SellingClient.RemoveFrame(self, uniqueId)
	local frame = SellingHolder:FindFirstChild(uniqueId)

	if frame then
		frame:Destroy()
		SellingClient:UpdateSellAllFrame()
	end
end

--- Обновляет отображение предмета, если статус в машине трейтов изменился
function SellingClient.UpdateTraitMachineFrame(self, uniqueId)
	local itemData = Data.Inventory[uniqueId]

	if not itemData then
		SellingClient:RemoveFrame(uniqueId)
		return
	end

	if itemData.InTraitMachine == true then
		SellingClient:RemoveFrame(uniqueId)
	else
		SellingClient:CreateFrame(uniqueId, itemData)
	end

	SellingClient:UpdateSellAllFrame()
end

--- Обновляет отображение предмета, если его статус "избранного" изменился
function SellingClient.UpdateFavoriteFrame(self, uniqueId)
	local itemData = Data.Inventory[uniqueId]

	if not itemData then
		SellingClient:RemoveFrame(uniqueId)
		return
	end

	if itemData.IsFavorited == true then
		SellingClient:RemoveFrame(uniqueId)
	else
		SellingClient:CreateFrame(uniqueId, itemData)
	end

	SellingClient:UpdateSellAllFrame()
end

--- Обновляет стоимость продажи на плашках существующих предметов или создаёт новые
function SellingClient.UpdateFrames(self)
	for uniqueId, itemData in pairs(Data.Inventory) do
		local frame = SellingHolder:FindFirstChild(uniqueId)

		if frame then
			local revenue = SellingHelper:GetRevenue(itemData, Data.Rebirths, Data.Purchases.CashMultiplier, Data.TraitIndex, 1)
			if revenue then
				frame:WaitForChild("Amount").Text = ("+$%*"):format((Formatting:FormatNumber(revenue)))
			end
			continue
		end

		SellingClient:CreateFrame(uniqueId, itemData)
	end

	SellingClient:UpdateSellAllFrame()
end

--- Первоначальное создание плашек инвентаря при загрузке
function SellingClient.CreateFrames(self)
	task.spawn(function()
		for uniqueId, itemData in pairs(Data.Inventory) do
			SellingClient:CreateFrame(uniqueId, itemData)

			Replica:ListenToChange({ "Inventory", uniqueId, "InTraitMachine" }, function()
				SellingClient:UpdateTraitMachineFrame(uniqueId)
			end)

			Replica:ListenToChange({ "Inventory", uniqueId, "IsFavorited" }, function()
				SellingClient:UpdateFavoriteFrame(uniqueId)
			end)

			task.wait()
		end
	end)
	SellingClient:UpdateSellAllFrame()
end

function SellingClient.Listen(self)
	SellAllButton:WaitForChild("SellButton").Activated:Connect(function()
		SellAllLootRemote:FireServer()
	end)

	Signals.LootAdded:Connect(function(itemData, uniqueId)
		SellingClient:CreateFrame(uniqueId, itemData)

		Replica:ListenToChange({ "Inventory", uniqueId, "InTraitMachine" }, function()
			SellingClient:UpdateTraitMachineFrame(uniqueId)
		end)

		Replica:ListenToChange({ "Inventory", uniqueId, "IsFavorited" }, function()
			SellingClient:UpdateFavoriteFrame(uniqueId)
		end)
	end)

	Signals.LootRemoved:Connect(function(itemData, uniqueId)
		SellingClient:RemoveFrame(uniqueId)
	end)

	Signals.TraitIndexAdded:Connect(function()
		SellingClient:UpdateFrames()
	end)

	Signals.TraitIndexRemoved:Connect(function()
		SellingClient:UpdateFrames()
	end)

	Replica:ListenToChange({ "Rebirths" }, function()
		SellingClient:UpdateFrames()
	end)

	Replica:ListenToChange({ "Purchases", "CashMultiplier" }, function()
		SellingClient:UpdateFrames()
	end)

	Replica:ListenToChange({ "Purchases", "CashMultiplier" }, function()
		SellingClient:UpdateFrames()
	end)
end

function SellingClient.Start(self)
	SellingClient:Listen()
	SellingClient:CreateFrames()
end

return SellingClient