--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Zone 9 Egg",
	rarity = Rarity.Eternal,
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
		{ "Zebra", 30 },
		{ "Crocodile", 22 },
		{ "Whale", 16 },
		{ "Velicoraptor", 12 },
		{ "ARCHAEOPTERYX", 8 },
		{ "WINGED_IMP", 5 },
		{ "CALADRIUS", 3.5 },
		{ "QILIN", 2 },
		{ "CLASSICDRAGON", 1 },
		{ "THUNDERBIRD", 0.5 },
	},
}
