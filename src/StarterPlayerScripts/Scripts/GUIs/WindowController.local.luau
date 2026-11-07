--!strict
--[[
	WindowController.local.luau
	Conecta os botões da HUD (Main.Frame.Left e Right) às ScreenGuis via ImportantWindow.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local LibraryFolder = ReplicatedStorage:WaitForChild("Library", 5) or ReplicatedStorage:WaitForChild("Libray", 5)
local ClientLib = LibraryFolder:WaitForChild("Client")
local ImportantWindow = require(ClientLib:WaitForChild("ImportantWindow"))

-- HUD Principal
local mainGui = PlayerGui:WaitForChild("Main")
local mainFrame = mainGui:WaitForChild("Frame")
local left = mainFrame:WaitForChild("Left")
local right = mainFrame:WaitForChild("Right")

--------------------------------------------------------------------------------
-- 1. left.ShopAndGuild -> ExclusiveShop (Pop)
--------------------------------------------------------------------------------
task.spawn(function()
	local exclusiveShopGui = PlayerGui:WaitForChild("ExclusiveShop") :: ScreenGui
	local shopBtn = left:WaitForChild("ShopAndtrade"):WaitForChild("ExclusiveShop") :: GuiObject
	ImportantWindow.BindButton(shopBtn, exclusiveShopGui, "Pop")
end)

--------------------------------------------------------------------------------
-- 2. left.IndexAndRebrith -> Index (Pop)
--------------------------------------------------------------------------------
task.spawn(function()
	local indexGui = PlayerGui:WaitForChild("Index") :: ScreenGui
	local indexBtn = left:WaitForChild("IndexAndRebrith"):WaitForChild("Index") :: GuiObject
	ImportantWindow.BindButton(indexBtn, indexGui, "Pop")
end)

--------------------------------------------------------------------------------
-- 3. left.IndexAndRebrith -> Rebirth (Pop)
--------------------------------------------------------------------------------
task.spawn(function()
	local rebirthGui = PlayerGui:WaitForChild("Rebirth") :: ScreenGui
	local rebirthBtn = left:WaitForChild("IndexAndRebrith"):WaitForChild("Rebirth") :: GuiObject
	ImportantWindow.BindButton(rebirthBtn, rebirthGui, "Pop")
end)

--------------------------------------------------------------------------------
-- 4. left.Upgrade -> PicaxeShop (Pop)
--------------------------------------------------------------------------------
task.spawn(function()
	local picaxeShopGui = PlayerGui:WaitForChild("PicaxeShop") :: ScreenGui
	local upgradeBtn = left:WaitForChild("Upgrade"):WaitForChild("UpgradeButton") :: GuiObject
	ImportantWindow.BindButton(upgradeBtn, picaxeShopGui, "Pop")
end)

--------------------------------------------------------------------------------
-- 5. right -> Pets & Eggs (Right ScreenGui - SlideRight: Direita para Esquerda)
--------------------------------------------------------------------------------
task.spawn(function()
	local rightGui = PlayerGui:WaitForChild("Right") :: ScreenGui
	local rightContainer = rightGui:WaitForChild("Frame") :: GuiObject

	local petsFrame = rightContainer:WaitForChild("Pets") :: GuiObject
	local eggsFrame = rightContainer:WaitForChild("Eggs") :: GuiObject

	-- Registra Right com animação "SlideRight"
	ImportantWindow.Register(rightGui, rightContainer, "SlideRight")

	local petsBtn = right:WaitForChild("PetsButton") :: GuiObject
	local eggsBtn = right:WaitForChild("EggButton") :: GuiObject

	local function openPets()
		if rightGui.Enabled and petsFrame.Visible then
			ImportantWindow.Close(rightGui)
		else
			eggsFrame.Visible = false
			petsFrame.Visible = true
			ImportantWindow.Open(rightGui)
		end
	end

	local function openEggs()
		if rightGui.Enabled and eggsFrame.Visible then
			ImportantWindow.Close(rightGui)
		else
			petsFrame.Visible = false
			eggsFrame.Visible = true
			ImportantWindow.Open(rightGui)
		end
	end

	petsBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			openPets()
		end
	end)

	eggsBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			openEggs()
		end
	end)

	-- Conecta os botões Close (agora renomeados para Close)
	local function bindCloseBtn(frame: GuiObject)
		local closeBtn = frame:FindFirstChild("Close")
		if closeBtn and closeBtn:IsA("GuiButton") then
			closeBtn.Activated:Connect(function()
				ImportantWindow.Close(rightGui)
			end)
		end
	end

	bindCloseBtn(petsFrame)
	bindCloseBtn(eggsFrame)
end)

print("[WindowController] Botões configurados com animação SlideRight para Right!")