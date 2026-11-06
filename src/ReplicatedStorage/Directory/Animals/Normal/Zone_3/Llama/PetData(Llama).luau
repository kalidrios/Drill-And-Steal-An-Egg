return {
	name = "Llama", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://119727685635380",
		Walk = "rbxassetid://93712026106914"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://122761605856452", 
	GoldThumbnail = "rbxassetid://126920250132229", 
	DiamondThumbnail = "rbxassetid://119400909924021", 
	baseWeightKg = 50.3,
	baseCoinsPerSecond = 18000.0,
	rarity = "Mythic", 
	tradeable = true
	};
