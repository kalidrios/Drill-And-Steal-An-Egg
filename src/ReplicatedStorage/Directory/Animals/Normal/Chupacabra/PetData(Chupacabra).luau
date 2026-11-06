return {
	name = "Chupacabra", 
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
	NormalThumbnail = "rbxassetid://133132312753507", 
	GoldThumbnail = "rbxassetid://94930594036863", 
	DiamondThumbnail = "rbxassetid://78190724210136", 
	baseWeightKg = 60.8,
	baseCoinsPerSecond = 85000.0,
	rarity = "Mythic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
