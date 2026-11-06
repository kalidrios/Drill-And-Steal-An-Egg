return {
	name = "Papillon", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://133283625897788",
		Walk = "rbxassetid://131883733844774"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://103768817448862", 
	GoldThumbnail = "rbxassetid://114473015053300", 
	DiamondThumbnail = "rbxassetid://95526277245001", 
	baseWeightKg = 43.9,
	baseCoinsPerSecond = 9000.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
