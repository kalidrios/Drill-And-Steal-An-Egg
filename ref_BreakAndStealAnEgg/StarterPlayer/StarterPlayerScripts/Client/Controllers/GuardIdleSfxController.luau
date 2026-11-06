-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local GuardIdleSfxConfig = require(ReplicatedStorage.Shared.GuardIdleSfxConfig)
local GuardSfx = require(ReplicatedStorage.Shared.GuardSfx)
local v1 = {}
local v2 = Random.new()
local v3 = {}

local function getSoundGroup() -- line 63 | captures: SoundService, GuardIdleSfxConfig
    local v4 = SoundService:FindFirstChild(GuardIdleSfxConfig.SoundGroupName)
    if not (v4 and v4:IsA("SoundGroup")) then
        return nil
    end
    return v4
end

local function newSound(v5, v6, v7) -- line 68 | captures: SoundService, GuardIdleSfxConfig
    local Sound = Instance.new("Sound")
    Sound.Name = v6
    Sound.SoundId = ("rbxassetid://%*"):format(v7)
    Sound.Volume = 0
    local v8 = SoundService:FindFirstChild(GuardIdleSfxConfig.SoundGroupName)
    if not (v8 and v8:IsA("SoundGroup")) then
        v8 = nil
    end
    Sound.SoundGroup = v8
    Sound.RollOffMode = GuardIdleSfxConfig.RollOffMode
    Sound.RollOffMaxDistance = v5.Config.Range
    Sound.RollOffMinDistance = v5.Config.MinDistance
    Sound.Parent = v5.Holder
    return Sound
end

local function scheduleChirp(v9, v10) -- line 81 | captures: v2
    v9.NextChirpAt = v10 + v2:NextNumber(v9.Config.ChirpMin, v9.Config.ChirpMax)
end

local function setHum(v11, v12) -- line 87 | captures: TweenService, GuardIdleSfxConfig, v2
    local Hum = v11.Hum
    local Hum_2 = v11.Config.Hum
    local v13
    if Hum and Hum_2 then
        if v11.HumOn == v12 then
            v13 = true
        else
            v11.HumOn = v12
            if v11.HumTween then
                v11.HumTween:Cancel()
                v11.HumTween = nil
            end
            v13 = false
        end
    else
        v13 = true
    end
    if v13 then
        return
    end
    local v14, v15
    if v12 then
        v14 = Hum_2.Volume * GuardIdleSfxConfig.MasterVolume
        if Hum.IsPlaying then
            v15 = true
        else
            Hum.Volume = 0
            if Hum.TimeLength > 0 then
                Hum.TimePosition = v2:NextNumber(0, Hum.TimeLength)
            end
            v15 = false
        end
    else
        v14 = 0
        v15 = true
    end
    if not v15 then
        Hum:Play()
    end
    local v16 = TweenService:Create(Hum, TweenInfo.new(GuardIdleSfxConfig.HumFadeTime, Enum.EasingStyle.Sine), { Volume = v14 })
    v11.HumTween = v16
    if not v12 then
        v16.Completed:Once(function(v17) -- line 118 | captures: v11, Hum
            if v17 == Enum.PlaybackState.Completed and not v11.HumOn then
                Hum:Stop()
            end
        end)
    end
    v16:Play()
end

local function armCap(v18, v19, v20) -- line 128 | captures: TweenService, GuardIdleSfxConfig
    local v21 = (v18.PlayTokens[v19] or 0) + 1
    v18.PlayTokens[v19] = v21
    task.delay(v20, function() -- line 131 | captures: v18, v19, v21, TweenService, GuardIdleSfxConfig
        if not (v18.PlayTokens[v19] == v21 and v19.Parent and v19.IsPlaying) then
            return
        end
        local v22 = TweenService:Create(v19, TweenInfo.new(GuardIdleSfxConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
        v22.Completed:Once(function() -- line 140 | captures: v18, v19, v21
            if v18.PlayTokens[v19] == v21 then
                v19:Stop()
            end
        end)
        v22:Play()
    end)
end

local function playChirp(v23) -- line 149 | captures: TweenService, GuardIdleSfxConfig, v2
    local v24 = #v23.Chirps
    if v24 == 0 then
        return
    end
    local v25 = v2:NextInteger(1, v24)
    if v24 > 1 and v25 == v23.LastChirp then
        v25 = v25 % v24 + 1
    end
    v23.LastChirp = v25
    local v26 = v23.Config.Chirps[v25]
    local v27 = v23.Chirps[v25]
    local v28
    if v27 and v27.Parent then
        v28 = v26.Jitter or GuardIdleSfxConfig.Jitter
    else
        return
    end
    v27.Volume = v26.Volume * GuardIdleSfxConfig.MasterVolume
    v27.PlaybackSpeed = (v26.Speed or 1) + v2:NextNumber(-v28, v28)
    v27.TimePosition = 0
    v27:Play()
    local v29 = v26.MaxDuration or GuardIdleSfxConfig.ChirpMaxDuration
    local v30 = (v23.PlayTokens[v27] or 0) + 1
    v23.PlayTokens[v27] = v30
    task.delay(v29, function() -- line 131 | captures: v23, v27, v30, TweenService, GuardIdleSfxConfig
        if not (v23.PlayTokens[v27] == v30 and v27.Parent and v27.IsPlaying) then
            return
        end
        local v31 = TweenService:Create(v27, TweenInfo.new(GuardIdleSfxConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
        v31.Completed:Once(function() -- line 140 | captures: v23, v27, v30
            if v23.PlayTokens[v27] == v30 then
                v27:Stop()
            end
        end)
        v31:Play()
    end)
end

local function stopChirps(v32) -- line 175 | captures: TweenService, GuardIdleSfxConfig
    for v33, v34 in v32.Chirps do
        if v34.IsPlaying then
            v32.PlayTokens[v34] = (v32.PlayTokens[v34] or 0) + 1
            local v35 = TweenService:Create(v34, TweenInfo.new(GuardIdleSfxConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
            local Completed = v35.Completed
            local v36 = v34
            Completed:Once(function() -- line 184 | captures: v36
                v36:Stop()
            end)
            v35:Play()
        end
    end
end

local function isCalm(v37) -- line 192 | captures: GuardIdleSfxConfig
    local ChaseState = v37:GetAttribute("ChaseState")
    if ChaseState == nil then
        return true
    end
    return GuardIdleSfxConfig.CalmStates[ChaseState] == true
end

local function update(v38, v39, v40) -- line 198 | captures: GuardIdleSfxConfig, v2, setHum, playChirp
    local Emitter = v38.Emitter
    local v41 = if Emitter.Parent == nil then false else not v40 or (Emitter.Position - v40).Magnitude <= v38.Config.Range + 20
    if v41 then
        local ChaseState = v38.Model:GetAttribute("ChaseState")
        if ChaseState == nil then
            v41 = true
        else
            v41 = GuardIdleSfxConfig.CalmStates[ChaseState] == true
        end
    end
    setHum(v38, v41)
    if v41 and v38.NextChirpAt <= v39 then
        v38.NextChirpAt = v39 + v2:NextNumber(v38.Config.ChirpMin, v38.Config.ChirpMax)
        playChirp(v38)
    end
end

local function onStateChanged(v42) -- line 214 | captures: GuardIdleSfxConfig, v2, setHum, stopChirps
    local ChaseState = v42.Model:GetAttribute("ChaseState")
    if ChaseState == nil or GuardIdleSfxConfig.CalmStates[ChaseState] == true then
        v42.NextChirpAt = os.clock() + v2:NextNumber(v42.Config.ChirpMin, v42.Config.ChirpMax)
    else
        setHum(v42, false)
        stopChirps(v42)
    end
end

local function attach(v43, v44) -- line 226 | captures: ContentProvider, SoundService, GuardIdleSfxConfig, GuardSfx, v2
    local v45 = GuardSfx.ResolveEmitter(v43)
    if v45 then
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "GuardIdleSfx"
        local v46 = {
            Hum = nil,
            HumOn = false,
            HumTween = nil,
            LastChirp = 0,
            NextChirpAt = 0,
            Model = v43,
            Config = v44,
            Emitter = v45,
            Holder = Attachment,
            Chirps = {},
            PlayTokens = {}
        }
        local v47 = {}
        if v44.Hum then
            local Id = v44.Hum.Id
            local Sound = Instance.new("Sound")
            Sound.Name = "IdleHum"
            Sound.SoundId = ("rbxassetid://%*"):format(Id)
            Sound.Volume = 0
            local v48 = SoundService:FindFirstChild(GuardIdleSfxConfig.SoundGroupName)
            if v48 then
                if not v48:IsA("SoundGroup") then
                    v48 = nil
                end
            else
                v48 = nil
            end
            Sound.SoundGroup = v48
            Sound.RollOffMode = GuardIdleSfxConfig.RollOffMode
            Sound.RollOffMaxDistance = v46.Config.Range
            Sound.RollOffMinDistance = v46.Config.MinDistance
            Sound.Parent = v46.Holder
            Sound.Looped = true
            Sound.PlaybackSpeed = v44.Hum.Speed or 1
            v46.Hum = Sound
            table.insert(v47, Sound)
        end
        for v49, v50 in v44.Chirps do
            local v51 = ("IdleChirp_%*"):format(v49)
            local Id = v50.Id
            local Sound = Instance.new("Sound")
            Sound.Name = v51
            Sound.SoundId = ("rbxassetid://%*"):format(Id)
            Sound.Volume = 0
            local v52 = SoundService:FindFirstChild(GuardIdleSfxConfig.SoundGroupName)
            if not (v52 and v52:IsA("SoundGroup")) then
                v52 = nil
            end
            Sound.SoundGroup = v52
            Sound.RollOffMode = GuardIdleSfxConfig.RollOffMode
            Sound.RollOffMaxDistance = v46.Config.Range
            Sound.RollOffMinDistance = v46.Config.MinDistance
            Sound.Parent = v46.Holder
            v46.Chirps[v49] = Sound
            table.insert(v47, Sound)
        end
        Attachment.Parent = v45
        task.spawn(function() -- line 267 | captures: v47, ContentProvider
            pcall(ContentProvider.PreloadAsync, ContentProvider, v47)
        end)
        v46.NextChirpAt = os.clock() + v2:NextNumber(v46.Config.ChirpMin, v46.Config.ChirpMax)
        return v46
    end
    return nil
end

local function detach(v53) -- line 275
    if v53.HumTween then
        v53.HumTween:Cancel()
    end
    table.clear(v53.PlayTokens)
    v53.Holder:Destroy()
end

local v54 = {}

local function trackGuard(v55) -- line 285 | captures: CollectionService, GuardIdleSfxConfig, v2, v3, setHum, stopChirps, attach, v54
    if v55:IsA("Model") and not v3[v55] then
        local v56 = GuardIdleSfxConfig.Get((v55:GetAttribute("ZoneId")))
        if v56 then
            local v57, v58
            for v59 = 1, 10 do
                local v60
                if v55.Parent then
                    v60 = attach(v55, v56)
                    v57 = v60
                    if v60 then
                        v58 = v60
                        break
                    end
                    if v59 < 10 then
                        task.wait(0.5)
                    end
                else
                    return
                end
                v58 = v60
            end
            if v58 then
                if v55.Parent and not v3[v55] and CollectionService:HasTag(v55, "ZoneGuard") then
                    v3[v55] = v58
                    v54[v55] = v55:GetAttributeChangedSignal("ChaseState"):Connect(function() -- line 318 | captures: v57, GuardIdleSfxConfig, v2, setHum, stopChirps
                        local v61 = v57
                        local ChaseState = v61.Model:GetAttribute("ChaseState")
                        if ChaseState == nil or GuardIdleSfxConfig.CalmStates[ChaseState] == true then
                            v61.NextChirpAt = os.clock() + v2:NextNumber(v61.Config.ChirpMin, v61.Config.ChirpMax)
                        else
                            setHum(v61, false)
                            stopChirps(v61)
                        end
                    end)
                else
                    if v58.HumTween then
                        v58.HumTween:Cancel()
                    end
                    table.clear(v58.PlayTokens)
                    v58.Holder:Destroy()
                end
            end
        end
    end
end

local function untrackGuard(v62) -- line 323 | captures: v3, v54
    local v63 = v3[v62]
    if not v63 then
        return
    end
    v3[v62] = nil
    local v64 = v54[v62]
    if v64 then
        v64:Disconnect()
        v54[v62] = nil
    end
    if v63.HumTween then
        v63.HumTween:Cancel()
    end
    table.clear(v63.PlayTokens)
    v63.Holder:Destroy()
end

function v1.Start() -- line 337 | captures: CollectionService, RunService, Workspace, v3, update, trackGuard, untrackGuard
    for v65, v66 in CollectionService:GetTagged("ZoneGuard") do
        task.spawn(trackGuard, v66)
    end
    CollectionService:GetInstanceAddedSignal("ZoneGuard"):Connect(function(v67) -- line 341 | captures: trackGuard
        task.spawn(trackGuard, v67)
    end)
    CollectionService:GetInstanceRemovedSignal("ZoneGuard"):Connect(untrackGuard)
    local v68 = 0
    RunService.Heartbeat:Connect(function(v69) -- line 347 | captures: v68, Workspace, v3, update
        v68 += v69
        if not (v68 < 0.25) then
            v68 = 0
            if next(v3) ~= nil then
                local CurrentCamera = Workspace.CurrentCamera
                local v70 = CurrentCamera and CurrentCamera.CFrame.Position
                local v71 = os.clock()
                for v72, v73 in v3 do
                    update(v73, v71, v70)
                end
            end
        end
    end)
end

return v1
