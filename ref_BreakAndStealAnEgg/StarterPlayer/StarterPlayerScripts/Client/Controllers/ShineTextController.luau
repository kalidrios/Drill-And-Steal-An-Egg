-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RarityGradientFX = require(ReplicatedStorage.Shared.RarityGradientFX)
local ShineTextConfig = require(ReplicatedStorage.Shared.ShineTextConfig)
local MainGui = require(script.Parent.Parent.Modules.MainGui)
local v1 = {}

local function resolve(v2, v3) -- line 25
    local v4 = v2
    for v5, v6 in v3 do
        v4 = v4 and v4:FindFirstChild(v6)
    end
    return v4
end

local function gradientOf(v7) -- line 33
    local UIGradient = v7:FindFirstChildOfClass("UIGradient")
    if UIGradient then
        return UIGradient
    end
    local UIGradient_2 = Instance.new("UIGradient")
    UIGradient_2.Parent = v7
    return UIGradient_2
end

local function bind(v8) -- line 43 | captures: RarityGradientFX, ShineTextConfig
    for v9, v10 in ShineTextConfig.Targets do
        local v11 = v8
        for v12, v13 in v10.Path do
            v11 = v11 and v11:FindFirstChild(v13)
        end
        if v11 and v11:IsA("GuiObject") then
            if v11:IsA("TextLabel") or v11:IsA("TextButton") then
                v11.TextColor3 = Color3.new(1, 1, 1)
            end
            local UIGradient = v11:FindFirstChildOfClass("UIGradient")
            if not UIGradient then
                UIGradient = Instance.new("UIGradient")
                UIGradient.Parent = v11
            end
            UIGradient.Offset = Vector2.zero
            RarityGradientFX.Attach(UIGradient, v10.Rarity, nil, { Rotation = v10.Rotation })
        else
            warn((("[ShineTextController] missing MainGUI.%*"):format((table.concat(v10.Path, ".")))))
        end
    end
end

function v1.Start() -- line 60 | captures: MainGui, bind
    MainGui.Observe(bind)
end

return v1
