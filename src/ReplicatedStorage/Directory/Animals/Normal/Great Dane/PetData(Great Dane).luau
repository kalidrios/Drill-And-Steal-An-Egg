return {
	name = "Great Dane", 
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
	NormalThumbnail = "rbxassetid://135072568216406", 
	GoldThumbnail = "rbxassetid://126133414148626", 
	DiamondThumbnail = "rbxassetid://100911884165487", 
	baseWeightKg = 37.9,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
