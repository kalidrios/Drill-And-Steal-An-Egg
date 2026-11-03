--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Limited Egg",
	rarity = Rarity.Exclusive,
	icon = "", -- Clean Room placeholder
	iconSettings = {
		imageSize = Vector2.new(260, 261),
		faceTopLeftPixel = Vector2.new(131, 51),
		faceBottomRightPixel = Vector2.new(139, 234),
	},
	disableModifiers = true,
	disableGold = false,
	disableRainbow = false,
	goldChance = 5,
	rainbowChance = 2,
	shinyChance = 2,
	pets = {
		{ "Tung Tung Sahur", 39.0 },
		{ "Bananita Dolphinita", 25.0 },
		{ "Belula Beluga", 20.0 },
		{ "Mangolini Parrochini", 10.0 },
		{ "Bomboclat Crocolat", 5.0 },
		{ "Strawberry Elephant", 1.0 },
	},
}
