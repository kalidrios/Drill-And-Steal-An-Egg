return {
	name = "Fossa", 
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
	NormalThumbnail = "rbxassetid://117725861584081", 
	GoldThumbnail = "rbxassetid://85297199624861", 
	DiamondThumbnail = "rbxassetid://138256300781175", 
	baseWeightKg = 42.9,
	baseCoinsPerSecond = 60.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
