-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local BackpackUiConfig = require(ReplicatedStorage.Shared.BackpackUiConfig)
local v1 = {}
local v2 = {}
local v3 = { __mode = "k" }
local v4 = setmetatable(v2, v3)
local v5 = {}
local v6 = { __mode = "k" }
local v7 = setmetatable(v5, v6)
local v8 = {}
local v9 = { __mode = "k" }
local v10 = setmetatable(v8, v9)
local v11 = {}
local v12 = { __mode = "k" }
local v13 = setmetatable(v11, v12)
local v14 = {}
local v15 = { __mode = "k" }
local v16 = setmetatable(v14, v15)
local v17 = TweenInfo.new(BackpackUiConfig.LockedTintFadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function v1.SetLockedTint(v18, v19) -- line 45 | captures: TweenService, BackpackUiConfig, v4, v13, v16, v17
    if v13[v18] == true == v19 then
        return
    end
    if v19 then
        v13[v18] = true
        if v4[v18] == nil then
            v4[v18] = {
                Color = v18.BackgroundColor3,
                Transparency = v18.BackgroundTransparency
            }
        end
    else
        v13[v18] = nil
    end
    local v20 = v4[v18]
    if not v20 then
        return
    end
    local v21 = v16[v18]
    if v21 then
        v21:Cancel()
    end
    local v22 = {}
    if v19 then
        v22.BackgroundColor3 = BackpackUiConfig.LockedTintColor
        v22.BackgroundTransparency = BackpackUiConfig.LockedTintTransparency
    else
        v22.BackgroundColor3 = v20.Color
        v22.BackgroundTransparency = v20.Transparency
    end
    local v23 = TweenService:Create(v18, v17, v22)
    v16[v18] = v23
    if not v19 then
        v23.Completed:Once(function(v24) -- line 74 | captures: v18, v4, v13, v16
            if v24 == Enum.PlaybackState.Completed and not v13[v18] then
                v4[v18] = nil
                v16[v18] = nil
            end
        end)
    end
    v23:Play()
end

function v1.Shake(v25) -- line 86 | captures: RunService, BackpackUiConfig, v7, v10
    local v26 = v7[v25]
    if v26 then
        v26:Disconnect()
    else
        v10[v25] = v25.Rotation
    end
    local v27 = v10[v25] or 0
    local ShakeTime = BackpackUiConfig.ShakeTime
    local ShakeAngle = BackpackUiConfig.ShakeAngle
    local ShakeCycles = BackpackUiConfig.ShakeCycles
    local v28 = 0
    local v29
    v29 = RunService.RenderStepped:Connect(function(v30) -- line 100 | captures: v28, v29, v25, v27, ShakeTime, ShakeAngle, ShakeCycles, v7, v10
        v28 += v30
        local v31 = v28
        if ShakeTime <= v31 or v25.Parent == nil then
            v29:Disconnect()
            if v7[v25] == v29 then
                v7[v25] = nil
                v10[v25] = nil
            end
            v25.Rotation = v27
        else
            local v32 = v28 / ShakeTime
            local v33 = ShakeAngle * (1 - v32)
            local v34 = v32 * ShakeCycles * 2 * 3.141592653589793
            v25.Rotation = v27 + v33 * math.sin(v34)
        end
    end)
    v7[v25] = v29
end

return v1
