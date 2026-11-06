return {
	name = "CHIREMA", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://128358565339949",
		Walk = "rbxassetid://116761338029366"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://130058024722050", 
	GoldThumbnail = "rbxassetid://77565649396128", 
	DiamondThumbnail = "rbxassetid://92664222728969", 
	baseWeightKg = 95.8,
	baseCoinsPerSecond = 2800.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
