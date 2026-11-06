return {
	name = "PTERODACTYL", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://113954134472635",
		Walk = "rbxassetid://100745794237950"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://134625019140226", 
	GoldThumbnail = "rbxassetid://137471081177473", 
	DiamondThumbnail = "rbxassetid://120765554695579", 
	baseWeightKg = 158.2,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
