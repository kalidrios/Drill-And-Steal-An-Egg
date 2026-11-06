--[[
	LootService: Спавн лута, подбор предметов, инвентарь
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local DataService = require(ServerScriptService.Server.Services.DataService)
local Databases = ReplicatedStorage:WaitForChild("Databases")
local StagesList = require(Databases:WaitForChild("StagesList"))
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local RaritiesList = require(Databases:WaitForChild("RaritiesList"))

local Assets = ReplicatedStorage:WaitForChild("Assets")
local ItemsFolder = Assets:WaitForChild("Items")
local Stages = game.Workspace:WaitForChild("Stages")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SpawnLootRemote = Remotes:WaitForChild("Server"):WaitForChild("SpawnLoot")
local LootAddedRemote = Remotes:WaitForChild("Client"):WaitForChild("LootAdded")
local LootClaimedRemote = Remotes:WaitForChild("Client"):WaitForChild("LootClaimed")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

-- Порядок редкостей
local RARITY_ORDER = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Godly", "Divine"}
local RARITY_INDEX = {}
for i, name in ipairs(RARITY_ORDER) do
	RARITY_INDEX[name] = i
end

-- Активные лут-модели на карте per player
-- activeLoot[player] = { {model=Model, itemId=string, stageId=number} }
local activeLoot = {}

local PICKUP_DISTANCE = 25 -- studs
local LOOT_LIFETIME = 60 -- сек, через сколько лут исчезает

local LootService = {}

--- Выбирает случайную редкость в диапазоне [minRarity, maxRarity] с учётом Spawnchance
function LootService.RollRarity(minRarity, maxRarity, luck)
	local minIdx = RARITY_INDEX[minRarity] or 1
	local maxIdx = if maxRarity then (RARITY_INDEX[maxRarity] or #RARITY_ORDER) else #RARITY_ORDER

	-- Собираем доступные редкости и их веса
	local pool = {}
	local totalWeight = 0

	for i = minIdx, maxIdx do
		local rarityName = RARITY_ORDER[i]
		local rarityData = RaritiesList[rarityName]
		if rarityData then
			local weight = rarityData.Spawnchance * (1 + (luck or 0) * 0.01)
			table.insert(pool, {name = rarityName, weight = weight})
			totalWeight += weight
		end
	end

	if #pool == 0 then return "Common" end

	-- Weighted random
	local roll = math.random() * totalWeight
	local cumulative = 0
	for _, entry in ipairs(pool) do
		cumulative += entry.weight
		if roll <= cumulative then
			return entry.name
		end
	end

	return pool[#pool].name
end

--- Выбирает случайный предмет указанной редкости
function LootService.GetRandomItem(rarity)
	local candidates = {}
	for itemId, itemData in pairs(ItemsList) do
		if itemData.Rarity == rarity and not itemData.Unobtainable then
			table.insert(candidates, {id = itemId, data = itemData})
		end
	end

	if #candidates == 0 then return nil, nil end

	local chosen = candidates[math.random(1, #candidates)]
	return chosen.id, chosen.data
end

--- Спавнит лут для игрока на стадии
function LootService.SpawnLootForPlayer(player, stageId, spawnPart)
	local stageData = StagesList[stageId]
	if not stageData then return end

	-- Определяем редкость
	local rarity = LootService.RollRarity(stageData.MinimumRarity, stageData.MaxRarity, stageData.Luck or 1)

	-- Выбираем предмет
	local itemId, itemData = LootService.GetRandomItem(rarity)
	if not itemId then return end

	-- Находим спавнпоинт
	local stageFolder = stageData.Folder
	if not stageFolder then return end

	local spawnpointsFolder = stageFolder:FindFirstChild("Spawnpoints")
	if not spawnpointsFolder then return end

	local spawnpoints = spawnpointsFolder:GetChildren()
	if #spawnpoints == 0 then return end

	-- Выбираем свободный спавнпоинт для этого игрока
	local availableSpawns = {}
	for _, part in ipairs(spawnpoints) do
		if part:GetAttribute("ItemId_" .. player.Name) == nil then
			table.insert(availableSpawns, part)
		end
	end

	if #availableSpawns == 0 then return end
	local spawnPart = spawnPart or availableSpawns[math.random(1, #availableSpawns)]

	-- Клонируем модель предмета
	local itemFolder = ItemsFolder:FindFirstChild(itemData.Name)
	if not itemFolder then return end

	local defaultFolder = itemFolder:FindFirstChild("Default")
	if not defaultFolder then return end

	local templateModel = defaultFolder:FindFirstChildWhichIsA("Model")
	if not templateModel then return end

	local model = templateModel:Clone()

	-- Устанавливаем владельца модели
	model:SetAttribute("Owner", player.Name)

	-- Настройка модели
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = false
		end
	end

	-- Устанавливаем атрибут на спавнпоинт для клиента/туториала
	spawnPart:SetAttribute("ItemId_" .. player.Name, itemId)

	-- Позиционирование через ItemsHelper (модель автоматически запарентится в spawnPart)
	local ItemsHelper = require(ReplicatedStorage.Helpers.ItemsHelper)
	ItemsHelper:PlaceItemModel(spawnPart, model, { ItemId = itemId })

	-- Создаем ProximityPrompt прямо на PrimaryPart модели артефакта (для красивого подбора)
	local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
	if primaryPart then
		local proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.MaxActivationDistance = 15
		proximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
		proximityPrompt.ActionText = "Collect"
		proximityPrompt.ObjectText = itemData.Name
		proximityPrompt.RequiresLineOfSight = false
		proximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		proximityPrompt.HoldDuration = 0
		proximityPrompt.Parent = primaryPart

		local connection
		connection = proximityPrompt.Triggered:Connect(function(clickPlayer)
			if clickPlayer ~= player then return end -- только владелец

			-- Проверка лимита рюкзака
			local profile = DataService.GetProfile(player)
			if not profile then return end

			local data = profile.Data
			local inventoryCount = DataService.GetInventoryCount(player)

			if inventoryCount >= data.BackpackSize then
				NotificationRemote:FireClient(player, "Error", "Backpack is Full! Sell items or upgrade your backpack.", 3.5)
				return
			end

			-- Проверка дистанции
			local character = player.Character
			if character then
				local hrp = character:FindFirstChild("HumanoidRootPart")
				if hrp and primaryPart then
					local dist = (hrp.Position - primaryPart.Position).Magnitude
					if dist > proximityPrompt.MaxActivationDistance * 1.5 then return end
				end
			end

			-- Добавляем в инвентарь
			local uniqueId = HttpService:GenerateGUID(false)
			local inventoryItem = {
				ItemId = itemId,
				InTraitMachine = false,
				IsFavorited = false,
				InBackpack = true,
			}

			profile.Replica:SetValue({"Inventory", uniqueId}, inventoryItem)
			DataService.UpdateInventoryCount(player)

			-- Добавляем в коллекцию (Индекс предметов)
			if not table.find(data.InventoryIndex, itemId) then
				profile.Replica:ArrayInsert({"InventoryIndex"}, itemId)
			end

			-- Очищаем атрибут спавнпоинта
			spawnPart:SetAttribute("ItemId_" .. player.Name, nil)

			-- Уведомляем клиент
			LootAddedRemote:FireClient(player, inventoryItem, uniqueId)

			-- Удаляем модель
			connection:Disconnect()
			model:Destroy()

			-- Спавним новый артефакт на том же spawnPart через 1.5 секунды
			task.spawn(function()
				task.wait(1.5)
				if player.Parent then
					LootService.SpawnLootForPlayer(player, stageId, spawnPart)
				end
			end)

			-- Удаляем из activeLoot
			if activeLoot[player] then
				for i, entry in ipairs(activeLoot[player]) do
					if entry.model == model then
						table.remove(activeLoot[player], i)
						break
					end
				end
			end
		end)
	end

	-- Трекинг
	if not activeLoot[player] then activeLoot[player] = {} end
	table.insert(activeLoot[player], {model = model, itemId = itemId, stageId = stageId})

	-- Авто-удаление через 15 секунд + спавн нового артефакта через 1 секунду после исчезновения
	task.delay(15, function()
		if model and model.Parent then
			spawnPart:SetAttribute("ItemId_" .. player.Name, nil)

			-- Плавное исчезновение на клиенте
			pcall(function()
				for _, part in ipairs(model:GetDescendants()) do
					if part:IsA("BasePart") then
						local TweenService = game:GetService("TweenService")
						TweenService:Create(part, TweenInfo.new(0.5), { Transparency = 1 }):Play()
					end
				end
			end)
			task.wait(0.5)

			model:Destroy()

			if activeLoot[player] then
				for i, entry in ipairs(activeLoot[player]) do
					if entry.model == model then
						table.remove(activeLoot[player], i)
						break
					end
				end
			end

			-- Спавним новый артефакт через 1 секунду на том же spawnPart
			task.wait(1)
			if player.Parent then
				LootService.SpawnLootForPlayer(player, stageId, spawnPart)
			end
		end
	end)
end

--- Спавнит глобальный публичный артефакт в мире
function LootService.SpawnGlobalLoot(rarity, position)
	-- Выбираем случайный предмет
	local itemId, itemData = LootService.GetRandomItem(rarity)
	if not itemId then return end

	-- Клонируем модель
	local itemFolder = ItemsFolder:FindFirstChild(itemData.Name)
	if not itemFolder then return end

	local defaultFolder = itemFolder:FindFirstChild("Default")
	if not defaultFolder then return end

	local templateModel = defaultFolder:FindFirstChildWhichIsA("Model")
	if not templateModel then return end

	local model = templateModel:Clone()

	-- Настройка модели
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = false
		end
	end

	-- Позиционируем на указанных координатах
	if model.PrimaryPart then
		model:SetPrimaryPartCFrame(CFrame.new(position))
	else
		local firstPart = model:FindFirstChildWhichIsA("BasePart")
		if firstPart then
			local offset = model:GetBoundingBox()
			model:TranslateBy(position - firstPart.Position)
		end
	end

	model.Parent = workspace

	-- Создаем ProximityPrompt для подбора любым игроком
	local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
	if primaryPart then
		local proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.MaxActivationDistance = 15
		proximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
		proximityPrompt.ActionText = "Collect Public"
		proximityPrompt.ObjectText = string.format("%s (%s)", itemData.Name, rarity)
		proximityPrompt.RequiresLineOfSight = false
		proximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		proximityPrompt.HoldDuration = 0
		proximityPrompt.Parent = primaryPart

		local connection
		connection = proximityPrompt.Triggered:Connect(function(player)
			local profile = DataService.GetProfile(player)
			if not profile then return end

			local data = profile.Data
			local inventoryCount = DataService.GetInventoryCount(player)

			if inventoryCount >= data.BackpackSize then
				NotificationRemote:FireClient(player, "Error", "Backpack is Full! Sell items or upgrade your backpack.", 3.5)
				return
			end

			-- Проверка дистанции
			local character = player.Character
			if character then
				local hrp = character:FindFirstChild("HumanoidRootPart")
				if hrp and primaryPart then
					local dist = (hrp.Position - primaryPart.Position).Magnitude
					if dist > proximityPrompt.MaxActivationDistance * 1.5 then return end
				end
			end

			-- Добавляем в инвентарь
			local uniqueId = HttpService:GenerateGUID(false)
			local inventoryItem = {
				ItemId = itemId,
				InTraitMachine = false,
				IsFavorited = false,
				InBackpack = true,
			}

			profile.Replica:SetValue({"Inventory", uniqueId}, inventoryItem)
			DataService.UpdateInventoryCount(player)

			-- Добавляем в коллекцию (Индекс предметов)
			if not table.find(data.InventoryIndex, itemId) then
				profile.Replica:ArrayInsert({"InventoryIndex"}, itemId)
			end

			-- Уведомляем клиент
			LootAddedRemote:FireClient(player, inventoryItem, uniqueId)

			-- Эффект подбора
			local breakSound = game:GetService("SoundService"):FindFirstChild("Break")
			if breakSound then
				local soundClone = breakSound:Clone()
				soundClone.Parent = player.Character or workspace
				soundClone:Play()
				task.delay(1, function() soundClone:Destroy() end)
			end

			-- Удаляем модель
			connection:Disconnect()
			model:Destroy()
		end)
	end

	-- Авто-удаление через 30 секунд, если никто не собрал
	task.delay(30, function()
		if model and model.Parent then
			pcall(function()
				for _, part in ipairs(model:GetDescendants()) do
					if part:IsA("BasePart") then
						local TweenService = game:GetService("TweenService")
						TweenService:Create(part, TweenInfo.new(0.5), { Transparency = 1 }):Play()
					end
				end
			end)
			task.wait(0.5)
			model:Destroy()
		end
	end)
end

function LootService.ClearAllLootForPlayer(player)
	if activeLoot[player] then
		for _, entry in ipairs(activeLoot[player]) do
			local spawnPart = entry.model and entry.model.Parent
			if spawnPart then
				spawnPart:SetAttribute("ItemId_" .. player.Name, nil)
			end
			if entry.model and entry.model.Parent then
				entry.model:Destroy()
			end
		end
		activeLoot[player] = nil
	end
end

function LootService.Start(self)
	-- FetchRandomItems remote handler
	local FetchRandomItemsRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("FetchRandomItems")
	FetchRandomItemsRemote.OnServerEvent:Connect(function(player)
		local secretId = LootService.GetRandomItem("Secret")
		local godlyId = LootService.GetRandomItem("Godly")
		local divineId = LootService.GetRandomItem("Divine")

		FetchRandomItemsRemote:FireClient(player, {
			["Random Secret"] = secretId,
			["Random Godly"] = godlyId,
			["Random Divine"] = divineId
		})
	end)

	-- Cleanup
	game.Players.PlayerRemoving:Connect(function(player)
		LootService.ClearAllLootForPlayer(player)
	end)

	-- Фоновая очистка лута с предыдущих зон, если игрок ушел вглубь шахты
	task.spawn(function()
		while true do
			task.wait(2)
			for _, player in ipairs(game.Players:GetPlayers()) do
				local char = player.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local currentStageId = nil
					local minDistance = math.huge
					
					for stageId, stageData in ipairs(StagesList) do
						local folder = stageData.Folder
						local hitbox = folder and folder:FindFirstChild("Hitbox")
						if hitbox then
							local dist = (hrp.Position - hitbox.Position).Magnitude
							if dist < 80 and dist < minDistance then
								minDistance = dist
								currentStageId = stageId
							end
						end
					end

					if currentStageId then
						-- 1. Очистка старого лута
						local playerLoot = activeLoot[player]
						if playerLoot then
							local i = 1
							while i <= #playerLoot do
								local entry = playerLoot[i]
								if entry.stageId < currentStageId - 1 then
									local spawnPart = entry.model and entry.model.Parent
									if spawnPart then
										spawnPart:SetAttribute("ItemId_" .. player.Name, nil)
									end
									if entry.model then
										entry.model:Destroy()
									end
									table.remove(playerLoot, i)
								else
									i += 1
								end
							end
						end

						-- 2. Заполнение активных стадий (текущая, предыдущая, следующая)
						for offset = -1, 1 do
							local targetStageId = currentStageId + offset
							local stageData = StagesList[targetStageId]
							if stageData then
								local folder = stageData.Folder
								local spawnpointsFolder = folder and folder:FindFirstChild("Spawnpoints")
								if spawnpointsFolder then
									for _, part in ipairs(spawnpointsFolder:GetChildren()) do
										if part:GetAttribute("ItemId_" .. player.Name) == nil then
											LootService.SpawnLootForPlayer(player, targetStageId, part)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)

	print("[LootService]: Started")
end

return LootService
