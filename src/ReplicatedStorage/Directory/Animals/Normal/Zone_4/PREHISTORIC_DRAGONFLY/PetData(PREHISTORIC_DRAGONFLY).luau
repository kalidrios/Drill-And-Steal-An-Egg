return {
	name = "PREHISTORIC_DRAGONFLY", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://135745512151625",
		Walk = "rbxassetid://80915898212048"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://125419280275975", 
	GoldThumbnail = "rbxassetid://83081906698521", 
	DiamondThumbnail = "rbxassetid://137354333115440", 
	baseWeightKg = 51.1,
	baseCoinsPerSecond = 1500000.0,
	rarity = "Cosmic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
