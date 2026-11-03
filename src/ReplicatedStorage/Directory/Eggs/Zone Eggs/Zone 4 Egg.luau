--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Zone 4 Egg",
	rarity = Rarity.Epic,
	icon = "", -- Clean Room placeholder
	iconSettings = {
		imageSize = Vector2.new(260, 261),
		faceTopLeftPixel = Vector2.new(131, 51),
		faceBottomRightPixel = Vector2.new(139, 234),
	},
	disableModifiers = false,
	disableGold = false,
	disableRainbow = false,
	goldChance = 5,
	rainbowChance = 2,
	shinyChance = 2,
	pets = {
		{ "Bunny", 34 },
		{ "trumpet", 24 },
		{ "Moorish idol", 18 },
		{ "barracuda", 12 },
		{ "Muscovy Duck", 6 },
		{ "Yak", 3.5 },
		{ "Cobra", 2 },
		{ "PREHISTORIC_DRAGONFLY", 0.5 },
	},
}
