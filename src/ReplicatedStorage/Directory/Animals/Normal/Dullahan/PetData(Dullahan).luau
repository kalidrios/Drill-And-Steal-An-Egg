return {
	name = "Dullahan", 
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
	NormalThumbnail = "rbxassetid://139109933485501", 
	GoldThumbnail = "rbxassetid://76795226807888", 
	DiamondThumbnail = "rbxassetid://101812945867295", 
	baseWeightKg = 96.6,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
