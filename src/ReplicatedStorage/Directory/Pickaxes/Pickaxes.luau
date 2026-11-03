--!strict
--[[
    Tabela de Balanceamento de Picaretas (Dano nos Ovos, Precos e Cooldown)
    Engenharia Reversa baseada em ref_MinePerClick/PickaxeList e ref_BreakAndStealAnEgg/BatConfig
    Clean Room: Sem ProductIds proprietarios, sem nomes ofuscados.
]]

export type PickaxeEntry = {
	Name: string,
	Rarity: string,
	Damage: number,
	SwingCooldown: number,
	Price: number,
	Range: number,
	AssetModelName: string,
}

local Pickaxes: { [string]: PickaxeEntry } = {
	["Wood Pickaxe"] = {
		Name = "Wood",
		Rarity = "Common",
		Damage = 1,
		SwingCooldown = 0.6,
		Price = 0,
		Range = 12,
		AssetModelName = "WoodPickaxe",
	},
	["Stone Pickaxe"] = {
		Name = "Stone",
		Rarity = "Common",
		Damage = 5,
		SwingCooldown = 0.58,
		Price = 80,
		Range = 12,
		AssetModelName = "StonePickaxe",
	},
	["Gold Pickaxe"] = {
		Name = "Gold",
		Rarity = "Uncommon",
		Damage = 15,
		SwingCooldown = 0.55,
		Price = 350,
		Range = 13,
		AssetModelName = "GoldPickaxe",
	},
	["Diamond Pickaxe"] = {
		Name = "Diamond",
		Rarity = "Rare",
		Damage = 45,
		SwingCooldown = 0.52,
		Price = 1800,
		Range = 13,
		AssetModelName = "DiamondPickaxe",
	},
	["Obsidian Pickaxe"] = {
		Name = "Obsidian",
		Rarity = "Epic",
		Damage = 120,
		SwingCooldown = 0.48,
		Price = 8000,
		Range = 14,
		AssetModelName = "ObsidianPickaxe",
	},
	["Lava Pickaxe"] = {
		Name = "Lava",
		Rarity = "Legendary",
		Damage = 350,
		SwingCooldown = 0.45,
		Price = 35000,
		Range = 15,
		AssetModelName = "LavaPickaxe",
	},
	["Celestial Pickaxe"] = {
		Name = "Celestial",
		Rarity = "Mythic",
		Damage = 1200,
		SwingCooldown = 0.40,
		Price = 150000,
		Range = 16,
		AssetModelName = "CelestialPickaxe",
	},
	["Void Breaker"] = {
		Name = "Void Breaker",
		Rarity = "Divine",
		Damage = 5000,
		SwingCooldown = 0.35,
		Price = 750000,
		Range = 18,
		AssetModelName = "VoidBreaker",
	},
}

return Pickaxes
