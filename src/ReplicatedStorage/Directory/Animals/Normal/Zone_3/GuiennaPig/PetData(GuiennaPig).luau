return {
	name = "GuiennaPig", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://119727685635380",
		Walk = "rbxassetid://93712026106914"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://74911925631359", 
	GoldThumbnail = "rbxassetid://123949472213281", 
	DiamondThumbnail = "rbxassetid://138761675931723", 
	baseWeightKg = 43.8,
	baseCoinsPerSecond = 65.0,
	rarity = "Uncommon", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
