return {
	name = "DIMETRODON", 
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
	NormalThumbnail = "rbxassetid://92272648014993", 
	GoldThumbnail = "rbxassetid://98700293495036", 
	DiamondThumbnail = "rbxassetid://123358009760181", 
	baseWeightKg = 95.1,
	baseCoinsPerSecond = 48000.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
