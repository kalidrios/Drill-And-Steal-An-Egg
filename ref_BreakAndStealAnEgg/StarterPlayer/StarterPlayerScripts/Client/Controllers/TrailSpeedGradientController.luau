-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TrailsConfig = require(ReplicatedStorage.Shared.TrailsConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2

local function equippedSequence() -- line 32 | captures: TrailsConfig, LocalPlayer
    local function v3(v4, ...)
        table.insert(v4, ...)
    end

    local v5 = TrailsConfig.ClampEquipped(LocalPlayer:GetAttribute(TrailsConfig.EquippedAttribute))
    local v6 = TrailsConfig.Get(v5)
    local v7 = v6 and v6.Colors
    if v7 and #v7 ~= 0 then
        if #v7 == 1 then
            return ColorSequence.new(v7[1])
        end
        local v8 = table.create(#v7)
        for v9, v10 in v7 do
            v3(v8, ColorSequenceKeypoint.new((v9 - 1) / (#v7 - 1), v10))
        end
        return ColorSequence.new(v8)
    end
    return nil
end

local function apply() -- line 50 | captures: v2, equippedSequence
    local v11 = v2
    if not (v11 and v11.Parent) then
        return
    end
    local v12 = equippedSequence()
    local TrailGradient = v11:FindFirstChild("TrailGradient")
    if v12 then
        if not (TrailGradient and TrailGradient:IsA("UIGradient")) then
            TrailGradient = Instance.new("UIGradient")
            TrailGradient.Name = "TrailGradient"
            TrailGradient.Rotation = 90
            TrailGradient.Parent = v11
        end
        TrailGradient.Color = v12
    elseif TrailGradient then
        TrailGradient:Destroy()
    end
end

function v1.Start() -- line 72 | captures: v2, TrailsConfig, MainGui, LocalPlayer, apply
    LocalPlayer:GetAttributeChangedSignal(TrailsConfig.EquippedAttribute):Connect(apply)
    MainGui.Observe(function(v13) -- line 77 | captures: v2, apply
        local Currencies = v13:FindFirstChild("Currencies")
        local v14 = Currencies and Currencies:FindFirstChild("Speed")
        local v15 = v14 and v14:FindFirstChild("Amount")
        if not (v15 and v15:IsA("TextLabel")) then
            v15 = nil
        end
        v2 = v15
        apply()
    end)
end

return v1
