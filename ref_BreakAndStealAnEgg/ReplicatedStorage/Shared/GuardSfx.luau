-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local GuardSfxConfig = require(script.Parent.GuardSfxConfig)
local v1 = {}
local v2 = Random.new()
local v3 = {}

local function armCueCap(v4, v5, v6) -- line 60 | captures: TweenService, GuardSfxConfig, v3
    local v7 = (v3[v4] or 0) + 1
    v3[v4] = v7
    task.delay(v6 or GuardSfxConfig.CueMaxDuration, function() -- line 63 | captures: v4, v5, v7, TweenService, GuardSfxConfig, v3
        if not (v3[v4] == v7 and v4.Parent and v4.IsPlaying) then
            return
        end
        local v8 = TweenService:Create(v4, TweenInfo.new(GuardSfxConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
        v5[v4] = v8
        local Completed = v8.Completed
        local v9 = v8
        Completed:Once(function() -- line 73 | captures: v9, v4, v5, v7, v3
            if v3[v4] == v7 and v5[v4] == v9 then
                v5[v4] = nil
                v4:Stop()
            end
        end)
        v8:Play()
    end)
end

local v10

local function getSoundGroup() -- line 87 | captures: v10, SoundService, GuardSfxConfig
    if not (v10 and v10.Parent) then
        local v11 = SoundService:FindFirstChild(GuardSfxConfig.SoundGroupName)
        if not (v11 and v11:IsA("SoundGroup")) then
            v11 = nil
        end
        v10 = v11
    end
    return v10
end

function v1.ResolveEmitter(v12) -- line 100 | captures: GuardSfxConfig
    for v13, v14 in GuardSfxConfig.EmitterNames do
        local v15 = v12:FindFirstChild(v14, true)
        if v15 and v15:IsA("BasePart") then
            return v15
        end
    end
    if v12.PrimaryPart then
        return v12.PrimaryPart
    end
    return v12:FindFirstChildWhichIsA("BasePart", true)
end

local function uniqueIds(v16) -- line 120
    local v17 = { v16.Lock }
    if v16.Chase then
        local Chase = v16.Chase
        table.insert(v17, Chase)
    end
    if v16.Catch then
        local Catch = v16.Catch
        table.insert(v17, Catch)
    end
    local v18 = {}
    local v19 = {}
    for v20, v21 in v17 do
        for v22, v23 in v21 do
            if not v18[v23.Id] then
                v18[v23.Id] = true
                local Id = v23.Id
                table.insert(v19, Id)
            end
        end
    end
    return v19
end

function v1.Attach(v24, v25) -- line 150 | captures: v10, ContentProvider, SoundService, GuardSfxConfig, v1, uniqueIds
    local v26 = v1.ResolveEmitter(v24)
    if v26 then
        local v27 = GuardSfxConfig.Get(v25)
        local v28 = {
            Model = v24,
            ZoneId = v25,
            Emitter = v26,
            Config = v27,
            Sounds = {},
            Fades = {}
        }
        if not (v10 and v10.Parent) then
            local v29 = SoundService:FindFirstChild(GuardSfxConfig.SoundGroupName)
            if v29 then
                if not v29:IsA("SoundGroup") then
                    v29 = nil
                end
            else
                v29 = nil
            end
            v10 = v29
        end
        local v30 = v10
        local v31 = {}
        for v32, v33 in uniqueIds(v27) do
            local Sound = Instance.new("Sound")
            Sound.Name = ("GuardRoar_%*"):format(v33)
            Sound.SoundId = ("rbxassetid://%*"):format(v33)
            Sound.Volume = 0
            Sound.SoundGroup = v30
            local Range = v27.Range
            Sound.RollOffMode = GuardSfxConfig.RollOffMode
            Sound.RollOffMaxDistance = Range
            Sound.RollOffMinDistance = Range * GuardSfxConfig.MinDistanceFraction
            Sound.Parent = v26
            v28.Sounds[v33] = Sound
            table.insert(v31, Sound)
        end
        if #v31 > 0 then
            task.spawn(function() -- line 192 | captures: v31, ContentProvider
                pcall(ContentProvider.PreloadAsync, ContentProvider, v31)
            end)
        end
        return v28
    end
    return nil
end

function v1.Detach(v34) -- line 201 | captures: v3
    for v35, v36 in v34.Fades do
        v36:Cancel()
    end
    table.clear(v34.Fades)
    for v37, v38 in v34.Sounds do
        v3[v38] = nil
        v38:Destroy()
    end
    table.clear(v34.Sounds)
end

function v1.Stop(v39) -- line 221 | captures: TweenService, GuardSfxConfig
    for v40, v41 in v39.Sounds do
        if v41.IsPlaying then
            local v42 = v39.Fades[v41]
            if v42 then
                v42:Cancel()
            end
            local v43 = TweenService:Create(v41, TweenInfo.new(GuardSfxConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
            v39.Fades[v41] = v43
            local Completed = v43.Completed
            local v44 = v41
            Completed:Once(function() -- line 238 | captures: v39, v43, v44
                if v39.Fades[v44] == v43 then
                    v39.Fades[v44] = nil
                    v44:Stop()
                end
            end)
            v43:Play()
        end
    end
end

function v1.PlayCue(v45, v46, v47) -- line 254 | captures: TweenService, GuardSfxConfig, v2, v3
    if v46 and #v46 ~= 0 and v45.Emitter.Parent then
        local v48 = (v47 or 1) * (v45.Config.Gain or 1) * GuardSfxConfig.MasterVolume
        local v49 = false
        for v50, v51 in v46 do
            local v52 = v45.Sounds[v51.Id]
            if v52 and v52.Parent then
                local v53 = v45.Fades[v52]
                if v53 then
                    v53:Cancel()
                    v45.Fades[v52] = nil
                end
                local v54 = v51.Volume * v48
                local MaxVolume = GuardSfxConfig.MaxVolume
                v52.Volume = math.clamp(v54, 0, MaxVolume)
                local v55 = v51.Jitter or GuardSfxConfig.Jitter
                v52.PlaybackSpeed = (v51.Speed or 1) + v2:NextNumber(-v55, v55)
                if v51.Range then
                    v52.RollOffMaxDistance = v51.Range
                    v52.RollOffMinDistance = v51.Range * GuardSfxConfig.MinDistanceFraction
                end
                v52:Play()
                local Fades = v45.Fades
                local MaxDuration = v51.MaxDuration
                local v56 = (v3[v52] or 0) + 1
                v3[v52] = v56
                task.delay(MaxDuration or GuardSfxConfig.CueMaxDuration, function() -- line 63 | captures: v52, Fades, v56, TweenService, GuardSfxConfig, v3
                    if not (v3[v52] == v56 and v52.Parent and v52.IsPlaying) then
                        return
                    end
                    local v57 = TweenService:Create(v52, TweenInfo.new(GuardSfxConfig.StopFadeTime, Enum.EasingStyle.Linear), { Volume = 0 })
                    Fades[v52] = v57
                    local Completed = v57.Completed
                    local v58 = v57
                    Completed:Once(function() -- line 73 | captures: v52, Fades, v56, v3, v58
                        if v3[v52] == v56 and Fades[v52] == v58 then
                            Fades[v52] = nil
                            v52:Stop()
                        end
                    end)
                    v57:Play()
                end)
                v49 = true
            end
        end
        return v49
    end
    return false
end

local v59 = {}
local v60 = {}

local function armScreenFlingFade(v61, v62) -- line 320 | captures: TweenService, GuardSfxConfig, v3, v60
    local v63 = (v3[v61] or 0) + 1
    v3[v61] = v63
    local v64 = v62 or GuardSfxConfig.CueMaxDuration
    local ScreenFadeHoldTime = GuardSfxConfig.ScreenFadeHoldTime
    local v65 = math.min(ScreenFadeHoldTime, v64)
    local v66 = v64 - v65
    local StopFadeTime = GuardSfxConfig.StopFadeTime
    local v67 = math.max(v66, StopFadeTime)
    local v68 = TweenService:Create(v61, TweenInfo.new(v67, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, v65), { Volume = 0 })
    v60[v61] = v68
    v68.Completed:Once(function() -- line 335 | captures: v61, v63, v68, v3, v60
        if v3[v61] == v63 and v60[v61] == v68 then
            v60[v61] = nil
            v61:Stop()
        end
    end)
    v68:Play()
end

local function getScreenSound(v69) -- line 345 | captures: v10, SoundService, GuardSfxConfig, v59
    local v70 = v59[v69]
    if v70 and v70.Parent then
        return v70
    end
    local Sound = Instance.new("Sound")
    Sound.Name = ("GuardRoarScreen_%*"):format(v69)
    Sound.SoundId = ("rbxassetid://%*"):format(v69)
    Sound.Volume = 0
    if not (v10 and v10.Parent) then
        local v71 = SoundService:FindFirstChild(GuardSfxConfig.SoundGroupName)
        if v71 then
            if not v71:IsA("SoundGroup") then
                v71 = nil
            end
        else
            v71 = nil
        end
        v10 = v71
    end
    Sound.SoundGroup = v10
    Sound.Parent = SoundService
    v59[v69] = Sound
    return Sound
end

function v1.PlayCue2D(v72, v73, v74) -- line 362 | captures: v10, SoundService, GuardSfxConfig, v2, v59, v60, armScreenFlingFade
    if not v73 or #v73 == 0 then
        return false
    end
    local v75 = (v74 or 1) * (v72.Gain or 1) * GuardSfxConfig.MasterVolume * GuardSfxConfig.ScreenVolumeScale
    local v76 = false
    for v77, v78 in v73 do
        local Id = v78.Id
        local v79 = v59[Id]
        if not (v79 and v79.Parent) then
            v79 = Instance.new("Sound")
            v79.Name = ("GuardRoarScreen_%*"):format(Id)
            v79.SoundId = ("rbxassetid://%*"):format(Id)
            v79.Volume = 0
            if v10 then
                if not v10.Parent then
                    local v80 = SoundService:FindFirstChild(GuardSfxConfig.SoundGroupName)
                    if v80 then
                        if not v80:IsA("SoundGroup") then
                            v80 = nil
                        end
                    else
                        v80 = nil
                    end
                    v10 = v80
                end
            else
                local v81 = SoundService:FindFirstChild(GuardSfxConfig.SoundGroupName)
                if v81 then
                    if not v81:IsA("SoundGroup") then
                        v81 = nil
                    end
                else
                    v81 = nil
                end
                v10 = v81
            end
            v79.SoundGroup = v10
            v79.Parent = SoundService
            v59[Id] = v79
        end
        local v82 = v60[v79]
        if v82 then
            v82:Cancel()
            v60[v79] = nil
        end
        local v83 = v78.Volume * v75
        local MaxVolume = GuardSfxConfig.MaxVolume
        v79.Volume = math.clamp(v83, 0, MaxVolume)
        local v84 = v78.Jitter or GuardSfxConfig.Jitter
        v79.PlaybackSpeed = (v78.Speed or 1) + v2:NextNumber(-v84, v84)
        v79:Play()
        armScreenFlingFade(v79, v78.MaxDuration)
        v76 = true
    end
    return v76
end

function v1.PlayCatch2D(v85) -- line 403 | captures: GuardSfxConfig, v1
    local v86 = GuardSfxConfig.Get(v85)
    local Catch = v86.Catch or v86.Chase or v86.Lock
    return v1.PlayCue2D(v86, Catch, GuardSfxConfig.CatchVolumeScale)
end

function v1.PlayLock(v87) -- line 412 | captures: v1
    return v1.PlayCue(v87, v87.Config.Lock)
end

function v1.PlayChase(v88) -- line 416 | captures: GuardSfxConfig, v1
    local Config = v88.Config
    return v1.PlayCue(v88, Config.Chase or Config.Lock, GuardSfxConfig.ChaseVolumeScale)
end

function v1.PlayCatch(v89) -- line 421 | captures: GuardSfxConfig, v1
    local Config = v89.Config
    local Catch = Config.Catch or Config.Chase or Config.Lock
    return v1.PlayCue(v89, Catch, GuardSfxConfig.CatchVolumeScale)
end

return v1
