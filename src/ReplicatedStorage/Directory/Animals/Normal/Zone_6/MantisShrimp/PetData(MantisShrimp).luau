return {
	name = "MantisShrimp", 
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
	NormalThumbnail = "rbxassetid://103059180319869", 
	GoldThumbnail = "rbxassetid://118433586779708", 
	DiamondThumbnail = "rbxassetid://117424886652035", 
	baseWeightKg = 37.6,
	baseCoinsPerSecond = 150000.0,
	rarity = "Mythic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
