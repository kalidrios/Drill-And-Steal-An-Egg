return {
	name = "ROC", 
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
	NormalThumbnail = "rbxassetid://112256182960138", 
	GoldThumbnail = "rbxassetid://106060772864933", 
	DiamondThumbnail = "rbxassetid://113352869602736", 
	baseWeightKg = 85.3,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	isPremium = false, 
	tradeable = true, 
	isVanity = false, 
	strengthMin = 2, 
	strengthMax = 3
};
