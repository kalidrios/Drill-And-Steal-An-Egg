return {
	name = "Triceratops", 
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
	NormalThumbnail = "rbxassetid://119086664657044", 
	GoldThumbnail = "rbxassetid://138596546728987", 
	DiamondThumbnail = "rbxassetid://86623707174987", 
	baseWeightKg = 104.1,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
