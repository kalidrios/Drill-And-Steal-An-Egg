-- Maked for kalidrios in 07/10/2024 by https://github.com/kalidrios or capa_louka

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Variables = {}

Variables.BloombergCost = 50000
Variables.ExclusiveEggSpacingRadius = 5
Variables.ExclusiveEggRadiusRange = Vector2.new(10, 50)
Variables.ExclusiveEggRadiusStep = 1
Variables.ExclusiveEggRadiusBuffer = 5
Variables.ExclusiveEggMaxHeight = 15
Variables.ExclusiveEggHeightOffset = 10
Variables.ExclusiveEggMaxHeightBuffer = 5
Variables.ExclusiveEggOpenAmounts = { 1, 3, 8 }
Variables.ShopNumber = 1
Variables.PetsForSale = {
    ["239"] = true,
    ["515"] = true,
    ["2078"] = true,
    ["3013"] = true,
    ["2104"] = true,
    ["564"] = true,
    ["565"] = true,
    ["566"] = true,
    ["2106"] = true,
    ["2107"] = true,
    ["3014"] = true
}

Variables.ExclusiveEggCosts = {
	[1] = 35000000,
	[3] = 105000000,
	[10] = 280000000,
	[100] = 2800000000
}

Variables.BoostsCosts = {
	["Triple Coins"] = 7500,
	["Triple Damage"] = 7500,
	["Super Lucky"] = 7500,
	["Ultra Lucky"] = 7500,
	["Pack"] = 24000
}

Variables.Purchasables = {
	["Triple Coins"] = {
		Cost = 25,
		class = "Boost",
		Amount = 1,
		inf = true
	},
	["Triple Damage"] = {
		Cost = 15,
		class = "Boost",
		Amount = 1,
		inf = true
	},
	["Super Lucky"] = {
		Cost = 15,
		class = "Boost",
		Amount = 1,
		inf = true
	},
	["Ultra Lucky"] = {
		Cost = 25,
		class = "Boost",
		Amount = 1,
		inf = true
	},
	["The Boost Bundle"] = {
		Cost = 25,
		class = "BoostBundle",
		inf = true
	},
	["Lucky"] = {
		Cost = 300,
		class = "Gamepass"
	},
	["Auto Hatch"] = {
		Cost = 120,
		class = "Gamepass"
	},
	["Mythical Hunter"] = {
		Cost = 1400,
		class = "Gamepass"
	},
	["Shiny Hunter"] = {
		Cost = 1000,
		class = "Gamepass"
	},
	["Octuple Egg Open"] = {
		Cost = 85,
		class = "Product",
		Requires = "Triple Egg Open"
	},
	["VIP"] = {
		Cost = 500,
		class = "Gamepass"
	},
	["Super Pet Storage"] = {
		Cost = 300,
		class = "Gamepass"
	},
	["Teleport"] = {
		Cost = 80,
		class = "Gamepass"
	},
	["Magic Eggs"] = {
		Cost = 1000,
		class = "Gamepass"
	},
	["Hoverboard"] = {
		Cost = 190,
		class = "Gamepass"
	},
	["Triple Egg Open"] = {
		Cost = 500,
		class = "Gamepass"
	},
	["15 Pets Equipped"] = {
		Cost = 110,
		class = "Product",
		Requires = "8 Pets Equipped"
	},
	["Secret Hunter"] = {
		Cost = 125,
		class = "Gamepass"
	},
	["Pet Storage"] = {
		Cost = 80,
		class = "Gamepass"
	},
	["Skip Egg Open"] = {
		Cost = 100,
		class = "Gamepass"
	},
	["Magnet"] = {
		Cost = 160,
		class = "Gamepass"
	},
	["8 Pets Equipped"] = {
		Cost = 260,
		class = "Gamepass"
	}, 
	["Exclusive1"] = {
		Cost = 40,
		class = "ExclusiveEgg",
		Amount = 1,
		inf = true
	},
	["Exclusive3"] = {
		Cost = 110,
		class = "ExclusiveEgg",
		Amount = 3,
		inf = true
	},
	["Exclusive10"] = {
		Cost = 320,
		class = "ExclusiveEgg",
		Amount = 10,
		inf = true
	},
	["Exclusive100"] = {
		Cost = 2500,
		class = "ExclusiveEgg",
		Amount = 100,
		inf = true
	},
	["Valentine Broadcast"] = {
		Cost = 15,
		class = "Product",
		inf = true
	},
}

Variables.UpdateLogId = 52
Variables.HardcorePetMult = 10000000000000
Variables.HardcorePetMultNormal = 1.5
Variables.HardcorePetMinPowerNormal = 1000000000
Variables.PetTypeMult = {
	Golden = 3,
	Rainbow = 7,
	["Dark Matter"] = 20,
	Shiny = 2.5
}
Variables.FreeGiftsResetTime = 43200
Variables.BankMaxPetsPerTransaction = 50
Variables.TitanicMult = {
	Default = 7.5,
	Golden = 8.75,
	Rainbow = 11.25
}
Variables.BestFriendMult = {
	Default = 1.5,
	Golden = 1.75,
	Rainbow = 2.25
}
Variables.GoldMachineOdds = {
	Normal = {
		{
			chance = 20,
			cost = 250
		},
		{
			chance = 40,
			cost = 400
		},
		{
			chance = 60,
			cost = 600
		},
		{
			chance = 80,
			cost = 800
		},
		{
			chance = 100,
			cost = 1000
		}
	},
	Hardcore = {
		[1] = {
			chance = 8,
			cost = 5000
		},
		[2] = {
			chance = 17,
			cost = 8000
		},
		[3] = {
			chance = 29,
			cost = 12000
		},
		[4] = {
			chance = 37,
			cost = 16000
		},
		[5] = {
			chance = 46,
			cost = 20000
		},
		[6] = {
			chance = 55,
			cost = 25000
		},
		[7] = {
			chance = 67,
			cost = 30000
		},
		[8] = {
			chance = 78,
			cost = 35000
		},
		[9] = {
			chance = 88,
			cost = 40000
		},
		[10] = {
			chance = 100,
			cost = 50000
		}
	}
}
Variables.RainbowMachineOdds = {
	Normal = {
		[1] = {
			chance = 25,
			cost = 400
		},
		[2] = {
			chance = 50,
			cost = 700
		},
		[3] = {
			chance = 75,
			cost = 1050
		},
		[4] = {
			chance = 100,
			cost = 1400
		},
	},
	Hardcore = {
		[1] = {
			chance = 8,
			cost = 8000
		},
		[2] = {
			chance = 17,
			cost = 14000
		},
		[3] = {
			chance = 29,
			cost = 22500
		},
		[4] = {
			chance = 37,
			cost = 28000
		},
		[5] = {
			chance = 46,
			cost = 35000
		},
		[6] = {
			chance = 55,
			cost = 45000
		},
		[7] = {
			chance = 67,
			cost = 55000
		},
		[8] = {
			chance = 78,
			cost = 65000
		},
		[9] = {
			chance = 88,
			cost = 80000
		},
		[10] = {
			chance = 100,
			cost = 100000
		}
	}
}
-- Dark Matter Machine - Instant Crafting (like Golden/Rainbow)
Variables.DarkMatterMachineOdds = {
	Normal = {
		[1] = {
			chance = 25,
			cost = 25000
		},
		[2] = {
			chance = 50,
			cost = 62500
		},
		[3] = {
			chance = 75,
			cost = 90000
		},
		[4] = {
			chance = 100,
			cost = 125000
		}
	},
	Hardcore = {
		[1] = {
			chance = 10,
			cost = 250000
		},
		[2] = {
			chance = 25,
			cost = 625000
		},
		[3] = {
			chance = 50,
			cost = 900000
		},
		[4] = {
			chance = 75,
			cost = 1250000
		},
		[5] = {
			chance = 100,
			cost = 1500000
		}
	}
}
Variables.EnchantCost = 10000
Variables.EnchantHardcoreCost = 500000
Variables.FusePetsCost = 5000
Variables.FuseMaxPets = 12
Variables.FuseMinPets = 3
Variables.FuseHardcoreCost = 250000
Variables.BoostsInfo = {
	["Triple Coins"] = {
		icon = "rbxassetid://117893736813987",
		desc = "3x Coins"
	},
	["Triple Damage"] = {
		icon = "rbxassetid://103830218090770",
		desc = "3x Damage"
	},
	["Triple Diamonds"] = {
		icon = "rbxassetid://13132216780",
		desc = "3x Diamonds"
	},
	Lucky = {
		icon = "rbxassetid://100252075867005",
		desc = "Lucky"
	},
	["Super Lucky"] = {
		icon = "rbxassetid://113476250487312",
		desc = "Super Lucky"
	},
	["Ultra Lucky"] = {
		icon = "rbxassetid://104432957516372",
		desc = "Ultra Lucky"
	},
	["Magic Eggs"] = {
		icon = "rbxassetid://103568760565715",
		desc = "Magic Eggs"
	},
	["Mythical Hunter"] = {
		icon = "rbxassetid://76499595457108",
		desc = "Mythical Hunter"
	},
	["Secret Hunter"] = {
		icon = "rbxassetid://12147083097",
		desc = "Secret Hunter"
	},
	["Shiny Hunter"] = {
		icon = "rbxassetid://132731182881530",
		desc = "Shiny Hunter"
	},
	Verified = {
		icon = "rbxassetid://7599327451",
		desc = "+50% XP"
	},
	VIP = {
		icon = "rbxassetid://128526012618889",
		desc = "+100% XP"
	},
	["Coins Event"] = {
		icon = "rbxassetid://7599296480",
		desc = "2x Coins Event"
	},
	["Luck Event"] = {
		icon = "rbxassetid://9502727028",
		desc = "Luck Event"
	},
	Friends = {
		icon = "rbxassetid://7621017602",
		desc = "Coin Mult"
	},
	Pineapple = {
		icon = "rbxassetid://12959517117",
		desc = "{mult}x Speed"
	},
	Orange = {
		icon = "rbxassetid://12959517323",
		desc = "{mult}x Diamonds"
	},
	Pear = {
		icon = "rbxassetid://12959517211",
		desc = "{mult}x Coins"
	},
	Banana = {
		icon = "rbxassetid://12959517469",
		desc = "+{mult}x Luck"
	},
	Apple = {
		icon = "rbxassetid://12959517558",
		desc = "{mult}x Damage"
	}
}
Variables.ServerBoostsInfo = {
	["Triple Coins"] = {
		icon = "rbxassetid://117893736813987",
		desc = "Server 3x Coins",
		tripleIcon = true
	},
	["Triple Damage"] = {
		icon = "rbxassetid://103830218090770",
		desc = "Server 3x Damage",
		tripleIcon = true
	},
	["Super Lucky"] = {
		icon = "rbxassetid://113476250487312",
		desc = "Server Super Lucky",
		tripleIcon = true
	},
	["Super Breaker"] = {
		icon = "rbxassetid://103830218090770",
		desc = "Server 25x Damage",
		loginAnnounce = true,
		msg = "All pet damage does an additional 25x damage!"
	},
	["Insane Luck"] = {
		icon = "rbxassetid://104432957516372",
		desc = "Server 25x Luck",
		loginAnnounce = true,
		msg = "All egg luck has been increased by 25x luck!"
	}
}
-- DarkMatterSkipProducts removed - Dark Matter is now instant crafting like Golden/Rainbow
Variables.HugeMachineUseProducts = {
	{
		pointsMin = 50,
		pointsMax = 74,
		productId = 1592680774,
		price = 50
	},
	{
		pointsMin = 75,
		pointsMax = 99,
		productId = 1592680619,
		price = 19
	},
	{
		pointsMin = 100,
		pointsMax = 100
	}
}
Variables.HugeMachineMaxPetPoints = 8
Variables.MerchantLevelReq = {
	[1] = 0,
	[2] = 8,
	[3] = 20
}
Variables.AchievementDifficulty = {
	[1] = {
		Name = "EZPZ :)",
		Color = Color3.fromRGB(180, 180, 180)
	},
	[2] = {
		Name = "Easy",
		Color = Color3.fromRGB(39,233,55)
	},
	[3] = {
		Name = "Medium",
		Color = Color3.fromRGB(255, 184, 62)
	},
	[4] = {
		Name = "Hard",
		Color = Color3.fromRGB(255, 60, 60)
	},
	[5] = {
		Name = "Insane",
		Color = Color3.fromRGB(153, 64, 255)
	}
}
Variables.PetCollectionTiers = {
	[1] = 150,
	[2] = 250,
	[3] = 350,
	[4] = 500,
	[5] = 650,
	[6] = 800,
	[7] = 1000
}
Variables.RankChart = {
	[1] = "Noob",
	[2] = "Just Got In",
	[3] = "Average Enjoyer",
	[4] = "Weekender Warrior",
	[5] = "Roblox Technician",
	[6] = "Trippi Hero",
	[7] = "Bombardino Main",
	[8] = "Dumpster Lord",
	[9] = "Capuchino Ultra",
	[10] = "Udindindindin",
	[11] = "Garam Ascended",
	[12] = "Tralalero Ultra",
	[13] = "Chimpanzini.exe",
	[14] = "Sahur Gold",
	[15] = "Peak Fiction",
	[16] = "Fiction Overload",
	[17] = "Brainrot Overdrive",
	[18] = "Lord of Memes",
	[19] = "Collector of Creatures",
	[20] = "Trash Deity"
}
Variables.PetRarityNumbers = {
	Basic = 1,
	Rare = 2,
	Epic = 3,
	Legendary = 4,
	Mythical = 5,
	Secret = 6,
	Event = 7,
	Exclusive = 8
}
Variables.PetRarityList = {}
for key2, _ in pairs(Variables.PetRarityNumbers) do
	table.insert(Variables.PetRarityList, key2)
end
Variables.FanArt = {
	{
		"rbxassetid://7249691240",
		"prec1osa"
	},
	{
		"rbxassetid://7249691383",
		"VitaminSe_a"
	},
	{
		"rbxassetid://7249691487",
		"Fragman_100"
	},
	{
		"rbxassetid://7249691593",
		"minimini61234"
	},
	{
		"rbxassetid://7249691698",
		"Jones_vedita"
	},
	{
		"rbxassetid://7249691856",
		"abridayyy"
	},
	{
		"rbxassetid://7249691950",
		"SneakyThiefy"
	},
	{
		"rbxassetid://7249692052",
		"Sketchiko"
	},
	{
		"rbxassetid://7249692135",
		"Oburnt"
	},
	{
		"rbxassetid://7249692223",
		"Crxmsey"
	},
	{
		"rbxassetid://7249692321",
		"alex0r23"
	},
	{
		"rbxassetid://7626524975",
		"Alper_XxX"
	},
	{
		"rbxassetid://7626525350",
		"Luminous_Vybe"
	},
	{
		"rbxassetid://7626525557",
		"Y666_666Y"
	},
	{
		"rbxassetid://7626525901",
		"TrayNotPH"
	},
	{
		"rbxassetid://7626526268",
		"6gls"
	},
	{
		"rbxassetid://7626526626",
		"Axyndey"
	},
	{
		"rbxassetid://7626526871",
		"OfficialSando"
	},
	{
		"rbxassetid://7626527112",
		"mylli128"
	},
	{
		"rbxassetid://7626527487",
		"AverageGirl170"
	},
	{
		"rbxassetid://8994062774",
		"GirlyProGamer1235"
	},
	{
		"rbxassetid://8994066065",
		"Cookie33335"
	},
	{
		"rbxassetid://8994071134",
		"Cookie33335"
	},
	{
		"rbxassetid://8994074573",
		"SlayedSorcerer"
	},
	{
		"rbxassetid://8994076079",
		"Cookie33335"
	},
	{
		"rbxassetid://8994077585",
		"Cookie33335"
	},
	{
		"rbxassetid://8994079163",
		"Cookie33335"
	},
	{
		"rbxassetid://8994084615",
		"HerixHelios"
	},
	{
		"rbxassetid://8994087971",
		"Cookie33335"
	},
	{
		"rbxassetid://8994093709",
		"Cookie33335"
	},
	{
		"rbxassetid://12653750753",
		"TheBabyFireDragon"
	},
	{
		"rbxassetid://12653750916",
		"TheBabyFireDragon"
	},
	{
		"rbxassetid://12653750840",
		"TheBabyFireDragon"
	},
	{
		"rbxassetid://12653751620",
		"sooty"
	},
	{
		"rbxassetid://12653751724",
		"SlayedSorcerer"
	},
	{
		"rbxassetid://12653751871",
		"SlayedSorcerer"
	},
	{
		"rbxassetid://12653752087",
		"Sir_Bingus"
	},
	{
		"rbxassetid://12653752313",
		"Sir_Bingus"
	},
	{
		"rbxassetid://12653752226",
		"Sir_Bingus"
	},
	{
		"rbxassetid://12653752405",
		"Setrah99"
	},
	{
		"rbxassetid://12653752580",
		"seinzie"
	},
	{
		"rbxassetid://12653752688",
		"seinzie"
	},
	{
		"rbxassetid://12653752812",
		"seinzie"
	},
	{
		"rbxassetid://12653752965",
		"seinzie"
	},
	{
		"rbxassetid://12653753124",
		"seinzie"
	},
	{
		"rbxassetid://12653753260",
		"seinzie"
	},
	{
		"rbxassetid://12653753433",
		"seinzie"
	},
	{
		"rbxassetid://12653753570",
		"seinzie"
	},
	{
		"rbxassetid://12653753727",
		"seinzie"
	},
	{
		"rbxassetid://12653753887",
		"seinzie"
	},
	{
		"rbxassetid://12653754019",
		"seinzie"
	},
	{
		"rbxassetid://12653754129",
		"seinzie"
	},
	{
		"rbxassetid://12653754295",
		"seinzie"
	},
	{
		"rbxassetid://12653754454",
		"seinzie"
	},
	{
		"rbxassetid://12653754536",
		"seinzie"
	},
	{
		"rbxassetid://12653754667",
		"seinzie"
	},
	{
		"rbxassetid://12653754820",
		"mooshibee"
	},
	{
		"rbxassetid://12653754936",
		"seinzie"
	},
	{
		"rbxassetid://12653755063",
		"SaDboyTo_11"
	},
	{
		"rbxassetid://12653755168",
		"mylli128"
	},
	{
		"rbxassetid://12653755314",
		"mooshibee"
	},
	{
		"rbxassetid://12653755429",
		"MissGxrgie"
	},
	{
		"rbxassetid://12653755524",
		"JustPlayinForFuns"
	},
	{
		"rbxassetid://12653755660",
		"IrisTheGamerr"
	},
	{
		"rbxassetid://12653755841",
		"I'mMiMi"
	},
	{
		"rbxassetid://12653755957",
		"I'mMiMi"
	},
	{
		"rbxassetid://12653756073",
		"I'mMiMi"
	},
	{
		"rbxassetid://12653756189",
		"I'mMiMi"
	},
	{
		"rbxassetid://12653756392",
		"I'mMiMi"
	},
	{
		"rbxassetid://12653756506",
		"I'mMiMi"
	},
	{
		"rbxassetid://12653756664",
		"I'mMiMi"
	},
	{
		"rbxassetid://12653756846",
		"hu5p"
	},
	{
		"rbxassetid://12653757031",
		"HueyAcc"
	},
	{
		"rbxassetid://12653757208",
		"HerixHelios"
	},
	{
		"rbxassetid://12653757299",
		"HerixHelios"
	},
	{
		"rbxassetid://12653757299",
		"Hamikee"
	},
	{
		"rbxassetid://12653757581",
		"Hakdog050406"
	},
	{
		"rbxassetid://12653757763",
		"Hakdog050406"
	},
	{
		"rbxassetid://12653757834",
		"ExpertGamings_YT"
	},
	{
		"rbxassetid://12653757987",
		"drift6480"
	},
	{
		"rbxassetid://12653758120",
		"Cookie33335"
	},
	{
		"rbxassetid://12653758376",
		"celi_mimi"
	},
	{
		"rbxassetid://12653758448",
		"AzealySnek"
	},
	{
		"rbxassetid://12653758552",
		"Alashaaaaaaaahhh"
	},
	{
		"rbxassetid://12653759255",
		"Sylzagoon"
	},
	{
		"rbxassetid://12653759440",
		"Sylzagoon"
	},
	{
		"rbxassetid://12653759541",
		"Sylzagoon"
	},
	{
		"rbxassetid://12653759663",
		"Sylzagoon"
	},
	{
		"rbxassetid://12653759823",
		"Sylzagoon"
	},
	{
		"rbxassetid://12653759898",
		"Sylzagoon"
	},
	{
		"rbxassetid://12653760012",
		"Sylzagoon"
	},
	{
		"rbxassetid://12653760112",
		"InniIili"
	},
	{
		"rbxassetid://12653760214",
		"HueyAcc"
	},
	{
		"rbxassetid://12653760363",
		"cherryygyu"
	},
	{
		"rbxassetid://12671813804",
		"GalliChanx"
	},
	{
		"rbxassetid://12695931160",
		"michaleku0"
	}
}

Variables.Nicknames = {
	"kalidrios",
	"Nither",
	"WorthLess",
	"Bwee", 
	"Ethan",
	"Bella",
	"Luna",
	"Charlie",
	"Lucy",
	"Cooper",
	"Max",
	"Bailey",
	"Daisy",
	"Sadie",
	"Lola",
	"Buddy",
	"Molly",
	"Stella",
	"Tucker",
	"Bear",
	"Zoey",
	"Duke",
	"Harley",
	"Jax",
	"Bentley",
	"Milo",
	"Oscar",
	"Oliver",
	"Riley",
	"Rocky",
	"Penny",
	"Sophie",
	"Chloe",
	"Jack",
	"Lily",
	"Nala",
	"Zues",
	"Ellie",
	"Winston",
	"Toby",
	"Loki",
	"Roxy",
	"Coco",
	"Rosie",
	"Teddy",
	"Ruby",
	"Gracie",
	"Leo",
	"Finn",
	"Scout",
	"Dexter",
	"Ollie",
	"Koda",
	"Isaac",
	"Rob",
	"Stefan",
	"Claudia",
	"Mitchell",
	"Conner",
	"Adam",
	"Joey",
	"Tony",
	"Saad",
	"Lexi"
}
Variables.SettingsInfo = {
	Music = {
		title = "Music",
		options = {
			[1] = "On",
			[2] = "Off"
		},
		sort = 2
	},
	SFX = {
		title = "SFX",
		options = {
			[1] = "On",
			[2] = "Off"
		},
		sort = 3
	},
	PetSFX = {
		title = "Brainrot SFX",
		options = {
			[1] = "On",
			[2] = "Off"
		},
		sort = 4
	},
	Trading = {
		title = "Trading",
		options = {
			[1] = "All",
			[2] = "Friends",
			[3] = "Disabled"
		},
		sort = 1
	},
	Notifications = {
		title = "Notifications",
		options = {
			[1] = "Enabled",
			[2] = "Disabled"
		},
		sort = 5
	},
	ShowOtherPets = {
		title = "Show Other Pets",
		options = {
			[1] = "Yes",
			[2] = "No"
		},
		sort = 6
	},
	PetsControl = {
		title = "Pet Sending",
		options = {
			[1] = "Single",
			[2] = "All"
		},
		sort = 7
	},
	ShowBoosts = {
		title = "Show Boosts",
		options = {
			[1] = "Yes",
			[2] = "No"
		},
		sort = 8
	},
	MountingTitanics = {
		title = "Mounting Titanics",
		options = {
			[1] = "On",
			[2] = "Off"
		},
		sort = 9
	},
	EggSkip = {
		title = "Box Skip",
		options = {
			[1] = "Basic Brainrots",
			[2] = "Rare Brainrots",
			[3] = "Epic Brainrots",
			[4] = "All Brainrots"
		},
		sort = 15
	}
}
Variables.ChristmasEventQuests = {
	[1] = {
		Desc = "Break 100 Candy Canes",
		Type = "Candycane",
		Needed = 100,
		Reward = {
			"Gingerbread",
			1000000
		}
	},
	[2] = {
		Desc = "Break 2 Gingerbread Chests",
		Type = "GingerbreadChest",
		Needed = 2,
		Reward = {
			"Triple Coins Boost",
			8
		}
	},
	[3] = {
		Desc = "Earn 20,000,000 Gingerbread",
		Type = "Gingerbread",
		Needed = 20000000,
		Reward = {
			"Diamonds",
			250000
		}
	},
	[4] = {
		Desc = "Break 1,250 Candy Canes",
		Type = "Candycane",
		Needed = 1250,
		Reward = {
			"Diamonds",
			1000000
		}
	},
	[5] = {
		Desc = "Break 40 Gingerbread Chests",
		Type = "GingerbreadChest",
		Needed = 40,
		Reward = {
			"Santas Sleigh",
			1
		}
	}
}
Variables.ChristmasEventQuests2022 = {
	[1] = {
		Desc = "Find today's Elf on a Shelf",
		Type = "ElfOnShelf",
		Needed = 1,
		Reward = {
			"Gingerbread",
			5000000
		}
	},
	[2] = {
		Desc = "Break 100 Candy Canes",
		Type = "Candycane",
		Needed = 100,
		Reward = {
			"Triple Coins Boost",
			25
		}
	},
	[3] = {
		Desc = "Participate in Santa Paws Event",
		Type = "SantaPaws",
		Needed = 1,
		Reward = {
			"Diamonds",
			1000000
		}
	},
	[4] = {
		Desc = "Find all 20 Hidden Presents",
		Type = "Presents",
		Needed = 20,
		Reward = {
			"Triple Damage Boost",
			30
		}
	},
	[5] = {
		Desc = "Break 1,250 Candy Canes",
		Type = "Candycane",
		Needed = 1250,
		Reward = {
			"Gingerbread",
			500000000
		}
	},
	[6] = {
		Desc = "Participate in Grinch Theft Event",
		Type = "GrinchTheft",
		Needed = 1,
		Reward = {
			"Diamonds",
			5000000
		}
	},
	[7] = {
		Desc = "Open 500 Christmas Eggs",
		Type = "ChristmasEggs",
		Needed = 500,
		Reward = {
			"Ultra Lucky Boost",
			50
		}
	},
	[8] = {
		Desc = "Unlock Santa Paw's Cottage",
		Type = "Cottage",
		Needed = 1,
		Reward = {
			"Diamonds",
			25000000
		}
	},
	[9] = {
		Desc = "Break 50 Gingerbread Chests",
		Type = "GingerbreadChest",
		Needed = 50,
		Reward = {
			"Diamonds",
			100000000
		}
	},
	[10] = {
		Desc = "Break 10 Golden Gingerbread Chests",
		Type = "GoldGingerbreadChest",
		Needed = 10,
		Reward = {
			"Rudolph Hoverboard",
			1
		}
	}
}
Variables.HalloweenEventQuests = {
	[1] = {
		Desc = "Open 10 Pumpkin Eggs",
		Type = "PumpkinEggs",
		Needed = 10,
		Reward = {
			"Halloween Candy",
			250000
		}
	},
	[2] = {
		Desc = "Collect 3 million Candy",
		Type = "CandyCurrency",
		Needed = 3000000,
		Reward = {
			"Triple Coins Boost",
			10
		}
	},
	[3] = {
		Desc = "Earn 25 Cursed Eggs",
		Type = "CursedEggs",
		Needed = 25,
		Reward = {
			"Diamonds",
			10000000
		}
	},
	[4] = {
		Desc = "Break 5 Giant Pumpkins",
		Type = "GiantPumpkin",
		Needed = 5,
		Reward = {
			"Hoverboard",
			1
		}
	}
}
Variables.ChristmasLoginRewards2022 = {
	[1] = {
		RequiredTime = 30,
		Reward = {
			"Pet",
			"430",
			{r = true}
		}
	},
	[2] = {
		RequiredTime = 900,
		Reward = {
			"Gingerbread",
			5000000
		}
	},
	[3] = {
		RequiredTime = 900,
		Reward = {
			"Pet",
			"262",
			{g = true}
		}
	},
	[4] = {
		RequiredTime = 900,
		Reward = {
			"Boosters",
			{
				"Ultra Lucky",
				100
			}
		}
	},
	[5] = {
		RequiredTime = 900,
		Reward = {
			"Booth",
			"Christmas Booth"
		}
	},
	[6] = {
		RequiredTime = 900,
		Reward = {
			"Diamonds",
			300000000
		}
	},
	[7] = {
		RequiredTime = 900,
		Reward = {
			"Pet",
			"264",
			{r = true}
		}
	},
	[8] = {
		RequiredTime = 900,
		Reward = {
			"Pet",
			"1014"
		}
	}
}
Variables.Valentines2022Quests = {
	[1] = 100,
	[2] = 25,
	[3] = 150
}
Variables.StPatricks2022Quests = {
	[1] = 150,
	[2] = 50,
	[3] = 1
}
Variables.AprilFools2023Quests = {
	[1] = {
		Desc = "Say 'April Fools' in Chat",
		Type = "ChatAprilFools",
		Needed = 1,
		Reward = {
			"Triple Coins Boost",
			100
		}
	},
	[2] = {
		Desc = "Eat 30 Healthy Fruits",
		Type = "Fruit",
		Needed = 30,
		Reward = {
			"Diamonds",
			1000000
		}
	},
	[3] = {
		Desc = "Break 20 Error Chests",
		Type = "AprilFoolsChests",
		Needed = 20,
		Reward = {
			"April Fools PS1",
			1
		}
	}
}
Variables.StPatricks2022GateToStage = {
	["Leprechaun Village"] = 1,
	["Rainbow Heights"] = 2,
	["Lucky Castle"] = 3
}
Variables.Easter2023Quests = {
	[1] = 200,
	[2] = 30,
	[3] = 100
}
Variables.HackerPortalQuests = {[1] = 3}
Variables.TradeRatingRequirement = 5
--[[Variables.PlaceIds = {
    [4491159178] = {
        Main = math.huge,
		Hardcore = math.huge,
        Trading = math.huge,
        VoiceTrading = math.huge,
        ProTrading = math.huge,
        Holding = math.huge
	},
}]]--

-- incase not added on upload --
--[[if not Variables.PlaceIds[game.GameId] then
    Variables.PlaceIds[game.GameId] = {
        Main = game.PlaceId,
        Hardcore = math.huge,
        Trading = math.huge,
        VoiceTrading = math.huge,
        ProTrading = math.huge,
        Holding = math.huge
    }
end]]--

Variables.LocalPlaceIds = {} --Variables.PlaceIds[game.GameId]
Variables.GameIds = {
    Production = math.huge,
	Staging = math.huge,
    Development = 4491159178,
    Playground = math.huge
}

local HardcoreID = 14990212282
local UGCVaultID = 91115203372361

Variables.IsVoiceTradingPlaza =  false --game.PlaceId == Variables.LocalPlaceIds.VoiceTrading
Variables.IsProTradingPlaza =    false --game.PlaceId == Variables.LocalPlaceIds.ProTrading
Variables.IsTradingPlaza =       false --game.PlaceId == Variables.LocalPlaceIds.Trading and true or Variables.IsVoiceTradingPlaza or Variables.IsProTradingPlaza
Variables.IsHardcore =           game.PlaceId == HardcoreID --game.PlaceId == Variables.LocalPlaceIds.Hardcore
Variables.IsUGCVault =           game.PlaceId == UGCVaultID
Variables.IsDevelopment =        false  --game.GameId == Variables.GameIds.Development
Variables.IsProduction =         false  --game.GameId == Variables.GameIds.Production

return Variables
