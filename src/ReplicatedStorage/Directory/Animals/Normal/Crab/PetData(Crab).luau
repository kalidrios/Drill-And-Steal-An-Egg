return {
	name = "Crab", 
	model = script.Parent:FindFirstChild("Normal"), 
	modelGold = script.Parent:FindFirstChild("Gold"),
	modelDiamond = script.Parent:FindFirstChild("Diamond"),
	sounds = {
		random = {  }
	}, 
	animations = {
		Idle = "rbxassetid://118592787740283",
		Walk = "rbxassetid://117692039199131"
	},
	fly = false,
	NormalThumbnail = "rbxassetid://103640249981229", 
	GoldThumbnail = "rbxassetid://115779876008451", 
	DiamondThumbnail = "rbxassetid://133290448861093", 
	baseWeightKg = 33.5,
	baseCoinsPerSecond = 1.0,
	rarity = "Common", 
	tradeable = true
	};
