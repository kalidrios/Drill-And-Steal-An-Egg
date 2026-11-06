return {
	name = "Snake", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://78329903934350",
		Walk = "rbxassetid://136632546720807"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://70389838551873", 
	GoldThumbnail = "rbxassetid://90354666251616", 
	DiamondThumbnail = "rbxassetid://121148199382046", 
	baseWeightKg = 48.9,
	baseCoinsPerSecond = 3.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
