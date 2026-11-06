--[[
	SellingService: Продажа лута, GotoSurface (телепорт + продажа)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService -- lazy
local StageService -- lazy
local Databases = ReplicatedStorage:WaitForChild("Databases")
local ItemsList = require(Databases:WaitForChild("ItemsList"))
local StagesList = require(Databases:WaitForChild("StagesList"))
local AurasList = require(Databases:WaitForChild("AurasList"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local SellingHelper = require(Helpers:WaitForChild("SellingHelper"))
local IndexHelper = require(Helpers:WaitForChild("IndexHelper"))
local ItemsHelper = require(Helpers:WaitForChild("ItemsHelper"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SellLootRemote = Remotes:WaitForChild("Server"):WaitForChild("SellLoot")
local SellAllLootRemote = Remotes:WaitForChild("Server"):WaitForChild("SellAllLoot")
local GotoSurfaceRemote = Remotes:WaitForChild("Server"):WaitForChild("GotoSurface")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

local Stages = game.Workspace:WaitForChild("Stages")

local SellingService = {}

--- Продать один предмет
function SellingService.SellItem(player, uniqueId)
	local profile = DataService.GetProfile(player)
	if not profile then return 0 end

	local data = profile.Data
	local replica = profile.Replica
	local itemData = data.Inventory[uniqueId]

	if not itemData then return 0 end
	if itemData.InTraitMachine then return 0 end
	if itemData.IsFavorited then return 0 end

	local auraConfig = AurasList[data.EquippedAuraId]
	local auraMultiplier = if auraConfig then auraConfig.Multiplier else 1

	-- Расчёт дохода
	local revenue = SellingHelper:GetRevenue(
		itemData,
		data.Rebirths,
		data.Purchases.CashMultiplier,
		data.TraitIndex,
1,
		auraMultiplier
	)

	if not revenue or revenue <= 0 then return 0 end

	-- Удаляем из инвентаря
	replica:SetValue({"Inventory", uniqueId}, nil)
	DataService.UpdateInventoryCount(player)

	-- Удаляем физический Tool у игрока
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character
	local function removeTool(parent)
		if parent then
			for _, child in ipairs(parent:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("UniqueId") == uniqueId then
					child:Destroy()
				end
			end
		end
	end
	removeTool(backpack)
	removeTool(character)

	-- Начисляем монеты
	replica:SetValue({"Cash"}, data.Cash + revenue)

	DataService.UpdateLeaderstats(player)

	return revenue
end

--- Продать всё
function SellingService.SellAll(player)
	local profile = DataService.GetProfile(player)
	if not profile then return 0 end

	local data = profile.Data
	local replica = profile.Replica
	local totalRevenue = 0
	local auraConfig = AurasList[data.EquippedAuraId]
	local auraMultiplier = if auraConfig then auraConfig.Multiplier else 1

	local toRemove = {}
	for uniqueId, itemData in pairs(data.Inventory) do
		if not itemData.InTraitMachine and not itemData.IsFavorited then
			local revenue = SellingHelper:GetRevenue(
				itemData,
				data.Rebirths,
				data.Purchases.CashMultiplier,
				data.TraitIndex,
		1,
				auraMultiplier
			)
			if revenue and revenue > 0 then
				totalRevenue += revenue
				table.insert(toRemove, uniqueId)
			end
		end
	end

	for _, uniqueId in ipairs(toRemove) do
		replica:SetValue({"Inventory", uniqueId}, nil)
	end
	DataService.UpdateInventoryCount(player)

	-- Удаляем все физические инструменты артефактов
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character
	local function removeAllTools(parent)
		if parent then
			for _, child in ipairs(parent:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("UniqueId") then
					child:Destroy()
				end
			end
		end
	end
	removeAllTools(backpack)
	removeAllTools(character)

	if totalRevenue > 0 then
		replica:SetValue({"Cash"}, data.Cash + totalRevenue)
		DataService.UpdateLeaderstats(player)
	end

	return totalRevenue
end

--- Телепорт на поверхность
function SellingService.GotoSurface(player)
	-- Телепорт на SpawnLocation игроков
	local spawnLocation = game.Workspace:FindFirstChild("Map")
		and game.Workspace.Map:FindFirstChild("PropsAndMisc")
		and game.Workspace.Map.PropsAndMisc:FindFirstChild("Blocks")
		and game.Workspace.Map.PropsAndMisc.Blocks:FindFirstChild("Spawn")
		and game.Workspace.Map.PropsAndMisc.Blocks.Spawn:FindFirstChild("SpawnLocation")

	if spawnLocation then
		local character = player.Character
		if character then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.CFrame = spawnLocation.CFrame + Vector3.new(0, 4, 0)
			end
		end
	end

	-- Сбрасываем флаг InBackpack для всех собранных в пещере предметов
	local profile = DataService.GetProfile(player)
	if profile then
		for uniqueId, item in pairs(profile.Data.Inventory) do
			if item.InBackpack then
				profile.Replica:SetValue({"Inventory", uniqueId, "InBackpack"}, nil)
			end
		end
		DataService.UpdateInventoryCount(player)
	end

	-- Очищаем парящий лут игрока с карты
	local LootService = require(ServerScriptService.Server.Services.LootService)
	LootService.ClearAllLootForPlayer(player)

	-- Сбрасываем стены
	StageService.ResetAllWalls(player)

	-- Выдаем артефакты в физический инвентарь игрока
	SellingService.GiveInventoryTools(player)
end

--- Выдает физические инструменты для всех артефактов в инвентаре
function SellingService.GiveInventoryTools(player)
	local profile = DataService.GetProfile(player)
	if not profile then return end

	local data = profile.Data
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return end

	-- Очищаем старые физические инструменты артефактов
	for _, child in ipairs(backpack:GetChildren()) do
		if child:IsA("Tool") and child:GetAttribute("UniqueId") then
			child:Destroy()
		end
	end
	if player.Character then
		for _, child in ipairs(player.Character:GetChildren()) do
			if child:IsA("Tool") and child:GetAttribute("UniqueId") then
				child:Destroy()
			end
		end
	end

	-- Выдаем физический Tool для каждого предмета
	local ItemsHelper = require(ReplicatedStorage.Helpers.ItemsHelper)
	for uniqueId, item in pairs(data.Inventory) do
		local itemData = ItemsList[item.ItemId]
		if itemData and not item.InTraitMachine then
			local tool = Instance.new("Tool")
			tool.Name = itemData.Name
			tool.RequiresHandle = false
			tool:SetAttribute("UniqueId", uniqueId)

			local model = ItemsHelper:GetItemModel(item)
			if model then
				local handle = model:FindFirstChild("Handle") or model:FindFirstChildWhichIsA("BasePart")
				if handle then
					local clonedHandle = handle:Clone()
					clonedHandle.Name = "Handle"
					clonedHandle.Parent = tool
					
					for _, child in ipairs(model:GetChildren()) do
						if child ~= handle then
							child:Clone().Parent = tool
						end
					end
				else
					local newHandle = Instance.new("Part")
					newHandle.Name = "Handle"
					newHandle.Size = Vector3.new(1, 1, 1)
					newHandle.Transparency = 1
					newHandle.Parent = tool
					
					model.Parent = tool
				end
			end

			tool.Parent = backpack
		end
	end
end

function SellingService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)
	StageService = require(ServerScriptService.Server.Services.StageService)

	SellLootRemote.OnServerEvent:Connect(function(player, uniqueId)
		if type(uniqueId) ~= "string" then return end
		SellingService.SellItem(player, uniqueId)
	end)

	SellAllLootRemote.OnServerEvent:Connect(function(player)
		SellingService.SellAll(player)
	end)

	GotoSurfaceRemote.OnServerEvent:Connect(function(player)
		SellingService.GotoSurface(player)
	end)

	print("[SellingService]: Started")
end

return SellingService