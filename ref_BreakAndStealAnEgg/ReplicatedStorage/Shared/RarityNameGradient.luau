-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggRewards = require(ReplicatedStorage.Shared.EggRewards)
local PrettyGradient = require(ReplicatedStorage.Shared.PrettyGradient)
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local v1 = {}

function v1.BaseColor(v2) -- line 43 | captures: EggRewards
    if v2.Base then
        return v2.Base
    end
    local Rarity = v2.Rarity
    return Rarity and EggRewards.RarityColors[Rarity] or EggRewards.RarityColors.Common
end

function v1.Apply(v3, v4) -- line 55 | captures: PrettyGradient, RarityGradientFX, v1
    local v5 = v1.BaseColor(v4)
    local Darken = v4.Darken
    local v6
    if not (Darken and Darken > 0) then
    else
        v6 = {
            Target = Color3.new(0, 0, 0),
            Alpha = Darken
        }
    end
    local v7 = PrettyGradient.ApplyToLabel(v3, v5, v6)
    local Rarity = v4.Rarity
    if RarityGradientFX.IsAnimated(Rarity) then
        RarityGradientFX.Attach(v7, Rarity, nil, {
            Master = PrettyGradient.Sequence(v5, v6),
            Rotation = PrettyGradient.Rotation
        })
    else
        RarityGradientFX.Detach(v7)
    end
    return v7
end

return v1
