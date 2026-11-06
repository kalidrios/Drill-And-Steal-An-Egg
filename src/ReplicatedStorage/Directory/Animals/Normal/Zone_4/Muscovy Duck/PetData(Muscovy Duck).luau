return {
	name = "Muscovy Duck", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://78060518414216",
		Walk = "rbxassetid://99357902887810"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://102977595013536", 
	GoldThumbnail = "rbxassetid://126197024974842", 
	DiamondThumbnail = "rbxassetid://81656505308046", 
	baseWeightKg = 29.9,
	baseCoinsPerSecond = 336.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
