--!strict
-- Cuando la tienda real (StarterGui.Shop) se cierra por CUALQUIER via (su propio
-- Close, o ButtonAnimation cerrandola automaticamente al abrir otro popup del HUD),
-- restaura visible el contenido del AdminPanel (ScrollingFrame), por si la tienda
-- se abrio desde ahi (ver OpenShopClient en AdminPanel.ScrollingFrame.AdminPlus.
-- OpenRobuxShop, que hace scrolling.Visible = false antes de abrir la tienda).
-- No-op si el AdminPanel no estaba abierto/oculto por ese flujo.
--
-- Reescrito en sesion 12: la version original esperaba estar parenteado dentro de
-- una Frame "Shop67" (Visible), que no existe en este juego -- la tienda real es
-- el ScreenGui StarterGui.Shop (toggleado via ButtonAnimation.ToggleFrame, que
-- cambia .Enabled, no .Visible).

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shop = script.Parent :: ScreenGui

shop:GetPropertyChangedSignal("Enabled"):Connect(function()
	if shop.Enabled then return end
	local frames = playerGui:FindFirstChild("Frames")
	local adminPanel = frames and frames:FindFirstChild("AdminPanel")
	local scrolling = adminPanel and adminPanel:FindFirstChild("ScrollingFrame")
	if scrolling and scrolling:IsA("GuiObject") then
		scrolling.Visible = true
	end
end)
