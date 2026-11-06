-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MutationConfig = require(script.Parent.MutationConfig)
local ZoneAnimalsConfig = require(script.Parent.ZoneAnimalsConfig)
local v1 = script.Parent.Parent:WaitForChild("Rarities", 10)

local function authoredUiGradient(v2) -- line 27 | captures: v1
    local v3 = v1 and v1:FindFirstChild(v2)
    if v3 and v3:IsA("UIGradient") then
        return v3
    end
    return nil
end

local function authoredGradient(v4, v5) -- line 37 | captures: v1
    local v6 = v1 and v1:FindFirstChild(v4)
    if not (v6 and v6:IsA("UIGradient")) then
        v6 = nil
    end
    if v6 then
        return v6.Color
    end
    return ColorSequence.new(v5)
end

local function authoredRotation(v7, v8) -- line 45 | captures: v1
    local v9 = v1 and v1:FindFirstChild(v7)
    if not (v9 and v9:IsA("UIGradient")) then
        v9 = nil
    end
    if v9 then
        return v9.Rotation
    end
    return v8
end

local v10 = {
    PoolFolderName = "Animals",
    DefaultPoolVariant = "Normal",
    TargetHeight = 4,
    MaxVisualSizeMult = 10,
    MaxMergedSizeMult = 13,
    SoftVisualSizeMult = 1.5,
    MinVisualSizeMult = 0.4,
    PickupSpawnDelay = 0,
    PickupLifetime = 45,
    OneShotLifetimeFraction = 1,
    OneShotLifetimeMin = 10,
    PoolVariants = { "Normal", "Gold", "Diamond" },
    PoolVariantCashMult = {
        Gold = 2,
        Diamond = 4
    },
    PoolVariantHatchChance = {
        Gold = 0.01,
        Diamond = 0.0025
    },
    PickupDespawnPop = {
        PopScale = 1.2,
        PopTime = 0.12,
        ShrinkTime = 0.25,
        CleanupDelay = 0.6
    },
    HatchSequence = {
        SpinIntroDuration = 1,
        ShakePreDuration = 1.75,
        ShakeTiltMagnitude = 8,
        ShakeTiltRate = 6,
        ScreenShakeDistance = 60,
        ScreenShakeDurationBuffer = 2,
        OpenSoundRange = 80,
        ExplodeDuration = 1,
        ExplodeUpscaleSize = 3,
        PetLookDuration = 2.5,
        PetFloatRate = 0.5,
        PetFloatHeight = 0,
        Grow = {
            Duration = 4,
            MinVisualMult = 1.75,
            ShakeRate = 60,
            JitterPerMult = 0.5,
            JitterMax = 2,
            ScreenShakePerMult = 0.05,
            RattleSpeedPerMult = 0.35,
            AuraDelayFrac = 0.65,
            AuraShakeDuration = 1,
            AuraShakeMagnitude = 2,
            Tick = {
                SoundName = "Dark Impact",
                StartInterval = 0.25,
                EndInterval = 0.05,
                StartPitch = 1,
                EndPitch = 2
            },
            Rumble = {
                SoundName = "Egg Rumble",
                SoundFolder = "SFX",
                Volume = 0.15,
                FadeOutTime = 0.25
            }
        }
    },
    Luck = {
        PoolFalloff = 2.5,
        BasePoolBias = 1.1,
        LuckPoolBias = 0.5,
        MaxLuckBias = 4,
        SizePickLuck = 1,
        PoolChances = {
            [2] = { 99, 1 },
            [3] = { 69, 30, 1 },
            [4] = { 55, 30, 14, 1 },
            [5] = { 50, 30, 15, 4, 1 }
        },
        SizeFloors = {
            {
                Chance = 0.2,
                CutFrac = 0.25
            },
            {
                Chance = 0.04,
                CutFrac = 0.5
            },
            {
                Chance = 0.01,
                CutFrac = 0.75
            }
        },
        BracketPickLuck = { TITANIC = 2 }
    },
    Weight = {
        Normalize = {
            AnchorKg = 50,
            Exponent = 1
        },
        BaseKg = {
            Common = 39.8,
            Uncommon = 43.3,
            Rare = 47.3,
            Epic = 42,
            Legendary = 52.3,
            Mythic = 104.4,
            Divine = 100,
            Cosmic = 62.2,
            Secret = 91.9,
            Celestial = 116,
            Inferno = 136.1,
            Void = 165.2,
            Omega = 130.7
        },
        EggBaseKg = {
            ["Basic Egg"] = 36.2,
            ["Forest Egg"] = 36.2,
            ["Rock Egg"] = 39.4,
            ["Swamp Egg"] = 42.9,
            ["Cactus Egg"] = 48.9,
            ["Bones Egg"] = 43.2,
            ["Scorpion Egg"] = 42.3,
            ["Frozen Egg"] = 41.8,
            ["Frosty Egg"] = 42.3,
            ["Yeti Egg"] = 66.9,
            ["Rainbow Egg"] = 40.9,
            ["Easter Bunny Egg"] = 40.9,
            ["Candy Egg"] = 47.3,
            ["Gooey Egg"] = 38.2,
            ["Tree Egg"] = 52.4,
            ["Lake Egg"] = 60.8,
            ["Sea Stones Egg"] = 101.5,
            ["Sea Egg"] = 104.5,
            ["Water Egg"] = 107.8,
            ["Angel Egg"] = 89.4,
            ["Fallen Angel Egg"] = 105.3,
            ["Volcanic Egg"] = 104.1,
            ["Bamboo Egg"] = 44.6,
            ["Blossom Egg"] = 45.5,
            ["Fortune Egg"] = 47.3,
            ["Starry Egg"] = 85.3,
            ["Sun Egg"] = 86.3,
            ["BlackHole Egg"] = 88.4,
            ["Plasma Egg"] = 145,
            ["Nebula Egg"] = 149.6,
            ["Supernova Egg"] = 155
        },
        AnimalKg = {
            Snail = 37.7,
            Chicken = 36,
            Frog = 27.2,
            Pigeon = 36.2,
            Bunny = 40.4,
            Cat = 39.4,
            Bat = 39.1,
            Binturong = 44.8,
            Badger = 41.6,
            Owl = 31.4,
            Tanuki = 41.8,
            HoneyBadger = 41.6,
            Fossa = 42.9,
            Wolf = 48.8,
            Bear = 82.4,
            Emu = 35,
            Lizard = 36,
            Snake = 48.9,
            Bull = 64.9,
            Cobra = 83.6,
            Aardvark = 45,
            Dingo = 40.4,
            Jackal = 39.8,
            Ostrich = 43.2,
            Llama = 50.3,
            Serval = 40.7,
            Caracal = 43.1,
            SecretaryBird = 42.3,
            Hyena = 41.6,
            Lion = 79.2,
            Maltese = 41.8,
            Goat = 47.2,
            Albatross = 32.2,
            Seal = 59.6,
            Akita = 40.5,
            BichonFrise = 32.3,
            ChowChow = 42.3,
            Blobfish = 38.1,
            Yak = 50.6,
            ["Polar Bear"] = 82.1,
            ["Great Dane"] = 37.9,
            Whale = 94.3,
            SABER_TOOTHED_TIGER = 66.9,
            Fenrir = 49.9,
            Mamoth = 91.6,
            Seahorse = 22.1,
            Hamster = 25.7,
            ["Boston Terrier"] = 40.9,
            GuiennaPig = 43.8,
            Quokka = 44.3,
            ["English Bulldog"] = 39.9,
            Koala = 36,
            ["Cavalier King Charles Spaniel"] = 40.9,
            GoldenRetriver = 53.9,
            Capybara = 43.7,
            Butterflyfish = 40.7,
            Papillon = 43.9,
            Mandarinfish = 47.3,
            Pony = 56.7,
            Unicorn = 58,
            ["Muscovy Duck"] = 29.9,
            pufferfish = 36.9,
            Turtle = 38.2,
            archerfish = 39.4,
            Shoebill = 39.9,
            stingray = 40,
            Crocodile = 66.1,
            wobbegong = 48.6,
            Kappa = 52.4,
            Bunyip = 67.1,
            Cassowary = 37.7,
            Chupacabra = 60.8,
            Lindworm = 59.9,
            MOTHMAN = 65.3,
            TripleCobra = 97.6,
            COCKATRICE = 73.1,
            GRIFFIN = 141.2,
            PEGASUS = 101.5,
            MANTICORE = 104.5,
            WYVERN = 201.6,
            CERBERUS = 94.1,
            HYDRA = 123.9,
            Kitsune = 76.7,
            SPHINX = 67.9,
            KRAKEN = 141.6,
            SIMURGH = 89.4,
            FIREPHOENIX = 105.3,
            LEVIATHAN = 92.8,
            CLASSICDRAGON = 252.7,
            THUNDERBIRD = 85.3,
            QILIN = 116.1,
            ARCHAEOPTERYX = 89.6,
            ARGENTAVIS = 87.4,
            AZHDARCHID = 146.9,
            Amphiptere = 148.1,
            Anglerfish = 40.5,
            Ankylosaurus = 99.7,
            Anteater = 48.4,
            ["Australian Cattle Dog"] = 40.1,
            Boxfish = 32.5,
            Brachiosaurus = 127.9,
            CALADRIUS = 87.2,
            CHIREMA = 95.8,
            CoralGoby = 34.2,
            Cow = 59.8,
            Crab = 33.5,
            Cuttlefish = 38.3,
            DIMETRODON = 95.1,
            Dullahan = 96.6,
            DumboOctopus = 31.8,
            Elephant = 95.4,
            FangtoothFish = 32.1,
            GARGOYLE_BAT = 77.3,
            GARUDA = 74.4,
            Gallimimus = 116.3,
            GiantIsopod = 28.7,
            Giraffee = 79.7,
            GoblinShark = 38,
            Goldfish = 34.2,
            Gorilla = 78.6,
            HARPY = 86.2,
            Horse = 55.3,
            Jackalope = 45.6,
            Jellyfish = 39,
            Kangaroo = 60.6,
            Kookaburra = 31.6,
            LeafySeaDragon = 45.1,
            Lionfish = 42,
            MEGALODON = 102.5,
            MICRORAPTOR = 125.7,
            MINOTAUR = 56.5,
            MantisShrimp = 37.6,
            ["Moorish idol"] = 35.1,
            Mosasaurus = 107.1,
            Nautilus = 29.3,
            PLESIOSAUR = 192.4,
            PREHISTORIC_DRAGONFLY = 51.1,
            PREHISTORIC_MOTH = 44.7,
            PTERANODON = 122.8,
            PTERODACTYL = 158.2,
            Parrot = 40.3,
            QUETZALCOATLUS = 124.5,
            ROC = 85.3,
            Raiju = 42.6,
            Regal = 33,
            STEGOSAURUS = 95.8,
            STYMPHALIANBIRD = 78.3,
            Shark = 68.2,
            Spinosaurus = 125.7,
            Surgeonfish = 40.4,
            Swordfish = 76.6,
            ["T-Rex"] = 120.2,
            Tiger = 60.9,
            Triceratops = 104.1,
            Velicoraptor = 136.1,
            WINGED_IMP = 78.9,
            Wrasse = 41.1,
            YI_QI = 67.4,
            Zebra = 61.8,
            barracuda = 33.7,
            Jax = 161.4,
            Gargoyle = 136.2,
            Mushroom = 123.6,
            Mimic = 120.7,
            ["Rock Crab"] = 176.9,
            ["John The Toad"] = 173.6,
            ["Black Widow"] = 191.9,
            Scarecrow = 137.9,
            ["Volcano Turtle"] = 192.4,
            ["Wizard Owl"] = 130.7,
            Bug = 163.4,
            CrystalLizard = 145,
            CrystalBeast = 145.2,
            CrystalRaptor = 149.8,
            CrystalDragon = 155,
            Mantis = 149.4,
            AlienJellyfish = 162.4,
            CrystalScorpion = 164.4,
            Behemoth = 156.5,
            CrystalWolf = 136.3,
            CelestialBeast = 140.7,
            CelestialSpirit = 123.4,
            CelestialAxolotl = 137.9,
            CelestialFrog = 148.9,
            CelestialLamb = 143.1,
            CelestialSpiritFox = 146.5,
            CelestialGorilla = 150.2,
            cowfish = 34.2,
            hawkfish = 37,
            sailfish = 53.3,
            trumpet = 26.3,
            tuna = 39.4
        }
    },
    ZoneEggs = {
        Zone1 = {
            Theme = "Forest",
            Folder = "Forest Eggs",
            Eggs = { "Forest Egg", "Rock Egg", "Swamp Egg" }
        },
        Zone2 = {
            Theme = "Desert",
            Folder = "Desert Eggs",
            Eggs = { "Cactus Egg", "Bones Egg", "Scorpion Egg" }
        },
        Zone3 = {
            Theme = "Snowy",
            Folder = "Snowy Eggs",
            Eggs = { "Frozen Egg", "Frosty Egg", "Yeti Egg" }
        },
        Zone4 = {
            Theme = "Candy",
            Folder = "Candy Eggs",
            Eggs = { "Rainbow Egg", "Easter Bunny Egg", "Candy Egg" }
        },
        Zone5 = {
            Theme = "Lake",
            Folder = "Lake Eggs",
            Eggs = { "Gooey Egg", "Tree Egg", "Lake Egg" }
        },
        Zone6 = {
            Theme = "Under Water",
            Folder = "Under Water Eggs",
            Eggs = { "Sea Stones Egg", "Sea Egg", "Water Egg" }
        },
        Zone7 = {
            Theme = "Volcano",
            Folder = "Volcano Eggs",
            Eggs = { "Angel Egg", "Fallen Angel Egg", "Volcanic Egg" }
        },
        Zone8 = {
            Theme = "Blossom",
            Folder = "Blossom Eggs",
            Eggs = { "Bamboo Egg", "Blossom Egg", "Fortune Egg" }
        },
        Zone9 = {
            Theme = "Galaxy",
            Folder = "Galaxy Eggs",
            Eggs = { "Starry Egg", "Sun Egg", "BlackHole Egg" }
        },
        Zone10 = {
            Theme = "Planet X",
            Folder = "Alien Eggs",
            Eggs = { "Plasma Egg", "Nebula Egg", "Supernova Egg" }
        }
    },
    Pool = {},
    DisplayNames = {
        GuiennaPig = "Guinea Pig",
        GoldenRetriver = "Golden Retriever",
        Mamoth = "Mammoth",
        Giraffee = "Giraffe",
        Velicoraptor = "Velociraptor",
        FIREPHOENIX = "Fire Phoenix",
        CLASSICDRAGON = "Fire Dragon",
        SABER_TOOTHED_TIGER = "Sabertooth",
        HellCroc = "Demon Bat",
        HellAnky = "Demon Bat",
        HellTrike = "Demon Scorpion",
        HellMegalodon = "Hellhound",
        HellDinoRex = "Hellhound",
        HellTRex = "Demon Golem",
        HellDragon = "Demon Dragon",
        HellHydra = "Cerberus",
        AngelCroc = "Angel Bat",
        AngelAnky = "Angel Bat",
        AngelTrike = "Angel Scorpion",
        AngelMegalodon = "Angel Hound",
        AngelTRex = "Angel Golem",
        AngelDragon = "Angel Dragon",
        AngelHydra = "Angel Cerberus"
    },
    RarityColors = {
        Common = Color3.fromRGB(200, 200, 200),
        Uncommon = Color3.fromRGB(88, 214, 96),
        Rare = Color3.fromRGB(64, 140, 255),
        Epic = Color3.fromRGB(170, 84, 255),
        Legendary = Color3.fromRGB(255, 170, 40),
        Mythic = Color3.fromRGB(255, 80, 80),
        Divine = Color3.fromRGB(120, 235, 235),
        Celestial = Color3.fromRGB(255, 223, 110),
        Cosmic = Color3.fromRGB(255, 90, 245),
        Secret = Color3.fromRGB(235, 235, 235),
        Inferno = Color3.fromRGB(235, 30, 30),
        Void = Color3.fromRGB(150, 70, 255),
        Omega = Color3.fromRGB(70, 255, 120)
    }
}
local v11 = {}
local v12 = Color3.fromRGB(200, 200, 200)
local v13 = v1 and v1:FindFirstChild("Common")

if not (v13 and v13:IsA("UIGradient")) then
    v13 = nil
end

if v13 then
    v11.Common = v13.Color
else
    v11.Common = ColorSequence.new(v12)
end
local v14 = Color3.fromRGB(88, 214, 96)
local v15 = v1 and v1:FindFirstChild("Uncommon")

if not (v15 and v15:IsA("UIGradient")) then
    v15 = nil
end

if v15 then
    v11.Uncommon = v15.Color
else
    v11.Uncommon = ColorSequence.new(v14)
end
local v16 = Color3.fromRGB(64, 140, 255)
local v17 = v1 and v1:FindFirstChild("Rare")

if not (v17 and v17:IsA("UIGradient")) then
    v17 = nil
end

if v17 then
    v11.Rare = v17.Color
else
    v11.Rare = ColorSequence.new(v16)
end
local v18 = Color3.fromRGB(170, 84, 255)
local v19 = v1 and v1:FindFirstChild("Epic")

if not (v19 and v19:IsA("UIGradient")) then
    v19 = nil
end

if v19 then
    v11.Epic = v19.Color
else
    v11.Epic = ColorSequence.new(v18)
end
local v20 = Color3.fromRGB(255, 80, 80)
local v21 = v1 and v1:FindFirstChild("Legendary")

if not (v21 and v21:IsA("UIGradient")) then
    v21 = nil
end

if v21 then
    v11.Legendary = v21.Color
else
    v11.Legendary = ColorSequence.new(v20)
end
v11.Mythic = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 40, 40)),
    ColorSequenceKeypoint.new(0.16666666666666666, Color3.fromRGB(255, 150, 30)),
    ColorSequenceKeypoint.new(0.3333333333333333, Color3.fromRGB(255, 235, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 230, 80)),
    ColorSequenceKeypoint.new(0.6666666666666666, Color3.fromRGB(40, 160, 255)),
    ColorSequenceKeypoint.new(0.8333333333333334, Color3.fromRGB(160, 70, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 40, 40))
})

local v22 = Color3.fromRGB(235, 235, 235)
local v23 = v1 and v1:FindFirstChild("Secret")

if not (v23 and v23:IsA("UIGradient")) then
    v23 = nil
end

if v23 then
    v11.Secret = v23.Color
else
    v11.Secret = ColorSequence.new(v22)
end
v11.Divine = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 20, 120)),
    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(40, 120, 255)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(170, 245, 255)),
    ColorSequenceKeypoint.new(0.62, Color3.fromRGB(90, 100, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(150, 80, 235)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 120))
})
v11.Celestial = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 95, 15)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(235, 170, 40)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 215, 90)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 252, 220)),
    ColorSequenceKeypoint.new(0.62, Color3.fromRGB(255, 215, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(235, 170, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 95, 15))
})
v11.Cosmic = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 5, 60)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(120, 20, 200)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 60, 230)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 170, 250)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(150, 40, 235)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(60, 15, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 5, 60))
})
v11.Inferno = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 25, 25)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(240, 60, 30)),
    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(255, 120, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 80)),
    ColorSequenceKeypoint.new(0.56, Color3.fromRGB(255, 245, 180)),
    ColorSequenceKeypoint.new(0.62, Color3.fromRGB(255, 200, 80)),
    ColorSequenceKeypoint.new(0.78, Color3.fromRGB(240, 70, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 25, 25))
})
v11.Void = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 0, 30)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(70, 10, 150)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(150, 70, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 210, 255)),
    ColorSequenceKeypoint.new(0.58, Color3.fromRGB(150, 70, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(70, 10, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 0, 30))
})
v11.Omega = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 150, 60)),
    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(40, 230, 90)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(170, 255, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 255, 200)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(170, 255, 60)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(30, 220, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 150, 60))
})
v10.RarityGradients = v11

local v24 = {
    Mythic = 0,
    Divine = 45,
    Celestial = 0,
    Cosmic = 90,
    Inferno = 135,
    Void = -45,
    Omega = 180
}
local v25 = v1 and v1:FindFirstChild("Common")

if not (v25 and v25:IsA("UIGradient")) then
    v25 = nil
end

if v25 then
    v24.Common = v25.Rotation
else
    v24.Common = -90
end
local v26 = v1 and v1:FindFirstChild("Uncommon")

if not (v26 and v26:IsA("UIGradient")) then
    v26 = nil
end

if v26 then
    v24.Uncommon = v26.Rotation
else
    v24.Uncommon = -90
end
local v27 = v1 and v1:FindFirstChild("Rare")

if not (v27 and v27:IsA("UIGradient")) then
    v27 = nil
end

if v27 then
    v24.Rare = v27.Rotation
else
    v24.Rare = -90
end
local v28 = v1 and v1:FindFirstChild("Epic")

if not (v28 and v28:IsA("UIGradient")) then
    v28 = nil
end

if v28 then
    v24.Epic = v28.Rotation
else
    v24.Epic = -90
end
local v29 = v1 and v1:FindFirstChild("Legendary")

if not (v29 and v29:IsA("UIGradient")) then
    v29 = nil
end

if v29 then
    v24.Legendary = v29.Rotation
else
    v24.Legendary = -90
end
local v30 = v1 and v1:FindFirstChild("Secret")

if not (v30 and v30:IsA("UIGradient")) then
    v30 = nil
end

if v30 then
    v24.Secret = v30.Rotation
else
    v24.Secret = -90
end
v10.RarityGradientRotations = v24
v10.AnimatedRarityGradients = {
    Mythic = true,
    Secret = true,
    Divine = true,
    Celestial = true,
    Cosmic = true,
    Inferno = true,
    Void = true,
    Omega = true
}

local v31 = {}
local v32 = #ZoneAnimalsConfig.Zones
for v33 = 1, v32 do
    local v34 = ZoneAnimalsConfig.Zones[v33]
    for v35, v36 in v34 do
        local v37 = {
            Name = v36.Name,
            Rarity = v36.Rarity,
            Cash = v36.Cash or 1,
            Zone = v33,
            Chance = v36.Chance,
            ZoneRank = v35,
            ZoneCount = #v34
        }
        table.insert(v31, v37)
    end
end
for v38, v39 in ZoneAnimalsConfig.Extras do
    local v40 = {
        Name = v39.Name,
        Rarity = v39.Rarity,
        Cash = v39.Cash,
        IndexHidden = v39.IndexHidden,
        CashZone = v39.CashZone
    }
    table.insert(v31, v40)
end
v10.Pool = v31

function v10.DisplayName(v41) -- line 931 | captures: v10
    return v10.DisplayNames[v41] or
    v41:gsub("_", " "):gsub("(%l)(%u)", "%1 %2"):gsub("%S+", function(v42) -- line 938
        local v43 = v42:sub(1, 1):upper()
        local v44 = v42:sub(2)
        if v44 ~= "" and v44 == v44:upper() then
            v44 = v44:lower()
        end
        return v43 .. v44
    end)
end

function v10.GetPoolFolder() -- line 958 | captures: ReplicatedStorage, v10
    return ReplicatedStorage:FindFirstChild(v10.PoolFolderName)
end

local function isPoolVariantFolder(v45) -- line 963 | captures: v10
    return table.find(v10.PoolVariants, v45.Name) ~= nil
end

local function variantFolderIn(v46, v47) -- line 971 | captures: v10
    local v48 = v46:FindFirstChild(v47)
    if v48 and v48:IsA("Folder") then
        return v48
    end
    for v49, v50 in v46:GetChildren() do
        if v50:IsA("Folder") and table.find(v10.PoolVariants, v50.Name) == nil then
            local v51 = v50:FindFirstChild(v47)
            if v51 and v51:IsA("Folder") then
                return v51
            end
        end
    end
    return nil
end

function v10.GetVariantFolder(v52) -- line 988 | captures: v10, variantFolderIn
    local v53 = v10.GetPoolFolder()
    if v53 then
        local v54 = v52 or v10.DefaultPoolVariant
        return (variantFolderIn(v53, v54))
    end
    return v53
end

local function findTemplateIn(v55, v56) -- line 997
    if v55 then
        local v57 = v55:FindFirstChild(v56)
        if v57 and v57:IsA("Model") then
            return v57
        end
        for v58, v59 in v55:GetChildren() do
            if v59:IsA("Folder") then
                local v60 = v59:FindFirstChild(v56)
                if v60 and v60:IsA("Model") then
                    return v60
                end
            end
        end
    end
    return nil
end

function v10.FindAnimalTemplate(v61, v62) -- line 1021 | captures: v10, variantFolderIn, findTemplateIn
    if typeof(v61) == "string" and v61 ~= "" then
        local v63 = v10.GetPoolFolder()
        if v63 then
            local v64 = v62 or v10.DefaultPoolVariant
            local v65 = findTemplateIn(variantFolderIn(v63, v64), v61)
            if not v65 then
                v65 = v63:FindFirstChild(v61)
                if not (v65 and v65:IsA("Model")) then
                    v65 = nil
                end
            end
            if not (v65 or v64 == v10.DefaultPoolVariant) then
                v65 = findTemplateIn(v63:FindFirstChild(v10.DefaultPoolVariant), v61)
            end
            if not v65 and v62 == nil then
                local v66 = v65
                for v67, v68 in v63:GetChildren() do
                    if v68:IsA("Folder") and table.find(v10.PoolVariants, v68.Name) == nil then
                        local v69 = v66
                        for v70, v71 in v68:GetChildren() do
                            if v71:IsA("Folder") then
                                v69 = findTemplateIn(v71, v61)
                                if v69 then
                                    return v69
                                end
                            end
                            v66 = v69
                        end
                    end
                    v65 = v66
                end
            end
            return v65
        end
    end
    return nil
end

function v10.AnimalTemplates(v72) -- line 1061 | captures: v10, variantFolderIn
    local v73 = {}
    local v74 = v10.GetPoolFolder()
    if v74 then
        local v75 = {}
        local collect

        local function collect_2(v76, v77) -- line 1071 | captures: v73, v75, collect
            if v76 then
                for v78, v79 in v76:GetChildren() do
                    if v79:IsA("Model") then
                        if v75[v79.Name] then
                            if v77 and v79:IsA("Folder") then
                                collect(v79, true)
                            end
                        else
                            v75[v79.Name] = true
                            table.insert(v73, v79)
                        end
                    elseif v77 and v79:IsA("Folder") then
                        collect(v79, true)
                    end
                end
            end
        end

        collect = collect_2
        local v80 = v72 or v10.DefaultPoolVariant
        collect_2(variantFolderIn(v74, v80), true)
        collect_2(v74)
    end
    return v73
end

function v10.AllAnimalTemplates() -- line 1093 | captures: v10
    local v81 = {}
    local v82 = v10.GetPoolFolder()
    if v82 then
        local collect

        local function collect_2(v83) -- line 1099 | captures: v81, collect
            for v84, v85 in v83:GetChildren() do
                if v85:IsA("Model") then
                    table.insert(v81, v85)
                elseif v85:IsA("Folder") then
                    collect(v85)
                end
            end
        end

        collect = collect_2
        collect_2(v82)
    end
    return v81
end

local v86

local function poolEntry(v87) -- line 1117 | captures: v86, ZoneAnimalsConfig, v10
    if v87 then
        if not v86 then
            local v88 = {}
            for v89, v90 in v10.Pool do
                v88[v90.Name] = v90
            end
            v86 = v88
        end
        return v86[v87] or ZoneAnimalsConfig.Legacy[v87]
    end
    return nil
end

function v10.CashPerSecond(v91) -- line 1135 | captures: poolEntry
    local v92 = poolEntry(v91)
    return v92 and v92.Cash or 1
end

function v10.RarityOf(v93) -- line 1142 | captures: poolEntry
    local v94 = poolEntry(v93)
    return v94 and v94.Rarity
end

function v10.ChanceMultOf(v95) -- line 1149 | captures: poolEntry
    local v96 = poolEntry(v95)
    return v96 and v96.ChanceMult or 1
end

function v10.ChanceOf(v97) -- line 1156 | captures: poolEntry
    local v98 = poolEntry(v97)
    return v98 and v98.Chance
end

function v10.SoftCapSize(v99) -- line 1164 | captures: v10
    local SoftVisualSizeMult = v10.SoftVisualSizeMult
    if v99 <= SoftVisualSizeMult then
        return v99
    end
    local v100 = v10.MaxVisualSizeMult - SoftVisualSizeMult
    if v100 <= 0 then
        return SoftVisualSizeMult
    end
    local MaxVisualSizeMult = v10.MaxVisualSizeMult
    local v101 = -(v99 - SoftVisualSizeMult) / v100
    return MaxVisualSizeMult - v100 * math.exp(v101)
end

local function VisualSizeMult(v102) -- line 1178
    local v103 = v102 or 1
    return (math.max(v103, 0))
end

v10.VisualSizeMult = VisualSizeMult

local function normalizeBaseKg(v104) -- line 1187 | captures: v10
    local Normalize = v10.Weight.Normalize
    if Normalize and Normalize.Exponent and Normalize.Exponent ~= 1 then
        return Normalize.AnchorKg * (v104 / Normalize.AnchorKg) ^ Normalize.Exponent
    end
    return v104
end

function v10.EggBaseKgFor(v105, v106) -- line 1197 | captures: v10
    local Weight = v10.Weight
    local v107, v108
    if v105 then
        local v109 = Weight.EggBaseKg[v105]
        if v109 then
            v107 = v109
            v108 = true
        elseif v106 then
            local v110 = Weight.BaseKg[v106]
            if v110 then
                v107 = v110
                v108 = true
            else
                v108 = false
            end
        else
            v108 = false
        end
    elseif v106 then
        local v111 = Weight.BaseKg[v106]
        if v111 then
            v107 = v111
            v108 = true
        else
            v108 = false
        end
    else
        v108 = false
    end
    if not v108 then
        v107 = Weight.BaseKg.Common
    end
    local Normalize = v10.Weight.Normalize
    if Normalize and Normalize.Exponent and Normalize.Exponent ~= 1 then
        return Normalize.AnchorKg * (v107 / Normalize.AnchorKg) ^ Normalize.Exponent
    end
    return v107
end

local v112 = {}

function v10.AnimalBaseKg(v113) -- line 1214 | captures: v10, poolEntry, v112
    local v114 = v112[v113]
    if v114 then
        return v114
    end
    local Weight = v10.Weight
    local v115 = Weight.AnimalKg[v113]
    local v116
    if v115 then
        v116 = v115
    else
        local v117 = poolEntry(v113)
        v116 = v117 and Weight.BaseKg[v117.Rarity]
    end
    local v118 = v116 or Weight.BaseKg.Common
    local Normalize = v10.Weight.Normalize
    if Normalize and Normalize.Exponent and Normalize.Exponent ~= 1 then
        v118 = Normalize.AnchorKg * (v118 / Normalize.AnchorKg) ^ Normalize.Exponent
    end
    v112[v113] = v118
    return v118
end

v10.WeightSizeExponent = 3

function v10.KgForSize(v119, v120) -- line 1240 | captures: v10
    local v121 = v120 or 1
    return v119 * math.max(v121, 0) ^ v10.WeightSizeExponent
end

function v10.SizeForKg(v122, v123) -- line 1246 | captures: v10
    if v122 <= 0 or v123 <= 0 then
        return 1
    end
    return (v123 / v122) ^ (1 / v10.WeightSizeExponent)
end

v10.SpeciesSizeSpread = 1.5

function v10.ScaleForWeight(v124, v125, v126, v127, v128) -- line 1281 | captures: v10
    local v129
    if v124 and v125 and v125 > 0 then
        local v130 = v10.SizeForKg(v10.AnimalBaseKg(v124), v125)
        local v131 = v126 or 1
        if v131 > 0 then
            local SpeciesSizeSpread = v10.SpeciesSizeSpread
            local v132 = v130 / v131
            local v133 = 1 / SpeciesSizeSpread
            v130 = v131 * math.clamp(v132, v133, SpeciesSizeSpread)
        end
        local MinVisualSizeMult = v10.MinVisualSizeMult
        v129 = math.max(v130, MinVisualSizeMult)
    else
        v129 = v10.VisualSizeMult(v126)
    end
    if v127 then
        return v129
    end
    local v134
    if v128 then
        local MaxMergedSizeMult = v10.MaxMergedSizeMult
        v134 = math.min(v128, MaxMergedSizeMult)
    else
        v134 = v10.MaxVisualSizeMult
    end
    return (math.min(v129, v134))
end

v10.PlacedAspectSpan = 2.5
v10.PlotFitSpecies = { stingray = true }
v10.MaxPlacedFootprintFrac = 1.15

function v10.FitsToPlot(v135) -- line 1326 | captures: v10
    if v135 == nil then
        return false
    end
    return v10.PlotFitSpecies[v135] == true
end

function v10.MaxPlacedSpan(v136) -- line 1331 | captures: v10
    local X = v136.X
    local Z = v136.Z
    local v137 = math.min(X, Z) * v10.MaxPlacedFootprintFrac
    local TargetHeight = v10.TargetHeight
    return (math.max(v137, TargetHeight))
end

function v10.PlacedScaleFactor(v138, v139, v140) -- line 1342 | captures: v10
    if v138.Y <= 0 then
        return 1
    end
    local X = v138.X
    local Z = v138.Z
    local v141 = math.max(X, Z)
    local Y = v138.Y
    local v142 = v141 / v10.PlacedAspectSpan
    local v143 = v139 / math.max(Y, v142)
    if v140 and v141 > 0 then
        local v144 = v10.MaxPlacedSpan(v140) / v141
        v143 = math.min(v143, v144)
    end
    return v143
end

v10.CashSizeExponent = 3
v10.CashSizeKnee = 2
v10.CashSizeTailExponent = 1
v10.CashSizeMultMin = 0.2

local v145 = {}

v145[1] = 1.38
v145[2] = 1.48
v145[3] = 1.55
v145[4] = 1.65
v145[5] = 1.7
v145[6] = 1.73
v145[7] = 1.79
v145[8] = 1.81
v145[9] = 1.81
v145[10] = 1.81
v10.CashSizeReference = v145

local v146

function v10.ZoneOfEggType(v147) -- line 1439 | captures: v146, v10
    local function v148(...)
        return (tonumber(...))
    end

    if v147 then
        if not v146 then
            local v149 = {}
            for v150, v151 in v10.ZoneEggs do
                local v152 = v148(string.match(v150, "%d+"))
                if v152 then
                    for v153, v154 in v151.Eggs do
                        v149[v154] = v152
                    end
                end
            end
            v146 = v149
        end
        return v146[v147]
    end
    return nil
end

function v10.HomeZoneOf(v155) -- line 1460 | captures: poolEntry
    local v156 = poolEntry(v155)
    return v156 and v156.Zone
end

function v10.CashZoneOf(v157) -- line 1467 | captures: poolEntry
    local v158 = poolEntry(v157)
    return v158 and (v158.Zone or v158.CashZone)
end

function v10.ZoneRankOf(v159) -- line 1475 | captures: poolEntry
    local v160 = poolEntry(v159)
    if not (v160 and v160.ZoneRank) then
        return nil, nil
    end
    return v160.ZoneRank, v160.ZoneCount
end

function v10.SizeReferenceFor(v161) -- line 1485 | captures: v10
    local v162 = v10.CashZoneOf(v161)
    return v162 and v10.CashSizeReference[v162] or 1
end

local v163 = {}

v163[1] = 1.1
v163[2] = 1.12
v163[3] = 1.14
v163[4] = 1.16
v163[5] = 1.18
v163[6] = 1.2
v163[7] = 1.22
v163[8] = 1.25
v163[9] = 1.27
v163[10] = 1.29
v10.CashWeightExponent = v163
v10.CashWeightKnee = 8

local v164 = {}

v164[1] = 0.55
v164[2] = 0.57
v164[3] = 0.59
v164[4] = 0.61
v164[5] = 0.63
v164[6] = 0.65
v164[7] = 0.67
v164[8] = 0.7
v164[9] = 0.72
v164[10] = 0.74
v10.CashWeightTailExponent = v164

function v10.CashWeightExponentsFor(v165) -- line 1560 | captures: v10
    local v166 = v10.CashZoneOf(v165)
    local v167, v168
    if v166 then
        v167 = v10.CashWeightExponent[v166] or v10.CashWeightExponent[1]
        v168 = v10.CashWeightTailExponent[v166] or v10.CashWeightTailExponent[1]
    else
        v167 = v10.CashWeightExponent[1]
        v168 = v10.CashWeightTailExponent[1]
    end
    return v167, v168
end

v10.CashSpeciesAnchorKg = 50
v10.CashSpeciesWeightExponent = 0.5
v10.CashSpeciesWeightMax = 3

function v10.SpeciesWeightCashMult(v169) -- line 1583 | captures: v10
    if v169 then
        local v170 = v10.AnimalBaseKg(v169)
        if v170 <= 0 then
            return 1
        end
        local v171 = (v170 / v10.CashSpeciesAnchorKg) ^ v10.CashSpeciesWeightExponent
        local CashSpeciesWeightMax = v10.CashSpeciesWeightMax
        return (math.clamp(v171, 1, CashSpeciesWeightMax))
    end
    return 1
end

function v10.CashWeightMult(v172, v173) -- line 1595 | captures: v10
    if v172 and v173 and not (v173 <= 0) then
        local v174 = v10.AnimalBaseKg(v172)
        if v174 <= 0 then
            return 1
        end
        local v175 = v10.SizeReferenceFor(v172)
        local v176 = v173 / (v174 * math.max(v175, 0.01) ^ v10.WeightSizeExponent)
        local CashWeightKnee = v10.CashWeightKnee
        local v177, v178 = v10.CashWeightExponentsFor(v172)
        local v179 = if v176 <= CashWeightKnee then v176 ^ v177 else CashWeightKnee ^ v177 * (v176 / CashWeightKnee) ^ v178
        local CashSizeMultMin = v10.CashSizeMultMin
        return (math.max(v179, CashSizeMultMin))
    end
    return 1
end

function v10.CashSizeMult(v180, v181) -- line 1623 | captures: v10
    local v182 = v10.SizeReferenceFor(v180)
    local v183 = v181 or 1
    local v184 = math.max(v183, 0) / math.max(v182, 0.01)
    local CashSizeKnee = v10.CashSizeKnee
    local v185 = if v184 <= CashSizeKnee then v184 ^ v10.CashSizeExponent else CashSizeKnee ^ v10.CashSizeExponent * (v184 / CashSizeKnee) ^ v10.CashSizeTailExponent
    local CashSizeMultMin = v10.CashSizeMultMin
    return (math.max(v185, CashSizeMultMin))
end

function v10.VariantCashMult(v186) -- line 1639 | captures: v10
    return v186 and v10.PoolVariantCashMult[v186] or 1
end

function v10.PlacedCashPerSecond(v187, v188, v189, v190, v191) -- line 1651 | captures: MutationConfig, v10, poolEntry
    local v192 = poolEntry(v187)
    local v193
    if not (v190 and v190 > 0) then
        v193 = v10.CashSizeMult(v187, v188)
    else
        v193 = v10.CashWeightMult(v187, v190)
    end
    local v194 = (v192 and v192.Cash or 1) * v193 * v10.SpeciesWeightCashMult(v187) * MutationConfig.CashMult(v189) * v10.VariantCashMult(v191) + 0.5
    local v195 = math.floor(v194)
    return (math.max(v195, 1))
end

function v10.PickupLifetimeFor(v196) -- line 1668 | captures: v10
    if v196 then
        local v197 = v10.PickupLifetime * v10.OneShotLifetimeFraction
        local OneShotLifetimeMin = v10.OneShotLifetimeMin
        local PickupLifetime = v10.PickupLifetime
        return (math.clamp(v197, OneShotLifetimeMin, PickupLifetime))
    end
    return v10.PickupLifetime
end

return v10
