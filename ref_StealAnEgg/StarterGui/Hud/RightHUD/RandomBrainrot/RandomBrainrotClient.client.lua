--!strict
-- RandomBrainrotClient
-- Click en RandomButton -> prompt de DevProduct real (3709337621, consumible: se puede comprar
-- múltiples veces). El grant real vive en
-- ServerScriptService.Controllers.AmonetizationPurchaseService.ProcessReceipt
-- (RANDOM_BUTTON_PRODUCT_ID -> grantRandomCreature): elige un animal al azar entre TODOS los de
-- Assets.Directory y lo mete directo en el Inventory con un tamaño sesgado a "muy grande/gigante"
-- (RANDOM_BUTTON_SIZE_TIERS, ahí mismo). Nota: el StoreServer/ProductCatalog que mencionaba este
-- comentario antes nunca llegó a existir -- era un plan viejo, no una pieza perdida.

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")

local RANDOM_BRAINROT_PRODUCT_ID = 3709337621

local player = Players.LocalPlayer
local frame = script.Parent :: Frame
local btn = frame:WaitForChild("RandomButton") :: ImageButton

-- =====================================================
-- Click: prompt de compra
-- =====================================================
btn.MouseButton1Click:Connect(function()
	if RANDOM_BRAINROT_PRODUCT_ID == 0 then
		StarterGui:SetCore("SendNotification", {
			Title = "Random Brainrot",
			Text = "DevProductId no configurado. Edita RandomBrainrotClient.",
			Duration = 4,
		})
		return
	end
	local ok, err = pcall(function()
		MarketplaceService:PromptProductPurchase(player, RANDOM_BRAINROT_PRODUCT_ID)
	end)
	if not ok then warn("[RandomBrainrot] prompt error:", err) end
end)

print("[RandomBrainrotClient] loaded.")
