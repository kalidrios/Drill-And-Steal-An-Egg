--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Zone 6 Egg",
	rarity = Rarity.Mythical,
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
		{ "Cuttlefish", 34 },
		{ "LeafySeaDragon", 24 },
		{ "Swordfish", 18 },
		{ "FangtoothFish", 12 },
		{ "GoblinShark", 6 },
		{ "MantisShrimp", 3.5 },
		{ "Amphiptere", 2 },
		{ "MEGALODON", 0.5 },
	},
}
