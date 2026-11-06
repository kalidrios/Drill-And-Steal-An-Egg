-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RranBossConfig = require(ReplicatedStorage.Shared.RranBossConfig)
local RranBossGround = require(ReplicatedStorage.Shared.RranBossGround)
local ChaseState = require(ReplicatedStorage.Shared.ChaseState)
local GlobalAnnouncementConfig = require(ReplicatedStorage.Shared.GlobalAnnouncementConfig)
local VFXScaler = require(ReplicatedStorage.Shared.VFXScaler)
local Modules = script.Parent.Parent.Modules
local BazookaMuzzle = require(Modules.BazookaMuzzle)
local CameraShaker = require(Modules.CameraShaker)
local CinematicMode = require(Modules.CinematicMode)
local EggLandImpact = require(Modules.EggLandImpact)
local JointAnimator = require(Modules.JointAnimator)
local SpatialSfx = require(Modules.SpatialSfx)
local VFXBurst = require(Modules.VFXBurst)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local Event = RranBossConfig.Event
local Clips = RranBossConfig.Clips
local Sfx = RranBossConfig.Sfx
local v2 = {}
local v3

local function now() -- line 125 | captures: Workspace
    return Workspace:GetServerTimeNow()
end

local function playSfx(v4, v5) -- line 129 | captures: SpatialSfx, Sfx
    local Play = SpatialSfx.Play
    local Folder = Sfx.Folder
    local Name = v4.Name
    local v6 = {
        At = v5,
        Range = v4.Range
    }
    v6.MinRange = v4.MinRange or v4.Range * 0.25
    if v4.RollOff == "Linear" then
        v6.RollOffMode = Enum.RollOffMode.Linear
    else
        v6.RollOffMode = nil
    end
    v6.PlaybackSpeed = v4.PlaybackSpeed
    v6.Volume = v4.Volume
    Play(Folder, Name, v6)
end

local function shakeFrom(v7, v8) -- line 144 | captures: v3, Workspace, CameraShaker, LocalPlayer, Event
    local Character = LocalPlayer.Character
    local v9 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v9 and v9:IsA("BasePart")) then
        return
    end
    local Magnitude = (v9.Position - v7).Magnitude
    if Event.ShakeRadius <= Magnitude then
        return
    end
    if not v3 then
        v3 = CameraShaker.new(Enum.RenderPriority.Camera.Value + 1, function(v10) -- line 155 | captures: Workspace
            local CurrentCamera = Workspace.CurrentCamera
            if CurrentCamera then
                CurrentCamera.CFrame *= v10
            end
        end)
        v3:Start()
    end
    local v11 = 1 - Magnitude / Event.ShakeRadius
    v3:ShakeOnce(v8 * v11, 10, 0.04, 0.7)
end

local function outlineColorFor(v12) -- line 169 | captures: RranBossConfig, GlobalAnnouncementConfig
    for v13, v14 in RranBossConfig.Bosses do
        if v12.Name == v14 then
            local v15 = RranBossConfig.BossUsers[v13]
            local v16 = v15 and GlobalAnnouncementConfig.NameColors[v15.UserId]
            if v16 then
                return v16
            end
        end
    end
    return RranBossConfig.Outline.Color
end

local function feetOf(v17, v18) -- line 182
    local Position = v18.Position
    local HipOffset = v17.HipOffset
    return Position - Vector3.new(0, HipOffset, 0)
end

local function bezier(v19, v20, v21, v22, v23) -- line 188
    local v24 = 1 - v23
    return v19 * (v24 * v24 * v24) + v20 * (v24 * 3 * v24 * v23) + v21 * (v24 * 3 * v23 * v23) + v22 * (v23 * v23 * v23)
end

local function smoothstep(v25) -- line 193
    local v26 = math.clamp(v25, 0, 1)
    return v26 * v26 * (3 - v26 * 2)
end

local function flyingCFrame(v27, v28, v29) -- line 200
    local v30
    if v28.Magnitude > 0.001 then
        v30 = v28.Unit
    else
        v30 = Vector3.new(0, 1, 0)
    end
    local v31 = Vector3.new(-0, -1, -0, -0) - v30 * v30:Dot((Vector3.new(-0, -1, -0, -0)))
    if v31.Magnitude < 0.05 then
        v31 = v29 - v30 * v30:Dot(v29)
        if v31.Magnitude < 0.05 then
            v31 = Vector3.new(0, 0, -1)
        end
    end
    local v32 = -v31.Unit
    return CFrame.fromMatrix(v27, v30:Cross(v32), v30, v32)
end

local function flyInPoint(v33, v34, v35) -- line 217
    local v36 = v34.X - v33.X
    local v37 = v34.Z - v33.Z
    local v38 = Vector3.new(v36, 0, v37)
    local v39 = v33.Y - v34.Y
    local v40 = math.max(v39, 1)
    local v41 = v33 + v38 * 0.5
    local v42 = v34 + Vector3.new(0, 1, 0) * (v40 * 0.55)
    local v43 = 1 - v35
    return v33 * (v43 * v43 * v43) + v41 * (v43 * 3 * v43 * v35) + v42 * (v43 * 3 * v35 * v35) + v34 * (v35 * v35 * v35)
end

local function flyOutPoint(v44, v45, v46) -- line 224
    local v47 = v45.X - v44.X
    local v48 = v45.Z - v44.Z
    local v49 = Vector3.new(v47, 0, v48)
    local v50 = v45.Y - v44.Y
    local v51 = math.max(v50, 1)
    local v52 = v44 + Vector3.new(0, 1, 0) * (v51 * 0.45)
    local v53 = v44 + v49 * 0.45 + Vector3.new(0, 1, 0) * v51
    local v54 = 1 - v46
    return v44 * (v54 * v54 * v54) + v52 * (v54 * 3 * v54 * v46) + v53 * (v54 * 3 * v46 * v46) + v45 * (v46 * v46 * v46)
end

local function muzzleBlast(v55) -- line 234 | captures: BazookaMuzzle, VFXBurst, Event, Sfx, playSfx, shakeFrom
    local v56, v57 = BazookaMuzzle.Get(v55.Model)
    if not v56 or not v57 then
        return
    end
    local v58 = CFrame.lookAt(v56, v56 + v57)
    VFXBurst.Play(Event.BlastName, v58, Event.MuzzleBlastScale)
    VFXBurst.Play(Event.SmokeName, v58, Event.SmokeScale)
    playSfx(Sfx.Shot, v56)
    shakeFrom(v56, Event.FireShake)
end

local function slam(v59) -- line 246 | captures: EggLandImpact, VFXBurst, Event, Sfx, playSfx, shakeFrom
    local Position = v59.To.Position
    local HipOffset = v59.HipOffset
    local v60 = Position - Vector3.new(0, HipOffset, 0)
    VFXBurst.Play(Event.BlastName, CFrame.new(v60), Event.LandBlastScale, v59.Color)
    EggLandImpact.Chunks(v60, v59.Scale * 0.6, v59.Scale * 2)
    playSfx(Sfx.Slam, v60)
    shakeFrom(v60, Event.LandShake)
end

local function takeOff(v61) -- line 254 | captures: EggLandImpact, VFXBurst, Event, Sfx, playSfx, shakeFrom
    local Position = v61.From.Position
    local HipOffset = v61.HipOffset
    local v62 = Position - Vector3.new(0, HipOffset, 0)
    VFXBurst.Play(Event.BlastName, CFrame.new(v62), Event.LandBlastScale * 0.7, v61.Color)
    VFXBurst.Play(Event.SmokeName, CFrame.new(v62), Event.SmokeScale * 1.6, v61.Color)
    EggLandImpact.Chunks(v62, v61.Scale * 0.5, v61.Scale * 1.5)
    playSfx(Sfx.Slam, v62)
    shakeFrom(v62, Event.LandShake * 0.5)
end

local function makeThrusters(v63, v64) -- line 265 | captures: ReplicatedStorage, VFXScaler, VFXBurst, Event
    local Thrusters = Event.Thrusters
    local v65 = {}
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v66 = VFX and VFX:FindFirstChild(Thrusters.FlameSource)
    local v67 = {}
    if v66 then
        for v68, v69 in v66:GetDescendants() do
            if v69:IsA("ParticleEmitter") and string.find(string.lower(v69.Name), Thrusters.FlameMatch) then
                table.insert(v67, v69)
            end
        end
    end
    for v70, v71 in Thrusters.Parts do
        local v72 = v63:FindFirstChild(v71)
        if v72 and v72:IsA("BasePart") then
            local Attachment = Instance.new("Attachment")
            Attachment.Name = "Thruster"
            local v73 = -v72.Size.Y / 2
            Attachment.Position = Vector3.new(0, v73, 0)
            Attachment.Orientation = Vector3.new(180, 0, 0)
            Attachment.Parent = v72
            for v74, v75 in v67 do
                local v76 = v75:Clone()
                v76.Enabled = false
                VFXScaler.ScaleParticle(v76, Thrusters.FlameScale)
                v76.Color = ColorSequence.new(v76.Color.Keypoints[1].Value:Lerp(v64, VFXBurst.TintStrength), v76.Color.Keypoints[#v76.Color.Keypoints].Value:Lerp(v64, VFXBurst.TintStrength))
                v76.Parent = Attachment
                table.insert(v65, v76)
            end
            local v77 = v72.Size.X * Thrusters.TrailWidth / 2
            local Attachment_2 = Instance.new("Attachment")
            local v78 = -v77
            local v79 = -v72.Size.Y / 2
            Attachment_2.Position = Vector3.new(v78, v79, 0)
            Attachment_2.Parent = v72
            local Attachment_3 = Instance.new("Attachment")
            local v80 = -v72.Size.Y / 2
            Attachment_3.Position = Vector3.new(v77, v80, 0)
            Attachment_3.Parent = v72
            local Trail = Instance.new("Trail")
            Trail.Attachment0 = Attachment_2
            Trail.Attachment1 = Attachment_3
            Trail.Lifetime = Thrusters.TrailLifetime
            Trail.MinLength = 0.05
            Trail.FaceCamera = true
            Trail.LightEmission = 1
            Trail.Color = ColorSequence.new(Thrusters.TrailColors[1], v64)
            Trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(1, 1)
            })
            Trail.WidthScale = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0.1)
            })
            Trail.Enabled = false
            Trail.Parent = v72
            table.insert(v65, Trail)
        end
    end
    return v65
end

local function setThrusters(v81, v82) -- line 332 | captures: SpatialSfx, Sfx, playSfx
    if v81.ThrustersOn == v82 then
        return
    end
    v81.ThrustersOn = v82
    if v82 then
        local FlyBy = Sfx.FlyBy
        playSfx(FlyBy, v81.Root)
        local FlyLoop = Sfx.FlyLoop
        v81.StopFlySound = SpatialSfx.PlayLooped(Sfx.Folder, FlyLoop.Name, {
            FadeOut = 0.3,
            At = v81.Root,
            Range = FlyLoop.Range,
            MinRange = FlyLoop.MinRange,
            RollOffMode = Enum.RollOffMode.Linear,
            Volume = FlyLoop.Volume
        })
    elseif v81.StopFlySound then
        v81.StopFlySound()
        v81.StopFlySound = nil
    end
    for v83, v84 in v81.Thrusters do
        if v84:IsA("ParticleEmitter") or v84:IsA("Trail") then
            v84.Enabled = v82
        end
    end
end

local function sonicBoom(v85) -- line 363 | captures: VFXBurst, Event, Sfx, playSfx, shakeFrom
    local Position = v85.Root.Position
    VFXBurst.Play(Event.BlastName, CFrame.new(Position), Event.LandBlastScale * 0.8, v85.Color)
    VFXBurst.Play(Event.SmokeName, CFrame.new(Position), Event.SmokeScale * 2, v85.Color)
    playSfx(Sfx.Slam, Position)
    shakeFrom(Position, Event.LandShake * 0.4)
end

local function setFade(v86, v87) -- line 373 | captures: RranBossConfig
    local v88 = math.clamp(v87, 0, 1)
    local v89 = v88 - v86.Fade
    if math.abs(v89) < 0.01 then
        return
    end
    v86.Fade = v88
    for v90, v91 in v86.Visuals do
        v91.LocalTransparencyModifier = v88
    end
    local Outline = v86.Outline
    if Outline then
        local Transparency = RranBossConfig.Outline.Transparency
        Outline.OutlineTransparency = Transparency + (1 - Transparency) * v88
    end
end

local v92 = (-1/0)

local function isStepping(v93) -- line 397
    local WalkTrack = v93.WalkTrack
    if v93.Kind == "Walk" or v93.Kind == "Turn" then
        if WalkTrack == nil then
            return false
        end
        return WalkTrack.IsPlaying
    end
    return false
end

local function footstepsVoicedByOther(v94) -- line 402 | captures: Workspace, RranBossConfig, v2
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera then
        local Position = CurrentCamera.CFrame.Position
        local Position_2 = v94.Root.Position
        local Magnitude = (Position_2 - Position).Magnitude
        for v95, v96 in v2 do
            if v96 ~= v94 then
                local WalkTrack = v96.WalkTrack
                local v97
                if v96.Kind == "Walk" or v96.Kind == "Turn" then
                    if WalkTrack == nil then
                        v97 = false
                    else
                        v97 = WalkTrack.IsPlaying
                    end
                else
                    v97 = false
                end
                if v97 and v96.Root.Parent then
                    local Position_3 = v96.Root.Position
                    if (Position_3 - Position_2).Magnitude <= RranBossConfig.Sfx.StompMergeRadius then
                        local Magnitude_2 = (Position_3 - Position).Magnitude
                        if Magnitude_2 < Magnitude or Magnitude_2 == Magnitude and v96.Model.Name < v94.Model.Name then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local function stomp(v98) -- line 425 | captures: v92, RranBossConfig, Event, Sfx, playSfx, shakeFrom, footstepsVoicedByOther
    if footstepsVoicedByOther(v98) or os.clock() - v92 < RranBossConfig.Sfx.StompGap then
        return
    end
    v92 = os.clock()
    local Position = v98.Root.CFrame.Position
    local HipOffset = v98.HipOffset
    local v99 = Position - Vector3.new(0, HipOffset, 0)
    playSfx(Sfx.Stomp, v99)
    shakeFrom(v99, Event.FireShake * 0.35)
end

local Cutscene = RranBossConfig.Cutscene
local v100 = (-1/0)

local function enterMovieMode() -- line 448 | captures: CinematicMode, Cutscene
    return CinematicMode.Enter(Cutscene)
end

local function exitMovieMode() -- line 452 | captures: CinematicMode
    CinematicMode.Exit()
end

local function smooth(v101) -- line 456
    local v102 = math.clamp(v101, 0, 1)
    return v102 * v102 * (3 - v102 * 2)
end

local function v103(v104) -- line 472 | captures: v100, Players, RunService, Workspace, ChaseState, CinematicMode, LocalPlayer, Event, v2, Cutscene
    if not Cutscene.Enabled then
        return
    end
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v105 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not CurrentCamera or not v105 or not v105:IsA("BasePart") or os.clock() - v100 < Cutscene.Cooldown or CinematicMode.IsActive() then
        return
    end
    if Cutscene.SkipWhileCarrying and (ChaseState.IsCarrying(LocalPlayer) or LocalPlayer:GetAttribute("BeingChased")) then
        return
    end
    local v106 = Workspace:GetServerTimeNow() - v104.Start
    if not (Cutscene.LateJoinGrace < v106) then
        v100 = os.clock()
        local DropTime = Event.DropTime
        local Hold = Cutscene.Hold
        local Return = Cutscene.Return
        local v107 = v104.HipOffset * 2
        local v108 = math.max(v107, 10)
        local Position = v104.To.Position
        local Position_2 = v104.To.Position
        local HipOffset = v104.HipOffset
        local v109 = Position_2 - Vector3.new(0, HipOffset, 0)
        local LookVector = v104.To.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v110 = Vector3.new(X, 0, Z)
        local Unit
        if v110.Magnitude > 0.001 then
            Unit = v110.Unit
        else
            Unit = Vector3.new(0, 0, -1)
        end
        local Unit_2 = Unit
        local v111 = Unit:Cross((Vector3.new(0, 1, 0)))

        local function spot(v112) -- line 509 | captures: Unit_2, v108, v109, v111, Cutscene
            local v113 = v108 * Cutscene.Zoom
            return v109 + v111 * ((v112.Right or 0) * v113) + Unit_2 * (((v112.Front or 0) - (v112.Back or 0)) * v113) + Vector3.new(0, 1, 0) * ((v112.Up or 0) * v113)
        end

        local ApproachFrom = Cutscene.Shots.ApproachFrom
        local v114 = v108 * Cutscene.Zoom
        local v115 = v109 + v111 * ((ApproachFrom.Right or 0) * v114)
        local v116 = ((ApproachFrom.Front or 0) - (ApproachFrom.Back or 0)) * v114
        local v117 = v115 + Unit_2 * v116 + Vector3.new(0, 1, 0) * ((ApproachFrom.Up or 0) * v114)
        local ApproachTo = Cutscene.Shots.ApproachTo
        local v118 = v108 * Cutscene.Zoom
        local v119 = v109 + v111 * ((ApproachTo.Right or 0) * v118)
        local v120 = ((ApproachTo.Front or 0) - (ApproachTo.Back or 0)) * v118
        local v121 = v119 + Unit_2 * v120 + Vector3.new(0, 1, 0) * ((ApproachTo.Up or 0) * v118)
        local v122
        if Cutscene.Shots.Hero then
            local Hero = Cutscene.Shots.Hero
            local v123 = v108 * Cutscene.Zoom
            local v124 = v109 + v111 * ((Hero.Right or 0) * v123)
            local v125 = ((Hero.Front or 0) - (Hero.Back or 0)) * v123
            v122 = v124 + Unit_2 * v125 + Vector3.new(0, 1, 0) * ((Hero.Up or 0) * v123)
        end
        local v126 = RaycastParams.new()
        v126.FilterType = Enum.RaycastFilterType.Exclude
        v126.RespectCanCollide = true

        local function clear(v127, v128) -- line 525 | captures: v126, Players, Workspace, v2, Cutscene
            local v129 = {}
            for v130 in v2 do
                table.insert(v129, v130)
            end
            for v131, v132 in Players:GetPlayers() do
                if v132.Character then
                    local Character = v132.Character
                    table.insert(v129, Character)
                end
            end
            v126.FilterDescendantsInstances = v129
            local v133 = v127 - v128
            local v134 = Workspace:Raycast(v128, v133, v126)
            if v134 then
                return v134.Position - v133.Unit * Cutscene.WallPadding
            end
            return v127
        end

        local function focusOf(v135) -- line 547
            local v136 = v135.Parent and v135.Parent:FindFirstChildOfClass("Humanoid")
            local v137
            if v136 then
                v137 = v136.CameraOffset
            else
                v137 = Vector3.new(0, 0, 0)
            end
            return v135.Position + Vector3.new(0, 1.5, 0) + v137
        end

        local Position_3 = CurrentCamera.CFrame.Position
        local v138 = v105.Parent and v105.Parent:FindFirstChildOfClass("Humanoid")
        local v139
        if v138 then
            v139 = v138.CameraOffset
        else
            v139 = Vector3.new(0, 0, 0)
        end
        local v140 = Position_3 - (v105.Position + Vector3.new(0, 1.5, 0) + v139)

        local function home(v141) -- line 553 | captures: v140
            local v142 = v141.Parent and v141.Parent:FindFirstChildOfClass("Humanoid")
            local v143
            if v142 then
                v143 = v142.CameraOffset
            else
                v143 = Vector3.new(0, 0, 0)
            end
            local v144 = v141.Position + Vector3.new(0, 1.5, 0) + v143
            return CFrame.lookAt(v144 + v140, v144)
        end

        local CameraType = CurrentCamera.CameraType
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        local v145 = CurrentCamera.CFrame
        local Start = v104.Start
        local v146 = DropTime + Hold + Return
        CinematicMode.Enter(Cutscene)
        local v147 = false

        local function finish() -- line 569 | captures: v147, CurrentCamera, v140, CameraType, RunService, CinematicMode, LocalPlayer
            if v147 then
                return
            end
            v147 = true
            RunService:UnbindFromRenderStep("RranBossCutscene")
            local v148 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v148 and v148:IsA("BasePart") then
                local v149 = v148.Parent and v148.Parent:FindFirstChildOfClass("Humanoid")
                local v150
                if v149 then
                    v150 = v149.CameraOffset
                else
                    v150 = Vector3.new(0, 0, 0)
                end
                local v151 = v148.Position + Vector3.new(0, 1.5, 0) + v150
                CurrentCamera.CFrame = CFrame.lookAt(v151 + v140, v151)
            end
            local v152 = if CameraType == Enum.CameraType.Scriptable then Enum.CameraType.Custom else CameraType
            CurrentCamera.CameraType = v152
            CinematicMode.Exit()
        end

        local v153 = CurrentCamera.CFrame.Position
        local v154 = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * v108 * 2
        local Value = Enum.RenderPriority.Camera.Value
        local v155 = v122
        RunService:BindToRenderStep("RranBossCutscene", Value, function(v156) -- line 591 | captures: v145, v153, v154, v104, CurrentCamera, DropTime, Hold, Return, v108, Position, v117, v121, clear, v140, Start, finish, v155, Workspace, LocalPlayer, Cutscene
            local v157 = Workspace:GetServerTimeNow() - Start
            local v158 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v104.Model.Parent and v158 and v158:IsA("BasePart") then
                local v159 = Cutscene.Shots.Hero ~= nil
                local v160 = if v159 then DropTime * Cutscene.ApproachShare else DropTime
                local v161, v162
                if v157 < v160 then
                    local v163 = v157 / v160
                    local v164 = math.clamp(v163, 0, 1)
                    local v165 = v164 * v164 * (3 - v164 * 2)
                    v161, v162 = v117:Lerp(v121, v165), v104.Root.Position
                elseif not (v157 < DropTime + Hold) or v159 then
                    if v157 < DropTime + Hold then
                        local v166 = (v157 - v160) / (DropTime - v160)
                        local v167 = math.clamp(v166, 0, 1)
                        local v168 = v167 * v167 * (3 - v167 * 2)
                        v161, v162 = v121:Lerp(v155, v168), v104.Root.Position:Lerp(Position - Vector3.new(0, 1, 0) * (v108 * 0.15), v168)
                    else
                        if v157 < DropTime + Hold + Return then
                            local v169 = (v157 - DropTime - Hold) / Return
                            local v170 = math.clamp(v169, 0, 1)
                            local v171 = v170 * v170 * (3 - v170 * 2)
                            local v172 = v145
                            local v173 = v158.Parent and v158.Parent:FindFirstChildOfClass("Humanoid")
                            local v174
                            if v173 then
                                v174 = v173.CameraOffset
                            else
                                v174 = Vector3.new(0, 0, 0)
                            end
                            local v175 = v158.Position + Vector3.new(0, 1.5, 0) + v174
                            CurrentCamera.CFrame = v172:Lerp(CFrame.lookAt(v175 + v140, v175), v171)
                        else
                            finish()
                        end
                        return
                    end
                else
                    v161, v162 = v121, v104.Root.Position
                end
                local v176 = clear(v161, Position)
                local v177 = -Cutscene.Smoothing * v156
                local v178 = 1 - math.exp(v177)
                v153 = v153:Lerp(v176, v178)
                v154 = v154:Lerp(v162, v178)
                local v179 = CFrame.lookAt(v153, v154)
                v145 = v179
                CurrentCamera.CFrame = v179
            else
                finish()
            end
        end)
        task.delay(v146 + Cutscene.SafetyGrace, finish)
    end
end

local function at(v180, v181, v182, v183) -- line 644 | captures: Workspace, v2
    local LegId = v180.LegId
    local v184 = v181 - Workspace:GetServerTimeNow()
    if v184 < -v182 then
        return
    end
    task.delay(math.max(v184, 0), function() -- line 650 | captures: v180, v183, LegId, v2
        if v2[v180.Model] == v180 and v180.LegId == LegId then
            v183(v180)
        end
    end)
end

local v185, v186

local function idleOn(v187) -- line 667 | captures: v186, RranBossConfig
    if not v187.IdleTrack then
        v187.IdleTrack = v186(v187.Model, RranBossConfig.IdleAnimation, Enum.AnimationPriority.Idle)
    end
    local IdleTrack = v187.IdleTrack
    if IdleTrack and not IdleTrack.IsPlaying then
        IdleTrack:Play(0.25)
    end
    return IdleTrack ~= nil
end

local function idleOff(v188) -- line 678
    local IdleTrack = v188.IdleTrack
    if IdleTrack and IdleTrack.IsPlaying then
        IdleTrack:Stop(0.25)
    end
end

local function walkOn(v189, v190) -- line 685 | captures: v185, RranBossConfig, Event, Clips
    if not v189.WalkTrack then
        v189.WalkTrack = v185(v189.Model)
    end
    local WalkTrack = v189.WalkTrack
    if WalkTrack then
        local WalkSpeed = Event.WalkSpeed
        local WalkAnimationSpeed = RranBossConfig.WalkAnimationSpeed
        local Scale = v189.Scale
        local v191 = WalkSpeed / (WalkAnimationSpeed * math.max(Scale, 0.01)) * v190
        local IdleTrack = v189.IdleTrack
        if IdleTrack and IdleTrack.IsPlaying then
            IdleTrack:Stop(0.25)
        end
        if not WalkTrack.IsPlaying then
            WalkTrack:Play(0.25)
        end
        WalkTrack:AdjustSpeed(v191)
        if v189.Clip then
            v189.Clip = nil
            v189.Animator:Release(0.25)
        end
    elseif v189.Clip ~= "Walk" then
        v189.Clip = "Walk"
        v189.Animator:Play(Clips.Walk)
    end
end

local function jointsOf(v192) -- line 713
    local Joints = v192.Joints
    if not Joints then
        Joints = {}
        for v193, v194 in v192.Model:GetDescendants() do
            if v194:IsA("Motor6D") or v194:IsA("AnimationConstraint") then
                Joints[v194.Name] = v194
            end
        end
        v192.Joints = Joints
    end
    return Joints
end

local function walkOff(v195) -- line 727
    local WalkTrack = v195.WalkTrack
    if WalkTrack and WalkTrack.IsPlaying then
        WalkTrack:Stop(0.25)
    end
end

local function shotTrackFor(v196, v197) -- line 736 | captures: v186
    local v198 = v196.ShotTracks[v197]
    if not v198 then
        v198 = v186(v196.Model, v197, Enum.AnimationPriority.Action)
        if not v198 then
            return nil
        end
        v198.Looped = false
        v196.ShotTracks[v197] = v198
    end
    return v198
end

local function shotOff(v199) -- line 749
    local ShotTrack = v199.ShotTrack
    v199.ShotTrack = nil
    v199.ShotHold = nil
    if ShotTrack and ShotTrack.IsPlaying then
        ShotTrack:Stop(0.25)
    end
end

local function playFull(v200, v201, v202) -- line 760 | captures: v186, Workspace, RranBossConfig, Clips, v2, jointsOf
    local v203 = Clips[v201]
    if not v203 then
        return
    end
    local WalkTrack = v200.WalkTrack
    if WalkTrack and WalkTrack.IsPlaying then
        WalkTrack:Stop(0.25)
    end
    local ShotTrack = v200.ShotTrack
    v200.ShotTrack = nil
    v200.ShotHold = nil
    if ShotTrack and ShotTrack.IsPlaying then
        ShotTrack:Stop(0.25)
    end
    if not v200.IdleTrack then
        v200.IdleTrack = v186(v200.Model, RranBossConfig.IdleAnimation, Enum.AnimationPriority.Idle)
    end
    local IdleTrack = v200.IdleTrack
    if IdleTrack and not IdleTrack.IsPlaying then
        IdleTrack:Play(0.25)
    end
    if IdleTrack ~= nil and v201 == "Idle" then
        if v200.Clip then
            v200.Clip = nil
            v200.Animator:Release(0.25)
        end
    else
        local v204
        if v203.Animation then
            local Animation = v203.Animation
            local v205 = v200.ShotTracks[Animation]
            local v206
            if v205 then
                v204 = v205
                v206 = false
            else
                local v207 = v186(v200.Model, Animation, Enum.AnimationPriority.Action)
                if v207 then
                    v207.Looped = false
                    v200.ShotTracks[Animation] = v207
                    v204 = v207
                    v206 = false
                else
                    v206 = true
                end
            end
            if v206 then
                v204 = nil
            end
        end
        if v204 then
            if v200.Clip then
                v200.Clip = nil
                v200.Animator:Release(0.25)
            end
            local v208 = {}
            local v209 = jointsOf(v200)
            for v210 in RranBossConfig.ShotStance do
                local v211 = v209[v210]
                if v211 then
                    v208[v210] = v211.Transform
                end
            end
            v200.ShotTrack = v204
            v204:Play(0.1)
            local v212 = Workspace:GetServerTimeNow() - v202
            v200.ShotHold = {
                Arms = nil,
                Track = v204,
                Start = v212,
                EndAt = v212 + v203.Length,
                Pre = v208
            }
            local RewindTo = v203.RewindTo
            if v202 > 0 and v204.Length > 0 then
                local Length = v204.Length
                local v213 = math.min(v202, Length)
                if RewindTo and RewindTo < v202 and RewindTo < v204.Length then
                    v213 = RewindTo + (v202 - RewindTo) % (v204.Length - RewindTo)
                end
                v204.TimePosition = v213
            end
            if RewindTo and v203.Shots then
                local v214 = #v203.Shots
                for v215 = 2, v214 do
                    local v216 = v212 + v203.Shots[v215] - 0.016666666666666666
                    local v217 = v204

                    local v218 = function() -- line 813 | captures: v200, RewindTo, v217
                        if v200.ShotTrack == v217 then
                            if not v217.IsPlaying then
                                v217:Play(0)
                            end
                            v217.TimePosition = RewindTo
                        end
                    end

                    local LegId = v200.LegId
                    local v219 = v216 - Workspace:GetServerTimeNow()
                    if not (v219 < -0.2) then
                        task.delay(math.max(v219, 0), function() -- line 650 | captures: v200, v218, LegId, v2
                            if v2[v200.Model] == v200 and v200.LegId == LegId then
                                v218(v200)
                            end
                        end)
                    end
                end
            end
        elseif not (v201 == v200.Clip and v203.Looped) then
            v200.Clip = v201
            v200.Animator:Play(v203, v202)
        end
    end
end

local function playShotLayer(v220, v221, v222) -- line 833 | captures: Workspace, RranBossConfig, Clips, v2
    local v223 = Clips[v221]
    if not v223 then
        return
    end
    local v224 = v223.Length - 0.3

    local function v225() -- line 838 | captures: v220, v222, v223, Workspace, RranBossConfig
        v220.Clip = nil
        local Animator = v220.Animator
        local v226 = Workspace:GetServerTimeNow() - v222
        Animator:Play(v223, math.max(v226, 0), {
            Release = true,
            Mask = RranBossConfig.UpperBody
        })
    end

    local LegId = v220.LegId
    local v227 = v222 - Workspace:GetServerTimeNow()
    if not (v227 < -v224) then
        task.delay(math.max(v227, 0), function() -- line 650 | captures: v220, v225, LegId, v2
            if v2[v220.Model] == v220 and v220.LegId == LegId then
                v225(v220)
            end
        end)
    end
end

local ShotBlendIn = RranBossConfig.ShotBlendIn
local ShotStillRelease = RranBossConfig.ShotStillRelease
local v228 = {}
for v229, v230 in RranBossConfig.ShotStance do
    local fromEulerAnglesXYZ = CFrame.fromEulerAnglesXYZ
    local v231 = v230[1]
    local v232 = math.rad(v231)
    local v233 = v230[2]
    v231 = math.rad(v233)
    local v234 = v230[3]
    v228[v229] = fromEulerAnglesXYZ(v232, v231, (math.rad(v234)))
end

local function steadyRoot(v235) -- line 868 | captures: jointsOf
    local Root = jointsOf(v235).Root
    local Transform, v236
    if Root and Root.Parent then
        Transform = Root.Transform
        if Transform.X == 0 then
            v236 = Transform.Z == 0
        else
            v236 = false
        end
    else
        v236 = true
    end
    if not v236 then
        Root.Transform = CFrame.new(0, Transform.Y, 0) * Transform.Rotation
    end
end

local function holdBody(v237) -- line 878 | captures: Workspace, jointsOf, ShotBlendIn, ShotStillRelease, v228
    local ShotHold = v237.ShotHold
    if not ShotHold then
        return
    end
    local v238 = jointsOf(v237)
    local v239 = Workspace:GetServerTimeNow()
    if ShotHold.EndAt <= v239 then
        v237.ShotHold = nil
    elseif v239 < ShotHold.EndAt - ShotStillRelease then
        local v240 = (v239 - ShotHold.Start) / ShotBlendIn
        local v241 = math.clamp(v240, 0, 1)
        local v242 = v241 * v241 * (3 - v241 * 2)
        for v243, v244 in v228 do
            local v245 = v238[v243]
            if v245 and v245.Parent then
                local v246 = ShotHold.Pre[v243] or v245.Transform
                if v242 >= 1 then
                    v245.Transform = v244
                else
                    v245.Transform = v246:Lerp(v244, v242)
                end
            end
        end
    else
        if not ShotHold.Arms then
            local v247 = {}
            for v248, v249 in v238 do
                if not v228[v248] then
                    v247[v248] = v249.Transform
                end
            end
            ShotHold.Arms = v247
            ShotHold.Track:Stop(0)
            if v237.ShotTrack == ShotHold.Track then
                v237.ShotTrack = nil
            end
        end
        local v250 = (ShotHold.EndAt - v239) / ShotStillRelease
        local v251 = math.clamp(v250, 0, 1)
        local v252 = v251 * v251 * (3 - v251 * 2)
        for v253, v254 in v228 do
            local v255 = v238[v253]
            if v255 and v255.Parent then
                v255.Transform = v255.Transform:Lerp(v254, v252)
            end
        end
        for v256, v257 in ShotHold.Arms do
            local v258 = v238[v256]
            if v258 and v258.Parent then
                v258.Transform = v258.Transform:Lerp(v257, v252)
            end
        end
    end
end

local function readLeg(v259) -- line 938 | captures: v103, Workspace, RranBossConfig, Event, Clips, v2, muzzleBlast, slam, takeOff, setThrusters, sonicBoom, walkOn, playFull
    local Model = v259.Model
    local LegId = Model:GetAttribute("LegId")
    local LegFrom = Model:GetAttribute("LegFrom")
    local LegTo = Model:GetAttribute("LegTo")
    local LegStart = Model:GetAttribute("LegStart")
    local LegEnd = Model:GetAttribute("LegEnd")
    local v260
    if type(LegId) == "number" and typeof(LegFrom) == "CFrame" and typeof(LegTo) == "CFrame" and type(LegStart) == "number" then
        v259.LegId = LegId
        v259.Kind = Model:GetAttribute("LegKind") or "Idle"
        v259.From = LegFrom
        v259.To = LegTo
        v259.Start = LegStart
        if type(LegEnd) == "number" then
            v260 = LegEnd
        else
            v260 = LegStart
        end
    else
        return
    end
    v259.Finish = v260
    local HipOffset = Model:GetAttribute("HipOffset")
    if type(HipOffset) == "number" then
        v259.HipOffset = HipOffset
    end
    if v259.Kind == "Drop" or v259.Kind == "Leave" then
        v259.SmoothY = nil
        v259.SmoothGround = nil
    end
    if v259.Kind ~= "Drop" and v259.Kind ~= "Leave" then
        setThrusters(v259, false)
    end
    local Kind = v259.Kind
    local v261 = Model:GetAttribute("LegClip") or "Idle"
    if Kind == "Walk" or Kind == "Turn" then
        local ShotTrack = v259.ShotTrack
        v259.ShotTrack = nil
        v259.ShotHold = nil
        if ShotTrack and ShotTrack.IsPlaying then
            ShotTrack:Stop(0.25)
        end
        local v262 = if Kind == "Turn" then 0.6 else 1
        walkOn(v259, v262)
    else
        local v263 = Workspace:GetServerTimeNow() - LegStart
        playFull(v259, v261, (math.max(v263, 0)))
    end
    local v264, v265
    if Kind == "Shoot" then
        v264 = Clips[v261]
        v265 = LegStart
    else
        local LegShot = Model:GetAttribute("LegShot")
        local LegShotAt = Model:GetAttribute("LegShotAt")
        if type(LegShot) == "string" then
            if LegShot == "" then
                v265 = LegStart
            elseif type(LegShotAt) == "number" and Clips[LegShot] then
                v264 = Clips[LegShot]
                local v266 = Clips[LegShot]
                if v266 then
                    local v267 = v266.Length - 0.3

                    local function v268() -- line 838 | captures: v259, LegShotAt, v266, Workspace, RranBossConfig
                        v259.Clip = nil
                        local Animator = v259.Animator
                        local v269 = Workspace:GetServerTimeNow() - LegShotAt
                        Animator:Play(v266, math.max(v269, 0), {
                            Release = true,
                            Mask = RranBossConfig.UpperBody
                        })
                    end

                    local LegId = v259.LegId
                    local v270 = LegShotAt - Workspace:GetServerTimeNow()
                    if not (v270 < -v267) then
                        task.delay(math.max(v270, 0), function() -- line 650 | captures: v259, v268, LegId, v2
                            if v2[v259.Model] == v259 and v259.LegId == LegId then
                                v268(v259)
                            end
                        end)
                    end
                end
                v265 = LegShotAt
            else
                v265 = LegStart
            end
        else
            v265 = LegStart
        end
    end
    if v264 and v264.Shots then
        for v271, v272 in v264.Shots do
            local v273 = v265 + v272
            local LegId = v259.LegId
            local v274 = v273 - Workspace:GetServerTimeNow()
            if not (v274 < -0.25) then
                task.delay(math.max(v274, 0), function() -- line 650 | captures: v259, LegId, v2, muzzleBlast
                    if v2[v259.Model] == v259 and v259.LegId == LegId then
                        muzzleBlast(v259)
                    end
                end)
            end
        end
    end
    if Kind == "Drop" then
        local v275 = LegStart + Event.DropTime
        local LegId = v259.LegId
        local v276 = v275 - Workspace:GetServerTimeNow()
        if not (v276 < -0.5) then
            task.delay(math.max(v276, 0), function() -- line 650 | captures: v259, LegId, v2, slam
                if v2[v259.Model] == v259 and v259.LegId == LegId then
                    slam(v259)
                end
            end)
        end
        v103(v259)
    elseif Kind == "Leave" then
        local v277 = LegStart + Event.LeaveCrouch
        local LegId = v259.LegId
        local v278 = v277 - Workspace:GetServerTimeNow()
        if not (v278 < -0.3) then
            task.delay(math.max(v278, 0), function() -- line 650 | captures: v259, LegId, v2, takeOff
                if v2[v259.Model] == v259 and v259.LegId == LegId then
                    takeOff(v259)
                end
            end)
        end
        local v279 = Event.LeaveTime - Event.LeaveCrouch
        local v280 = LegStart + Event.LeaveCrouch + v279 * 0.3
        local LegId_2 = v259.LegId
        local v281 = v280 - Workspace:GetServerTimeNow()
        if v281 < -0.3 then
            return
        end
        task.delay(math.max(v281, 0), function() -- line 650 | captures: v259, LegId_2, v2, sonicBoom
            if v2[v259.Model] == v259 and v259.LegId == LegId_2 then
                sonicBoom(v259)
            end
        end)
    end
end

local v282 = { "LeftFoot", "RightFoot" }

local function feetDrop(v283) -- line 1015 | captures: v282
    local v284 = (1/0)
    for v285, v286 in v282 do
        local v287 = v283.Model:FindFirstChild(v286)
        if v287 and v287:IsA("BasePart") then
            local CFrame = v287.CFrame
            local Size = v287.Size
            local Y = CFrame.RightVector.Y
            local v288 = math.abs(Y) * Size.X
            local Y_2 = CFrame.UpVector.Y
            local v289 = v288 + math.abs(Y_2) * Size.Y
            local Y_3 = CFrame.LookVector.Y
            local v290 = (v289 + math.abs(Y_3) * Size.Z) / 2
            local v291 = v287.Position.Y - v290
            v284 = math.min(v284, v291)
        end
    end
    if v284 == (1/0) then
        return v283.HipOffset
    end
    return v283.Root.Position.Y - v284
end

local function groundedY(v292, v293, v294) -- line 1031 | captures: RranBossGround, Event, feetDrop
    local v295
    if not (v292.GroundPos and (v292.GroundPos - v293).Magnitude < 0.25) then
        local Height = RranBossGround.Height
        local HipOffset = v292.HipOffset
        v295 = Height(v293 - Vector3.new(0, HipOffset, 0), Event.StepUp)
        v292.GroundPos = v293
        v292.GroundY = v295
    else
        v295 = v292.GroundY
    end
    local v296 = feetDrop(v292)
    local v297 = v295 or v293.Y - v296
    local v298 = v292.SmoothGround or (v292.SmoothY or v292.Root.Position.Y) - v296
    local v299 = v297 - v298
    local v300 = v294 * -12
    local v301 = v298 + v299 * (1 - math.exp(v300))
    local v302 = v297 - v301
    if not (math.abs(v302) < 0.003) then
        v297 = v301
    end
    v292.SmoothGround = v297
    local v303 = v297 + v296
    v292.SmoothY = v303
    return v303
end

local function place(v304, v305) -- line 1062 | captures: TweenService, Workspace, RranBossConfig, RranBossGround, Event, flyingCFrame, setThrusters, groundedY
    local v306 = Workspace:GetServerTimeNow()
    local Kind = v304.Kind
    local v307 = v304.Finish - v304.Start
    local v308 = math.max(v307, 0.001)
    local v309 = (v306 - v304.Start) / v308
    local v310 = math.clamp(v309, 0, 1)
    if Kind == "Walk" then
        local v311 = v304.From.Position:Lerp(v304.To.Position, v310)
        local v312 = groundedY(v304, v311, v305)
        return CFrame.new(v311.X, v312, v311.Z) * v304.To.Rotation
    end
    if Kind == "Turn" then
        local v313 = TweenService:GetValue(v310, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local v314 = v304.From:Lerp(v304.To, v313)
        local v315 = groundedY(v304, v314.Position, v305)
        return CFrame.new(v314.X, v315, v314.Z) * v314.Rotation
    end
    if Kind == "Drop" then
        local v316 = v306 - v304.Start
        local DropTime = Event.DropTime
        local v317 = v316 / math.max(DropTime, 0.01)
        local v318 = math.clamp(v317, 0, 1)
        local v319 = 1 - (1 - v318) ^ 2.2
        if not (v304.LandY and v304.LandLeg == v304.LegId) then
            v304.LandLeg = v304.LegId
            local v320 = v304.To.Position + Vector3.new(0, 60, 0)
            local HipOffset = v304.HipOffset
            local v321 = v320 - Vector3.new(0, HipOffset, 0)
            local v322 = RranBossGround.Height(v321, 0)
            if v322 then
                v304.LandY = v322 + v304.HipOffset
            else
                v304.LandY = v304.To.Position.Y
            end
        end
        local Position = v304.From.Position
        local X = v304.To.X
        local LandY = v304.LandY
        local Z = v304.To.Z
        local v323 = Vector3.new(X, LandY, Z)
        local v324 = v323.X - Position.X
        local v325 = v323.Z - Position.Z
        local v326 = Vector3.new(v324, 0, v325)
        local v327 = Position.Y - v323.Y
        local v328 = math.max(v327, 1)
        local v329 = Position + v326 * 0.5
        local v330 = v323 + Vector3.new(0, 1, 0) * (v328 * 0.55)
        local v331 = 1 - v319
        local v332 = Position * (v331 * v331 * v331) + v329 * (v331 * 3 * v331 * v319) + v330 * (v331 * 3 * v319 * v319) + v323 * (v319 * v319 * v319)
        local v333 = v319 + 0.02
        local v334 = math.min(v333, 1)
        local v335 = v323.X - Position.X
        local v336 = v323.Z - Position.Z
        local v337 = Vector3.new(v335, 0, v336)
        local v338 = Position.Y - v323.Y
        local v339 = math.max(v338, 1)
        local v340 = Position + v337 * 0.5
        local v341 = v323 + Vector3.new(0, 1, 0) * (v339 * 0.55)
        local v342 = 1 - v334
        local v343 = Position * (v342 * v342 * v342) + v340 * (v342 * 3 * v342 * v334) + v341 * (v342 * 3 * v334 * v334) + v323 * (v334 * v334 * v334) - v332
        if not (v343.Magnitude > 0.01) then
            v343 = v304.To.LookVector
        end
        local v344 = flyingCFrame(v332, v343, v304.To.LookVector)
        local v345 = (v318 - 0.6) / 0.25
        local v346 = math.clamp(v345, 0, 1)
        local v347 = v346 * v346 * (3 - v346 * 2)
        setThrusters(v304, v318 < 0.95)
        local v348 = v344:Lerp(CFrame.new(v332) * v304.To.Rotation, v347)
        if v318 >= 1 then
            v304.SmoothY = v348.Position.Y
            v304.SmoothGround = nil
        end
        return v348
    end
    if Kind == "Leave" then
        local v349 = Event.LeaveTime - Event.LeaveCrouch
        local v350 = math.max(v349, 0.01)
        local v351 = (v306 - v304.Start - Event.LeaveCrouch) / v350
        local v352 = math.clamp(v351, 0, 1)
        if v306 - v304.Start < Event.LeaveCrouch then
            setThrusters(v304, false)
            return v304.From
        end
        setThrusters(v304, true)
        local v353 = math.clamp(v352, 0, 1)
        local v354 = v353 - v304.Fade
        if not (math.abs(v354) < 0.01) then
            v304.Fade = v353
            for v355, v356 in v304.Visuals do
                v356.LocalTransparencyModifier = v353
            end
            local Outline = v304.Outline
            if Outline then
                local Transparency = RranBossConfig.Outline.Transparency
                Outline.OutlineTransparency = Transparency + (1 - Transparency) * v353
            end
        end
        local v357 = v352 ^ 1.7
        local Position = v304.From.Position
        local Position_2 = v304.To.Position
        local v358 = Position_2.X - Position.X
        local v359 = Position_2.Z - Position.Z
        local v360 = Vector3.new(v358, 0, v359)
        local v361 = Position_2.Y - Position.Y
        local v362 = math.max(v361, 1)
        local v363 = Position + Vector3.new(0, 1, 0) * (v362 * 0.45)
        local v364 = Position + v360 * 0.45 + Vector3.new(0, 1, 0) * v362
        local v365 = 1 - v357
        local v366 = Position * (v365 * v365 * v365) + v363 * (v365 * 3 * v365 * v357) + v364 * (v365 * 3 * v357 * v357) + Position_2 * (v357 * v357 * v357)
        local v367 = v357 + 0.02
        local v368 = math.min(v367, 1)
        local v369 = Position_2.X - Position.X
        local v370 = Position_2.Z - Position.Z
        local v371 = Vector3.new(v369, 0, v370)
        local v372 = Position_2.Y - Position.Y
        local v373 = math.max(v372, 1)
        local v374 = Position + Vector3.new(0, 1, 0) * (v373 * 0.45)
        local v375 = Position + v371 * 0.45 + Vector3.new(0, 1, 0) * v373
        local v376 = 1 - v368
        local v377 = Position * (v376 * v376 * v376) + v374 * (v376 * 3 * v376 * v368) + v375 * (v376 * 3 * v368 * v368) + Position_2 * (v368 * v368 * v368) - v366
        if not (v377.Magnitude > 0.01) then
            v377 = Vector3.new(0, 1, 0)
        end
        local v378 = flyingCFrame(v366, v377, v304.From.LookVector)
        local v379 = v352 / 0.3
        local v380 = math.clamp(v379, 0, 1)
        local v381 = v380 * v380 * (3 - v380 * 2)
        return (CFrame.new(v366) * v304.From.Rotation):Lerp(v378, v381)
    end
    local v382 = groundedY(v304, v304.To.Position, v305)
    return CFrame.new(v304.To.X, v382, v304.To.Z) * v304.To.Rotation
end

local function footsteps(v383) -- line 1129 | captures: stomp
    local WalkTrack = v383.WalkTrack
    if WalkTrack and WalkTrack.IsPlaying and WalkTrack.Length > 0 and v383.Kind == "Walk" then
        local v384 = WalkTrack.Length / 2
        local TimePosition = WalkTrack.TimePosition
        local WalkPhase = v383.WalkPhase
        if WalkPhase >= 0 then
            if WalkPhase < v384 and v384 <= TimePosition then
                local v385 = not not (TimePosition < WalkPhase)
                stomp(v383)
            elseif TimePosition < WalkPhase then
                stomp(v383)
            end
        end
        v383.WalkPhase = TimePosition
    else
        v383.WalkPhase = -1
    end
end

local function drop(v386) -- line 1152 | captures: v2, setThrusters
    local v387 = v2[v386]
    if not v387 then
        return
    end
    v2[v386] = nil
    for v388, v389 in v387.Connections do
        v389:Disconnect()
    end
    local WalkTrack = v387.WalkTrack
    if WalkTrack and WalkTrack.IsPlaying then
        WalkTrack:Stop(0.25)
    end
    local ShotTrack = v387.ShotTrack
    v387.ShotTrack = nil
    v387.ShotHold = nil
    if ShotTrack and ShotTrack.IsPlaying then
        ShotTrack:Stop(0.25)
    end
    setThrusters(v387, false)
    v387.Animator:Stop()
end

function v186(v390, v391, v392) -- line 1170
    local Humanoid = v390:FindFirstChildOfClass("Humanoid")
    if v391 and Humanoid then
        local Animator = Humanoid:FindFirstChildOfClass("Animator")
        if Animator then
            local Animation = Instance.new("Animation")
            Animation.AnimationId = v391
            local v393, v394 = pcall(function() -- line 1181 | captures: Animator, Animation
                return Animator:LoadAnimation(Animation)
            end)
            if not v393 or not v394 then
                warn((("[RranBossController] couldn't load %*: %*"):format(v391, v394)))
                return nil
            end
            v394.Priority = v392
            v394.Looped = true
            return v394
        end
    end
    return nil
end

function v185(v395) -- line 1193 | captures: v186, RranBossConfig
    return v186(v395, RranBossConfig.WalkAnimation, Enum.AnimationPriority.Movement)
end

local function adopt(v396) -- line 1197 | captures: v185, v186, RunService, Workspace, RranBossConfig, JointAnimator, Clips, v2, outlineColorFor, makeThrusters, jointsOf, playFull, holdBody, readLeg, place, footsteps, drop
    local function v397(v398, ...)
        table.insert(v398, ...)
    end

    local function v399(v400, ...)
        table.insert(v400, ...)
    end

    if v396:IsA("Model") and not v2[v396] then
        local v401 = v396:WaitForChild("HumanoidRootPart", 10)
        if v401 and v401:IsA("BasePart") and v396.Parent and not v2[v396] then
            local JointCount = v396:GetAttribute("JointCount")
            local v402 = os.clock() + 6
            while v396.Parent do
                if os.clock() < v402 then
                    local v403 = 0
                    for v404, v405 in v396:GetDescendants() do
                        if v405:IsA("Motor6D") or v405:IsA("AnimationConstraint") then
                            v403 += 1
                        end
                    end
                    local Humanoid = v396:FindFirstChildOfClass("Humanoid")
                    local v406 = if Humanoid == nil then false else Humanoid:FindFirstChildOfClass("Animator") ~= nil
                    local v407
                    if type(JointCount) == "number" then
                        if JointCount <= v403 then
                            v407 = not not v406
                        else
                            v407 = false
                        end
                    else
                        v407 = not not v406
                    end
                    if v407 then
                        break
                    end
                    task.wait(0.1)
                    continue
                end
                break
            end
            if v396.Parent and not v2[v396] then
                v396.PrimaryPart = v401
                local v408 = outlineColorFor(v396)
                local v409 = {
                    ShotTrack = nil,
                    ShotHold = nil,
                    Joints = nil,
                    WalkPhase = -1,
                    Clip = nil,
                    LegId = -1,
                    Kind = "Idle",
                    SmoothY = nil,
                    SmoothGround = nil,
                    LastCFrame = nil,
                    LandY = nil,
                    LandLeg = nil,
                    ThrustersOn = false,
                    StopFlySound = nil,
                    Outline = nil,
                    Fade = 0,
                    Model = v396,
                    Root = v401,
                    Animator = JointAnimator.new(v396, Clips.Idle, RranBossConfig.Poses),
                    WalkTrack = v185(v396),
                    IdleTrack = v186(v396, RranBossConfig.IdleAnimation, Enum.AnimationPriority.Idle),
                    ShotTracks = {},
                    From = v401.CFrame,
                    To = v401.CFrame,
                    Start = Workspace:GetServerTimeNow(),
                    Finish = Workspace:GetServerTimeNow(),
                    HipOffset = v396:GetAttribute("HipOffset") or 0,
                    Scale = v396:GetScale(),
                    Color = v408,
                    Thrusters = makeThrusters(v396, v408),
                    Visuals = {},
                    Connections = {}
                }
                v2[v396] = v409
                for v410, v411 in Clips do
                    if v411.Animation then
                        local Animation = v411.Animation
                        if not v409.ShotTracks[Animation] then
                            local v412 = v186(v409.Model, Animation, Enum.AnimationPriority.Action)
                            if v412 then
                                v412.Looped = false
                                v409.ShotTracks[Animation] = v412
                            end
                        end
                    end
                end
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "BossOutline"
                Highlight.Adornee = v396
                Highlight.FillTransparency = 1
                Highlight.OutlineColor = v409.Color
                Highlight.OutlineTransparency = RranBossConfig.Outline.Transparency
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight.Enabled = true
                Highlight.Parent = v396
                v409.Outline = Highlight
                for v413, v414 in v396:GetDescendants() do
                    if v414:IsA("BasePart") or v414:IsA("Decal") then
                        local Visuals = v409.Visuals
                        table.insert(Visuals, v414)
                    end
                end
                readLeg(v409)
                if v409.LegId < 0 then
                    playFull(v409, "Idle", 0)
                end
                v397(v409.Connections, v396:GetAttributeChangedSignal("LegId"):Connect(function() -- line 1293 | captures: v409, readLeg
                    readLeg(v409)
                end))
                v399(v409.Connections, RunService.PreSimulation:Connect(function(v415) -- line 1299 | captures: v396, v401, v409, jointsOf, holdBody, place, footsteps, drop
                    if v396.Parent then
                        local v416 = place(v409, v415)
                        if v416 ~= v409.LastCFrame then
                            v409.LastCFrame = v416
                            v401.CFrame = v416
                        end
                        local Root, Transform, v417
                        if v409.Kind == "Idle" or v409.Kind == "Shoot" then
                            Root = jointsOf(v409).Root
                            if Root and Root.Parent then
                                Transform = Root.Transform
                                if Transform.X == 0 then
                                    v417 = Transform.Z == 0
                                else
                                    v417 = false
                                end
                            else
                                v417 = true
                            end
                        else
                            v417 = true
                        end
                        if not v417 then
                            Root.Transform = CFrame.new(0, Transform.Y, 0) * Transform.Rotation
                        end
                        holdBody(v409)
                        footsteps(v409)
                    else
                        drop(v396)
                    end
                end))
            end
        end
    end
end

function v1.Start() -- line 1321 | captures: CollectionService, RranBossConfig, CinematicMode, LocalPlayer, Cutscene, drop, adopt
    task.spawn(function() -- line 1324 | captures: CinematicMode, LocalPlayer, Cutscene
        LocalPlayer:WaitForChild("PlayerGui"):WaitForChild(Cutscene.BarsGui, 30)
        CinematicMode.ParkBars(Cutscene)
    end)
    for v418, v419 in CollectionService:GetTagged(RranBossConfig.Tag) do
        task.spawn(adopt, v419)
    end
    CollectionService:GetInstanceAddedSignal(RranBossConfig.Tag):Connect(function(v420) -- line 1333 | captures: adopt
        task.spawn(adopt, v420)
    end)
    CollectionService:GetInstanceRemovedSignal(RranBossConfig.Tag):Connect(function(v421) -- line 1336 | captures: drop
        if v421:IsA("Model") then
            drop(v421)
        end
    end)
end

return v1
