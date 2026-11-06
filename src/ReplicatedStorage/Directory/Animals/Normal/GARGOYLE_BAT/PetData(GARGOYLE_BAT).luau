return {
	name = "GARGOYLE_BAT", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://98291474471201",
		Walk = "rbxassetid://131766740917324"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://139840022946178", 
	GoldThumbnail = "rbxassetid://104782607889928", 
	DiamondThumbnail = "rbxassetid://100006968302050", 
	baseWeightKg = 77.3,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	tradeable = true
	};
