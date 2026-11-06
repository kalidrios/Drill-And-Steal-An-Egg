--[[
	PickaxeService: Покупка и экипировка кирок (с поддержкой GamePass кирок)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

local DataService -- lazy
local Databases = ReplicatedStorage:WaitForChild("Databases")
local PickaxeList = require(Databases:WaitForChild("PickaxeList"))

local Assets = ReplicatedStorage:WaitForChild("Assets")
local PickaxesAssets = Assets:WaitForChild("Pickaxes")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PurchasePickaxeRemote = Remotes:WaitForChild("Server"):WaitForChild("PurchasePickaxe")
local EquipPickaxeRemote = Remotes:WaitForChild("Server"):WaitForChild("EquipPickaxe")
local NotificationRemote = Remotes:WaitForChild("Client"):WaitForChild("Notification")

local PickaxeService = {}

--- Выдаёт инструмент кирки игроку в Backpack
function PickaxeService.GivePickaxeTool(player, pickaxeName)
	local character = player.Character
	if not character then return end

	-- Удаляем старую кирку из Backpack и Character
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		for _, tool in ipairs(backpack:GetChildren()) do
			if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
				tool:Destroy()
			end
		end
	end
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
			tool:Destroy()
		end
	end

	-- Находим ассет кирки
	local pickaxeAsset = PickaxesAssets:FindFirstChild(pickaxeName)
	if not pickaxeAsset then
		-- Пробуем найти в Gears
		local gearsAssets = Assets:FindFirstChild("Gears")
		if gearsAssets then
			pickaxeAsset = gearsAssets:FindFirstChild(pickaxeName)
		end
	end

	if pickaxeAsset and pickaxeAsset:IsA("Tool") then
		local tool = pickaxeAsset:Clone()
		tool:SetAttribute("Pickaxe", true)
		tool.Parent = backpack or player
	elseif pickaxeAsset then
		-- Если это Folder/Model, создаём Tool
		local tool = Instance.new("Tool")
		tool.Name = pickaxeName
		tool:SetAttribute("Pickaxe", true)
		tool.CanBeDropped = false

		local handle = pickaxeAsset:FindFirstChild("Handle") or pickaxeAsset:FindFirstChildWhichIsA("BasePart")
		if handle then
			local clonedHandle = handle:Clone()
			clonedHandle.Name = "Handle"
			clonedHandle.Parent = tool
		end

		tool.Parent = backpack or player
	else
		-- Фоллбэк: создаём пустой Tool
		local tool = Instance.new("Tool")
		tool.Name = pickaxeName
		tool:SetAttribute("Pickaxe", true)
		tool.CanBeDropped = false

		local handle = Instance.new("Part")
		handle.Name = "Handle"
		handle.Size = Vector3.new(1, 1, 4)
		handle.Transparency = 1
		handle.Parent = tool

		tool.Parent = backpack or player
	end
end

function PickaxeService.OnCharacterAdded(self, player, character)
	-- Выдаём кирку при спавне
	task.defer(function()
		local profile = DataService and DataService.GetProfile(player)
		if profile then
			PickaxeService.GivePickaxeTool(player, profile.Data.EquippedPickaxeId)
		end
	end)
end

function PickaxeService.Start(self)
	DataService = require(ServerScriptService.Server.Services.DataService)

	PurchasePickaxeRemote.OnServerEvent:Connect(function(player, pickaxeName, currency)
		if type(pickaxeName) ~= "string" then return end

		local pickaxeData = PickaxeList[pickaxeName]
		if not pickaxeData then return end

		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data
		local replica = profile.Replica

		-- Уже куплена?
		if table.find(data.Pickaxes, pickaxeName) then
			NotificationRemote:FireClient(player, "Already Owned", "You already own this pickaxe.")
			return
		end

		-- Robux покупка?
		if currency == "Robux" then
			if pickaxeData.GamepassId then
				-- Проверяем, куплен ли уже геймпасс
				local ownsPass = false
				pcall(function()
					ownsPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, pickaxeData.GamepassId)
				end)

				if ownsPass then
					-- Уже куплен — выдаём сразу
					if not table.find(data.Pickaxes, pickaxeName) then
						replica:ArrayInsert({"Pickaxes"}, pickaxeName)
					end
					replica:SetValue({"EquippedPickaxeId"}, pickaxeName)
					PickaxeService.GivePickaxeTool(player, pickaxeName)
					DataService.UpdateLeaderstats(player)
					NotificationRemote:FireClient(player, "Equipped!", "You equipped " .. pickaxeName)
				else
					-- Промптим покупку геймпаса
					MarketplaceService:PromptGamePassPurchase(player, pickaxeData.GamepassId)
				end
			elseif pickaxeData.ProductId then
				-- Промптим покупку Developer Product
				MarketplaceService:PromptProductPurchase(player, pickaxeData.ProductId)
			end
			return
		end

		-- Обычная покупка за Cash
		-- Проверка цены
		local price = pickaxeData.Price or 0
		if data.Cash < price then
			NotificationRemote:FireClient(player, "Not Enough Coins", "You need $" .. tostring(price))
			return
		end

		-- Списываем монеты
		replica:SetValue({"Cash"}, data.Cash - price)
		replica:ArrayInsert({"Pickaxes"}, pickaxeName)

		-- Авто-экипировка
		replica:SetValue({"EquippedPickaxeId"}, pickaxeName)
		PickaxeService.GivePickaxeTool(player, pickaxeName)

		DataService.UpdateLeaderstats(player)
		NotificationRemote:FireClient(player, "Purchased!", "You bought " .. pickaxeName)
	end)

	EquipPickaxeRemote.OnServerEvent:Connect(function(player, pickaxeName)
		if type(pickaxeName) ~= "string" then return end

		local pickaxeData = PickaxeList[pickaxeName]
		if not pickaxeData then return end

		local profile = DataService.GetProfile(player)
		if not profile then return end

		local data = profile.Data
		if not table.find(data.Pickaxes, pickaxeName) then return end

		profile.Replica:SetValue({"EquippedPickaxeId"}, pickaxeName)
		PickaxeService.GivePickaxeTool(player, pickaxeName)
	end)

	print("[PickaxeService]: Started")
end

return PickaxeService
