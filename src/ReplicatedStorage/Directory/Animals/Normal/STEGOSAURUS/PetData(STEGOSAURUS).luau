return {
	name = "STEGOSAURUS", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://128358565339949",
		Walk = "rbxassetid://116761338029366"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://100179049814918", 
	GoldThumbnail = "rbxassetid://126124683654305", 
	DiamondThumbnail = "rbxassetid://85003681233908", 
	baseWeightKg = 95.8,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
