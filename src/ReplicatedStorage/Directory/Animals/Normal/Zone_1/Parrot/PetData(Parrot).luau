return {
	name = "Parrot", 
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
	NormalThumbnail = "rbxassetid://123454043882290", 
	GoldThumbnail = "rbxassetid://140428277594850", 
	DiamondThumbnail = "rbxassetid://105587919535298", 
	baseWeightKg = 40.3,
	baseCoinsPerSecond = 45.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
