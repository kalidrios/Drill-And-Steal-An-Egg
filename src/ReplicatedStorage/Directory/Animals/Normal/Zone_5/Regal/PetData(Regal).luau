return {
	name = "Regal", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://136398560016120",
		Walk = "rbxassetid://129025486657762"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://79330376810733", 
	GoldThumbnail = "rbxassetid://74790790796356", 
	DiamondThumbnail = "rbxassetid://102612742216754", 
	baseWeightKg = 33.0,
	baseCoinsPerSecond = 1340000.0,
	rarity = "Cosmic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
