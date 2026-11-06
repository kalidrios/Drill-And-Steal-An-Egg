return {
	name = "CLASSICDRAGON", 
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
	NormalThumbnail = "rbxassetid://128073743703468", 
	GoldThumbnail = "rbxassetid://115312189986194", 
	DiamondThumbnail = "rbxassetid://74982144160079", 
	baseWeightKg = 252.7,
	baseCoinsPerSecond = 500000000.0,
	rarity = "Inferno", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
