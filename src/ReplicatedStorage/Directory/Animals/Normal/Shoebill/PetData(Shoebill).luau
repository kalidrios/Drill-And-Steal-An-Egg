return {
	name = "Shoebill", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://78060518414216",
		Walk = "rbxassetid://99357902887810"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://117366976652910", 
	GoldThumbnail = "rbxassetid://115393026556110", 
	DiamondThumbnail = "rbxassetid://93475073686307", 
	baseWeightKg = 39.9,
	baseCoinsPerSecond = 5000000.0,
	rarity = "Secret", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
