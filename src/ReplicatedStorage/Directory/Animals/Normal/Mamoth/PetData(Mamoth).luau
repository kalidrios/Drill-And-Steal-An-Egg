return {
	name = "Mamoth", 
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
	NormalThumbnail = "rbxassetid://135617555071808", 
	GoldThumbnail = "rbxassetid://124757212005683", 
	DiamondThumbnail = "rbxassetid://110918767801841", 
	baseWeightKg = 91.6,
	baseCoinsPerSecond = 165000.0,
	rarity = "Divine", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
