--!strict
--[[
    Tabela de Animais/Pets (Renda de Moedas por Segundo no Cercado/Pen)
    Engenharia Reversa baseada em ref_BreakAndStealAnEgg/ZoneAnimalsConfig e ref_StealAnEgg/EggService
    Clean Room: Sem asset IDs proprietarios de malhas/texturas.
]]

export type PetEntry = {
	Name: string,
	Rarity: string,
	CoinsPerSecond: number,
	AssetModelName: string,
}

local Pets: { [string]: PetEntry } = {
	-- Tier 1 (Forest / Nivel 1)
	["Chicken"] = { Name = "Chicken", Rarity = "Common", CoinsPerSecond = 1, AssetModelName = "Pet_Chicken" },
	["Cat"] = { Name = "Cat", Rarity = "Common", CoinsPerSecond = 3, AssetModelName = "Pet_Cat" },
	["Bat"] = { Name = "Bat", Rarity = "Uncommon", CoinsPerSecond = 10, AssetModelName = "Pet_Bat" },
	["Badger"] = { Name = "Badger", Rarity = "Rare", CoinsPerSecond = 35, AssetModelName = "Pet_Badger" },
	["Fox"] = { Name = "Fox", Rarity = "Epic", CoinsPerSecond = 120, AssetModelName = "Pet_Fox" },

	-- Tier 2 (Stone / Nivel 2)
	["Mole"] = { Name = "Mole", Rarity = "Common", CoinsPerSecond = 15, AssetModelName = "Pet_Mole" },
	["Armadillo"] = { Name = "Armadillo", Rarity = "Common", CoinsPerSecond = 40, AssetModelName = "Pet_Armadillo" },
	["Boar"] = { Name = "Boar", Rarity = "Uncommon", CoinsPerSecond = 150, AssetModelName = "Pet_Boar" },
	["Gargoyle"] = { Name = "Gargoyle", Rarity = "Rare", CoinsPerSecond = 450, AssetModelName = "Pet_Gargoyle" },
	["Golem"] = { Name = "Golem", Rarity = "Epic", CoinsPerSecond = 1500, AssetModelName = "Pet_Golem" },

	-- Tier 3 (Crystal / Nivel 3)
	["Crystal Spider"] = { Name = "Crystal Spider", Rarity = "Common", CoinsPerSecond = 200, AssetModelName = "Pet_CrystalSpider" },
	["Gem Beetle"] = { Name = "Gem Beetle", Rarity = "Uncommon", CoinsPerSecond = 600, AssetModelName = "Pet_GemBeetle" },
	["Shard Hound"] = { Name = "Shard Hound", Rarity = "Rare", CoinsPerSecond = 2200, AssetModelName = "Pet_ShardHound" },
	["Diamond Golem"] = { Name = "Diamond Golem", Rarity = "Epic", CoinsPerSecond = 7500, AssetModelName = "Pet_DiamondGolem" },
	["Prismatic Dragon"] = { Name = "Prismatic Dragon", Rarity = "Legendary", CoinsPerSecond = 25000, AssetModelName = "Pet_PrismaticDragon" },

	-- Tier 4 (Magma / Nivel 4)
	["Fire Salamander"] = { Name = "Fire Salamander", Rarity = "Common", CoinsPerSecond = 3500, AssetModelName = "Pet_FireSalamander" },
	["Lava Crab"] = { Name = "Lava Crab", Rarity = "Uncommon", CoinsPerSecond = 12000, AssetModelName = "Pet_LavaCrab" },
	["Volcano Drake"] = { Name = "Volcano Drake", Rarity = "Rare", CoinsPerSecond = 45000, AssetModelName = "Pet_VolcanoDrake" },
	["Obsidian Beast"] = { Name = "Obsidian Beast", Rarity = "Epic", CoinsPerSecond = 180000, AssetModelName = "Pet_ObsidianBeast" },
	["Infernal Phoenix"] = { Name = "Infernal Phoenix", Rarity = "Mythic", CoinsPerSecond = 600000, AssetModelName = "Pet_InfernalPhoenix" },

	-- Tier 5 (Void / Nivel 5)
	["Shadow Crawler"] = { Name = "Shadow Crawler", Rarity = "Common", CoinsPerSecond = 75000, AssetModelName = "Pet_ShadowCrawler" },
	["Void Stalker"] = { Name = "Void Stalker", Rarity = "Uncommon", CoinsPerSecond = 280000, AssetModelName = "Pet_VoidStalker" },
	["Eclipse Wyrm"] = { Name = "Eclipse Wyrm", Rarity = "Rare", CoinsPerSecond = 1000000, AssetModelName = "Pet_EclipseWyrm" },
	["Abyssal Horror"] = { Name = "Abyssal Horror", Rarity = "Epic", CoinsPerSecond = 4500000, AssetModelName = "Pet_AbyssalHorror" },
	["Cosmic Titan"] = { Name = "Cosmic Titan", Rarity = "Divine", CoinsPerSecond = 20000000, AssetModelName = "Pet_CosmicTitan" },
}

return Pets
