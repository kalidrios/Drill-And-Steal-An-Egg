-- UpgradesClient: UI апгрейдов BackpackSize и Walkspeed
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local Client = ReplicatedStorage:WaitForChild("Client")
local DataClient = require(Client:WaitForChild("DataClient"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local UpgradeSlot = Remotes:WaitForChild("Server"):WaitForChild("UpgradeSlot")
local UpgradeWalkspeed = Remotes:WaitForChild("Server"):WaitForChild("UpgradeWalkspeed")
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local PurchasesHelper = require(Helpers:WaitForChild("PurchasesHelper"))
local UpgradesHelper = require(Helpers:WaitForChild("UpgradesHelper"))
local Config = require(ReplicatedStorage:WaitForChild("Config"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local Replica = DataClient:GetReplica()
local Data = Replica.Data
local Holder = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("UpgradeFrame"):WaitForChild("UpgradesScrollingFrame"):WaitForChild("Holder")
local UpgradesClient = {
	--- Обновляет стоимость апгрейда рюкзака
	UpdateBackpackSize = function(self)
		local Amount = Holder:WaitForChild("Slots"):WaitForChild("Buttons"):WaitForChild("PurchaseButton"):WaitForChild("Amount")

		if Data.BackpackSize >= UpgradesHelper.MaxBackpackSize then
			Amount.Text = "MAX"
		else
			Amount.Text = "$" .. Formatting:FormatNumber((UpgradesHelper:GetBackpackUpgradeCost(Data.BackpackSize)))
		end
	end,
	UpdateWalkspeed = function(self)
		local Amount = Holder:WaitForChild("Walkspeed"):WaitForChild("Buttons"):WaitForChild("PurchaseButton"):WaitForChild("Amount")
		local currentExtraSpeed = Data.ExtraWalkSpeed or 0

		if 25 + currentExtraSpeed >= UpgradesHelper.MaxWalkspeed then
			Amount.Text = "MAX"
		else
			Amount.Text = "$" .. Formatting:FormatNumber((UpgradesHelper:GetWalkspeedUpgradeCost(currentExtraSpeed)))
		end
	end
}

function UpgradesClient.SetupBackpackSlots(self)
	local Buttons = Holder:WaitForChild("Slots"):WaitForChild("Buttons")
	local PurchaseButton = Buttons:WaitForChild("PurchaseButton")
	local RobuxButton = Buttons:WaitForChild("RobuxButton")
	local Price = RobuxButton:WaitForChild("Price")

	task.spawn(function()
		Price.Text = ("%* %*"):format(utf8.char(57346), (PurchasesHelper:GetProductPrice(Config.Products.Upgrades["+1 Slot"])))
	end)
	UpgradesClient:UpdateBackpackSize()
	PurchaseButton.Activated:Connect(function()
		UpgradeSlot:FireServer("Cash")
	end)
	RobuxButton.Activated:Connect(function()
		UpgradeSlot:FireServer("Robux")
	end)
end

function UpgradesClient.SetupWalkspeed(self)
	local Buttons = Holder:WaitForChild("Walkspeed"):WaitForChild("Buttons")
	local PurchaseButton = Buttons:WaitForChild("PurchaseButton")
	local RobuxButton = Buttons:WaitForChild("RobuxButton")
	local Price = RobuxButton:WaitForChild("Price")

	task.spawn(function()
		Price.Text = ("%* %*"):format(utf8.char(57346), (PurchasesHelper:GetProductPrice(Config.Products.Upgrades["+1 Walkspeed"])))
	end)
	UpgradesClient:UpdateWalkspeed()
	PurchaseButton.Activated:Connect(function()
		UpgradeWalkspeed:FireServer("Cash")
	end)
	RobuxButton.Activated:Connect(function()
		UpgradeWalkspeed:FireServer("Robux")
	end)
end

function UpgradesClient.Listen(self)
	Replica:ListenToChange({ "BackpackSize" }, function()
		UpgradesClient:UpdateBackpackSize()
	end)
	Replica:ListenToChange({ "ExtraWalkSpeed" }, function()
		UpgradesClient:UpdateWalkspeed()
	end)
end

function UpgradesClient.Start(self)
	UpgradesClient:SetupBackpackSlots()
	UpgradesClient:SetupWalkspeed()
	UpgradesClient:Listen()
end

return UpgradesClient