return {
	name = "Cow", 
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
	NormalThumbnail = "rbxassetid://97151049410727", 
	GoldThumbnail = "rbxassetid://99250509187841", 
	DiamondThumbnail = "rbxassetid://134542049455231", 
	baseWeightKg = 59.8,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	tradeable = true
	};
