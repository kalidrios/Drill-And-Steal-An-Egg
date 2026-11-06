return {
	name = "Moorish idol", 
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
	NormalThumbnail = "rbxassetid://82288264685280", 
	GoldThumbnail = "rbxassetid://133341467922197", 
	DiamondThumbnail = "rbxassetid://114783507731701", 
	baseWeightKg = 35.1,
	baseCoinsPerSecond = 8400.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
