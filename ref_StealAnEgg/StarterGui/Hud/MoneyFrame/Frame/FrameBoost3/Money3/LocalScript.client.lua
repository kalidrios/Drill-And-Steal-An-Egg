local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Money3: dinero INFINITO (lo entrega StoreServer.ProcessReceipt; en la UI
-- aparece como "∞" aunque el valor real sea un numero enorme).
local PRODUCT_ID = 3602363824

script.Parent.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(player, PRODUCT_ID)
end)