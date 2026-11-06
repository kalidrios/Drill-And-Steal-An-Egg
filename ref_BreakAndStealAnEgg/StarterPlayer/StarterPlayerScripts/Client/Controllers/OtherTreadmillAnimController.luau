-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AnimationAssets = require(ReplicatedStorage.Shared.AnimationAssets)
local AnimationCache = require(script.Parent.AnimationCache)
local PublicTreadmillConfig = require(ReplicatedStorage.Shared.PublicTreadmillConfig)
local SpeedConfig = require(ReplicatedStorage.Shared.SpeedConfig)
local TreadmillUpgradeConfig = require(ReplicatedStorage.Shared.TreadmillUpgradeConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local TreadmillRunFallback = AnimationAssets.TreadmillRunFallback
local v2 = {}
local v3 = {}

local function resolveRunId(v4, v5) -- line 89 | captures: TreadmillRunFallback
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

local function findReplicatedRunTrack(v8, v9) -- line 104 | captures: TreadmillRunFallback
    local Humanoid = v8:FindFirstChildOfClass("Humanoid")
    local v10 = Humanoid and Humanoid:FindFirstChildOfClass("Animator")
    if v10 then
        local Animate = v8:FindFirstChild("Animate")
        local v11 = Animate and Animate:FindFirstChild("run")
        local v12 = v11 and v11:FindFirstChildOfClass("Animation")
        local v13 = if not v12 or v12.AnimationId == "" then TreadmillRunFallback else v12.AnimationId
        for v14, v15 in v10:GetPlayingAnimationTracks() do
            if v15 ~= v9 and v15.IsPlaying and v15.Length > 0 then
                local Animation = v15.Animation
                local v16 = Animation and Animation.AnimationId
                if v16 == v13 or v16 == TreadmillRunFallback then
                    return v15
                end
            end
        end
    end
    return nil
end

local function stopEchoTrack(v17) -- line 127
    if v17.Track then
        v17.Track:Stop(0.2)
        v17.Track = nil
    end
end

local function paceFor(v18) -- line 136 | captures: Workspace, PublicTreadmillConfig, TreadmillUpgradeConfig
    local Plot = v18.Plot
    if Plot then
        local v19 = Plot:GetAttribute("TreadmillLevel") or TreadmillUpgradeConfig.DefaultLevel
        return TreadmillUpgradeConfig.AnimationRateFor(v19)
    end
    local DefaultLevel = TreadmillUpgradeConfig.DefaultLevel
    local Plots = Workspace:FindFirstChild("Plots")
    local Owner = v18.Owner
    if Plots and Owner then
        for v20, v21 in Plots:GetChildren() do
            if v21:GetAttribute("OwnerUserId") == Owner.UserId then
                DefaultLevel = v21:GetAttribute("TreadmillLevel") or DefaultLevel
                break
            end
        end
    end
    return TreadmillUpgradeConfig.AnimationRateFor(DefaultLevel) * PublicTreadmillConfig.PaceMult
end

local function tick(v22) -- line 161 | captures: Players, AnimationCache, TreadmillRunFallback, v2, findReplicatedRunTrack, paceFor
    local Owner = v22.Owner
    if not Owner and v22.Plot then
        local OwnerUserId = v22.Plot:GetAttribute("OwnerUserId")
        if typeof(OwnerUserId) == "number" then
            Owner = Players:GetPlayerByUserId(OwnerUserId)
        else
            Owner = nil
        end
    end
    local v23 = Owner and Owner.Character
    if v23 and v23.Parent ~= nil then
        local Humanoid = v23:FindFirstChildOfClass("Humanoid")
        local v24
        if Humanoid then
            if Humanoid.Health <= 0 then
                v24 = true
            else
                if v23 ~= v22.Character then
                    if v22.Track then
                        v22.Track:Stop(0.2)
                        v22.Track = nil
                    end
                    v22.Character = v23
                    v22.UseFallback = false
                end
                v24 = false
            end
        else
            v24 = true
        end
        if not v24 then
            if findReplicatedRunTrack(v23, v22.Track) then
                if v22.Track then
                    v22.Track:Stop(0.2)
                    v22.Track = nil
                end
            else
                local Animate, v25
                if v22.UseFallback then
                    v25 = false
                else
                    Animate = v23:FindFirstChild("Animate")
                    if Animate then
                        Animate = Animate:FindFirstChild("run")
                        if Animate then
                            Animate = Animate:FindFirstChildOfClass("Animation")
                            if Animate then
                                v25 = Animate.AnimationId ~= ""
                            else
                                v25 = false
                            end
                        else
                            v25 = false
                        end
                    else
                        v25 = false
                    end
                end
                local v26 = if v25 then Animate.AnimationId else TreadmillRunFallback
                local Track = v22.Track
                local v27 = os.clock()
                if Track and Track.IsPlaying then
                    local Animation = Track.Animation
                    if Animation and Animation.AnimationId == v26 then
                        if Track.Length > 0 or v27 < v22.LoadDeadline then
                            Track:AdjustSpeed(paceFor(v22))
                            return
                        end
                        v22.UseFallback = true
                        v26 = TreadmillRunFallback
                    end
                end
                if v22.Track then
                    v22.Track:Stop(0.2)
                    v22.Track = nil
                end
                local v28 = AnimationCache.Track(v23, v26, Enum.AnimationPriority.Action, true)
                if v28 and v2[v22.Model] == v22 then
                    v28:Play(0.1)
                    v28:AdjustSpeed(paceFor(v22))
                    v22.Track = v28
                    v22.LoadDeadline = os.clock() + 3
                end
            end
        elseif v22.Track then
            v22.Track:Stop(0.2)
            v22.Track = nil
        end
    else
        if v22.Track then
            v22.Track:Stop(0.2)
            v22.Track = nil
        end
        v22.Character = nil
    end
end

local function startEcho(v29, v30, v31) -- line 223 | captures: v2, tick
    if v2[v29] then
        return
    end
    local v32 = {
        Character = nil,
        Track = nil,
        UseFallback = false,
        Model = v29,
        Plot = v30,
        Owner = v31,
        LoadDeadline = os.clock() + 3
    }
    v2[v29] = v32
    task.spawn(function() -- line 238 | captures: v29, v32, v2, tick
        while v2[v29] == v32 do
            tick(v32)
            task.wait(0.5)
        end
        if v32.Track then
            v32.Track:Stop(0.2)
            v32.Track = nil
        end
    end)
end

local function stopEcho(v33) -- line 247 | captures: v2
    local v34 = v2[v33]
    if v34 then
        v2[v33] = nil
        if v34.Track then
            v34.Track:Stop(0.2)
            v34.Track = nil
        end
    end
end

local function sync(v35, v36) -- line 260 | captures: SpeedConfig, LocalPlayer, v2, startEcho
    local v37 = v35:GetAttribute(SpeedConfig.InUseAttribute) == true
    local v38 = v36:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId
    if not v37 or not v38 then
        local v39 = v2[v35]
        if v39 then
            v2[v35] = nil
            if v39.Track then
                v39.Track:Stop(0.2)
                v39.Track = nil
            end
        end
    else
        startEcho(v35, v36)
    end
end

local function hook(v40, v41) -- line 270 | captures: SpeedConfig, LocalPlayer, v2, v3, startEcho
    if v3[v40] or not v40:IsA("Model") then
        return
    end
    if v40.Name == "TreadmillBoard" or string.find(v40.Name, "Treadmill") == nil then
        return
    end
    local v42 = v40:GetAttributeChangedSignal(SpeedConfig.InUseAttribute)
    v3[v40] = v42:Connect(function() -- line 279 | captures: v40, v41, SpeedConfig, LocalPlayer, v2, startEcho
        local v43 = v40:GetAttribute(SpeedConfig.InUseAttribute) == true
        local v44 = v41:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId
        if not v43 or not v44 then
            local v45 = v2[v40]
            if v45 then
                v2[v40] = nil
                if v45.Track then
                    v45.Track:Stop(0.2)
                    v45.Track = nil
                end
            end
        else
            startEcho(v40, v41)
        end
    end)
    local v46 = v40:GetAttribute(SpeedConfig.InUseAttribute) == true
    local v47 = v41:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId
    if not v46 or not v47 then
        local v48 = v2[v40]
        if v48 then
            v2[v40] = nil
            if v48.Track then
                v48.Track:Stop(0.2)
                v48.Track = nil
            end
        end
    else
        startEcho(v40, v41)
    end
end

local function unhook(v49) -- line 286 | captures: v2, v3
    local v50 = v3[v49]
    if v50 then
        v50:Disconnect()
        v3[v49] = nil
    end
    local v51 = v2[v49]
    if v51 then
        v2[v49] = nil
        if v51.Track then
            v51.Track:Stop(0.2)
            v51.Track = nil
        end
    end
end

local function hookPlot(v52) -- line 295 | captures: SpeedConfig, LocalPlayer, v2, v3, startEcho, hook, unhook
    for v53, v54 in v52:GetChildren() do
        hook(v54, v52)
    end
    v52.ChildAdded:Connect(function(v55) -- line 299 | captures: v52, hook
        hook(v55, v52)
    end)
    v52.ChildRemoved:Connect(unhook)
    v52:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- line 304 | captures: v52, SpeedConfig, LocalPlayer, v2, v3, startEcho
        for v56, v57 in v52:GetChildren() do
            if v3[v57] then
                local v58 = v57:GetAttribute(SpeedConfig.InUseAttribute) == true
                local v59 = v52:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId
                if v58 and v59 then
                    startEcho(v57, v52)
                else
                    local v60 = v2[v57]
                    if v60 then
                        v2[v57] = nil
                        if v60.Track then
                            v60.Track:Stop(0.2)
                            v60.Track = nil
                        end
                    end
                end
            end
        end
    end)
end

local function syncPublic(v61) -- line 314 | captures: PublicTreadmillConfig, LocalPlayer, v2, startEcho
    if v61 ~= LocalPlayer then
        if v61:GetAttribute(PublicTreadmillConfig.SlotAttribute) == nil then
            local v62 = v2[v61]
            if v62 then
                v2[v61] = nil
                if v62.Track then
                    v62.Track:Stop(0.2)
                    v62.Track = nil
                end
            end
        else
            startEcho(v61, nil, v61)
        end
    end
end

local function hookPublicPlayer(v63) -- line 325 | captures: PublicTreadmillConfig, LocalPlayer, v2, startEcho
    v63:GetAttributeChangedSignal(PublicTreadmillConfig.SlotAttribute):Connect(function() -- line 326 | captures: v63, PublicTreadmillConfig, LocalPlayer, v2, startEcho
        if v63 ~= LocalPlayer then
            if v63:GetAttribute(PublicTreadmillConfig.SlotAttribute) == nil then
                local v64 = v2[v63]
                if v64 then
                    v2[v63] = nil
                    if v64.Track then
                        v64.Track:Stop(0.2)
                        v64.Track = nil
                    end
                end
            else
                startEcho(v63, nil, v63)
            end
        end
    end)
    if v63 ~= LocalPlayer then
        if v63:GetAttribute(PublicTreadmillConfig.SlotAttribute) == nil then
            local v65 = v2[v63]
            if v65 then
                v2[v63] = nil
                if v65.Track then
                    v65.Track:Stop(0.2)
                    v65.Track = nil
                end
            end
        else
            startEcho(v63, nil, v63)
        end
    end
end

function v1.Start() -- line 332 | captures: Players, Workspace, PublicTreadmillConfig, LocalPlayer, v2, startEcho, stopEcho, hookPlot, hookPublicPlayer
    for v66, v67 in Players:GetPlayers() do
        local v68 = v67:GetAttributeChangedSignal(PublicTreadmillConfig.SlotAttribute)
        local v69 = v67
        v68:Connect(function() -- line 326 | captures: v69, PublicTreadmillConfig, LocalPlayer, v2, startEcho
            if v69 ~= LocalPlayer then
                if v69:GetAttribute(PublicTreadmillConfig.SlotAttribute) == nil then
                    local v70 = v2[v69]
                    if v70 then
                        v2[v69] = nil
                        if v70.Track then
                            v70.Track:Stop(0.2)
                            v70.Track = nil
                        end
                    end
                else
                    startEcho(v69, nil, v69)
                end
            end
        end)
        if v67 ~= LocalPlayer then
            if v67:GetAttribute(PublicTreadmillConfig.SlotAttribute) == nil then
                local v71 = v2[v67]
                if v71 then
                    v2[v67] = nil
                    if v71.Track then
                        v71.Track:Stop(0.2)
                        v71.Track = nil
                    end
                end
            else
                startEcho(v67, nil, v67)
            end
        end
    end
    Players.PlayerAdded:Connect(hookPublicPlayer)
    Players.PlayerRemoving:Connect(stopEcho)
    local Plots = Workspace:WaitForChild("Plots")
    for v72, v73 in Plots:GetChildren() do
        hookPlot(v73)
    end
    Plots.ChildAdded:Connect(hookPlot)
end

return v1
