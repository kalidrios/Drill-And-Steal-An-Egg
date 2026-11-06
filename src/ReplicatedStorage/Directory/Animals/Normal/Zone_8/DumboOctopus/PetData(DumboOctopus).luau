return {
	name = "DumboOctopus", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://75089375984978",
		Walk = "rbxassetid://121409753393079"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://121611555669331", 
	GoldThumbnail = "rbxassetid://102611755190903", 
	DiamondThumbnail = "rbxassetid://137823865503581", 
	baseWeightKg = 31.8,
	baseCoinsPerSecond = 6500000.0,
	rarity = "Cosmic", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
