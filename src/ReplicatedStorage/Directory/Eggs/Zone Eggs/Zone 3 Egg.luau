--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Zone 3 Egg",
	rarity = Rarity.Rare,
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
		{ "Pigeon", 35 },
		{ "GuiennaPig", 25 },
		{ "Goat", 17 },
		{ "Llama", 12 },
		{ "BichonFrise", 5 },
		{ "Maltese", 3.5 },
		{ "SecretaryBird", 2 },
		{ "Polar Bear", 0.5 },
	},
}
