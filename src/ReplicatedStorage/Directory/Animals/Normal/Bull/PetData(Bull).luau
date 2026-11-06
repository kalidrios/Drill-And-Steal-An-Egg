return {
	name = "Bull", 
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
	NormalThumbnail = "rbxassetid://131216062296795", 
	GoldThumbnail = "rbxassetid://107327783356588", 
	DiamondThumbnail = "rbxassetid://128280393616915", 
	baseWeightKg = 64.9,
	baseCoinsPerSecond = 2500.0,
	rarity = "Legendary", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
