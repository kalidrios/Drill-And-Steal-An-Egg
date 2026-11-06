return {
	name = "SPHINX", 
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
	NormalThumbnail = "rbxassetid://94106833596246", 
	GoldThumbnail = "rbxassetid://116800028886334", 
	DiamondThumbnail = "rbxassetid://74568595245513", 
	baseWeightKg = 67.9,
	baseCoinsPerSecond = 230.0,
	rarity = "Epic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
