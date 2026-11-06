return {
	name = "Ostrich", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://77443485797860",
		Walk = "rbxassetid://128588121629454"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://74799060459004", 
	GoldThumbnail = "rbxassetid://115759820609152", 
	DiamondThumbnail = "rbxassetid://86909965763913", 
	baseWeightKg = 43.2,
	baseCoinsPerSecond = 3000.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
