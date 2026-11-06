--!strict
--[[
    HatchService.luau
    Serviço central de chocar ovos (Hatching) no servidor.
    Calcula:
    1. Sorteio do Animal baseado na tabela drops do ovo
    2. Sorteio de Variante (89% Normal, 10% Gold, 1% Diamond) usando Variables.luau
    3. Sorteio de Peso (Kg) e cálculo final de moedas/segundo
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Variables = require(ReplicatedStorage:WaitForChild("Libray"):WaitForChild("Shared"):WaitForChild("Variables"))
local PetWeightCalculator = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("PetWeightCalculator"))

local HatchService = {}

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
    Determina a variante do pet sorteado com base no Variables.luau:
    89% Normal, 10% Gold, 1% Diamond.
]]
function HatchService.RollVariant(luckMultiplier: number?): "Normal" | "Gold" | "Diamond"
    local luck = luckMultiplier or 1.0
    local roll = math.random() * 100.0 -- número de 0.0 a 100.0
    
    -- Ajusta chances de Gold e Diamond com o multiplicador de sorte
    local diamondChance = Variables.DiamondChance * luck
    local goldChance = Variables.GoldChance * luck
    
    if roll <= diamondChance then
        return "Diamond"
    elseif roll <= (diamondChance + goldChance) then
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
    
    -- Multiplicador da variante vindo de Variables
    local variantMult = Variables.VariantMultipliers[variant] or 1.0
    local weightMult = PetWeightCalculator.CalculateCashMultiplier(actualKg, baseKg)
    local finalCoinsPerSec = math.max(math.floor((baseCoins * weightMult * variantMult) + 0.5), 1)
    
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
