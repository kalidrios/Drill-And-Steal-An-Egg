return {
	name = "Cobra", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://78329903934350",
		Walk = "rbxassetid://136632546720807"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://117032673529486", 
	GoldThumbnail = "rbxassetid://128734782441920", 
	DiamondThumbnail = "rbxassetid://81556042106455", 
	baseWeightKg = 83.6,
	baseCoinsPerSecond = 200000.0,
	rarity = "Divine", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
