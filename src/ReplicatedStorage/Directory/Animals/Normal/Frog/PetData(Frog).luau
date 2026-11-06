return {
	name = "Frog", 
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
	NormalThumbnail = "rbxassetid://95237512951290", 
	GoldThumbnail = "rbxassetid://86093306428110", 
	DiamondThumbnail = "rbxassetid://79847496896039", 
	baseWeightKg = 27.2,
	baseCoinsPerSecond = 40.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
