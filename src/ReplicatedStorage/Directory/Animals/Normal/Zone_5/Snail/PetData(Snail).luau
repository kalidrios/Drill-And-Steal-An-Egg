return {
	name = "Snail", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://115865315339501",
		Walk = "rbxassetid://74229802498908"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://112875103956591", 
	GoldThumbnail = "rbxassetid://140657948689210", 
	DiamondThumbnail = "rbxassetid://80868233262592", 
	baseWeightKg = 37.7,
	baseCoinsPerSecond = 400.0,
	rarity = "Rare", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
