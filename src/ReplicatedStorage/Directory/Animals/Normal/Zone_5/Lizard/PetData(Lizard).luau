return {
	name = "Lizard", 
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
	NormalThumbnail = "rbxassetid://119936798041083", 
	GoldThumbnail = "rbxassetid://132284668983636", 
	DiamondThumbnail = "rbxassetid://101380614972838", 
	baseWeightKg = 36.0,
	baseCoinsPerSecond = 1500.0,
	rarity = "Epic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
