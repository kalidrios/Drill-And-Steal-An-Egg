return {
	name = "Boston Terrier", 
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
	NormalThumbnail = "rbxassetid://138454493058926", 
	GoldThumbnail = "rbxassetid://102461297395615", 
	DiamondThumbnail = "rbxassetid://88846178973743", 
	baseWeightKg = 40.9,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
