return {
	name = "Badger", 
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
	NormalThumbnail = "rbxassetid://90949185437293", 
	GoldThumbnail = "rbxassetid://89874345490394", 
	DiamondThumbnail = "rbxassetid://99455458133623", 
	baseWeightKg = 41.6,
	baseCoinsPerSecond = 35.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
