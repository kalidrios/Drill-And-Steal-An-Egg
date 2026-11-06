return {
	name = "Maltese", 
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
	NormalThumbnail = "rbxassetid://70681658590910", 
	GoldThumbnail = "rbxassetid://125636609289061", 
	DiamondThumbnail = "rbxassetid://75411594816574", 
	baseWeightKg = 41.8,
	baseCoinsPerSecond = 180.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
