return {
	name = "LeafySeaDragon", 
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
	NormalThumbnail = "rbxassetid://102902264873497", 
	GoldThumbnail = "rbxassetid://86591956082089", 
	DiamondThumbnail = "rbxassetid://104896744598641", 
	baseWeightKg = 45.1,
	baseCoinsPerSecond = 2410000.0,
	rarity = "Cosmic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
