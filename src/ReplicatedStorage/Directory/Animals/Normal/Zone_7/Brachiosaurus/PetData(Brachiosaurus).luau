return {
	name = "Brachiosaurus", 
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
	NormalThumbnail = "rbxassetid://123793214833924", 
	GoldThumbnail = "rbxassetid://116464330054990", 
	DiamondThumbnail = "rbxassetid://105361968268639", 
	baseWeightKg = 127.9,
	baseCoinsPerSecond = 267000.0,
	rarity = "Mythic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
