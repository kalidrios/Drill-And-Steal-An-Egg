return {
	name = "Butterflyfish", 
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
	NormalThumbnail = "rbxassetid://132179854649023", 
	GoldThumbnail = "rbxassetid://127078620100914", 
	DiamondThumbnail = "rbxassetid://96229985398041", 
	baseWeightKg = 40.7,
	baseCoinsPerSecond = 83300.0,
	rarity = "Mythic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
