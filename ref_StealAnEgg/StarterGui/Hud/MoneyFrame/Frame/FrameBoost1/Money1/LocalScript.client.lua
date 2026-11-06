local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Money1: +100 Cuatrillones de dinero (lo entrega StoreServer.ProcessReceipt).
local PRODUCT_ID = 3602363703

script.Parent.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(player, PRODUCT_ID)
end)