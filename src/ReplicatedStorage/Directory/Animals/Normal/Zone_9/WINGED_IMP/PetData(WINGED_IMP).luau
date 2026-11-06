return {
	name = "WINGED_IMP", 
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
	NormalThumbnail = "rbxassetid://100521995448720", 
	GoldThumbnail = "rbxassetid://108438135315803", 
	DiamondThumbnail = "rbxassetid://75132090806302", 
	baseWeightKg = 78.9,
	baseCoinsPerSecond = 260000000.0,
	rarity = "Celestial", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
