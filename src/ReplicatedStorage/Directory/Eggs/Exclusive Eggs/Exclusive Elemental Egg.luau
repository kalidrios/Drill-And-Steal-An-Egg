--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Exclusive Elemental Egg",
	rarity = Rarity.Exclusive,
	icon = "", -- Placeholder (ID de referência original: rbxassetid://15187935439)
	iconSettings = {
		imageSize = Vector2.new(260, 261),
		faceTopLeftPixel = Vector2.new(131, 51),
		faceBottomRightPixel = Vector2.new(139, 234),
	},
	disableModifiers = true,
	disableGold = true,
	disableRainbow = false,
	goldChance = 0,
	rainbowChance = 2,
	shinyChance = 2,
	pets = {
		{ "Prickly Panda", 35 },
		{ "Lightning Bat", 30 },
		{ "Subzero Cat", 20 },
		{ "Inferno Cat", 13 },
		{ "Huge Prickly Panda", 1.5 },
		{ "Huge Inferno Cat", 0.5 },
	},
}
