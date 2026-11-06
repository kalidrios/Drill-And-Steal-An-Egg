return {
	name = "Caracal", 
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
	NormalThumbnail = "rbxassetid://90642201512540", 
	GoldThumbnail = "rbxassetid://134920348272735", 
	DiamondThumbnail = "rbxassetid://114169331153686", 
	baseWeightKg = 43.1,
	baseCoinsPerSecond = 175.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
