-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local ZoneHitboxLookup = require(ReplicatedStorage.Shared.ZoneHitboxLookup)
local v1 = {}
local AdaptiveCull = EggConfig.AdaptiveCull
local Tiers = AdaptiveCull.Tiers
local v2 = #Tiers
local v3 = 1
local DistanceScale = Tiers[1].DistanceScale
local HideDelayScale = Tiers[1].HideDelayScale

function v1.GetTier() -- line 52 | captures: v3
    return v3
end

function v1.Distance(v4) -- line 57 | captures: DistanceScale
    return v4 * DistanceScale
end

function v1.HideDelay(v5) -- line 62 | captures: HideDelayScale
    return v5 * HideDelayScale
end

local v6

local function eggZone(v7) -- line 76 | captures: ZoneHitboxLookup
    local ZoneIndex = v7:GetAttribute("ZoneIndex")
    if typeof(ZoneIndex) == "number" then
        return ZoneIndex
    end
    return ZoneHitboxLookup.GetZoneIndexAt(v7.Position)
end

function v1.IsHomeZoneEgg(v8) -- line 84 | captures: v6, ZoneHitboxLookup
    if v6 == nil then
        return false
    end
    local ZoneIndex = v8:GetAttribute("ZoneIndex")
    if typeof(ZoneIndex) ~= "number" then
        ZoneIndex = ZoneHitboxLookup.GetZoneIndexAt(v8.Position)
    end
    return ZoneIndex == v6
end

function v1.EggDistance(v9, v10) -- line 89 | captures: DistanceScale, v1
    if DistanceScale == 1 or v1.IsHomeZoneEgg(v10) then
        return v9
    end
    return v9 * DistanceScale
end

function v1.EggHideDelay(v11, v12) -- line 97 | captures: HideDelayScale, v1
    if HideDelayScale == 1 or v1.IsHomeZoneEgg(v12) then
        return v11
    end
    return v11 * HideDelayScale
end

local function setTier(v13, v14) -- line 104 | captures: v3, DistanceScale, HideDelayScale, Players, AdaptiveCull, Tiers, v2
    local v15 = math.clamp(v13, 1, v2)
    if v15 == v3 then
        return
    end
    v3 = v15
    DistanceScale = Tiers[v15].DistanceScale
    HideDelayScale = Tiers[v15].HideDelayScale
    local LocalPlayer = Players.LocalPlayer
    if LocalPlayer then
        LocalPlayer:SetAttribute("EggCullTier", v15)
    end
    if not AdaptiveCull.Debug then
        return
    end
    local print_2 = print
    local v16 = v14 + 0.5
    print_2((("[EggCullQuality] tier %*/%* at %* fps (distance x%*)"):format(v15, v2, math.floor(v16), DistanceScale)))
end

if AdaptiveCull.Enabled and v2 > 1 then
    local LocalPlayer = Players.LocalPlayer
    if LocalPlayer then
        LocalPlayer:SetAttribute("EggCullTier", v3)
    end
    local v17 = 0.016666666666666666
    local v18 = os.clock() + AdaptiveCull.WarmupSeconds
    local v19, v20
    local v21 = AdaptiveCull.RecoverHold
    local v22 = (-1/0)
    local v23 = false
    local v24 = true
    local v25 = 0
    RunService.Heartbeat:Connect(function() -- line 141 | captures: v6, v25, ZoneHitboxLookup, LocalPlayer
        local v26 = os.clock()
        if v26 < v25 then
            return
        end
        v25 = v26 + 0.25
        local v27 = LocalPlayer and LocalPlayer.Character
        local v28 = v27 and v27:FindFirstChild("HumanoidRootPart")
        if v28 and v28:IsA("BasePart") then
            v6 = ZoneHitboxLookup.GetZoneIndexAt(v28.Position)
        end
    end)
    UserInputService.WindowFocusReleased:Connect(function() -- line 156 | captures: v24
        v24 = false
    end)
    UserInputService.WindowFocused:Connect(function() -- line 159 | captures: v18, v19, v20, v24, AdaptiveCull
        v24 = true
        local v29 = v18
        local v30 = os.clock() + AdaptiveCull.SmoothTime * 2
        v18 = math.max(v29, v30)
        v19 = nil
        v20 = nil
    end)
    RunService.RenderStepped:Connect(function(v31) -- line 167 | captures: v3, v17, v18, v19, v20, v21, v22, v23, v24, AdaptiveCull, v2, setTier
        if not v24 then
            return
        end
        local MaxFrameTime = AdaptiveCull.MaxFrameTime
        local v32 = math.min(v31, MaxFrameTime)
        local v33 = -v31 / AdaptiveCull.SmoothTime
        local v34 = 1 - math.exp(v33)
        v17 += (v32 - v17) * v34
        local v35 = os.clock()
        if v35 < v18 then
            return
        end
        local v36 = 1 / v17
        if v23 then
            local v37 = v35 - v22
            if AdaptiveCull.RelapseWindow < v37 then
                v23 = false
                v21 = AdaptiveCull.RecoverHold
            end
        end
        if v36 < AdaptiveCull.LowFps then
            v20 = nil
            local v38 = v3
            if v2 <= v38 then
                v19 = nil
            elseif v19 then
                local v39 = v35 - v19
                if AdaptiveCull.DowngradeHold <= v39 then
                    v19 = nil
                    if v23 and v35 - v22 <= AdaptiveCull.RelapseWindow then
                        local v40 = v21 * 2
                        local RecoverHoldMax = AdaptiveCull.RecoverHoldMax
                        v21 = math.min(v40, RecoverHoldMax)
                    end
                    v23 = false
                    setTier(v3 + 1, v36)
                end
            else
                v19 = v35
            end
        elseif AdaptiveCull.HighFps < v36 then
            v19 = nil
            if v3 <= 1 then
                v20 = nil
            elseif v20 then
                local v41 = v35 - v20
                if v21 <= v41 then
                    v20 = nil
                    v22 = v35
                    v23 = true
                    setTier(v3 - 1, v36)
                end
            else
                v20 = v35
            end
        else
            v19 = nil
            v20 = nil
        end
    end)
end
return v1
