--!strict
--[[
    Libray/Shared/Variables.luau
    Variáveis globais compartilhadas de configuração e balanceamento da economia.
    Padrão Velvet Framework / PSX (ref_PSX/ReplicatedStorage/Libray/Shared/Variables.luau).
]]

local Variables = {}

-- Probabilidades de Hatch de Variantes
Variables.NormalChance = 89.0  -- 89% chance
Variables.GoldChance = 10.0    -- 10% chance
Variables.DiamondChance = 1.0  -- 1% chance

-- Multiplicadores de Renda por Variante
Variables.VariantMultipliers = {
	Normal = 1.0,
	Gold = 2.0,
	Diamond = 4.0,
}

-- Configurações de Inventário e Slots
Variables.MaxEquippedPetsDefault = 4
Variables.MaxStoredPetsDefault = 100

-- Multiplicadores Globais de Moedas e Dano
Variables.DefaultCoinMultiplier = 1.0
Variables.DefaultStrengthMultiplier = 1.0

-- Configurações de Cavernas/Paredes
Variables.WallHitCooldown = 0.25
Variables.MaxHitDistanceStuds = 35.0

return Variables
