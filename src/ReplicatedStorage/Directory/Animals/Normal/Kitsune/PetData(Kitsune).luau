return {
	name = "Kitsune", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://119727685635380",
		Walk = "rbxassetid://93712026106914"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://87986750220374", 
	GoldThumbnail = "rbxassetid://80740436834674", 
	DiamondThumbnail = "rbxassetid://90110647289055", 
	baseWeightKg = 76.7,
	baseCoinsPerSecond = 45000000.0,
	rarity = "Celestial", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
