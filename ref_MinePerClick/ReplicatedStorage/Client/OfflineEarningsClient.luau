-- OfflineEarningsClient: Показ офлайн-заработка (Strength + Cash)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local InterfaceClient = require(script.Parent:WaitForChild("InterfaceClient"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Formatting = require(Utils:WaitForChild("Formatting"))
local ShowOfflineEarnings = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("ShowOfflineEarnings")
local OfflineEarningsFrame = LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("OfflineEarningsFrame")
local StrengthAmount = OfflineEarningsFrame:WaitForChild("StrengthEarnings"):WaitForChild("Amount")
local CashAmount = OfflineEarningsFrame:WaitForChild("CashEarnings"):WaitForChild("Amount")

local OfflineEarningsClient = {
	--- Показывает окно офлайн-заработка
	ShowOfflineEarnings = function(self, strengthEarned, cashEarned)
		StrengthAmount.Text = "+" .. Formatting:FormatNumber(strengthEarned)
		CashAmount.Text = "+" .. Formatting:FormatNumber(cashEarned)
		InterfaceClient:Open(InterfaceClient.Frames.OfflineEarningsFrame)
	end
}

function OfflineEarningsClient.Listen(self)
	ShowOfflineEarnings.OnClientEvent:Connect(function(strengthEarned, cashEarned)
		OfflineEarningsClient:ShowOfflineEarnings(strengthEarned, cashEarned)
	end)
end

function OfflineEarningsClient.Start(self)
	OfflineEarningsClient:Listen()
end

return OfflineEarningsClient