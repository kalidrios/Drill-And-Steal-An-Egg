return {
	name = "PTERANODON", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://113954134472635",
		Walk = "rbxassetid://100745794237950"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://132503832796187", 
	GoldThumbnail = "rbxassetid://80944492400953", 
	DiamondThumbnail = "rbxassetid://124021811708753", 
	baseWeightKg = 122.8,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
