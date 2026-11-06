-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EggConfig = require(ReplicatedStorage.Shared.EggConfig)
local HellBossConfig = require(ReplicatedStorage.Shared.HellBossConfig)
local HellEventConfig = require(ReplicatedStorage.Shared.HellEventConfig)
local ShieldModel = require(ReplicatedStorage.Shared.ShieldModel)
local Modules = script.Parent.Parent.Modules
local BinaryTransition = require(Modules.BinaryTransition)
local CameraShaker = require(Modules.CameraShaker)
local CinematicMode = require(Modules.CinematicMode)
local MovementLock = require(Modules.MovementLock)
local EggLandImpact = require(Modules.EggLandImpact)
local SurfaceLook = require(Modules.SurfaceLook)
local BossTracks = require(Modules.BossTracks)
local BoneFlail = require(Modules.BoneFlail)
local HellSummonCutscene = require(Modules.HellSummonCutscene)
local SpatialSfx = require(Modules.SpatialSfx)
local VFXBurst = require(Modules.VFXBurst)
local MainGui = require(Modules.MainGui)
local ViewportStencil = require(ReplicatedStorage.Shared.Packages.ViewportStencil)
local ViewportStencilConfig = require(ReplicatedStorage.Shared.ViewportStencilConfig)
local MusicController = require(script.Parent.MusicController)
local LocalPlayer = Players.LocalPlayer
local v1 = { CutsceneEnded = Instance.new("BindableEvent") }
local Visuals = HellBossConfig.Visuals
local HellMinions = require(script.Parent.Parent.Modules.HellMinions)
local HellMinionRoar = require(script.Parent.Parent.Modules.HellMinionRoar)
local Attacks = HellBossConfig.Attacks
local Sfx = HellBossConfig.Sfx
local Cutscene = HellBossConfig.Cutscene
do
    local v2 = {
        TurnSharpnessWalk = 9,
        TurnSharpness = 5,
        WalkMinSpeed = 4,
        WalkSpeedSmoothing = 10,
        WalkTeleportMult = 3
    }
end
do
    local v3
    local v4
    local v5
    local v6 = false

    local function now() -- line 202 | captures: Workspace
        return Workspace:GetServerTimeNow()
    end

    local function lerp(v7, v8, v9) -- line 206
        return v7 + (v8 - v7) * v9
    end

    local function smoothstep(v10) -- line 210
        local v11 = math.clamp(v10, 0, 1)
        return v11 * v11 * (3 - v11 * 2)
    end

    local function flat(v12) -- line 215
        local X = v12.X
        local Z = v12.Z
        return (Vector3.new(X, 0, Z))
    end

    local v13 = {}
    local v14 = {}
    local v15 = { __mode = "k" }
    v13.Live = setmetatable(v14, v15)

    function v13.Track(v16) -- line 225 | captures: v13
        if v16 then
            v13.Live[v16] = true
        end
        return v16
    end

    function v13.StopAll() -- line 232 | captures: TweenService, HellSummonCutscene, v13
        for v17 in v13.Live do
            v13.Live[v17] = nil
            if v17.Parent and v17.IsPlaying then
                TweenService:Create(v17, TweenInfo.new(0.3), { Volume = 0 }):Play()
                local delay = task.delay
                local v18 = v17
                delay(0.3, function() -- line 237 | captures: v18
                    v18:Stop()
                end)
            end
        end
        HellSummonCutscene.StopSounds()
    end

    local function sfxGroup() -- line 247 | captures: SpatialSfx, Sfx
        local v19 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
        return v19 and v19.SoundGroup
    end

    local function volumeOf(v20) -- line 253 | captures: HellBossConfig, SpatialSfx, Sfx
        local Volume = v20.Volume
        local v21
        if Volume then
            v21 = Volume
        else
            local v22 = SpatialSfx.Find(v20.Folder or Sfx.Folder, v20.Name)
            v21 = v22 and v22.Volume
        end
        if v21 then
            return v21 * HellBossConfig.SfxVolume
        end
        return nil
    end

    local function playSfx(v23, v24) -- line 262 | captures: HellBossConfig, SpatialSfx, Sfx, v13
        local Play = SpatialSfx.Play
        local v25 = v23.Folder or Sfx.Folder
        local Name = v23.Name
        local v26 = {
            At = v24,
            Range = v23.Range
        }
        v26.MinRange = v23.MinRange or v23.Range * 0.25
        v26.RollOffMode = Enum.RollOffMode.Linear
        v26.PlaybackSpeed = v23.PlaybackSpeed
        local Volume = v23.Volume
        local v27
        if Volume then
            v27 = Volume
        else
            local v28 = SpatialSfx.Find(v23.Folder or Sfx.Folder, v23.Name)
            v27 = v28 and v28.Volume
        end
        if v27 then
            v26.Volume = v27 * HellBossConfig.SfxVolume
        else
            v26.Volume = nil
        end
        local v29 = Play(v25, Name, v26)
        local v30, v31
        if v29 then
            if v29.SoundGroup then
                v31 = true
            else
                local v32 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                v30 = v32 and v32.SoundGroup
                v31 = false
            end
        else
            v31 = true
        end
        if not v31 then
            v29.SoundGroup = v30
        end
        return v13.Track(v29)
    end

    local v33 = {}

    local function shakeFrom(v34, v35, v36) -- line 285 | captures: v4, Workspace, CameraShaker, LocalPlayer, Visuals, v33
        local function v37(v38, ...)
            table.insert(v38, ...)
        end

        local Character = LocalPlayer.Character
        local v39 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v40
        if v39 and v39:IsA("BasePart") then
            v40 = v36 or Visuals.ShakeRadius
        else
            return
        end
        local Magnitude = (v39.Position - v34).Magnitude
        if v40 <= Magnitude then
            return
        end
        if not v4 then
            v4 = CameraShaker.new(Enum.RenderPriority.Camera.Value + 1, function(v41) -- line 297 | captures: Workspace
                local CurrentCamera = Workspace.CurrentCamera
                if CurrentCamera then
                    CurrentCamera.CFrame *= v41
                end
            end)
            v4:Start()
        end
        local Inactive = CameraShaker.CameraShakeInstance.CameraShakeState.Inactive
        local v42 = #v33
        for v43 = v42, 1, -1 do
            if v33[v43]:GetState() == Inactive then
                table.remove(v33, v43)
            end
        end
        local v44 = #v33
        if not (Visuals.ShakeMaxStack <= v44) then
            local v45 = (1 - Magnitude / v40) ^ 2
            v37(v33, v4:ShakeOnce(v35 * v45, 10, 0.03, Visuals.ShakeFadeOut))
        end
    end

    local function inHell() -- line 319 | captures: HellEventConfig, LocalPlayer
        return LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
    end

    local function myFeet(v46) -- line 328 | captures: HellEventConfig, LocalPlayer
        local Character = LocalPlayer.Character
        local v47
        if Character then
            v47 = Character:FindFirstChild("HumanoidRootPart")
            Character = Character:FindFirstChildOfClass("Humanoid")
        else
            v47 = Character
        end
        if v47 and v47:IsA("BasePart") and Character and Character.Health > 0 and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
            return v47, v47.Position.Y - (Character.HipHeight + v47.Size.Y / 2) - v46
        end
        return nil, 0
    end

    local v48
    local v49 = 0

    local function reportHit(v50, v51, v52) -- line 343 | captures: v48, v49, ReplicatedStorage, HellBossConfig, SpatialSfx, LocalPlayer, Sfx, v13
        local Character = LocalPlayer.Character
        if Character and Character:GetAttribute(HellBossConfig.RespawnImmunity.Attribute) then
            return
        end
        if os.clock() - v49 > 0.3 then
            v49 = os.clock()
            local PlayerHit = Sfx.PlayerHit
            local Track = v13.Track
            local Play = SpatialSfx.Play
            local v53 = PlayerHit.Folder or Sfx.Folder
            local Name = PlayerHit.Name
            local v54 = { Mine = true }
            local Volume = PlayerHit.Volume
            local v55
            if Volume then
                v55 = Volume
            else
                local v56 = SpatialSfx.Find(PlayerHit.Folder or Sfx.Folder, PlayerHit.Name)
                v55 = v56 and v56.Volume
            end
            if v55 then
                v54.Volume = v55 * HellBossConfig.SfxVolume
            else
                v54.Volume = nil
            end
            local v57 = Track(Play(v53, Name, v54))
            local v58, v59
            if v57 then
                if v57.SoundGroup then
                    v59 = true
                else
                    local v60 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                    v58 = v60 and v60.SoundGroup
                    v59 = false
                end
            else
                v59 = true
            end
            if not v59 then
                v57.SoundGroup = v58
            end
        end
        if not (v48 and v48.Parent) then
            local v61 = ReplicatedStorage:FindFirstChild(HellBossConfig.HitRemoteName)
            if v61 then
                if not v61:IsA("RemoteEvent") then
                    v61 = nil
                end
            else
                v61 = nil
            end
            v48 = v61
        end
        if v48 then
            v48:FireServer(v50, v51 or 0, v52)
        end
    end

    local function effects() -- line 367 | captures: v5, Workspace
        if v5 and v5.Parent then
            return v5
        end
        local Folder = Instance.new("Folder")
        Folder.Name = "HellBossFX"
        Folder.Parent = Workspace
        v5 = Folder
        return Folder
    end

    local function billboardParent() -- line 380 | captures: v5, Workspace, LocalPlayer
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not PlayerGui then
            if v5 and v5.Parent then
                return v5
            end
            PlayerGui = Instance.new("Folder")
            PlayerGui.Name = "HellBossFX"
            PlayerGui.Parent = Workspace
            v5 = PlayerGui
        end
        return PlayerGui
    end

    local function clearEffects() -- line 384 | captures: v5
        if v5 then
            v5:ClearAllChildren()
        end
    end

    local function newPart(v62) -- line 390
        local Part = Instance.new("Part")
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        for v63, v64 in v62 do
            Part[v63] = v64
        end
        return Part
    end

    local function discCFrame(v65) -- line 407
        return CFrame.new(v65) * CFrame.Angles(0, 0, 1.5707963267948966)
    end

    local function at(v66, v67, v68, v69, v70) -- line 414 | captures: v3, Workspace
        local v71 = v68 - Workspace:GetServerTimeNow()
        if v71 < -v69 then
            return
        end
        task.delay(math.max(v71, 0), function() -- line 419 | captures: v66, v67, v70, v3
            if not (v3 ~= v66 or v66.AttackId ~= v67 and v66.SideAttackId ~= v67) then
                v70()
            end
        end)
    end

    local function ring(v72, v73, v74, v75, v76, v77, v78) -- line 432 | captures: v5, RunService, Workspace, Visuals, newPart
        local Shockwave = Visuals.Shockwave
        local Segments = Shockwave.Segments
        local Model = Instance.new("Model")
        Model.Name = "Shockwave"
        local v79 = {}
        local v80 = {}
        local v81 = {}
        for v82 = 1, Segments do
            v79[v82] = newPart({
                Size = Vector3.new(1, 1, 1),
                Color = Shockwave.Color,
                Parent = Model
            })
            v80[v82] = newPart({
                Size = Vector3.new(1, 1, 1),
                Color = Shockwave.GlowColor,
                Transparency = Shockwave.GlowTransparency,
                Parent = Model
            })
            local v83 = v79[v82]
            table.insert(v81, v83)
            local v84 = v80[v82]
            table.insert(v81, v84)
        end
        local Folder
        if not (v5 and v5.Parent) then
            Folder = Instance.new("Folder")
            Folder.Name = "HellBossFX"
            Folder.Parent = Workspace
            v5 = Folder
        else
            Folder = v5
        end
        Model.Parent = Folder
        local v85 = {}
        for v86 = 1, Segments do
            local v87 = (v86 - 1) / Segments * 3.141592653589793 * 2
            local v88 = math.cos(v87)
            local v89 = math.sin(v87)
            v85[v86] = Vector3.new(v88, 0, v89)
        end
        local v90 = table.create(Segments * 2)
        local v91 = -1
        local v92
        v92 = RunService.RenderStepped:Connect(function() -- line 454 | captures: v91, v92, v72, v73, v74, v75, v76, v77, v78, Shockwave, Segments, Model, v79, v80, v81, v85, v90, Workspace
            local v93 = v74 + (Workspace:GetServerTimeNow() - v73) * v75
            if v76 <= v93 or not Model.Parent then
                v92:Disconnect()
                Model:Destroy()
            else
                local v94 = math.max(v93, 0.5)
                local v95 = (v94 / v76 - Shockwave.FadeFrom) / (1 - Shockwave.FadeFrom)
                local v96 = math.clamp(v95, 0, 1)
                local v97 = 6.283185307179586 * v94 / Segments * 1.08
                local v98 = Vector3.new(v97, v77, 1.2)
                local v99 = v77 * 0.5
                local v100 = Vector3.new(v97, v99, v78)
                for v101 = 1, Segments do
                    local v102 = v85[v101]
                    local v103 = v72 + v102 * v94
                    local v104 = CFrame.lookAt(v103, v103 + v102)
                    v79[v101].Size = v98
                    v80[v101].Size = v100
                    v90[v101 * 2 - 1] = v104 + Vector3.new(0, 1, 0) * (v77 / 2)
                    v90[v101 * 2] = v104 + Vector3.new(0, 1, 0) * (v77 * 0.25)
                end
                Workspace:BulkMoveTo(v81, v90, Enum.BulkMoveMode.FireCFrameChanged)
                local v105 = v96 - v91
                if math.abs(v105) > 0.02 then
                    v91 = v96
                    for v106 = 1, Segments do
                        v79[v106].Transparency = v96
                        v80[v106].Transparency = Shockwave.GlowTransparency + (1 - Shockwave.GlowTransparency) * v96
                    end
                end
            end
        end)
    end

    local v107 = {}
    local v108

    local function stepIndicators() -- line 511 | captures: v108, Workspace, Visuals, v107
        local Indicator = Visuals.Indicator
        local v109 = Workspace:GetServerTimeNow()
        local v110 = os.clock()
        local v111 = 1
        while v111 <= #v107 do
            local v112 = v107[v111]
            local v113, v114, v115, v116
            if v112.HitAt <= v109 then
                v116 = true
            elseif v112.Model.Parent then
                v113 = v111 + 1
                local v117 = v110 - v112.LastClock
                v112.LastClock = v110
                local v118 = v109 - v112.ShowAt
                local v119 = v112.HitAt - v112.ShowAt
                local v120 = v118 / math.max(v119, 0.01)
                v114 = math.clamp(v120, 0, 1)
                local FlashPhase = v112.FlashPhase
                local Min = Indicator.FlashRate.Min
                local Max = Indicator.FlashRate.Max
                local v121 = v114 * v114
                v112.FlashPhase = FlashPhase + v117 * (Min + (Max - Min) * v121)
                local v122 = v112.FlashPhase * 3.141592653589793 * 2
                v115 = math.cos(v122) * 0.5 + 0.5
                local Min_2 = Indicator.FillTransparency.Min
                local v123 = Min_2 + (Indicator.FillTransparency.Max - Min_2) * v115
                local v124 = v123 - v112.LastFill
                if math.abs(v124) > 0.012 then
                    v112.LastFill = v123
                    v112.Fill.Transparency = v123
                end
                v116 = false
            else
                v116 = true
            end
            if v116 then
                v112.Model:Destroy()
                v107[v111] = v107[#v107]
                v107[#v107] = nil
            else
                local v125 = v115 * 0.55
                local v126 = v125 - v112.LastEdge
                if math.abs(v126) > 0.012 then
                    v112.LastEdge = v125
                    for v127, v128 in v112.Edges do
                        v128.Transparency = v125
                    end
                end
                local Beam = v112.Beam
                if Beam then
                    local v129 = v115 * 0.45 + 0.45
                    local v130 = v129 - v112.LastBeam
                    if math.abs(v130) > 0.012 then
                        v112.LastBeam = v129
                        Beam.Transparency = v129
                    end
                end
                local v131 = v114 * v112.Radius * 2
                local v132 = math.max(v131, 0.1)
                local v133 = v132 - v112.LastSize
                if math.abs(v133) > 0.04 then
                    v112.LastSize = v132
                    v112.Grow.Size = Vector3.new(0.22, v132, v132)
                end
                v111 = v113
            end
        end
        if #v107 == 0 and v108 then
            v108:Disconnect()
            v108 = nil
        end
    end

    local function indicator(v134, v135, v136, v137, v138) -- line 565 | captures: v5, v108, RunService, Workspace, Visuals, newPart, v107, stepIndicators
        local Indicator = Visuals.Indicator
        local Model = Instance.new("Model")
        Model.Name = "DangerCircle"
        local v139 = v134 + Vector3.new(0, 0.11999999731779099, 0)
        local v140 = {
            Shape = Enum.PartType.Cylinder,
            Color = Indicator.Color,
            Transparency = Indicator.FillTransparency.Min
        }
        local v141 = v135 * 2
        local v142 = v135 * 2
        v140.Size = Vector3.new(0.2, v141, v142)
        v140.CFrame = CFrame.new(v139) * CFrame.Angles(0, 0, 1.5707963267948966)
        v140.Parent = Model
        local v143 = newPart(v140)
        local v144 = {
            Size = Vector3.new(0.2199999988079071, 0.10000000149011612, 0.10000000149011612),
            Shape = Enum.PartType.Cylinder,
            Color = Indicator.Color,
            Transparency = Indicator.GrowTransparency
        }
        local v145 = v139 + Vector3.new(0, 0.03999999910593033, 0)
        v144.CFrame = CFrame.new(v145) * CFrame.Angles(0, 0, 1.5707963267948966)
        v144.Parent = Model
        local v146 = newPart(v144)
        local v147 = {}
        local EdgeSegments = Indicator.EdgeSegments
        local v148 = v135 / 50
        local v149 = EdgeSegments * math.min(v148, 1) + 0.5
        local v150 = math.floor(v149)
        local v151 = math.max(12, v150)
        local v152 = 6.283185307179586 * v135 / v151 * 1.1
        for v153 = 1, v151 do
            local v154 = (v153 - 1) / v151 * 3.141592653589793 * 2
            local v155 = math.cos(v154)
            local v156 = math.sin(v154)
            local v157 = Vector3.new(v155, 0, v156)
            local v158 = v139 + v157 * v135 + Vector3.new(0, 0.15000000596046448, 0)
            local v159 = { Color = Indicator.EdgeColor }
            local EdgeWidth = Indicator.EdgeWidth
            v159.Size = Vector3.new(v152, 0.35, EdgeWidth)
            v159.CFrame = CFrame.lookAt(v158, v158 + v157)
            v159.Parent = Model
            v147[v153] = newPart(v159)
        end
        local v160
        if Indicator.BeamHeight > 0 then
            if v138 then
            else
                local v161 = {
                    Transparency = 0.6,
                    Shape = Enum.PartType.Cylinder,
                    Color = Indicator.Color
                }
                local BeamHeight = Indicator.BeamHeight
                v161.Size = Vector3.new(BeamHeight, 1.4, 1.4)
                v161.CFrame = CFrame.new(v139 + Vector3.new(0, 1, 0) * (Indicator.BeamHeight / 2)) * CFrame.Angles(0, 0, 1.5707963267948966)
                v161.Parent = Model
                v160 = newPart(v161)
            end
        end
        local Folder
        if not (v5 and v5.Parent) then
            Folder = Instance.new("Folder")
            Folder.Name = "HellBossFX"
            Folder.Parent = Workspace
            v5 = Folder
        else
            Folder = v5
        end
        Model.Parent = Folder
        local v162 = {
            FlashPhase = 0,
            LastFill = -1,
            LastEdge = -1,
            LastBeam = -1,
            LastSize = -1,
            Model = Model,
            Fill = v143,
            Grow = v146,
            Edges = v147,
            Beam = v160,
            ShowAt = v136,
            HitAt = v137,
            Radius = v135,
            LastClock = os.clock()
        }
        table.insert(v107, v162)
        v108 = v108 or RunService.RenderStepped:Connect(stepIndicators)
    end

    local function onScreen(v163, v164) -- line 635 | captures: Workspace
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera then
            local CFrame = CurrentCamera.CFrame
            if (v163 - CFrame.Position).Magnitude <= v164 * 2 then
                return true
            end
            local v165, v166 = CurrentCamera:WorldToViewportPoint(v163)
            if v166 then
                return true
            end
            local v167, v168 = CurrentCamera:WorldToViewportPoint(v163 + CFrame.LookVector * v164)
            return v168
        end
        return true
    end

    local function findAsset(v169) -- line 656 | captures: ReplicatedStorage
        local v170 = ReplicatedStorage
        for v171, v172 in v169 do
            v170 = v170 and v170:FindFirstChild(v172)
        end
        return v170
    end

    local v173
    local v174

    local function meteorRock() -- line 673 | captures: v173, v174, ReplicatedStorage, Visuals, newPart
        local Meteor = Visuals.Meteor
        local Model = Meteor.Model
        local v175 = ReplicatedStorage
        for v176, v177 in Model do
            v175 = v175 and v175:FindFirstChild(v177)
        end
        if v175 and v175:IsA("Model") and (v173 == nil or v174 ~= v175) then
            local v178 = v175:Clone()
            local v179, v180 = v178:GetBoundingBox()
            local X = v180.X
            local Y = v180.Y
            local Z = v180.Z
            local v181 = math.max(X, Y, Z)
            if v181 > 0 then
                v178:ScaleTo(v178:GetScale() * Meteor.Size / v181)
            end
            v173 = v178
            v174 = v175
        end
        if v175 and v175:IsA("Model") and v173 then
            local v182 = v173:Clone()
            local v183 = v182.PrimaryPart
            for v184, v185 in v182:GetDescendants() do
                if v185:IsA("BasePart") then
                    v185.Anchored = true
                    v185.CanCollide = false
                    v185.CanQuery = false
                    v185.CanTouch = false
                    v185.CastShadow = false
                    v183 = v183 or v185
                end
            end
            if v183 then
                v182.PrimaryPart = v183
                return v182, v183
            end
            v182:Destroy()
        end
        local v186 = newPart({
            Shape = Enum.PartType.Ball,
            Color = Meteor.Color,
            Size = Vector3.new(1, 1, 1) * Meteor.Size
        })
        return v186, v186
    end

    local function meteor(v187, v188) -- line 711 | captures: v5, RunService, Workspace, Visuals, Attacks, Sfx, playSfx, newPart, meteorRock
        local Meteor = Attacks.Meteor
        local Meteor_2 = Visuals.Meteor
        local v189 = math.random() * 3.141592653589793 * 2
        local v190 = math.cos(v189)
        local v191 = math.sin(v189)
        local v192 = v187 + Vector3.new(v190, 0, v191) * (Meteor.FallHeight * 0.35) + Vector3.new(0, 1, 0) * Meteor.FallHeight
        local v193, v194 = meteorRock()
        local v195 = math.random() - 0.5
        local v196 = math.random() - 0.5
        local v197 = math.random() - 0.5
        local v198 = Vector3.new(v195, v196, v197)
        local v199
        if v198.Magnitude > 0.01 then
            v199 = v198.Unit
        else
            v199 = Vector3.new(1, 0, 0)
        end
        local v200 = CFrame.Angles(math.random() * 6.28, math.random() * 6.28, math.random() * 6.28)
        local v201 = newPart({
            Transparency = 1,
            Size = Vector3.new(1, 1, 1),
            CFrame = CFrame.new(v192)
        })
        local Fire = Instance.new("Fire")
        Fire.Size = Meteor_2.Size * 1.1
        Fire.Heat = 20
        Fire.Color = Meteor_2.Color
        Fire.SecondaryColor = Meteor_2.TrailColor
        Fire.Parent = v201
        local PointLight = Instance.new("PointLight")
        PointLight.Color = Meteor_2.Color
        PointLight.Range = 40
        PointLight.Brightness = 4
        PointLight.Parent = v201
        local Attachment = Instance.new("Attachment")
        local v202 = Meteor_2.Size * 0.4
        Attachment.Position = Vector3.new(0, v202, 0)
        Attachment.Parent = v201
        local Attachment_2 = Instance.new("Attachment")
        local v203 = -Meteor_2.Size * 0.4
        Attachment_2.Position = Vector3.new(0, v203, 0)
        Attachment_2.Parent = v201
        local Trail = Instance.new("Trail")
        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment_2
        Trail.Color = ColorSequence.new(Meteor_2.CoreColor, Meteor_2.TrailColor)
        Trail.Transparency = NumberSequence.new(0.1, 1)
        Trail.Lifetime = 0.35
        Trail.LightEmission = 1
        Trail.FaceCamera = true
        Trail.Parent = v201
        local Folder
        if not (v5 and v5.Parent) then
            Folder = Instance.new("Folder")
            Folder.Name = "HellBossFX"
            Folder.Parent = Workspace
            v5 = Folder
        else
            Folder = v5
        end
        v201.Parent = Folder
        local Folder_2
        if not (v5 and v5.Parent) then
            Folder_2 = Instance.new("Folder")
            Folder_2.Name = "HellBossFX"
            Folder_2.Parent = Workspace
            v5 = Folder_2
        else
            Folder_2 = v5
        end
        v193.Parent = Folder_2
        playSfx(Sfx.MeteorFall, v187)
        local v204 = v188 - Meteor.FallTime

        local function moveTo(v205) -- line 754 | captures: v199, v187, Meteor_2, v192, v193, v194, v200, v201, v204, Workspace
            local v206 = v192:Lerp(v187, (math.clamp(v205, 0, 1)))
            v201.CFrame = CFrame.lookAt(v206, v187)
            local v207 = CFrame.fromAxisAngle(v199, (Workspace:GetServerTimeNow() - v204) * Meteor_2.Spin)
            local v208 = CFrame.new(v206) * v207 * v200
            if v193:IsA("Model") then
                v193:SetPrimaryPartCFrame(v208)
            else
                v194.CFrame = v208
            end
        end

        local v209 = Workspace:GetServerTimeNow() - v204
        moveTo(math.max(v209, 0) / Meteor.FallTime)
        local v210
        v210 = RunService.RenderStepped:Connect(function() -- line 767 | captures: v210, Meteor, v193, v201, v204, moveTo, Workspace
            local v211 = (Workspace:GetServerTimeNow() - v204) / Meteor.FallTime
            if v211 >= 1 or not v201.Parent then
                v210:Disconnect()
                v201:Destroy()
                v193:Destroy()
            else
                moveTo(v211)
            end
        end)
    end

    local Dialogue = HellBossConfig.Dialogue
    local ScreenGui
    local v212
    local v213
    local v214 = {}
    local v215 = 0
    local v216 = 0
    local v217 = (-1/0)
    local v218 = (-1/0)
    local v219 = {}
    local v220
    local v221
    local v222
    local v223
    local v224
    local v225 = 0
    local v226 = 0
    local v227
    local v228

    local function dialogueTemplate() -- line 812 | captures: StarterGui, Dialogue
        local v229 = StarterGui:FindFirstChild(Dialogue.Gui)
        local v230 = v229 and v229:FindFirstChild(Dialogue.Frame)
        if v230 and v230:IsA("GuiObject") then
            return v230
        end
        return nil
    end

    local v231 = {}
    local v232
    local v233 = 0
    local v234 = 0

    local function boxRect(v235) -- line 845
        local AbsolutePosition = v235.AbsolutePosition
        local AbsoluteSize = v235.AbsoluteSize
        local v236 = AbsolutePosition.X + AbsoluteSize.X / 2
        local v237 = AbsolutePosition.Y + AbsoluteSize.Y / 2
        local X = AbsoluteSize.X
        local v238 = math.abs(X) / 2
        local Y = AbsoluteSize.Y
        local v239 = math.abs(Y) / 2
        local Rotation = v235.Rotation
        local v240 = math.rad(Rotation)
        if v240 ~= 0 then
            local v241 = math.cos(v240)
            local v242 = math.abs(v241)
            local v243 = math.sin(v240)
            local v244 = math.abs(v243)
            v238, v239 = v238 * v242 + v239 * v244, v238 * v244 + v239 * v242
        end
        return {
            L = v236 - v238,
            T = v237 - v239,
            R = v236 + v238,
            B = v237 + v239
        }
    end

    local function textRect(v245) -- line 859
        local AbsolutePosition = v245.AbsolutePosition
        local AbsoluteSize = v245.AbsoluteSize
        local TextBounds = v245.TextBounds
        local v246 = AbsolutePosition.X + (AbsoluteSize.X - TextBounds.X) / 2
        if v245.TextXAlignment == Enum.TextXAlignment.Left then
            v246 = AbsolutePosition.X
        elseif v245.TextXAlignment == Enum.TextXAlignment.Right then
            v246 = AbsolutePosition.X + AbsoluteSize.X - TextBounds.X
        end
        local v247 = AbsolutePosition.Y + (AbsoluteSize.Y - TextBounds.Y) / 2
        if v245.TextYAlignment == Enum.TextYAlignment.Top then
            v247 = AbsolutePosition.Y
        elseif v245.TextYAlignment == Enum.TextYAlignment.Bottom then
            v247 = AbsolutePosition.Y + AbsoluteSize.Y - TextBounds.Y
        end
        return {
            L = v246,
            T = v247,
            R = v246 + TextBounds.X,
            B = v247 + TextBounds.Y
        }
    end

    local function clipRect(v248, v249) -- line 877
        if v249 then
            local v250 = {}
            local L = v248.L
            local L_2 = v249.L
            v250.L = math.max(L, L_2)
            local T = v248.T
            local T_2 = v249.T
            v250.T = math.max(T, T_2)
            local R = v248.R
            local R_2 = v249.R
            v250.R = math.min(R, R_2)
            local B = v248.B
            local B_2 = v249.B
            v250.B = math.min(B, B_2)
            local R_3 = v250.R
            local v251 = v250.L < R_3
            local v252
            if v251 then
                local B = v250.B
                v252 = v250.T < B
            end
            if not v251 or not v252 then
                return nil
            end
            return v250
        end
        return v248
    end

    local collectDrawn

    local function collectDrawn_2(v253, v254, v255) -- line 893 | captures: boxRect, textRect, clipRect, collectDrawn
        if not v253.Visible then
            return
        end

        local function add(v256) -- line 897 | captures: v254, v255, clipRect
            local v257 = clipRect(v256, v255)
            if v257 then
                table.insert(v254, v257)
            end
        end

        if v253.BackgroundTransparency < 1 then
            local v258 = boxRect(v253)
            local v259 = clipRect(v258, v255)
            if v259 then
                table.insert(v254, v259)
            end
        end
        if not v253:IsA("TextLabel") and not v253:IsA("TextButton") and not v253:IsA("TextBox") then
            if (v253:IsA("ImageLabel") or v253:IsA("ImageButton")) and v253.ImageTransparency < 1 and v253.Image ~= "" then
                local v260 = boxRect(v253)
                local v261 = clipRect(v260, v255)
                if v261 then
                    table.insert(v254, v261)
                end
            end
        elseif v253.TextTransparency < 1 and v253.ContentText ~= "" then
            local v262 = textRect(v253)
            local v263 = clipRect(v262, v255)
            if v263 then
                table.insert(v254, v263)
            end
        end
        local v264
        if v253:IsA("CanvasGroup") or v253.ClipsDescendants then
            v264 = clipRect(boxRect(v253), v255)
            if not v264 then
                return
            end
        else
            v264 = v255
        end
        for v265, v266 in v253:GetChildren() do
            if v266:IsA("GuiObject") then
                collectDrawn(v266, v254, v264)
            end
        end
    end

    collectDrawn = collectDrawn_2

    local function onScreen_2(v267) -- line 933
        local v268 = v267
        while true do
            if v268 then
                if not v268:IsA("GuiObject") or v268.Visible then
                    if v268:IsA("LayerCollector") then
                        return v268.Enabled
                    end
                    v268 = v268.Parent
                    continue
                end
                break
            end
            return false
        end
        return false
    end

    local function resolvePath(v269, v270) -- line 946
        local v271 = v269
        for v272, v273 in v270 do
            v271 = v271 and v271:FindFirstChild(v273)
        end
        if not (v271 and v271:IsA("GuiObject")) then
            return nil
        end
        return v271
    end

    local v274

    local function stillCopy(v275) -- line 962
        local v276 = v275:Clone()
        for v277, v278 in v276:GetDescendants() do
            if v278:IsA("LuaSourceContainer") then
                v278:Destroy()
            elseif v278:IsA("UIScale") then
                v278.Scale = 1
            end
        end
        return v276
    end

    local function restingBar(v279, v280) -- line 974 | captures: ScreenGui, v274, StarterGui, Dialogue, resolvePath, stillCopy
        local ScreenGui_2 = ScreenGui
        if ScreenGui_2 then
            if not (v274 and v274.Parent == ScreenGui_2) then
                local v281 = resolvePath(StarterGui:FindFirstChild(Dialogue.Gui), v279.Path)
                if v281 and v281.Parent and v281.Parent:IsA("LayerCollector") then
                    local v282 = stillCopy(v281)
                    for v283, v284 in v282:GetChildren() do
                        if v284:IsA("GuiObject") and not table.find(v279.Parts, v284.Name) then
                            v284:Destroy()
                        end
                    end
                    v282.Name = "BossBarRestProbe"
                    v282.Visible = false
                    v282.Parent = ScreenGui_2
                    v274 = v282
                else
                    return nil
                end
            end
            local v285 = v274
            for v286, v287 in v279.Parts do
                local v288 = v280:FindFirstChild(v287)
                if v288 and v288:IsA("GuiObject") and not v285:FindFirstChild(v287) then
                    stillCopy(v288).Parent = v285
                end
            end
            return v285
        end
        return nil
    end

    local function bossBarRects() -- line 1009 | captures: StarterGui, LocalPlayer, Dialogue, collectDrawn_2, onScreen_2, resolvePath, restingBar
        local v289 = {}
        local DropBelow = Dialogue.DropBelow
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v290
        if DropBelow then
            local v291 = PlayerGui and PlayerGui:FindFirstChild(Dialogue.Gui)
            v290 = resolvePath(v291, DropBelow.Path)
        else
            v290 = DropBelow
        end
        if DropBelow and v290 and onScreen_2(v290) then
            local v292 = restingBar(DropBelow, v290)
            if v292 then
                for v293, v294 in DropBelow.Parts do
                    local v295 = v290:FindFirstChild(v294)
                    local v296 = v292:FindFirstChild(v294)
                    if v295 and v295:IsA("GuiObject") and v296 and v296:IsA("GuiObject") then
                        v296.Visible = v295.Visible
                        if v295:IsA("TextLabel") and v296:IsA("TextLabel") then
                            v296.Text = v295.Text
                        end
                        collectDrawn_2(v296, v289)
                    end
                end
            else
                local v297 = resolvePath(StarterGui:FindFirstChild(Dialogue.Gui), DropBelow.Path)
                local Parent = v290.Parent
                local v298, v299
                if v297 and Parent and Parent:IsA("GuiBase2d") then
                    local Position = v297.Position
                    local AbsoluteSize = v290.AbsoluteSize
                    local v300 = Parent.AbsolutePosition.X + Position.X.Scale * Parent.AbsoluteSize.X + Position.X.Offset - v290.AnchorPoint.X * AbsoluteSize.X
                    local v301 = Parent.AbsolutePosition.Y + Position.Y.Scale * Parent.AbsoluteSize.Y + Position.Y.Offset - v290.AnchorPoint.Y * AbsoluteSize.Y
                    v298, v299 = v300 - v290.AbsolutePosition.X, v301 - v290.AbsolutePosition.Y
                else
                    v298 = 0
                    v299 = 0
                end
                for v302, v303 in DropBelow.Parts do
                    local v304 = v290:FindFirstChild(v303)
                    if v304 and v304:IsA("GuiObject") then
                        collectDrawn_2(v304, v289)
                    end
                end
                for v305, v306 in v289 do
                    v306.L += v298
                    v306.R += v298
                    v306.T += v299
                    v306.B += v299
                end
            end
            return v289
        end
        return v289
    end

    local function dialogueRects() -- line 1060 | captures: v221, v222, v233, v214, collectDrawn_2
        local v307 = {}
        for v308, v309 in v214 do
            if not v309.Gone then
                local v310 = {
                    Frame = v309.Frame,
                    Scale = v309.Scale
                }
                table.insert(v307, v310)
            end
        end
        if v221 and v222 then
            local v311 = {
                Frame = v221,
                Scale = v222
            }
            table.insert(v307, v311)
        end
        local v312 = {}
        local v313 = false
        for v314, v315 in v307 do
            local Scale = v315.Scale.Scale
            if not (Scale < 0.98) and v315.Frame.Parent then
                local v316 = #v312 + 1
                collectDrawn_2(v315.Frame, v312)
                local AbsolutePosition = v315.Frame.AbsolutePosition
                local AbsoluteSize = v315.Frame.AbsoluteSize
                local v317 = AbsolutePosition.X + AbsoluteSize.X / 2
                local v318 = AbsolutePosition.Y + AbsoluteSize.Y / 2
                local v319 = #v312
                v313 = true
                for v320 = v316, v319 do
                    local v321 = v312[v320]
                    v321.L = v317 + (v321.L - v317) / Scale
                    v321.R = v317 + (v321.R - v317) / Scale
                    v321.T = v318 + (v321.T - v318) / Scale - v233
                    v321.B = v318 + (v321.B - v318) / Scale - v233
                    v313 = true
                end
            end
        end
        if v313 then
            return v312
        end
        return nil
    end

    local function measureDialogueDrop() -- line 1096 | captures: Dialogue, bossBarRects, dialogueRects
        local v322 = dialogueRects()
        if v322 then
            local v323 = bossBarRects()
            local v324 = Dialogue.BelowGap or 0
            local v325 = 0
            for v326, v327 in v322 do
                local v328 = v325
                for v329, v330 in v323 do
                    local R = v327.R
                    if v330.L < R and v327.L < v330.R then
                        local v331 = v330.B + v324 - v327.T
                        v328 = math.max(v328, v331)
                    end
                    v325 = v328
                end
            end
            return (math.ceil(v325))
        end
        return nil
    end

    local function applyDialogueDrop() -- line 1114 | captures: v212, v232, v233
        local v332 = v212
        local v333 = v232
        if not (v332 and v333) then
            return
        end
        local fromOffset = UDim2.fromOffset
        local v334 = v233
        v332.Position = v333 + fromOffset(0, (math.round(v334)))
    end

    local function placeDialogue(v335) -- line 1122 | captures: v212, v232, v233, v234, measureDialogueDrop
        local v336 = measureDialogueDrop()
        if v336 then
            v234 = v336
        end
        if not v335 then
            return
        end
        v233 = v234
        local v337 = v212
        local v338 = v232
        if not (v337 and v338) then
            return
        end
        local fromOffset = UDim2.fromOffset
        local v339 = v233
        v337.Position = v338 + fromOffset(0, (math.round(v339)))
    end

    local function stepDialogueDrop(v340) -- line 1135 | captures: ScreenGui, v212, v232, v233, v234, measureDialogueDrop
        local ScreenGui_2 = ScreenGui
        if ScreenGui_2 and ScreenGui_2.Enabled and v212 then
            local v341 = measureDialogueDrop()
            if v341 then
                v234 = v341
            end
        else
            return
        end
        local v342 = v234 - v233
        if math.abs(v342) < 0.5 then
            if v233 ~= v234 then
                v233 = v234
                local v343 = v212
                local v344 = v232
                if v343 and v344 then
                    local fromOffset = UDim2.fromOffset
                    local v345 = v233
                    v343.Position = v344 + fromOffset(0, (math.round(v345)))
                end
            end
        else
            local v346 = v233
            local v347 = v340 * -14
            v233 = v346 + v342 * (1 - math.exp(v347))
            local v348 = v212
            local v349 = v232
            if v348 and v349 then
                local fromOffset = UDim2.fromOffset
                local v350 = v233
                v348.Position = v349 + fromOffset(0, (math.round(v350)))
            end
        end
    end

    function v231.Reset(v351) -- line 1154 | captures: v232, v233, v234
        v232 = v351
        v233 = 0
        v234 = 0
    end

    v231.Place = placeDialogue
    v231.Step = stepDialogueDrop

    local function ensureDialogue() -- line 1165 | captures: ScreenGui, v212, v213, v220, v221, v222, v223, v227, RunService, StarterGui, LocalPlayer, Dialogue, v214, v231
        if ScreenGui and ScreenGui.Parent and v213 then
            return true
        end
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local v352 = StarterGui:FindFirstChild(Dialogue.Gui)
        local v353 = v352 and v352:FindFirstChild(Dialogue.Frame)
        if not (v353 and v353:IsA("GuiObject")) then
            v353 = nil
        end
        local ScreenGui_2
        if PlayerGui and v353 then
            local ScreenGui = v353:FindFirstAncestorWhichIsA("ScreenGui")
            ScreenGui_2 = Instance.new("ScreenGui")
            ScreenGui_2.Name = "HellBossDialogue"
            ScreenGui_2.ResetOnSpawn = false
            ScreenGui_2.DisplayOrder = Dialogue.DisplayOrder
            ScreenGui_2.Enabled = false
            if ScreenGui then
                ScreenGui_2.IgnoreGuiInset = ScreenGui.IgnoreGuiInset
                ScreenGui_2.ScreenInsets = ScreenGui.ScreenInsets
                ScreenGui_2.ZIndexBehavior = ScreenGui.ZIndexBehavior
            end
        else
            return false
        end
        local v354 = v353:Clone()
        v354.Visible = true
        local v355 = v354:FindFirstChild(Dialogue.LineName)
        if v355 and v355:IsA("GuiObject") then
            v355.Parent = nil
            local v356 = v354:FindFirstChild(Dialogue.TaskName)
            if v356 and v356:IsA("GuiObject") then
                v356.Parent = nil
                v220 = v356
            else
                warn((("[HellBossController] MainGUI.%*.%* (the task row) not found"):format(Dialogue.Frame, Dialogue.TaskName)))
                v220 = nil
            end
            v221 = nil
            v222 = nil
            v354.Parent = ScreenGui_2
            ScreenGui_2.Parent = PlayerGui
            ScreenGui = ScreenGui_2
            v212 = v354
            v231.Reset(v354.Position)
            local v357 = RunService.RenderStepped:Connect(v231.Step)
            ScreenGui_2.Destroying:Once(function() -- line 1212 | captures: v357
                v357:Disconnect()
            end)
            v213 = v355
            table.clear(v214)
            if v223 then
                v227()
            end
            return true
        end
        warn((("[HellBossController] MainGUI.%*.%* (one dialogue line) not found"):format(Dialogue.Frame, Dialogue.LineName)))
        v354:Destroy()
        ScreenGui_2:Destroy()
        return false
    end

    local function syncDialogueGui() -- line 1224 | captures: ScreenGui, v221, v226, v214
        if not ScreenGui then
            return
        end
        local ScreenGui_2 = ScreenGui
        if #v214 > 0 then
            ScreenGui_2.Enabled = true
        elseif v221 == nil then
            ScreenGui_2.Enabled = v226 > 0
        else
            ScreenGui_2.Enabled = true
        end
    end

    local function retireTask() -- line 1231 | captures: ScreenGui, v221, v222, v226, TweenService, Dialogue, v214
        local v358 = v221
        local v359 = v222
        if not (v358 and v359) then
            return
        end
        v221 = nil
        v222 = nil
        v226 += 1
        TweenService:Create(v359, TweenInfo.new(Dialogue.PopTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0 }):Play()
        task.delay(Dialogue.PopTime, function() -- line 1237 | captures: v358, ScreenGui, v221, v226, v214
            v358:Destroy()
            v226 -= 1
            if not ScreenGui then
                return
            end
            local ScreenGui_2 = ScreenGui
            if #v214 > 0 then
                ScreenGui_2.Enabled = true
            elseif v221 == nil then
                ScreenGui_2.Enabled = v226 > 0
            else
                ScreenGui_2.Enabled = true
            end
        end)
    end

    function v227() -- line 1247 | captures: v212, v220, v221, v222, v223, TweenService, Dialogue, retireTask
        if v223 then
            if not (v221 and v221.Parent) then
                local v360, v361
                if v220 and v212 then
                    v360 = v220:Clone()
                    v360.LayoutOrder = 1073741824
                    v360.Visible = true
                    v361 = v360:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
                else
                    return
                end
                v361.Scale = 0
                v361.Parent = v360
                v360.Parent = v212
                v221 = v360
                v222 = v361
                TweenService:Create(v361, TweenInfo.new(Dialogue.PopTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            end
            local v362 = v221:FindFirstChild(Dialogue.TaskTextName, true)
            if v362 and v362:IsA("TextLabel") then
                v362.Text = v223
                local Inner = v362:FindFirstChild("Inner")
                if Inner and Inner:IsA("TextLabel") then
                    Inner.Text = v223
                end
            end
        else
            retireTask()
        end
    end

    local function popOut(v363) -- line 1277 | captures: ScreenGui, v216, v218, v221, v226, v228, TweenService, Dialogue, v214, v219
        if v363.Gone then
            return
        end
        v363.Gone = true
        local v364 = table.find(v214, v363)
        if v364 then
            table.remove(v214, v364)
        end
        TweenService:Create(v363.Scale, TweenInfo.new(Dialogue.PopTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0 }):Play()
        task.delay(Dialogue.PopTime, function() -- line 1287 | captures: v363, ScreenGui, v216, v218, v221, v226, v228, Dialogue, v214, v219
            v363.Frame:Destroy()
            if #v214 ~= 0 then
                return
            end
            v218 = os.clock()
            if ScreenGui then
                local ScreenGui_2 = ScreenGui
                if #v214 > 0 then
                    ScreenGui_2.Enabled = true
                elseif v221 == nil then
                    ScreenGui_2.Enabled = v226 > 0
                else
                    ScreenGui_2.Enabled = true
                end
            end
            if #v219 > 0 then
                local v365 = v216
                task.delay(Dialogue.QueueGap, function() -- line 1295 | captures: v365, v216, v228, v214, v219
                    if v216 == v365 and #v214 == 0 and #v219 > 0 then
                        v228(table.remove(v219, 1))
                    end
                end)
            end
        end)
    end

    local function say(v366, v367) -- line 1308 | captures: ScreenGui, v212, v213, v215, v216, v217, SoundService, Debris, TweenService, HellEventConfig, SpatialSfx, LocalPlayer, Sfx, v13, Dialogue, v214, v231, ensureDialogue, popOut
        if not (v366 and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and ensureDialogue()) then
            return
        end
        local Voice = Dialogue.Voice
        if Voice then
            if v367 then
                if not Voice.Silent[v367] and #Voice.Sounds > 0 then
                    local PlaybackSpeed = Voice.PlaybackSpeed
                    local Track = v13.Track
                    local Play = SpatialSfx.Play
                    local Folder = Voice.Folder
                    local v368 = Voice.Sounds[math.random(1, #Voice.Sounds)]
                    local v369 = { Mine = true }
                    v369.Volume = Voice.Volume
                    v369.PlaybackSpeed = PlaybackSpeed.Min + math.random() * (PlaybackSpeed.Max - PlaybackSpeed.Min)
                    local v370 = Track(Play(Folder, v368, v369))
                    if v370 and not v370.SoundGroup then
                        local v371 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                        v370.SoundGroup = v371 and v371.SoundGroup
                    end
                end
            elseif #Voice.Sounds > 0 then
                local PlaybackSpeed = Voice.PlaybackSpeed
                local Track = v13.Track
                local Play = SpatialSfx.Play
                local Folder = Voice.Folder
                local v372 = Voice.Sounds[math.random(1, #Voice.Sounds)]
                local v373 = { Mine = true }
                v373.Volume = Voice.Volume
                v373.PlaybackSpeed = PlaybackSpeed.Min + math.random() * (PlaybackSpeed.Max - PlaybackSpeed.Min)
                local v374 = Track(Play(Folder, v372, v373))
                if v374 and not v374.SoundGroup then
                    local v375 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                    v374.SoundGroup = v375 and v375.SoundGroup
                end
            end
        end
        local ScreenGui_2 = ScreenGui
        local v376 = v212
        v217 = os.clock()
        local v377 = v216
        while true do
            local v378 = #v214
            if Dialogue.MaxLines <= v378 then
                popOut(v214[1])
                continue
            end
            break
        end
        local v379 = v213:Clone()
        v215 += 1
        v379.LayoutOrder = v215
        v379.Visible = true
        local v380 = v379:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        v380.Scale = 0
        v380.Parent = v379
        local v381 = v379:FindFirstChild(Dialogue.TextName, true)
        if v381 and v381:IsA("TextLabel") then
            local v382 = { v381 }
            local Inner = v381:FindFirstChild("Inner")
            if Inner and Inner:IsA("TextLabel") then
                table.insert(v382, Inner)
            end
            local v383 = Dialogue.SpeakerName and v379:FindFirstChild(Dialogue.SpeakerName, true)
            local v384
            if v383 ~= nil and v383:IsA("TextLabel") then
                for v385, v386 in {
                        v383,
                        v383:FindFirstChild("Inner")
                    } do
                    if v386 and v386:IsA("TextLabel") then
                        v386.Text = ("%*:"):format(Dialogue.Speaker)
                    end
                end
                v384 = ""
            else
                v384 = string.format(Dialogue.Format, Dialogue.Speaker, "")
            end

            local function setShown(v387) -- line 1361 | captures: v382
                for v388, v389 in v382 do
                    v389.MaxVisibleGraphemes = v387
                end
            end

            for v390, v391 in v382 do
                v391.Text = v384 .. v366
            end
            local v392 = utf8.len(v384) or #v384
            local v393 = utf8.len(v381.ContentText) or #v381.ContentText
            for v394, v395 in v382 do
                v395.MaxVisibleGraphemes = v392
            end
            v379.Parent = v376
            local v396 = not ScreenGui_2.Enabled
            ScreenGui_2.Enabled = true
            TweenService:Create(v380, TweenInfo.new(Dialogue.PopTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            local v397 = (v393 - v392) / Dialogue.CharsPerSecond + Dialogue.Hold + (v393 - v392) * Dialogue.HoldPerChar
            local v398 = {
                Gone = false,
                Frame = v379,
                Scale = v380,
                ExpiresAt = os.clock() + v397 + 3
            }
            table.insert(v214, v398)
            if v396 then
                local Scale = v380.Scale
                v380.Scale = 1
                v231.Place(true)
                v380.Scale = Scale
            end
            local TypeSound = Dialogue.TypeSound
            local v399 = TypeSound and SoundService:FindFirstChild(TypeSound.Folder)
            local v400 = v399 and v399:FindFirstChild(TypeSound.Name)

            local function tick() -- line 1395 | captures: TypeSound, v399, v400, Debris
                if not (v400 and v400:IsA("Sound")) then
                    return
                end
                local v401 = v400:Clone()
                v401.Volume = TypeSound.Volume
                v401.Parent = v399
                v401:Play()
                local TimeLength = v401.TimeLength
                Debris:AddItem(v401, math.max(TimeLength, 0.3) + 0.2)
            end

            local function live() -- line 1404 | captures: v377, v398, v216
                return not v398.Gone and v216 == v377
            end

            task.spawn(function() -- line 1407 | captures: v377, v382, v398, TypeSound, v399, v400, v393, v392, v216, Debris, Dialogue, popOut
                local v402, v403 = xpcall(function() -- line 1411 | captures: v377, v382, v398, TypeSound, v399, v400, v393, v392, v216, Debris, Dialogue
                    local v404 = os.clock()
                    local v405 = v392
                    while not v398.Gone and v216 == v377 do
                        local v406 = (os.clock() - v404) * Dialogue.CharsPerSecond
                        local v407 = v392 + math.floor(v406)
                        if v393 <= v407 then
                            break
                        end
                        for v408, v409 in v382 do
                            v409.MaxVisibleGraphemes = v407
                        end
                        if TypeSound then
                            local v410 = v407 - v405
                            if TypeSound.Every <= v410 then
                                if v400 and v400:IsA("Sound") then
                                    local v411 = v400:Clone()
                                    v411.Volume = TypeSound.Volume
                                    v411.Parent = v399
                                    v411:Play()
                                    local TimeLength = v411.TimeLength
                                    Debris:AddItem(v411, math.max(TimeLength, 0.3) + 0.2)
                                end
                                v405 = v407
                            end
                        end
                        task.wait()
                    end
                    if not v398.Gone and v216 == v377 then
                        for v412, v413 in v382 do
                            v413.MaxVisibleGraphemes = -1
                        end
                        task.wait(Dialogue.Hold + (v393 - v392) * Dialogue.HoldPerChar)
                    end
                end, debug.traceback)
                if not v402 then
                    warn((("[HellBossController] dialogue line failed: %*"):format(v403)))
                end
                if not v398.Gone and v216 == v377 then
                    popOut(v398)
                end
            end)
        else
            v379:Destroy()
        end
    end

    local function clearStuckLines() -- line 1444 | captures: v214, popOut
        local v414 = os.clock()
        for v415, v416 in table.clone(v214) do
            if v416.ExpiresAt < v414 or not v416.Frame.Parent then
                warn("[HellBossController] a dialogue line got stuck on screen \226\128\148 cleared it")
                popOut(v416)
            end
        end
    end

    local v417 = {}
    local v418 = {}

    local function nextLine(v419, v420) -- line 1459 | captures: v417, v418
        local v421 = v418[v419]
        if not v421 or #v421 == 0 then
            v421 = table.clone(v420)
            local v422 = #v421
            for v423 = v422, 2, -1 do
                local v424 = math.random(1, v423)
                local v425 = v421[v424]
                local v426 = v421[v423]
                v421[v423] = v425
                v421[v424] = v426
            end
            if #v421 > 1 and v421[#v421] == v417[v419] then
                local v427 = #v421
                local v428 = v421[1]
                local v429 = v421[#v421]
                v421[v427] = v428
                v421[1] = v429
            end
            v418[v419] = v421
        end
        local v430 = table.remove(v421)
        v417[v419] = v430
        return v430
    end

    function v228(v431, v432, v433) -- line 1482 | captures: v217, v218, Dialogue, v214, v219, popOut, say, clearStuckLines, nextLine
        local v434 = Dialogue.Lines[v431]
        if not v434 or v432 and v432 < math.random() then
            return
        end
        if v433 and os.clock() - v217 < (Dialogue.MinGap or 0) then
            return
        end
        clearStuckLines()
        local v435 = #v214 > 0
        if Dialogue.Interrupt[v431] then
            for v436, v437 in table.clone(v214) do
                popOut(v437)
            end
            table.clear(v219)
        elseif Dialogue.Important[v431] then
            if v435 then
                if #v219 < Dialogue.QueueMax and not table.find(v219, v431) then
                    table.insert(v219, v431)
                end
                return
            end
        elseif v435 or os.clock() - v218 < Dialogue.QuietGap then
            return
        end
        if not (type(v434) == "table" and #v434 > 1) then
            if type(v434) == "string" then
                say(v434, v431)
            elseif #v434 > 0 then
                say(v434[math.random(1, #v434)], v431)
            end
        else
            say(nextLine(v431, v434), v431)
        end
    end

    local function hushDialogue() -- line 1520 | captures: ScreenGui, v216, v221, v226, v214, v219
        v216 += 1
        table.clear(v219)
        for v438, v439 in v214 do
            v439.Gone = true
            v439.Frame:Destroy()
        end
        table.clear(v214)
        if not ScreenGui then
            return
        end
        local ScreenGui_2 = ScreenGui
        if #v214 > 0 then
            ScreenGui_2.Enabled = true
        elseif v221 == nil then
            ScreenGui_2.Enabled = v226 > 0
        else
            ScreenGui_2.Enabled = true
        end
    end

    local function playClip(v440, v441, v442, v443) -- line 1538 | captures: Workspace, HellBossConfig
        local v444 = HellBossConfig.Moves[v441]
        if v444 then
            v440.Tracks:Play(v444, Workspace:GetServerTimeNow() - math.max(v442, 0))
        else
            v440.Tracks:Stop()
        end
    end

    local function releaseClip(v445, v446) -- line 1547
        v445.Tracks:Stop(v446)
    end

    local v447 = {}

    function v447.Find(v448, v449) -- line 1553 | captures: HellBossConfig
        local v450 = v448.Bones[v449]
        if v450 and v450.Parent then
            return v450
        end
        local v451 = HellBossConfig.Rig.Bones[v449] or v449
        local v452 = v448.Model:FindFirstChild(v451, true)
        if not v452 or not v452:IsA("Bone") and not v452:IsA("BasePart") then
            return nil
        end
        v448.Bones[v449] = v452
        return v452
    end

    function v447.Position(v453, v454) -- line 1567 | captures: v447
        local v455 = v447.Find(v453, v454)
        if v455 and v455:IsA("Bone") then
            return v455.WorldPosition
        end
        if not (v455 and v455:IsA("BasePart")) then
            return nil
        end
        return v455.Position
    end

    local function steadyRoot(v456) -- line 1579
        local RootJoint = v456.RootJoint
        if not (RootJoint and RootJoint.Parent) then
            local v457 = os.clock()
            if v457 - v456.RootJointMissedAt < 1 then
                return
            end
            RootJoint = nil
            for v458, v459 in v456.Model:GetDescendants() do
                if v459.Name == "Root" and (v459:IsA("Motor6D") or v459:IsA("AnimationConstraint")) then
                    RootJoint = v459
                    break
                end
                RootJoint = nil
            end
            v456.RootJoint = RootJoint
            if not RootJoint then
                v456.RootJointMissedAt = v457
            end
        end
        if RootJoint then
            local Transform = RootJoint.Transform
            if Transform.Position ~= Vector3.new(0, 0, 0) then
                RootJoint.Transform = Transform.Rotation
            end
        end
    end

    local function groundY(v460) -- line 1619
        return v460.FloorY + v460.HipOffset
    end

    local function grounded(v461, v462) -- line 1623
        return CFrame.new(v462.X, v461.FloorY + v461.HipOffset, v462.Z) * v462.Rotation
    end

    local function turning(v463, v464, v465) -- line 1627
        local v466 = v465 / 0.35
        local v467 = math.clamp(v466, 0, 1)
        local v468 = v467 * v467 * (3 - v467 * 2)
        local v469 = CFrame.new(v464.From.Position) * v463.TurnFrom.Rotation:Lerp(v464.From.Rotation, v468)
        return CFrame.new(v469.X, v463.FloorY + v463.HipOffset, v469.Z) * v469.Rotation
    end

    local function slamCFrame(v470, v471, v472) -- line 1632 | captures: Attacks
        local Slam = Attacks.Slam
        local v473 = v470.FloorY + v470.HipOffset
        local X = v471.From.X
        local Z = v471.From.Z
        local v474 = Vector3.new(X, v473, Z)
        local X_2 = v471.To.X
        local Z_2 = v471.To.Z
        local v475 = Vector3.new(X_2, v473, Z_2)
        local v476 = v474 + Vector3.new(0, 1, 0) * Slam.Height
        local v477 = v475 + Vector3.new(0, 1, 0) * Slam.Height
        local Crouch = Slam.Crouch
        local v478 = Crouch + Slam.Rise
        local v479 = v478 + Slam.Aim
        local v480 = v479 + Slam.Fall
        if v472 < Crouch then
            local v481 = v472 / 0.35
            local v482 = math.clamp(v481, 0, 1)
            local v483 = v482 * v482 * (3 - v482 * 2)
            local v484 = CFrame.new(v471.From.Position) * v470.TurnFrom.Rotation:Lerp(v471.From.Rotation, v483)
            return CFrame.new(v484.X, v470.FloorY + v470.HipOffset, v484.Z) * v484.Rotation
        end
        if v472 < v478 then
            local v485 = (v472 - Crouch) / Slam.Rise
            local v486 = 1 - (1 - v485) * (1 - v485)
            return CFrame.new(v474:Lerp(v476, v486)) * v471.From.Rotation
        end
        if v472 < v479 then
            local v487 = (v472 - v478) / Slam.Aim
            local v488 = math.clamp(v487, 0, 1)
            local v489 = v488 * v488 * (3 - v488 * 2)
            return CFrame.new(v476:Lerp(v477, v489)) * v471.From.Rotation:Lerp(v471.To.Rotation, v489)
        end
        if v472 < v480 then
            local v490 = (v472 - v479) / Slam.Fall
            return CFrame.new(v477:Lerp(v475, v490 * v490)) * v471.To.Rotation
        end
        return CFrame.new(v475) * v471.To.Rotation
    end

    local function currentMove(v491, v492) -- line 1660
        local NextMove = v491.NextMove
        if NextMove and NextMove.Start <= v492 then
            v491.Move = NextMove
            v491.NextMove = nil
        end
        return v491.Move
    end

    local function isAttacking(v493, v494) -- line 1669
        local Attack = v493.Attack
        if Attack == nil then
            return false
        end
        return v494 < Attack.Start + Attack.Length
    end

    local Defeat = HellBossConfig.Defeat

    local function defeatBasis(v495) -- line 1686
        local LookVector = v495.Rest.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v496 = Vector3.new(X, 0, Z)
        local v497
        if v496.Magnitude > 0.001 then
            v497 = v496.Unit
        else
            v497 = Vector3.new(0, 0, -1)
        end
        local X_2 = v495.Rest.X
        local FloorY = v495.FloorY
        local Z_2 = v495.Rest.Z
        local v498 = Vector3.new(X_2, FloorY, Z_2)
        return v498, v497, v498 - v497 * (v495.Height * 0.5)
    end

    local function defeatCFrame(v499, v500) -- line 1695 | captures: Defeat
        if v500 < Defeat.StaggerTime then
            local Rest = v499.Rest
            return CFrame.new(Rest.X, v499.FloorY + v499.HipOffset, Rest.Z) * Rest.Rotation
        end
        local LookVector = v499.Rest.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v501 = Vector3.new(X, 0, Z)
        local v502
        if v501.Magnitude > 0.001 then
            v502 = v501.Unit
        else
            v502 = Vector3.new(0, 0, -1)
        end
        local X_2 = v499.Rest.X
        local FloorY = v499.FloorY
        local Z_2 = v499.Rest.Z
        local v503 = Vector3.new(X_2, FloorY, Z_2)
        local v504 = v503 - v502 * (v499.Height * 0.5)
        local v505 = CFrame.lookAt(v503, v503 + v502)
        local v506 = Defeat.StaggerTime + Defeat.FallTime
        local v507
        if v500 < v506 then
            local v508 = (v500 - Defeat.StaggerTime) / Defeat.FallTime
            v507 = v508 * v508 * 3.141592653589793 / 2
        else
            local v509 = v500 - v506
            local v510 = v509 * 10
            local v511 = math.sin(v510)
            local v512 = math.abs(v511)
            local v513 = -v509 * 5
            v507 = 1.5707963267948966 - v512 * math.exp(v513) * 0.12
        end
        local v514 = v499.FloorY + v499.HipOffset - v499.FloorY
        local v515 = v505 * CFrame.Angles(v507, 0, 0) * CFrame.new(0, v514, 0) + Vector3.new(0, 1, 0) * (Defeat.LieLift * math.sin(v507))
        if Defeat.DropAt < v500 then
            local v516 = (v500 - Defeat.DropAt) / Defeat.DropTime
            local v517 = math.clamp(v516, 0, 1)
            local v518 = Defeat.DropTilt or 0
            local v519 = math.rad(v518)
            local v520 = math.clamp(v517, 0, 1)
            local v521 = v519 * (v520 * v520 * (3 - v520 * 2))
            local v522 = Defeat.DropRoll or 0
            local v523 = math.rad(v522)
            local v524 = (v500 - Defeat.DropAt) * 3.141592653589793 * 2 * (Defeat.DropRollSpeed or 1)
            local v525 = v523 * math.sin(v524)
            local v526 = v517 * 3
            local v527 = v525 * math.min(v526, 1)
            v515 = v515 * CFrame.Angles(v521, v527, 0) - Vector3.new(0, 1, 0) * (v517 * v517 * v499.Height * Defeat.DropDepth)
        end
        return v515
    end

    local function smoothTurn(v528, v529, v530) -- line 1726 | captures: Workspace
        local Attack = v528.Attack
        local v531
        if v528.Override == nil then
            if v528.Phase == "Defeated" then
                v531 = true
            elseif Attack == nil then
                v531 = false
            elseif Attack.Kind == "Slam" then
                local v532 = Workspace:GetServerTimeNow()
                local Attack = v528.Attack
                if Attack == nil then
                    v531 = false
                else
                    v531 = v532 < Attack.Start + Attack.Length
                end
            else
                v531 = false
            end
        else
            v531 = true
        end
        local LookVector = v529.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v533 = Vector3.new(X, 0, Z)
        if not (v531 or v533.Magnitude < 0.001) then
            local Unit = v533.Unit
            local Facing = v528.Facing
            if Facing then
                if Facing.Magnitude < 0.001 then
                    Facing = Unit
                end
            else
                Facing = Unit
            end
            local Move = v528.Move
            local v534 = if Move ~= nil and Workspace:GetServerTimeNow() < Move.End + 0.12 then 9 else 5
            local v535 = -v534 * v530
            local v536 = Facing:Lerp(Unit, 1 - math.exp(v535))
            if not (v536.Magnitude < 0.001) then
                Unit = v536
            end
            v528.Facing = Unit.Unit
            return CFrame.lookAt(v529.Position, v529.Position + v528.Facing)
        end
        v528.Facing = v533
        return v529
    end

    local function place(v537) -- line 1752 | captures: Workspace, slamCFrame, Defeat, defeatCFrame
        local Override = v537.Override
        local v538
        if Override then
            v538 = Override()
        end
        if not Override or not v538 then
            local v539 = Workspace:GetServerTimeNow()
            if v537.Phase == "Defeated" then
                return (defeatCFrame(v537, v539 - v537.PhaseStart - Defeat.BreakTime))
            end
            local Attack = v537.Attack
            if Attack then
                local Attack_2 = v537.Attack
                if Attack_2 ~= nil and v539 < Attack_2.Start + Attack_2.Length then
                    local v540 = v539 - Attack.Start
                    if Attack.Kind == "Slam" then
                        return (slamCFrame(v537, Attack, v540))
                    end
                    local From = Attack.From
                    return CFrame.new(From.X, v537.FloorY + v537.HipOffset, From.Z) * From.Rotation
                end
            end
            local NextMove = v537.NextMove
            if NextMove and NextMove.Start <= v539 then
                v537.Move = NextMove
                v537.NextMove = nil
            end
            local Move = v537.Move
            if not (Move and v539 < Move.End) then
                local Rest = v537.Rest
                return CFrame.new(Rest.X, v537.FloorY + v537.HipOffset, Rest.Z) * Rest.Rotation
            end
            local v541 = v539 - Move.Start
            local v542 = Move.End - Move.Start
            local v543 = v541 / math.max(v542, 0.01)
            local v544 = math.clamp(v543, 0, 1)
            local v545 = Move.From.Position:Lerp(Move.To.Position, v544)
            local v546 = CFrame.new(v545) * Move.To.Rotation
            return CFrame.new(v546.X, v537.FloorY + v537.HipOffset, v546.Z) * v546.Rotation
        end
        return v538
    end

    local function loadTrack(v547, v548, v549) -- line 1787
        local v550 = v547.Tracks:Get(v548, v549)
        if v550 then
            v550.Looped = true
        end
        return v550
    end

    local function readMove(v551) -- line 1795 | captures: Workspace
        local Model = v551.Model
        local MoveId = Model:GetAttribute("MoveId")
        if type(MoveId) ~= "number" or MoveId == v551.MoveId then
            return
        end
        v551.MoveId = MoveId
        local MoveFrom = Model:GetAttribute("MoveFrom")
        local MoveTo = Model:GetAttribute("MoveTo")
        local MoveStart = Model:GetAttribute("MoveStart")
        local MoveEnd = Model:GetAttribute("MoveEnd")
        if not (typeof(MoveFrom) == "CFrame" and typeof(MoveTo) == "CFrame" and type(MoveStart) == "number" and type(MoveEnd) == "number") then
            return
        end
        local v552 = {
            Id = MoveId,
            From = MoveFrom,
            To = MoveTo,
            Start = MoveStart,
            End = MoveEnd
        }
        local Move = v551.Move
        if Move and Workspace:GetServerTimeNow() < Move.End then
            local Start = v552.Start
            if Move.End - 0.01 <= Start then
                v551.NextMove = v552
                return
            end
        end
        v551.Move = v552
        v551.NextMove = nil
    end

    local function isWalking(v553, v554) -- line 1819
        local Attack = v553.Attack
        if Attack ~= nil and v554 < Attack.Start + Attack.Length or v553.Phase == "Stunned" or v553.Phase == "Defeated" then
            return false
        end
        local Move = v553.Move
        if Move ~= nil and v554 < Move.End + 0.12 then
            return true
        end
        return v553.NextMove ~= nil
    end

    local function walkOn(v555, v556) -- line 1829 | captures: HellBossConfig
        if not v555.WalkTrack then
            local Movement = Enum.AnimationPriority.Movement
            local v557 = v555.Tracks:Get("Walk", Movement)
            if v557 then
                v557.Looped = true
            end
            v555.WalkTrack = v557
        end
        local WalkTrack = v555.WalkTrack
        if not WalkTrack then
            return
        end
        if not WalkTrack.IsPlaying then
            WalkTrack:Play(0.25)
        end
        local AnimationSpeed = HellBossConfig.Walk.AnimationSpeed
        local Scale = v555.Scale
        WalkTrack:AdjustSpeed(v556 / (AnimationSpeed * math.max(Scale, 0.01)))
    end

    local function walkOff(v558) -- line 1845
        local WalkTrack = v558.WalkTrack
        if WalkTrack and WalkTrack.IsPlaying then
            WalkTrack:Stop(0.25)
        end
    end

    local function footsteps(v559) -- line 1854 | captures: HellBossConfig, Sfx, playSfx, shakeFrom
        local WalkTrack = v559.WalkTrack
        if WalkTrack and WalkTrack.IsPlaying and WalkTrack.Length > 0 then
            local v560 = WalkTrack.Length / 2
            local TimePosition = WalkTrack.TimePosition
            local WalkPhase = v559.WalkPhase
            if WalkPhase >= 0 then
                if WalkPhase < v560 then
                    if v560 <= TimePosition or TimePosition < WalkPhase then
                        local X = v559.Root.Position.X
                        local FloorY = v559.FloorY
                        local Z = v559.Root.Position.Z
                        local v561 = Vector3.new(X, FloorY, Z)
                        playSfx(Sfx.Footstep, v561)
                        shakeFrom(v561, HellBossConfig.Walk.FootstepShake, HellBossConfig.Walk.FootstepShakeRadius)
                    end
                elseif TimePosition < WalkPhase then
                    local X = v559.Root.Position.X
                    local FloorY = v559.FloorY
                    local Z = v559.Root.Position.Z
                    local v562 = Vector3.new(X, FloorY, Z)
                    playSfx(Sfx.Footstep, v562)
                    shakeFrom(v562, HellBossConfig.Walk.FootstepShake, HellBossConfig.Walk.FootstepShakeRadius)
                end
            end
            v559.WalkPhase = TimePosition
        else
            v559.WalkPhase = -1
        end
    end

    local function setFade(v563, v564) -- line 1873
        local v565 = math.clamp(v564, 0, 1)
        if v563.Fade == v565 then
            return
        end
        v563.Fade = v565
        v563.Hidden = v565 >= 1
        local FadeParts = v563.FadeParts
        if not FadeParts then
            FadeParts = {}
            for v566, v567 in v563.Model:GetDescendants() do
                if v567:IsA("BasePart") or v567:IsA("Decal") then
                    table.insert(FadeParts, v567)
                end
            end
            v563.FadeParts = FadeParts
        end
        for v568, v569 in FadeParts do
            v569.LocalTransparencyModifier = v565
        end
    end

    local function setHidden(v570, v571) -- line 1896 | captures: setFade
        local v572 = if v571 then 1 else 0
        setFade(v570, v572)
    end

    local function floorLook(v573) -- line 1906 | captures: v3, v5, Players, Workspace, Visuals
        local v574 = RaycastParams.new()
        v574.FilterType = Enum.RaycastFilterType.Exclude
        local v575 = {}
        local Folder
        if not (v5 and v5.Parent) then
            Folder = Instance.new("Folder")
            Folder.Name = "HellBossFX"
            Folder.Parent = Workspace
            v5 = Folder
        else
            Folder = v5
        end
        v575[1] = Folder
        if v3 then
            local Model = v3.Model
            table.insert(v575, Model)
        end
        for v576, v577 in Players:GetPlayers() do
            if v577.Character then
                local Character = v577.Character
                table.insert(v575, Character)
            end
        end
        v574.FilterDescendantsInstances = v575
        local v578, v579
        for v580 = 1, 6 do
            local v581 = Workspace:Raycast(v573 + Vector3.new(0, 25, 0), Vector3.new(0, -60, 0), v574)
            v578 = v581
            if v581 and v581.Instance:IsA("BasePart") then
                if v581.Instance.Transparency < 0.9 then
                    v579 = v581
                    break
                end
            else
                v579 = v581
                break
            end
            local Instance = v581.Instance
            table.insert(v575, Instance)
            v574.FilterDescendantsInstances = v575
            v578 = nil
            v579 = nil
        end
        if v579 then
            if v579.Instance:IsA("Terrain") then
                local v582, v583 = pcall(function() -- line 1933 | captures: v578, Workspace
                    return Workspace.Terrain:GetMaterialColor(v578.Material)
                end)
                if not v582 then
                    v583 = Visuals.Crater.FallbackColor
                end
                return v583, v578.Material
            end
            if v579.Instance:IsA("BasePart") then
                return v579.Instance.Color, v579.Instance.Material, v579.Instance
            end
        end
        return Visuals.Crater.FallbackColor, Enum.Material.Slate
    end

    local function floorChunks(v584, v585, v586) -- line 1946 | captures: EggLandImpact, floorLook
        local v587, v588, v589 = floorLook(v584)
        EggLandImpact.Chunks(v584, v585, v586, v589)
    end

    local function crater(v590, v591, v592) -- line 1954 | captures: v5, TweenService, Workspace, SurfaceLook, Visuals, newPart, floorLook
        local Crater = Visuals.Crater
        local v593, v594, v595 = floorLook(v590)
        local Model = Instance.new("Model")
        Model.Name = "ImpactChunks"
        local v596 = {}
        for v597 = 1, v592 do
            local v598 = math.random() * 3.141592653589793 * 2
            local v599 = math.random()
            local v600 = v591 * math.sqrt(v599) * 0.95
            local v601 = math.cos(v598) * v600
            local v602 = math.sin(v598) * v600
            local v603 = v590 + Vector3.new(v601, 0, v602)
            local v604 = (v600 / v591 * -0.44999999999999996 + 1) * (v591 / Crater.Radius)
            local Min = Crater.BlockSize.Min
            local Max = Crater.BlockSize.Max
            local v605 = math.random()
            local v606 = Min + (Max - Min) * v605
            local Min_2 = Crater.BlockSize.Min
            local Max_2 = Crater.BlockSize.Max
            local v607 = math.random()
            local v608 = Min_2 + (Max_2 - Min_2) * v607
            local Min_3 = Crater.BlockSize.Min
            local Max_3 = Crater.BlockSize.Max
            local v609 = math.random()
            local v610 = Min_3 + (Max_3 - Min_3) * v609
            local v611 = Vector3.new(v606, v608, v610) * math.max(v604, 0.3)
            local Tilt = Crater.Tilt
            local v612 = math.rad(Tilt)
            local v613 = CFrame.Angles((math.random() - 0.5) * 2 * v612, math.random() * 3.141592653589793 * 2, (math.random() - 0.5) * 2 * v612)
            local Min_4 = Crater.StickOut.Min
            local Max_4 = Crater.StickOut.Max
            local v614 = math.random()
            local v615 = Min_4 + (Max_4 - Min_4) * v614
            local v616 = CFrame.new(v603 + Vector3.new(0, 1, 0) * (v611.Y * (v615 - 0.5))) * v613
            local v617 = newPart({
                Material = v594,
                Color = v593,
                Size = v611,
                CFrame = v616 - Vector3.new(0, 1, 0) * (v611.Y * v615 + 0.5),
                Parent = Model
            })
            v617.Material = Enum.Material.Plastic
            SurfaceLook.Apply(v617, v595)
            local v618 = {
                Part = v617,
                Goal = v616
            }
            table.insert(v596, v618)
        end
        local Folder
        if not (v5 and v5.Parent) then
            Folder = Instance.new("Folder")
            Folder.Name = "HellBossFX"
            Folder.Parent = Workspace
            v5 = Folder
        else
            Folder = v5
        end
        Model.Parent = Folder
        for v619, v620 in v596 do
            local v621 = TweenInfo.new(Crater.RiseTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, math.random() * Crater.Stagger)
            TweenService:Create(v620.Part, v621, { CFrame = v620.Goal }):Play()
        end
        task.delay(Crater.Linger, function() -- line 2001 | captures: Crater, Model, v596, TweenService
            if Model.Parent then
                for v622, v623 in v596 do
                    local v624 = TweenInfo.new(Crater.ShrinkTime, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, math.random() * Crater.Stagger)
                    TweenService:Create(v623.Part, v624, { Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806) }):Play()
                end
                task.delay(Crater.ShrinkTime + Crater.Stagger + 0.05, function() -- line 2009 | captures: Model
                    Model:Destroy()
                end)
            end
        end)
    end

    local function stopFly(v625) -- line 2015
        local StopFly = v625.StopFly
        v625.StopFly = nil
        if StopFly then
            StopFly()
        end
    end

    local function shockwave(v626, v627, v628, v629, v630, v631, v632, v633) -- line 2029 | captures: v3, RunService, Workspace, HellBossConfig, myFeet, reportHit, ring
        local v634 = v629 < Workspace:GetServerTimeNow()
        local ShockwaveRadius = HellBossConfig.Arena.ShockwaveRadius
        local v635 = (ShockwaveRadius - v630.StartRadius) / v630.Speed
        local Id = v627.Id

        local function v636() -- line 2037 | captures: v626, v627, v628, v629, v630, v631, v632, v633, ShockwaveRadius, v634, v3, RunService, Workspace, myFeet, reportHit, ring
            local v637
            if v633 then
                v637 = v633()
            else
                v637 = v628
            end
            ring(v637, v629, v630.StartRadius, v630.Speed, ShockwaveRadius, v630.Height, v630.Thickness)
            local v638 = v630.Thickness / 2 + 1.5
            local StartRadius = v630.StartRadius
            local v639 = Workspace:GetServerTimeNow() - v629
            local v640 = StartRadius + math.max(v639, 0) * v630.Speed
            local v641
            if v634 then
                v641 = v640
            elseif v632 then
                v641 = v630.StartRadius
            else
                v641 = 0
            end
            local v642
            local Heartbeat = RunService.Heartbeat
            local v643 = v638
            local v644 = v637
            v642 = Heartbeat:Connect(function() -- line 2049 | captures: v641, v642, v643, v644, v626, v627, v629, v630, v631, ShockwaveRadius, v3, Workspace, myFeet, reportHit
                local v645 = v630.StartRadius + (Workspace:GetServerTimeNow() - v629) * v630.Speed
                if v3 ~= v626 or ShockwaveRadius + v643 < v645 then
                    v642:Disconnect()
                else
                    local v646, v647 = myFeet(v626.FloorY)
                    if v646 then
                        local v648 = v646.Position - v644
                        local X = v648.X
                        local Z = v648.Z
                        local Magnitude = Vector3.new(X, 0, Z).Magnitude
                        if Magnitude <= v645 + v643 and v641 - v643 <= Magnitude and v647 < v630.Height then
                            v642:Disconnect()
                            reportHit(v627.Id, v631)
                            return
                        end
                    end
                    v641 = v645
                end
            end)
        end

        local v649 = v629 - Workspace:GetServerTimeNow()
        if v649 < -v635 then
            return
        end
        task.delay(math.max(v649, 0), function() -- line 419 | captures: v626, Id, v636, v3
            if not (v3 ~= v626 or v626.AttackId ~= Id and v626.SideAttackId ~= Id) then
                v636()
            end
        end)
    end

    local function stompAt(v650, v651, v652, v653) -- line 2071 | captures: v3, RunService, Workspace, HellBossConfig, EggLandImpact, VFXBurst, Visuals, Attacks, Sfx, playSfx, shakeFrom, myFeet, reportHit, ring, v447, floorLook
        local Stomp = Attacks.Stomp
        local X = v651.From.X
        local FloorY = v650.FloorY
        local Z = v651.From.Z
        local v654 = Vector3.new(X, FloorY, Z)

        local function footSpot() -- line 2076 | captures: v650, Stomp, v654, v447
            local v655 = v447.Position(v650, Stomp.Foot)
            if v655 then
                local v656 = v655 - v654
                local X = v656.X
                local Z = v656.Z
                local v657 = Vector3.new(X, 0, Z)
                local Magnitude = v657.Magnitude
                if Stomp.FootReach < Magnitude then
                    v657 = v657.Unit * Stomp.FootReach
                end
                return v654 + v657
            end
            return v654
        end

        local Id = v651.Id

        local function v658() -- line 2087 | captures: v650, Stomp, v654, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, v447, floorLook
            local v659 = v447.Position(v650, Stomp.Foot)
            local v660
            if v659 then
                local v661 = v659 - v654
                local X = v661.X
                local Z = v661.Z
                local v662 = Vector3.new(X, 0, Z)
                local Magnitude = v662.Magnitude
                if Stomp.FootReach < Magnitude then
                    v662 = v662.Unit * Stomp.FootReach
                end
                v660 = v654 + v662
            else
                v660 = v654
            end
            VFXBurst.Play(Visuals.BlastName, CFrame.new(v660), Visuals.StompBlastScale, Visuals.Shockwave.Color)
            local v663 = v650.FxScale * 0.5
            local v664 = v650.FxScale * 1.5
            local v665, v666, v667 = floorLook(v660)
            EggLandImpact.Chunks(v660, v663, v664, v667)
            playSfx(Sfx.Stomp, v660)
            playSfx(Sfx.StompBoom, v660)
            shakeFrom(v660, Visuals.StompShake)
        end

        local v668 = v652 - Workspace:GetServerTimeNow()
        if not (v668 < -0.3) then
            task.delay(math.max(v668, 0), function() -- line 419 | captures: v650, Id, v658, v3
                if not (v3 ~= v650 or v650.AttackId ~= Id and v650.SideAttackId ~= Id) then
                    v658()
                end
            end)
        end
        local v669 = v652 < Workspace:GetServerTimeNow()
        local ShockwaveRadius = HellBossConfig.Arena.ShockwaveRadius
        local v670 = (ShockwaveRadius - Stomp.StartRadius) / Stomp.Speed
        local Id_2 = v651.Id
        local v671

        local function v672() -- line 2037 | captures: v650, v651, v652, v653, Stomp, v654, footSpot, ShockwaveRadius, v669, v671, v3, RunService, Workspace, myFeet, reportHit, ring
            local v673
            if footSpot then
                v673 = footSpot()
            else
                v673 = v654
            end
            ring(v673, v652, Stomp.StartRadius, Stomp.Speed, ShockwaveRadius, Stomp.Height, Stomp.Thickness)
            local v674 = Stomp.Thickness / 2 + 1.5
            local StartRadius = Stomp.StartRadius
            local v675 = Workspace:GetServerTimeNow() - v652
            local v676 = StartRadius + math.max(v675, 0) * Stomp.Speed
            local v677
            if v669 then
                v677 = v676
            elseif v671 then
                v677 = Stomp.StartRadius
            else
                v677 = 0
            end
            local v678
            local Heartbeat = RunService.Heartbeat
            local v679 = v674
            local v680 = v673
            v678 = Heartbeat:Connect(function() -- line 2049 | captures: v650, v651, v652, v653, Stomp, ShockwaveRadius, v3, Workspace, myFeet, reportHit, v677, v678, v679, v680
                local v681 = Stomp.StartRadius + (Workspace:GetServerTimeNow() - v652) * Stomp.Speed
                if v3 ~= v650 or ShockwaveRadius + v679 < v681 then
                    v678:Disconnect()
                else
                    local v682, v683 = myFeet(v650.FloorY)
                    if v682 then
                        local v684 = v682.Position - v680
                        local X = v684.X
                        local Z = v684.Z
                        local Magnitude = Vector3.new(X, 0, Z).Magnitude
                        if Magnitude <= v681 + v679 and v677 - v679 <= Magnitude and v683 < Stomp.Height then
                            v678:Disconnect()
                            reportHit(v651.Id, v653)
                            return
                        end
                    end
                    v677 = v681
                end
            end)
        end

        local v685 = v652 - Workspace:GetServerTimeNow()
        if v685 < -v670 then
            return
        end
        task.delay(math.max(v685, 0), function() -- line 419 | captures: v650, Id_2, v672, v3
            if not (v3 ~= v650 or v650.AttackId ~= Id_2 and v650.SideAttackId ~= Id_2) then
                v672()
            end
        end)
    end

    local function stompFx(v686, v687) -- line 2098 | captures: Attacks, stompAt
        stompAt(v686, v687, v687.Start + Attacks.Stomp.Windup)
    end

    local function tripleStompFx(v688, v689) -- line 2103 | captures: HellBossConfig, Attacks, stompAt
        local Count = Attacks.TripleStomp.Count
        for v690 = 1, Count do
            stompAt(v688, v689, v689.Start + HellBossConfig.TripleStompImpactTime(v690), v690)
        end
    end

    local function slamFx(v691, v692) -- line 2109 | captures: v3, RunService, Workspace, HellBossConfig, EggLandImpact, VFXBurst, Visuals, Attacks, Sfx, playSfx, shakeFrom, myFeet, reportHit, ring, indicator, floorLook, crater
        local Slam = Attacks.Slam
        local v693 = v692.Start + Slam.Crouch
        local v694 = v692.Start + HellBossConfig.SlamImpactTime()
        local X = v692.To.X
        local FloorY = v691.FloorY
        local Z = v692.To.Z
        local v695 = Vector3.new(X, FloorY, Z)
        local X_2 = v692.From.X
        local FloorY_2 = v691.FloorY
        local Z_2 = v692.From.Z
        local v696 = Vector3.new(X_2, FloorY_2, Z_2)
        local Id = v692.Id
        local Start = v692.Start
        local v697 = v694 - v692.Start

        local function v698() -- line 2116 | captures: v692, Slam, v694, v695, Visuals, indicator
            indicator(v695, Slam.Radius, v692.Start, v694, not Visuals.Indicator.SlamBeam)
        end

        local v699 = Start - Workspace:GetServerTimeNow()
        if not (v699 < -v697) then
            task.delay(math.max(v699, 0), function() -- line 419 | captures: v691, Id, v698, v3
                if not (v3 ~= v691 or v691.AttackId ~= Id and v691.SideAttackId ~= Id) then
                    v698()
                end
            end)
        end
        local Id_2 = v692.Id

        local function v700() -- line 2120 | captures: v691, v696, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, floorLook
            VFXBurst.Play(Visuals.SmokeName, CFrame.new(v696), Visuals.LeapSmokeScale)
            local v701 = v691.FxScale * 0.5
            local v702 = v691.FxScale * 1.5
            local v703, v704, v705 = floorLook(v696)
            EggLandImpact.Chunks(v696, v701, v702, v705)
            playSfx(Sfx.TakeOff, v696)
            shakeFrom(v696, Visuals.LeapShake)
        end

        local v706 = v693 - Workspace:GetServerTimeNow()
        if not (v706 < -0.3) then
            task.delay(math.max(v706, 0), function() -- line 419 | captures: v691, Id_2, v700, v3
                if not (v3 ~= v691 or v691.AttackId ~= Id_2 and v691.SideAttackId ~= Id_2) then
                    v700()
                end
            end)
        end
        local LargeImpact = Sfx.LargeImpact
        local v707 = v694 - LargeImpact.Lead
        local Id_3 = v692.Id

        local function v708() -- line 2130 | captures: v695, LargeImpact, v707, Workspace, playSfx
            local v709 = playSfx(LargeImpact, v695)
            local v710 = Workspace:GetServerTimeNow() - v707
            if v709 and v710 > 0.05 then
                v709.TimePosition = v710
            end
        end

        local v711 = v707 - Workspace:GetServerTimeNow()
        if not (v711 < -0.6) then
            task.delay(math.max(v711, 0), function() -- line 419 | captures: v691, Id_3, v708, v3
                if not (v3 ~= v691 or v691.AttackId ~= Id_3 and v691.SideAttackId ~= Id_3) then
                    v708()
                end
            end)
        end
        local Id_4 = v692.Id

        local function v712() -- line 2138 | captures: v691, v692, Slam, v695, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, myFeet, reportHit, floorLook, crater
            local StopFly = v691.StopFly
            v691.StopFly = nil
            if StopFly then
                StopFly()
            end
            local v713, v714 = myFeet(v691.FloorY)
            if v713 then
                local v715 = v713.Position - v695
                local X = v715.X
                local Z = v715.Z
                if Vector3.new(X, 0, Z).Magnitude <= Slam.Radius + 1.5 and v714 < Slam.HitHeight then
                    reportHit(v692.Id)
                end
            end
            VFXBurst.Play(Visuals.BlastName, CFrame.new(v695), Visuals.SlamBlastScale, Visuals.Indicator.Color)
            VFXBurst.Play(Visuals.SmokeName, CFrame.new(v695), Visuals.LeapSmokeScale * 1.3)
            local v716 = v691.FxScale * 0.7
            local v717 = v691.FxScale * 2.2
            local v718, v719, v720 = floorLook(v695)
            EggLandImpact.Chunks(v695, v716, v717, v720)
            playSfx(Sfx.Slam, v695)
            shakeFrom(v695, Visuals.SlamShake)
            crater(v695, Visuals.Crater.Radius, Visuals.Crater.Blocks)
        end

        local v721 = v694 - Workspace:GetServerTimeNow()
        if not (v721 < -0.3) then
            task.delay(math.max(v721, 0), function() -- line 419 | captures: v691, Id_4, v712, v3
                if not (v3 ~= v691 or v691.AttackId ~= Id_4 and v691.SideAttackId ~= Id_4) then
                    v712()
                end
            end)
        end
        local Shockwave = Slam.Shockwave
        local v722 = v694 < Workspace:GetServerTimeNow()
        local ShockwaveRadius = HellBossConfig.Arena.ShockwaveRadius
        local v723 = (ShockwaveRadius - Shockwave.StartRadius) / Shockwave.Speed
        local Id_5 = v692.Id
        local v724
        local v725 = true
        local v726 = 1

        local function v727() -- line 2037 | captures: v691, v692, v694, v695, Shockwave, ShockwaveRadius, v724, v722, v725, v726, v3, RunService, Workspace, myFeet, reportHit, ring
            local v728
            if v724 then
                v728 = v724()
            else
                v728 = v695
            end
            ring(v728, v694, Shockwave.StartRadius, Shockwave.Speed, ShockwaveRadius, Shockwave.Height, Shockwave.Thickness)
            local v729 = Shockwave.Thickness / 2 + 1.5
            local StartRadius = Shockwave.StartRadius
            local v730 = Workspace:GetServerTimeNow() - v694
            local v731 = StartRadius + math.max(v730, 0) * Shockwave.Speed
            local v732
            if v722 then
                v732 = v731
            elseif v725 then
                v732 = Shockwave.StartRadius
            else
                v732 = 0
            end
            local v733
            local Heartbeat = RunService.Heartbeat
            local v734 = v729
            local v735 = v728
            v733 = Heartbeat:Connect(function() -- line 2049 | captures: v691, v692, v694, Shockwave, ShockwaveRadius, v726, v3, Workspace, myFeet, reportHit, v732, v733, v734, v735
                local v736 = Shockwave.StartRadius + (Workspace:GetServerTimeNow() - v694) * Shockwave.Speed
                if v3 ~= v691 or ShockwaveRadius + v734 < v736 then
                    v733:Disconnect()
                else
                    local v737, v738 = myFeet(v691.FloorY)
                    if v737 then
                        local v739 = v737.Position - v735
                        local X = v739.X
                        local Z = v739.Z
                        local Magnitude = Vector3.new(X, 0, Z).Magnitude
                        if Magnitude <= v736 + v734 and v732 - v734 <= Magnitude and v738 < Shockwave.Height then
                            v733:Disconnect()
                            reportHit(v692.Id, v726)
                            return
                        end
                    end
                    v732 = v736
                end
            end)
        end

        local v740 = v694 - Workspace:GetServerTimeNow()
        if v740 < -v723 then
            return
        end
        task.delay(math.max(v740, 0), function() -- line 419 | captures: v691, Id_5, v727, v3
            if not (v3 ~= v691 or v691.AttackId ~= Id_5 and v691.SideAttackId ~= Id_5) then
                v727()
            end
        end)
    end

    local function weaponSlamFx(v741, v742) -- line 2162 | captures: v3, Workspace, HellBossConfig, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, ring, v447, floorLook
        local WeaponSlam = Visuals.WeaponSlam
        local v743 = HellBossConfig.Moves[v742.Kind]
        if WeaponSlam and v743 then
            local v744, WeaponSlam_2, v745, Id, v746
            for v747, v748 in v743 do
                if v748.Track == "Attack" then
                    local v749 = v748.Speed or 1
                    local v750 = math.max(v749, 0.001)
                    for v751, v752 in WeaponSlam.Marks do
                        if not (v752 < (v748.Mark or 0)) then
                            local v753 = v748.At + (v752 - (v748.Mark or 0)) / v750
                            if v748.Until then
                                if not (v748.Until < v753) and not (v742.Length < v753) then
                                    local v754 = v742.Start + v753
                                    local Id_2 = v742.Id
                                    v744 = v741
                                    WeaponSlam_2 = WeaponSlam

                                    local function v755() -- line 2182 | captures: v744, WeaponSlam_2, Workspace, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, ring, v447, floorLook
                                        local v756 = v447.Position(v744, WeaponSlam_2.Bone)
                                        if not v756 then
                                            local Position = v744.Root.Position
                                            local LookVector = v744.Root.CFrame.LookVector
                                            local X = LookVector.X
                                            local Z = LookVector.Z
                                            v756 = Position + Vector3.new(X, 0, Z) * v744.Height * 0.4
                                        end
                                        local X = v756.X
                                        local FloorY = v744.FloorY
                                        local Z = v756.Z
                                        local v757 = Vector3.new(X, FloorY, Z)
                                        VFXBurst.Play(Visuals.SmokeName, CFrame.new(v757), WeaponSlam_2.SmokeScale)
                                        VFXBurst.Play(Visuals.BlastName, CFrame.new(v757), WeaponSlam_2.BlastScale, Visuals.Shockwave.Color)
                                        local v758 = v744.FxScale * WeaponSlam_2.ChunkScale
                                        local FxScale = v744.FxScale
                                        local v759, v760, v761 = floorLook(v757)
                                        EggLandImpact.Chunks(v757, v758, FxScale, v761)
                                        if WeaponSlam_2.Ring then
                                            ring(v757 + Vector3.new(0, 0.20000000298023224, 0), Workspace:GetServerTimeNow(), 2, WeaponSlam_2.RingSpeed, WeaponSlam_2.RingMax, WeaponSlam_2.RingHeight, WeaponSlam_2.RingThickness)
                                        end
                                        playSfx(Sfx.WeaponSlam, v757)
                                        shakeFrom(v757, WeaponSlam_2.Shake)
                                    end

                                    local v762 = v754 - Workspace:GetServerTimeNow()
                                    if not (v762 < -0.3) then
                                        local delay = task.delay
                                        local v763 = math.max(v762, 0)
                                        v745 = v741
                                        Id = Id_2
                                        v746 = v755
                                        delay(v763, function() -- line 419 | captures: v745, Id, v746, v3
                                            if not (v3 ~= v745 or v745.AttackId ~= Id and v745.SideAttackId ~= Id) then
                                                v746()
                                            end
                                        end)
                                    end
                                end
                            elseif not (v742.Length < v753) then
                                local v764 = v742.Start + v753
                                local Id_2 = v742.Id
                                v744 = v741
                                WeaponSlam_2 = WeaponSlam

                                local function v765() -- line 2182 | captures: v744, WeaponSlam_2, Workspace, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, ring, v447, floorLook
                                    local v766 = v447.Position(v744, WeaponSlam_2.Bone)
                                    if not v766 then
                                        local Position = v744.Root.Position
                                        local LookVector = v744.Root.CFrame.LookVector
                                        local X = LookVector.X
                                        local Z = LookVector.Z
                                        v766 = Position + Vector3.new(X, 0, Z) * v744.Height * 0.4
                                    end
                                    local X = v766.X
                                    local FloorY = v744.FloorY
                                    local Z = v766.Z
                                    local v767 = Vector3.new(X, FloorY, Z)
                                    VFXBurst.Play(Visuals.SmokeName, CFrame.new(v767), WeaponSlam_2.SmokeScale)
                                    VFXBurst.Play(Visuals.BlastName, CFrame.new(v767), WeaponSlam_2.BlastScale, Visuals.Shockwave.Color)
                                    local v768 = v744.FxScale * WeaponSlam_2.ChunkScale
                                    local FxScale = v744.FxScale
                                    local v769, v770, v771 = floorLook(v767)
                                    EggLandImpact.Chunks(v767, v768, FxScale, v771)
                                    if WeaponSlam_2.Ring then
                                        ring(v767 + Vector3.new(0, 0.20000000298023224, 0), Workspace:GetServerTimeNow(), 2, WeaponSlam_2.RingSpeed, WeaponSlam_2.RingMax, WeaponSlam_2.RingHeight, WeaponSlam_2.RingThickness)
                                    end
                                    playSfx(Sfx.WeaponSlam, v767)
                                    shakeFrom(v767, WeaponSlam_2.Shake)
                                end

                                local v772 = v764 - Workspace:GetServerTimeNow()
                                if not (v772 < -0.3) then
                                    local delay = task.delay
                                    local v773 = math.max(v772, 0)
                                    v745 = v741
                                    Id = Id_2
                                    v746 = v765
                                    delay(v773, function() -- line 419 | captures: v745, Id, v746, v3
                                        if not (v3 ~= v745 or v745.AttackId ~= Id and v745.SideAttackId ~= Id) then
                                            v746()
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function meteorFx(v774, v775) -- line 2199 | captures: v3, Workspace, HellBossConfig, EggLandImpact, VFXBurst, Visuals, Attacks, Sfx, playSfx, shakeFrom, myFeet, reportHit, indicator, meteor, v447, floorLook, crater
        local Meteor = Attacks.Meteor
        local Id = v775.Id
        local Start = v775.Start

        local function v776() -- line 2201 | captures: v774, Sfx, playSfx
            playSfx(Sfx.MeteorCast, v774.Root)
        end

        local v777 = Start - Workspace:GetServerTimeNow()
        if not (v777 < -0.3) then
            task.delay(math.max(v777, 0), function() -- line 419 | captures: v774, Id, v776, v3
                if not (v3 ~= v774 or v774.AttackId ~= Id and v774.SideAttackId ~= Id) then
                    v776()
                end
            end)
        end
        local Id_2 = v775.Id
        local v778 = v775.Start + Meteor.Cast * 0.85

        local function v779() -- line 2205 | captures: v774, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, v447
            local Weapon = v447.Position(v774, "Weapon")
            local v780 = if Weapon then Weapon + Vector3.new(0, 6, 0) else v774.Root.Position + Vector3.new(0, 1, 0) * v774.Height * 0.6
            VFXBurst.Play(Visuals.BlastName, CFrame.new(v780), Visuals.Meteor.BlastScale, Visuals.Meteor.Color)
            playSfx(Sfx.Roar, v774.Root)
            shakeFrom(v780, Visuals.MeteorShake)
        end

        local v781 = v778 - Workspace:GetServerTimeNow()
        if not (v781 < -0.3) then
            task.delay(math.max(v781, 0), function() -- line 419 | captures: v774, Id_2, v779, v3
                if not (v3 ~= v774 or v774.AttackId ~= Id_2 and v774.SideAttackId ~= Id_2) then
                    v779()
                end
            end)
        end
        for v782, v783 in v775.Targets do
            local v784 = v775.Start + Meteor.Cast + (v782 - 1) * Meteor.Stagger
            local v785 = v775.Start + HellBossConfig.MeteorImpactTime(v782)
            local Id = v775.Id
            local v786 = v785 - v784
            local v787 = v783

            local v788 = function() -- line 2216 | captures: Meteor, v784, v785, v787, indicator
                indicator(v787, Meteor.Radius, v784, v785)
            end

            local v789 = v784 - Workspace:GetServerTimeNow()
            if not (v789 < -v786) then
                task.delay(math.max(v789, 0), function() -- line 419 | captures: v774, Id, v788, v3
                    if not (v3 ~= v774 or v774.AttackId ~= Id and v774.SideAttackId ~= Id) then
                        v788()
                    end
                end)
            end
            local Id_2 = v775.Id
            local v790 = v785 - Meteor.FallTime
            local FallTime = Meteor.FallTime

            local v791 = function() -- line 2219 | captures: v785, v787, meteor
                meteor(v787, v785)
            end

            local v792 = v790 - Workspace:GetServerTimeNow()
            if not (v792 < -FallTime) then
                task.delay(math.max(v792, 0), function() -- line 419 | captures: v774, Id_2, v791, v3
                    if not (v3 ~= v774 or v774.AttackId ~= Id_2 and v774.SideAttackId ~= Id_2) then
                        v791()
                    end
                end)
            end
            local Id_3 = v775.Id
            local v793 = v782

            local v794 = function() -- line 2222 | captures: v774, v775, Meteor, v787, v793, Workspace, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, myFeet, reportHit, floorLook, crater
                local v795, v796 = myFeet(v774.FloorY)
                if v795 then
                    local v797 = v795.Position - v787
                    local X = v797.X
                    local Z = v797.Z
                    if Vector3.new(X, 0, Z).Magnitude <= Meteor.Radius + 1.5 and v796 < Meteor.HitHeight then
                        reportHit(v775.Id, v793)
                    end
                end
                local CurrentCamera = Workspace.CurrentCamera
                local v798
                if CurrentCamera then
                    local CFrame = CurrentCamera.CFrame
                    if (v787 - CFrame.Position).Magnitude <= 90 then
                        v798 = true
                    else
                        local v799, v800 = CurrentCamera:WorldToViewportPoint(v787)
                        if v800 then
                            v798 = true
                        else
                            local v801
                            v801, v798 = CurrentCamera:WorldToViewportPoint(v787 + CFrame.LookVector * 45)
                        end
                    end
                else
                    v798 = true
                end
                if v798 then
                    VFXBurst.Play(Visuals.BlastName, CFrame.new(v787), Visuals.Meteor.BlastScale, Visuals.Meteor.Color)
                    local v802, v803, v804 = floorLook(v787)
                    EggLandImpact.Chunks(v787, 3, 8, v804)
                    local Crater = Visuals.Crater
                    local v805 = Crater.Radius * Crater.MeteorScale
                    local v806 = Crater.Blocks * Crater.MeteorScale + 0.5
                    local v807 = math.floor(v806)
                    crater(v787, v805, (math.max(v807, 5)))
                end
                playSfx(Sfx.MeteorHit, v787)
                shakeFrom(v787, Visuals.MeteorShake)
            end

            local v808 = v785 - Workspace:GetServerTimeNow()
            if not (v808 < -0.3) then
                task.delay(math.max(v808, 0), function() -- line 419 | captures: v774, Id_3, v794, v3
                    if not (v3 ~= v774 or v774.AttackId ~= Id_3 and v774.SideAttackId ~= Id_3) then
                        v794()
                    end
                end)
            end
        end
    end

    local v809

    local function preparedSpikes() -- line 2252 | captures: v809, ReplicatedStorage, Attacks
        local function v810(v811, ...)
            table.insert(v811, ...)
        end

        local Model = Attacks.Spikes.Model
        local v812 = ReplicatedStorage
        for v813, v814 in Model do
            v812 = v812 and v812:FindFirstChild(v814)
        end
        if not (v812 and v812:IsA("Model")) then
            return nil
        end
        if not (v809 and v809.Source == v812) then
            local v815 = v812:Clone()
            for v816, v817 in v815:GetDescendants() do
                if v817:IsA("BasePart") then
                    v817.Anchored = true
                    v817.CanCollide = false
                    v817.CanQuery = false
                    v817.CanTouch = false
                    v817.CastShadow = false
                end
            end
            local v818, v819 = v815:GetBoundingBox()
            if v819.Y > 0 then
                v815:ScaleTo(v815:GetScale() * Attacks.Spikes.SpikeHeight / v819.Y)
            end
            local v820, v821 = v815:GetBoundingBox()
            local v822 = v815:GetPivot()
            local v823 = {}
            for v824, v825 in v815:GetDescendants() do
                if v825:IsA("BasePart") then
                    v810(v823, v822:ToObjectSpace(v825.CFrame))
                end
            end
            v809 = {
                Source = v812,
                Model = v815,
                Lift = v822.Position.Y - (v820.Position.Y - v821.Y / 2),
                Height = v821.Y,
                Offsets = v823,
                Count = #v823
            }
        end
        return v809
    end

    local v826 = {}
    local v827
    local v828 = {}
    local v829 = {}

    local function stepSpikes() -- line 2304 | captures: v827, TweenService, Workspace, Attacks, v826, v828, v829
        local Spikes = Attacks.Spikes
        local v830 = os.clock()
        table.clear(v828)
        table.clear(v829)
        local v831 = 1
        while v831 <= #v826 do
            local v832 = v826[v831]
            local v833 = v830 - v832.Born
            if v832.Model.Parent then
                local v834, v835
                if v833 < Spikes.RiseTime then
                    local Down = v832.Down
                    local Up = v832.Up
                    local v836 = TweenService:GetValue(v833 / Spikes.RiseTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    v834 = Down + (Up - Down) * v836
                    v835 = false
                elseif v833 < Spikes.RiseTime + Spikes.Hold then
                    if v832.Settled then
                    else
                        v832.Settled = true
                        v834 = v832.Up
                    end
                    v835 = false
                elseif v833 < Spikes.RiseTime + Spikes.Hold + Spikes.SinkTime then
                    local v837 = (v833 - Spikes.RiseTime - Spikes.Hold) / Spikes.SinkTime
                    local Up = v832.Up
                    local Down = v832.Down
                    local v838 = TweenService:GetValue(v837, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    v834 = Up + (Down - Up) * v838
                    v835 = false
                else
                    v835 = true
                end
                if v835 then
                    v832.Model:Destroy()
                    v826[v831] = v826[#v826]
                    v826[#v826] = nil
                else
                    v831 += 1
                    if v834 then
                        local v839 = CFrame.new(v832.X, v834, v832.Z) * v832.Turn
                        for v840, v841 in v832.Parts do
                            table.insert(v828, v841)
                            local v842 = v839 * v832.Offsets[v840]
                            table.insert(v829, v842)
                        end
                    end
                end
            else
                v826[v831] = v826[#v826]
                v826[#v826] = nil
            end
        end
        if #v828 > 0 then
            Workspace:BulkMoveTo(v828, v829, Enum.BulkMoveMode.FireCFrameChanged)
        end
        if #v826 == 0 and v827 then
            v827:Disconnect()
            v827 = nil
        end
    end

    local function erupt(v843) -- line 2355 | captures: v5, v827, RunService, Workspace, preparedSpikes, v826, stepSpikes
        local v844 = preparedSpikes()
        if not v844 then
            return
        end
        local v845 = v844.Model:Clone()
        local v846 = {}
        for v847, v848 in v845:GetDescendants() do
            if v848:IsA("BasePart") then
                table.insert(v846, v848)
            end
        end
        if #v846 == v844.Count then
            local v849 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
            local v850 = v843.Y + v844.Lift - v844.Height - 0.5
            local v851 = v843.Y + v844.Lift - 0.4
            v845:PivotTo(CFrame.new(v843.X, v850, v843.Z) * v849)
            local Folder
            if not (v5 and v5.Parent) then
                Folder = Instance.new("Folder")
                Folder.Name = "HellBossFX"
                Folder.Parent = Workspace
                v5 = Folder
            else
                Folder = v5
            end
            v845.Parent = Folder
            local v852 = {
                Model = v845,
                Parts = v846,
                Offsets = v844.Offsets,
                X = v843.X,
                Z = v843.Z,
                Turn = v849,
                Down = v850,
                Up = v851,
                Born = os.clock()
            }
            table.insert(v826, v852)
            v827 = v827 or RunService.RenderStepped:Connect(stepSpikes)
        else
            v845:Destroy()
        end
    end

    local function spikeFx(v853, v854) -- line 2395 | captures: v3, Workspace, HellBossConfig, EggLandImpact, Visuals, Attacks, Sfx, playSfx, shakeFrom, myFeet, reportHit, indicator, floorLook, erupt
        local Spikes = Attacks.Spikes
        local Id = v854.Id
        local Start = v854.Start

        local function v855() -- line 2398 | captures: v853, v854, Workspace, HellBossConfig, Sfx, playSfx
            local v856 = playSfx(Sfx.SpikeRumble, v853.Root.Position)
            if not v856 then
                return
            end
            local delay = task.delay
            local v857 = v854.Start + HellBossConfig.SpikeImpactTime(1, #v854.Targets) - Workspace:GetServerTimeNow()
            delay(math.max(v857, 0) + 0.3, function() -- line 2401 | captures: v856
                v856:Stop()
            end)
        end

        local v858 = Start - Workspace:GetServerTimeNow()
        if not (v858 < -0.3) then
            task.delay(math.max(v858, 0), function() -- line 419 | captures: v853, Id, v855, v3
                if not (v3 ~= v853 or v853.AttackId ~= Id and v853.SideAttackId ~= Id) then
                    v855()
                end
            end)
        end
        for v859, v860 in v854.Targets do
            local X = v860.X
            local FloorY = v853.FloorY
            local Z = v860.Z
            local v861 = Vector3.new(X, FloorY, Z)
            local v862 = v854.Start + HellBossConfig.SpikeImpactTime(v859, #v854.Targets)
            local Id = v854.Id
            local Start = v854.Start
            local v863 = v862 - v854.Start

            local v864 = function() -- line 2409 | captures: v854, Spikes, v861, v862, indicator
                indicator(v861, Spikes.Radius, v854.Start, v862, true)
            end

            local v865 = Start - Workspace:GetServerTimeNow()
            if not (v865 < -v863) then
                task.delay(math.max(v865, 0), function() -- line 419 | captures: v853, Id, v864, v3
                    if not (v3 ~= v853 or v853.AttackId ~= Id and v853.SideAttackId ~= Id) then
                        v864()
                    end
                end)
            end
            local Id_2 = v854.Id
            local v866 = v859

            local v867 = function() -- line 2412 | captures: v853, v854, Spikes, v861, v866, v3, EggLandImpact, Visuals, Sfx, playSfx, shakeFrom, myFeet, reportHit, floorLook, erupt
                erupt(v861)
                if v866 % 5 == 1 then
                    playSfx(Sfx.SpikeRise, v861)
                    playSfx(Sfx.SpikeCrack, v861)
                    local v868 = v853.FxScale * 0.3
                    local v869 = v853.FxScale * 0.8
                    local v870, v871, v872 = floorLook(v861)
                    EggLandImpact.Chunks(v861, v868, v869, v872)
                    task.delay(Spikes.RiseTime + Spikes.Hold, function() -- line 2420 | captures: v853, v861, v3, Sfx, playSfx
                        if v3 == v853 then
                            playSfx(Sfx.SpikeSink, v861)
                        end
                    end)
                end
                shakeFrom(v861, Visuals.MeteorShake)
                local v873, v874 = myFeet(v853.FloorY)
                if not v873 then
                    return
                end
                local v875 = v873.Position - v861
                local X = v875.X
                local Z = v875.Z
                if Vector3.new(X, 0, Z).Magnitude <= Spikes.Radius + 1.5 and v874 < Spikes.HitHeight then
                    reportHit(v854.Id, v866)
                end
            end

            local v876 = v862 - Workspace:GetServerTimeNow()
            if not (v876 < -0.3) then
                task.delay(math.max(v876, 0), function() -- line 419 | captures: v853, Id_2, v867, v3
                    if not (v3 ~= v853 or v853.AttackId ~= Id_2 and v853.SideAttackId ~= Id_2) then
                        v867()
                    end
                end)
            end
        end
    end

    local function minionFx(v877, v878) -- line 2437 | captures: v3, v5, Players, Workspace, HellEventConfig, SpatialSfx, VFXBurst, LocalPlayer, Visuals, HellMinions, HellMinionRoar, Attacks, Sfx, now, v13, playSfx, shakeFrom, myFeet, reportHit
        local Minions = Attacks.Minions
        local v879 = v878.Start + Minions.Cast
        local v880 = Workspace:GetServerTimeNow()
        if not (v879 + Minions.Fuse.Max < v880) then
            local v881 = v877.Model:GetAttribute(v878.MinionsAttr or "AttackMinions")
            if type(v881) == "string" then
                local v882 = {}
                local v883 = 0
                for v884 in string.gmatch(v881, "[^;]+") do
                    v883 += 1
                    local v885, v886, v887 = string.match(v884, "^(.-)|(%-?%d+)|([%d%.]+)$")
                    local v888 = v878.Targets[v883]
                    if v885 and v888 then
                        local v889 = {
                            Index = v883,
                            Animal = v885,
                            Target = Players:GetPlayerByUserId((tonumber(v886))),
                            From = v888
                        }
                        v889.ExplodeAt = v879 + (tonumber(v887) or Minions.Fuse.Min)
                        table.insert(v882, v889)
                    end
                end
                local Id = v878.Id
                local Id_2 = v878.Id
                local Start = v878.Start

                local function v890() -- line 2464 | captures: v877, Sfx, playSfx
                    playSfx(Sfx.MinionSummon, v877.Root)
                end

                local v891 = Start - Workspace:GetServerTimeNow()
                if not (v891 < -0.3) then
                    task.delay(math.max(v891, 0), function() -- line 419 | captures: v877, Id_2, v890, v3
                        if not (v3 ~= v877 or v877.AttackId ~= Id_2 and v877.SideAttackId ~= Id_2) then
                            v890()
                        end
                    end)
                end
                local v892 = HellMinionRoar.Pick(v882)
                if v892 then
                    local Id = v878.Id

                    local function v893() -- line 2470 | captures: v892, HellEventConfig, SpatialSfx, LocalPlayer, HellMinionRoar, Sfx, v13
                        if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) ~= true then
                            return
                        end
                        local Track = v13.Track
                        local Play = HellMinionRoar.Play
                        local v894 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                        local v895 = v894 and v894.SoundGroup
                        Track(Play(v892, v895))
                    end

                    local v896 = v879 - Workspace:GetServerTimeNow()
                    if not (v896 < -0.5) then
                        task.delay(math.max(v896, 0), function() -- line 419 | captures: v877, Id, v893, v3
                            if not (v3 ~= v877 or v877.AttackId ~= Id and v877.SideAttackId ~= Id) then
                                v893()
                            end
                        end)
                    end
                end
                local Spawn = HellMinions.Spawn
                local v897 = {}
                local Folder
                if not (v5 and v5.Parent) then
                    Folder = Instance.new("Folder")
                    Folder.Name = "HellBossFX"
                    Folder.Parent = Workspace
                    v5 = Folder
                else
                    Folder = v5
                end
                v897.Parent = Folder
                v897.Map = Workspace:FindFirstChild(HellEventConfig.MapName)
                v897.FloorY = v877.FloorY
                v897.Now = now

                function v897.Alive() -- line 2481 | captures: v877, v3, HellEventConfig, LocalPlayer
                    if v3 == v877 and v877.Phase == "Active" then
                        return LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
                    end
                    return false
                end

                function v897.MyFeet() -- line 2484 | captures: v877, myFeet
                    return myFeet(v877.FloorY)
                end

                function v897.Report(v898, v899) -- line 2487 | captures: Id, reportHit
                    reportHit(Id, v898, v899)
                end

                function v897.Puff(v900) -- line 2490 | captures: VFXBurst, Visuals, Sfx, playSfx
                    VFXBurst.Play(Visuals.SmokeName, CFrame.new(v900), Visuals.Minion.SpawnSmokeScale)
                    playSfx(Sfx.MinionSpawn, v900)
                end

                function v897.Beep(v901) -- line 2494 | captures: Sfx, playSfx
                    playSfx(Sfx.MinionBeep, v901)
                end

                function v897.Blast(v902) -- line 2497 | captures: VFXBurst, Visuals, Sfx, playSfx, shakeFrom
                    VFXBurst.Play(Visuals.BlastName, CFrame.new(v902), Visuals.Minion.BlastScale, Visuals.Minion.FlashColor)
                    playSfx(Sfx.MinionBoom, v902)
                    shakeFrom(v902, Visuals.Minion.BlastShake, Visuals.Minion.BlastShakeRadius)
                end

                Spawn(v897, v882, v879)
            end
        end
    end

    local function parseTargets(v903) -- line 2505
        local v904 = {}
        if type(v903) == "string" then
            for v905 in string.gmatch(v903, "[^;]+") do
                local v906, v907, v908 = string.match(v905, "^([%-%d%.]+),([%-%d%.]+),([%-%d%.]+)$")
                if v906 then
                    local v909 = tonumber(v906)
                    local v910 = tonumber(v907)
                    local v911 = tonumber(v908)
                    local v912 = Vector3.new(v909, v910, v911)
                    table.insert(v904, v912)
                end
            end
        end
        return v904
    end

    local function readAttack(v913) -- line 2519 | captures: v3, v228, Workspace, HellBossConfig, HellEventConfig, BoneFlail, LocalPlayer, Attacks, Dialogue, stompAt, tripleStompFx, slamFx, weaponSlamFx, meteorFx, spikeFx, minionFx, parseTargets
        local Model = v913.Model
        local AttackId = Model:GetAttribute("AttackId")
        if type(AttackId) ~= "number" or AttackId == v913.AttackId then
            return
        end
        v913.AttackId = AttackId
        local AttackKind = Model:GetAttribute("AttackKind")
        local AttackStart = Model:GetAttribute("AttackStart")
        local AttackFrom = Model:GetAttribute("AttackFrom")
        local AttackTo = Model:GetAttribute("AttackTo")
        if not (type(AttackKind) == "string" and type(AttackStart) == "number" and typeof(AttackFrom) == "CFrame" and typeof(AttackTo) == "CFrame") then
            return
        end
        local v914 = parseTargets(Model:GetAttribute("AttackTargets"))
        local v915 = {
            Id = AttackId,
            Kind = AttackKind,
            Start = AttackStart,
            Length = HellBossConfig.AttackLength(AttackKind, #v914),
            From = AttackFrom,
            To = AttackTo,
            Targets = v914
        }
        local v916 = Workspace:GetServerTimeNow()
        if not (v915.Start + v915.Length < v916) then
            v913.Attack = v915
            v913.TurnFrom = v913.Root.CFrame
            if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                for v917, v918 in HellBossConfig.CodeMoves or {} do
                    if v918.Attack == AttackKind then
                        local v919 = v913.CodePoses[v917]
                        if not v919 then
                            v919 = BoneFlail.new(Model, v913.Root, v918.Moves)
                            v913.CodePoses[v917] = v919
                        end
                        v913.CodeMove = {
                            Pose = v919,
                            Spec = v918,
                            Start = AttackStart
                        }
                    end
                end
                local Length = v915.Length

                local function v920() -- line 2563 | captures: v913, AttackKind, AttackStart, Workspace, HellBossConfig
                    local v921 = Workspace:GetServerTimeNow() - AttackStart
                    local v922 = HellBossConfig.Moves[AttackKind]
                    if v922 then
                        v913.Tracks:Play(v922, Workspace:GetServerTimeNow() - math.max(v921, 0))
                    else
                        v913.Tracks:Stop()
                    end
                end

                local v923 = AttackStart - Workspace:GetServerTimeNow()
                if not (v923 < -Length) then
                    task.delay(math.max(v923, 0), function() -- line 419 | captures: v913, AttackId, v920, v3
                        if not (v3 ~= v913 or v913.AttackId ~= AttackId and v913.SideAttackId ~= AttackId) then
                            v920()
                        end
                    end)
                end
                if Workspace:GetServerTimeNow() - AttackStart < 0.6 then
                    v228(AttackKind, Dialogue.AttackChance)
                end
                if AttackKind == "Stomp" then
                    stompAt(v913, v915, v915.Start + Attacks.Stomp.Windup)
                elseif AttackKind == "TripleStomp" then
                    tripleStompFx(v913, v915)
                elseif AttackKind == "Minions" then
                    minionFx(v913, v915)
                elseif AttackKind == "Spikes" then
                    spikeFx(v913, v915)
                elseif AttackKind == "Slam" then
                    slamFx(v913, v915)
                elseif AttackKind == "Meteor" then
                    meteorFx(v913, v915)
                end
                weaponSlamFx(v913, v915)
            end
        end
    end

    local function readSideAttack(v924) -- line 2587 | captures: Workspace, HellBossConfig, HellEventConfig, LocalPlayer, meteorFx, spikeFx, minionFx, parseTargets
        local Model = v924.Model
        local SideAttackId = Model:GetAttribute("SideAttackId")
        if type(SideAttackId) ~= "number" or SideAttackId == v924.SideAttackId then
            return
        end
        v924.SideAttackId = SideAttackId
        local SideAttackKind = Model:GetAttribute("SideAttackKind")
        local SideAttackStart = Model:GetAttribute("SideAttackStart")
        local SideAttackFrom = Model:GetAttribute("SideAttackFrom")
        local SideAttackTo = Model:GetAttribute("SideAttackTo")
        if not (type(SideAttackKind) == "string" and type(SideAttackStart) == "number" and typeof(SideAttackFrom) == "CFrame" and typeof(SideAttackTo) == "CFrame") then
            return
        end
        local v925 = parseTargets(Model:GetAttribute("SideAttackTargets"))
        local v926 = {
            MinionsAttr = "SideAttackMinions",
            Id = SideAttackId,
            Kind = SideAttackKind,
            Start = SideAttackStart,
            Length = HellBossConfig.AttackLength(SideAttackKind, #v925),
            From = SideAttackFrom,
            To = SideAttackTo,
            Targets = v925
        }
        local v927 = Workspace:GetServerTimeNow()
        if not (v926.Start + v926.Length < v927) and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
            if SideAttackKind == "Minions" then
                minionFx(v924, v926)
            elseif SideAttackKind == "Spikes" then
                spikeFx(v924, v926)
            elseif SideAttackKind == "Meteor" then
                meteorFx(v924, v926)
            end
        end
    end

    local function readEnrage(v928) -- line 2628 | captures: v228, Workspace, HellBossConfig, HellEventConfig, VFXBurst, LocalPlayer, Visuals, Sfx, playSfx, shakeFrom
        local Enrage = v928.Model:GetAttribute("Enrage")
        if type(Enrage) ~= "number" then
            return
        end
        local EnrageStage = v928.EnrageStage
        v928.EnrageStage = Enrage
        if Enrage <= EnrageStage or not (LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true) then
            return
        end
        v228((("Enrage%*"):format(Enrage)))
        local v929 = Workspace:GetServerTimeNow()
        local Attack = v928.Attack
        if not (Attack ~= nil and v929 < Attack.Start + Attack.Length) then
            local Roar = HellBossConfig.Moves.Roar
            if Roar then
                v928.Tracks:Play(Roar, Workspace:GetServerTimeNow() - 0)
            else
                v928.Tracks:Stop()
            end
        end
        playSfx(Sfx.Roar, v928.Root)
        VFXBurst.Play(Visuals.BlastName, CFrame.new(v928.Root.Position), Visuals.RoarBlastScale, Visuals.Meteor.Color)
        shakeFrom(v928.Root.Position, Visuals.RoarShake)
    end

    local function stunOff(v930) -- line 2654 | captures: TweenService
        local Stun = v930.Stun
        if not Stun then
            return
        end
        v930.Stun = nil
        Stun.Connection:Disconnect()
        Stun.Folder:Destroy()
        local Gui = Stun.Gui
        if not Gui then
            return
        end
        local v931 = Gui:FindFirstChild("Banner") and Gui.Banner:FindFirstChildOfClass("UIScale")
        if v931 then
            TweenService:Create(v931, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0 }):Play()
        end
        local Arrow = Gui:FindFirstChild("Arrow")
        if Arrow then
            Arrow.Visible = false
        end
        task.delay(0.22, function() -- line 2673 | captures: Gui
            Gui:Destroy()
        end)
    end

    local function stunScreen(v932, v933) -- line 2681 | captures: TweenService, Workspace, HellBossConfig, HellEventConfig, LocalPlayer, Visuals, Cutscene
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if PlayerGui and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
            local Stun = Visuals.Stun
            local Font = Cutscene.Title.Font
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "HellBossStunUI"
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = 40
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            local Frame = Instance.new("Frame")
            Frame.Name = "Banner"
            Frame.AnchorPoint = Vector2.new(0.5, 0)
            Frame.Position = UDim2.fromScale(0.5, 0.17)
            Frame.Size = UDim2.fromScale(0.26, 0.1)
            Frame.BackgroundTransparency = 1
            Frame.Parent = ScreenGui
            local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
            UIAspectRatioConstraint.AspectRatio = 5
            UIAspectRatioConstraint.Parent = Frame
            local UIScale = Instance.new("UIScale")
            UIScale.Scale = 0
            UIScale.Parent = Frame
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "Title"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.fromScale(1, 0.46)
            TextLabel.FontFace = Font
            TextLabel.Text = Stun.BannerTitle
            TextLabel.TextScaled = true
            TextLabel.TextColor3 = Color3.new(1, 1, 1)
            TextLabel.Parent = Frame
            local UIGradient = Instance.new("UIGradient")
            UIGradient.Rotation = -90
            UIGradient.Color = ColorSequence.new(Stun.BannerColors[1], Stun.BannerColors[2])
            UIGradient.Parent = TextLabel
            local UIStroke = Instance.new("UIStroke")
            UIStroke.Thickness = 3
            UIStroke.Parent = TextLabel
            local TextLabel_2 = Instance.new("TextLabel")
            TextLabel_2.Name = "Sub"
            TextLabel_2.BackgroundTransparency = 1
            TextLabel_2.Position = UDim2.fromScale(0, 0.48)
            TextLabel_2.Size = UDim2.fromScale(1, 0.27)
            TextLabel_2.FontFace = Font
            TextLabel_2.Text = Stun.BannerSub
            TextLabel_2.TextScaled = true
            TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
            TextLabel_2.Parent = Frame
            local UIStroke_2 = Instance.new("UIStroke")
            UIStroke_2.Thickness = 2
            UIStroke_2.Parent = TextLabel_2
            local TextLabel_3 = Instance.new("TextLabel")
            TextLabel_3.Name = "Time"
            TextLabel_3.BackgroundTransparency = 1
            TextLabel_3.Position = UDim2.fromScale(0, 0.77)
            TextLabel_3.Size = UDim2.fromScale(1, 0.23)
            TextLabel_3.FontFace = Font
            TextLabel_3.TextScaled = true
            TextLabel_3.TextColor3 = Stun.Color
            TextLabel_3.Parent = Frame
            local UIStroke_3 = Instance.new("UIStroke")
            UIStroke_3.Thickness = 1.5
            UIStroke_3.Parent = TextLabel_3
            local Frame_2 = Instance.new("Frame")
            Frame_2.Name = "Arrow"
            Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame_2.Size = UDim2.fromOffset(Stun.ArrowSize, Stun.ArrowSize)
            Frame_2.BackgroundTransparency = 1
            Frame_2.Parent = ScreenGui
            local TextLabel_4 = Instance.new("TextLabel")
            TextLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel_4.Position = UDim2.fromScale(0.5, 0.5)
            TextLabel_4.Size = UDim2.fromScale(1, 1)
            TextLabel_4.BackgroundTransparency = 1
            TextLabel_4.Text = "\226\150\178"
            TextLabel_4.TextScaled = true
            TextLabel_4.TextColor3 = Stun.Color
            TextLabel_4.Parent = Frame_2
            local UIStroke_4 = Instance.new("UIStroke")
            UIStroke_4.Thickness = 3
            UIStroke_4.Parent = TextLabel_4
            local TextLabel_5 = Instance.new("TextLabel")
            TextLabel_5.AnchorPoint = Vector2.new(0.5, 0)
            TextLabel_5.Position = UDim2.new(0.5, 0, 1, 2)
            TextLabel_5.Size = UDim2.fromOffset(Stun.ArrowSize * 2, Stun.ArrowSize * 0.4)
            TextLabel_5.BackgroundTransparency = 1
            TextLabel_5.FontFace = Font
            TextLabel_5.TextScaled = true
            TextLabel_5.TextColor3 = Color3.new(1, 1, 1)
            TextLabel_5.Parent = Frame_2
            local UIStroke_5 = Instance.new("UIStroke")
            UIStroke_5.Thickness = 2
            UIStroke_5.Parent = TextLabel_5
            ScreenGui.Parent = PlayerGui
            TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

            local function update() -- line 2788 | captures: v932, v933, Stun, TextLabel, TextLabel_2, TextLabel_3, Frame_2, TextLabel_4, TextLabel_5, Workspace, HellBossConfig, LocalPlayer
                local CurrentCamera = Workspace.CurrentCamera
                local v934
                if v933 then
                    local v935 = v933 - Workspace:GetServerTimeNow()
                    v934 = math.max(v935, 0)
                else
                    v934 = 0
                end
                TextLabel_3.Text = string.format("%.1fs left", v934)
                local v936 = os.clock() * 6
                TextLabel.Rotation = math.sin(v936) * 1.5
                local Character = LocalPlayer.Character
                local v937 = Character and Character:FindFirstChild("HumanoidRootPart")
                if CurrentCamera and v937 and v937:IsA("BasePart") then
                    local ShieldsUp = v932.Model:GetAttribute("ShieldsUp")
                    if not (type(ShieldsUp) == "number" and ShieldsUp > 0) then
                        local v938 = v932.Root.Position - v937.Position
                        local X = v938.X
                        local Z = v938.Z
                        local Magnitude = Vector3.new(X, 0, Z).Magnitude
                        local v939 = Magnitude <= HellBossConfig.BatHitRadius
                        local v940 = if v939 then Stun.BannerInRange else Stun.BannerSub
                        TextLabel_2.Text = v940
                        local v941
                        if v939 then
                            v941 = Stun.Color
                        else
                            v941 = Color3.new(1, 1, 1)
                        end
                        TextLabel_2.TextColor3 = v941
                        if v939 then
                            Frame_2.Visible = false
                        else
                            Frame_2.Visible = true
                            TextLabel_5.Text = ("%*m"):format((math.floor(Magnitude)))
                            local ViewportSize = CurrentCamera.ViewportSize
                            local v942, v943 = CurrentCamera:WorldToViewportPoint(v932.Root.Position + Vector3.new(0, 1, 0) * (v932.Height * 0.75))
                            local ArrowMargin = Stun.ArrowMargin
                            if v943 and ArrowMargin < v942.X and v942.X < ViewportSize.X - ArrowMargin and ArrowMargin < v942.Y and v942.Y < ViewportSize.Y - ArrowMargin then
                                local v944 = os.clock() * 5
                                local v945 = math.sin(v944) * 8
                                Frame_2.Position = UDim2.fromOffset(v942.X, v942.Y - Stun.ArrowSize - 20 + v945)
                                TextLabel_4.Rotation = 180
                            else
                                local v946 = ViewportSize / 2
                                local v947 = Vector2.new(v942.X, v942.Y) - v946
                                if v942.Z < 0 then
                                    v947 = -v947
                                end
                                if v947.Magnitude < 1 then
                                    v947 = Vector2.new(0, -1)
                                end
                                local Unit = v947.Unit
                                local v948 = v946.X - ArrowMargin
                                local v949 = v946.Y - ArrowMargin
                                local X = Unit.X
                                local v950
                                if math.abs(X) > 0.001 then
                                    local X = Unit.X
                                    v950 = v948 / math.abs(X)
                                else
                                    v950 = (1/0)
                                end
                                local Y = Unit.Y
                                local v951
                                if math.abs(Y) > 0.001 then
                                    local Y = Unit.Y
                                    v951 = v949 / math.abs(Y)
                                else
                                    v951 = (1/0)
                                end
                                local v952 = v946 + Unit * math.min(v950, v951)
                                Frame_2.Position = UDim2.fromOffset(v952.X, v952.Y)
                                local Y_2 = Unit.Y
                                local X_2 = Unit.X
                                local v953 = math.atan2(Y_2, X_2)
                                TextLabel_4.Rotation = math.deg(v953) + 90
                            end
                        end
                    else
                        TextLabel_2.Text = string.format(Stun.BannerShielded, ShieldsUp)
                        TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
                        Frame_2.Visible = false
                    end
                else
                    Frame_2.Visible = false
                end
            end

            update()
            return ScreenGui, update
        end
        return nil, nil
    end

    local function stunOn(v954) -- line 2853 | captures: v5, RunService, Workspace, LocalPlayer, Visuals, Cutscene, newPart, stunOff, stunScreen
        stunOff(v954)
        local Stun = Visuals.Stun
        local Head = v954.Model:FindFirstChild("Head")
        local Folder = Instance.new("Folder")
        Folder.Name = "Stun"
        local v955 = {}
        local Stars = Stun.Stars
        for v956 = 1, Stars do
            v955[v956] = newPart({
                Shape = Enum.PartType.Ball,
                Color = Stun.Color,
                Size = Vector3.new(1, 1, 1) * Stun.StarSize,
                Parent = Folder
            })
        end
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "StunnedLabel"
        local v957 = if not (Head and Head:IsA("BasePart")) then v954.Root else Head
        BillboardGui.Adornee = v957
        BillboardGui.Size = UDim2.fromScale(46, 16)
        BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 20, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.LightInfluence = 0
        BillboardGui.MaxDistance = 3000
        local TextLabel = Instance.new("TextLabel")
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 0.62)
        TextLabel.FontFace = Cutscene.Title.Font
        TextLabel.Text = Stun.Text
        TextLabel.TextScaled = true
        TextLabel.TextColor3 = Stun.Color
        TextLabel.Parent = BillboardGui
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 3
        UIStroke.Parent = TextLabel
        local TextLabel_2 = Instance.new("TextLabel")
        TextLabel_2.BackgroundTransparency = 1
        TextLabel_2.Position = UDim2.fromScale(0, 0.62)
        TextLabel_2.Size = UDim2.fromScale(1, 0.38)
        TextLabel_2.FontFace = Cutscene.Title.Font
        TextLabel_2.TextScaled = true
        TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
        TextLabel_2.Parent = BillboardGui
        local UIStroke_2 = Instance.new("UIStroke")
        UIStroke_2.Thickness = 2
        UIStroke_2.Parent = TextLabel_2
        local UIScale = Instance.new("UIScale")
        UIScale.Parent = BillboardGui
        BillboardGui.ResetOnSpawn = false
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not PlayerGui then
            if not (v5 and v5.Parent) then
                PlayerGui = Instance.new("Folder")
                PlayerGui.Name = "HellBossFX"
                PlayerGui.Parent = Workspace
                v5 = PlayerGui
            else
                PlayerGui = v5
            end
        end
        BillboardGui.Parent = PlayerGui
        Folder.Destroying:Connect(function() -- line 2902 | captures: BillboardGui
            BillboardGui:Destroy()
        end)
        local Folder_2
        if not (v5 and v5.Parent) then
            Folder_2 = Instance.new("Folder")
            Folder_2.Name = "HellBossFX"
            Folder_2.Parent = Workspace
            v5 = Folder_2
        else
            Folder_2 = v5
        end
        Folder.Parent = Folder_2
        local PhaseEnd = v954.Model:GetAttribute("PhaseEnd")
        local v958 = if type(PhaseEnd) == "number" then PhaseEnd else nil
        local v959, v960 = stunScreen(v954, v958)
        local RenderStepped = RunService.RenderStepped
        v954.Stun = {
            Folder = Folder,
            Connection = RenderStepped:Connect(function() -- line 2909 | captures: v954, Stun, Head, v955, TextLabel_2, UIScale, PhaseEnd, v960, Workspace
                if v960 then
                    v960()
                end
                local v961 = os.clock()
                local v962 = if not (Head and Head:IsA("BasePart")) then v954.Root.Position + Vector3.new(0, 1, 0) * v954.Height * 0.55 else Head.Position + Vector3.new(0, 1, 0) * (Head.Size.Y * 0.9)
                for v963, v964 in v955 do
                    local v965 = v961 * Stun.StarSpeed + (v963 - 1) / #v955 * 3.141592653589793 * 2
                    local v966 = v961 * 3 + v963
                    local v967 = math.sin(v966) * 1.2
                    local new = CFrame.new
                    local v968 = math.cos(v965) * Stun.StarOrbit
                    local v969 = math.sin(v965) * Stun.StarOrbit
                    v964.CFrame = new(v962 + Vector3.new(v968, v967, v969))
                end
                local v970 = v961 * 9
                UIScale.Scale = math.sin(v970) * 0.07 + 1
                local v971
                if type(PhaseEnd) == "number" then
                    local v972 = PhaseEnd - Workspace:GetServerTimeNow()
                    v971 = math.max(v972, 0)
                else
                    v971 = 0
                end
                TextLabel_2.Text = string.format("%s  %.1fs", Stun.SubText, v971)
            end),
            Gui = v959
        }
    end

    local function hitStrength(v973) -- line 2931 | captures: TweenService, Visuals
        local HitFlash = Visuals.HitFlash
        local v974 = os.clock() - v973.HitAt
        if v974 < 0 or HitFlash.Time <= v974 then
            return 0
        end
        if v974 < HitFlash.FadeIn then
            local v975 = TweenService:GetValue(v974 / HitFlash.FadeIn, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            return v973.HitFrom + (1 - v973.HitFrom) * v975
        end
        local v976 = (v974 - HitFlash.FadeIn) / (HitFlash.Time - HitFlash.FadeIn)
        return 1 - TweenService:GetValue(v976, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    end

    local function updateHighlight(v977) -- line 2947 | captures: Visuals, hitStrength
        local HitHighlight = v977.HitHighlight
        local v978 = hitStrength(v977)
        if v978 > 0.001 then
            HitHighlight.FillTransparency = (Visuals.HitFlash.Transparency - 1) * v978 + 1
            if not HitHighlight.Enabled then
                HitHighlight.Adornee = v977.Model
                HitHighlight.Enabled = true
            end
        elseif HitHighlight.Enabled then
            HitHighlight.Enabled = false
            HitHighlight.Adornee = nil
        end
    end

    local function hitSound(v979, v980) -- line 2964 | captures: EggConfig, SpatialSfx, Sfx
        local Hit = EggConfig.Hit
        local Play = SpatialSfx.Play
        local SoundFolder = Hit.SoundFolder
        local SoundName = Hit.SoundName
        local v981 = {
            Range = 400,
            MinRange = 60,
            Mine = v980
        }
        if v980 then
            v981.At = nil
        else
            v981.At = v979.Root
        end
        local v982 = Play(SoundFolder, SoundName, v981)
        local v983, v984
        if v982 then
            if v982.SoundGroup then
                v984 = true
            else
                local v985 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                v983 = v985 and v985.SoundGroup
                v984 = false
            end
        else
            v984 = true
        end
        if not v984 then
            v982.SoundGroup = v983
        end
    end

    local function hitFeedback(v986, v987, v988) -- line 2978 | captures: hitStrength, hitSound
        v986.HitFrom = hitStrength(v986)
        v986.HitAt = os.clock()
        hitSound(v986, v987)
    end

    local v989 = {}

    local function onHitPulse(v990) -- line 2991 | captures: v228, Players, EggConfig, SpatialSfx, LocalPlayer, Sfx, playSfx, Dialogue, hitStrength, v989
        local HitPulse = v990.Model:GetAttribute("HitPulse")
        if type(HitPulse) ~= "number" then
            return
        end
        local LastHitPulse = v990.LastHitPulse
        v990.LastHitPulse = HitPulse
        if HitPulse <= LastHitPulse then
            return
        end
        v228("Hurt", Dialogue.HurtChance, true)
        local BossHurt = Sfx.BossHurt
        local v991 = os.clock() - (v990.LastGrowl or 0)
        if BossHurt.Gap < v991 and math.random() < BossHurt.Chance then
            v990.LastGrowl = os.clock()
            playSfx(BossHurt, v990.Root)
        end
        if v990.Model:GetAttribute("HitBy") == LocalPlayer.UserId then
            local v992 = os.clock()
            while v989[1] and v992 - v989[1] > 1.5 do
                table.remove(v989, 1)
            end
            if v989[1] then
                table.remove(v989, 1)
            else
                v990.HitFrom = hitStrength(v990)
                v990.HitAt = os.clock()
                local Hit = EggConfig.Hit
                local v993 = SpatialSfx.Play(Hit.SoundFolder, Hit.SoundName, {
                    Mine = true,
                    At = nil,
                    Range = 400,
                    MinRange = 60
                })
                local v994, v995
                if v993 then
                    if v993.SoundGroup then
                        v995 = true
                    else
                        local v996 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                        v994 = v996 and v996.SoundGroup
                        v995 = false
                    end
                else
                    v995 = true
                end
                if not v995 then
                    v993.SoundGroup = v994
                end
            end
        else
            local HitBy = v990.Model:GetAttribute("HitBy")
            if type(HitBy) == "number" then
                Players:GetPlayerByUserId(HitBy)
            end
            v990.HitFrom = hitStrength(v990)
            v990.HitAt = os.clock()
            local Hit = EggConfig.Hit
            local v997 = SpatialSfx.Play(Hit.SoundFolder, Hit.SoundName, {
                Mine = false,
                Range = 400,
                MinRange = 60,
                At = v990.Root
            })
            local v998, v999
            if v997 then
                if v997.SoundGroup then
                    v999 = true
                else
                    local v1000 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                    v998 = v1000 and v1000.SoundGroup
                    v999 = false
                end
            else
                v999 = true
            end
            if not v999 then
                v997.SoundGroup = v998
            end
        end
    end

    local function findShield(v1001) -- line 3025 | captures: Workspace, HellBossConfig, HellEventConfig, ShieldModel
        local v1002 = Workspace:FindFirstChild(HellEventConfig.MapName)
        local v1003 = v1002 and v1002:FindFirstChild(HellBossConfig.Shields.Folder)
        if v1003 then
            for v1004, v1005 in v1003:GetChildren() do
                if v1005:GetAttribute("ShieldIndex") == v1001 then
                    return v1005, ShieldModel.HitPart(v1005)
                end
            end
        end
        return nil, nil
    end

    local function flashShield(v1006) -- line 3040 | captures: TweenService, HellBossConfig
        local HitFlash = HellBossConfig.Shields.HitFlash
        local ShieldHitFlash = v1006:FindFirstChild("ShieldHitFlash")
        local ShieldHitFlash_2 = ShieldHitFlash
        if not (ShieldHitFlash and ShieldHitFlash:IsA("Highlight")) then
            ShieldHitFlash = Instance.new("Highlight")
            ShieldHitFlash_2 = ShieldHitFlash
            ShieldHitFlash.Name = "ShieldHitFlash"
            ShieldHitFlash.FillColor = HitFlash.Color
            ShieldHitFlash.OutlineColor = HitFlash.Color
            ShieldHitFlash.OutlineTransparency = 1
            ShieldHitFlash.DepthMode = Enum.HighlightDepthMode.Occluded
            ShieldHitFlash.Parent = v1006
        end
        ShieldHitFlash.FillTransparency = HitFlash.Transparency
        ShieldHitFlash.Adornee = v1006
        ShieldHitFlash.Enabled = true
        local v1007 = TweenService:Create(ShieldHitFlash, TweenInfo.new(HitFlash.Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FillTransparency = 1 })
        v1007.Completed:Once(function(v1008) -- line 3058 | captures: ShieldHitFlash_2
            if v1008 == Enum.PlaybackState.Completed and ShieldHitFlash_2.Parent then
                ShieldHitFlash_2.Enabled = false
                ShieldHitFlash_2.Adornee = nil
            end
        end)
        v1007:Play()
    end

    local function onShieldHit(v1009) -- line 3072 | captures: v228, Players, EggConfig, HellBossConfig, SpatialSfx, VFXBurst, LocalPlayer, Visuals, Sfx, playSfx, shakeFrom, Dialogue, findShield, flashShield
        local ShieldHitPulse = v1009.Model:GetAttribute("ShieldHitPulse")
        if type(ShieldHitPulse) ~= "number" then
            return
        end
        local LastShieldPulse = v1009.LastShieldPulse
        v1009.LastShieldPulse = ShieldHitPulse
        if ShieldHitPulse <= LastShieldPulse then
            return
        end
        local ShieldHitIndex = v1009.Model:GetAttribute("ShieldHitIndex")
        local v1010, v1011
        if type(ShieldHitIndex) == "number" then
            v1010, v1011 = findShield(ShieldHitIndex)
        end
        local v1012
        if v1010 and v1011 then
            local ShieldHitBy = v1009.Model:GetAttribute("ShieldHitBy")
            if type(ShieldHitBy) == "number" then
                v1012 = Players:GetPlayerByUserId(ShieldHitBy)
            end
        else
            return
        end
        local v1013 = v1012 == LocalPlayer
        flashShield(v1010)
        local Hit = EggConfig.Hit
        local Play = SpatialSfx.Play
        local SoundFolder = Hit.SoundFolder
        local SoundName = Hit.SoundName
        local v1014 = {
            Range = 400,
            MinRange = 60,
            Mine = v1013
        }
        if v1013 then
            v1014.At = nil
        else
            v1014.At = v1011
        end
        local v1015 = Play(SoundFolder, SoundName, v1014)
        local v1016, v1017
        if v1015 then
            if v1015.SoundGroup then
                v1017 = true
            else
                local v1018 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                v1016 = v1018 and v1018.SoundGroup
                v1017 = false
            end
        else
            v1017 = true
        end
        if not v1017 then
            v1015.SoundGroup = v1016
        end
        local v1019 = v1009.Model:GetAttribute((("ShieldHealth%*"):format(ShieldHitIndex)))
        if type(v1019) == "number" and v1019 <= 0 then
            local ShieldsUp = v1009.Model:GetAttribute("ShieldsUp")
            local v1020 = v228
            local v1021 = if type(ShieldsUp) == "number" and ShieldsUp <= 0 then "ShieldsDown" else "ShieldBroken"
            v1020(v1021)
            if type(ShieldsUp) == "number" and ShieldsUp <= 0 then
                playSfx(Sfx.ShieldsDown, v1011.Position)
            end
        else
            v228("ShieldHit", Dialogue.ShieldHitChance, true)
        end
        if type(v1019) == "number" and v1019 <= 0 then
            local Shields = HellBossConfig.Shields
            VFXBurst.Play(Visuals.BlastName, CFrame.new(v1011.Position), Shields.BreakScale, Shields.BreakColor)
            playSfx(Shields.BreakSound, v1011.Position)
            shakeFrom(v1011.Position, 2)
        end
    end

    function v1.CanBatHit() -- line 3128 | captures: v3, Workspace, HellBossConfig, HellEventConfig, LocalPlayer, Attacks, myFeet
        local v1022 = v3
        if not (not v1022 or v1022.Phase ~= "Stunned" and v1022.Phase ~= "Active") and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
            local Health = v1022.Model:GetAttribute("Health")
            if not (type(Health) == "number" and Health <= 0) then
                local ShieldsUp = v1022.Model:GetAttribute("ShieldsUp")
                if not (type(ShieldsUp) == "number" and ShieldsUp > 0) then
                    local AttackStart = v1022.Model:GetAttribute("AttackStart")
                    if v1022.Model:GetAttribute("AttackKind") == "Slam" and type(AttackStart) == "number" then
                        local v1023 = Workspace:GetServerTimeNow()
                        if AttackStart + Attacks.Slam.Crouch <= v1023 and Workspace:GetServerTimeNow() < AttackStart + HellBossConfig.SlamImpactTime() then
                            return false
                        end
                    end
                    local v1024 = myFeet(v1022.FloorY)
                    if v1024 then
                        local v1025 = v1024.Position - v1022.Root.Position
                        local X = v1025.X
                        local Z = v1025.Z
                        if Vector3.new(X, 0, Z).Magnitude <= HellBossConfig.BatHitRadius then
                            return true
                        end
                        local BodyMin = v1022.Model:GetAttribute("BodyMin")
                        local BodyMax = v1022.Model:GetAttribute("BodyMax")
                        if typeof(BodyMin) == "Vector3" and typeof(BodyMax) == "Vector3" then
                            local v1026 = v1022.Root.CFrame:PointToObjectSpace(v1024.Position)
                            local v1027 = BodyMin.X - v1026.X
                            local v1028 = v1026.X - BodyMax.X
                            local v1029 = math.max(v1027, v1028, 0)
                            local v1030 = BodyMin.Z - v1026.Z
                            local v1031 = v1026.Z - BodyMax.Z
                            local v1032 = math.max(v1030, v1031, 0)
                            local v1033 = v1029 * v1029 + v1032 * v1032
                            return math.sqrt(v1033) <= (HellBossConfig.BatHitReach or 0)
                        end
                    end
                end
            end
            return false
        end
        return false
    end

    function v1.PredictBatHit() -- line 3172 | captures: v3, EggConfig, SpatialSfx, v1, Sfx, hitStrength, v989
        local function v1034(v1035, ...)
            table.insert(v1035, ...)
        end

        local v1036 = v3
        if not (v1036 and v1.CanBatHit()) then
            return
        end
        v1034(v989, os.clock())
        v1036.HitFrom = hitStrength(v1036)
        v1036.HitAt = os.clock()
        local Hit = EggConfig.Hit
        local v1037 = SpatialSfx.Play(Hit.SoundFolder, Hit.SoundName, {
            Mine = true,
            At = nil,
            Range = 400,
            MinRange = 60
        })
        if v1037 and not v1037.SoundGroup then
            local v1038 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
            v1037.SoundGroup = v1038 and v1038.SoundGroup
        end
    end

    local function atDefeat(v1039, v1040, v1041, v1042) -- line 3183 | captures: v3, Workspace, Defeat
        local v1043 = v1040 + v1041 - Workspace:GetServerTimeNow()
        if v1043 < -0.5 then
            return
        end
        task.delay(math.max(v1043, 0), function() -- line 3188 | captures: v1039, v1040, v1042, v3, Defeat
            if v3 == v1039 and v1039.Phase == "Defeated" and v1039.PhaseStart + Defeat.BreakTime == v1040 then
                v1042()
            end
        end)
    end

    local function defeatCrack(v1044, v1045) -- line 3200 | captures: v3, v5, ReplicatedStorage, RunService, TweenService, Workspace, ViewportStencil, ViewportStencilConfig, Visuals, Defeat
        local Stencil = Defeat.Stencil
        local v1046 = ViewportStencilConfig.Stencils[Stencil.Name]
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local v1047 = Assets and Assets:FindFirstChild(ViewportStencilConfig.AssetsFolderName)
        local v1048 = v1046 and v1047 and v1047:FindFirstChild(v1046.Model)
        if v1048 and v1048:IsA("Model") then
            local LookVector = v1044.Rest.LookVector
            local X = LookVector.X
            local Z = LookVector.Z
            local v1049 = Vector3.new(X, 0, Z)
            local v1050
            if v1049.Magnitude > 0.001 then
                v1050 = v1049.Unit
            else
                v1050 = Vector3.new(0, 0, -1)
            end
            local X_2 = v1044.Rest.X
            local FloorY = v1044.FloorY
            local Z_2 = v1044.Rest.Z
            local v1051 = Vector3.new(X_2, FloorY, Z_2) - v1050 * (v1044.Height * 0.5)
            local v1052 = CFrame.new(v1051.X, v1044.FloorY, v1051.Z) * CFrame.lookAt(Vector3.new(0, 0, 0), v1050).Rotation
            local Angles = CFrame.Angles
            local v1053 = Stencil.Yaw or 0
            local v1054 = v1052 * Angles(0, math.rad(v1053), 0)
            local v1055 = v1048:Clone()
            local v1056, v1057 = v1055:GetBoundingBox()
            local v1058 = v1055:GetScale() * Stencil.Size
            local X_3 = v1057.X
            local Z_3 = v1057.Z
            local v1059 = v1058 / math.max(X_3, Z_3, 0.01)
            v1055:ScaleTo(v1059)
            local v1060 = table.clone(v1046.Options or {})
            local v1061, v1062 = pcall(ViewportStencil.new, v1055, v1054, v1060)
            if v1061 then
                local _modelOffset = v1062._modelOffset
                local v1063 = v1062:getSize()
                local v1064, PointLight
                local v1065 = v1046.VFX and v1047:FindFirstChild(v1046.VFX)
                local v1066 = {}
                local v1067 = Vector3.new(1, 1, 1)
                if v1065 and v1065:IsA("BasePart") then
                    local v1068 = v1065:Clone()
                    v1068.CFrame = v1054
                    v1067 = v1068.Size
                    for v1069, v1070 in v1068:GetDescendants() do
                        if v1070:IsA("ParticleEmitter") then
                            v1070.Enabled = false
                            table.insert(v1066, v1070)
                        end
                    end
                    local PointLight_2 = Instance.new("PointLight")
                    PointLight_2.Name = "CrackGlow"
                    PointLight_2.Color = Visuals.Meteor.Color
                    PointLight_2.Range = 60
                    PointLight_2.Brightness = 0
                    PointLight_2.Parent = v1068
                    local Folder
                    if not (v5 and v5.Parent) then
                        Folder = Instance.new("Folder")
                        Folder.Name = "HellBossFX"
                        Folder.Parent = Workspace
                        v5 = Folder
                    else
                        Folder = v5
                    end
                    v1068.Parent = Folder
                    v1064 = v1068
                    PointLight = PointLight_2
                end

                local function setOpen(v1071) -- line 3257 | captures: v1064, v1067, Stencil, v1054, v1055, v1059, v1062, _modelOffset, v1063
                    local v1072 = math.max(v1071, 0.02)
                    v1055:ScaleTo(v1059 * v1072)
                    v1062._modelOffset = CFrame.new(_modelOffset.Position * v1072) * _modelOffset.Rotation
                    v1062:setSize(v1063 * v1072)
                    if not v1064 then
                        return
                    end
                    local v1073 = v1064
                    local v1074 = v1067.X * v1072 * Stencil.Size / 20
                    local Y = v1067.Y
                    local v1075 = v1067.Z * v1072 * Stencil.Size / 20
                    v1073.Size = Vector3.new(v1074, Y, v1075)
                    v1064.CFrame = v1054
                end

                setOpen(0)
                v1062:setTransparency(1)
                local v1076 = false
                local v1077 = -1
                local v1078
                v1078 = RunService.RenderStepped:Connect(function() -- line 3273 | captures: v1064, PointLight, v1076, v1077, v1078, v1044, v1045, Stencil, v1062, v1066, setOpen, v3, TweenService, Workspace, Defeat
                    local v1079 = Workspace:GetServerTimeNow() - v1045
                    local v1080, v1081, v1082
                    if v3 == v1044 and v1044.Phase == "Defeated" then
                        if Defeat.CloseAt + Defeat.CloseTime + 0.2 < v1079 then
                            v1082 = true
                        else
                            local v1083 = Defeat.OpenAt + Defeat.OpenTime
                            local v1084 = (v1079 - Defeat.CrackAt) / (v1083 - Defeat.CrackAt)
                            local v1085 = TweenService:GetValue(math.clamp(v1084, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                            local v1086 = (v1079 - Defeat.CloseAt) / Defeat.CloseTime
                            local v1087 = math.clamp(v1086, 0, 1)
                            v1080 = v1087 * v1087 * (3 - v1087 * 2)
                            if v1079 < Defeat.CrackAt then
                                v1081 = 0
                            else
                                local StartShare = Stencil.StartShare
                                v1081 = StartShare + (1 - StartShare) * v1085
                            end
                            v1082 = false
                        end
                    else
                        v1082 = true
                    end
                    if not v1082 then
                        local v1088 = v1081 * (1 - v1080)
                        local v1089 = v1088 - v1077
                        if math.abs(v1089) > 0.002 then
                            v1077 = v1088
                            setOpen(v1088)
                        end
                        if v1079 < Defeat.CrackAt then
                            v1080 = 1
                        end
                        v1062:setTransparency(v1080)
                        local v1090 = if Defeat.CrackAt <= v1079 then v1079 < Defeat.CloseAt else false
                        if v1090 ~= v1076 then
                            v1076 = v1090
                            for v1091, v1092 in v1066 do
                                v1092.Enabled = v1090
                            end
                        end
                        if PointLight then
                            PointLight.Brightness = v1088 * 5
                        end
                    else
                        v1078:Disconnect()
                        v1062:destroy()
                        if v1064 then
                            v1064:Destroy()
                        end
                    end
                end)
            else
                warn((("[HellBossController] couldn't make the crack stencil: %*"):format(v1062)))
            end
        else
            warn((("[HellBossController] stencil \"%*\" template missing (ReplicatedStorage.Assets.%*)"):format(Stencil.Name, ViewportStencilConfig.AssetsFolderName)))
        end
    end

    local function screamText(v1093, v1094) -- line 3308 | captures: v5, RunService, TweenService, Workspace, LocalPlayer, Cutscene, v447, Defeat
        local Head = v447.Find(v1093, "Head")
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "Scream"
        if not (Head and (Head:IsA("BasePart") or Head:IsA("Attachment"))) then
            Head = v1093.Root
        end
        BillboardGui.Adornee = Head
        BillboardGui.Size = UDim2.fromScale(44, 14)
        BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 14, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.LightInfluence = 0
        BillboardGui.MaxDistance = 3000
        local TextLabel = Instance.new("TextLabel")
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        TextLabel.Position = UDim2.fromScale(0.5, 0.5)
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.BackgroundTransparency = 1
        TextLabel.FontFace = Cutscene.Title.Font
        TextLabel.Text = Defeat.ScreamText
        TextLabel.TextScaled = true
        TextLabel.TextColor3 = Color3.fromRGB(255, 60, 40)
        TextLabel.Parent = BillboardGui
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 3
        UIStroke.Parent = TextLabel
        local UIScale = Instance.new("UIScale")
        UIScale.Scale = 0
        UIScale.Parent = BillboardGui
        BillboardGui.ResetOnSpawn = false
        local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not PlayerGui then
            if not (v5 and v5.Parent) then
                PlayerGui = Instance.new("Folder")
                PlayerGui.Name = "HellBossFX"
                PlayerGui.Parent = Workspace
                v5 = PlayerGui
            else
                PlayerGui = v5
            end
        end
        BillboardGui.Parent = PlayerGui
        TweenService:Create(UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        local v1095
        v1095 = RunService.RenderStepped:Connect(function() -- line 3338 | captures: v1095, v1094, BillboardGui, TextLabel, Workspace
            local v1096 = Workspace:GetServerTimeNow()
            if v1094 < v1096 or not BillboardGui.Parent then
                v1095:Disconnect()
                BillboardGui:Destroy()
            else
                TextLabel.Rotation = (math.random() - 0.5) * 8
                TextLabel.Position = UDim2.fromScale(0.5 + (math.random() - 0.5) * 0.03, 0.5 + (math.random() - 0.5) * 0.05)
            end
        end)
    end

    local v1097

    local function getDefeatMusic() -- line 3351 | captures: v1097, SoundService, SpatialSfx, Defeat
        if v1097 and v1097.Parent then
            return v1097
        end
        local v1098 = SpatialSfx.Find(Defeat.Music.Folder, Defeat.Music.Name)
        if v1098 then
            local v1099 = v1098:Clone()
            v1099.Name = "HellBossDefeatMusic"
            v1099.Parent = SoundService
            v1097 = v1099
            return v1099
        end
        return nil
    end

    local function playDefeatCutscene(v1100, v1101) -- line 3368 | captures: v3, RunService, Workspace, HellEventConfig, CinematicMode, LocalPlayer, Cutscene, Defeat
        local CurrentCamera = Workspace.CurrentCamera
        local Character = LocalPlayer.Character
        local v1102 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v1103, v1104
        if CurrentCamera and v1102 and v1102:IsA("BasePart") then
            if CinematicMode.IsActive() then
                v1104 = true
            else
                local LookVector = v1100.Rest.LookVector
                local X = LookVector.X
                local Z = LookVector.Z
                local v1105 = Vector3.new(X, 0, Z)
                if v1105.Magnitude > 0.001 then
                    v1103 = v1105.Unit
                else
                    v1103 = Vector3.new(0, 0, -1)
                end
                v1104 = false
            end
        else
            v1104 = true
        end
        if v1104 then
            return
        end
        local X = v1100.Rest.X
        local FloorY = v1100.FloorY
        local Z = v1100.Rest.Z
        local v1106 = Vector3.new(X, FloorY, Z) - v1103 * (v1100.Height * 0.5)
        local v1107 = v1103:Cross((Vector3.new(0, 1, 0)))
        local Height = v1100.Height
        local Shots = Defeat.Shots
        local v1108 = v1103

        local function around(v1109, v1110) -- line 3379 | captures: v1106, v1107, Height, v1108
            local Angle = v1109.Angle
            local v1111 = math.rad(Angle)
            local v1112 = v1108 * math.cos(v1111) + v1107 * math.sin(v1111)
            return v1106 + v1112 * ((v1109.Distance - (v1110 or 0)) * Height) + Vector3.new(0, 1, 0) * (v1109.Up * Height)
        end

        local function focusOf(v1113) -- line 3385
            local v1114 = v1113.Parent and v1113.Parent:FindFirstChildOfClass("Humanoid")
            local v1115
            if v1114 then
                v1115 = v1114.CameraOffset
            else
                v1115 = Vector3.new(0, 0, 0)
            end
            return v1113.Position + Vector3.new(0, 1.5, 0) + v1115
        end

        local Position = CurrentCamera.CFrame.Position
        local v1116 = v1102.Parent and v1102.Parent:FindFirstChildOfClass("Humanoid")
        local v1117
        if v1116 then
            v1117 = v1116.CameraOffset
        else
            v1117 = Vector3.new(0, 0, 0)
        end
        local v1118 = Position - (v1102.Position + Vector3.new(0, 1.5, 0) + v1117)

        local function home(v1119) -- line 3391 | captures: v1118
            local v1120 = v1119.Parent and v1119.Parent:FindFirstChildOfClass("Humanoid")
            local v1121
            if v1120 then
                v1121 = v1120.CameraOffset
            else
                v1121 = Vector3.new(0, 0, 0)
            end
            local v1122 = v1119.Position + Vector3.new(0, 1.5, 0) + v1121
            return CFrame.lookAt(v1122 + v1118, v1122)
        end

        local CameraType = CurrentCamera.CameraType
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CinematicMode.Enter(Cutscene)
        local v1123 = Defeat.CameraEnd + Defeat.Return
        local BindableEvent = Instance.new("BindableEvent")
        local v1124 = false

        local function finish() -- line 3403 | captures: v1124, CurrentCamera, v1118, CameraType, BindableEvent, RunService, CinematicMode, LocalPlayer
            if v1124 then
                return
            end
            v1124 = true
            RunService:UnbindFromRenderStep("HellBossDefeatCutscene")
            local v1125 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v1125 and v1125:IsA("BasePart") then
                local v1126 = v1125.Parent and v1125.Parent:FindFirstChildOfClass("Humanoid")
                local v1127
                if v1126 then
                    v1127 = v1126.CameraOffset
                else
                    v1127 = Vector3.new(0, 0, 0)
                end
                local v1128 = v1125.Position + Vector3.new(0, 1.5, 0) + v1127
                CurrentCamera.CFrame = CFrame.lookAt(v1128 + v1118, v1128)
            end
            local v1129 = if CameraType == Enum.CameraType.Scriptable then Enum.CameraType.Custom else CameraType
            CurrentCamera.CameraType = v1129
            CinematicMode.Exit()
            BindableEvent:Fire()
        end

        local v1130 = 0
        local v1131 = CurrentCamera.CFrame.Position
        local v1132 = CurrentCamera.CFrame.Position
        local v1133 = CurrentCamera.CFrame
        local Value = Enum.RenderPriority.Camera.Value
        RunService:BindToRenderStep("HellBossDefeatCutscene", Value, function(v1134) -- line 3421 | captures: v1130, v1131, v1132, v1133, v1100, v1101, CurrentCamera, v1106, v1107, Height, Shots, v1108, v1118, v1123, finish, v3, Workspace, HellEventConfig, LocalPlayer, Cutscene, Defeat
            local v1135 = Workspace:GetServerTimeNow() - v1101
            local v1136 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v3 == v1100 and v1100.Phase == "Defeated" and v1136 and v1136:IsA("BasePart") and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                local v1137, v1138, v1139
                if v1135 < Defeat.CrackAt then
                    local Fall = Shots.Fall
                    local Angle = Fall.Angle
                    local v1140 = math.rad(Angle)
                    local v1141 = v1108 * math.cos(v1140) + v1107 * math.sin(v1140)
                    v1138, v1139, v1137 = v1106 + v1141 * ((Fall.Distance - 0) * Height) + Vector3.new(0, 1, 0) * (Fall.Up * Height), v1100.Root.Position:Lerp(v1106 + Vector3.new(0, 1, 0) * (Height * 0.1), 0.35), 1
                elseif v1135 < Defeat.DropAt then
                    local v1142 = (v1135 - Defeat.CrackAt) / (Defeat.DropAt - Defeat.CrackAt)
                    local v1143 = math.clamp(v1142, 0, 1)
                    local v1144 = v1143 * v1143 * (3 - v1143 * 2)
                    local Crack = Shots.Crack
                    local v1145 = Shots.Crack.PushIn * v1144
                    local Angle = Crack.Angle
                    local v1146 = math.rad(Angle)
                    local v1147 = v1108 * math.cos(v1146) + v1107 * math.sin(v1146)
                    v1138 = v1106 + v1147 * ((Crack.Distance - (v1145 or 0)) * Height) + Vector3.new(0, 1, 0) * (Crack.Up * Height)
                    v1139 = v1106
                    v1137 = 2
                elseif v1135 < Defeat.CameraEnd then
                    local Drop = Shots.Drop
                    local Angle = Drop.Angle
                    local v1148 = math.rad(Angle)
                    local v1149 = v1108 * math.cos(v1148) + v1107 * math.sin(v1148)
                    v1138, v1139, v1137 = v1106 + v1149 * ((Drop.Distance - 0) * Height) + Vector3.new(0, 1, 0) * (Drop.Up * Height), v1106 - Vector3.new(0, 1, 0) * (Height * 0.15), 3
                else
                    if v1135 < v1123 then
                        local v1150 = (v1135 - Defeat.CameraEnd) / Defeat.Return
                        local v1151 = math.clamp(v1150, 0, 1)
                        local v1152 = v1151 * v1151 * (3 - v1151 * 2)
                        local v1153 = v1133
                        local v1154 = v1136.Parent and v1136.Parent:FindFirstChildOfClass("Humanoid")
                        local v1155
                        if v1154 then
                            v1155 = v1154.CameraOffset
                        else
                            v1155 = Vector3.new(0, 0, 0)
                        end
                        local v1156 = v1136.Position + Vector3.new(0, 1.5, 0) + v1155
                        CurrentCamera.CFrame = v1153:Lerp(CFrame.lookAt(v1156 + v1118, v1156), v1152)
                    else
                        finish()
                    end
                    return
                end
                if v1137 ~= v1130 then
                    v1130 = v1137
                    v1131 = v1138
                    v1132 = v1139
                end
                local v1157 = -Cutscene.Smoothing * v1134
                local v1158 = 1 - math.exp(v1157)
                v1131 = v1131:Lerp(v1138, v1158)
                v1132 = v1132:Lerp(v1139, v1158)
                v1133 = CFrame.lookAt(v1131, v1132)
                CurrentCamera.CFrame = v1133
            else
                finish()
            end
        end)
        local delay = task.delay
        local v1159 = v1101 + v1123 - Workspace:GetServerTimeNow()
        delay(math.max(v1159, 0) + Cutscene.SafetyGrace, finish)
        BindableEvent.Event:Wait()
        BindableEvent:Destroy()
    end

    local function startDefeat(v1160) -- line 3470 | captures: v3, v228, v1097, SoundService, Workspace, HellBossConfig, HellEventConfig, EggLandImpact, SpatialSfx, VFXBurst, MusicController, LocalPlayer, Visuals, Sfx, v13, playSfx, shakeFrom, Defeat, floorLook, defeatCrack, screamText, playDefeatCutscene
        local v1161 = v1160.PhaseStart + Defeat.BreakTime
        local v1162 = Workspace:GetServerTimeNow() - v1161
        local LookVector = v1160.Rest.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v1163 = Vector3.new(X, 0, Z)
        local v1164
        if v1163.Magnitude > 0.001 then
            v1164 = v1163.Unit
        else
            v1164 = Vector3.new(0, 0, -1)
        end
        local X_2 = v1160.Rest.X
        local FloorY = v1160.FloorY
        local Z_2 = v1160.Rest.Z
        local v1165 = Vector3.new(X_2, FloorY, Z_2) - v1164 * (v1160.Height * 0.5)
        if v1162 >= 0 then
            local Defeated = HellBossConfig.Moves.Defeated
            if Defeated then
                v1160.Tracks:Play(Defeated, Workspace:GetServerTimeNow() - math.max(v1162, 0))
            else
                v1160.Tracks:Stop()
            end
        else
            local Stunned = HellBossConfig.Moves.Stunned
            if Stunned then
                v1160.Tracks:Play(Stunned, Workspace:GetServerTimeNow() - 0)
            else
                v1160.Tracks:Stop()
            end

            local function v1166() -- line 3481 | captures: v1160, v1161, Workspace, HellBossConfig
                local v1167 = Workspace:GetServerTimeNow() - v1161
                local Defeated = HellBossConfig.Moves.Defeated
                if Defeated then
                    v1160.Tracks:Play(Defeated, Workspace:GetServerTimeNow() - math.max(v1167, 0))
                else
                    v1160.Tracks:Stop()
                end
            end

            local v1168 = v1161 + 0 - Workspace:GetServerTimeNow()
            if not (v1168 < -0.5) then
                task.delay(math.max(v1168, 0), function() -- line 3188 | captures: v1160, v1161, v1166, v3, Defeat
                    if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                        v1166()
                    end
                end)
            end
        end
        if v1162 < 1 then
            v228("Defeat")
        end
        local v1169
        if not (v1097 and v1097.Parent) then
            local v1170 = SpatialSfx.Find(Defeat.Music.Folder, Defeat.Music.Name)
            if v1170 then
                v1169 = v1170:Clone()
                v1169.Name = "HellBossDefeatMusic"
                v1169.Parent = SoundService
                v1097 = v1169
            end
        else
            v1169 = v1097
        end
        if v1169 then
            MusicController.SetHellOverride(v1169)
        end
        if v1162 < Defeat.CloseAt then
            defeatCrack(v1160, v1161)
        end
        local v1171 = Defeat.StaggerTime + Defeat.FallTime

        local function v1172() -- line 3500 | captures: v1160, v1165, EggLandImpact, VFXBurst, Visuals, playSfx, shakeFrom, Defeat, floorLook
            VFXBurst.Play(Visuals.SmokeName, CFrame.new(v1165), Visuals.LeapSmokeScale * 1.4)
            local v1173 = v1160.FxScale * 0.6
            local v1174 = v1160.FxScale * 2
            local v1175, v1176, v1177 = floorLook(v1165)
            EggLandImpact.Chunks(v1165, v1173, v1174, v1177)
            playSfx(Defeat.Thud, v1165)
            shakeFrom(v1165, Visuals.SlamShake)
        end

        local v1178 = v1161 + v1171 - Workspace:GetServerTimeNow()
        if not (v1178 < -0.5) then
            task.delay(math.max(v1178, 0), function() -- line 3188 | captures: v1160, v1161, v1172, v3, Defeat
                if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                    v1172()
                end
            end)
        end
        local v1179 = Defeat.CrackAt
        local v1180
        while true do
            if v1179 < Defeat.OpenAt + Defeat.OpenTime then
                function v1180() -- line 3509 | captures: v1165, playSfx, shakeFrom, Defeat
                    playSfx(Defeat.Rumble, v1165)
                    shakeFrom(v1165, 2)
                end

                local v1181 = v1161 + v1179 - Workspace:GetServerTimeNow()
                if not (v1181 < -0.5) then
                    task.delay(math.max(v1181, 0), function() -- line 3188 | captures: v1160, v1161, v1180, v3, Defeat
                        if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                            v1180()
                        end
                    end)
                end
            else
                break
            end
            v1179 += Defeat.RumbleEvery
        end
        local v1182 = Defeat.OpenAt + Defeat.OpenTime

        local function v1183() -- line 3516 | captures: v1165, VFXBurst, Visuals, playSfx, shakeFrom, Defeat
            VFXBurst.Play(Visuals.BlastName, CFrame.new(v1165), Visuals.RoarBlastScale, Visuals.Meteor.Color)
            playSfx(Defeat.Open, v1165)
            shakeFrom(v1165, Visuals.SlamShake)
        end

        local v1184 = v1161 + v1182 - Workspace:GetServerTimeNow()
        if not (v1184 < -0.5) then
            task.delay(math.max(v1184, 0), function() -- line 3188 | captures: v1160, v1161, v1183, v3, Defeat
                if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                    v1183()
                end
            end)
        end
        local ScreamAt = Defeat.ScreamAt

        local function v1185() -- line 3522 | captures: v1160, v1161, v228, SpatialSfx, Sfx, v13, Defeat, screamText
            local Scream = Defeat.Scream
            local v1186 = v13.Track(SpatialSfx.Play(Scream.Folder, Scream.Name, {
                At = v1160.Root,
                Range = Scream.Range,
                MinRange = Scream.MinRange,
                RollOffMode = Enum.RollOffMode.Linear
            }))
            local v1187, v1188
            if v1186 then
                if v1186.SoundGroup then
                    v1188 = true
                else
                    local v1189 = SpatialSfx.Find(Sfx.Folder, Sfx.Slam.Name)
                    v1187 = v1189 and v1189.SoundGroup
                    v1188 = false
                end
            else
                v1188 = true
            end
            if not v1188 then
                v1186.SoundGroup = v1187
            end
            screamText(v1160, v1161 + Defeat.DropAt + Defeat.DropTime)
            v228("Scream")
        end

        local v1190 = v1161 + ScreamAt - Workspace:GetServerTimeNow()
        if not (v1190 < -0.5) then
            task.delay(math.max(v1190, 0), function() -- line 3188 | captures: v1160, v1161, v1185, v3, Defeat
                if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                    v1185()
                end
            end)
        end
        local v1191 = Defeat.DropAt + Defeat.DropTime * 0.7

        local function v1192() -- line 3537 | captures: v1165, VFXBurst, Visuals, shakeFrom
            VFXBurst.Play(Visuals.BlastName, CFrame.new(v1165), Visuals.SlamBlastScale, Visuals.Meteor.Color)
            shakeFrom(v1165, Visuals.SlamShake)
        end

        local v1193 = v1161 + v1191 - Workspace:GetServerTimeNow()
        if not (v1193 < -0.5) then
            task.delay(math.max(v1193, 0), function() -- line 3188 | captures: v1160, v1161, v1192, v3, Defeat
                if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                    v1192()
                end
            end)
        end
        local CloseAt = Defeat.CloseAt

        local function v1194() -- line 3541 | captures: v1165, playSfx, shakeFrom, Defeat
            playSfx(Defeat.Thud, v1165)
            shakeFrom(v1165, 2)
        end

        local v1195 = v1161 + CloseAt - Workspace:GetServerTimeNow()
        if not (v1195 < -0.5) then
            task.delay(math.max(v1195, 0), function() -- line 3188 | captures: v1160, v1161, v1194, v3, Defeat
                if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                    v1194()
                end
            end)
        end
        local TitleAt = Defeat.TitleAt

        local function v1196() -- line 3545 | captures: v228, HellEventConfig, LocalPlayer
            if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                v228("Fallen")
            end
        end

        local v1197 = v1161 + TitleAt - Workspace:GetServerTimeNow()
        if not (v1197 < -0.5) then
            task.delay(math.max(v1197, 0), function() -- line 3188 | captures: v1160, v1161, v1196, v3, Defeat
                if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                    v1196()
                end
            end)
        end
        if not (LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and v1162 < 1.5) then
            return
        end
        local delay = task.delay
        local v1198 = -v1162
        delay(math.max(v1198, 0), function() -- line 3554 | captures: v1160, v1161, v3, Defeat, playDefeatCutscene
            if v3 == v1160 and v1160.Phase == "Defeated" and v1160.PhaseStart + Defeat.BreakTime == v1161 then
                playDefeatCutscene(v1160, v1161)
            end
        end)
    end

    local function readPhase(v1199) -- line 3562 | captures: v3, v5, v228, Workspace, HellBossConfig, HellEventConfig, HellSummonCutscene, VFXBurst, MusicController, LocalPlayer, v1, Visuals, Sfx, playSfx, shakeFrom, Dialogue, hushDialogue, setFade, stunOff, stunOn, startDefeat
        local Model = v1199.Model
        local v1200 = Model:GetAttribute("Phase") or "Idle"
        local PhaseStart = Model:GetAttribute("PhaseStart")
        if type(PhaseStart) ~= "number" then
            PhaseStart = Workspace:GetServerTimeNow()
        end
        v1199.PhaseStart = PhaseStart
        if v1200 == v1199.Phase then
            return
        end
        local Phase = v1199.Phase
        v1199.Phase = v1200
        if Phase == "Stunned" then
            stunOff(v1199)
        end
        if Phase == "Defeated" then
            setFade(v1199, 0)
        end
        if v1200 == "Gather" then
            setFade(v1199, 1)
            HellSummonCutscene.SetPylonsDormant(true)
        elseif Phase == "Gather" then
            if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and v1200 == "Intro" and v1.PlayIntro then
                task.defer(v1.PlayIntro)
            else
                setFade(v1199, 0)
                HellSummonCutscene.SetPylonsDormant(false)
            end
        end
        if v1200 == "Stunned" then
            local Stunned = HellBossConfig.Moves.Stunned
            if Stunned then
                v1199.Tracks:Play(Stunned, Workspace:GetServerTimeNow() - 0)
            else
                v1199.Tracks:Stop()
            end
            stunOn(v1199)
            v228("Stunned")
            local Head = Model:FindFirstChild("Head")
            if Head and Head:IsA("BasePart") then
                VFXBurst.Play(Visuals.SmokeName, CFrame.new(Head.Position), Visuals.LeapSmokeScale * 0.6, Visuals.Stun.Color)
            end
        elseif v1200 == "Defeated" then
            startDefeat(v1199)
        elseif v1200 == "Failed" then
            if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                local Roar = HellBossConfig.Moves.Roar
                if Roar then
                    v1199.Tracks:Play(Roar, Workspace:GetServerTimeNow() - 0)
                else
                    v1199.Tracks:Stop()
                end
                v228("Failed")
                playSfx(Sfx.Roar, v1199.Root)
                VFXBurst.Play(Visuals.BlastName, CFrame.new(v1199.Root.Position), Visuals.RoarBlastScale, Visuals.Meteor.Color)
                shakeFrom(v1199.Root.Position, Visuals.RoarShake)
            end
        elseif Phase == "Stunned" or Phase == "Defeated" then
            v1199.Tracks:Stop(0.35)
        end
        if Phase == "Stunned" and v1200 == "Active" then
            v228("Recover")
        end
        v1199.TauntToken += 1
        if v1200 == "Active" then
            if Phase == "Intro" then
                v228("FightStart")
            end
            local TauntToken = v1199.TauntToken
            task.spawn(function() -- line 3630 | captures: v1199, TauntToken, v3, v228, Dialogue
                while true do
                    task.wait(math.random() * (Dialogue.TauntEvery.Max - Dialogue.TauntEvery.Min) + Dialogue.TauntEvery.Min)
                    if v3 == v1199 and v1199.TauntToken == TauntToken and v1199.Phase == "Active" then
                        v228("Taunt", nil, true)
                        continue
                    end
                    break
                end
            end)
        end
        local SetSummoned = HellSummonCutscene.SetSummoned
        local v1201 = if v1200 == "Idle" then false else v1200 ~= "Gather"
        SetSummoned(v1201)
        if v1200 ~= "Intro" and v1200 ~= "Idle" then
            return
        end
        MusicController.SetHellOverride(nil)
        hushDialogue()
        v1199.SaidLow = false
        v1199.SaidHalf = false
        v1199.SaidThreeQuarter = false
        v1199.Attack = nil
        v1199.Move = nil
        v1199.NextMove = nil
        local StopFly = v1199.StopFly
        v1199.StopFly = nil
        if StopFly then
            StopFly()
        end
        if v5 then
            v5:ClearAllChildren()
        end
    end

    local function summonLanding(v1202, v1203) -- line 3663 | captures: Workspace, EggLandImpact, VFXBurst, Visuals, Sfx, playSfx, ring, floorLook, crater
        VFXBurst.Play(Visuals.BlastName, CFrame.new(v1203), Visuals.SlamBlastScale, Visuals.Indicator.Color)
        VFXBurst.Play(Visuals.SmokeName, CFrame.new(v1203), Visuals.LeapSmokeScale * 1.5)
        local v1204 = v1202.FxScale * 0.8
        local v1205 = v1202.FxScale * 2.4
        local v1206, v1207, v1208 = floorLook(v1203)
        EggLandImpact.Chunks(v1203, v1204, v1205, v1208)
        crater(v1203, Visuals.Crater.Radius, Visuals.Crater.Blocks)
        ring(v1203, Workspace:GetServerTimeNow(), 10, 260, 320, 3, 6)
        playSfx(Sfx.Slam, v1203)
    end

    local function roar(v1209, v1210) -- line 3672 | captures: Workspace, VFXBurst, Visuals, Sfx, playSfx, shakeFrom, ring
        VFXBurst.Play(Visuals.BlastName, CFrame.new(v1210), Visuals.RoarBlastScale, Visuals.Outline)
        ring(v1210, Workspace:GetServerTimeNow(), 10, 260, 320, 3, 6)
        playSfx(Sfx.Roar, v1209.Root)
        shakeFrom(v1210, Visuals.RoarShake)
    end

    local function playCutscene(v1211) -- line 3681 | captures: v3, v228, Workspace, HellBossConfig, HellEventConfig, HellSummonCutscene, LocalPlayer, sfxGroup, shakeFrom, effects, setFade, summonLanding, roar
        local Play = HellSummonCutscene.Play
        local v1212 = {
            LockReason = "HellBossIntro",
            Model = v1211.Model,
            Root = v1211.Root,
            Height = v1211.Height,
            FloorY = v1211.FloorY
        }
        local Rest = v1211.Rest
        v1212.Rest = CFrame.new(Rest.X, v1211.FloorY + v1211.HipOffset, Rest.Z) * Rest.Rotation

        function v1212.IsAlive() -- line 3688 | captures: v1211, v3, HellEventConfig, LocalPlayer
            if v3 == v1211 then
                if v1211.Model.Parent == nil then
                    return false
                end
                return LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
            end
            return false
        end

        function v1212.SetOverride(v1213) -- line 3691 | captures: v1211
            v1211.Override = v1213
        end

        function v1212.SetFade(v1214) -- line 3694 | captures: v1211, setFade
            setFade(v1211, v1214)
        end

        function v1212.PlayMove(v1215, v1216) -- line 3697 | captures: v1211, Workspace
            v1211.Tracks:Play(v1215, Workspace:GetServerTimeNow() - v1216)
        end

        function v1212.PlayClip(v1217, v1218) -- line 3700 | captures: v1211, Workspace, HellBossConfig
            local v1219 = HellBossConfig.Moves[v1217]
            if v1219 then
                v1211.Tracks:Play(v1219, Workspace:GetServerTimeNow() - math.max(v1218, 0))
            else
                v1211.Tracks:Stop()
            end
        end

        function v1212.Say(v1220) -- line 3703 | captures: v228
            v228(v1220)
        end

        function v1212.Shake(v1221) -- line 3706 | captures: LocalPlayer, shakeFrom
            local Character = LocalPlayer.Character
            local v1222 = Character and Character:FindFirstChild("HumanoidRootPart")
            if v1222 and v1222:IsA("BasePart") then
                shakeFrom(v1222.Position, v1221, (1/0))
            end
        end

        function v1212.Land(v1223) -- line 3713 | captures: v1211, summonLanding
            summonLanding(v1211, v1223)
        end

        function v1212.Roar(v1224) -- line 3716 | captures: v1211, roar
            roar(v1211, v1224)
        end

        v1212.SfxGroup = sfxGroup
        v1212.Effects = effects
        Play(v1212)
    end

    local function preloadIntroSound() -- line 3727 | captures: ContentProvider, SpatialSfx, Cutscene
        local Sound = Cutscene.Sound
        local v1225 = Sound and SpatialSfx.Find(Sound.Folder, Sound.Name)
        if v1225 then
            task.spawn(function() -- line 3731 | captures: v1225, ContentProvider
                pcall(ContentProvider.PreloadAsync, ContentProvider, { v1225 })
            end)
        end
    end

    function v1.PlayIntro() -- line 3738 | captures: v3, v6, ContentProvider, Workspace, HellEventConfig, BinaryTransition, MovementLock, HellSummonCutscene, SpatialSfx, LocalPlayer, v1, Cutscene, setFade, playCutscene
        local v1226, v1227
        if Cutscene.Enabled then
            if v6 then
                v1227 = true
            else
                v6 = true
                local Sound = Cutscene.Sound
                v1226 = Sound and SpatialSfx.Find(Sound.Folder, Sound.Name)
                v1227 = false
            end
        else
            v1227 = true
        end
        if v1227 then
            return
        end
        if v1226 then
            local spawn = task.spawn
            local v1228 = v1226
            spawn(function() -- line 3731 | captures: v1228, ContentProvider
                pcall(ContentProvider.PreloadAsync, ContentProvider, { v1228 })
            end)
        end
        task.spawn(function() -- line 3744 | captures: v3, v6, Workspace, HellEventConfig, BinaryTransition, MovementLock, HellSummonCutscene, LocalPlayer, v1, Cutscene, setFade, playCutscene
            local v1229, v1230 = pcall(function() -- line 3745 | captures: v3, Workspace, HellEventConfig, BinaryTransition, LocalPlayer, Cutscene, playCutscene
                local v1231 = os.clock() + 8
                while not v3 do
                    if os.clock() < v1231 then
                        task.wait(0.1)
                        continue
                    end
                    break
                end
                while BinaryTransition.IsPlaying() do
                    BinaryTransition.Finished.Event:Wait()
                end
                local v1232 = v3
                if v1232 and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and v1232.Model:GetAttribute("Phase") == "Intro" then
                    local PhaseEnd = v1232.Model:GetAttribute("PhaseEnd")
                    if not (type(PhaseEnd) == "number" and PhaseEnd - Workspace:GetServerTimeNow() < Cutscene.MinTimeLeft) then
                        playCutscene(v1232)
                    end
                end
            end)
            if not v1229 then
                warn((("[HellBossController] cutscene errored: %*"):format(v1230)))
            end
            local v1233 = v3
            if v1233 and v1233.Phase ~= "Gather" then
                HellSummonCutscene.SetPylonsDormant(false)
                if v1233.Phase ~= "Defeated" and v1233.Hidden then
                    setFade(v1233, 0)
                end
            end
            MovementLock.Unlock("HellBossIntro")
            v6 = false
            v1.CutsceneEnded:Fire()
        end)
    end

    function v1.SetTask(v1234, v1235, v1236) -- line 3789 | captures: ScreenGui, v221, v222, v223, v224, v225, v226, v227, TweenService, HellBossConfig, Dialogue, v214, ensureDialogue, retireTask
        if v1234 == v223 and v1236 == v224 and not v1235 then
            return
        end
        local v1237 = if v1234 == nil or v221 == nil then false else v1236 ~= v224
        v223 = v1234
        v224 = v1236
        if not v1234 or ensureDialogue() then
            if v1237 then
                retireTask()
                v225 += 1
                local v1238 = v225
                if ScreenGui then
                    local ScreenGui_2 = ScreenGui
                    if #v214 > 0 then
                        ScreenGui_2.Enabled = true
                    elseif v221 == nil then
                        ScreenGui_2.Enabled = v226 > 0
                    else
                        ScreenGui_2.Enabled = true
                    end
                end
                task.delay(Dialogue.PopTime, function() -- line 3805 | captures: v1238, ScreenGui, v221, v223, v225, v226, v227, v214
                    local ScreenGui_2, v1239, v1240
                    if v1238 == v225 then
                        if v223 == nil then
                            v1240 = true
                        else
                            v227()
                            if ScreenGui then
                                ScreenGui_2 = ScreenGui
                                if #v214 > 0 then
                                    v1239 = true
                                elseif v221 == nil then
                                    v1239 = v226 > 0
                                else
                                    v1239 = true
                                end
                                v1240 = false
                            else
                                v1240 = true
                            end
                        end
                    else
                        v1240 = true
                    end
                    if not v1240 then
                        ScreenGui_2.Enabled = v1239
                    end
                end)
            else
                v225 += 1
                v227()
                if ScreenGui then
                    local ScreenGui_2 = ScreenGui
                    if #v214 > 0 then
                        ScreenGui_2.Enabled = true
                    elseif v221 == nil then
                        ScreenGui_2.Enabled = v226 > 0
                    else
                        ScreenGui_2.Enabled = true
                    end
                end
                if v1235 and v1234 and v222 then
                    v222.Scale = HellBossConfig.Tasks.BumpScale
                    TweenService:Create(v222, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
                end
            end
        end
    end

    function v1.IsCutsceneBusy() -- line 3823 | captures: v6
        return v6
    end

    local function drop(v1241) -- line 3831 | captures: v3, v5, stunOff
        local v1242 = v3
        if not (v1242 and v1242.Model == v1241) then
            return
        end
        v3 = nil
        for v1243, v1244 in v1242.Connections do
            v1244:Disconnect()
        end
        stunOff(v1242)
        local StopFly = v1242.StopFly
        v1242.StopFly = nil
        if StopFly then
            StopFly()
        end
        v1242.Tracks:StopAll()
        v1242.HitHighlight:Destroy()
        if v5 then
            v5:ClearAllChildren()
        end
    end

    local function adopt(v1245) -- line 3847 | captures: v3, v228, RunService, Workspace, HellBossConfig, HellEventConfig, BossTracks, BoneFlail, LocalPlayer, Visuals, now, Dialogue, steadyRoot, smoothTurn, place, readMove, walkOn, footsteps, setFade, readAttack, readSideAttack, readEnrage, hitStrength, onHitPulse, onShieldHit, readPhase, drop
        local function v1246(v1247, ...)
            table.insert(v1247, ...)
        end

        local function v1248(v1249, ...)
            table.insert(v1249, ...)
        end

        local function v1250(v1251, ...)
            table.insert(v1251, ...)
        end

        local function v1252(v1253, ...)
            table.insert(v1253, ...)
        end

        local function v1254(v1255, ...)
            table.insert(v1255, ...)
        end

        local function v1256(v1257, ...)
            table.insert(v1257, ...)
        end

        local function v1258(v1259, ...)
            table.insert(v1259, ...)
        end

        local function v1260(v1261, ...)
            table.insert(v1261, ...)
        end

        local function v1262(v1263, ...)
            table.insert(v1263, ...)
        end

        local function v1264(v1265, ...)
            table.insert(v1265, ...)
        end

        local function v1266(v1267, ...)
            table.insert(v1267, ...)
        end

        local function v1268(v1269, ...)
            table.insert(v1269, ...)
        end

        if not v1245:IsA("Model") or v3 and v3.Model == v1245 then
            return
        end
        local v1270 = v1245:WaitForChild(HellBossConfig.Rig.Root, 10)
        if not (v1270 and v1270:IsA("BasePart") and v1245.Parent) then
            return
        end
        local JointCount = v1245:GetAttribute("JointCount")
        local v1271 = os.clock() + 6
        while v1245.Parent do
            if os.clock() < v1271 then
                local v1272 = 0
                for v1273, v1274 in v1245:GetDescendants() do
                    if v1274:IsA("Motor6D") or v1274:IsA("AnimationConstraint") then
                        v1272 += 1
                    end
                end
                local v1275 = v1245:FindFirstChildWhichIsA("Animator", true) ~= nil
                local v1276
                if type(JointCount) == "number" then
                    if JointCount <= v1272 then
                        v1276 = not not v1275
                    else
                        v1276 = false
                    end
                else
                    v1276 = not not v1275
                end
                if v1276 then
                    break
                end
                task.wait(0.1)
                continue
            end
            break
        end
        if not v1245.Parent or v3 and v3.Model == v1245 then
            return
        end
        if v3 then
            drop(v3.Model)
        end
        v1245.PrimaryPart = v1270
        local v1277 = v1245:GetAttribute("HipOffset") or 0
        local v1278 = v1245:GetAttribute("FloorY") or v1270.Position.Y - v1277
        local v1279 = (-1/0)
        for v1280, v1281 in v1245:GetDescendants() do
            if v1281:IsA("BasePart") and v1281 ~= v1270 then
                local v1282 = v1281.Position.Y + v1281.Size.Y / 2
                v1279 = math.max(v1279, v1282)
            end
        end
        local v1283 = if v1278 < v1279 then v1279 - v1278 else v1277 * 1.75
        local RestCFrame = v1245:GetAttribute("RestCFrame")
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "HellBossHitFlash"
        Highlight.FillColor = Visuals.HitFlash.Color
        Highlight.FillTransparency = 1
        Highlight.OutlineTransparency = 1
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.Enabled = false
        Highlight.Parent = v1245
        local v1284 = {
            Model = v1245,
            Root = v1270,
            Tracks = BossTracks.new(v1245, HellBossConfig.Rig.Folder, HellBossConfig.Rig.Tracks, now, HellBossConfig.Rig.Fade),
            IdleTrack = nil,
            HipOffset = v1277,
            FloorY = v1278,
            Height = math.max(v1283, 10),
            Scale = v1245:GetScale()
        }
        v1284.FxScale = HellBossConfig.Rig.FxScale or v1245:GetScale()
        v1284.Bones = {}
        if typeof(RestCFrame) ~= "CFrame" then
            RestCFrame = v1270.CFrame
        end
        v1284.Rest = RestCFrame
        v1284.Phase = ""
        v1284.PhaseStart = Workspace:GetServerTimeNow()
        v1284.AttackId = -1
        v1284.SideAttackId = -1
        v1284.EnrageStage = v1245:GetAttribute("Enrage") or 0
        v1284.Attack = nil
        v1284.TurnFrom = v1270.CFrame
        v1284.LastHitPulse = v1245:GetAttribute("HitPulse") or 0
        v1284.HitHighlight = Highlight
        v1284.HitAt = (-1/0)
        v1284.HitFrom = 0
        v1284.Stun = nil
        v1284.Hidden = false
        v1284.Dormant = false
        v1284.Fade = 0
        v1284.FadeParts = nil
        v1284.LastShieldPulse = v1245:GetAttribute("ShieldHitPulse") or 0
        v1284.RootJoint = nil
        v1284.RootJointMissedAt = (-1/0)
        v1284.SaidLow = false
        v1284.SaidHalf = false
        v1284.SaidThreeQuarter = false
        v1284.TauntToken = 0
        v1284.WalkTrack = nil
        v1284.WalkPhase = -1
        v1284.MoveId = -1
        v1284.Move = nil
        v1284.NextMove = nil
        v1284.StopFly = nil
        v1284.Override = nil
        v1284.Facing = nil
        v1284.Speed = 0
        v1284.Flail = nil
        v1284.Topple = nil
        v1284.CodePoses = {}
        v1284.CodeMove = nil
        v1284.Flailing = false
        v1284.Connections = {}
        v3 = v1284
        local Idle = Enum.AnimationPriority.Idle
        local v1285 = v1284.Tracks:Get("Idle", Idle)
        if v1285 then
            v1285.Looped = true
        end
        v1284.IdleTrack = v1285
        local Movement = Enum.AnimationPriority.Movement
        local v1286 = v1284.Tracks:Get("Walk", Movement)
        if v1286 then
            v1286.Looped = true
        end
        v1284.WalkTrack = v1286
        if v1284.IdleTrack then
            v1284.IdleTrack:Play(0.25)
        end
        readPhase(v1284)
        readAttack(v1284)
        readMove(v1284)

        local function watch(v1287, v1288) -- line 3966 | captures: v1245, v1284
            local function v1289(v1290, ...)
                table.insert(v1290, ...)
            end

            v1289(v1284.Connections, v1245:GetAttributeChangedSignal(v1287):Connect(v1288))
        end

        local function v1291() -- line 3969 | captures: v1284, readSideAttack
            readSideAttack(v1284)
        end

        v1246(v1284.Connections, v1245:GetAttributeChangedSignal("SideAttackId"):Connect(v1291))

        local function v1292() -- line 3972 | captures: v1284, readEnrage
            readEnrage(v1284)
        end

        v1248(v1284.Connections, v1245:GetAttributeChangedSignal("Enrage"):Connect(v1292))

        local function v1293() -- line 3975 | captures: v1284, readAttack
            readAttack(v1284)
        end

        v1250(v1284.Connections, v1245:GetAttributeChangedSignal("AttackId"):Connect(v1293))

        local function v1294() -- line 3978 | captures: v1284, readPhase
            readPhase(v1284)
        end

        v1252(v1284.Connections, v1245:GetAttributeChangedSignal("Phase"):Connect(v1294))

        local function v1295() -- line 3981 | captures: v1284, onHitPulse
            onHitPulse(v1284)
        end

        v1254(v1284.Connections, v1245:GetAttributeChangedSignal("HitPulse"):Connect(v1295))

        local function v1296() -- line 3984 | captures: v1284, onShieldHit
            onShieldHit(v1284)
        end

        v1256(v1284.Connections, v1245:GetAttributeChangedSignal("ShieldHitPulse"):Connect(v1296))

        local function v1297() -- line 3987 | captures: v1245, v1284, v228, Dialogue
            local Health = v1245:GetAttribute("Health")
            local MaxHealth = v1245:GetAttribute("MaxHealth")
            if not (v1284.Phase ~= "Defeated") or not (type(Health) == "number") or not (type(MaxHealth) == "number") or MaxHealth <= 0 or Health <= 0 then
                return
            end
            local v1298 = Health / MaxHealth
            if v1284.SaidLow or not (v1298 <= Dialogue.LowHealthAt) then
                if v1284.SaidHalf or not (v1298 <= Dialogue.HalfHealthAt) then
                    if not v1284.SaidThreeQuarter and v1298 <= Dialogue.ThreeQuarterAt then
                        v1284.SaidThreeQuarter = true
                        v228("ThreeQuarterHealth")
                    end
                else
                    v1284.SaidHalf = true
                    v1284.SaidThreeQuarter = true
                    v228("HalfHealth")
                end
            else
                v1284.SaidLow = true
                v1284.SaidHalf = true
                v1284.SaidThreeQuarter = true
                v228("LowHealth")
            end
        end

        v1258(v1284.Connections, v1245:GetAttributeChangedSignal("Health"):Connect(v1297))

        local function v1299() -- line 4007 | captures: v1284, readMove
            readMove(v1284)
        end

        v1260(v1284.Connections, v1245:GetAttributeChangedSignal("MoveId"):Connect(v1299))

        local function v1300() -- line 4010 | captures: v1245, v1284
            local RestCFrame = v1245:GetAttribute("RestCFrame")
            if typeof(RestCFrame) == "CFrame" then
                v1284.Rest = RestCFrame
            end
        end

        v1262(v1284.Connections, v1245:GetAttributeChangedSignal("RestCFrame"):Connect(v1300))

        local function forgetFadeParts() -- line 4017 | captures: v1284
            v1284.FadeParts = nil
        end

        v1264(v1284.Connections, v1245.DescendantAdded:Connect(forgetFadeParts))
        v1266(v1284.Connections, v1245.DescendantRemoving:Connect(forgetFadeParts))
        v1268(v1284.Connections, RunService.PreSimulation:Connect(function(v1301) -- line 4025 | captures: v1245, v1270, v1284, Workspace, HellBossConfig, HellEventConfig, BoneFlail, LocalPlayer, Visuals, steadyRoot, smoothTurn, place, walkOn, footsteps, setFade, readAttack, readSideAttack, hitStrength, drop
            if not v1245.Parent then
                drop(v1245)
            elseif LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) ~= true then
                if not v1284.Dormant then
                    v1284.Dormant = true
                    v1284.Tracks:StopAll()
                end
            else
                if v1284.Dormant then
                    v1284.Dormant = false
                    if v1284.IdleTrack then
                        v1284.IdleTrack:Play(0.25)
                    end
                    v1284.AttackId = -1
                    v1284.SideAttackId = -1
                    readAttack(v1284)
                    readSideAttack(v1284)
                end
                local v1302 = place(v1284)
                local v1303 = smoothTurn(v1284, v1302, v1301)
                local v1304 = Workspace:GetServerTimeNow()
                local Move = v1284.Move
                local v1305
                if Move then
                    local Attack = v1284.Attack
                    local v1306
                    if not (Attack ~= nil and v1304 < Attack.Start + Attack.Length) and v1284.Phase ~= "Stunned" and v1284.Phase ~= "Defeated" then
                        local Move = v1284.Move
                        if not (Move ~= nil and v1304 < Move.End + 0.12) then
                            v1306 = v1284.NextMove ~= nil
                        else
                            v1306 = true
                        end
                    else
                        v1306 = false
                    end
                    if v1306 then
                        local End = Move.End
                        if Move.Start < End then
                            local v1307 = Move.To.Position - Move.From.Position
                            local X = v1307.X
                            local Z = v1307.Z
                            v1305 = Vector3.new(X, 0, Z).Magnitude / (Move.End - Move.Start)
                        else
                            v1305 = 0
                        end
                    else
                        v1305 = 0
                    end
                else
                    v1305 = 0
                end
                if v1305 ~= v1305 or HellBossConfig.Walk.Speed * 3 < v1305 then
                    v1305 = 0
                end
                local Speed = v1284.Speed
                local v1308 = v1305 - v1284.Speed
                local v1309 = -10 * v1301
                v1284.Speed = Speed + v1308 * (1 - math.exp(v1309))
                if v1284.Speed ~= v1284.Speed then
                    v1284.Speed = 0
                end
                if v1270.CFrame ~= v1303 then
                    v1270.CFrame = v1303
                end
                if v1284.Speed >= 4 then
                    walkOn(v1284, v1284.Speed)
                else
                    local WalkTrack = v1284.WalkTrack
                    if WalkTrack and WalkTrack.IsPlaying then
                        WalkTrack:Stop(0.25)
                    end
                end
                v1284.Tracks:Step()
                local CodeMove = v1284.CodeMove
                if CodeMove then
                    local v1310 = Workspace:GetServerTimeNow() - CodeMove.Start
                    local Spec = CodeMove.Spec
                    if Spec.Length <= v1310 or v1284.Phase == "Defeated" then
                        v1284.CodeMove = nil
                    elseif v1310 >= 0 then
                        local BlendIn = Spec.BlendIn
                        local v1311 = v1310 / math.max(BlendIn, 0.001)
                        local v1312 = math.clamp(v1311, 0, 1)
                        local v1313 = v1312 * v1312 * (3 - v1312 * 2)
                        local v1314 = v1310 - (Spec.Length - Spec.BlendOut)
                        local BlendOut = Spec.BlendOut
                        local v1315 = v1314 / math.max(BlendOut, 0.001)
                        local v1316 = math.clamp(v1315, 0, 1)
                        local v1317 = 1 - v1316 * v1316 * (3 - v1316 * 2)
                        CodeMove.Pose:Step(v1310, v1313 * v1317)
                    end
                end
                if not v1284.Tracks:IsPlaying() then
                    steadyRoot(v1284)
                end
                footsteps(v1284)
                if v1284.Phase == "Defeated" then
                    local Defeat = HellBossConfig.Defeat
                    local v1318 = Workspace:GetServerTimeNow() - v1284.PhaseStart - Defeat.BreakTime
                    local v1319 = (v1318 - Defeat.DropAt) / Defeat.DropTime - Defeat.FadeStart
                    local v1320 = Defeat.FadeEnd - Defeat.FadeStart
                    setFade(v1284, v1319 / math.max(v1320, 0.001))
                    local Topple = Defeat.Topple
                    local Flail = Defeat.Flail
                    local v1321 = if Flail then Flail.StartAt + Flail.BlendIn else (1/0)
                    if Topple and v1318 >= 0 and v1318 < v1321 then
                        if not v1284.Topple then
                            v1284.Topple = BoneFlail.new(v1245, v1270, Topple.Moves)
                        end
                        local Topple_2 = v1284.Topple
                        local BlendIn = Topple.BlendIn
                        local v1322 = v1318 / math.max(BlendIn, 0.001)
                        local v1323 = math.clamp(v1322, 0, 1)
                        Topple_2:Step(v1318, v1323 * v1323 * (3 - v1323 * 2))
                        v1284.Flailing = true
                    end
                    if Flail and Flail.StartAt <= v1318 then
                        if not v1284.Flail then
                            v1284.Flail = BoneFlail.new(v1245, v1270, Flail.Moves)
                        end
                        local v1324 = v1318 - Flail.StartAt
                        local Flail_2 = v1284.Flail
                        local BlendIn = Flail.BlendIn
                        local v1325 = v1324 / math.max(BlendIn, 0.001)
                        local v1326 = math.clamp(v1325, 0, 1)
                        Flail_2:Step(v1324, v1326 * v1326 * (3 - v1326 * 2))
                        v1284.Flailing = true
                    end
                elseif v1284.Flailing then
                    v1284.Flailing = false
                    if v1284.Topple then
                        v1284.Topple:Reset()
                    end
                    if v1284.Flail then
                        v1284.Flail:Reset()
                    end
                end
                local HitHighlight = v1284.HitHighlight
                local v1327 = hitStrength(v1284)
                if v1327 > 0.001 then
                    HitHighlight.FillTransparency = (Visuals.HitFlash.Transparency - 1) * v1327 + 1
                    if not HitHighlight.Enabled then
                        HitHighlight.Adornee = v1284.Model
                        HitHighlight.Enabled = true
                    end
                elseif HitHighlight.Enabled then
                    HitHighlight.Enabled = false
                    HitHighlight.Adornee = nil
                end
            end
        end))
    end

    function v1.Start() -- line 4150 | captures: v3, v6, v228, CollectionService, ContentProvider, Players, Workspace, HellBossConfig, HellEventConfig, BinaryTransition, MovementLock, HellSummonCutscene, SpatialSfx, MainGui, MusicController, LocalPlayer, v1, Cutscene, v13, Dialogue, hushDialogue, setFade, playCutscene, drop, adopt
        for v1328, v1329 in CollectionService:GetTagged(HellBossConfig.Tag) do
            task.spawn(adopt, v1329)
        end
        CollectionService:GetInstanceAddedSignal(HellBossConfig.Tag):Connect(function(v1330) -- line 4154 | captures: adopt
            task.spawn(adopt, v1330)
        end)
        CollectionService:GetInstanceRemovedSignal(HellBossConfig.Tag):Connect(drop)
        local Sound = Cutscene.Sound
        local v1331 = Sound and SpatialSfx.Find(Sound.Folder, Sound.Name)
        if v1331 then
            task.spawn(function() -- line 3731 | captures: v1331, ContentProvider
                pcall(ContentProvider.PreloadAsync, ContentProvider, { v1331 })
            end)
        end
        MainGui.Observe(function(v1332) -- line 4163 | captures: Dialogue
            local v1333 = v1332:FindFirstChild(Dialogue.Frame)
            if v1333 and v1333:IsA("GuiObject") then
                v1333.Visible = false
            end
        end)

        local function watchDowns(v1334) -- line 4171 | captures: v3, v228, HellEventConfig, LocalPlayer, Dialogue
            local function onCharacter(v1335) -- line 4172 | captures: v1334, v3, v228, HellEventConfig, LocalPlayer, Dialogue
                local v1336 = v1335:WaitForChild("Humanoid", 10)
                if v1336 and v1336:IsA("Humanoid") then
                    v1336.Died:Once(function() -- line 4175 | captures: v1334, v3, v228, HellEventConfig, LocalPlayer, Dialogue
                        local v1337 = v3
                        if v1337 and v1337.Phase == "Active" and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and v1334:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                            v228("PlayerDown", Dialogue.PlayerDownChance, true)
                        end
                    end)
                end
            end

            v1334.CharacterAdded:Connect(onCharacter)
            if v1334.Character then
                task.spawn(onCharacter, v1334.Character)
            end
        end

        for v1338, v1339 in Players:GetPlayers() do
            local v1340 = v1339

            local onCharacter = function(v1341) -- onCharacter | line 4172 | captures: v1340, v3, v228, HellEventConfig, LocalPlayer, Dialogue
                local v1342 = v1341:WaitForChild("Humanoid", 10)
                if v1342 and v1342:IsA("Humanoid") then
                    v1342.Died:Once(function() -- line 4175 | captures: v1340, v3, v228, HellEventConfig, LocalPlayer, Dialogue
                        local v1343 = v3
                        if v1343 and v1343.Phase == "Active" and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and v1340:GetAttribute(HellEventConfig.PlayerAttribute) == true then
                            v228("PlayerDown", Dialogue.PlayerDownChance, true)
                        end
                    end)
                end
            end

            v1339.CharacterAdded:Connect(onCharacter)
            if v1339.Character then
                task.spawn(onCharacter, v1339.Character)
            end
        end
        Players.PlayerAdded:Connect(watchDowns)
        local v1344 = LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
        LocalPlayer:GetAttributeChangedSignal(HellEventConfig.PlayerAttribute):Connect(function() -- line 4196 | captures: v1344, v3, v6, ContentProvider, Workspace, HellEventConfig, BinaryTransition, MovementLock, HellSummonCutscene, SpatialSfx, MusicController, LocalPlayer, v1, Cutscene, v13, hushDialogue, setFade, playCutscene
            local v1345 = LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true
            local v1346, v1347
            if v1345 then
                if v1344 then
                    v1347 = true
                elseif Cutscene.Enabled then
                    if v6 then
                        v1347 = true
                    else
                        v6 = true
                        local Sound = Cutscene.Sound
                        v1346 = Sound and SpatialSfx.Find(Sound.Folder, Sound.Name)
                        v1347 = false
                    end
                else
                    v1347 = true
                end
            else
                v1347 = true
            end
            if not v1347 then
                if v1346 then
                    local spawn = task.spawn
                    local v1348 = v1346
                    spawn(function() -- line 3731 | captures: v1348, ContentProvider
                        pcall(ContentProvider.PreloadAsync, ContentProvider, { v1348 })
                    end)
                end
                task.spawn(function() -- line 3744 | captures: v3, v6, Workspace, HellEventConfig, BinaryTransition, MovementLock, HellSummonCutscene, LocalPlayer, v1, Cutscene, setFade, playCutscene
                    local v1349, v1350 = pcall(function() -- line 3745 | captures: v3, Workspace, HellEventConfig, BinaryTransition, LocalPlayer, Cutscene, playCutscene
                        local v1351 = os.clock() + 8
                        while not v3 do
                            if os.clock() < v1351 then
                                task.wait(0.1)
                                continue
                            end
                            break
                        end
                        while BinaryTransition.IsPlaying() do
                            BinaryTransition.Finished.Event:Wait()
                        end
                        local v1352 = v3
                        if v1352 and LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) == true and v1352.Model:GetAttribute("Phase") == "Intro" then
                            local PhaseEnd = v1352.Model:GetAttribute("PhaseEnd")
                            if not (type(PhaseEnd) == "number" and PhaseEnd - Workspace:GetServerTimeNow() < Cutscene.MinTimeLeft) then
                                playCutscene(v1352)
                            end
                        end
                    end)
                    if not v1349 then
                        warn((("[HellBossController] cutscene errored: %*"):format(v1350)))
                    end
                    local v1353 = v3
                    if v1353 and v1353.Phase ~= "Gather" then
                        HellSummonCutscene.SetPylonsDormant(false)
                        if v1353.Phase ~= "Defeated" and v1353.Hidden then
                            setFade(v1353, 0)
                        end
                    end
                    MovementLock.Unlock("HellBossIntro")
                    v6 = false
                    v1.CutsceneEnded:Fire()
                end)
            end
            if not v1345 and v1344 then
                hushDialogue()
                v13.StopAll()
                task.delay(3, function() -- line 4206 | captures: HellEventConfig, MusicController, LocalPlayer
                    if LocalPlayer:GetAttribute(HellEventConfig.PlayerAttribute) ~= true then
                        MusicController.SetHellOverride(nil)
                    end
                end)
            end
            v1344 = v1345
        end)
    end
end
return v1
