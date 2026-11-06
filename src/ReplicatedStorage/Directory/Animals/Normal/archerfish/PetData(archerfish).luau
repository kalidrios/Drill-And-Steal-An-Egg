return {
	name = "archerfish", 
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
	NormalThumbnail = "rbxassetid://113569211363878", 
	GoldThumbnail = "rbxassetid://108532264140248", 
	DiamondThumbnail = "rbxassetid://91825228578649", 
	baseWeightKg = 39.4,
	baseCoinsPerSecond = 1200000.0,
	rarity = "Cosmic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
