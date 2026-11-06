-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local GuardFootstepConfig = require(ReplicatedStorage.Shared.GuardFootstepConfig)
local GuardSfx = require(ReplicatedStorage.Shared.GuardSfx)
local v1 = {}
local v2 = Random.new()
local v3 = {}

local function getSoundGroup() -- line 69 | captures: SoundService, GuardFootstepConfig
    local v4 = SoundService:FindFirstChild(GuardFootstepConfig.SoundGroupName)
    if not (v4 and v4:IsA("SoundGroup")) then
        return nil
    end
    return v4
end

local function collectAnimators(v5) -- line 74
    local v6 = {}
    for v7, v8 in v5:GetDescendants() do
        if v8:IsA("Animator") then
            table.insert(v6, v8)
        end
    end
    return v6
end

local function isWalkTrack(v9) -- line 84 | captures: GuardFootstepConfig
    local v10 = v9.Name:lower()
    local Animation = v9.Animation
    local v11
    if Animation then
        v11 = Animation.Name:lower()
    else
        v11 = ""
    end
    for v12, v13 in GuardFootstepConfig.WalkKeywords do
        if string.find(v10, v13, 1, true) or string.find(v11, v13, 1, true) then
            return true
        end
    end
    return false
end

local function resolveWalkTrack(v14, v15) -- line 98 | captures: collectAnimators, isWalkTrack
    local WalkTrack = v14.WalkTrack
    if WalkTrack and WalkTrack.IsPlaying then
        return WalkTrack
    end
    v14.WalkTrack = nil
    if not (v15 < v14.NextTrackScanAt) then
        v14.NextTrackScanAt = v15 + 0.25
        v14.Animators = collectAnimators(v14.Model)
        for v16, v17 in v14.Animators do
            if v17.Parent then
                for v18, v19 in v17:GetPlayingAnimationTracks() do
                    if isWalkTrack(v19) then
                        v14.WalkTrack = v19
                        return v19
                    end
                end
            end
        end
    end
    return nil
end

local function armCap(v20, v21, v22) -- line 128 | captures: TweenService, GuardFootstepConfig
    local v23 = (v20.PlayTokens[v21] or 0) + 1
    v20.PlayTokens[v21] = v23
    task.delay(v22, function() -- line 131 | captures: v20, v21, v23, TweenService, GuardFootstepConfig
        if not (v20.PlayTokens[v21] == v23 and v21.Parent and v21.IsPlaying) then
            return
        end
        local v24 = TweenService:Create(v21, TweenInfo.new(GuardFootstepConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
        v24.Completed:Once(function() -- line 140 | captures: v20, v21, v23
            if v20.PlayTokens[v21] == v23 then
                v21:Stop()
            end
        end)
        v24:Play()
    end)
end

local function step(v25, v26) -- line 149 | captures: TweenService, GuardFootstepConfig, v2
    if v26 - v25.LastStepAt < GuardFootstepConfig.MinStepGap then
        return
    end
    v25.LastStepAt = v26
    v25.StepCount += 1
    local v27 = v25.StepCount % 2 == 0
    local v28, v29, v30
    for v31, v32 in v25.Config.Layers do
        if v32.EveryOther then
            if v27 then
                local v33 = v25.Sounds[v31]
                if v33 and v33.Parent then
                    local Jitter = v32.Jitter or GuardFootstepConfig.Jitter
                    v33.Volume = v32.Volume * GuardFootstepConfig.MasterVolume
                    v33.PlaybackSpeed = (v32.Speed or 1) + v2:NextNumber(-Jitter, Jitter)
                    v33.TimePosition = 0
                    v33:Play()
                    local MaxDuration = v32.MaxDuration or GuardFootstepConfig.StepMaxDuration
                    local v34 = (v25.PlayTokens[v33] or 0) + 1
                    v25.PlayTokens[v33] = v34
                    local delay = task.delay
                    v28 = v25
                    v29 = v33
                    v30 = v34
                    delay(MaxDuration, function() -- line 131 | captures: v28, v29, v30, TweenService, GuardFootstepConfig
                        if not (v28.PlayTokens[v29] == v30 and v29.Parent and v29.IsPlaying) then
                            return
                        end
                        local v35 = TweenService:Create(v29, TweenInfo.new(GuardFootstepConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
                        v35.Completed:Once(function() -- line 140 | captures: v28, v29, v30
                            if v28.PlayTokens[v29] == v30 then
                                v29:Stop()
                            end
                        end)
                        v35:Play()
                    end)
                end
            end
        else
            local v36 = v25.Sounds[v31]
            if v36 and v36.Parent then
                local Jitter = v32.Jitter or GuardFootstepConfig.Jitter
                v36.Volume = v32.Volume * GuardFootstepConfig.MasterVolume
                v36.PlaybackSpeed = (v32.Speed or 1) + v2:NextNumber(-Jitter, Jitter)
                v36.TimePosition = 0
                v36:Play()
                local MaxDuration = v32.MaxDuration or GuardFootstepConfig.StepMaxDuration
                local v37 = (v25.PlayTokens[v36] or 0) + 1
                v25.PlayTokens[v36] = v37
                local delay = task.delay
                v28 = v25
                v29 = v36
                v30 = v37
                delay(MaxDuration, function() -- line 131 | captures: v28, v29, v30, TweenService, GuardFootstepConfig
                    if not (v28.PlayTokens[v29] == v30 and v29.Parent and v29.IsPlaying) then
                        return
                    end
                    local v38 = TweenService:Create(v29, TweenInfo.new(GuardFootstepConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
                    v38.Completed:Once(function() -- line 140 | captures: v28, v29, v30
                        if v28.PlayTokens[v29] == v30 then
                            v29:Stop()
                        end
                    end)
                    v38:Play()
                end)
            end
        end
    end
end

local function resetMotion(v39) -- line 174
    v39.WalkPhase = -1
    v39.StrideAccum = 0
    v39.LastPosition = nil
end

local function updateWalker(v40, v41, v42, v43) -- line 180 | captures: resolveWalkTrack, step
    local Emitter = v40.Emitter
    if Emitter.Parent then
        local Position = Emitter.Position
        local v44
        if v43 then
            local Magnitude = (Position - v43).Magnitude
            v44 = v40.Config.Range + 20 < Magnitude
        end
        if not v43 or not v44 then
            local LastPosition = v40.LastPosition
            v40.LastPosition = Position
            if LastPosition and not (v41 <= 0) then
                local v45 = Position.X - LastPosition.X
                local v46 = Position.Z - LastPosition.Z
                local Magnitude = Vector3.new(v45, 0, v46).Magnitude
                if Magnitude / v41 < v40.Config.MinSpeed then
                    v40.WalkPhase = -1
                    v40.StrideAccum = 0
                else
                    local v47 = resolveWalkTrack(v40, v42)
                    if v47 and v47.Length > 0 then
                        v40.StrideAccum = 0
                        local v48 = v47.Length / 2
                        local TimePosition = v47.TimePosition
                        local WalkPhase = v40.WalkPhase
                        if WalkPhase >= 0 then
                            if WalkPhase < v48 and v48 <= TimePosition then
                                local v49 = not not (TimePosition < WalkPhase)
                                step(v40, v42)
                            elseif TimePosition < WalkPhase then
                                step(v40, v42)
                            end
                        end
                        v40.WalkPhase = TimePosition
                    else
                        v40.WalkPhase = -1
                        v40.StrideAccum += Magnitude
                        local StrideAccum = v40.StrideAccum
                        if v40.Config.StrideLength <= StrideAccum then
                            v40.StrideAccum %= v40.Config.StrideLength
                            step(v40, v42)
                        end
                    end
                end
            end
        else
            v40.WalkPhase = -1
            v40.StrideAccum = 0
            v40.LastPosition = nil
        end
    else
        v40.WalkPhase = -1
        v40.StrideAccum = 0
        v40.LastPosition = nil
    end
end

local function makeFeet(v50, v51) -- line 235
    local v52, v53 = v50:GetBoundingBox()
    local v54 = v52.Position.Y - v53.Y / 2
    local Position = v51.Position
    local X = Position.X
    local Z = Position.Z
    local v55 = Vector3.new(X, v54, Z)
    local Attachment = Instance.new("Attachment")
    Attachment.Name = "GuardFootsteps"
    Attachment.Position = v51.CFrame:PointToObjectSpace(v55)
    Attachment.Parent = v51
    return Attachment
end

local function attach(v56, v57) -- line 248 | captures: ContentProvider, SoundService, GuardFootstepConfig, GuardSfx, collectAnimators, makeFeet
    local v58 = GuardSfx.ResolveEmitter(v56)
    if v58 then
        local v59 = makeFeet(v56, v58)
        local v60 = SoundService:FindFirstChild(GuardFootstepConfig.SoundGroupName)
        if not (v60 and v60:IsA("SoundGroup")) then
            v60 = nil
        end
        local v61 = {}
        for v62, v63 in v57.Layers do
            local Sound = Instance.new("Sound")
            Sound.Name = ("Footstep_%*"):format(v62)
            Sound.SoundId = ("rbxassetid://%*"):format(v63.Id)
            Sound.Volume = 0
            Sound.SoundGroup = v60
            Sound.RollOffMode = GuardFootstepConfig.RollOffMode
            Sound.RollOffMaxDistance = v57.Range
            Sound.RollOffMinDistance = v57.MinDistance
            Sound.Parent = v59
            v61[v62] = Sound
        end
        task.spawn(function() -- line 271 | captures: v61, ContentProvider
            pcall(ContentProvider.PreloadAsync, ContentProvider, v61)
        end)
        return {
            WalkTrack = nil,
            NextTrackScanAt = 0,
            WalkPhase = -1,
            StrideAccum = 0,
            LastPosition = nil,
            LastStepAt = (-1/0),
            StepCount = 0,
            Model = v56,
            Config = v57,
            Emitter = v58,
            Feet = v59,
            Sounds = v61,
            PlayTokens = {},
            Animators = collectAnimators(v56)
        }
    end
    return nil
end

local function detach(v64) -- line 293
    table.clear(v64.PlayTokens)
    v64.Feet:Destroy()
end

local function trackGuard(v65) -- line 298 | captures: CollectionService, GuardFootstepConfig, v3, attach
    if v65:IsA("Model") and not v3[v65] then
        local v66 = GuardFootstepConfig.Get((v65:GetAttribute("ZoneId")))
        if v66 then
            local v67
            for v68 = 1, 10 do
                if v65.Parent then
                    v67 = attach(v65, v66)
                    if v67 then
                        break
                    end
                    if v68 < 10 then
                        task.wait(0.5)
                    end
                else
                    return
                end
            end
            if v67 then
                if v65.Parent and not v3[v65] and CollectionService:HasTag(v65, "ZoneGuard") then
                    v3[v65] = v67
                else
                    table.clear(v67.PlayTokens)
                    v67.Feet:Destroy()
                end
            end
        end
    end
end

local function untrackGuard(v69) -- line 332 | captures: v3
    local v70 = v3[v69]
    if not v70 then
        return
    end
    v3[v69] = nil
    table.clear(v70.PlayTokens)
    v70.Feet:Destroy()
end

function v1.Start() -- line 341 | captures: CollectionService, RunService, Workspace, v3, updateWalker, trackGuard, untrackGuard
    for v71, v72 in CollectionService:GetTagged("ZoneGuard") do
        task.spawn(trackGuard, v72)
    end
    CollectionService:GetInstanceAddedSignal("ZoneGuard"):Connect(function(v73) -- line 345 | captures: trackGuard
        task.spawn(trackGuard, v73)
    end)
    CollectionService:GetInstanceRemovedSignal("ZoneGuard"):Connect(untrackGuard)
    RunService.Heartbeat:Connect(function(v74) -- line 350 | captures: Workspace, v3, updateWalker
        if next(v3) == nil then
            return
        end
        local CurrentCamera = Workspace.CurrentCamera
        local v75 = CurrentCamera and CurrentCamera.CFrame.Position
        local v76 = os.clock()
        for v77, v78 in v3 do
            updateWalker(v78, v74, v76, v75)
        end
    end)
end

return v1
