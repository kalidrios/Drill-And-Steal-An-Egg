return {
	name = "cowfish", 
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
	NormalThumbnail = "rbxassetid://103350388448440", 
	GoldThumbnail = "rbxassetid://118095694584731", 
	DiamondThumbnail = "rbxassetid://106391512988517", 
	baseWeightKg = 34.2,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	tradeable = true
	};
