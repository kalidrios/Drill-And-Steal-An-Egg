-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local HellSummonConfig = require(ReplicatedStorage.Shared.HellSummonConfig)
local ShieldModel = require(ReplicatedStorage.Shared.ShieldModel)
local Parent = script.Parent
local CinematicMode = require(Parent.CinematicMode)
local LightningBolt = require(Parent.LightningBolt)
local MovementLock = require(Parent.MovementLock)
local SpatialSfx = require(Parent.SpatialSfx)
local VFXBurst = require(Parent.VFXBurst)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local Timeline = HellSummonConfig.Timeline
local Camera = HellSummonConfig.Camera
local Bolts = HellSummonConfig.Bolts
local Grade = HellSummonConfig.Grade
local Shake = HellSummonConfig.Shake
local Sfx = HellSummonConfig.Sfx
local Cutscene = HellBossConfig.Cutscene
local v2 = { "ParticleEmitter", "Beam", "Trail", "Light", "Fire", "Smoke", "Sparkles" }
local v3 = false
local v4 = {}
local v5 = { __mode = "k" }
local v6 = setmetatable(v4, v5)

local function lerp(v7, v8, v9) -- line 101
    return v7 + (v8 - v7) * v9
end

local function smoothstep(v10) -- line 105
    local v11 = math.clamp(v10, 0, 1)
    return v11 * v11 * (3 - v11 * 2)
end

local function flat(v12) -- line 110
    local X = v12.X
    local Z = v12.Z
    return (Vector3.new(X, 0, Z))
end

local function unitOr(v13, v14) -- line 114
    if v13.Magnitude > 0.001 then
        return v13.Unit
    end
    return v14
end

local function isEffect(v15) -- line 118 | captures: v2
    for v16, v17 in v2 do
        if v15:IsA(v17) then
            return true
        end
    end
    return false
end

local function map() -- line 127 | captures: Workspace, HellEventConfig
    return Workspace:FindFirstChild(HellEventConfig.MapName)
end

local function findPath(v18, v19) -- line 131
    local v20 = v18
    for v21, v22 in v19 do
        v20 = v20 and v20:FindFirstChild(v22)
    end
    return v20
end

local v23, v24
local v25 = false

local function getGate() -- line 158 | captures: v23, Workspace, HellEventConfig, HellSummonConfig, v2
    if v23 and v23.Model.Parent then
        return v23
    end
    local Portal = HellSummonConfig.Portal
    local v26 = Workspace:FindFirstChild(HellEventConfig.MapName)
    for v27, v28 in Portal.Path do
        v26 = v26 and v26:FindFirstChild(v28)
    end
    if v26 then
        local v29 = v26:FindFirstChild(Portal.Surface)
        local v30
        if v26:IsA("Model") then
            v30 = v26:GetBoundingBox().Position
        elseif v26:IsA("BasePart") then
            v30 = v26.Position
        else
            v30 = Vector3.new(0, 0, 0)
        end
        if v29 and v29:IsA("BasePart") then
            v30 = v29.Position
        end
        local v31 = {
            Facing = Vector3.new(-0, -0, -1, -0),
            Model = v26,
            Center = v30
        }
        if not (v29 and v29:IsA("BasePart")) then
            v31.Surface = nil
        else
            v31.Surface = v29
        end
        if not (v29 and v29:IsA("BasePart")) then
            v31.SurfaceColor = Color3.new()
        else
            v31.SurfaceColor = v29.Color
        end
        v31.Effects = {}
        v31.Lights = {}
        v31.Emitters = {}
        for v32, v33 in v26:GetDescendants() do
            local v34 = false
            for v35, v36 in v2 do
                if v33:IsA(v36) then
                    v34 = true
                    break
                end
                v34 = false
            end
            if v34 then
                local Effects = v31.Effects
                local v37 = {
                    Instance = v33,
                    Enabled = v33.Enabled
                }
                table.insert(Effects, v37)
                if v33:IsA("Light") then
                    local Lights = v31.Lights
                    local v38 = {
                        Light = v33,
                        Brightness = v33.Brightness
                    }
                    table.insert(Lights, v38)
                elseif v33:IsA("ParticleEmitter") then
                    local Emitters = v31.Emitters
                    table.insert(Emitters, v33)
                end
            end
        end
        local v39 = Workspace:FindFirstChild(HellEventConfig.MapName) and Workspace:FindFirstChild(HellEventConfig.MapName):FindFirstChild(HellEventConfig.SpawnsFolderName)
        if v39 then
            local v40 = Vector3.new(0, 0, 0)
            local v41 = 0
            for v42, v43 in v39:GetChildren() do
                if v43:IsA("BasePart") then
                    v40 += v43.Position
                    v41 += 1
                end
            end
            if v41 > 0 then
                local v44 = v40 / v41 - v30
                local X = v44.X
                local Z = v44.Z
                local v45 = Vector3.new(X, 0, Z)
                local Facing = v31.Facing
                if v45.Magnitude > 0.001 then
                    Facing = v45.Unit
                end
                v31.Facing = Facing
            end
        end
        v23 = v31
        return v31
    end
    return nil
end

local function stopGateTween() -- line 217 | captures: v24
    if v24 then
        v24:Disconnect()
        v24 = nil
    end
end

local function setGate(v46, v47) -- line 226 | captures: v24, v25, RunService, HellSummonConfig, getGate
    local v48 = getGate()
    v25 = v46
    if v24 then
        v24:Disconnect()
        v24 = nil
    end
    if not v48 then
        return
    end
    local Portal = HellSummonConfig.Portal
    for v49, v50 in v48.Effects do
        local Instance = v50.Instance
        if v46 then
            Instance.Enabled = true
        else
            Instance.Enabled = v50.Enabled
        end
    end
    local Surface = v48.Surface
    if v46 then
        local v51 = { v48.SurfaceColor }
        for v52, v53 in Portal.LitColors do
            table.insert(v51, v53)
        end
        if not v47 or v47 <= 0 then
            for v54, v55 in v48.Lights do
                v55.Light.Brightness = v55.Brightness
            end
            if Surface then
                Surface.Color = v51[#v51]
            end
        else
            local v56 = os.clock()
            v24 = RunService.Heartbeat:Connect(function() -- line 262 | captures: v47, v48, Portal, Surface, v51, v56, v24
                local v57 = os.clock() - v56
                local v58 = v57 / Portal.LightTime
                local v59 = math.clamp(v58, 0, 1)
                local v60 = v59 * v59 * (3 - v59 * 2)
                for v61, v62 in v48.Lights do
                    v62.Light.Brightness = v62.Brightness * v60
                end
                local v63 = v57 / v47
                local v64 = math.clamp(v63, 0, 1) * (#v51 - 1)
                local v65 = math.floor(v64) + 1
                local v66 = #v51 - 1
                local v67 = math.min(v65, v66)
                if Surface then
                    local v68 = v51[v67]
                    local v69 = v51[v67 + 1]
                    local v70 = v64 - (v67 - 1)
                    local v71 = math.clamp(v70, 0, 1)
                    Surface.Color = v68:Lerp(v69, v71 * v71 * (3 - v71 * 2))
                end
                local LightTime = Portal.LightTime
                if math.max(v47, LightTime) <= v57 and v24 then
                    v24:Disconnect()
                    v24 = nil
                end
            end)
        end
    else
        for v72, v73 in v48.Lights do
            v73.Light.Brightness = v73.Brightness
        end
        if Surface then
            Surface.Color = v48.SurfaceColor
        end
    end
end

function v1.SetSummoned(v74) -- line 279 | captures: v3, v25, setGate
    if not (v3 or v74 == v25) then
        setGate(v74)
    end
end

function v1.StopSounds() -- line 287 | captures: TweenService, v6
    for v75 in v6 do
        v6[v75] = nil
        if v75.Parent and v75.IsPlaying then
            TweenService:Create(v75, TweenInfo.new(0.3), { Volume = 0 }):Play()
            local delay = task.delay
            local v76 = v75
            delay(0.3, function() -- line 292 | captures: v76
                v76:Stop()
            end)
        end
    end
end

function v1.IsPlaying() -- line 299 | captures: v3
    return v3
end

local v77 = {}
local v78 = { __mode = "k" }
local v79 = setmetatable(v77, v78)

local function lookOf(v80) -- line 319 | captures: ShieldModel, v79
    local v81 = v79[v80]
    if not v81 then
        v81 = ShieldModel.Capture(v80)
        v79[v80] = v81
    end
    return v81
end

local function getPylons() -- line 328 | captures: Workspace, HellBossConfig, HellEventConfig, HellSummonConfig, ShieldModel, v79
    local v82 = Workspace:FindFirstChild(HellEventConfig.MapName) and Workspace:FindFirstChild(HellEventConfig.MapName):FindFirstChild(HellBossConfig.Shields.Folder)
    if v82 then
        local v83 = {}
        for v84, v85 in v82:GetChildren() do
            local v86 = ShieldModel.HitPart(v85)
            if v86 then
                local v87 = v85:FindFirstChild(HellSummonConfig.Pylons.Orb, true)
                local v88 = if v87 and v87:IsA("BasePart") then v87.Position else v86.Position + Vector3.new(0, 1, 0) * (v86.Size.Y / 2)
                local v89 = {}
                for v90, v91 in v85:GetDescendants() do
                    if v91:IsA("Beam") and v91.Attachment0 and v91.Attachment0.Name == HellSummonConfig.Pylons.ChainAttachment then
                        table.insert(v89, v91)
                    end
                end
                local v92 = {
                    Instance = v85,
                    Orb = v88
                }
                local v93 = v79[v85]
                if not v93 then
                    v93 = ShieldModel.Capture(v85)
                    v79[v85] = v93
                end
                v92.Look = v93
                v92.Chains = v89
                table.insert(v83, v92)
            end
        end
        table.sort(v83, function(v94, v95) -- line 351
            local ShieldIndex = v94.Instance:GetAttribute("ShieldIndex")
            if not ShieldIndex then
                local Name = v94.Instance.Name
                ShieldIndex = tonumber(Name) or 0
            end
            local ShieldIndex_2 = v95.Instance:GetAttribute("ShieldIndex")
            if not ShieldIndex_2 then
                local Name = v95.Instance.Name
                ShieldIndex_2 = tonumber(Name) or 0
            end
            return ShieldIndex < ShieldIndex_2
        end)
        return v83
    end
    return {}
end

local function setChains(v96, v97) -- line 359
    for v98, v99 in v96.Chains do
        v99.Enabled = v97
    end
end

function v1.SetPylonsDormant(v100) -- line 367 | captures: v3, ShieldModel, getPylons
    if not v3 then
        for v101, v102 in getPylons() do
            ShieldModel.SetPowered(v102.Look, not v100)
            for v103, v104 in v102.Chains do
                v104.Enabled = false
            end
        end
    end
end

function v1.Play(v105) -- line 381 | captures: v3, v24, v25, RunService, TweenService, Workspace, HellBossConfig, HellEventConfig, HellSummonConfig, ShieldModel, CinematicMode, LightningBolt, MovementLock, SpatialSfx, VFXBurst, LocalPlayer, Timeline, Camera, Bolts, Grade, Shake, Sfx, Cutscene, v6, getGate, setGate, getPylons
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v106 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v3 or not CurrentCamera or not v106 or not v106:IsA("BasePart") or CinematicMode.IsActive() then
        return
    end
    local v107 = getGate()
    if v107 then
        v3 = true
        local v108 = getPylons()
        local v109 = v105.Effects()
        local FloorY = v105.FloorY
        local Rest = v105.Rest
        local Height = v105.Height
        local X = Rest.X
        local v110 = Rest.Z
        local v111 = Vector3.new(X, FloorY, v110)
        local v112 = v111
        local v113
        if #v108 > 0 then
            local v114 = Vector3.new(0, 0, 0)
            for v115, v116 in v108 do
                v114 += v116.Orb
            end
            local v117 = v114.X / #v108
            v113 = v114.Z / #v108
            v110 = Vector3.new(v117, FloorY, v113)
            v112 = v110
        else
            v110 = v111
        end
        local Center = v107.Center
        local Facing = v107.Facing
        v113 = Center - v110
        local X_2 = v113.X
        local Z = v113.Z
        local v118 = Vector3.new(X_2, 0, Z)
        v113 = -Facing
        if v118.Magnitude > 0.001 then
            v113 = v118.Unit
        end
        local Unit = v113:Cross((Vector3.new(0, 1, 0))).Unit
        local v119 = v110 + Vector3.new(0, 1, 0) * HellSummonConfig.Ball.Up
        local Flight = HellSummonConfig.Flight
        local v120 = Timeline.LandAt - Timeline.EmergeAt
        local v121 = Center - Vector3.new(0, 1, 0) * HellSummonConfig.Portal.ExitDrop + Facing * 6
        local Position = Rest.Position
        local v122 = Position - v121
        local X_3 = v122.X
        local Z_2 = v122.Z
        local v123 = Vector3.new(X_3, 0, Z_2)
        local v124 = if v123.Magnitude > 0.001 then v123.Unit else Facing
        local Rotation = CFrame.lookAt(Vector3.new(0, 0, 0), v124).Rotation

        local function flight(v125) -- line 424 | captures: Rest, Flight, v120, v121, Position, Rotation
            local v126 = v125 / v120
            local v127 = math.clamp(v126, 0, 1)
            local v128 = 3.141592653589793 * v127
            local v129 = (1 - math.cos(v128)) / 2
            local v130 = v121:Lerp(Position, v129)
            local v131 = Vector3.new(0, 1, 0)
            local v132 = 3.141592653589793 * v127
            local v133 = v130 + v131 * (math.sin(v132) * Flight.ArcHeight)
            local v134 = (v127 - Flight.TurnShare) / (1 - Flight.TurnShare)
            local v135 = math.clamp(v134, 0, 1)
            local v136 = v135 * v135 * (3 - v135 * 2)
            return CFrame.new(v133) * Rotation:Lerp(Rest.Rotation, v136)
        end

        local function bossPosition() -- line 431 | captures: v105
            return v105.Root.Position
        end

        local v137 = {}

        local function arc(v138, v139, v140) -- line 437 | captures: v109, v137, LightningBolt
            local v141 = LightningBolt.Arc(v138, v139, v140, v109)
            table.insert(v137, v141)
            return v141
        end

        local function stopArcs(v142) -- line 442 | captures: v137
            for v143, v144 in v137 do
                v144:Stop(v142)
            end
            table.clear(v137)
        end

        local function sound(v145) -- line 450 | captures: v105, SpatialSfx, v6
            local v146 = SpatialSfx.Play(v145.Folder, v145.Name, {
                Mine = true,
                Volume = v145.Volume,
                PlaybackSpeed = v145.PlaybackSpeed
            })
            if v146 then
                if not v146.SoundGroup then
                    v146.SoundGroup = v105.SfxGroup()
                end
                v6[v146] = true
            end
            return v146
        end

        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
        ColorCorrectionEffect.Name = "HellSummonGrade"
        ColorCorrectionEffect.Brightness = Grade.Dark.Brightness
        ColorCorrectionEffect.Contrast = Grade.Dark.Contrast
        ColorCorrectionEffect.Saturation = Grade.Dark.Saturation
        ColorCorrectionEffect.Parent = CurrentCamera

        local function flash(v147, v148) -- line 472 | captures: ColorCorrectionEffect, TweenService
            ColorCorrectionEffect.Brightness = v147.Brightness
            ColorCorrectionEffect.TintColor = v147.Tint
            local v149 = v148 or
            {
                Brightness = 0,
                Contrast = 0,
                Saturation = 0
            }
            TweenService:Create(ColorCorrectionEffect, TweenInfo.new(v147.Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Brightness = v149.Brightness,
                Contrast = v149.Contrast,
                Saturation = v149.Saturation,
                TintColor = Color3.new(1, 1, 1)
            }):Play()
        end

        local v150 = getGate()
        v25 = false
        if v24 then
            v24:Disconnect()
            v24 = nil
        end
        if v150 then
            local Portal = HellSummonConfig.Portal
            for v151, v152 in v150.Effects do
                v152.Instance.Enabled = v152.Enabled
            end
            local Surface = v150.Surface
            for v153, v154 in v150.Lights do
                v154.Light.Brightness = v154.Brightness
            end
            if Surface then
                Surface.Color = v150.SurfaceColor
            end
        end
        for v155, v156 in v108 do
            ShieldModel.SetPowered(v156.Look, false)
            for v157, v158 in v156.Chains do
                v158.Enabled = false
            end
        end
        v105.SetFade(1)
        v105.SetOverride(function() -- line 491 | captures: v121, Rotation
            return CFrame.new(v121) * Rotation
        end)
        local CameraType = CurrentCamera.CameraType
        local FieldOfView = CurrentCamera.FieldOfView
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CinematicMode.Enter(Cutscene)
        MovementLock.Lock(v105.LockReason)
        local v159 = sound(Sfx.Rumble)
        local v160
        local v161 = {}

        local function focusOf(v162) -- line 505
            local v163 = v162.Parent and v162.Parent:FindFirstChildOfClass("Humanoid")
            local v164
            if v163 then
                v164 = v163.CameraOffset
            else
                v164 = Vector3.new(0, 0, 0)
            end
            return v162.Position + Vector3.new(0, 1.5, 0) + v164
        end

        local Position_2 = CurrentCamera.CFrame.Position
        local Parent = v106.Parent and v106.Parent:FindFirstChildOfClass("Humanoid")
        local v165
        if Parent then
            v165 = Parent.CameraOffset
        else
            v165 = Vector3.new(0, 0, 0)
        end
        local v166 = Position_2 - (v106.Position + Vector3.new(0, 1.5, 0) + v165)

        local function home(v167) -- line 511 | captures: v166
            local v168 = v167.Parent and v167.Parent:FindFirstChildOfClass("Humanoid")
            local v169
            if v168 then
                v169 = v168.CameraOffset
            else
                v169 = Vector3.new(0, 0, 0)
            end
            local v170 = v167.Position + Vector3.new(0, 1.5, 0) + v169
            return CFrame.lookAt(v170 + v166, v170)
        end

        local Hero = Cutscene.Hero
        local v171 = Timeline.HeroAt + Hero.Time
        local v172 = v171 + Cutscene.Return
        local v173 = {}

        local function at(v174, v175) -- line 522 | captures: v173
            local v176 = {
                At = v174,
                Run = v175
            }
            table.insert(v173, v176)
        end

        local v177, v178
        for v179, v180 in v108 do
            v177 = Timeline.StrikesAt + (v179 - 1) * Timeline.StrikeEvery + Timeline.StrikeDelay
            local v181 = v180
            v178 = {
                At = v177,
                Run = function() -- line 529 | captures: v105, v109, FloorY, v137, sound, flash, v181, HellBossConfig, HellSummonConfig, ShieldModel, LightningBolt, VFXBurst, Bolts, Grade, Shake, Sfx
                    local Strike = HellSummonConfig.Strike
                    local SkySpread = Strike.SkySpread
                    local Bolts_2 = Strike.Bolts
                    for v182 = 1, Bolts_2 do
                        local delay = task.delay
                        local v183 = (v182 - 1) * Strike.Spacing
                        delay(v183, function() -- line 534 | captures: Strike, SkySpread, v109, v181, LightningBolt, Bolts
                            local function v184(v185, v186, ...)
                                return (Vector3.new(v185, v186, ...))
                            end

                            local v187 = v181.Orb + Vector3.new(0, 1, 0) * Strike.Height + v184(math.random(-SkySpread, SkySpread), 0, math.random(-SkySpread, SkySpread))
                            LightningBolt.Strike(v187, v181.Orb, Bolts.Sky, v109)
                        end)
                    end
                    ShieldModel.SetPowered(v181.Look, true)
                    for v188, v189 in v181.Chains do
                        v189.Enabled = false
                    end
                    VFXBurst.Play(HellBossConfig.Visuals.BlastName, CFrame.new(v181.Orb), Strike.BlastScale, Color3.fromRGB(255, 200, 80))
                    local Play = VFXBurst.Play
                    local SmokeName = HellBossConfig.Visuals.SmokeName
                    local new = CFrame.new
                    local X = v181.Orb.X
                    local Z = v181.Orb.Z
                    Play(SmokeName, new((Vector3.new(X, FloorY, Z))), Strike.GroundSmokeScale)
                    sound(Sfx.Strike)
                    flash(Grade.Strike, Grade.Dark)
                    v105.Shake(Shake.Strike)
                    local CrackleRadius = Strike.CrackleRadius
                    local CrackleArcs = Strike.CrackleArcs
                    for v190 = 1, CrackleArcs do
                        local Orb = v181.Orb

                        local v191 = function() -- line 549 | captures: CrackleRadius, v181
                            local function v192(v193, v194, ...)
                                return (Vector3.new(v193, v194, ...))
                            end

                            return v181.Orb + v192(math.random(-CrackleRadius, CrackleRadius), math.random(-CrackleRadius // 3, CrackleRadius), math.random(-CrackleRadius, CrackleRadius))
                        end

                        local Crackle = Bolts.Crackle
                        local v195 = LightningBolt.Arc(Orb, v191, Crackle, v109)
                        table.insert(v137, v195)
                    end
                end
            }
            table.insert(v173, v178)
        end
        local Riser = Sfx.Riser
        v177 = {
            At = Timeline[Riser.StartAt],
            Run = function() -- line 559 | captures: sound, v161, Riser, Timeline
                local v196 = sound(Riser)
                if not v196 then
                    return
                end
                table.insert(v161, v196)

                local function sync() -- line 563 | captures: v196, Riser, Timeline
                    local v197 = v196.TimeLength - (Timeline[Riser.PeakAt] - Timeline[Riser.StartAt])
                    if v197 > 0 then
                        v196.TimePosition = v197
                    end
                end

                if v196.IsLoaded then
                    local v198 = v196.TimeLength - (Timeline[Riser.PeakAt] - Timeline[Riser.StartAt])
                    if v198 > 0 then
                        v196.TimePosition = v198
                    end
                else
                    v196.Loaded:Once(sync)
                end
            end
        }
        table.insert(v173, v177)
        local Vortex = Sfx.Vortex
        local v199
        local v200 = {
            At = Timeline[Vortex.StartAt],
            Run = function() -- line 579 | captures: v199, sound, v161, Vortex
                v199 = sound(Vortex)
                if v199 then
                    local v201 = v199
                    table.insert(v161, v201)
                end
            end
        }
        table.insert(v173, v200)
        v200 = {
            At = Timeline[Vortex.StopAt],
            Run = function() -- line 585 | captures: v199, Vortex, TweenService
                local v202 = v199
                if not (v202 and v202.Parent) then
                    return
                end
                TweenService:Create(v202, TweenInfo.new(Vortex.FadeOut), { Volume = 0 }):Play()
                task.delay(Vortex.FadeOut, function() -- line 589 | captures: v202
                    v202:Stop()
                end)
            end
        }
        table.insert(v173, v200)
        local v203 = {}
        local FireAt = #v108
        local v204
        for v205 = 1, FireAt do
            v200 = v205 % #v108 + 1
            if v200 ~= v205 then
                v204 = {
                    v108[v205],
                    v108[v200]
                }
                table.insert(v203, v204)
            end
        end
        if #v108 >= 4 then
            local v206 = {
                v108[1],
                v108[3]
            }
            table.insert(v203, v206)
            v206 = {
                v108[2],
                v108[4]
            }
            table.insert(v203, v206)
        end
        for v207, v208 in v203 do
            v178 = Timeline.ChainAt + 0.2 + (v207 - 1) * Timeline.RingEvery
            local v209 = v208
            local v210 = {
                At = v178,
                Run = function() -- line 608 | captures: v105, v109, v137, sound, v209, LightningBolt, Bolts, Shake, Sfx
                    local Orb = v209[1].Orb
                    local Orb_2 = v209[2].Orb
                    local Chain = Bolts.Chain
                    local v211 = LightningBolt.Arc(Orb, Orb_2, Chain, v109)
                    table.insert(v137, v211)
                    v211:SetWidth(0.4)
                    task.delay(0.15, function() -- line 611 | captures: v211
                        v211:SetWidth(1)
                    end)
                    sound(Sfx.Arc)
                    v105.Shake(Shake.Strike * 0.5)
                end
            }
            table.insert(v173, v210)
        end
        local v212 = {
            At = Timeline.ChainAt + 0.1,
            Run = function() -- line 618 | captures: sound, Sfx
                sound(Sfx.Charge)
            end
        }
        table.insert(v173, v212)
        v212 = {
            At = Timeline.ConvergeAt,
            Run = function() -- line 624 | captures: v108, v109, v119, v137, sound, HellSummonConfig, LightningBolt, Timeline, Bolts, Sfx
                local Ball = HellSummonConfig.Ball
                local v213 = Timeline.FireAt - Timeline.ConvergeAt
                local v214 = os.clock()

                local function knotPoint() -- line 628 | captures: Ball, v213, v214, v119
                    local v215 = (os.clock() - v214) / v213
                    local v216 = math.clamp(v215, 0, 1)
                    local StartRadius = Ball.StartRadius
                    local Radius = Ball.Radius
                    local v217 = v216 * v216
                    local v218 = StartRadius + (Radius - StartRadius) * v217
                    local v219 = math.random() - 0.5
                    local v220 = math.random() - 0.5
                    local v221 = math.random() - 0.5
                    local v222 = Vector3.new(v219, v220, v221)
                    local v223
                    if v222.Magnitude > 0.001 then
                        v223 = v222.Unit
                    else
                        v223 = Vector3.new(0, 1, 0)
                    end
                    return v119 + v223 * v218 * (0.4 + math.random() * 0.6)
                end

                local Arcs = Ball.Arcs
                for v224 = 1, Arcs do
                    local Knot = Bolts.Knot
                    local v225 = LightningBolt.Arc(knotPoint, knotPoint, Knot, v109)
                    table.insert(v137, v225)
                end
                for v226, v227 in v108 do
                    local Orb = v227.Orb
                    local Feed = Bolts.Feed
                    local v228 = LightningBolt.Arc(Orb, v119, Feed, v109)
                    table.insert(v137, v228)
                end
                sound(Sfx.Charge)
                sound(Sfx.Arc)
            end
        }
        table.insert(v173, v212)
        v212 = {
            At = Timeline.FireAt,
            Run = function() -- line 646 | captures: v105, v109, Center, v119, v137, sound, flash, HellBossConfig, HellSummonConfig, LightningBolt, VFXBurst, Bolts, Grade, Shake, Sfx
                for v229, v230 in v137 do
                    v230:Stop(0.25)
                end
                table.clear(v137)
                LightningBolt.Strike(v119, Center, Bolts.Blast, v109)
                task.delay(0.12, function() -- line 649 | captures: v109, Center, v119, LightningBolt, Bolts
                    LightningBolt.Strike(v119, Center, Bolts.Blast, v109)
                end)
                VFXBurst.Play(HellBossConfig.Visuals.BlastName, CFrame.new(v119), 2.5, HellSummonConfig.Ball.Color)
                sound(Sfx.Fire)
                flash(Grade.Strike, Grade.Dark)
                v105.Shake(Shake.Fire)
            end
        }
        table.insert(v173, v212)
        v212 = {
            At = Timeline.IgniteAt,
            Run = function() -- line 659 | captures: v160, v105, v107, v109, Center, Facing, sound, flash, v3, HellBossConfig, HellSummonConfig, LightningBolt, VFXBurst, Bolts, Grade, Shake, Sfx, Cutscene, setGate
                setGate(true, HellSummonConfig.Portal.ColorTime)
                for v231, v232 in v107.Emitters do
                    v232:Emit(HellSummonConfig.Portal.BurstCount)
                end
                VFXBurst.Play(HellBossConfig.Visuals.BlastName, CFrame.new(Center), 5, Color3.fromRGB(255, 150, 40))
                VFXBurst.Play(HellBossConfig.Visuals.SmokeName, CFrame.new(Center - Vector3.new(0, 40, 0)), 4)
                sound(Sfx.Portal)
                sound(Sfx.Strike)
                local Sound = Cutscene.Sound
                if Sound then
                    v160 = sound({
                        Folder = Sound.Folder,
                        Name = Sound.Name
                    })
                end
                flash(Grade.Ignite)
                v105.Shake(Shake.Ignite)
                v105.Say("Summon")
                for v233 = 0, 10 do
                    task.delay(v233 * 0.18, function() -- line 678 | captures: v109, Center, Facing, v3, LightningBolt, Bolts
                        if not v3 then
                            return
                        end
                        local v234 = math.random(-60, 60)
                        local v235 = math.random(-80, 80)
                        local v236 = Vector3.new(v234, v235, 0)
                        local v237 = Center + CFrame.lookAt(Vector3.new(0, 0, 0), Facing):VectorToWorldSpace(v236)
                        LightningBolt.Strike(Center, v237, Bolts.Gate, v109)
                    end)
                end
            end
        }
        table.insert(v173, v212)
        local v238 = {
            {
                Track = "FlyIdle",
                Mark = 0,
                At = 0,
                Speed = 1,
                Looped = true,
                Until = v120 - 0.45
            },
            {
                Track = "FlyDown",
                Mark = 0,
                At = v120 - 0.55,
                Speed = HellBossConfig.Rig.Tracks.FlyDown.Length / 0.85
            }
        }
        v178 = {
            At = Timeline.EmergeAt,
            Run = function() -- line 694 | captures: v105, Flight, v120, v121, flight, sound, v238, HellBossConfig, VFXBurst, Shake, Sfx
                local v239 = os.clock()
                v105.SetOverride(function() -- line 696 | captures: v239, v105, Flight, v120, flight
                    local v240 = os.clock() - v239
                    local SetFade = v105.SetFade
                    local v241 = v240 / Flight.FadeIn
                    SetFade(1 - math.clamp(v241, 0, 1))
                    if v120 <= v240 then
                        return nil
                    end
                    return (flight(v240))
                end)
                v105.PlayMove(v238, 0)
                sound(Sfx.Whoosh)
                v105.Shake(Shake.Fire * 0.6)
                VFXBurst.Play(HellBossConfig.Visuals.SmokeName, CFrame.new(v121), 3)
            end
        }
        table.insert(v173, v178)
        v178 = {
            At = Timeline.LandAt,
            Run = function() -- line 711 | captures: v105, v108, v109, v111, bossPosition, sound, flash, LightningBolt, Bolts, Grade, Shake, Sfx
                v105.SetOverride(nil)
                v105.SetFade(0)
                v105.Land(v111)
                sound(Sfx.Land)
                flash(Grade.Land)
                v105.Shake(Shake.Land)
                v105.Say("IntroA")
                for v242, v243 in v108 do
                    LightningBolt.Strike(v243.Orb, bossPosition, Bolts.Lock, v109)
                end
            end
        }
        table.insert(v173, v178)
        v177 = Timeline.HeroAt + Hero.RoarAt
        v178 = {
            At = v177,
            Run = function() -- line 726 | captures: v105
                v105.PlayClip("Roar", 0)
            end
        }
        table.insert(v173, v178)
        v204 = {
            At = v177 + HellBossConfig.RoarHitTime,
            Run = function() -- line 729 | captures: v105, CurrentCamera, v111, FieldOfView, Hero, TweenService
                v105.Roar(v111)
                TweenService:Create(CurrentCamera, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = FieldOfView - Hero.FovPunch }):Play()
            end
        }
        table.insert(v173, v204)
        v204 = {
            At = Timeline.HeroAt + Hero.TitleAt,
            Run = function() -- line 735 | captures: v105
                v105.Say("IntroB")
            end
        }
        table.insert(v173, v204)
        local v244 = v113
        local v245 = v124

        local function shotAt(v246) -- line 740 | captures: v112, v105, v108, Rest, Height, v111, Center, Facing, Unit, v119, Hero, v171, v244, v245, Timeline, Camera
            if v246 < Timeline.StrikesAt then
                local v247 = v246 / Timeline.StrikesAt
                local v248 = math.clamp(v247, 0, 1)
                local v249 = v248 * v248 * (3 - v248 * 2)
                return 1, v112 - v244 * (Camera.Dark.Back - Camera.Dark.PushIn * v249) + Vector3.new(0, 1, 0) * Camera.Dark.Up, Center, Camera.Fov
            end
            if v246 < Timeline.ChainAt and #v108 > 0 then
                local v250 = (v246 - Timeline.StrikesAt) / Timeline.StrikeEvery
                local v251 = math.floor(v250) + 1
                local v252 = #v108
                local v253 = math.clamp(v251, 1, v252)
                local v254 = v108[v253]
                local v255 = (v246 - Timeline.StrikesAt - (v253 - 1) * Timeline.StrikeEvery) / Timeline.StrikeEvery
                local v256 = v112 - v254.Orb
                local X = v256.X
                local Z = v256.Z
                local v257 = Vector3.new(X, 0, Z)
                local v258 = -v244
                if v257.Magnitude > 0.001 then
                    v258 = v257.Unit
                end
                local Angles = CFrame.Angles
                local v259 = -Camera.Pylon.Orbit
                local v260 = v259 + (Camera.Pylon.Orbit - v259) * v255
                local v261 = Angles(0, math.rad(v260), 0)
                local v262 = v254.Orb + v261:VectorToWorldSpace(v258) * Camera.Pylon.Distance + Vector3.new(0, 1, 0) * Camera.Pylon.Up
                return v253 + 10, v262, v254.Orb + Vector3.new(0, 1, 0) * Camera.Pylon.LookUp, Camera.Fov
            end
            if v246 < Timeline.ConvergeAt then
                local v263 = (v246 - Timeline.ChainAt) / (Timeline.ConvergeAt - Timeline.ChainAt)
                local v264 = math.clamp(v263, 0, 1)
                local v265 = v264 * v264 * (3 - v264 * 2)
                local Angles = CFrame.Angles
                local v266 = Camera.Chain.Orbit * v265
                local v267 = Angles(0, math.rad(v266), 0)
                return 3, v112 + v267:VectorToWorldSpace(-v244 * Camera.Chain.Back) + Vector3.new(0, 1, 0) * Camera.Chain.Up, v112, Camera.Chain.Fov
            end
            if v246 < Timeline.IgniteAt - 0.15 then
                return 4, v119 - v244 * Camera.Converge.Back + Vector3.new(0, 1, 0) * Camera.Converge.Up + Unit * Camera.Converge.Side, v119 + v244 * 120, Camera.Fov
            end
            if v246 < Timeline.TrackAt then
                local v268 = (v246 - Timeline.IgniteAt) / (Timeline.TrackAt - Timeline.IgniteAt)
                local v269 = math.clamp(v268, 0, 1)
                local v270 = v269 * v269 * (3 - v269 * 2)
                return 5, Center + Facing * (Camera.Gate.Distance - Camera.Gate.PushIn * v270) + Vector3.new(0, 1, 0) * Camera.Gate.Up, Center, Camera.Fov
            end
            if v246 < Timeline.HeroAt then
                local Position = v105.Root.Position
                return 6, Position + Unit * Camera.Track.Side + Vector3.new(0, 1, 0) * Camera.Track.Up - v245 * Camera.Track.Behind, Position, Camera.Fov
            end
            if v246 < v171 then
                local v271 = (v246 - Timeline.HeroAt) / Hero.Time
                local v272 = math.clamp(v271, 0, 1)
                local v273 = v272 * v272 * (3 - v272 * 2)
                local LookVector = Rest.LookVector
                local X = LookVector.X
                local Z = LookVector.Z
                local v274 = Vector3.new(X, 0, Z)
                local v275
                if v274.Magnitude > 0.001 then
                    v275 = v274.Unit
                else
                    v275 = Vector3.new(-0, -0, -1, -0)
                end
                local RightVector = Rest.RightVector
                local X_2 = RightVector.X
                local Z_2 = RightVector.Z
                local v276 = Vector3.new(X_2, 0, Z_2)
                local v277
                if v276.Magnitude > 0.001 then
                    v277 = v276.Unit
                else
                    v277 = Vector3.new(1, 0, 0)
                end
                local Angle = Hero.At.Angle
                local v278 = math.rad(Angle)
                return 7, v111 + (v275 * math.cos(v278) + v277 * math.sin(v278)) * ((Hero.At.Distance - Hero.PushIn * v273) * Height) + Vector3.new(0, 1, 0) * (Hero.At.Up * Height), v111 + Vector3.new(0, 1, 0) * (Hero.Look * Height), nil
            end
            return 8, nil, nil, nil
        end

        local v279 = os.clock()
        local BindableEvent = Instance.new("BindableEvent")
        local v280 = false
        local v281 = 0
        local v282 = CurrentCamera.CFrame.Position
        local v283 = CurrentCamera.CFrame.Position
        local v284 = CurrentCamera.CFrame
        local FieldOfView_2 = FieldOfView

        local function finish() -- line 799 | captures: v160, v280, v105, CurrentCamera, v108, v137, ColorCorrectionEffect, CameraType, FieldOfView, v159, v161, v166, v172, v279, BindableEvent, v3, RunService, TweenService, ShieldModel, CinematicMode, MovementLock, LocalPlayer, Cutscene, setGate
            if v280 then
                return
            end
            v280 = true
            RunService:UnbindFromRenderStep("HellSummonCutscene")
            for v285, v286 in v137 do
                v286:Stop(0.2)
            end
            table.clear(v137)
            setGate(true)
            for v287, v288 in v108 do
                local Health = v288.Instance:GetAttribute("Health")
                local v289 = if type(Health) == "number" then Health > 0 else true
                ShieldModel.SetPowered(v288.Look, v289)
                for v290, v291 in v288.Chains do
                    v291.Enabled = false
                end
            end
            v105.SetOverride(nil)
            v105.SetFade(0)
            if v159 and v159.Parent then
                TweenService:Create(v159, TweenInfo.new(1), { Volume = 0 }):Play()
            end
            for v292, v293 in v161 do
                if v293.Parent and v293.IsPlaying then
                    TweenService:Create(v293, TweenInfo.new(0.6), { Volume = 0 }):Play()
                end
            end
            local v294 = os.clock() - v279
            local v295 = v172 - 0.1 <= v294
            if v160 and v160.Parent and not v295 then
                TweenService:Create(v160, TweenInfo.new(Cutscene.Sound.FadeOut or 1), { Volume = 0 }):Play()
            end
            TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.5), {
                Brightness = 0,
                Contrast = 0,
                Saturation = 0
            }):Play()
            task.delay(0.6, function() -- line 832 | captures: ColorCorrectionEffect
                ColorCorrectionEffect:Destroy()
            end)
            CurrentCamera.FieldOfView = FieldOfView
            local v296 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v296 and v296:IsA("BasePart") then
                local v297 = v296.Parent and v296.Parent:FindFirstChildOfClass("Humanoid")
                local v298
                if v297 then
                    v298 = v297.CameraOffset
                else
                    v298 = Vector3.new(0, 0, 0)
                end
                local v299 = v296.Position + Vector3.new(0, 1.5, 0) + v298
                CurrentCamera.CFrame = CFrame.lookAt(v299 + v166, v299)
            end
            local v300 = if CameraType == Enum.CameraType.Scriptable then Enum.CameraType.Custom else CameraType
            CurrentCamera.CameraType = v300
            CinematicMode.Exit()
            MovementLock.Unlock(v105.LockReason)
            v3 = false
            BindableEvent:Fire()
        end

        local Value = Enum.RenderPriority.Camera.Value
        RunService:BindToRenderStep("HellSummonCutscene", Value, function(v301) -- line 847 | captures: v281, v282, v283, v284, FieldOfView_2, v105, CurrentCamera, FieldOfView, v166, v171, v172, v173, shotAt, v279, finish, LocalPlayer, Camera, Cutscene
            local v302 = os.clock() - v279
            local v303 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v105.IsAlive() and v303 and v303:IsA("BasePart") then
                for v304, v305 in v173 do
                    if v305.At <= v302 and v305.Run ~= nil then
                        local Run = v305.Run
                        v305.Run = nil
                        local v306, v307 = pcall(Run)
                        if not v306 then
                            warn((("[HellSummonCutscene] event at %*s errored: %*"):format(v305.At, v307)))
                        end
                    end
                end
                if v172 <= v302 then
                    finish()
                else
                    local v308, v309, v310, v311 = shotAt(v302)
                    if v308 == 8 then
                        if v281 ~= 8 then
                            v281 = 8
                            FieldOfView_2 = CurrentCamera.FieldOfView
                        end
                        local v312 = (v302 - v171) / Cutscene.Return
                        local v313 = math.clamp(v312, 0, 1)
                        local v314 = v313 * v313 * (3 - v313 * 2)
                        local v315 = v284
                        local v316 = v303.Parent and v303.Parent:FindFirstChildOfClass("Humanoid")
                        local v317
                        if v316 then
                            v317 = v316.CameraOffset
                        else
                            v317 = Vector3.new(0, 0, 0)
                        end
                        local v318 = v303.Position + Vector3.new(0, 1.5, 0) + v317
                        CurrentCamera.CFrame = v315:Lerp(CFrame.lookAt(v318 + v166, v318), v314)
                        local FieldOfView_3 = FieldOfView_2
                        CurrentCamera.FieldOfView = FieldOfView_3 + (FieldOfView - FieldOfView_3) * v314
                    else
                        if v309 and v310 then
                            if v308 ~= v281 then
                                v281 = v308
                                v282 = v309
                                v283 = v310
                                if v311 then
                                    CurrentCamera.FieldOfView = v311
                                elseif v308 == 7 then
                                    CurrentCamera.FieldOfView = FieldOfView
                                end
                            end
                        else
                            return
                        end
                        local v319 = -Camera.Smoothing * v301
                        local v320 = 1 - math.exp(v319)
                        v282 = v282:Lerp(v309, v320)
                        v283 = v283:Lerp(v310, v320)
                        v284 = CFrame.lookAt(v282, v283)
                        CurrentCamera.CFrame = v284
                    end
                end
            else
                finish()
            end
        end)
        task.delay(v172 + Cutscene.SafetyGrace, finish)
        BindableEvent.Event:Wait()
        BindableEvent:Destroy()
    else
        warn("[HellSummonCutscene] no gate at Workspace." .. HellEventConfig.MapName .. "." .. table.concat(HellSummonConfig.Portal.Path, "."))
    end
end

return v1
