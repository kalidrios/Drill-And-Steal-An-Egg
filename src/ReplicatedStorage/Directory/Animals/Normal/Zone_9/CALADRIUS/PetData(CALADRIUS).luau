return {
	name = "CALADRIUS", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://130175154578087",
		Walk = "rbxassetid://138400618684513"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://121946540095421", 
	GoldThumbnail = "rbxassetid://79727651226527", 
	DiamondThumbnail = "rbxassetid://139843771618418", 
	baseWeightKg = 87.2,
	baseCoinsPerSecond = 330000000.0,
	rarity = "Celestial", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
