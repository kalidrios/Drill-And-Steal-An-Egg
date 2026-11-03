--!strict
--[[
	Directory/Rarity/Rarity.luau
	Definição de Raridades no padrão Velvet / PS99 / ref_PSX.
	Clean Room: Sem dependências proprietárias.
]]

export type RarityData = {
	DisplayName: string,
	RarityNumber: number,
	Color: Color3,
}

local Rarity = {
	Basic = {
		DisplayName = "Basic",
		RarityNumber = 1,
		Color = Color3.fromRGB(180, 180, 180),
	},
	Common = {
		DisplayName = "Common",
		RarityNumber = 1,
		Color = Color3.fromRGB(200, 200, 200),
	},
	Uncommon = {
		DisplayName = "Uncommon",
		RarityNumber = 2,
		Color = Color3.fromRGB(100, 210, 100),
	},
	Rare = {
		DisplayName = "Rare",
		RarityNumber = 3,
		Color = Color3.fromRGB(80, 160, 255),
	},
	Epic = {
		DisplayName = "Epic",
		RarityNumber = 4,
		Color = Color3.fromRGB(200, 80, 255),
	},
	Legendary = {
		DisplayName = "Legendary",
		RarityNumber = 5,
		Color = Color3.fromRGB(255, 170, 0),
	},
	Mythical = {
		DisplayName = "Mythical",
		RarityNumber = 6,
		Color = Color3.fromRGB(255, 60, 90),
	},
	Mythic = {
		DisplayName = "Mythic",
		RarityNumber = 6,
		Color = Color3.fromRGB(255, 60, 90),
	},
	Secret = {
		DisplayName = "Secret",
		RarityNumber = 7,
		Color = Color3.fromRGB(40, 240, 220),
	},
	Cosmic = {
		DisplayName = "Cosmic",
		RarityNumber = 8,
		Color = Color3.fromRGB(140, 90, 255),
	},
	Eternal = {
		DisplayName = "Eternal",
		RarityNumber = 9,
		Color = Color3.fromRGB(255, 230, 80),
	},
	Divine = {
		DisplayName = "Divine",
		RarityNumber = 10,
		Color = Color3.fromRGB(255, 255, 255),
	},
	Exclusive = {
		DisplayName = "Exclusive",
		RarityNumber = 11,
		Color = Color3.fromRGB(255, 120, 220),
	},
}

return table.freeze(Rarity)
