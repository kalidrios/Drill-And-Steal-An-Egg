return {
	name = "THUNDERBIRD", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://130175154578087",
		Walk = "rbxassetid://138400618684513"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://129593290131193", 
	GoldThumbnail = "rbxassetid://134942146547566", 
	DiamondThumbnail = "rbxassetid://93909706958410", 
	baseWeightKg = 85.3,
	baseCoinsPerSecond = 50000000.0,
	rarity = "Secret", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
