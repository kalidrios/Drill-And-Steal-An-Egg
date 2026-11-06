--!strict
-- Close del RobuxShop -> esconde el RobuxShop y REABRE el contenido del AdminPanel
-- (ScrollingFrame), que OpenShopClient habia ocultado.

local button = script.Parent :: ImageButton
button.Active = true

local robuxShop = button:FindFirstAncestor("RobuxShop")
if not robuxShop or not robuxShop:IsA("GuiObject") then
	warn("[CloseShopClient] RobuxShop ancestor no encontrado")
	return
end
local adminPanel = robuxShop:FindFirstAncestor("AdminPanel")

button.MouseButton1Click:Connect(function()
	robuxShop.Visible = false
	if adminPanel then
		local sf = adminPanel:FindFirstChild("ScrollingFrame")
		if sf and sf:IsA("GuiObject") then sf.Visible = true end
	end
end)
