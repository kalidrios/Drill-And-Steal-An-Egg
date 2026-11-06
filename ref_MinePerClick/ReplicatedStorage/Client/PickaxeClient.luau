-- PickaxeClient: UI магазина кирок (purchase/equip)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PurchasePickaxe = Remotes:WaitForChild("Server"):WaitForChild("PurchasePickaxe")
local EquipPickaxe = Remotes:WaitForChild("Server"):WaitForChild("EquipPickaxe")
local Databases = ReplicatedStorage:WaitForChild("Databases")
local PickaxeList = require(Databases:WaitForChild("PickaxeList"))
local RaritiesList = require(Databases:WaitForChild("RaritiesList"))
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local PurchasesHelper = require(Helpers:WaitForChild("PurchasesHelper"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Replica = DataClient:GetReplica()
local Data = Replica.Data
local Holder = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("PickaxeFrame"):WaitForChild("PickaxesScrollingFrame"):WaitForChild("Holder")
local PickaxeClient = {
	--- Обновляет состояние кнопок для одной кирки
	UpdateFrame = function(self, pickaxeId)
		local frame = Holder:FindFirstChild(pickaxeId)
		if not frame then return end

		local pickaxeData = PickaxeList[pickaxeId]
		if not pickaxeData then return end

		local Buttons = frame:WaitForChild("Buttons")
		local PurchaseButton = Buttons:WaitForChild("PurchaseButton")
		local RobuxButton = Buttons:WaitForChild("RobuxButton")
		local Amount = PurchaseButton:WaitForChild("Amount")
		local isOwned = table.find(Data.Pickaxes, pickaxeId)

		RobuxButton.Visible = pickaxeData.ProductId or pickaxeData.GamepassId
		PurchaseButton.Visible = true

		if isOwned then
			RobuxButton.Visible = false
		end

		if pickaxeData.GamepassId and not isOwned then
			PurchaseButton.Visible = false
			RobuxButton.Visible = true

			return
		end

		if Data.EquippedPickaxeId == pickaxeId then
			Amount.Text = "Equipped"

			return
		end

		if isOwned then
			Amount.Text = "Equip"

			return
		end

		if not pickaxeData.Price then
			return
		end

		Amount.Text = ("$%*"):format((Formatting:FormatNumber(pickaxeData.Price)))
	end
}

function PickaxeClient.UpdateFrames(self)
	for pickaxeId in pairs(PickaxeList) do
		PickaxeClient:UpdateFrame(pickaxeId)
	end
end

function PickaxeClient.SetupFrame(self, pickaxeId)
	local frame = Holder:FindFirstChild(pickaxeId)
	if not frame then return end

	local pickaxeData = PickaxeList[pickaxeId]
	if not pickaxeData then return end

	frame.Name = pickaxeId
	frame:WaitForChild("Title").Text = pickaxeData.Name

	local Rarity = frame:WaitForChild("Rarity")
	Rarity.Text = pickaxeData.Rarity

	local rarityData = RaritiesList[pickaxeData.Rarity]
	if rarityData then
		rarityData.Gradient:Clone().Parent = Rarity
		rarityData.Gradient:Clone().Parent = frame
	end

	frame:WaitForChild("Strength"):WaitForChild("Amount").Text = ("+%*"):format((Formatting:FormatNumber(pickaxeData.Strength)))

	local Buttons = frame:WaitForChild("Buttons")
	local PurchaseButton = Buttons:WaitForChild("PurchaseButton")
	local RobuxButton = Buttons:WaitForChild("RobuxButton")
	local Price = RobuxButton:WaitForChild("Price")

	PurchaseButton.Activated:Connect(function()
		if Data.EquippedPickaxeId == pickaxeId then
			return
		end
		if table.find(Data.Pickaxes, pickaxeId) then
			EquipPickaxe:FireServer(pickaxeId)
		else
			PurchasePickaxe:FireServer(pickaxeId, "Cash")
		end
	end)
	RobuxButton.Activated:Connect(function()
		PurchasePickaxe:FireServer(pickaxeId, "Robux")
	end)
	task.spawn(function()
		if pickaxeData.ProductId then
			Price.Text = ("%* %*"):format(utf8.char(57346), (PurchasesHelper:GetProductPrice(pickaxeData.ProductId)))
		end
		if not pickaxeData.GamepassId then
			return
		end
		Price.Text = ("%* %*"):format(utf8.char(57346), (PurchasesHelper:GetGamepassPrice(pickaxeData.GamepassId)))
	end)
	PickaxeClient:UpdateFrame(pickaxeId)
end

function PickaxeClient.SetupFrames(self)
	for pickaxeId in pairs(PickaxeList) do
		PickaxeClient:SetupFrame(pickaxeId)
	end
end

function PickaxeClient.Listen(self)
	Replica:ListenToArrayInsert({ "Pickaxes" }, function()
		PickaxeClient:UpdateFrames()
	end)
	Replica:ListenToChange({ "EquippedPickaxeId" }, function()
		PickaxeClient:UpdateFrames()
	end)
	PurchasePickaxe.OnClientEvent:Connect(function()
		game:GetService("SoundService"):FindFirstChild("Purchase"):Play()
	end)
end

function PickaxeClient.Start(self)
	PickaxeClient:SetupFrames()
	PickaxeClient:Listen()
end

return PickaxeClient