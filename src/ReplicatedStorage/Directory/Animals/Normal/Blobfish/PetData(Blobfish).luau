return {
	name = "Blobfish", 
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
	NormalThumbnail = "rbxassetid://133213484553038", 
	GoldThumbnail = "rbxassetid://111444905459441", 
	DiamondThumbnail = "rbxassetid://119812576866812", 
	baseWeightKg = 38.1,
	baseCoinsPerSecond = 5250.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
