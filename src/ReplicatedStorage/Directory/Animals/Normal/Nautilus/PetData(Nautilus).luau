return {
	name = "Nautilus", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://132004894853681",
		Walk = "rbxassetid://136405867016124"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://109914493297939", 
	GoldThumbnail = "rbxassetid://111111140970650", 
	DiamondThumbnail = "rbxassetid://126352639790263", 
	baseWeightKg = 29.3,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
