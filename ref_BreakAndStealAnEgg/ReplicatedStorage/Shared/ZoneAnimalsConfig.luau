-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = {}

v2[1] = 1
v2[2] = 2.5
v2[3] = 6
v1.EggTierChanceBias = v2
v1.SizeFloorMinPool = { [10] = 6 }
v1.IndexRewards = {
    CashMult = 100,
    SpeedZoneShare = 0.3,
    SpeedRankGrowth = 1.5,
    SpeedFinalZoneStep = 2,
    SpeedMin = 60
}

local v3 = {}

v3[1] = {
    {
        Name = "Chicken",
        Rarity = "Common",
        Chance = 46,
        Cash = 1
    },
    {
        Name = "Cat",
        Rarity = "Common",
        Chance = 30,
        Cash = 2
    },
    {
        Name = "Bat",
        Rarity = "Uncommon",
        Chance = 14,
        Cash = 10
    },
    {
        Name = "Anteater",
        Rarity = "Uncommon",
        Chance = 6.5,
        Cash = 13
    },
    {
        Name = "Badger",
        Rarity = "Rare",
        Chance = 2.3,
        Cash = 35
    },
    {
        Name = "Parrot",
        Rarity = "Rare",
        Chance = 0.85,
        Cash = 45
    },
    {
        Name = "GoldenRetriver",
        Rarity = "Epic",
        Chance = 0.3,
        Cash = 145
    },
    {
        Name = "Bear",
        Rarity = "Legendary",
        Chance = 0.05,
        Cash = 1800
    }
}
v3[2] = {
    {
        Name = "Snake",
        Rarity = "Common",
        Chance = 46,
        Cash = 3
    },
    {
        Name = "Tiger",
        Rarity = "Uncommon",
        Chance = 30,
        Cash = 20
    },
    {
        Name = "Lion",
        Rarity = "Uncommon",
        Chance = 14,
        Cash = 25
    },
    {
        Name = "Ankylosaurus",
        Rarity = "Rare",
        Chance = 6.5,
        Cash = 90
    },
    {
        Name = "COCKATRICE",
        Rarity = "Rare",
        Chance = 2.3,
        Cash = 110
    },
    {
        Name = "SPHINX",
        Rarity = "Epic",
        Chance = 0.85,
        Cash = 230
    },
    {
        Name = "CHIREMA",
        Rarity = "Legendary",
        Chance = 0.3,
        Cash = 2800
    },
    {
        Name = "MANTICORE",
        Rarity = "Mythic",
        Chance = 0.05,
        Cash = 12500
    }
}
v3[3] = {
    {
        Name = "Pigeon",
        Rarity = "Uncommon",
        Chance = 46,
        Cash = 40
    },
    {
        Name = "GuiennaPig",
        Rarity = "Uncommon",
        Chance = 30,
        Cash = 65
    },
    {
        Name = "Maltese",
        Rarity = "Rare",
        Chance = 14,
        Cash = 180
    },
    {
        Name = "Goat",
        Rarity = "Rare",
        Chance = 6.5,
        Cash = 240
    },
    {
        Name = "BichonFrise",
        Rarity = "Epic",
        Chance = 2.3,
        Cash = 650
    },
    {
        Name = "SecretaryBird",
        Rarity = "Legendary",
        Chance = 0.85,
        Cash = 4500
    },
    {
        Name = "Llama",
        Rarity = "Mythic",
        Chance = 0.3,
        Cash = 18000
    },
    {
        Name = "Polar Bear",
        Rarity = "Divine",
        Chance = 0.05,
        Cash = 125000
    }
}
v3[4] = {
    {
        Name = "Bunny",
        Rarity = "Uncommon",
        Chance = 46,
        Cash = 84
    },
    {
        Name = "trumpet",
        Rarity = "Rare",
        Chance = 30,
        Cash = 224
    },
    {
        Name = "Muscovy Duck",
        Rarity = "Rare",
        Chance = 14,
        Cash = 336
    },
    {
        Name = "barracuda",
        Rarity = "Epic",
        Chance = 6.5,
        Cash = 840
    },
    {
        Name = "Moorish idol",
        Rarity = "Legendary",
        Chance = 2.3,
        Cash = 8400
    },
    {
        Name = "Yak",
        Rarity = "Mythic",
        Chance = 0.85,
        Cash = 46700
    },
    {
        Name = "Cobra",
        Rarity = "Divine",
        Chance = 0.3,
        Cash = 200000
    },
    {
        Name = "PREHISTORIC_DRAGONFLY",
        Rarity = "Cosmic",
        Chance = 0.05,
        Cash = 1500000
    }
}
v3[5] = {
    {
        Name = "Snail",
        Rarity = "Rare",
        Chance = 46,
        Cash = 400
    },
    {
        Name = "Goldfish",
        Rarity = "Rare",
        Chance = 30,
        Cash = 600
    },
    {
        Name = "Lizard",
        Rarity = "Epic",
        Chance = 14,
        Cash = 1500
    },
    {
        Name = "pufferfish",
        Rarity = "Legendary",
        Chance = 6.5,
        Cash = 15000
    },
    {
        Name = "Butterflyfish",
        Rarity = "Mythic",
        Chance = 2.3,
        Cash = 83300
    },
    {
        Name = "stingray",
        Rarity = "Divine",
        Chance = 0.85,
        Cash = 391000
    },
    {
        Name = "Regal",
        Rarity = "Cosmic",
        Chance = 0.3,
        Cash = 1340000
    },
    {
        Name = "PREHISTORIC_MOTH",
        Rarity = "Secret",
        Chance = 0.05,
        Cash = 12500000
    }
}
v3[6] = {
    {
        Name = "Cuttlefish",
        Rarity = "Rare",
        Chance = 46,
        Cash = 720
    },
    {
        Name = "FangtoothFish",
        Rarity = "Epic",
        Chance = 30,
        Cash = 2700
    },
    {
        Name = "Swordfish",
        Rarity = "Legendary",
        Chance = 14,
        Cash = 27000
    },
    {
        Name = "MantisShrimp",
        Rarity = "Mythic",
        Chance = 6.5,
        Cash = 150000
    },
    {
        Name = "GoblinShark",
        Rarity = "Divine",
        Chance = 2.3,
        Cash = 703000
    },
    {
        Name = "LeafySeaDragon",
        Rarity = "Cosmic",
        Chance = 0.85,
        Cash = 2410000
    },
    {
        Name = "MEGALODON",
        Rarity = "Secret",
        Chance = 0.3,
        Cash = 16750000
    },
    {
        Name = "Amphiptere",
        Rarity = "Celestial",
        Chance = 0.05,
        Cash = 125000000
    }
}
v3[7] = {
    {
        Name = "Jackalope",
        Rarity = "Epic",
        Chance = 46,
        Cash = 3500
    },
    {
        Name = "DIMETRODON",
        Rarity = "Legendary",
        Chance = 30,
        Cash = 48000
    },
    {
        Name = "Brachiosaurus",
        Rarity = "Mythic",
        Chance = 14,
        Cash = 267000
    },
    {
        Name = "Lindworm",
        Rarity = "Divine",
        Chance = 6.5,
        Cash = 1250000
    },
    {
        Name = "T-Rex",
        Rarity = "Cosmic",
        Chance = 2.3,
        Cash = 4290000
    },
    {
        Name = "Fenrir",
        Rarity = "Secret",
        Chance = 0.85,
        Cash = 24000000
    },
    {
        Name = "CERBERUS",
        Rarity = "Celestial",
        Chance = 0.3,
        Cash = 150000000
    },
    {
        Name = "Raiju",
        Rarity = "Celestial",
        Chance = 0.05,
        Cash = 180000000
    }
}
v3[8] = {
    {
        Name = "Tanuki",
        Rarity = "Legendary",
        Chance = 46,
        Cash = 65000
    },
    {
        Name = "Surgeonfish",
        Rarity = "Mythic",
        Chance = 30,
        Cash = 360000
    },
    {
        Name = "Mandarinfish",
        Rarity = "Divine",
        Chance = 14,
        Cash = 1800000
    },
    {
        Name = "DumboOctopus",
        Rarity = "Cosmic",
        Chance = 6.5,
        Cash = 6500000
    },
    {
        Name = "Akita",
        Rarity = "Secret",
        Chance = 2.3,
        Cash = 36000000
    },
    {
        Name = "Gallimimus",
        Rarity = "Celestial",
        Chance = 0.85,
        Cash = 200000000
    },
    {
        Name = "Wolf",
        Rarity = "Celestial",
        Chance = 0.3,
        Cash = 240000000
    },
    {
        Name = "SIMURGH",
        Rarity = "Celestial",
        Chance = 0.05,
        Cash = 300000000
    }
}
v3[9] = {
    {
        Name = "Crocodile",
        Rarity = "Mythic",
        Chance = 46,
        Cash = 500000
    },
    {
        Name = "Whale",
        Rarity = "Divine",
        Chance = 30,
        Cash = 2500000
    },
    {
        Name = "Zebra",
        Rarity = "Cosmic",
        Chance = 14,
        Cash = 9000000
    },
    {
        Name = "THUNDERBIRD",
        Rarity = "Secret",
        Chance = 6.5,
        Cash = 50000000
    },
    {
        Name = "ARCHAEOPTERYX",
        Rarity = "Secret",
        Chance = 2.3,
        Cash = 220000000
    },
    {
        Name = "WINGED_IMP",
        Rarity = "Celestial",
        Chance = 0.85,
        Cash = 260000000
    },
    {
        Name = "CALADRIUS",
        Rarity = "Celestial",
        Chance = 0.3,
        Cash = 330000000
    },
    {
        Name = "Velicoraptor",
        Rarity = "Inferno",
        Chance = 0.1,
        Cash = 400000000
    },
    {
        Name = "CLASSICDRAGON",
        Rarity = "Inferno",
        Chance = 0.05,
        Cash = 500000000
    },
    {
        Name = "QILIN",
        Rarity = "Inferno",
        Chance = 0.01,
        Cash = 750000000
    }
}
v3[10] = {
    {
        Name = "Bug",
        Rarity = "Divine",
        Chance = 40,
        Cash = 3000000
    },
    {
        Name = "CrystalLizard",
        Rarity = "Divine",
        Chance = 26,
        Cash = 3600000
    },
    {
        Name = "CrystalBeast",
        Rarity = "Cosmic",
        Chance = 16,
        Cash = 10800000
    },
    {
        Name = "CrystalRaptor",
        Rarity = "Secret",
        Chance = 9,
        Cash = 60000000
    },
    {
        Name = "CrystalDragon",
        Rarity = "Celestial",
        Chance = 5,
        Cash = 312000000
    },
    {
        Name = "Mantis",
        Rarity = "Celestial",
        Chance = 2.5,
        Cash = 396000000
    },
    {
        Name = "AlienJellyfish",
        Rarity = "Inferno",
        Chance = 1,
        Cash = 480000000
    },
    {
        Name = "CrystalScorpion",
        Rarity = "Inferno",
        Chance = 0.4,
        Cash = 600000000
    },
    {
        Name = "Behemoth",
        Rarity = "Inferno",
        Chance = 0.15,
        Cash = 900000000
    },
    {
        Name = "CrystalWolf",
        Rarity = "Void",
        Chance = 0.02,
        Cash = 1080000000
    },
    {
        Name = "CelestialBeast",
        Rarity = "Void",
        Chance = 0.01,
        Cash = 1296000000
    },
    {
        Name = "CelestialSpirit",
        Rarity = "Omega",
        Chance = 0.001,
        Cash = 1555200000
    }
}
v1.Zones = v3
v1.Extras = {
    {
        Name = "Unicorn",
        Rarity = "Epic",
        Cash = 1500,
        IndexHidden = true
    },
    {
        Name = "SABER_TOOTHED_TIGER",
        Rarity = "Legendary",
        Cash = 2800,
        CashZone = 2,
        IndexHidden = true
    },
    {
        Name = "HellCroc",
        Rarity = "Secret",
        Cash = 2400000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "HellAnky",
        Rarity = "Secret",
        Cash = 3600000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "HellTrike",
        Rarity = "Secret",
        Cash = 6000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "HellDinoRex",
        Rarity = "Celestial",
        Cash = 15000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "HellMegalodon",
        Rarity = "Celestial",
        Cash = 24000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "HellTRex",
        Rarity = "Celestial",
        Cash = 42000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "HellDragon",
        Rarity = "Inferno",
        Cash = 510000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "HellHydra",
        Rarity = "Inferno",
        Cash = 800000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "CelestialLamb",
        Rarity = "Secret",
        Cash = 220000000,
        CashZone = 10,
        IndexHidden = true
    },
    {
        Name = "CelestialSpiritFox",
        Rarity = "Celestial",
        Cash = 360000000,
        CashZone = 10,
        IndexHidden = true
    },
    {
        Name = "CelestialFrog",
        Rarity = "Inferno",
        Cash = 600000000,
        CashZone = 10,
        IndexHidden = true
    },
    {
        Name = "CelestialAxolotl",
        Rarity = "Void",
        Cash = 950000000,
        CashZone = 10,
        IndexHidden = true
    },
    {
        Name = "CelestialGorilla",
        Rarity = "Omega",
        Cash = 1200000000,
        CashZone = 10,
        IndexHidden = true
    },
    {
        Name = "AngelCroc",
        Rarity = "Secret",
        Cash = 4000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "AngelAnky",
        Rarity = "Secret",
        Cash = 6000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "AngelTrike",
        Rarity = "Secret",
        Cash = 10000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "AngelMegalodon",
        Rarity = "Celestial",
        Cash = 40000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "AngelTRex",
        Rarity = "Celestial",
        Cash = 70000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "AngelDragon",
        Rarity = "Inferno",
        Cash = 850000000,
        CashZone = 9,
        IndexHidden = true
    },
    {
        Name = "AngelHydra",
        Rarity = "Inferno",
        Cash = 1100000000,
        CashZone = 9,
        IndexHidden = true
    }
}
v1.Legacy = {
    Frog = {
        Rarity = "Rare",
        Cash = 40
    },
    Binturong = {
        Rarity = "Rare",
        Cash = 50
    },
    Owl = {
        Rarity = "Legendary",
        Cash = 1750
    },
    HoneyBadger = {
        Rarity = "Uncommon",
        Cash = 35
    },
    Fossa = {
        Rarity = "Rare",
        Cash = 60
    },
    Emu = {
        Rarity = "Uncommon",
        Cash = 70
    },
    Bull = {
        Rarity = "Legendary",
        Cash = 2500
    },
    Aardvark = {
        Rarity = "Uncommon",
        Cash = 105
    },
    Dingo = {
        Rarity = "Rare",
        Cash = 140
    },
    Jackal = {
        Rarity = "Epic",
        Cash = 355
    },
    Ostrich = {
        Rarity = "Legendary",
        Cash = 3000
    },
    Serval = {
        Rarity = "Uncommon",
        Cash = 150
    },
    Caracal = {
        Rarity = "Rare",
        Cash = 175
    },
    Hyena = {
        Rarity = "Legendary",
        Cash = 3500
    },
    Albatross = {
        Rarity = "Legendary",
        Cash = 4500
    },
    Seal = {
        Rarity = "Mythic",
        Cash = 25000
    },
    ChowChow = {
        Rarity = "Epic",
        Cash = 825
    },
    Blobfish = {
        Rarity = "Legendary",
        Cash = 5250
    },
    ["Great Dane"] = {
        Rarity = "Rare",
        Cash = 400
    },
    Mamoth = {
        Rarity = "Divine",
        Cash = 165000
    },
    Seahorse = {
        Rarity = "Epic",
        Cash = 1200
    },
    Hamster = {
        Rarity = "Legendary",
        Cash = 7000
    },
    ["Boston Terrier"] = {
        Rarity = "Mythic",
        Cash = 42500
    },
    Quokka = {
        Rarity = "Cosmic",
        Cash = 750000
    },
    ["English Bulldog"] = {
        Rarity = "Epic",
        Cash = 1350
    },
    Koala = {
        Rarity = "Legendary",
        Cash = 8000
    },
    ["Cavalier King Charles Spaniel"] = {
        Rarity = "Mythic",
        Cash = 50000
    },
    Capybara = {
        Rarity = "Cosmic",
        Cash = 825000
    },
    Papillon = {
        Rarity = "Legendary",
        Cash = 9000
    },
    Pony = {
        Rarity = "Divine",
        Cash = 275000
    },
    Turtle = {
        Rarity = "Divine",
        Cash = 330000
    },
    archerfish = {
        Rarity = "Cosmic",
        Cash = 1200000
    },
    Shoebill = {
        Rarity = "Secret",
        Cash = 5000000
    },
    wobbegong = {
        Rarity = "Divine",
        Cash = 375000
    },
    Kappa = {
        Rarity = "Cosmic",
        Cash = 1350000
    },
    Bunyip = {
        Rarity = "Secret",
        Cash = 6000000
    },
    Cassowary = {
        Rarity = "Legendary",
        Cash = 15000
    },
    Chupacabra = {
        Rarity = "Mythic",
        Cash = 85000
    },
    MOTHMAN = {
        Rarity = "Cosmic",
        Cash = 1500000
    },
    TripleCobra = {
        Rarity = "Secret",
        Cash = 7000000
    },
    GRIFFIN = {
        Rarity = "Divine",
        Cash = 540000
    },
    PEGASUS = {
        Rarity = "Cosmic",
        Cash = 2100000
    },
    WYVERN = {
        Rarity = "Cosmic",
        Cash = 2500000
    },
    HYDRA = {
        Rarity = "Secret",
        Cash = 15000000
    },
    Kitsune = {
        Rarity = "Celestial",
        Cash = 45000000
    },
    KRAKEN = {
        Rarity = "Cosmic",
        Cash = 5250000
    },
    FIREPHOENIX = {
        Rarity = "Cosmic",
        Cash = 7500000
    },
    LEVIATHAN = {
        Rarity = "Secret",
        Cash = 40000000
    },
    Jax = {
        Rarity = "Divine",
        Cash = 3500000,
        CashZone = 10
    },
    Gargoyle = {
        Rarity = "Cosmic",
        Cash = 15000000,
        CashZone = 10
    },
    Mushroom = {
        Rarity = "Secret",
        Cash = 60000000,
        CashZone = 10
    },
    Mimic = {
        Rarity = "Secret",
        Cash = 300000000,
        CashZone = 10
    },
    ["Rock Crab"] = {
        Rarity = "Celestial",
        Cash = 1100000000,
        CashZone = 10
    },
    ["John The Toad"] = {
        Rarity = "Celestial",
        Cash = 1400000000,
        CashZone = 10
    },
    ["Black Widow"] = {
        Rarity = "Inferno",
        Cash = 1800000000,
        CashZone = 10
    },
    Scarecrow = {
        Rarity = "Void",
        Cash = 2300000000,
        CashZone = 10
    },
    ["Volcano Turtle"] = {
        Rarity = "Void",
        Cash = 3000000000,
        CashZone = 10
    },
    ["Wizard Owl"] = {
        Rarity = "Omega",
        Cash = 4500000000,
        CashZone = 10
    }
}
return v1
