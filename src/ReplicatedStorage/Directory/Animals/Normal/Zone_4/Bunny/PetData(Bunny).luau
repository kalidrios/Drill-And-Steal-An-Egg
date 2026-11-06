return {
	name = "Bunny", 
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
	NormalThumbnail = "rbxassetid://130063854578399", 
	GoldThumbnail = "rbxassetid://117221779353890", 
	DiamondThumbnail = "rbxassetid://109460582420778", 
	baseWeightKg = 40.4,
	baseCoinsPerSecond = 84.0,
	rarity = "Uncommon", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
