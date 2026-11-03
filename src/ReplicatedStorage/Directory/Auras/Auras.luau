--!strict
--[[
    Tabela de Auras (Velocidade de Corrida, Multiplicador e Iluminacao na Mina)
    Engenharia Reversa baseada em ref_MinePerClick/AurasList e Trails de ref_StealAnEgg
    Clean Room: Sem ProductIds proprietarios ou referencias proprietarias.
]]

export type AuraEntry = {
	Name: string,
	SpeedMultiplier: number,
	LightRadiusStuds: number,
	LightBrightness: number,
	LightColor: Color3,
	Price: number,
	AssetParticleName: string,
}

local Auras: { [string]: AuraEntry } = {
	["Lantern Glow"] = {
		Name = "Lantern Glow",
		SpeedMultiplier = 1.05,
		LightRadiusStuds = 20,
		LightBrightness = 1.2,
		LightColor = Color3.fromRGB(255, 220, 150),
		Price = 250,
		AssetParticleName = "Aura_Lantern",
	},
	["Ember Aura"] = {
		Name = "Ember Aura",
		SpeedMultiplier = 1.15,
		LightRadiusStuds = 28,
		LightBrightness = 1.5,
		LightColor = Color3.fromRGB(255, 120, 30),
		Price = 2500,
		AssetParticleName = "Aura_Ember",
	},
	["Jade Flame"] = {
		Name = "Jade Flame",
		SpeedMultiplier = 1.30,
		LightRadiusStuds = 36,
		LightBrightness = 2.0,
		LightColor = Color3.fromRGB(50, 255, 120),
		Price = 20000,
		AssetParticleName = "Aura_Jade",
	},
	["Abyssal Neon"] = {
		Name = "Abyssal Neon",
		SpeedMultiplier = 1.50,
		LightRadiusStuds = 48,
		LightBrightness = 2.5,
		LightColor = Color3.fromRGB(180, 50, 255),
		Price = 150000,
		AssetParticleName = "Aura_Neon",
	},
	["Solar Flare"] = {
		Name = "Solar Flare",
		SpeedMultiplier = 1.85,
		LightRadiusStuds = 65,
		LightBrightness = 3.2,
		LightColor = Color3.fromRGB(255, 240, 200),
		Price = 1200000,
		AssetParticleName = "Aura_Solar",
	},
}

return Auras
