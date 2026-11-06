local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local buttonAnimation = require(ReplicatedStorage.Library.Modules:WaitForChild("ButtonAnimation"))
local trollButton = script.Parent
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local trollGui = playerGui:WaitForChild("Troll")

buttonAnimation.CreateButton(trollButton)
for _, descendant in ipairs(trollGui:GetDescendants()) do
	if descendant:IsA("GuiButton") then
		buttonAnimation.CreateButton(descendant)
	end
end

local savedStates = nil

local function openTroll()
	if trollGui.Enabled then
		return
	end
	savedStates = {}
	for _, gui in ipairs(playerGui:GetChildren()) do
		if gui:IsA("ScreenGui") and gui ~= trollGui then
			savedStates[gui] = gui.Enabled
			gui.Enabled = false
		end
	end
	trollGui.Enabled = true
end

local function closeTroll()
	trollGui.Enabled = false
	if savedStates then
		for gui, wasEnabled in pairs(savedStates) do
			if gui.Parent then
				gui.Enabled = wasEnabled
			end
		end
		savedStates = nil
	end
end

trollButton.Activated:Connect(openTroll)
trollGui:WaitForChild("Back").Activated:Connect(closeTroll)