return {
	name = "TripleCobra", 
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
	NormalThumbnail = "rbxassetid://133890251806831", 
	GoldThumbnail = "rbxassetid://90615058962011", 
	DiamondThumbnail = "rbxassetid://87743656429918", 
	baseWeightKg = 97.6,
	baseCoinsPerSecond = 7000000.0,
	rarity = "Secret", 
	tradeable = true
	};
