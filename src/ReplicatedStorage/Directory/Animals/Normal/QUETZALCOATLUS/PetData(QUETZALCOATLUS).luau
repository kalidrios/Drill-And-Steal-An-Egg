return {
	name = "QUETZALCOATLUS", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://113954134472635",
		Walk = "rbxassetid://100745794237950"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://135975100864872", 
	GoldThumbnail = "rbxassetid://103325270033433", 
	DiamondThumbnail = "rbxassetid://114474211550698", 
	baseWeightKg = 124.5,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
