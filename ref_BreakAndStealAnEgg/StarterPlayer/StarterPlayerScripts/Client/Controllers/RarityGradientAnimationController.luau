-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local v1 = {}

local function animate(v2) -- line 19 | captures: RarityGradientFX
    if v2:IsA("UIGradient") then
        local v3 = v2:GetAttribute(RarityGradientFX.RarityAttribute)
        if typeof(v3) == "string" then
            RarityGradientFX.Attach(v2, v3)
        end
    end
end

function v1.Start() -- line 29 | captures: CollectionService, RarityGradientFX, animate
    for v4, v5 in CollectionService:GetTagged(RarityGradientFX.AnimatedTag) do
        if v5:IsA("UIGradient") then
            local v6 = v5:GetAttribute(RarityGradientFX.RarityAttribute)
            if typeof(v6) == "string" then
                RarityGradientFX.Attach(v5, v6)
            end
        end
    end
    CollectionService:GetInstanceAddedSignal(RarityGradientFX.AnimatedTag):Connect(animate)
end

return v1
