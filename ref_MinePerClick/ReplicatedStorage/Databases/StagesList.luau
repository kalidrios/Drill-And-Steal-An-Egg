-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ReplicatedStorage"):WaitForChild("Assets")

local Stages = game.Workspace:WaitForChild("Stages")

return {
	{
		MinimumRarity = "Common",
		MaxRarity = "Rare",
		ProductId = 3609813533,
		Luck = 1,
		Folder = Stages:FindFirstChild("Stage 1"),
		Stages = {
			{
				MaxHealth = 1,
				Wall = Stages:FindFirstChild("Stage 1"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 5,
				Wall = Stages:FindFirstChild("Stage 1"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 15,
				Wall = Stages:FindFirstChild("Stage 1"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Uncommon",
		MaxRarity = "Rare",
		ProductId = 3609813567,
		Luck = 2,
		Folder = Stages:FindFirstChild("Stage 2"),
		Stages = {
			{
				MaxHealth = 50,
				Wall = Stages:FindFirstChild("Stage 2"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 200,
				Wall = Stages:FindFirstChild("Stage 2"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 500,
				Wall = Stages:FindFirstChild("Stage 2"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Uncommon",
		MaxRarity = "Epic",
		ProductId = 3609813599,
		Luck = 3,
		Folder = Stages:FindFirstChild("Stage 3"),
		Stages = {
			{
				MaxHealth = 500,
				Wall = Stages:FindFirstChild("Stage 3"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 2500,
				Wall = Stages:FindFirstChild("Stage 3"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 5000,
				Wall = Stages:FindFirstChild("Stage 3"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Rare",
		MaxRarity = "Legendary",
		ProductId = 3609813624,
		Luck = 4,
		Folder = Stages:FindFirstChild("Stage 4"),
		Stages = {
			{
				MaxHealth = 10000,
				Wall = Stages:FindFirstChild("Stage 4"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 25000,
				Wall = Stages:FindFirstChild("Stage 4"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 50000,
				Wall = Stages:FindFirstChild("Stage 4"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Rare",
		MaxRarity = "Legendary",
		ProductId = 3609813735,
		Luck = 5,
		Folder = Stages:FindFirstChild("Stage 5"),
		Stages = {
			{
				MaxHealth = 100000,
				Wall = Stages:FindFirstChild("Stage 5"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 300000,
				Wall = Stages:FindFirstChild("Stage 5"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 500000,
				Wall = Stages:FindFirstChild("Stage 5"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Epic",
		MaxRarity = "Mythic",
		ProductId = 3609813754,
		Luck = 7,
		Folder = Stages:FindFirstChild("Stage 6"),
		Stages = {
			{
				MaxHealth = 1500000,
				Wall = Stages:FindFirstChild("Stage 6"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 3500000,
				Wall = Stages:FindFirstChild("Stage 6"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 5000000,
				Wall = Stages:FindFirstChild("Stage 6"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Epic",
		MaxRarity = "Mythic",
		ProductId = 3609813796,
		Luck = 9,
		Folder = Stages:FindFirstChild("Stage 7"),
		Stages = {
			{
				MaxHealth = 15000000,
				Wall = Stages:FindFirstChild("Stage 7"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 35000000,
				Wall = Stages:FindFirstChild("Stage 7"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 50000000,
				Wall = Stages:FindFirstChild("Stage 7"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Legendary",
		MaxRarity = "Secret",
		ProductId = 3609813823,
		Luck = 12,
		Folder = Stages:FindFirstChild("Stage 8"),
		Stages = {
			{
				MaxHealth = 150000000,
				Wall = Stages:FindFirstChild("Stage 8"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 250000000,
				Wall = Stages:FindFirstChild("Stage 8"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 350000000,
				Wall = Stages:FindFirstChild("Stage 8"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Legendary",
		MaxRarity = "Secret",
		ProductId = 3609813912,
		Luck = 16,
		Folder = Stages:FindFirstChild("Stage 9"),
		Stages = {
			{
				MaxHealth = 1500000000,
				Wall = Stages:FindFirstChild("Stage 9"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 3500000000,
				Wall = Stages:FindFirstChild("Stage 9"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 5000000000,
				Wall = Stages:FindFirstChild("Stage 9"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Legendary",
		MaxRarity = "Godly",
		ProductId = 3609813958,
		Luck = 21,
		Folder = Stages:FindFirstChild("Stage 10"),
		Stages = {
			{
				MaxHealth = 5000000000,
				Wall = Stages:FindFirstChild("Stage 10"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 15000000000,
				Wall = Stages:FindFirstChild("Stage 10"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 25000000000,
				Wall = Stages:FindFirstChild("Stage 10"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Mythic",
		MaxRarity = "Godly",
		ProductId = 3609813980,
		Luck = 27,
		Folder = Stages:FindFirstChild("Stage 11"),
		Stages = {
			{
				MaxHealth = 50000000000,
				Wall = Stages:FindFirstChild("Stage 11"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 150000000000,
				Wall = Stages:FindFirstChild("Stage 11"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 250000000000,
				Wall = Stages:FindFirstChild("Stage 11"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Mythic",
		MaxRarity = "Godly",
		ProductId = 3609813980,
		Luck = 34,
		Folder = Stages:FindFirstChild("Stage 12"),
		Stages = {
			{
				MaxHealth = 500000000000,
				Wall = Stages:FindFirstChild("Stage 12"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 750000000000,
				Wall = Stages:FindFirstChild("Stage 12"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 1000000000000,
				Wall = Stages:FindFirstChild("Stage 12"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Mythic",
		MaxRarity = "Godly",
		ProductId = 3609814054,
		Luck = 42,
		Folder = Stages:FindFirstChild("Stage 13"),
		Stages = {
			{
				MaxHealth = 2500000000000,
				Wall = Stages:FindFirstChild("Stage 13"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 5000000000000,
				Wall = Stages:FindFirstChild("Stage 13"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 10000000000000,
				Wall = Stages:FindFirstChild("Stage 13"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Secret",
		MaxRarity = "Godly",
		ProductId = 3609814090,
		Luck = 51,
		Folder = Stages:FindFirstChild("Stage 14"),
		Stages = {
			{
				MaxHealth = 10000000000000,
				Wall = Stages:FindFirstChild("Stage 14"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 25000000000000,
				Wall = Stages:FindFirstChild("Stage 14"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 50000000000000,
				Wall = Stages:FindFirstChild("Stage 14"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Secret",
		MaxRarity = "Godly",
		ProductId = 3609814090,
		Luck = 61,
		Folder = Stages:FindFirstChild("Stage 15"),
		Stages = {
			{
				MaxHealth = 100000000000000,
				Wall = Stages:FindFirstChild("Stage 15"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 500000000000000,
				Wall = Stages:FindFirstChild("Stage 15"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 1000000000000000,
				Wall = Stages:FindFirstChild("Stage 15"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Secret",
		MaxRarity = "Godly",
		ProductId = 3609814090,
		Luck = 72,
		Folder = Stages:FindFirstChild("Stage 16"),
		Stages = {
			{
				MaxHealth = 1000000000000000,
				Wall = Stages:FindFirstChild("Stage 16"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 2500000000000000,
				Wall = Stages:FindFirstChild("Stage 16"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 5000000000000000,
				Wall = Stages:FindFirstChild("Stage 16"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Godly",
		ProductId = 3609814090,
		Luck = 100,
		Folder = Stages:FindFirstChild("Stage 17"),
		Stages = {
			{
				MaxHealth = 1e16,
				Wall = Stages:FindFirstChild("Stage 17"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 2.5e16,
				Wall = Stages:FindFirstChild("Stage 17"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 3.5e16,
				Wall = Stages:FindFirstChild("Stage 17"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Godly",
		ProductId = 3609814090,
		Luck = 125,
		Folder = Stages:FindFirstChild("Stage 18"),
		Stages = {
			{
				MaxHealth = 7.5e16,
				Wall = Stages:FindFirstChild("Stage 18"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 1e17,
				Wall = Stages:FindFirstChild("Stage 18"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 1.25e17,
				Wall = Stages:FindFirstChild("Stage 18"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Godly",
		ProductId = 3609814090,
		Luck = 150,
		Folder = Stages:FindFirstChild("Stage 19"),
		Stages = {
			{
				MaxHealth = 1.25e17,
				Wall = Stages:FindFirstChild("Stage 19"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 1.75e17,
				Wall = Stages:FindFirstChild("Stage 19"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 2e17,
				Wall = Stages:FindFirstChild("Stage 19"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Godly",
		ProductId = 3609814090,
		Luck = 175,
		Folder = Stages:FindFirstChild("Stage 20"),
		Stages = {
			{
				MaxHealth = 2e17,
				Wall = Stages:FindFirstChild("Stage 20"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 3e17,
				Wall = Stages:FindFirstChild("Stage 20"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 4e17,
				Wall = Stages:FindFirstChild("Stage 20"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Godly",
		ProductId = 3609814090,
		Luck = 200,
		Folder = Stages:FindFirstChild("Stage 21"),
		Stages = {
			{
				MaxHealth = 5e17,
				Wall = Stages:FindFirstChild("Stage 21"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 6e17,
				Wall = Stages:FindFirstChild("Stage 21"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 7e17,
				Wall = Stages:FindFirstChild("Stage 21"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	},
	{
		MinimumRarity = "Godly",
		ProductId = 3609814090,
		Luck = 250,
		Folder = Stages:FindFirstChild("Stage 22"),
		Stages = {
			{
				MaxHealth = 8e17,
				Wall = Stages:FindFirstChild("Stage 22"):FindFirstChild("Stages"):FindFirstChild("1")
			},
			{
				MaxHealth = 9e17,
				Wall = Stages:FindFirstChild("Stage 22"):FindFirstChild("Stages"):FindFirstChild("2")
			},
			{
				MaxHealth = 1e18,
				Wall = Stages:FindFirstChild("Stage 22"):FindFirstChild("Stages"):FindFirstChild("3")
			}
		}
	}
}