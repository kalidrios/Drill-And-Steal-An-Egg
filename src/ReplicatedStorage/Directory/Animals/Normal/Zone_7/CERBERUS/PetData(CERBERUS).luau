return {
	name = "CERBERUS", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://128358565339949",
		Walk = "rbxassetid://116761338029366"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://109593038586758", 
	GoldThumbnail = "rbxassetid://78134380964966", 
	DiamondThumbnail = "rbxassetid://114851420251683", 
	baseWeightKg = 94.1,
	baseCoinsPerSecond = 150000000.0,
	rarity = "Celestial", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
