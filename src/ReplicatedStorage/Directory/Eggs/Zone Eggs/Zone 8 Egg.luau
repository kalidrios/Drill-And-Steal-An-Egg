--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Zone 8 Egg",
	rarity = Rarity.Cosmic,
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
		{ "Mandarinfish", 34 },
		{ "Surgeonfish", 24 },
		{ "Tanuki", 18 },
		{ "Akita", 12 },
		{ "Wolf", 6 },
		{ "Gallimimus", 3.5 },
		{ "DumboOctopus", 2 },
		{ "SIMURGH", 0.5 },
	},
}
