--!strict
--[[
    Tabela de Monstros Perseguidores (Velocidade, Raio de Percepcao, Modificadores de Dia e Noite)
    Engenharia Reversa baseada em ref_BreakAndStealAnEgg/GuardHitbox e HellMinions
    Clean Room: Sem assets proprietarios.
]]

export type MonsterEntry = {
	Name: string,
	BaseSpeed: number,
	NightSpeedMultiplier: number,
	DetectionRadiusDay: number,
	DetectionRadiusNight: number,
	AttackDamage: number,
	KnockbackForce: number,
	CausesEggDrop: boolean,
	AssetModelName: string,
}

local Monsters: { [string]: MonsterEntry } = {
	["Cave Lurker"] = {
		Name = "Cave Lurker",
		BaseSpeed = 16,
		NightSpeedMultiplier = 1.35, -- Corre a ~21.6 studs/s a noite
		DetectionRadiusDay = 35,
		DetectionRadiusNight = 60,
		AttackDamage = 25,
		KnockbackForce = 45,
		CausesEggDrop = true,
		AssetModelName = "Monster_CaveLurker",
	},
	["Shadow Stalker"] = {
		Name = "Shadow Stalker",
		BaseSpeed = 19,
		NightSpeedMultiplier = 1.45, -- Corre a ~27.5 studs/s a noite
		DetectionRadiusDay = 50,
		DetectionRadiusNight = 85,
		AttackDamage = 45,
		KnockbackForce = 65,
		CausesEggDrop = true,
		AssetModelName = "Monster_ShadowStalker",
	},
	["Abyssal Behemoth"] = {
		Name = "Abyssal Behemoth",
		BaseSpeed = 23,
		NightSpeedMultiplier = 1.55, -- Corre a ~35.6 studs/s a noite
		DetectionRadiusDay = 65,
		DetectionRadiusNight = 120,
		AttackDamage = 999, -- Instakill em profundezas extremas
		KnockbackForce = 90,
		CausesEggDrop = true,
		AssetModelName = "Monster_AbyssalBehemoth",
	},
}

return Monsters
