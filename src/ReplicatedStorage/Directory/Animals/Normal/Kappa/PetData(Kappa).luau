return {
	name = "Kappa", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://87672067546983",
		Walk = "rbxassetid://106722856130049"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://104454694749452", 
	GoldThumbnail = "rbxassetid://122135557002022", 
	DiamondThumbnail = "rbxassetid://77968038674300", 
	baseWeightKg = 52.4,
	baseCoinsPerSecond = 1350000.0,
	rarity = "Cosmic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
