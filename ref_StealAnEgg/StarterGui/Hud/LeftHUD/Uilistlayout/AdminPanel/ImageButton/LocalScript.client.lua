local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local ADMIN_NAME = "thehalconyt1"
local GAMEPASS_ID = 1963825934 -- "Admin Panel" real, Creator Dashboard

local player = Players.LocalPlayer
local button = script.Parent :: GuiButton

-- Este boton del HUD (Hud.LeftHUD.Uilistlayout.AdminPanel) es solo el icono/rotulo.
-- El panel de verdad es "PlayerGui.Frames.AdminPanel" (StarterGui.Frames.AdminPanel).
--
-- Sesion 12, tercera vuelta: el user pidio vender el panel COMPLETO (mismas herramientas
-- que ADMIN_NAME) via este gamepass real a cualquier jugador. thehalconyt1 lo abre gratis;
-- cualquier otro jugador ve el mismo boton, y al tocarlo: si ya tiene el gamepass, abre el
-- panel; si no, le prompea la compra. El server (AdminPanelHandler.isAdmin) valida esto
-- mismo de nuevo antes de dejar que ningun remote haga nada -- este script solo decide si
-- MOSTRAR el panel, nunca es la autoridad real.

local isFreeAdmin = player.Name == ADMIN_NAME
local ownsGamepass = false

if not isFreeAdmin then
	local ok, owns = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
	end)
	if ok then
		ownsGamepass = owns
	end
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, passId, wasPurchased)
	if plr == player and passId == GAMEPASS_ID and wasPurchased then
		ownsGamepass = true
	end
end)

button.Visible = true

local playerGui = player:WaitForChild("PlayerGui")
local frames = playerGui:WaitForChild("Frames")
local adminPanel = frames:WaitForChild("AdminPanel") :: Frame

-- BUG FIX (user report: "si ya lo tiene comprado se le abre la GUI -- no funciona"). ownsGamepass
-- solo se comprobaba UNA VEZ al cargar el script (arriba); si esa llamada a
-- UserOwnsGamePassAsync fallaba en silencio (pcall ok=false -- red lenta al justo cargar el
-- PlayerGui, throttle, lo que sea) ownsGamepass se quedaba en false PARA SIEMPRE, sin reintento
-- -- un jugador que YA tenia el gamepass comprado de antes podia quedar atrapado viendo el prompt
-- de compra cada vez que tocaba el boton, sin abrir nunca el panel. Ahora, si el flag en memoria
-- dice que no lo tiene, se vuelve a comprobar la posesion real justo antes de decidir -- solo
-- entonces, si de verdad no lo tiene, se muestra el prompt de compra.
local function toggleMenu()
	if isFreeAdmin or ownsGamepass then
		adminPanel.Visible = not adminPanel.Visible
		return
	end

	local ok, owns = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
	end)
	if ok and owns then
		ownsGamepass = true
		adminPanel.Visible = not adminPanel.Visible
		return
	end

	MarketplaceService:PromptGamePassPurchase(player, GAMEPASS_ID)
end

button.Activated:Connect(toggleMenu)
