-- Decompiled by Electron BETA [ Made By (Co) ]
-- Path: ReplicatedStorage.__DIRECTORY.Lootbags.Lootbags
return {
	Small = {
		model = "Small", 
		weight = 100, 
		isRare = false,
		orbs = {16, 19},
		masteryXP = 75, 
		rewards = {
			{"Coins", 100, 1},
			{"Diamonds", 60, 1}, 
			{"Boost", 0.15, 1}
		}
	},
	Good = {
		model = "Good", 
		weight = 20, 
		isRare = false,
		orbs = {28, 32},
		masteryXP = 125, 
		rewards = {
			{"Coins", 50, 2.5},
			{"Diamonds", 50, 2.5},
			{"Boost", 0.225, 1}
		}
	},
	Best = {
		model = "Best", 
		weight = 2.5,
		isRare = true, 
		orbs = {60, 65},
		masteryXP = 200,
		rewards = {
			{"Coins", 50, 15}, 
			{"Diamonds", 75, 18}, 
			{"Boost", 2.5, 2}
		}
	},
	["Mini Giftbox"] = {
		model = "Mini Giftbox", 
		weight = 1.5, 
		isRare = true, 
		orbs = {60, 65},
		masteryXP = 400, 
		rewards = {
			{"Boost", 100, 1}
		}
	},
	Giftbox = {
		model = "Giftbox",
		weight = 1,
		isRare = true, 
		orbs = {60, 65},
		masteryXP = 450, 
		rewards = {
			{"Boost", 100, 2}
		}
	}, 
	HugePet = {
		model = "HugeSnowmanGiftbox",
		weight = 0, 
		isRare = true, 
		orbs = {60, 65},
		masteryXP = 450, 
		rewards = {
			{"HugePet", 100, 1}
		}
	},
	ChristmasEgg = {
		model = "Mini Giftbox",
		weight = 0, 
		isRare = true, 
		orbs = {60, 65},
		masteryXP = 450, 
		rewards = {
			{"ChristmasEgg", 100, 1}
		}
	}, 
	FreeGiftsCoins = {
		model = "Good",
		weight = 0,
		isRare = true, 
		orbs = {28, 32},
		masteryXP = 25, 
		rewards = {
			{"Coins", 50, 6}
		}
	},
	["Scavenger Diamonds"] = {
		model = "Giftbox", 
		weight = 0, 
		isRare = true,
		orbs = {60, 65},
		masteryXP = 25, 
		rewards = {
			{"Diamonds", 50, 6500}
		}
	}, FreeGiftsDiamonds = {
		model = "Giftbox",
		weight = 0, 
		isRare = true, 
		orbs = {60, 65}, 
		masteryXP = 25,
		rewards = {
			{"Diamonds", 50, 13.5}
		}
	}, 
	FreeGiftsCoinsJUMBO = {
		model = "Good", 
		weight = 0, 
		isRare = true, 
		orbs = {28, 32}, 
		masteryXP = 75,
		rewards = {
			{"Coins", 50, 14}
		}
	},
	FreeGiftsDiamondsJUMBO = {
		model = "Giftbox", 
		weight = 0, 
		isRare = true, 
		orbs = {60, 65},
		masteryXP = 75, 
		rewards = {
			{"Diamonds", 50, 52.5}
		}
	},
	["Mini Comet Diamonds 1"] = {
		model = "Giftbox", 
		weight = 0,
		isRare = true, 
		orbs = {10, 20},
		masteryXP = 50,
		rewards = {
			{"Diamonds", 50, 166.66666666667}, 
			{"Boost", 10, 1}
		}
	}, 
	["Mini Comet Diamonds 2"] = {
		model = "Giftbox",
		weight = 0,
		isRare = true,
		orbs = {20, 40},
		masteryXP = 100,
		rewards = {
			{"Diamonds", 50, 666.66666666667}, 
			{"Boost", 10, 1}
		}
	}, 
	["Mini Comet Diamonds 3"] = {
		model = "Giftbox",
		weight = 0, 
		isRare = true, 
		orbs = {40, 80}, 
		masteryXP = 200, 
		rewards = {
			{"Diamonds", 50, 1666.6666666667},
			{"Boost", 10, 3}
		}
	},
	["Massive Comet Diamonds 1"] = {
		model = "Giftbox", 
		weight = 0,
		isRare = true,
		orbs = {10, 20},
		masteryXP = 100, 
		rewards = {
			{"Diamonds", 50, 1000}, 
			{"Boost", 10, 4}
		}
	}, 
	["Massive Comet Diamonds 2"] = {
		model = "Giftbox", 
		weight = 0, 
		isRare = true,
		orbs = {20, 40},
		masteryXP = 200, 
		rewards = {
			{"Diamonds", 50, 4000},
			{"Boost", 10, 8}
		}
	}, 
	["Massive Comet Diamonds 3"] = {
		model = "Giftbox", 
		weight = 0,
		isRare = true, 
		orbs = {40, 80},
		masteryXP = 400,
		rewards = {
			{"Diamonds", 50, 10000},
			{"Boost", 10, 15}
		}
	}, 
	["Diamond Bag Tier 1"] = {
		model = "Diamond Bag Tier 1",
		weight = 0,
		isRare = false, 
		orbs = {5, 10}, 
		masteryXP = 3, 
		staticCurrency = true,
		diamondMine = true,
		rewards = {
			{"Diamonds", 100, 2500}
		}
	}, 
	["Diamond Bag Tier 2"] = {
		model = "Diamond Bag Tier 2",
		weight = 0, 
		isRare = false, 
		orbs = {10, 20},
		masteryXP = 5,
		staticCurrency = true, 
		diamondMine = true,
		rewards = {
			{"Diamonds", 100, 10000}
		}
	},
	["Diamond Bag Tier 3"] = {
		model = "Diamond Bag Tier 3",
		weight = 0, 
		isRare = false,
		orbs = {15, 30},
		masteryXP = 8, 
		staticCurrency = true,
		diamondMine = true, 
		rewards = {
			{"Diamonds", 100, 100000}
		}
	}, 
	["Diamond Bag Tier 4"] = {
		model = "Diamond Bag Tier 4",
		weight = 0, 
		isRare = true,
		orbs = {20, 40},
		masteryXP = 10, 
		staticCurrency = true,
		diamondMine = true, 
		rewards = {
			{"Diamonds", 100, 1000000}
		}
	}, 
	["Diamond Bag Tier 5"] = {
		model = "Diamond Bag Tier 5",
		weight = 0, 
		isRare = true,
		orbs = {25, 50}, 
		masteryXP = 20, 
		staticCurrency = true,
		diamondMine = true, 
		rewards = {
			{"Diamonds", 100, 10000000}
		}
	}
}