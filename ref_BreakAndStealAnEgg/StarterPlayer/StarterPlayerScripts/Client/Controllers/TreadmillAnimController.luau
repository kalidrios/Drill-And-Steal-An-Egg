-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationAssets = require(ReplicatedStorage.Shared.AnimationAssets)
local AnimationCache = require(script.Parent.AnimationCache)
local OwnBase = require(script.Parent.OwnBase)
local PublicTreadmillConfig = require(ReplicatedStorage.Shared.PublicTreadmillConfig)
local TreadmillUpgradeConfig = require(ReplicatedStorage.Shared.TreadmillUpgradeConfig)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local TreadmillRunFallback = AnimationAssets.TreadmillRunFallback
local v2 = 0
local v3, Character

local function stopTrack() -- line 56 | captures: v3
    if v3 then
        v3:Stop(0.2)
        v3 = nil
    end
end

local function resolveRunId(v4, v5) -- line 65 | captures: TreadmillRunFallback
    if not v5 then
        local Animate = v4:FindFirstChild("Animate")
        local v6 = Animate and Animate:FindFirstChild("run")
        local v7 = v6 and v6:FindFirstChildOfClass("Animation")
        if v7 and v7.AnimationId ~= "" then
            return v7.AnimationId
        end
    end
    return TreadmillRunFallback
end

local function loadRunTrack(v8, v9, v10, v11) -- line 77 | captures: v2, AnimationCache, TreadmillRunFallback
    local Track = AnimationCache.Track
    local Animate, v12
    if v10 then
        v12 = false
    else
        Animate = v8:FindFirstChild("Animate")
        if Animate then
            Animate = Animate:FindFirstChild("run")
            if Animate then
                Animate = Animate:FindFirstChildOfClass("Animation")
                if Animate then
                    v12 = Animate.AnimationId ~= ""
                else
                    v12 = false
                end
            else
                v12 = false
            end
        else
            v12 = false
        end
    end
    local v13 = if v12 then Animate.AnimationId else TreadmillRunFallback
    local v14 = Track(v8, v13, Enum.AnimationPriority.Action, true)
    if not (v14 and v11 == v2) then
        return nil
    end
    v14:Play(0.1)
    return v14
end

local function warmRunTrack(v15) -- line 105 | captures: AnimationCache, WaitFor, LocalPlayer, TreadmillRunFallback
    local v16 = v15:FindFirstChild("Animate") or v15:WaitForChild("Animate", 10)
    v16 = v16 and (v16:FindFirstChild("run") or v16:WaitForChild("run", 10))
    if v16 then
        local Until = WaitFor.Until
        local v17 = v16
        Until(function() -- line 113 | captures: v17
            return v17:FindFirstChildOfClass("Animation")
        end, 10)
    end
    local Warm, v18, v19
    if LocalPlayer.Character == v15 then
        if v15.Parent == nil then
            v19 = true
        else
            Warm = AnimationCache.Warm
            local Animate = v15:FindFirstChild("Animate")
            v18 = Animate and Animate:FindFirstChild("run")
            v19 = false
        end
    else
        v19 = true
    end
    if v19 then
        return
    end
    local v20 = v18 and v18:FindFirstChildOfClass("Animation")
    local v21 = if not v20 or v20.AnimationId == "" then TreadmillRunFallback else v20.AnimationId
    Warm(v15, v21, Enum.AnimationPriority.Action, true)
end

local function syncPace() -- line 127 | captures: v3, OwnBase, PublicTreadmillConfig, TreadmillUpgradeConfig, LocalPlayer
    if not v3 then
        return
    end
    local v22 = OwnBase.Get()
    local TreadmillLevel = v22 and v22:GetAttribute("TreadmillLevel") or TreadmillUpgradeConfig.DefaultLevel
    local v23 = TreadmillUpgradeConfig.AnimationRateFor(TreadmillLevel)
    if LocalPlayer:GetAttribute(PublicTreadmillConfig.SlotAttribute) ~= nil then
        v23 *= PublicTreadmillConfig.PaceMult
    end
    v3:AdjustSpeed(v23)
end

local function startSession() -- line 142 | captures: v2, v3, Character, AnimationCache, LocalPlayer, TreadmillRunFallback, syncPace
    local Character_2 = LocalPlayer.Character
    local Character_3 = Character_2
    local v24 = Character_2
    local Humanoid
    if Character_2 then
        Humanoid = Character_2:FindFirstChildOfClass("Humanoid")
        v24 = Humanoid
    else
        Humanoid = Character_2
    end
    if v3 and v3.IsPlaying and Character_2 ~= nil and Character_2 == Character then
        return
    end
    v2 += 1
    local v25 = v2
    if v3 then
        v3:Stop(0.2)
        v3 = nil
    end
    local v26, Track, v27
    if Character_2 and Humanoid then
        Character = Character_2
        v26 = false
        Track = AnimationCache.Track
        local Animate = Character_2:FindFirstChild("Animate")
        if Animate then
            Animate = Animate:FindFirstChild("run")
            if Animate then
                Animate = Animate:FindFirstChildOfClass("Animation")
                if Animate then
                    if Animate.AnimationId == "" then
                        v27 = TreadmillRunFallback
                    else
                        v27 = Animate.AnimationId
                    end
                else
                    v27 = TreadmillRunFallback
                end
            else
                v27 = TreadmillRunFallback
            end
        else
            v27 = TreadmillRunFallback
        end
    else
        return
    end
    local v28 = Track(Character_2, v27, Enum.AnimationPriority.Action, true)
    if not (v28 and v25 == v2) then
        v28 = nil
    else
        v28:Play(0.1)
    end
    v3 = v28
    syncPace()
    local v29 = os.clock() + 3
    task.spawn(function() -- line 168 | captures: Character_3, v24, v26, v29, v25, v2, v3, AnimationCache, LocalPlayer, TreadmillRunFallback, syncPace
        while true do
            local v30, v31
            if v25 == v2 then
                task.wait(0.5)
                if v25 == v2 then
                    Character_3 = LocalPlayer.Character
                    v30 = Character_3 and Character_3:FindFirstChildOfClass("Humanoid")
                    v31 = false
                else
                    v31 = true
                end
            else
                v31 = true
            end
            if v31 then
                break
            end
            v24 = v30
            local v32, v33, IsPlaying, v34
            if Character_3 and v24 then
                if v24.Health <= 0 then
                    v34 = true
                else
                    v32 = v3
                    v33 = os.clock()
                    if v32 == nil then
                        IsPlaying = false
                    else
                        IsPlaying = v32.IsPlaying
                        if IsPlaying then
                            if v32.Length > 0 then
                                IsPlaying = true
                            else
                                IsPlaying = v33 < v29
                            end
                        end
                    end
                    v34 = false
                end
            else
                v34 = true
            end
            if not v34 then
                if IsPlaying then
                    syncPace()
                else
                    if v32 and v32.IsPlaying and v32.Length <= 0 then
                        v26 = true
                    end
                    if v3 then
                        v3:Stop(0.2)
                        v3 = nil
                    end
                    local Character = Character_3
                    local v35 = v26
                    local Track = AnimationCache.Track
                    local Animate, v36
                    if v35 then
                        v36 = false
                    else
                        Animate = Character:FindFirstChild("Animate")
                        if Animate then
                            Animate = Animate:FindFirstChild("run")
                            if Animate then
                                Animate = Animate:FindFirstChildOfClass("Animation")
                                if Animate then
                                    v36 = Animate.AnimationId ~= ""
                                else
                                    v36 = false
                                end
                            else
                                v36 = false
                            end
                        else
                            v36 = false
                        end
                    end
                    local v37 = if v36 then Animate.AnimationId else TreadmillRunFallback
                    local v38 = Track(Character, v37, Enum.AnimationPriority.Action, true)
                    if not (v38 and v25 == v2) then
                        v38 = nil
                    else
                        v38:Play(0.1)
                    end
                    v3 = v38
                    syncPace()
                    v29 = v33 + 3
                end
            end
        end
    end)
end

local function endSession() -- line 201 | captures: v2, v3, Character
    v2 += 1
    Character = nil
    if v3 then
        v3:Stop(0.2)
        v3 = nil
    end
end

function v1.Start() -- line 207 | captures: v2, v3, Character, ReplicatedStorage, LocalPlayer, warmRunTrack, startSession, endSession
    if LocalPlayer.Character then
        task.spawn(warmRunTrack, LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(function(v39) -- line 214 | captures: warmRunTrack
        task.spawn(warmRunTrack, v39)
    end)
    local v40 = ReplicatedStorage:WaitForChild("TreadmillSessionRemote", 30)
    if v40 and v40:IsA("RemoteEvent") then
        v40.OnClientEvent:Connect(function(v41) -- line 224 | captures: v2, v3, Character, startSession
            if typeof(v41) == "number" then
                startSession()
            else
                v2 += 1
                Character = nil
                if v3 then
                    v3:Stop(0.2)
                    v3 = nil
                end
            end
        end)
        LocalPlayer.CharacterAdded:Connect(endSession)
    else
        warn("[TreadmillAnimController] TreadmillSessionRemote missing")
    end
end

return v1
