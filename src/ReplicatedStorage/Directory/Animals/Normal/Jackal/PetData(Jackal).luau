return {
	name = "Jackal", 
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
	NormalThumbnail = "rbxassetid://90914057083658", 
	GoldThumbnail = "rbxassetid://88917125437671", 
	DiamondThumbnail = "rbxassetid://71075078645472", 
	baseWeightKg = 39.8,
	baseCoinsPerSecond = 355.0,
	rarity = "Epic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
