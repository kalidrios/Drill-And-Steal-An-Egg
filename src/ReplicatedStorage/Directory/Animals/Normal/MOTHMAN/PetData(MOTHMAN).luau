return {
	name = "MOTHMAN", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://98291474471201",
		Walk = "rbxassetid://131766740917324"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://94886159092306", 
	GoldThumbnail = "rbxassetid://123788429586241", 
	DiamondThumbnail = "rbxassetid://108493425544633", 
	baseWeightKg = 65.3,
	baseCoinsPerSecond = 1500000.0,
	rarity = "Cosmic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
