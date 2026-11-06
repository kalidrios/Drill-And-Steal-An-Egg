return {
	name = "MEGALODON", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://76071215719797",
		Walk = "rbxassetid://134801553914606"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://81390995877291", 
	GoldThumbnail = "rbxassetid://121318894079972", 
	DiamondThumbnail = "rbxassetid://92313856647335", 
	baseWeightKg = 102.5,
	baseCoinsPerSecond = 16750000.0,
	rarity = "Secret", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
