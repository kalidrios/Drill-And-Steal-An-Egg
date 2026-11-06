--[[
	ItemsHelper: Вспомогательный модуль для работы с моделями и данными предметов (лута)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Items")
local Databases = ReplicatedStorage:WaitForChild("Databases")
local RaritiesList = require(Databases:WaitForChild("RaritiesList"))
local TraitsList = require(Databases:WaitForChild("TraitsList"))
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Assets = ReplicatedStorage:WaitForChild("Assets")

local ItemsHelper = {}

--- Создаёт BillboardGui-эффекты надписи (имя, редкость, доход) над предметом
function ItemsHelper.CreateItemStats(self, item)
	local calculatedPreset = ItemsHelper:GetCalculatedPreset(item)
	if not calculatedPreset then
		return nil
	end

	local billboardClone = Assets:WaitForChild("Attachments"):WaitForChild("ItemStats"):Clone()
	if not billboardClone then
		return nil
	end

	local gui = billboardClone:FindFirstChild("BillboardGui")
	if gui then
		gui:FindFirstChild("Name").Text = calculatedPreset.Name
		
		local rarityLabel = gui:FindFirstChild("Rarity")
		rarityLabel.Text = calculatedPreset.Rarity
		
		local rarityConfig = RaritiesList[calculatedPreset.Rarity]
		if rarityConfig and rarityConfig.Gradient then
			rarityConfig.Gradient:Clone().Parent = rarityLabel
		end

		if item.TraitIds then
			for _, traitId in pairs(item.TraitIds) do
				local traitConfig = TraitsList[traitId]
				if traitConfig then
					local traitsFrame = gui:FindFirstChild("Traits")
					traitsFrame.Visible = true
					
					local iconClone = traitConfig.Icon:Clone()
					iconClone.Parent = traitsFrame
					iconClone.Visible = true
				end
			end
		end

		gui:FindFirstChild("Revenue").Text = ("$%*"):format(Formatting:FormatNumber(calculatedPreset.Revenue))
	end

	return billboardClone
end

--- Рассчитывает параметры предмета с учётом трейтов
function ItemsHelper.GetCalculatedPreset(self, item)
	local baseItem = ItemsList[item.ItemId]
	if not baseItem then
		return nil
	end

	local multiplierSum = 1
	if item.TraitIds then
		for _, traitId in pairs(item.TraitIds) do
			local traitConfig = TraitsList[traitId]
			if traitConfig and traitConfig.Multiplier then
				multiplierSum = multiplierSum + (traitConfig.Multiplier - 1)
			end
		end
	end

	local presetClone = table.clone(baseItem)
	presetClone.Revenue = baseItem.Revenue * multiplierSum
	return presetClone
end

--- Клонирует и подготавливает визуальную модель предмета
function ItemsHelper.GetItemModel(self, item)
	local baseItem = ItemsList[item.ItemId]
	if not baseItem then
		return nil
	end

	local itemFolder = ItemsFolder:FindFirstChild(baseItem.Name)
	local defaultFolder = itemFolder and itemFolder:FindFirstChild("Default")
	local templateModel = defaultFolder and defaultFolder:FindFirstChildWhichIsA("Model")

	if not templateModel then
		warn("ItemsHelper: Item model not found for " .. tostring(baseItem.Name) .. " / Default")
		return nil
	end

	local modelClone = templateModel:Clone()
	for _, child in pairs(modelClone:GetDescendants()) do
		if child:IsA("BasePart") then
			child.Anchored = false
			child.CanCollide = false
			child.Massless = true
		end
	end

	return modelClone
end

--- Размещает модель на спавнпоинте, выравнивая по высоте и создавая статы
function ItemsHelper.PlaceItemModel(self, spawnPart, model, item)
	local boundingBoxCFrame, boundingBoxSize = model:GetBoundingBox()
	local statsBillboard = ItemsHelper:CreateItemStats(item)

	if statsBillboard and model.PrimaryPart then
		statsBillboard.Parent = model.PrimaryPart
		statsBillboard.Position = Vector3.new(0, boundingBoxSize.Y / 2 + 2.0, 0)
	end

	if model.PrimaryPart then
		model.PrimaryPart.Anchored = true
		model.PrimaryPart.Massless = true
		model.PrimaryPart.CanCollide = false
	end
	
	model.Parent = spawnPart

	local targetPosition = spawnPart.CFrame.Position
	model:PivotTo(CFrame.new(targetPosition + Vector3.new(0, 50 + boundingBoxCFrame.Y, 0)) * spawnPart.CFrame.Rotation)

	-- Вычисляем минимальную точку коллизии для идеального приземления
	local lowestY = math.huge
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local partLowestY = part.Position.Y - part.Size.Y / 2
			if partLowestY < lowestY then
				lowestY = partLowestY
			end
		end
	end

	model:PivotTo(model:GetPivot() * CFrame.new(0, targetPosition.Y - lowestY, 0) * CFrame.Angles(0, math.random() * math.pi * 2, 0))
end

--- Возвращает количество предметов
function ItemsHelper.GetInventoryCount(self, inventoryTable)
	if type(inventoryTable) ~= "table" then
		return 0
	end

	local count = 0
	for _ in pairs(inventoryTable) do
		count = count + 1
	end
	return count
end

return ItemsHelper