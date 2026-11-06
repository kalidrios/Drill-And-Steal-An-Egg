-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ChaseState = require(ReplicatedStorage.Shared.ChaseState)
local PublicTreadmillConfig = require(ReplicatedStorage.Shared.PublicTreadmillConfig)
local CinematicMode = require(script.Parent.CinematicMode)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local AdminSpawn = PublicTreadmillConfig.AdminSpawn
local Cutscene = AdminSpawn.Cutscene
local v2 = false

local function now() -- line 53 | captures: Workspace
    return Workspace:GetServerTimeNow()
end

local function smooth(v3) -- line 57
    local v4 = math.clamp(v3, 0, 1)
    return v4 * v4 * (3 - v4 * 2)
end

local function flat(v5, v6) -- line 62
    local X = v5.X
    local Z = v5.Z
    local v7 = Vector3.new(X, 0, Z)
    if v7.Magnitude > 0.001 then
        return v7.Unit
    end
    return v6
end

function v1.IsPlaying() -- line 67 | captures: v2
    return v2
end

function v1.Facing(v8) -- line 74 | captures: PublicTreadmillConfig
    local LookVector = v8:GetPivot().LookVector
    local X = LookVector.X
    local Z = LookVector.Z
    local v9 = Vector3.new(X, 0, Z)
    local v10
    if v9.Magnitude > 0.001 then
        v10 = v9.Unit
    else
        v10 = Vector3.new(0, 0, -1)
    end
    for v11, v12 in PublicTreadmillConfig.Treadmills do
        if v12.Model == v8.Name then
            local v13 = v8:FindFirstChild(v12.Belt, true)
            if v13 and v13:IsA("BasePart") then
                local v14 = v13.CFrame:VectorToWorldSpace(v12.Facing)
                local X = v14.X
                local Z = v14.Z
                local v15 = Vector3.new(X, 0, Z)
                if v15.Magnitude > 0.001 then
                    return v15.Unit
                end
                return v10
            end
        end
    end
    return v10
end

function v1.Play(v16) -- line 88 | captures: v2, Players, RunService, Workspace, ChaseState, CinematicMode, LocalPlayer, AdminSpawn, Cutscene
    local CurrentCamera, v17, v18
    if Cutscene.Enabled then
        if v2 or CinematicMode.IsActive() then
            v18 = true
        else
            CurrentCamera = Workspace.CurrentCamera
            local Character = LocalPlayer.Character
            v17 = Character and Character:FindFirstChild("HumanoidRootPart")
            v18 = false
        end
    else
        v18 = true
    end
    if v18 then
        return
    end
    if not (CurrentCamera and v17 and v17:IsA("BasePart")) then
        return
    end
    if Cutscene.SkipWhileCarrying and (ChaseState.IsCarrying(LocalPlayer) or LocalPlayer:GetAttribute("BeingChased")) then
        return
    end
    local FallStart = v16.FallStart
    local v19 = Workspace:GetServerTimeNow() - FallStart
    if Cutscene.LateJoinGrace < v19 then
        return
    end
    local DropTime = AdminSpawn.DropTime
    local Hold = Cutscene.Hold
    local Return = Cutscene.Return
    local Size = v16.Size
    local Ground = v16.Ground
    local Facing = v16.Facing
    local v20 = Facing:Cross((Vector3.new(0, 1, 0)))
    local X = Size.X
    local Z = Size.Z
    local v21 = math.max(X, Z) * Cutscene.Zoom
    local v22 = Ground + Vector3.new(0, 1, 0) * (Size.Y * Cutscene.LookHeight)

    local function spot(v23) -- line 115 | captures: Ground, Facing, v20, v21
        return Ground + v20 * ((v23.Right or 0) * v21) + Facing * (((v23.Front or 0) - (v23.Back or 0)) * v21) + Vector3.new(0, 1, 0) * ((v23.Up or 0) * v21)
    end

    local ApproachFrom = Cutscene.Shots.ApproachFrom
    local v24 = Ground + v20 * ((ApproachFrom.Right or 0) * v21) + Facing * (((ApproachFrom.Front or 0) - (ApproachFrom.Back or 0)) * v21) + Vector3.new(0, 1, 0) * ((ApproachFrom.Up or 0) * v21)
    local ApproachTo = Cutscene.Shots.ApproachTo
    local v25 = Ground + v20 * ((ApproachTo.Right or 0) * v21) + Facing * (((ApproachTo.Front or 0) - (ApproachTo.Back or 0)) * v21) + Vector3.new(0, 1, 0) * ((ApproachTo.Up or 0) * v21)

    local function fallingCenter(v26) -- line 126 | captures: DropTime, v22, AdminSpawn
        local v27 = v26 / DropTime
        local v28 = math.clamp(v27, 0, 1)
        return v22 + Vector3.new(0, 1, 0) * (AdminSpawn.DropHeight * (1 - v28 * v28))
    end

    local v29 = RaycastParams.new()
    v29.FilterType = Enum.RaycastFilterType.Exclude
    v29.RespectCanCollide = true

    local function clear(v30, v31) -- line 136 | captures: v16, v29, Players, Workspace, Cutscene
        local v32 = { v16.Model }
        for v33, v34 in Players:GetPlayers() do
            if v34.Character then
                local Character = v34.Character
                table.insert(v32, Character)
            end
        end
        v29.FilterDescendantsInstances = v32
        local v35 = v30 - v31
        local v36 = Workspace:Raycast(v31, v35, v29)
        if v36 then
            return v36.Position - v35.Unit * Cutscene.WallPadding
        end
        return v30
    end

    local function focusOf(v37) -- line 155
        local v38 = v37.Parent and v37.Parent:FindFirstChildOfClass("Humanoid")
        local v39
        if v38 then
            v39 = v38.CameraOffset
        else
            v39 = Vector3.new(0, 0, 0)
        end
        return v37.Position + Vector3.new(0, 1.5, 0) + v39
    end

    local Position = CurrentCamera.CFrame.Position
    local v40 = v17.Parent and v17.Parent:FindFirstChildOfClass("Humanoid")
    local v41
    if v40 then
        v41 = v40.CameraOffset
    else
        v41 = Vector3.new(0, 0, 0)
    end
    local v42 = Position - (v17.Position + Vector3.new(0, 1.5, 0) + v41)

    local function home(v43) -- line 161 | captures: v42
        local v44 = v43.Parent and v43.Parent:FindFirstChildOfClass("Humanoid")
        local v45
        if v44 then
            v45 = v44.CameraOffset
        else
            v45 = Vector3.new(0, 0, 0)
        end
        local v46 = v43.Position + Vector3.new(0, 1.5, 0) + v45
        return CFrame.lookAt(v46 + v42, v46)
    end

    if CinematicMode.Enter(Cutscene) then
        v2 = true
        local CameraType = CurrentCamera.CameraType
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        local v47 = CurrentCamera.CFrame
        local v48 = DropTime + Hold + Return
        local v49 = false
        local CurrentCamera_2 = CurrentCamera

        local function finish() -- line 176 | captures: v49, v42, CameraType, CurrentCamera_2, v2, RunService, CinematicMode, LocalPlayer
            if v49 then
                return
            end
            v49 = true
            RunService:UnbindFromRenderStep("AdminTreadmillCutscene")
            local v50 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v50 and v50:IsA("BasePart") then
                local v51 = v50.Parent and v50.Parent:FindFirstChildOfClass("Humanoid")
                local v52
                if v51 then
                    v52 = v51.CameraOffset
                else
                    v52 = Vector3.new(0, 0, 0)
                end
                local v53 = v50.Position + Vector3.new(0, 1.5, 0) + v52
                CurrentCamera_2.CFrame = CFrame.lookAt(v53 + v42, v53)
            end
            local v54 = if CameraType == Enum.CameraType.Scriptable then Enum.CameraType.Custom else CameraType
            CurrentCamera_2.CameraType = v54
            v2 = false
            CinematicMode.Exit()
        end

        local v55 = CurrentCamera.CFrame.Position
        local v56 = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * v21
        local Value = Enum.RenderPriority.Camera.Value
        RunService:BindToRenderStep("AdminTreadmillCutscene", Value, function(v57) -- line 198 | captures: v47, v55, v56, v16, FallStart, DropTime, Hold, Return, v22, v24, v25, clear, v42, v48, finish, CurrentCamera_2, Workspace, LocalPlayer, AdminSpawn, Cutscene
            local v58 = Workspace:GetServerTimeNow() - FallStart
            local v59 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if v16.Model.Parent and v59 and v59:IsA("BasePart") then
                local v60, v61
                if v58 < DropTime then
                    local v62 = v58 / DropTime
                    local v63 = math.clamp(v62, 0, 1)
                    v60 = v24:Lerp(v25, v63 * v63 * (3 - v63 * 2))
                    local v64 = v58 / DropTime
                    local v65 = math.clamp(v64, 0, 1)
                    v61 = v22 + Vector3.new(0, 1, 0) * (AdminSpawn.DropHeight * (1 - v65 * v65))
                elseif v58 < DropTime + Hold then
                    v60 = v25
                    v61 = v22
                else
                    if v58 < v48 then
                        local v66 = (v58 - DropTime - Hold) / Return
                        local v67 = math.clamp(v66, 0, 1)
                        local v68 = v67 * v67 * (3 - v67 * 2)
                        local v69 = v47
                        local v70 = v59.Parent and v59.Parent:FindFirstChildOfClass("Humanoid")
                        local v71
                        if v70 then
                            v71 = v70.CameraOffset
                        else
                            v71 = Vector3.new(0, 0, 0)
                        end
                        local v72 = v59.Position + Vector3.new(0, 1.5, 0) + v71
                        CurrentCamera_2.CFrame = v69:Lerp(CFrame.lookAt(v72 + v42, v72), v68)
                    else
                        finish()
                    end
                    return
                end
                local v73 = clear(v60, v22)
                local v74 = -Cutscene.Smoothing * v57
                local v75 = 1 - math.exp(v74)
                v55 = v55:Lerp(v73, v75)
                v56 = v56:Lerp(v61, v75)
                local v76 = CFrame.lookAt(v55, v56)
                v47 = v76
                CurrentCamera_2.CFrame = v76
            else
                finish()
            end
        end)
        local delay = task.delay
        local v77 = v48 - (Workspace:GetServerTimeNow() - FallStart)
        delay(math.max(v77, 0) + Cutscene.SafetyGrace, finish)
    end
end

return v1
