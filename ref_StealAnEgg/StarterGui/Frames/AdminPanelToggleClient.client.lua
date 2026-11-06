-- StarterGui.Frames.AdminPanelToggleClient
-- Replaces the source game's AdminPlusToggleClient, which expected a SEPARATE, never-exported
-- "StarterGui.AdminPlus.Admin" panel (its own comment called it "para testear rapido sin
-- depender del gamepass del AdminPanel principal" -- a free/no-gamepass shortcut to the SAME
-- tools as the main panel). That second panel was never actually part of the copied bundle
-- (only its toggle script was -- see chat summary), and this game has no gamepass/purchase
-- flow wired for the panel either (no ProductCatalog/ProcessReceipt exist here at all). So:
-- this script IS that free shortcut, just pointed straight at the real, only panel
-- (StarterGui.Frames.AdminPanel) instead of a duplicate that was never built.
--
-- SOLO thehalconyt1: escribir "/admin" en el chat abre el panel, "/unadmin" lo cierra.

local Players = game:GetService("Players")

local ADMIN_NAME = "thehalconyt1"
local player = Players.LocalPlayer

if player.Name ~= ADMIN_NAME then
	script:Destroy()
	return
end

local playerGui = player:WaitForChild("PlayerGui")
local frames = playerGui:WaitForChild("Frames")
local adminPanel = frames:WaitForChild("AdminPanel") :: Frame
adminPanel.Visible = false -- hidden by default, only this admin can ever show it

local function handleChatCommand(message: string)
	if typeof(message) ~= "string" then
		return
	end
	local trimmed = message:lower():match("^%s*(.-)%s*$") or ""
	if trimmed == "/admin" then
		adminPanel.Visible = true
	elseif trimmed == "/unadmin" then
		adminPanel.Visible = false
	end
end

player.Chatted:Connect(handleChatCommand)
