return {
	name = "Serval", 
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
	NormalThumbnail = "rbxassetid://137220981367059", 
	GoldThumbnail = "rbxassetid://98649930953590", 
	DiamondThumbnail = "rbxassetid://119903425944657", 
	baseWeightKg = 40.7,
	baseCoinsPerSecond = 150.0,
	rarity = "Uncommon", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
