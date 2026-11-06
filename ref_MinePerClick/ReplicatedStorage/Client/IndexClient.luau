-- IndexClient: UI коллекции найденных предметов (Индекс) и трейтов

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game.Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")

require(Helpers:WaitForChild("ItemsHelper"))

local Databases = ReplicatedStorage:WaitForChild("Databases")
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local RaritiesList = require(Databases:WaitForChild("RaritiesList"))
local TraitsList = require(Databases:WaitForChild("TraitsList"))
local Signals = require(Databases:WaitForChild("Signals"))
local IndexFrame = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("IndexFrame")
local ItemsHolder = IndexFrame:WaitForChild("IndexScrollingFrame"):WaitForChild("Holder")
local TraitsHolder = IndexFrame:WaitForChild("TraitScrollingFrame"):WaitForChild("Holder")
local ItemTemplate = ItemsHolder:WaitForChild("Template")
local TraitTemplate = TraitsHolder:WaitForChild("Template")
local IndexProgressBar = IndexFrame:WaitForChild("IndexProgressBar")
local TraitProgressBar = IndexFrame:WaitForChild("TraitProgressBar")
local IndexCounter = IndexFrame:WaitForChild("IndexCounter")
local TraitCounter = IndexFrame:WaitForChild("TraitCounter")
local Data = DataClient:GetReplica().Data

local IndexClient = {
	OwnsItem = function(self, itemId)
		return Data.InventoryIndex and table.find(Data.InventoryIndex, itemId) ~= nil
	end,
	OwnsTrait = function(self, traitId)
		return Data.TraitIndex and table.find(Data.TraitIndex, traitId) ~= nil
	end
}

--- Блокирует трейт в интерфейсе (скрывает название и затемняет иконку)
function IndexClient.LockTrait(self, traitId)
	local frame = TraitsHolder:FindFirstChild(tostring(traitId))

	if frame then
		local Title = frame:WaitForChild("Top"):WaitForChild("Title")
		local Icon = frame:WaitForChild("Icon")

		Title.Text = "???"
		Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
		IndexClient:UpdateTraitCounter()
	end
end

--- Разблокирует трейт в интерфейсе
function IndexClient.UnlockTrait(self, traitId)
	local frame = TraitsHolder:FindFirstChild(tostring(traitId))

	if not frame then
		return
	end

	local traitData = TraitsList[traitId]

	if traitData then
		local Title = frame:WaitForChild("Top"):WaitForChild("Title")
		local Icon = frame:WaitForChild("Icon")

		Title.Text = traitData.Name
		Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		IndexClient:UpdateTraitCounter()
	end
end

--- Блокирует предмет в интерфейсе
function IndexClient.LockItem(self, itemId)
	local frame = ItemsHolder:FindFirstChild(tostring(itemId))

	if frame then
		local Title = frame:WaitForChild("Top"):WaitForChild("Title")
		local Icon = frame:WaitForChild("Icon")

		Title.Text = "???"
		Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
		IndexClient:UpdateIndexCounter()
	end
end

--- Разблокирует предмет в интерфейсе
function IndexClient.UnlockItem(self, itemId)
	local frame = ItemsHolder:FindFirstChild(tostring(itemId))

	if not frame then
		return
	end

	local itemData = ItemsList[itemId]

	if itemData then
		local Title = frame:WaitForChild("Top"):WaitForChild("Title")
		local Icon = frame:WaitForChild("Icon")

		Title.Text = itemData.Name
		Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		IndexClient:UpdateIndexCounter()
	end
end

--- Обновляет полосу прогресса
function IndexClient.UpdateProgressBar(self, progressBar, currentCount, maxCount)
	local Bar = progressBar:WaitForChild("Bar")
	local ratio = if maxCount > 0 then math.clamp(currentCount / maxCount, 0, 1) else 0

	TweenService:Create(Bar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromScale(ratio, 1)
	}):Play()
end

--- Обновляет счётчик предметов и прогресс-бар
function IndexClient.UpdateIndexCounter(self)
	local totalItems = 0
	local ownedItems = 0

	for itemId, itemData in pairs(ItemsList) do
		if not itemData.Unobtainable then
			totalItems = totalItems + 1

			if IndexClient:OwnsItem(itemId) then
				ownedItems = ownedItems + 1
			end
		end
	end

	IndexCounter.Text = ownedItems .. "/" .. totalItems
	IndexClient:UpdateProgressBar(IndexProgressBar, ownedItems, totalItems)
end

--- Обновляет счётчик трейтов и прогресс-бар
function IndexClient.UpdateTraitCounter(self)
	local totalTraits = 0
	local ownedTraits = 0

	for traitId in pairs(TraitsList) do
		totalTraits = totalTraits + 1

		if IndexClient:OwnsTrait(traitId) then
			ownedTraits = ownedTraits + 1
		end
	end

	TraitCounter.Text = ownedTraits .. "/" .. totalTraits
	IndexClient:UpdateProgressBar(TraitProgressBar, ownedTraits, totalTraits)
end

--- Создаёт UI-карточки трейтов
function IndexClient.CreateTraitFrames(self)
	for traitId, traitData in pairs(TraitsList) do
		local frame = TraitTemplate:Clone()

		frame.Name = tostring(traitId)
		frame:SetAttribute("TraitId", traitId)
		frame:WaitForChild("Top"):WaitForChild("Title").Text = traitData.Name
		frame:WaitForChild("Multiplier").Text = "x" .. traitData.Multiplier
		frame:WaitForChild("Icon").Image = traitData.Icon.Image or ""
		frame.Visible = true
		frame.Parent = TraitsHolder
		frame.LayoutOrder = traitData.Multiplier or 0

		if IndexClient:OwnsTrait(traitId) then
			IndexClient:UnlockTrait(traitId)
			continue
		end

		IndexClient:LockTrait(traitId)
	end
end

--- Создаёт UI-карточки предметов
function IndexClient.CreateItemFrames(self)
	for itemId, itemData in pairs(ItemsList) do
		if not itemData.Unobtainable then
			local frame = ItemTemplate:Clone()

			frame.Name = tostring(itemId)
			frame:SetAttribute("ItemId", itemId)
			frame:WaitForChild("Top"):WaitForChild("Title").Text = itemData.Name

			local Icon = frame:WaitForChild("Icon")
			Icon.Image = itemData.ImageId or itemData.Icon or ""

			local Rarity = frame:WaitForChild("Rarity")
			Rarity.Text = itemData.Rarity or "Common"

			local rarityData = RaritiesList[itemData.Rarity]
			if rarityData and rarityData.Gradient then
				rarityData.Gradient:Clone().Parent = Rarity
			end

			frame.Visible = true
			frame.Parent = ItemsHolder
			frame.LayoutOrder = itemData.Revenue or 0

			if IndexClient:OwnsItem(itemId) then
				IndexClient:UnlockItem(itemId)
				continue
			end

			IndexClient:LockItem(itemId)
		end
	end
end

--- Создаёт все UI-карточки
function IndexClient.CreateFrames(self)
	IndexClient:CreateTraitFrames()
	IndexClient:CreateItemFrames()
end

--- Слушает сигналы добавления/удаления предметов и трейтов в коллекции
function IndexClient.Listen(self)
	Signals.IndexAdded:Connect(function(itemId)
		IndexClient:UnlockItem(itemId)
	end)
	Signals.IndexRemoved:Connect(function(itemId)
		IndexClient:LockItem(itemId)
	end)
	Signals.TraitIndexAdded:Connect(function(traitId)
		IndexClient:UnlockTrait(traitId)
	end)
	Signals.TraitIndexRemoved:Connect(function(traitId)
		IndexClient:LockTrait(traitId)
	end)

	-- Синхронизация видимости текстовых полей и баров при переключении вкладок
	IndexFrame:WaitForChild("IndexScrollingFrame"):GetPropertyChangedSignal("Visible"):Connect(function()
		local isIndexVisible = IndexFrame:WaitForChild("IndexScrollingFrame").Visible
		local isTraitVisible = IndexFrame:WaitForChild("TraitScrollingFrame").Visible

		IndexCounter.Visible = isIndexVisible
		IndexProgressBar.Visible = isIndexVisible
		TraitCounter.Visible = isTraitVisible
		TraitProgressBar.Visible = isTraitVisible
	end)

	IndexFrame:WaitForChild("TraitScrollingFrame"):GetPropertyChangedSignal("Visible"):Connect(function()
		local isIndexVisible = IndexFrame:WaitForChild("IndexScrollingFrame").Visible
		local isTraitVisible = IndexFrame:WaitForChild("TraitScrollingFrame").Visible

		IndexCounter.Visible = isIndexVisible
		IndexProgressBar.Visible = isIndexVisible
		TraitCounter.Visible = isTraitVisible
		TraitProgressBar.Visible = isTraitVisible
	end)
end

function IndexClient.Start(self)
	IndexClient:CreateFrames()
	IndexClient:Listen()
	IndexClient:UpdateIndexCounter()
	IndexClient:UpdateTraitCounter()
end

return IndexClient