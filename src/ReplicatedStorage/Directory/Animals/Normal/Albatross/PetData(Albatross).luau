return {
	name = "Albatross", 
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
	NormalThumbnail = "rbxassetid://77164854196976", 
	GoldThumbnail = "rbxassetid://72331090051223", 
	DiamondThumbnail = "rbxassetid://84646171001483", 
	baseWeightKg = 32.2,
	baseCoinsPerSecond = 4500.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
