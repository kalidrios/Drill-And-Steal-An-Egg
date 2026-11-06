return {
	name = "Yak", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://99192444604411",
		Walk = "rbxassetid://126959692371843"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://90473025115181", 
	GoldThumbnail = "rbxassetid://104601268273113", 
	DiamondThumbnail = "rbxassetid://80915504221727", 
	baseWeightKg = 50.6,
	baseCoinsPerSecond = 46700.0,
	rarity = "Mythic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
