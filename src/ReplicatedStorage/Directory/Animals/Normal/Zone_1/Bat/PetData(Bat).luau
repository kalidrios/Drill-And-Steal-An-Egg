return {
	name = "Bat", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://77443485797860",
		Walk = "rbxassetid://128588121629454"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://74319599947884", 
	GoldThumbnail = "rbxassetid://125424510211335", 
	DiamondThumbnail = "rbxassetid://82984918975272", 
	baseWeightKg = 39.1,
	baseCoinsPerSecond = 10.0,
	rarity = "Uncommon", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
