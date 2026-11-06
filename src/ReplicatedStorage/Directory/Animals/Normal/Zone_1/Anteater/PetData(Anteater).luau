return {
	name = "Anteater", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	},
	animations = {
		Idle = "rbxassetid://99192444604411",
		Walk = "rbxassetid://126959692371843"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://103982210409782", 
	GoldThumbnail = "rbxassetid://79336633898832", 
	DiamondThumbnail = "rbxassetid://77715603644011", 
	baseWeightKg = 48.4,
	baseCoinsPerSecond = 13.0,
	rarity = "Uncommon", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
