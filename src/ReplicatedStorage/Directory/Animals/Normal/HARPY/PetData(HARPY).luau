return {
	name = "HARPY", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://130175154578087",
		Walk = "rbxassetid://138400618684513"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://123748661717800", 
	GoldThumbnail = "rbxassetid://83502557834655", 
	DiamondThumbnail = "rbxassetid://131841897812487", 
	baseWeightKg = 86.2,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
