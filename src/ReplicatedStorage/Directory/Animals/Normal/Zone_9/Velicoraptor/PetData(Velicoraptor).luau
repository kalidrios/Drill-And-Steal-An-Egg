return {
	name = "Velicoraptor", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://87672067546983",
		Walk = "rbxassetid://106722856130049"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://83244311139665", 
	GoldThumbnail = "rbxassetid://127513034935472", 
	DiamondThumbnail = "rbxassetid://129116234425857", 
	baseWeightKg = 136.1,
	baseCoinsPerSecond = 400000000.0,
	rarity = "Inferno", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
