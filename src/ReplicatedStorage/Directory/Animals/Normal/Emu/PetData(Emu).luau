return {
	name = "Emu", 
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
	NormalThumbnail = "rbxassetid://88659033345814", 
	GoldThumbnail = "rbxassetid://111317549113633", 
	DiamondThumbnail = "rbxassetid://71482090091429", 
	baseWeightKg = 35.0,
	baseCoinsPerSecond = 70.0,
	rarity = "Uncommon", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
