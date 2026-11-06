return {
	name = "GoblinShark", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://118474643930132",
		Walk = "rbxassetid://74213239121377"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://84984757569976", 
	GoldThumbnail = "rbxassetid://78353608650231", 
	DiamondThumbnail = "rbxassetid://111953959686330", 
	baseWeightKg = 38.0,
	baseCoinsPerSecond = 703000.0,
	rarity = "Divine", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
