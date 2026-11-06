return {
	Spawn = {
		display = "Spawn World",
		mainCurrency = "Coins",
		additionalCurrencies = { "Valentine Hearts" },
		worldOrder = 1,
		teleportImage = "rbxassetid://12447472318",
		disabled = false,
		requiredArea = nil,
		hardcoreOnly = false,
		luckyBlockEnabled = true,
		music = { "rbxassetid://82847320458601"},
		ambience = "rbxassetid://85516654667410",
		ambienceVolume = 0.115,
		spawns = {
			VIP = {
				settings = {
					maxCoins = 24,
					healthMult = 3,
					area = "VIP",
					respawnCooldown = false
				},
				coins = { { "Tiny Diamonds", 90 }, { "Diamonds", 15 } }
			},
			["Town FRONT"] = {
				settings = {
					maxCoins = 50,
					healthMult = 1,
					area = "Town",
					respawnCooldown = false
				},
				coins = { { "Town Tiny Coins", 100 }, { "Town Coins", 30 }, { "Town Crate", 15 }, { "Town Chest", 10 }, { "Town Vault", 5 }, { "Heart Present", 20 }, { "Heart Pile", 10 } }
			},
			["Town SPECIAL"] = {
				settings = {
					maxCoins = 1,
					healthMult = 1,
					area = "Town",
					respawnCooldown = true,
					disableBalancing = true,
					respawnRate = 30,
					manualSpawn = true
				},
				coins = { --[[{ "Giant Pinata", 100 }]] }
			},
			Town = {
				settings = {
					maxCoins = 80,
					healthMult = 1,
					area = "Town",
					respawnCooldown = false
				},
				coins = { { "Town Tiny Coins", 35 }, { "Town Coins", 45 }, { "Town Large Coins", 25 }, { "Town Crate", 33 }, { "Town Present", 22 }, { "Town Chest", 10 },{ "Town Vault", 6.5 }, { "Super Chest", 2 }, { "Diamonds", 11 }--[[, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			["Forest FRONT"] = {
				settings = {
					maxCoins = 40,
					healthMult = 4,
					area = "Forest",
					respawnCooldown = false
				},
				coins = { { "Forest Tiny Coins", 60 }, { "Forest Coins", 45 }, { "Forest Large Coins", 15 }, { "Forest Present", 7.5 }, { "Forest Small Chest", 2.25 }, { "Forest Chest", 0.7 }, { "Diamonds", 10 }--[[, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			Forest = {
				settings = {
					maxCoins = 40,
					healthMult = 4,
					area = "Forest",
					respawnCooldown = false
				},
				coins = { { "Forest Tiny Coins", 35 }, { "Forest Coins", 70 }, { "Forest Large Coins", 40 }, { "Forest Crate", 23 }, { "Forest Present", 15 }, { "Forest Safe", 8.5 }, { "Forest Vault", 5.5 }, { "Forest Small Chest", 7 }, { "Forest Chest", 6 }, { "Diamonds", 17 }--[[, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]]}
			},
			["Beach FRONT"] = {
				settings = {
					maxCoins = 30,
					healthMult = 9,
					area = "Beach",
					respawnCooldown = false
				},
				coins = { { "Beach Tiny Coins", 60 }, { "Beach Coins", 45 }, { "Beach Large Coins", 15 }, { "Beach Present", 7.5 }, { "Beach Small Chest", 2.25 }, { "Beach Chest", 0.7 }, { "Diamonds", 5 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			Beach = {
				settings = {
					maxCoins = 40,
					healthMult = 9,
					area = "Beach",
					respawnCooldown = false
				},
				coins = { { "Beach Tiny Coins", 35 }, { "Beach Coins", 70 }, { "Beach Large Coins", 40 }, { "Beach Crate", 23 }, { "Beach Present", 15 }, { "Beach Safe", 9.5 }, { "Beach Vault", 6.5 }, { "Beach Small Chest", 7 }, { "Beach Chest", 6 }, { "Diamonds", 17 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			["Mine FRONT"] = {
				settings = {
					maxCoins = 30,
					healthMult = 16,
					area = "Mine",
					respawnCooldown = false
				},
				coins = { { "Mine Tiny Coins", 60 }, { "Mine Coins", 45 }, { "Mine Large Coins", 15 }, { "Mine Present", 7.5 }, { "Mine Small Chest", 2.25 }, { "Mine Chest", 0.7 }, { "Diamonds", 10 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			Mine = {
				settings = {
					maxCoins = 40,
					healthMult = 16,
					area = "Mine",
					respawnCooldown = false
				},
				coins = { { "Mine Tiny Coins", 35 }, { "Mine Coins", 70 }, { "Mine Large Coins", 40 }, { "Mine Crate", 23 }, { "Mine Present", 15 }, { "Mine Safe", 8.5 }, { "Mine Vault", 5.5 }, { "Mine Small Chest", 7 }, { "Mine Chest", 6 }, { "Diamonds", 17 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			["Winter FRONT"] = {
				settings = {
					maxCoins = 30,
					healthMult = 38,
					area = "Winter",
					respawnCooldown = false
				},
				coins = { { "Winter Tiny Coins", 60 }, { "Winter Coins", 45 }, { "Winter Large Coins", 15 }, { "Winter Present", 7.5 }, { "Winter Small Chest", 2.25 }, { "Winter Chest", 0.7 }, { "Diamonds", 10 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			Winter = {
				settings = {
					maxCoins = 40,
					healthMult = 38,
					area = "Winter",
					respawnCooldown = false
				},
				coins = { { "Winter Tiny Coins", 35 }, { "Winter Coins", 70 }, { "Winter Large Coins", 40 }, { "Winter Crate", 23 }, { "Winter Present", 15 }, { "Winter Safe", 8.5 }, { "Winter Vault", 5.5 }, { "Winter Small Chest", 7 }, { "Winter Chest", 6 }, { "Diamonds", 17 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			Glacier = {
				settings = {
					maxCoins = 45,
					healthMult = 70,
					area = "Glacier",
					respawnCooldown = false
				},
				coins = { { "Glacier Tiny Coins", 80 }, { "Glacier Coins", 70 }, { "Glacier Large Coins", 40 }, { "Glacier Crate", 6 }, { "Glacier Present", 4 }, { "Glacier Small Chest", 1.5 }, { "Glacier Chest", 0.7 }, { "Diamonds", 10 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			["Glacier Lake"] = {
				settings = {
					maxCoins = 20,
					healthMult = 70,
					area = "Glacier",
					respawnCooldown = false
				},
				coins = { { "Glacier Large Coins", 30 }, { "Glacier Crate", 15 }, { "Glacier Present", 11 }, { "Glacier Safe", 5 }, { "Glacier Vault", 4 }, { "Glacier Small Chest", 4 }, { "Glacier Chest", 3 }, { "Diamonds", 17 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			["Desert FRONT"] = {
				settings = {
					maxCoins = 30,
					healthMult = 150,
					area = "Desert",
					respawnCooldown = false
				},
				coins = { { "Desert Tiny Coins", 60 }, { "Desert Coins", 45 }, { "Desert Large Coins", 15 }, { "Desert Present", 7.5 }, { "Desert Small Chest", 2.25 }, { "Desert Chest", 0.7 }, { "Diamonds", 10 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			Desert = {
				settings = {
					maxCoins = 40,
					healthMult = 150,
					area = "Desert",
					respawnCooldown = false
				},
				coins = { { "Desert Tiny Coins", 35 }, { "Desert Coins", 70 }, { "Desert Large Coins", 40 }, { "Desert Crate", 23 }, { "Desert Present", 15 }, { "Desert Safe", 8.5 }, { "Desert Vault", 5.5 }, { "Desert Small Chest", 7 }, { "Desert Chest", 6 }, { "Diamonds", 17 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			["Volcano FRONT"] = {
				settings = {
					maxCoins = 20,
					healthMult = 340,
					area = "Volcano",
					respawnCooldown = false
				},
				coins = { { "Volcano Tiny Coins", 60 }, { "Volcano Coins", 45 }, { "Volcano Large Coins", 15 }, { "Volcano Present", 7.5 }, { "Diamonds", 10 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			Volcano = {
				settings = {
					maxCoins = 40,
					healthMult = 340,
					area = "Volcano",
					respawnCooldown = false
				},
				coins = { { "Volcano Tiny Coins", 35 }, { "Volcano Coins", 70 }, { "Volcano Large Coins", 40 }, { "Volcano Crate", 25 }, { "Volcano Present", 18 }, { "Volcano Safe", 10 }, { "Volcano Vault", 15 }, { "Diamonds", 17 } --[[{ "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 }]] }
			},
			["Volcano Chest"] = {
				settings = {
					maxCoins = 1,
					healthMult = 340,
					area = "Volcano",
					respawnCooldown = true
				},
				coins = { { "Volcano Magma Chest", 100 } }
			},
			["Ice Tech"] = {
				settings = {
					maxCoins = 1,
					healthMult = 90000,
					area = "Ice Tech",
					respawnCooldown = true
				},
				coins = { { "Giant Tech Chest", 60 } }
			}
		}
	}
};