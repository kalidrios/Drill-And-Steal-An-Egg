-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local PublicTreadmillConfig = require(ReplicatedStorage.Shared.PublicTreadmillConfig)
local RranBossConfig = require(ReplicatedStorage.Shared.RranBossConfig)
local Modules = script.Parent.Parent.Modules
local AdminTreadmillCutscene = require(Modules.AdminTreadmillCutscene)
local CameraShaker = require(Modules.CameraShaker)
local EggLandImpact = require(Modules.EggLandImpact)
local SpatialSfx = require(Modules.SpatialSfx)
local VFXBurst = require(Modules.VFXBurst)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local AdminSpawn = PublicTreadmillConfig.AdminSpawn
local v2

local function now() -- line 48 | captures: Workspace
    return Workspace:GetServerTimeNow()
end

local function shake(v3) -- line 52 | captures: v2, Workspace, AdminTreadmillCutscene, CameraShaker, LocalPlayer, AdminSpawn
    local Character = LocalPlayer.Character
    local v4 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v4 and v4:IsA("BasePart")) then
        return
    end
    local Magnitude = (v4.Position - v3).Magnitude
    local v5 = AdminTreadmillCutscene.IsPlaying()
    if AdminSpawn.ShakeRadius <= Magnitude and not v5 then
        return
    end
    if not v2 then
        v2 = CameraShaker.new(Enum.RenderPriority.Camera.Value + 1, function(v6) -- line 65 | captures: Workspace
            local CurrentCamera = Workspace.CurrentCamera
            if CurrentCamera then
                CurrentCamera.CFrame *= v6
            end
        end)
        v2:Start()
    end
    local v7 = if v5 then AdminSpawn.Cutscene.ShakeScale else 1 - Magnitude / AdminSpawn.ShakeRadius
    v2:ShakeOnce(AdminSpawn.ShakeMagnitude * v7, 12, 0.03, 1.1)
end

local function fallSound(v8, v9) -- line 81 | captures: Debris, TweenService, Workspace, RranBossConfig, SpatialSfx, AdminSpawn
    local v10 = SpatialSfx.Play(RranBossConfig.Sfx.Folder, AdminSpawn.FallSound, {
        At = v8,
        Range = AdminSpawn.SlamRange,
        MinRange = AdminSpawn.SlamRange * 0.15,
        RollOffMode = Enum.RollOffMode.Linear
    })
    if v10 then
        local v11 = (v9 - Workspace:GetServerTimeNow()) * v10.PlaybackSpeed
        if v11 < v10.TimeLength then
            v10.TimePosition = v10.TimeLength - v11
        end
        return function() -- line 95 | captures: v10, Debris, TweenService, AdminSpawn
            if v10.Parent then
                TweenService:Create(v10, TweenInfo.new(AdminSpawn.FallSoundFadeOut), { Volume = 0 }):Play()
                Debris:AddItem(v10, AdminSpawn.FallSoundFadeOut + 0.05)
            end
        end
    end
    return function() -- line 89
    end
end

local function slam(v12, v13) -- line 105 | captures: RranBossConfig, EggLandImpact, SpatialSfx, VFXBurst, AdminSpawn, shake
    VFXBurst.Play(AdminSpawn.LandBlastName, CFrame.new(v12), AdminSpawn.LandBlastScale)
    VFXBurst.Play(AdminSpawn.SmokeName, CFrame.new(v12), AdminSpawn.SmokeScale)
    local v14 = v13.X * 0.55
    local v15 = v13.Z * 0.55
    local FlameRingCount = AdminSpawn.FlameRingCount
    for v16 = 1, FlameRingCount do
        local v17 = v16 / AdminSpawn.FlameRingCount * 3.141592653589793 * 2
        local v18 = math.cos(v17) * v14
        local v19 = math.sin(v17) * v15
        local v20 = v12 + Vector3.new(v18, 0, v19)
        task.delay(v16 * 0.02, VFXBurst.Play, AdminSpawn.LandBlastName, CFrame.new(v20), AdminSpawn.FlameRingScale)
    end
    local Chunks = EggLandImpact.Chunks
    local X = v13.X
    local Z = v13.Z
    Chunks(v12, math.max(X, Z) * 0.25, v13.Y)
    SpatialSfx.Play(RranBossConfig.Sfx.Folder, AdminSpawn.SlamSound, {
        At = v12,
        Range = AdminSpawn.SlamRange,
        MinRange = AdminSpawn.SlamRange * 0.15,
        RollOffMode = Enum.RollOffMode.Linear
    })
    shake(v12)
end

local function drop(v21) -- line 125 | captures: RunService, Workspace, AdminTreadmillCutscene, AdminSpawn, fallSound, slam
    local v22 = v21:GetAttribute(AdminSpawn.LandAtAttribute)
    if type(v22) ~= "number" or v22 <= Workspace:GetServerTimeNow() then
        return
    end
    local v23 = v22 - AdminSpawn.DropTime
    local v24 = {}
    local v25 = {}
    local v26 = {}

    local function addPart(v27) -- line 136 | captures: v24, v25, v26
        if not v27:IsA("BasePart") or v26[v27] then
            return
        end
        v26[v27] = true
        table.insert(v24, v27)
        local CFrame = v27.CFrame
        table.insert(v25, CFrame)
    end

    for v28, v29 in v21:GetDescendants() do
        if v29:IsA("BasePart") and not v26[v29] then
            v26[v29] = true
            table.insert(v24, v29)
            local CFrame = v29.CFrame
            table.insert(v25, CFrame)
        end
    end
    local v30 = v21.DescendantAdded:Connect(addPart)
    local v31, v32 = v21:GetBoundingBox()
    local Position = v31.Position
    local v33 = v32.Y / 2
    local v34 = Position - Vector3.new(0, v33, 0)
    local v35 = AdminTreadmillCutscene.Facing(v21)
    local v36 = {}

    local function lift(v37) -- line 152 | captures: v24, v25, v36, Workspace
        local v38 = Vector3.new(0, v37, 0)
        for v39, v40 in v25 do
            v36[v39] = v40 + v38
        end
        Workspace:BulkMoveTo(v24, v36, Enum.BulkMoveMode.FireCFrameChanged)
    end

    local DropHeight = AdminSpawn.DropHeight
    local v41 = Vector3.new(0, DropHeight, 0)
    for v42, v43 in v25 do
        v36[v42] = v43 + v41
    end
    Workspace:BulkMoveTo(v24, v36, Enum.BulkMoveMode.FireCFrameChanged)
    local v44
    if v24[1] then
        v44 = fallSound(v24[1], v22)
    else
        function v44() -- line 160
        end
    end
    task.spawn(AdminTreadmillCutscene.Play, {
        Model = v21,
        Ground = v34,
        Size = v32,
        Facing = v35,
        FallStart = v23
    })
    local v45
    local RenderStepped = RunService.RenderStepped
    local v46 = v44
    v45 = RenderStepped:Connect(function() -- line 172 | captures: v45, v21, v23, v24, v25, v30, v32, v34, v36, v46, Workspace, AdminSpawn, slam
        if v21.Parent then
            local v47 = (Workspace:GetServerTimeNow() - v23) / AdminSpawn.DropTime
            local v48 = math.clamp(v47, 0, 1)
            local v49 = AdminSpawn.DropHeight * (1 - v48 * v48)
            local v50 = Vector3.new(0, v49, 0)
            for v51, v52 in v25 do
                v36[v51] = v52 + v50
            end
            Workspace:BulkMoveTo(v24, v36, Enum.BulkMoveMode.FireCFrameChanged)
            if v48 >= 1 then
                v45:Disconnect()
                v30:Disconnect()
                for v53, v54 in v25 do
                    v36[v53] = v54 + Vector3.new(0, 0, 0)
                end
                Workspace:BulkMoveTo(v24, v36, Enum.BulkMoveMode.FireCFrameChanged)
                v46()
                slam(v34, v32)
            end
        else
            v45:Disconnect()
            v30:Disconnect()
            v46()
        end
    end)
end

local function watch(v55) -- line 192 | captures: AdminSpawn, drop
    if v55:IsA("Model") and v55.Name == AdminSpawn.Model then
        drop(v55)
    end
end

function v1.Start() -- line 198 | captures: Workspace, watch
    for v56, v57 in Workspace:GetChildren() do
        task.spawn(watch, v57)
    end
    Workspace.ChildAdded:Connect(watch)
end

return v1
