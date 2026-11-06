local Data = {
	Fantasy = {
		display = "Fantarelo World", 
		mainCurrency = "Fantasy Coins", 
		worldOrder = 2, 
		teleportImage = "rbxassetid://12447472192", 
		disabled = true, 
		requiredArea = "Cave", 
		hardcoreOnly = false, 
		luckyBlockEnabled = true, 
		music = { "rbxassetid://88239084825686", "rbxassetid://82847320458601", "rbxassetid://82847320458601", "rbxassetid://6918026842", "rbxassetid://82847320458601", "rbxassetid://7009860327", "rbxassetid://104480911944885", "rbxassetid://7009860392", "rbxassetid://82847320458601", "rbxassetid://7810629972", "rbxassetid://10296556752" }, 
		ambience = "rbxassetid://6912256346", 
		ambienceVolume = 0.125, 
		spawns = {
			["Enchanted Forest FRONT"] = {
				settings = {
					maxCoins = 30, 
					healthMult = 1800, 
					area = "Enchanted Forest", 
					respawnCooldown = false
				}, 
				coins = { { "Enchanted Forest Tiny Coins", 60 }, { "Enchanted Forest Coins", 45 }, { "Enchanted Forest Large Coins", 15 }, { "Enchanted Forest Present", 7.5 }, { "Enchanted Forest Small Chest", 2.25 }, { "Enchanted Forest Chest", 0.7 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			["Enchanted Forest"] = {
				settings = {
					maxCoins = 35, 
					healthMult = 1800, 
					area = "Enchanted Forest", 
					respawnCooldown = false
				}, 
				coins = { { "Enchanted Forest Tiny Coins", 35 }, { "Enchanted Forest Coins", 70 }, { "Enchanted Forest Large Coins", 40 }, { "Enchanted Forest Crate", 23 }, { "Enchanted Forest Present", 15 }, { "Enchanted Forest Safe", 8.5 }, { "Enchanted Forest Vault", 5.5 }, { "Enchanted Forest Small Chest", 7 }, { "Enchanted Forest Chest", 6 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			Ancient = {
				settings = {
					maxCoins = 80, 
					healthMult = 3750, 
					area = "Ancient Island", 
					respawnCooldown = false
				}, 
				coins = { { "Ancient Island Tiny Coins", 35 }, { "Ancient Island Coins", 60 }, { "Ancient Island Large Coins", 45 }, { "Ancient Island Crate", 23 }, { "Ancient Island Present", 15 }, { "Ancient Island Safe", 8.5 }, { "Ancient Island Vault", 5.5 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			["Enchanted Chest"] = {
				settings = {
					maxCoins = 1, 
					healthMult = 3750, 
					area = "Ancient Island", 
					respawnCooldown = true
				}, 
				coins = { { "Ancient Island Enchanted Chest", 100 } }
			}, 
			["Samurai FRONT"] = {
				settings = {
					maxCoins = 50, 
					healthMult = 8000, 
					area = "Samurai Island", 
					respawnCooldown = false
				}, 
				coins = { { "Samurai Island Tiny Coins", 35 }, { "Samurai Island Coins", 60 }, { "Samurai Island Large Coins", 50 }, { "Samurai Island Crate", 12 }, { "Samurai Island Present", 15 }, { "Samurai Island Small Chest", 3.5 }, { "Samurai Island Chest", 2 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			Samurai = {
				settings = {
					maxCoins = 30, 
					healthMult = 8000, 
					area = "Samurai Island", 
					respawnCooldown = false
				}, 
				coins = { { "Samurai Island Large Coins", 50 }, { "Samurai Island Crate", 23 }, { "Samurai Island Present", 15 }, { "Samurai Island Small Chest", 12 }, { "Samurai Island Chest", 9 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			Candy = {
				settings = {
					maxCoins = 75, 
					healthMult = 17500, 
					area = "Candy Island", 
					respawnCooldown = false
				}, 
				coins = { { "Candy Island Tiny Coins", 35 }, { "Candy Island Coins", 70 }, { "Candy Island Large Coins", 40 }, { "Candy Island Crate", 23 }, { "Candy Island Present", 15 }, { "Candy Island Safe", 8.5 }, { "Candy Island Vault", 5.5 }, { "Candy Island Small Chest", 7 }, { "Candy Island Chest", 6 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			["Haunted FRONT"] = {
				settings = {
					maxCoins = 55, 
					healthMult = 40000, 
					area = "Haunted Island", 
					respawnCooldown = false
				}, 
				coins = { { "Haunted Island Tiny Coins", 35 }, { "Haunted Island Coins", 60 }, { "Haunted Island Large Coins", 50 }, { "Haunted Island Crate", 12 }, { "Haunted Island Present", 15 }, { "Haunted Island Safe", 3.5 }, { "Haunted Island Vault", 2 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			Haunted = {
				settings = {
					maxCoins = 20, 
					healthMult = 40000, 
					area = "Haunted Island", 
					respawnCooldown = false
				}, 
				coins = { { "Haunted Island Large Coins", 45 }, { "Haunted Island Crate", 23 }, { "Haunted Island Present", 15 }, { "Haunted Island Safe", 12 }, { "Haunted Island Vault", 10 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			["Haunted Chest"] = {
				settings = {
					maxCoins = 1, 
					healthMult = 40000, 
					area = "Haunted Island", 
					respawnCooldown = true
				}, 
				coins = { { "Haunted Island Haunted Chest", 100 } }
			}, 
			Hell = {
				settings = {
					maxCoins = 75, 
					healthMult = 90000, 
					area = "Hell Island", 
					respawnCooldown = false
				}, 
				coins = { { "Hell Island Crate", 125 }, { "Hell Island Present", 100 }, { "Hell Island Small Chest", 55 }, { "Hell Island Chest", 30 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			["Hell Chest"] = {
				settings = {
					maxCoins = 2, 
					healthMult = 90000, 
					area = "Hell Island", 
					respawnCooldown = true
				}, 
				coins = { { "Hell Island Hell Chest", 100 } }
			}, 
			Heaven = {
				settings = {
					maxCoins = 60, 
					healthMult = 125000, 
					area = "Heaven Island", 
					respawnCooldown = false
				}, 
				coins = { { "Heaven Island Tiny Coins", 35 }, { "Heaven Island Coins", 70 }, { "Heaven Island Large Coins", 40 }, { "Heaven Island Crate", 30 }, { "Heaven Island Present", 18 }, { "Heaven Island Safe", 11 }, { "Heaven Island Vault", 8 }, { "Heaven Island Small Chest", 10 }, { "Heaven Island Chest", 8 }, { "Diamonds", 10 }, { "Banana", 0.5 }, { "Apple", 0.5 }, { "Rainbow Fruit", 0.5 }, { "Pear", 0.5 }, { "Orange", 0.5 }, { "Pineapple", 0.5 } }
			}, 
			["Angel Chest"] = {
				settings = {
					maxCoins = 2, 
					healthMult = 125000, 
					area = "Heaven Island", 
					respawnCooldown = true
				}, 
				coins = { { "Heaven Island Angel Chest", 100 } }
			}, 
			["Grand Heaven Chest"] = {
				settings = {
					maxCoins = 1, 
					healthMult = 125000, 
					area = "Heavens Gate", 
					respawnCooldown = true
				}, 
				coins = { { "Heavens Gate Grand Heaven Chest", 100 } }
			}
		}
	}
}

return Data