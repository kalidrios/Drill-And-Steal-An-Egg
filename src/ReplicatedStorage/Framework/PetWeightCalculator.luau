--!strict
--[[
    PetWeightCalculator.luau
    Cálculo de peso (Kg) e multiplicador de Moedas/segundo por peso.
    Revertido e padronizado a partir de ref_BreakAndStealAnEgg (EggRewards.luau) e ref_StealAnEgg.
]]

local PetWeightCalculator = {}

-- Configurações de Curva de Peso
local ANCHOR_KG = 50.0
local CASH_WEIGHT_EXPONENT = 1.25 -- Curva progressiva: mais peso = exponencialmente mais dinheiro
local CASH_WEIGHT_KNEE = 8.0

--[[
    Gera um peso aleatório para o animal baseado no seu peso base em Kg.
    Possui variação gaussiana natural (0.75x a 1.6x do peso base, com raras chances de pesos gigantes/titânicos).
]]
function PetWeightCalculator.RollWeight(baseKg: number, luckMultiplier: number?): number
    local luck = luckMultiplier or 1.0
    local base = baseKg or 40.0
    
    -- Rolo de variação de tamanho/peso (gaussiano centrado em 1.0 com cauda longa para pesos maiores)
    local r1 = math.random()
    local r2 = math.random()
    local standardNormal = math.sqrt(-2 * math.log(math.max(r1, 0.0001))) * math.cos(2 * math.pi * r2)
    
    -- Escala com sorte: pesos gigantes são mais prováveis com ovo de maior sorte
    local scaleFactor = 1.0 + (standardNormal * 0.15) + ((luck - 1.0) * 0.2)
    scaleFactor = math.clamp(scaleFactor, 0.6, 5.0) -- Permite até 5x o peso base (Titânico / Gigante)
    
    local finalKg = math.round(base * scaleFactor * 10) / 10
    return math.max(finalKg, 1.0)
end

--[[
    Calcula o multiplicador de moedas gerado pelo peso do animal.
    Animais mais pesados que a média da sua espécie rendem proporcionalmente muito mais moedas.
]]
function PetWeightCalculator.CalculateCashMultiplier(actualKg: number, baseKg: number): number
    local base = math.max(baseKg or 40.0, 1.0)
    local ratio = actualKg / base
    
    if ratio <= CASH_WEIGHT_KNEE then
        return ratio ^ CASH_WEIGHT_EXPONENT
    else
        local kneeVal = CASH_WEIGHT_KNEE ^ CASH_WEIGHT_EXPONENT
        return kneeVal * (ratio / CASH_WEIGHT_KNEE) ^ 1.15
    end
end

--[[
    Calcula a renda total em moedas/segundo de um pet no Plot.
]]
function PetWeightCalculator.GetCoinsPerSecond(baseCoinsPerSec: number, actualKg: number, baseKg: number, variant: string?): number
    local baseCoins = baseCoinsPerSec or 1.0
    local weightMult = PetWeightCalculator.CalculateCashMultiplier(actualKg, baseKg)
    
    local variantMult = 1.0
    if variant == "Gold" or variant == "Golden" then
        variantMult = 2.0
    elseif variant == "Diamond" then
        variantMult = 4.0
    end
    
    return math.max(math.floor((baseCoins * weightMult * variantMult) + 0.5), 1)
end

return PetWeightCalculator

