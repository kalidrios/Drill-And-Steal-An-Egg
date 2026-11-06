return {
	name = "English Bulldog", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://133283625897788",
		Walk = "rbxassetid://131883733844774"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://111448551108191", 
	GoldThumbnail = "rbxassetid://80969181192688", 
	DiamondThumbnail = "rbxassetid://112015188280108", 
	baseWeightKg = 39.9,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
