return {
	name = "stingray", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://136398560016120",
		Walk = "rbxassetid://129025486657762"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://87783206436047", 
	GoldThumbnail = "rbxassetid://102404891343085", 
	DiamondThumbnail = "rbxassetid://117869747494540", 
	baseWeightKg = 40.0,
	baseCoinsPerSecond = 391000.0,
	rarity = "Divine", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
