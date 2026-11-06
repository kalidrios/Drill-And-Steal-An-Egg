-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AdminAbuseConfig = require(ReplicatedStorage.Shared.AdminAbuseConfig)
local ChaseState = require(ReplicatedStorage.Shared.ChaseState)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local MusicBus = require(ReplicatedStorage.Shared.MusicBus)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3 = {}
local v4, v5, v6
local v7 = 1
local v8
local v9 = false
local v10, v11
local v12 = 0
local v13 = {}

local function fadeTo(v14, v15, v16, v17) -- line 78 | captures: TweenService, v13
    local v18 = v13[v14]
    if v18 then
        v18:Cancel()
    end
    local v19
    if v17 then
        v19 = TweenInfo.new(v17.Time, v17.Style, Enum.EasingDirection.InOut)
    else
        v19 = TweenInfo.new(1, Enum.EasingStyle.Linear)
    end
    local v20 = TweenService:Create(v14, v19, { Volume = v15 })
    v13[v14] = v20
    v20.Completed:Once(function(v21) -- line 93 | captures: v14, v16, v20, v13
        if v13[v14] == v20 then
            v13[v14] = nil
        end
        if v21 == Enum.PlaybackState.Completed and v16 then
            v16()
        end
    end)
    v20:Play()
end

local v22

local function playNext(v23) -- line 112 | captures: v7, v8, v9, v22
    if v9 then
        v8 = nil
        v7 = v23
    else
        v22(v23)
    end
end

local function scheduleAdvance(v24) -- line 125 | captures: v7, v8, v9, v12, v22, WaitFor, v2, fadeTo
    local v25 = v12
    task.spawn(function() -- line 127 | captures: v24, v25, v7, v8, v9, v12, v22, WaitFor, v2, fadeTo
        if v24.IsLoaded then
            if v24.TimeLength <= 0 then
                local v26 = false
                local v27 = v24.Loaded:Connect(function() -- line 134 | captures: v26
                    v26 = true
                end)
                WaitFor.Until(function() -- line 137 | captures: v26, v24, v25, v12
                    if v25 == v12 then
                        return v26 or v24.IsLoaded and v24.TimeLength > 0
                    end
                    return true
                end, 30)
                v27:Disconnect()
            end
        else
            local v28 = false
            local v29 = v24.Loaded:Connect(function() -- line 134 | captures: v28
                v28 = true
            end)
            WaitFor.Until(function() -- line 137 | captures: v24, v25, v12, v28
                if v25 == v12 then
                    return v28 or v24.IsLoaded and v24.TimeLength > 0
                end
                return true
            end, 30)
            v29:Disconnect()
        end
        while true do
            if v25 ~= v12 or not v24.IsPlaying and not v24.IsPaused then
                break
            end
            local v30 = v24.TimeLength - v24.TimePosition - 1
            if v30 <= 0 then
                break
            end
            task.wait((math.min(v30, 1)))
        end
        if v25 ~= v12 then
            return
        end
        local v31 = v24
        fadeTo(v24, 0, function() -- line 160 | captures: v31
            v31:Stop()
        end)
        local v32 = v7 % #v2 + 1
        if v9 then
            v8 = nil
            v7 = v32
        else
            v22(v32)
        end
    end)
end

function v22(v33, v34) -- line 167 | captures: v7, v8, v9, v12, v22, WaitFor, v2, v3, fadeTo
    local v35 = v2[v33]
    if not v35 then
        return
    end
    v12 += 1
    v7 = v33
    v8 = v35
    v35.Looped = false
    v35.TimePosition = 0
    v35.Volume = 0
    v35:Play()
    fadeTo(v35, v3[v35], nil, v34)
    local v36 = v12
    task.spawn(function() -- line 127 | captures: v35, v36, v7, v8, v9, v12, v22, WaitFor, v2, fadeTo
        if v35.IsLoaded then
            if v35.TimeLength <= 0 then
                local v37 = false
                local v38 = v35.Loaded:Connect(function() -- line 134 | captures: v37
                    v37 = true
                end)
                WaitFor.Until(function() -- line 137 | captures: v35, v36, v12, v37
                    if v36 == v12 then
                        return v37 or v35.IsLoaded and v35.TimeLength > 0
                    end
                    return true
                end, 30)
                v38:Disconnect()
            end
        else
            local v39 = false
            local v40 = v35.Loaded:Connect(function() -- line 134 | captures: v39
                v39 = true
            end)
            WaitFor.Until(function() -- line 137 | captures: v35, v36, v12, v39
                if v36 == v12 then
                    return v39 or v35.IsLoaded and v35.TimeLength > 0
                end
                return true
            end, 30)
            v40:Disconnect()
        end
        while true do
            if v36 ~= v12 or not v35.IsPlaying and not v35.IsPaused then
                break
            end
            local v41 = v35.TimeLength - v35.TimePosition - 1
            if v41 <= 0 then
                break
            end
            task.wait((math.min(v41, 1)))
        end
        if v36 ~= v12 then
            return
        end
        local v42 = v35
        fadeTo(v35, 0, function() -- line 160 | captures: v42
            v42:Stop()
        end)
        local v43 = v7 % #v2 + 1
        if v9 then
            v8 = nil
            v7 = v43
        else
            v22(v43)
        end
    end)
end

local function wantedCue() -- line 187 | captures: v4, v5, v6, v11, Workspace, AdminAbuseConfig, ChaseState, HellEventConfig, LocalPlayer
    local v44 = LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
    local v45
    if LocalPlayer:GetAttribute(ChaseState.ChasedAttribute) == nil then
        v45 = ChaseState.IsCarrying(LocalPlayer)
    else
        v45 = true
    end
    if v44 and (v11 or v5) then
        return true, v11 or v5
    end
    if v45 then
        return true, v4
    end
    if not v6 or Workspace:GetAttribute(AdminAbuseConfig.StartedAtAttribute) == nil then
        return false, nil
    end
    return true, v6
end

local v46 = {
    Time = HellEventConfig.MusicFadeTime,
    Style = Enum.EasingStyle.Sine
}
local v47 = {
    Time = 1,
    Style = Enum.EasingStyle.Sine
}
local v48 = {
    Time = AdminAbuseConfig.MusicFadeTime,
    Style = Enum.EasingStyle.Sine
}

local function refreshCue() -- line 214 | captures: v4, v5, v6, v7, v8, v9, v10, v11, v12, v22, WaitFor, v2, v3, fadeTo, wantedCue, v46, v47, v48
    local v49, v50 = wantedCue()
    local v51
    if v11 and (v50 == v11 or v10 == v11) then
        v51 = v47
    elseif v5 and (v50 == v5 or v10 == v5) then
        v51 = v46
    elseif v4 and (v50 == v4 or v10 == v4) then
    elseif v6 and (v50 == v6 or v10 == v6) then
        v51 = v48
    end
    if v50 ~= v10 then
        local v52 = v10
        if v52 then
            fadeTo(v52, 0, function() -- line 229 | captures: v52
                v52:Stop()
            end, v51)
        end
        if v50 then
            v50.Looped = true
            v50.TimePosition = 0
            v50.Volume = 0
            v50:Play()
            fadeTo(v50, v3[v50], nil, v51)
        end
        v10 = v50
    end
    if v49 == v9 then
        return
    end
    v9 = v49
    v12 += 1
    if v9 then
        local v53 = v8
        if v53 and v53.Playing then
            fadeTo(v53, 0, function() -- line 252 | captures: v53
                v53:Pause()
            end, v51)
        end
    else
        local v54 = v8
        if v54 and (v54.IsPlaying or v54.IsPaused) then
            v54:Resume()
            fadeTo(v54, v3[v54], nil, v51)
            local v55 = v12
            task.spawn(function() -- line 127 | captures: v54, v55, v7, v8, v9, v12, v22, WaitFor, v2, fadeTo
                if v54.IsLoaded then
                    if v54.TimeLength <= 0 then
                        local v56 = false
                        local v57 = v54.Loaded:Connect(function() -- line 134 | captures: v56
                            v56 = true
                        end)
                        WaitFor.Until(function() -- line 137 | captures: v54, v55, v12, v56
                            if v55 == v12 then
                                return v56 or v54.IsLoaded and v54.TimeLength > 0
                            end
                            return true
                        end, 30)
                        v57:Disconnect()
                    end
                else
                    local v58 = false
                    local v59 = v54.Loaded:Connect(function() -- line 134 | captures: v58
                        v58 = true
                    end)
                    WaitFor.Until(function() -- line 137 | captures: v54, v55, v12, v58
                        if v55 == v12 then
                            return v58 or v54.IsLoaded and v54.TimeLength > 0
                        end
                        return true
                    end, 30)
                    v59:Disconnect()
                end
                while true do
                    if v55 ~= v12 or not v54.IsPlaying and not v54.IsPaused then
                        break
                    end
                    local v60 = v54.TimeLength - v54.TimePosition - 1
                    if v60 <= 0 then
                        break
                    end
                    task.wait((math.min(v60, 1)))
                end
                if v55 ~= v12 then
                    return
                end
                local v61 = v54
                fadeTo(v54, 0, function() -- line 160 | captures: v61
                    v61:Stop()
                end)
                local v62 = v7 % #v2 + 1
                if v9 then
                    v8 = nil
                    v7 = v62
                else
                    v22(v62)
                end
            end)
        else
            v22(v7, v51)
        end
    end
end

function v1.SetHellOverride(v63) -- line 274 | captures: v11, MusicBus, v3, refreshCue
    if v63 == v11 then
        return
    end
    local v64, v65, v66
    if v63 then
        MusicBus.RouteExempt(v63)
        if v3[v63] then
            v66 = true
        else
            v64 = v3
            v65 = v63.Volume > 0 and v63.Volume or 0.5
            v66 = false
        end
    else
        v66 = true
    end
    if not v66 then
        v64[v63] = v65
    end
    v11 = v63
    refreshCue()
end

function v1.Start() -- line 289 | captures: v4, v5, v6, v7, v8, v9, v22, SoundService, Workspace, AdminAbuseConfig, ChaseState, HellEventConfig, MusicBus, LocalPlayer, v2, v3, wantedCue, refreshCue
    local v67 = SoundService:WaitForChild("BackgroundMusic", 30)
    if v67 then
        for v68, v69 in v67:GetChildren() do
            if v69:IsA("Sound") then
                MusicBus.Route(v69)
                local v70 = v69.Volume > 0 and v69.Volume or 0.5
                v3[v69] = v70
                if v69.Name == "Alien Pursuit 2" then
                    v4 = v69
                elseif v69.Name == HellEventConfig.MusicName then
                    v5 = v69
                    MusicBus.RouteExempt(v69)
                    v69:Stop()
                elseif v69.Name == AdminAbuseConfig.MusicName then
                    v6 = v69
                    v69:Stop()
                else
                    table.insert(v2, v69)
                end
            end
        end
        if #v2 == 0 then
            warn("[MusicController] no playlist tracks in BackgroundMusic")
        else
            table.sort(v2, function(v71, v72) -- line 324
                return v71.Name < v72.Name
            end)
            for v73, v74 in v2 do
                local Ended = v74.Ended
                local v75 = v74
                local v76 = v73
                Ended:Connect(function() -- line 333 | captures: v75, v76, v7, v8, v9, v22, v2
                    if v75 == v8 then
                        local v77 = v76 % #v2 + 1
                        if v9 then
                            v8 = nil
                            v7 = v77
                        else
                            v22(v77)
                        end
                    end
                end)
            end
            LocalPlayer:GetAttributeChangedSignal(ChaseState.ChasedAttribute):Connect(refreshCue)
            LocalPlayer:GetAttributeChangedSignal(ChaseState.CarryingAttribute):Connect(refreshCue)
            LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(refreshCue)
            Workspace:GetAttributeChangedSignal(AdminAbuseConfig.StartedAtAttribute):Connect(refreshCue)
            if wantedCue() then
                refreshCue()
            else
                v22(1)
            end
        end
    else
        warn("[MusicController] SoundService.BackgroundMusic missing")
    end
end

return v1
