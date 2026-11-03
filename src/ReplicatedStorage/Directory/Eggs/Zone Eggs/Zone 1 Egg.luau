--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local directoryFolder = ReplicatedStorage:FindFirstChild("Directory") or ReplicatedStorage:FindFirstChild("__DIRECTORY") or ReplicatedStorage:WaitForChild("Directory", 5)
local Rarity = require(directoryFolder:WaitForChild("Rarity"):WaitForChild("Rarity"))

return {
	name = "Zone 1 Egg",
	rarity = Rarity.Common,
	icon = "", -- Clean Room placeholder (defina o ID de asset próprio)
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
		{ "Chicken", 35 },
		{ "Cat", 25 },
		{ "Bat", 15 },
		{ "Badger", 10 },
		{ "Parrot", 7 },
		{ "Anteater", 5 },
		{ "Bear", 2.5 },
		{ "GoldenRetriver", 0.5 },
	},
}
