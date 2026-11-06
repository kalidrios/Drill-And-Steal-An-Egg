return {
	name = "HoneyBadger", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://99192444604411",
		Walk = "rbxassetid://126959692371843"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://131369647106952", 
	GoldThumbnail = "rbxassetid://75000154792401", 
	DiamondThumbnail = "rbxassetid://139738325273503", 
	baseWeightKg = 41.6,
	baseCoinsPerSecond = 35.0,
	rarity = "Uncommon", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
