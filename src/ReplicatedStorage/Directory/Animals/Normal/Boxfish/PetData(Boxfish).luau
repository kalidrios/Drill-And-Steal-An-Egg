return {
	name = "Boxfish", 
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
	NormalThumbnail = "rbxassetid://100541577360997", 
	GoldThumbnail = "rbxassetid://123539514898522", 
	DiamondThumbnail = "rbxassetid://94935397857301", 
	baseWeightKg = 32.5,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	tradeable = true
	};
