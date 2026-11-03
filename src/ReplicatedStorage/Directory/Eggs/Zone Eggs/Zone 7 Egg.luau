--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Zone 7 Egg",
	rarity = Rarity.Secret,
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
		{ "Jackalope", 34 },
		{ "DIMETRODON", 24 },
		{ "Brachiosaurus", 18 },
		{ "CERBERUS", 12 },
		{ "Lindworm", 6 },
		{ "Raiju", 3.5 },
		{ "Fenrir", 2 },
		{ "T-Rex", 0.5 },
	},
}
