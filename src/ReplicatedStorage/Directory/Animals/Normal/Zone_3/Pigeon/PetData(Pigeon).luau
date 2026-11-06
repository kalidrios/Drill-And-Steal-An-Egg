return {
	name = "Pigeon", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://77443485797860",
		Walk = "rbxassetid://128588121629454"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://128861946371025", 
	GoldThumbnail = "rbxassetid://74583585693120", 
	DiamondThumbnail = "rbxassetid://138762367902661", 
	baseWeightKg = 36.2,
	baseCoinsPerSecond = 40.0,
	rarity = "Uncommon", 
	tradeable = true
	};
