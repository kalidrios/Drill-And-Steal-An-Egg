-- AurasClient: UI магазина аур, покупка, экипировка и визуальное отображение аур на персонаже

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = game.Players.LocalPlayer
local Databases = ReplicatedStorage:WaitForChild("Databases")
local AurasList = require(Databases:WaitForChild("AurasList"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PurchaseAuraRemote = Remotes:WaitForChild("Server"):WaitForChild("PurchaseAura")
local EquipAuraRemote = Remotes:WaitForChild("Server"):WaitForChild("EquipAura")
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local PurchasesHelper = require(Helpers:WaitForChild("PurchasesHelper"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local AurasAssets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Auras")
local AurasHolder = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("AurasFrame"):WaitForChild("AuraScrollingFrame"):WaitForChild("Holder")
local Replica = DataClient:GetReplica()
local Data = Replica.Data
local AurasClient = {}

--- Очищает текущие визуальные эффекты аур на персонаже
function AurasClient.ClearAura(self, character)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	for _, child in ipairs(humanoidRootPart:GetChildren()) do
		if child:GetAttribute("Aura") then
			child:Destroy()
		end
	end
end

--- Накладывает эффекты экипированной ауры на персонажа
function AurasClient.ApplyAura(self)
	local character = LocalPlayer.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	AurasClient:ClearAura(character)

	local equippedAuraId = Data.EquippedAuraId
	if not table.find(Data.Auras, equippedAuraId) then
		return
	end

	local auraConfig = AurasList[equippedAuraId]
	if not auraConfig then
		return
	end

	local auraTemplate = auraConfig.Aura or AurasAssets:FindFirstChild(equippedAuraId)
	if auraTemplate then
		local clonedAura = auraTemplate:Clone()
		clonedAura:SetAttribute("Aura", true)
		clonedAura.Parent = humanoidRootPart
	end
end

--- Обновляет статус кнопок конкретной ауры в магазине
function AurasClient.UpdateFrame(self, auraId)
	local auraConfig = AurasList[auraId]
	if not auraConfig then
		return
	end

	local frame = AurasHolder:FindFirstChild(auraId)
	if not frame then
		return
	end

	local PurchaseButton = frame:WaitForChild("Buttons"):WaitForChild("PurchaseButton")
	local RobuxButton = frame:WaitForChild("Buttons"):WaitForChild("RobuxButton")
	local Amount = PurchaseButton:WaitForChild("Amount")
	local Price = RobuxButton:WaitForChild("Price")
	local isOwned = table.find(Data.Auras, auraId)

	RobuxButton.Visible = not isOwned
	PurchaseButton.Visible = true

	if Data.EquippedAuraId == auraId then
		Amount.Text = "Unequip"
		return
	end

	if isOwned then
		Amount.Text = "Equip"
	else
		Amount.Text = ("$%*"):format((Formatting:FormatNumber(auraConfig.Price)))
		task.spawn(function()
			Price.Text = ("%* %*"):format(utf8.char(57346), (PurchasesHelper:GetProductPrice(auraConfig.ProductId)))
		end)
	end
end

--- Инициализирует плашки магазина аур
function AurasClient.CreateFrames(self)
	for auraId, auraConfig in pairs(AurasList) do
		local frame = AurasHolder:FindFirstChild(auraId)

		if frame then
			local PurchaseButton = frame:WaitForChild("Buttons"):WaitForChild("PurchaseButton")
			local RobuxButton = frame:WaitForChild("Buttons"):WaitForChild("RobuxButton")
			local Title = frame:WaitForChild("Title")
			local Amount = PurchaseButton:WaitForChild("Amount")
			local Boost = frame:WaitForChild("Boost")

			Title.Text = auraId
			Boost.Text = ("%*x Boost"):format(auraConfig.Multiplier)
			Amount.Text = ("$%*"):format((Formatting:FormatNumber(auraConfig.Price)))

			PurchaseButton.Activated:Connect(function()
				PurchaseAuraRemote:FireServer(auraId)
			end)

			RobuxButton.Activated:Connect(function()
				if table.find(Data.Auras, auraId) then
					EquipAuraRemote:FireServer(auraId)
					return
				end

				if not auraConfig.ProductId or auraConfig.ProductId == 0 then
					return
				end

				MarketplaceService:PromptProductPurchase(LocalPlayer, auraConfig.ProductId)
			end)

			AurasClient:UpdateFrame(auraId)
		end
	end
end

function AurasClient.OnCharacterAdded(self)
	task.wait(0.1)
	AurasClient:ApplyAura()
end

function AurasClient.Listen(self)
	Replica:ListenToChange({ "Auras" }, function(_, newAuraId)
		AurasClient:UpdateFrame(newAuraId)
	end)

	Replica:ListenToChange({ "EquippedAuraId" }, function()
		for auraId in pairs(AurasList) do
			AurasClient:UpdateFrame(auraId)
		end

		AurasClient:ApplyAura()
	end)
end

function AurasClient.Start(self)
	AurasClient:Listen()
	AurasClient:CreateFrames()
end

return AurasClient