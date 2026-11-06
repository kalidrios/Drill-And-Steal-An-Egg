-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local GuardMorphConfig = require(ReplicatedStorage.Shared.GuardMorphConfig)
local GuardSfx = require(ReplicatedStorage.Shared.GuardSfx)
local GuardSfxConfig = require(ReplicatedStorage.Shared.GuardSfxConfig)
local CameraShaker = require(script.Parent.Parent.Modules.CameraShaker)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3

local function yawOf(v4) -- line 80
    local LookVector = v4.LookVector
    local v5 = -LookVector.X
    local v6 = -LookVector.Z
    return (math.atan2(v5, v6))
end

local function wrapAngle(v7) -- line 86
    return (v7 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function collectWelds(v8) -- line 90 | captures: GuardMorphConfig
    for v9, v10 in v8.Model:GetDescendants() do
        if v10:IsA("Weld") and v10.Name == GuardMorphConfig.WeldName and v10.Part0 then
            local Welds = v8.Welds
            local v11 = {
                Weld = v10,
                Base = v10.C0
            }
            table.insert(Welds, v11)
            v8.Root = v10.Part0
        end
    end
end

local function easeTurn(v12, v13) -- line 104 | captures: GuardMorphConfig, collectWelds
    if #v12.Welds == 0 then
        local v14 = os.clock()
        if v14 < v12.NextWeldLookAt then
            return
        end
        v12.NextWeldLookAt = v14 + 0.25
        collectWelds(v12)
        if #v12.Welds == 0 then
            return
        end
    end
    local Root = v12.Root
    if not (Root and Root.Parent) then
        return
    end
    local LookVector = Root.CFrame.LookVector
    local v15 = -LookVector.X
    local v16 = -LookVector.Z
    local v17 = math.atan2(v15, v16)
    local v18 = v12.Yaw or v17
    local v19 = -GuardMorphConfig.TurnResponsiveness * v13
    local v20 = 1 - math.exp(v19)
    local v21 = v18 + ((v17 - v18 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v20
    v12.Yaw = v21
    local v22 = (v21 - v17 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
    local v23 = v22 - v12.Lag
    if math.abs(v23) < 0.001 then
        return
    end
    v12.Lag = v22
    local v24 = CFrame.Angles(0, v22, 0)
    for v25, v26 in v12.Welds do
        if v26.Weld.Parent then
            v26.Weld.C0 = v24 * v26.Base
        end
    end
end

local v27

local function shake(v28, v29) -- line 146 | captures: v27, Workspace, CameraShaker
    if not v27 then
        v27 = CameraShaker.new(Enum.RenderPriority.Camera.Value + 1, function(v30) -- line 148 | captures: Workspace
            local CurrentCamera = Workspace.CurrentCamera
            if CurrentCamera then
                CurrentCamera.CFrame *= v30
            end
        end)
        v27:Start()
    end
    local v31 = v29 or 1
    v27:ShakeOnce(v28[1] * v31, v28[2], v28[3], v28[4])
end

local function takeCooldown(v32, v33) -- line 164 | captures: GuardSfxConfig
    local v34 = os.clock()
    if v34 - (v32.LastCueAt[v33] or 0) < GuardSfxConfig.Cooldown then
        return false
    end
    v32.LastCueAt[v33] = v34
    return true
end

local function loadAttack(v35) -- line 173
    local Animations = v35.Model:FindFirstChild("Animations")
    local v36 = Animations and Animations:FindFirstChild("Attack")
    if not (v36 and v36:IsA("Animation") and v36.AnimationId ~= "") then
        return
    end
    local AnimationController = v35.Model:FindFirstChildOfClass("AnimationController")
    if not AnimationController then
        return
    end
    local Animator = AnimationController:FindFirstChildOfClass("Animator")
    local Animator_2 = Animator
    if not Animator then
        local Animator = Instance.new("Animator")
        Animator_2 = Animator
        Animator.Parent = AnimationController
    end
    local v37, v38 = pcall(function() -- line 188 | captures: Animator_2, v36
        return Animator_2:LoadAnimation(v36)
    end)
    if v37 and v38 then
        v38.Priority = Enum.AnimationPriority.Action
        v38.Looped = false
        v35.Attack = v38
    end
end

local function swing(v39) -- line 198
    local Attack = v39.Attack
    if Attack then
        if Attack.IsPlaying then
            Attack:Stop(0)
        end
        Attack:Play(0.1)
    end
end

local function isMine(v40) -- line 209 | captures: GuardMorphConfig, LocalPlayer
    return v40:GetAttribute(GuardMorphConfig.OwnerAttribute) == LocalPlayer.UserId
end

local v41

local function updateCamera() -- line 235 | captures: v41, v2
    local v42 = v41
    if v42 then
        local Humanoid = v42.Humanoid
        if Humanoid.Parent then
            local v43 = v2[v42.Model]
            local v44 = if v43 then v43.Lag else 0
            local v45 = CFrame.Angles(0, v44, 0) * v42.Offset
            local LastWritten = v42.LastWritten
            if not (LastWritten ~= nil) or (v45 - LastWritten).Magnitude > 0.01 or not (Humanoid.CameraOffset ~= Vector3.new(0, 0, 0)) then
                Humanoid.CameraOffset = v45
                v42.LastWritten = v45
            end
        end
    end
end

local function releaseOwn() -- line 254 | captures: v41, ContextActionService, LocalPlayer
    local v46 = v41
    if not v46 then
        return
    end
    v41 = nil
    for v47, v48 in v46.Connections do
        v48:Disconnect()
    end
    ContextActionService:UnbindAction("GuardMorphRoar")
    if v46.Humanoid.Parent and v46.Humanoid.CameraOffset == v46.LastWritten then
        v46.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end
    LocalPlayer.CameraMaxZoomDistance = v46.SavedMaxZoom
    LocalPlayer.CameraMinZoomDistance = v46.SavedMinZoom
end

local function onRoarAction(v49, v50) -- line 271 | captures: v3, v41
    if v50 == Enum.UserInputState.Begin and v41 and v3 then
        v3:FireServer("Roar")
    end
    return Enum.ContextActionResult.Pass
end

local function claimOwn(v51) -- line 279 | captures: v41, ContextActionService, RunService, GuardMorphConfig, LocalPlayer, shake, updateCamera, releaseOwn, onRoarAction
    local function v52(v53, ...)
        table.insert(v53, ...)
    end

    local function v54(v55, ...)
        table.insert(v55, ...)
    end

    local Character = LocalPlayer.Character
    local v56 = Character and Character:FindFirstChildOfClass("Humanoid")
    if not v56 then
        return
    end
    releaseOwn()
    local v57 = v51:GetAttribute(GuardMorphConfig.HeadAttribute)
    local v58 = v51:GetAttribute(GuardMorphConfig.SizeAttribute)
    local v59
    if typeof(v57) == "Vector3" then
        local CameraSubjectHeight = GuardMorphConfig.CameraSubjectHeight
        v59 = v57 - Vector3.new(0, CameraSubjectHeight, 0)
    else
        v59 = Vector3.new(0, 0, 0)
    end
    local v60 = {
        LastWritten = nil,
        Model = v51,
        Humanoid = v56,
        Offset = v59,
        SavedMinZoom = LocalPlayer.CameraMinZoomDistance,
        SavedMaxZoom = LocalPlayer.CameraMaxZoomDistance,
        Connections = {}
    }
    v41 = v60
    updateCamera()
    local v61
    if typeof(v58) == "Vector3" then
        local X = v58.X
        local Y = v58.Y
        local Z = v58.Z
        v61 = math.max(X, Y, Z)
    else
        v61 = 0
    end
    local v62 = v61 * GuardMorphConfig.ZoomPerSize
    local MinZoom = GuardMorphConfig.MinZoom
    local MaxZoom = GuardMorphConfig.MaxZoom
    local v63 = math.clamp(v62, MinZoom, MaxZoom)
    local SavedMaxZoom = v60.SavedMaxZoom
    local v64 = v63 * 2
    LocalPlayer.CameraMaxZoomDistance = math.max(SavedMaxZoom, v64)
    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
    LocalPlayer.CameraMinZoomDistance = math.min(v63, CameraMaxZoomDistance)
    task.delay(0.25, function() -- line 313 | captures: v60, v41, LocalPlayer
        if v41 == v60 then
            LocalPlayer.CameraMinZoomDistance = v60.SavedMinZoom
        end
    end)
    ContextActionService:BindAction("GuardMorphRoar", onRoarAction, false, GuardMorphConfig.RoarKey, GuardMorphConfig.RoarGamepadKey)
    local v65 = 0
    v52(v60.Connections, RunService.Heartbeat:Connect(function() -- line 329 | captures: v65, v56
        if v56.Parent and v56:GetState() == Enum.HumanoidStateType.Freefall then
            local RootPart = v56.RootPart
            if RootPart then
                local v66 = v65
                local v67 = -RootPart.AssemblyLinearVelocity.Y
                v65 = math.max(v66, v67)
            end
        end
    end))
    v54(v60.Connections, v56.StateChanged:Connect(function(v68, v69) -- line 340 | captures: v65, GuardMorphConfig, shake
        if v69 ~= Enum.HumanoidStateType.Landed then
            return
        end
        local v70 = v65
        if GuardMorphConfig.LandingMinFallSpeed <= v70 then
            local Landing = GuardMorphConfig.Shakes.Landing
            local v71 = v65 / 80
            shake(Landing, (math.min(v71, 1.5)))
        end
        v65 = 0
    end))
end

local function track(v72) -- line 354 | captures: GuardMorphConfig, GuardSfx, LocalPlayer, v2, loadAttack, claimOwn
    local v73, v74, v75
    if v72:IsA("Model") then
        if v2[v72] then
            v75 = true
        else
            v73 = {
                Voice = nil,
                Attack = nil,
                Root = nil,
                NextWeldLookAt = 0,
                Yaw = nil,
                Lag = 0,
                Model = v72,
                ZoneId = v72:GetAttribute(GuardMorphConfig.ZoneAttribute),
                LastCueAt = {},
                Welds = {}
            }
            v2[v72] = v73
            v74 = v72:GetAttribute(GuardMorphConfig.OwnerAttribute) == LocalPlayer.UserId
            v75 = false
        end
    else
        v75 = true
    end
    if v75 then
        return
    end
    if v74 then
        claimOwn(v72)
    end
    local spawn = task.spawn
    local v76 = v73
    spawn(function() -- line 378 | captures: v72, v76, GuardSfx, v2, loadAttack
        for v77 = 1, 10 do
            if v2[v72] == v76 then
                local v78 = GuardSfx.Attach(v72, v76.ZoneId)
                if v78 then
                    v76.Voice = v78
                    break
                end
                if v77 < 10 then
                    task.wait(0.5)
                end
            else
                return
            end
        end
        if v2[v72] == v76 then
            loadAttack(v76)
        end
    end)
end

local function untrack(v79) -- line 398 | captures: v41, GuardSfx, v2, releaseOwn
    local v80 = v2[v79]
    if not v80 then
        return
    end
    v2[v79] = nil
    if v80.Voice then
        GuardSfx.Detach(v80.Voice)
    end
    if v80.Attack then
        v80.Attack:Stop(0)
        v80.Attack:Destroy()
    end
    if v41 and v41.Model == v79 then
        releaseOwn()
    end
end

local function onHit(v81, v82) -- line 420 | captures: GuardMorphConfig, GuardSfx, GuardSfxConfig, LocalPlayer, v2, shake
    local v83 = v2[v81]
    if not v83 then
        return
    end
    local Attack = v83.Attack
    if Attack then
        if Attack.IsPlaying then
            Attack:Stop(0)
        end
        Attack:Play(0.1)
    end
    if v82 == LocalPlayer.UserId then
        GuardSfx.PlayCatch2D(v83.ZoneId)
        shake(GuardMorphConfig.Shakes.Victim)
    else
        if v83.Voice then
            GuardSfx.Stop(v83.Voice)
            local v84 = os.clock()
            if not (v84 - (v83.LastCueAt.Catch or 0) < GuardSfxConfig.Cooldown) then
                v83.LastCueAt.Catch = v84
                GuardSfx.PlayCatch(v83.Voice)
            end
        end
        if v81:GetAttribute(GuardMorphConfig.OwnerAttribute) == LocalPlayer.UserId then
            shake(GuardMorphConfig.Shakes.HitOwner)
        end
    end
end

local function onRoar(v85) -- line 444 | captures: GuardMorphConfig, GuardSfx, GuardSfxConfig, LocalPlayer, v2, shake
    local v86 = v2[v85]
    if not v86 then
        return
    end
    local Attack = v86.Attack
    if Attack then
        if Attack.IsPlaying then
            Attack:Stop(0)
        end
        Attack:Play(0.1)
    end
    if v86.Voice then
        local v87 = os.clock()
        if not (v87 - (v86.LastCueAt.Roar or 0) < GuardSfxConfig.Cooldown) then
            v86.LastCueAt.Roar = v87
            GuardSfx.Stop(v86.Voice)
            GuardSfx.PlayLock(v86.Voice)
        end
    end
    local Character = LocalPlayer.Character
    local v88 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v89 = v85.PrimaryPart or v85:FindFirstChildWhichIsA("BasePart", true)
    if not (v88 and v89) then
        return
    end
    local Magnitude = (v88.Position - v89.Position).Magnitude
    local RoarShakeRadius = GuardMorphConfig.RoarShakeRadius
    if Magnitude < RoarShakeRadius then
        shake(GuardMorphConfig.Shakes.Roar, 1 - Magnitude / RoarShakeRadius)
    end
end

function v1.Start() -- line 468 | captures: v3, CollectionService, ReplicatedStorage, RunService, GuardMorphConfig, v2, easeTurn, updateCamera, track, untrack, onHit, onRoar
    for v90, v91 in CollectionService:GetTagged(GuardMorphConfig.Tag) do
        track(v91)
    end
    CollectionService:GetInstanceAddedSignal(GuardMorphConfig.Tag):Connect(track)
    CollectionService:GetInstanceRemovedSignal(GuardMorphConfig.Tag):Connect(untrack)
    RunService:BindToRenderStep("GuardMorphTurn", Enum.RenderPriority.Camera.Value - 1, function(v92) -- line 477 | captures: v2, easeTurn, updateCamera
        for v93, v94 in v2 do
            easeTurn(v94, v92)
        end
        updateCamera()
    end)
    local v95 = ReplicatedStorage:WaitForChild(GuardMorphConfig.RemoteName, 30)
    if not (v95 and v95:IsA("RemoteEvent")) then
        warn((("[GuardMorphController] ReplicatedStorage.%* not found"):format(GuardMorphConfig.RemoteName)))
    else
        v3 = v95
        v95.OnClientEvent:Connect(function(v96, v97, v98) -- line 490 | captures: onHit, onRoar
            if typeof(v97) == "Instance" and v97:IsA("Model") then
                if v96 == "Hit" then
                    onHit(v97, v98)
                elseif v96 == "Roar" then
                    onRoar(v97)
                end
            end
        end)
    end
end

return v1
