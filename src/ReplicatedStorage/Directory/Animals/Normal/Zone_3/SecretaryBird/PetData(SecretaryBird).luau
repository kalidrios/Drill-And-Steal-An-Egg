return {
	name = "SecretaryBird", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://78060518414216",
		Walk = "rbxassetid://99357902887810"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://133157088541013", 
	GoldThumbnail = "rbxassetid://112023122291211", 
	DiamondThumbnail = "rbxassetid://95741225756703", 
	baseWeightKg = 42.3,
	baseCoinsPerSecond = 4500.0,
	rarity = "Legendary", 
	tradeable = true
	};
