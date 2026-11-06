return {
	name = "GoldenRetriver", 
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
	NormalThumbnail = "rbxassetid://114960328381483", 
	GoldThumbnail = "rbxassetid://107019163338313", 
	DiamondThumbnail = "rbxassetid://140538265304980", 
	baseWeightKg = 53.9,
	baseCoinsPerSecond = 145.0,
	rarity = "Epic", 
	tradeable = true
	};
