return {
	name = "Seahorse", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://120744040945061",
		Walk = "rbxassetid://135414630851545"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://129373356631251", 
	GoldThumbnail = "rbxassetid://100408677231369", 
	DiamondThumbnail = "rbxassetid://113679244734730", 
	baseWeightKg = 22.1,
	baseCoinsPerSecond = 1200.0,
	rarity = "Epic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
