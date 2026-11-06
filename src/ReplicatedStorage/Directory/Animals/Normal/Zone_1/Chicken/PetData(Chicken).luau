return {
	name = "Chicken", 
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
	NormalThumbnail = "rbxassetid://127497355806458", 
	GoldThumbnail = "rbxassetid://83179302784391", 
	DiamondThumbnail = "rbxassetid://134507527187605", 
	baseWeightKg = 36.0,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
