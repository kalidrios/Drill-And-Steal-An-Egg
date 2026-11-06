-- BoostStaminaClient
-- Cablea los botones Boost1/2/3 (HUD.BoostFrame) a la compra de los DevProducts
-- de stamina. Cada boton tiene un atributo "Action" (Boost150K/Boost1M/Boost10M)
-- que mapeamos a su ProductId. Al confirmar la compra en Robux, StoreServer
-- (MarketplaceService.ProcessReceipt) entrega la stamina enorme y actualiza
-- Stamina / StaminaLevel / StaminaMax del jugador.

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- Mismo mapeo de IDs que STAMINA_PRODUCTS en StoreServer.
local ACTION_TO_PRODUCT = {
	Boost150K = 3599631066, -- Boost1: 100B stamina
	Boost1M = 3599631109,   -- Boost2: 100T stamina
	Boost10M = 3599631184,  -- Boost3: inf stamina
}

-- Texto del boton acorde a lo que entrega ahora.
local ACTION_TO_TEXT = {
	Boost150K = "+100B SPEED",
	Boost1M = "+100T SPEED",
	Boost10M = "+INF SPEED",
}

local frame = script.Parent

local function wire(btn)
	if not btn:IsA("TextButton") then return end
	local action = btn:GetAttribute("Action")
	local productId = action and ACTION_TO_PRODUCT[action]
	if not productId then return end
	if ACTION_TO_TEXT[action] then
		btn.Text = ACTION_TO_TEXT[action]
	end
	if btn:GetAttribute("_BoostWired") then return end
	btn:SetAttribute("_BoostWired", true)
	btn.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(player, productId)
	end)
end

for _, d in ipairs(frame:GetDescendants()) do
	wire(d)
end
frame.DescendantAdded:Connect(wire)
