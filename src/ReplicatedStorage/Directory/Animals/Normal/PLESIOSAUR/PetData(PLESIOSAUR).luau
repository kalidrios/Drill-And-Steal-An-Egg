return {
	name = "PLESIOSAUR", 
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
	NormalThumbnail = "rbxassetid://86775453017097", 
	GoldThumbnail = "rbxassetid://109327865610609", 
	DiamondThumbnail = "rbxassetid://102784841617115", 
	baseWeightKg = 192.4,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
