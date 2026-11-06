return {
	name = "HYDRA", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://121257374504578",
		Walk = "rbxassetid://121719261746253"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://105056979176151", 
	GoldThumbnail = "rbxassetid://90467822939208", 
	DiamondThumbnail = "rbxassetid://116702492424074", 
	baseWeightKg = 123.9,
	baseCoinsPerSecond = 15000000.0,
	rarity = "Secret", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
