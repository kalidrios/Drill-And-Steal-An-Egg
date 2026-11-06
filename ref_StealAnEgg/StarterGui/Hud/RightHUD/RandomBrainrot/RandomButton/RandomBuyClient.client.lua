--!strict
-- HUD RandomBrainrot button: al click, dispara la compra del DevProduct
-- "Random_Brainrot_29R" (29 R$) via el UBuyProductEvent del Store. El server
-- valida la entry contra ProductCatalog y abre el prompt nativo de Robux.
--
-- Si el DevProductId aun no esta configurado en ProductCatalog, StoreServer
-- imprime un warn y el prompt no abre.

local RS = game:GetService("ReplicatedStorage")

-- ReplicatedStorage.RemoteGUI does not exist in this rebuild -- Robux dev-product purchases
-- ("Products", see StubService's header) were never built. WaitForChild hung forever here;
-- use FindFirstChild so the button just no-ops with a warn instead of hanging the client.
local RemoteGUI = RS:FindFirstChild("RemoteGUI")
local UBuyProductEvent = RemoteGUI and RemoteGUI:FindFirstChild("UBuyProductEvent")

local button = script.Parent :: ImageButton

-- StoreServer valida por ItemName (matches ProductCatalog.Products[].ItemName)
local ENTRY = { ItemName = "Random_Brainrot_29R" }

local debounce = false

button.MouseButton1Click:Connect(function()
	if not UBuyProductEvent then
		warn("[RandomBuyClient] RemoteGUI/UBuyProductEvent not built in this rebuild -- Robux purchase flow is not implemented yet.")
		return
	end
	if debounce then return end
	debounce = true
	task.delay(1, function() debounce = false end)
	UBuyProductEvent:FireServer(ENTRY)
end)
