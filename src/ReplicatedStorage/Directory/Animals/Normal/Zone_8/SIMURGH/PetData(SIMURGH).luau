return {
	name = "SIMURGH", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://130175154578087",
		Walk = "rbxassetid://138400618684513"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://128188780310562", 
	GoldThumbnail = "rbxassetid://136055180328587", 
	DiamondThumbnail = "rbxassetid://119885322589078", 
	baseWeightKg = 89.4,
	baseCoinsPerSecond = 300000000.0,
	rarity = "Celestial", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
