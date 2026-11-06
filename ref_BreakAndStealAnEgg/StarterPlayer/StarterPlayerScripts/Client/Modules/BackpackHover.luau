-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local UiSounds = require(script.Parent.UiSounds)
local v1 = { ScaleName = "BackpackHoverScale" }
local v2 = TweenInfo.new(BackpackUiConfig.HoverTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = {}
local v4 = { __mode = "k" }
local v5 = setmetatable(v3, v4)

local function stateFor(v6) -- line 41 | captures: v5
    local v7 = v5[v6]
    if not v7 then
        v7 = {
            shrink = 1,
            apply = nil
        }
        v5[v6] = v7
    end
    return v7
end

function v1.Attach(v8) -- line 50 | captures: TweenService, BackpackUiConfig, UiSounds, v1, v2, v5
    v8.AutoButtonColor = false
    local v9 = v8:FindFirstChild(v1.ScaleName)
    if not (v9 and v9:IsA("UIScale")) then
        v9 = Instance.new("UIScale")
        v9.Name = v1.ScaleName
        v9.Parent = v8
    end
    local v10 = v5[v8]
    if not v10 then
        v10 = {
            shrink = 1,
            apply = nil
        }
        v5[v8] = v10
    end
    v9.Scale = v10.shrink
    local v11 = false
    local v12 = false
    local v13 = false
    local v14 = v9
    local v15 = v10

    local function apply(v16) -- line 64 | captures: v11, v12, v13, v14, v15, TweenService, BackpackUiConfig, v2
        local v17
        if v13 then
            v17 = BackpackUiConfig.PressScale
        elseif v11 or v12 then
            v17 = BackpackUiConfig.HoverScale
        else
            v17 = 1
        end
        TweenService:Create(v14, v16 or v2, { Scale = v17 * v15.shrink }):Play()
    end

    v10.apply = apply
    v8.MouseEnter:Connect(function() -- line 73 | captures: v11, apply, UiSounds
        if not v11 then
            UiSounds.Hover()
        end
        v11 = true
        apply()
    end)
    v8.MouseLeave:Connect(function() -- line 82 | captures: v11, v13, apply
        v11 = false
        v13 = false
        apply()
    end)
    v8.MouseButton1Down:Connect(function() -- line 86 | captures: v13, apply
        v13 = true
        apply()
    end)
    v8.MouseButton1Up:Connect(function() -- line 90 | captures: v13, apply
        v13 = false
        apply()
    end)
    v8.SelectionGained:Connect(function() -- line 94 | captures: v12, apply, UiSounds
        if not v12 then
            UiSounds.Hover()
        end
        v12 = true
        apply()
    end)
    v8.SelectionLost:Connect(function() -- line 101 | captures: v12, v13, apply
        v12 = false
        v13 = false
        apply()
    end)
    v8.Activated:Connect(UiSounds.Click)
    v8:GetPropertyChangedSignal("Visible"):Connect(function() -- line 110 | captures: v11, v12, v13, v8, v14, v15
        if v8.Visible then
            return
        end
        v11 = false
        v12 = false
        v13 = false
        v14.Scale = v15.shrink
    end)
end

function v1.SetShrink(v18, v19, v20) -- line 122 | captures: v5
    local v21 = v5[v18]
    if not v21 then
        v21 = {
            shrink = 1,
            apply = nil
        }
        v5[v18] = v21
    end
    if v21.shrink ~= v19 then
        v21.shrink = v19
        if v21.apply then
            v21.apply(v20)
        end
    end
end

function v1.Reset(v22) -- line 134 | captures: v1
    local v23 = v22:FindFirstChild(v1.ScaleName)
    if v23 and v23:IsA("UIScale") then
        v23.Scale = 1
    end
end

return v1
