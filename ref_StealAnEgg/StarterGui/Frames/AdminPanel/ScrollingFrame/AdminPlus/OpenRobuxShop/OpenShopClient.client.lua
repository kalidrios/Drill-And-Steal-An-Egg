local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local button = script.Parent :: ImageButton
button.Active = true
local GAMEPASS_ID = 1963825934
local player = Players.LocalPlayer
local adminPanel = button:FindFirstAncestor("AdminPanel")
if not adminPanel then
	warn("[AdminPanelRobuxShop] AdminPanel ancestor not found")
	return
end

button.Activated:Connect(function()
	MarketplaceService:PromptGamePassPurchase(player, GAMEPASS_ID)
end)