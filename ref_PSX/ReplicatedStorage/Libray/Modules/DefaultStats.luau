local isStudio = game:GetService("RunService"):IsStudio()
local allowDeb = true  
local freePassesActive = require(game.ReplicatedStorage.Library.Client.Settings).FreeGamepasses
--
local defaultCurrency = allowDeb and isStudio and 10_000_000_000_000 or 0
local defaultBoosts = allowDeb and isStudio and {["Super Lucky"] = 999, ["Ultra Lucky"] = 999, ["Triple Coins"] = 999, ["Triple Damage"] = 999} or {}

return {
	["Pets"] = {}, 
	PetsEquipped = {}, 
	HardcorePetsEquipped = {}, 
	RidingPet = nil, 
	["Coins"] = defaultCurrency,
	["Diamonds"] = defaultCurrency,
	["Tech Coins"] = defaultCurrency,
	["Fantasy Coins"] = defaultCurrency,
	["Rainbow Coins"] = defaultCurrency,
	["Cartoon Coins"] = defaultCurrency,
	["Gingerbread"] = defaultCurrency,
	["Valentine Hearts"] = defaultCurrency,
	["Clover Coins"] = defaultCurrency,
	["Easter Coins"] = defaultCurrency,
	["Lucky Coins"] = defaultCurrency,
	["Popsicles"] = defaultCurrency,
	["Quest Points"] = defaultCurrency,
	["Stars"] = defaultCurrency,
	["Claw Tokens"] = defaultCurrency,
	["Yeet Coins"] = defaultCurrency,
	["Yeet Orbs"] = defaultCurrency,
	["Yeet Strength"] = defaultCurrency,
	["Paw Tokens"] = 0,
	SpentPawTokens = 0,
	PurchasedPurchasables = {},
	RAP = 0, 
	GamepassesCompensated = false,
	Fruits = {}, 
	Quests = {}, 
	HardcoreQuests = {}, 
	QuestRewards = {}, 
	Rank = "Noob", 
	RankProgress = 0, 
	RankTimer = 0, 
	MaxSlots = 30, 
	MaxEquipped = 6, 
	World = "Spawn", 
	PositionData = {
		PlayerCFrame = nil, 
		CameraCFrame = nil, 
		CameraFocus = nil
	}, 
	AreasUnlocked = { "Shop", "Town" }, 
	EggsOpened = {}, 
	MasteryUnlocked = false, 
	Mastery = {}, 
	Collection = {}, 
	CollectionTier = 0, 
	MerchantLevel = 1, 
	MerchantSales = 0, 
	DarkMatterSlots = 6, 
	DarkMatterQueue = {}, 
	FreeGiftsRedeemed = {}, 
	FreeGiftsTime = 0, 
	FreeGiftsResetTime = 0, 
	ThanksForPlayingPet = nil, 
	ReturningPlayerPet = nil, 
	CollectedScavenger = {}, 
	ScavengerEggsCollected = {}, 
	HardcoreUnlocked = false, 
	HardcoreTutorial = false, 
	HardcoreCurrency = {
		Coins = defaultCurrency, 
		["Tech Coins"] = defaultCurrency, 
		["Fantasy Coins"] = defaultCurrency, 
		["Rainbow Coins"] = defaultCurrency, 
		["Cartoon Coins"] = defaultCurrency
	}, 
	Hardcore = {
		World = "Spawn", 
		AreasUnlocked = { "Shop", "Town" }, 
		TeleportsUnlocked = {}, 
		EggsOpened = {}, 
		OwnsDominusGate = false, 
		OwnsHackerGate = false, 
		HackerPortalUnlocked = false, 
		HackerPortalProgress = { 0, -1 }, 
		ProgressNotifications = {
			Areas = {}, 
			Eggs = {}, 
			Upgrades = {}
		}, 
		StPatricks2022Quest = { 0, -1 }, 
		Valentines2022Quest = { 0, -1 }, 
		AprilFools2023 = {
			Quest = {
				Progress = 0, 
				Stage = 1
			}
		}
	},
	Sandbox = {
		Coins = 999999999999999, 
		["Tech Coins"] = 999999999999999, 
		["Fantasy Coins"] = 999999999999999, 
		["Rainbow Coins"] = 999999999999999, 
		["Cartoon Coins"] = 999999999999999,
		World = "Spawn", 
		AreasUnlocked = { "Shop", "Town" }, 
		TeleportsUnlocked = {}, 
		EggsOpened = {}, 
		OwnsDominusGate = false, 
		OwnsHackerGate = false, 
		HackerPortalUnlocked = false, 
		HackerPortalProgress = { 0, -1 }, 
		ProgressNotifications = {
			Areas = {}, 
			Eggs = {}, 
			Upgrades = {}
		}, 
		StPatricks2022Quest = { 0, -1 }, 
		Valentines2022Quest = { 0, -1 }, 
		AprilFools2023 = {
			Quest = {
				Progress = 0, 
				Stage = 1
			}
		}
	},
	DaycareTier = 0, 
	DaycareQueue = {}, 
	DaycareHardcoreQueue = {}, 
	DaycareLoot = {}, 
	DaycareHardcoreLoot = {}, 
	Settings = {
		Music = 1, 
		SFX = 1, 
		Trading = 1, 
		ShowOtherPets = 1, 
		EggSkip = 1, 
		ShowBoosts = 1, 
		PetsControl = 1, 
		PetSFX = 1, 
		Notifications = 1,
		MountingTitanics = 1
	}, 
	SelectedTradingBooth = nil, 
	TradingBoothStyles = {}, 
	BoothDiamondsEarned = 0, 
	UpdateGifts = {}, 
	Upgrades = {}, 
	Boosts = {}, 
	BoostsInventory = defaultBoosts, 
	Achievements = {}, 
	VIPCooldown = 0, 
	TwitterCodes = {}, 
	OwnsDominusGate = false, 
	TradeHistory2 = {}, 
	MailLog = {}, 
	TeleportsUnlocked = {}, 
	AutoDelete = {}, 
	OwnsOctupleEggs = freePassesActive, 
	AutoHatchSettings = {
		Enabled = true, 
		StopOnFailure = true, 
		TripleEggs = false, 
		OctupleEggs = false, 
		AlwaysKeep = {
			GoldPets = "Exclusive", 
			RainbowPets = "Exclusive", 
			ShinyPets = "Exclusive"
		}
	}, 
	FriendsBoost = 1, 
	OwnsTradingPlaza = false, 
	OwnsUGCVault = false,
	VDayGramCredits = 0,
	OwnsHugeMachine = false, 
	Hoverboards = {}, 
	EquippedHoverboard = "", 
	ChristmasEventQuest = {
		Progress = 0, 
		Stage = 1
	}, 
	Christmas2022 = {
		HasPlayedChristmas2022 = false, 
		PresentsFound = {}, 
		ElvesFound = {}, 
		ChristmasEventQuest = {
			Progress = 0, 
			Stage = 1
		}, 
		SantasDoor = false, 
		SantasHardcoreDoor = false
	}, 
	StPatricks2022Quest = { 0, -1 }, 
	Valentines2022Quest = { 0, -1 }, 
	AprilFools2023 = {
		Quest = {
			Progress = 0, 
			Stage = 1
		}
	}, 
	Easter2023 = {
		Participated = false, 
		ParticipatedHardcore = false, 
		LastHunt = nil, 
		FoundEggs = {}, 
		HasGift = false, 
		Time = 0, 
		Quest = { 0, -1 }
	}, 
	OwnsHackerGate = false, 
	HackerPortalUnlocked = false, 
	HackerPortalProgress = { 0, -1 }, 
	AprilFoolsUsed = 0, 
	InfPetsTimeStart = nil, 
	InfPetsEnabled = false, 
	HasAnniversaryGift = false, 
	CaveShinyBoost = false, 
	HasPlayedHalloween2022 = false, 
	HasHalloween2022Gift = false, 
	HalloweenGift2022Time = 0, 
	HalloweenEventQuest2022 = {
		Progress = 0, 
		Stage = 1
	}, 
	ChristmasLoginReward2022 = {
		Stage = 0, 
		LastClaim = nil
	}, 
	PickedStarter = false, 
	HasCompletedTutorial = false,
	TutorialProgress = 0, 
	GroupReward = false, 
	ProgressNotifications = {
		Areas = {}, 
		Eggs = {}, 
		Upgrades = {}
	}, 
	InventoryNotifications = 0, 
	LastUpdateLog = 0, 
	ThanksgivingTime = nil, 
	HugePegasusAlert = false, 
	HugePegasusGiven = false, 
	CometData = {
		LastCometTime = 0,
		JobId = nil
	},
	DiamondMineData = {
		LastDiamondMineTeleport = 0,
		JobId = nil, 
		LastDay = nil,
		Earned = 0
	},
	IsFollowingOnTwitter = false, 
	TwitterUsername = nil, 
	Gamepasses = {}, 
	LastSaveTimestamp = 0, 
	PlayingSession = false, 
	SessionId = nil, 
	SafeSaveToken = nil, 
	LoginTime = nil, 
	Age = 0, 
	LastShopClick = 0,
	RobuxSpent = 0, 
	PaidPlayer = false, 
	HasPlayedBefore = false
};
