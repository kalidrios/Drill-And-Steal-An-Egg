return {
	name = "wobbegong", 
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
	NormalThumbnail = "rbxassetid://137914110587913", 
	GoldThumbnail = "rbxassetid://84932552459192", 
	DiamondThumbnail = "rbxassetid://94295825002426", 
	baseWeightKg = 48.6,
	baseCoinsPerSecond = 375000.0,
	rarity = "Divine", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
