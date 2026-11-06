--!strict
--[[
    HatchService.luau
    Serviço central de chocar ovos (Hatching) no servidor.
    Calcula:
    1. Sorteio do Animal baseado na tabela drops do ovo
    2. Sorteio de Variante (Normal, Gold, Diamond)
    3. Sorteio de Peso (Kg) e cálculo final de moedas/segundo
    
    Valores e chances extraídos 1:1 de ref_BreakAndStealAnEgg (EggRewards.luau).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PetWeightCalculator = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("PetWeightCalculator"))

local HatchService = {}

-- Chances base do ref_BreakAndStealAnEgg (EggRewards.luau linhas 58-60)
HatchService.CHANCE_GOLD = 0.01      -- 1.0% (1 em 100)
HatchService.CHANCE_DIAMOND = 0.0025 -- 0.25% (1 em 400)

export type HatchResult = {
    petName: string,
    variant: "Normal" | "Gold" | "Diamond",
    weightKg: number,
    coinsPerSecond: number,
    baseCoinsPerSecond: number,
    baseWeightKg: number,
    rarity: string,
    thumbnail: string,
}

--[[
    Determina a variante do pet sorteado com base na probabilidade de hatch.
]]
function HatchService.RollVariant(luckMultiplier: number?): "Normal" | "Gold" | "Diamond"
    local luck = luckMultiplier or 1.0
    local roll = math.random() -- número decimal entre 0.0 e 1.0
    
    -- Chance ajustada por poções de sorte ou sorte da área
    local diamondThreshold = HatchService.CHANCE_DIAMOND * luck
    local goldThreshold = (HatchService.CHANCE_DIAMOND + HatchService.CHANCE_GOLD) * luck
    
    if roll <= diamondThreshold then
        return "Diamond"
    elseif roll <= goldThreshold then
        return "Gold"
    else
        return "Normal"
    end
end

--[[
    Sorteia um pet a partir da lista de drops de um ovo.
]]
function HatchService.RollPetFromDrops(drops: { { any } }): string?
    if not drops or #drops == 0 then return nil end
    
    -- Calcula peso total
    local totalWeight = 0
    for _, entry in ipairs(drops) do
        totalWeight += (entry[2] or 0)
    end
    
    if totalWeight <= 0 then return drops[1][1] end
    
    local roll = math.random() * totalWeight
    local current = 0
    for _, entry in ipairs(drops) do
        current += entry[2]
        if roll <= current then
            return entry[1]
        end
    end
    
    return drops[#drops][1]
end

--[[
    Executa a abertura completa de um ovo retornando todos os dados prontos para salvar/equipar.
]]
function HatchService.HatchEgg(eggConfig: any, luckMultiplier: number?): HatchResult?
    if not eggConfig or not eggConfig.drops then return nil end
    
    local petName = HatchService.RollPetFromDrops(eggConfig.drops)
    if not petName then return nil end
    
    -- Busca módulo do pet para pegar baseWeight, baseCoins, renders
    local animalsFolder = ReplicatedStorage.Directory.Animals.Normal
    local petModule = animalsFolder:FindFirstChild(petName, true)
    local petData = petModule and petModule:FindFirstChildWhichIsA("ModuleScript")
    local petConfig = petData and require(petData) or {}
    
    local baseKg = petConfig.baseWeightKg or 40.0
    local baseCoins = petConfig.baseCoinsPerSecond or 1.0
    local rarity = petConfig.rarity or "Common"
    
    local variant = HatchService.RollVariant(luckMultiplier)
    local actualKg = PetWeightCalculator.RollWeight(baseKg, luckMultiplier)
    local finalCoinsPerSec = PetWeightCalculator.GetCoinsPerSecond(baseCoins, actualKg, baseKg, variant)
    
    -- Thumbnail correta para a UI
    local thumb = petConfig.NormalThumbnail or ""
    if variant == "Gold" and petConfig.GoldThumbnail ~= "" then
        thumb = petConfig.GoldThumbnail
    elseif variant == "Diamond" and petConfig.DiamondThumbnail ~= "" then
        thumb = petConfig.DiamondThumbnail
    end
    
    return {
        petName = petName,
        variant = variant,
        weightKg = actualKg,
        coinsPerSecond = finalCoinsPerSec,
        baseCoinsPerSecond = baseCoins,
        baseWeightKg = baseKg,
        rarity = rarity,
        thumbnail = thumb,
    }
end

return HatchService
