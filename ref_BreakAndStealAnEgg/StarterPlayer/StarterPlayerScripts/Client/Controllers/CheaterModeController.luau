-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CheaterModeConfig = require(ReplicatedStorage.Shared.CheaterModeConfig)
local NotificationController = require(script.Parent.NotificationController)
local LocalPlayer = Players.LocalPlayer
local v1 = {}
local v2 = false
local v3 = false
local v4 = false
local WalkSpeed, v5
local v6 = {}
local v7 = {}
local v8 = {}
local v9

local function getCharacter() -- line 60 | captures: LocalPlayer
    local Character = LocalPlayer.Character
    local v10, v11
    if Character then
        v10 = Character:FindFirstChild("HumanoidRootPart")
        v11 = Character:FindFirstChildOfClass("Humanoid")
    else
        v10 = Character
        v11 = Character
    end
    if v10 and v10:IsA("BasePart") and v11 and not (v11.Health <= 0) then
        return Character, v10, v11
    end
    return nil, nil, nil
end

local function disconnectAll(v12) -- line 70
    for v13, v14 in v12 do
        v14:Disconnect()
    end
    table.clear(v12)
end

local function applyWalkSpeed(v15) -- line 81 | captures: v4, WalkSpeed, v5, CheaterModeConfig
    local v16 = WalkSpeed or v15.WalkSpeed
    if v4 then
        v16 *= CheaterModeConfig.SpeedMultiplier
    end
    if v4 then
        v5 = v16
    else
        v5 = nil
    end
    if v15.WalkSpeed ~= v16 then
        v15.WalkSpeed = v16
    end
end

local function setSpeeding(v17, v18) -- line 90 | captures: v4, WalkSpeed, v5, CheaterModeConfig, NotificationController, LocalPlayer
    if v4 == v17 then
        return
    end
    v4 = v17
    local Character = LocalPlayer.Character
    local v19
    if Character then
        v19 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    else
        v19 = Character
    end
    if not v19 or not v19:IsA("BasePart") or not Character or Character.Health <= 0 then
        Character = nil
    end
    if Character then
        local v20 = WalkSpeed or Character.WalkSpeed
        if v4 then
            v20 *= CheaterModeConfig.SpeedMultiplier
        end
        if v4 then
            v5 = v20
        else
            v5 = nil
        end
        if Character.WalkSpeed ~= v20 then
            Character.WalkSpeed = v20
        end
    end
    if not v18 then
        if v17 then
            NotificationController.ShowPreset("CheatSpeedOn", CheaterModeConfig.SpeedMultiplier)
        else
            NotificationController.ShowPreset("CheatSpeedOff")
        end
    end
end

local function flySpeed() -- line 112 | captures: v4, WalkSpeed, CheaterModeConfig
    local v21 = WalkSpeed or 16
    local FlyMinSpeed = CheaterModeConfig.FlyMinSpeed
    local v22 = math.max(v21, FlyMinSpeed)
    if v4 then
        return v22 * CheaterModeConfig.SpeedMultiplier
    end
    return v22
end

local function flyDirection(v23) -- line 118 | captures: UserInputService, CheaterModeConfig
    if not UserInputService:GetFocusedTextBox() then
        local LookVector = v23.CFrame.LookVector
        local RightVector = v23.CFrame.RightVector
        local v24 = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            v24 += LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            v24 -= LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            v24 += RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            v24 -= RightVector
        end
        if UserInputService:IsKeyDown(CheaterModeConfig.FlyUpKey) then
            v24 += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(CheaterModeConfig.FlyDownKey) then
            v24 -= Vector3.new(0, 1, 0)
        end
        if v24.Magnitude > 0 then
            return v24.Unit
        end
    end
    return (Vector3.new(0, 0, 0))
end

local function stopFly(v25) -- line 146 | captures: v3, v8, v9, NotificationController, LocalPlayer
    if not v3 then
        return
    end
    v3 = false
    if v9 then
        v9:Disconnect()
        v9 = nil
    end
    for v26, v27 in v8 do
        v27:Destroy()
    end
    table.clear(v8)
    local Character = LocalPlayer.Character
    local v28
    if Character then
        v28 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    else
        v28 = Character
    end
    if not v28 or not v28:IsA("BasePart") or not Character or Character.Health <= 0 then
        Character = nil
    end
    if Character then
        Character.PlatformStand = false
    end
    if not v25 then
        NotificationController.ShowPreset("CheatFlyOff")
    end
end

local function startFly() -- line 168 | captures: v3, v4, WalkSpeed, v8, v9, RunService, Workspace, CheaterModeConfig, NotificationController, LocalPlayer, flyDirection
    local Character = LocalPlayer.Character
    local v29
    if Character then
        v29 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    else
        v29 = Character
    end
    if not v29 or not v29:IsA("BasePart") or not Character or Character.Health <= 0 then
        v29 = nil
        Character = nil
    end
    if v3 or not v29 or not Character then
        return
    end
    v3 = true
    local Attachment = Instance.new("Attachment")
    Attachment.Name = "CheatFlyAttachment"
    Attachment.Parent = v29
    local LinearVelocity = Instance.new("LinearVelocity")
    LinearVelocity.Name = "CheatFlyVelocity"
    LinearVelocity.Attachment0 = Attachment
    LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    LinearVelocity.MaxForce = 1000000000
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    LinearVelocity.Parent = v29
    local AlignOrientation = Instance.new("AlignOrientation")
    AlignOrientation.Name = "CheatFlyOrientation"
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation.Attachment0 = Attachment
    AlignOrientation.RigidityEnabled = true
    AlignOrientation.CFrame = v29.CFrame.Rotation
    AlignOrientation.Parent = v29
    v8 = { Attachment, LinearVelocity, AlignOrientation }
    Character.PlatformStand = true
    local RenderStepped = RunService.RenderStepped
    local v30 = v29
    v9 = RenderStepped:Connect(function() -- line 199 | captures: LinearVelocity, AlignOrientation, v30, v4, WalkSpeed, Workspace, CheaterModeConfig, flyDirection
        local CurrentCamera = Workspace.CurrentCamera
        local LinearVelocity_2, v31, v32, v33
        if CurrentCamera then
            if v30.Parent == nil then
                v33 = true
            else
                LinearVelocity_2 = LinearVelocity
                v31 = flyDirection(CurrentCamera)
                local v34 = WalkSpeed or 16
                local FlyMinSpeed = CheaterModeConfig.FlyMinSpeed
                v32 = math.max(v34, FlyMinSpeed)
                if v4 then
                    v32 *= CheaterModeConfig.SpeedMultiplier
                end
                v33 = false
            end
        else
            v33 = true
        end
        if v33 then
            return
        end
        LinearVelocity_2.VectorVelocity = v31 * v32
        local LookVector = CurrentCamera.CFrame.LookVector
        local X = LookVector.X
        local Z = LookVector.Z
        local v35 = Vector3.new(X, 0, Z)
        if v35.Magnitude > 0.001 then
            AlignOrientation.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v35)
        end
    end)
    NotificationController.ShowPreset("CheatFlyOn")
end

local function teleportToScreenPoint(v36) -- line 219 | captures: Workspace, CheaterModeConfig, LocalPlayer
    local Character = LocalPlayer.Character
    local v37, v38
    if Character then
        v37 = Character:FindFirstChild("HumanoidRootPart")
        v38 = Character:FindFirstChildOfClass("Humanoid")
    else
        v37 = Character
        v38 = Character
    end
    if not v37 or not v37:IsA("BasePart") or not v38 or v38.Health <= 0 then
        Character = nil
        v37 = nil
        v38 = nil
    end
    local CurrentCamera = Workspace.CurrentCamera
    if not (Character and v37 and v38 and CurrentCamera) then
        return
    end
    local v39 = CurrentCamera:ViewportPointToRay(v36.X, v36.Y)
    local v40 = RaycastParams.new()
    v40.FilterType = Enum.RaycastFilterType.Exclude
    v40.FilterDescendantsInstances = { Character }
    local v41 = Workspace:Raycast(v39.Origin, v39.Direction * CheaterModeConfig.TeleportRange, v40)
    if not v41 then
        return
    end
    local Position = v41.Position
    local v42 = v38.HipHeight + v37.Size.Y * 0.5
    local v43 = Position + Vector3.new(0, v42, 0)
    local v44 = v43 - v37.Position
    local X = v44.X
    local Z = v44.Z
    local v45 = Vector3.new(X, 0, Z)
    if v45.Magnitude > 0.001 then
        v37.CFrame = CFrame.lookAt(v43, v43 + v45)
    else
        v37.CFrame = CFrame.new(v43) * v37.CFrame.Rotation
    end
    v37.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end

local function hookCharacter(v46) -- line 248 | captures: v2, v4, WalkSpeed, v5, CheaterModeConfig, LocalPlayer, v7, stopFly
    local function v47(v48, ...)
        table.insert(v48, ...)
    end

    local function v49(v50, ...)
        table.insert(v50, ...)
    end

    for v51, v52 in v7 do
        v52:Disconnect()
    end
    table.clear(v7)
    stopFly(true)
    v5 = nil
    local v53 = v46:WaitForChild("Humanoid", 10)
    if not (v53 and v53:IsA("Humanoid") and LocalPlayer.Character == v46 and v2) then
        return
    end
    WalkSpeed = v53.WalkSpeed
    local WalkSpeed_2 = v53:GetPropertyChangedSignal("WalkSpeed")
    v47(v7, WalkSpeed_2:Connect(function() -- line 262 | captures: v53, v4, WalkSpeed, v5, CheaterModeConfig
        local WalkSpeed_2 = v53.WalkSpeed
        local v54 = v5
        local v55
        if v54 then
            local v56 = WalkSpeed_2 - v5
            v55 = math.abs(v56) < 0.0001
        end
        if not v54 or not v55 then
            WalkSpeed = WalkSpeed_2
            if v4 then
                local v57 = WalkSpeed or v53.WalkSpeed
                if v4 then
                    v57 *= CheaterModeConfig.SpeedMultiplier
                end
                if v4 then
                    v5 = v57
                else
                    v5 = nil
                end
                if v53.WalkSpeed ~= v57 then
                    v53.WalkSpeed = v57
                end
            end
        end
    end))
    v49(v7, v53.Died:Connect(function() -- line 276 | captures: stopFly
        stopFly(true)
    end))
    if not v4 then
        return
    end
    local v58 = WalkSpeed or v53.WalkSpeed
    if v4 then
        v58 *= CheaterModeConfig.SpeedMultiplier
    end
    if v4 then
        v5 = v58
    else
        v5 = nil
    end
    if v53.WalkSpeed ~= v58 then
        v53.WalkSpeed = v58
    end
end

local function onInput(v59, v60) -- line 285 | captures: v2, v3, v4, WalkSpeed, v5, UserInputService, CheaterModeConfig, NotificationController, LocalPlayer, stopFly, startFly, teleportToScreenPoint
    if not v60 and v2 then
        if v59.UserInputType == Enum.UserInputType.MouseButton1 then
            teleportToScreenPoint(UserInputService:GetMouseLocation())
        elseif v59.KeyCode == CheaterModeConfig.FlyKey then
            if v3 then
                stopFly()
            else
                startFly()
            end
        elseif v59.KeyCode == CheaterModeConfig.SpeedKey then
            local v61 = not v4
            if v4 == v61 then
                return
            end
            v4 = v61
            local Character = LocalPlayer.Character
            local v62 = Character and Character:FindFirstChild("HumanoidRootPart")
            local v63 = Character and Character:FindFirstChildOfClass("Humanoid")
            if not v62 or not v62:IsA("BasePart") or not v63 or v63.Health <= 0 then
                v63 = nil
            end
            if v63 then
                local v64 = WalkSpeed or v63.WalkSpeed
                if v4 then
                    v64 *= CheaterModeConfig.SpeedMultiplier
                end
                if v4 then
                    v5 = v64
                else
                    v5 = nil
                end
                if v63.WalkSpeed ~= v64 then
                    v63.WalkSpeed = v64
                end
            end
            if v61 then
                NotificationController.ShowPreset("CheatSpeedOn", CheaterModeConfig.SpeedMultiplier)
            else
                NotificationController.ShowPreset("CheatSpeedOff")
            end
        end
    end
end

local function arm() -- line 302 | captures: v2, UserInputService, LocalPlayer, v6, hookCharacter, onInput
    local function v65(v66, ...)
        table.insert(v66, ...)
    end

    local function v67(v68, ...)
        table.insert(v68, ...)
    end

    if v2 then
        return
    end
    v2 = true
    v65(v6, UserInputService.InputBegan:Connect(onInput))
    v67(v6, LocalPlayer.CharacterAdded:Connect(function(v69) -- line 310 | captures: hookCharacter
        hookCharacter(v69)
    end))
    if LocalPlayer.Character then
        task.spawn(hookCharacter, LocalPlayer.Character)
    end
end

local function disarm() -- line 319 | captures: v2, v4, WalkSpeed, v5, CheaterModeConfig, LocalPlayer, v6, v7, stopFly
    if not v2 then
        return
    end
    v2 = false
    stopFly(true)
    if v4 ~= false then
        v4 = false
        local Character = LocalPlayer.Character
        local v70 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v71 = Character and Character:FindFirstChildOfClass("Humanoid")
        if not v70 or not v70:IsA("BasePart") or not v71 or v71.Health <= 0 then
            v71 = nil
        end
        if v71 then
            local v72 = WalkSpeed or v71.WalkSpeed
            if v4 then
                v72 *= CheaterModeConfig.SpeedMultiplier
            end
            if v4 then
                v5 = v72
            else
                v5 = nil
            end
            if v71.WalkSpeed ~= v72 then
                v71.WalkSpeed = v72
            end
        end
    end
    for v73, v74 in v6 do
        v74:Disconnect()
    end
    table.clear(v6)
    for v75, v76 in v7 do
        v76:Disconnect()
    end
    table.clear(v7)
    v5 = nil
    WalkSpeed = nil
end

function v1.Start() -- line 332 | captures: v2, v4, WalkSpeed, v5, CheaterModeConfig, LocalPlayer, v6, v7, stopFly, arm
    local function refresh() -- line 333 | captures: v2, v4, WalkSpeed, v5, CheaterModeConfig, LocalPlayer, v6, v7, stopFly, arm
        if LocalPlayer:GetAttribute(CheaterModeConfig.Attribute) == true then
            arm()
        elseif v2 then
            v2 = false
            stopFly(true)
            if v4 ~= false then
                v4 = false
                local Character = LocalPlayer.Character
                local v77 = Character and Character:FindFirstChild("HumanoidRootPart")
                local v78 = Character and Character:FindFirstChildOfClass("Humanoid")
                if not v77 or not v77:IsA("BasePart") or not v78 or v78.Health <= 0 then
                    v78 = nil
                end
                if v78 then
                    local v79 = WalkSpeed or v78.WalkSpeed
                    if v4 then
                        v79 *= CheaterModeConfig.SpeedMultiplier
                    end
                    if v4 then
                        v5 = v79
                    else
                        v5 = nil
                    end
                    if v78.WalkSpeed ~= v79 then
                        v78.WalkSpeed = v79
                    end
                end
            end
            for v80, v81 in v6 do
                v81:Disconnect()
            end
            table.clear(v6)
            for v82, v83 in v7 do
                v83:Disconnect()
            end
            table.clear(v7)
            v5 = nil
            WalkSpeed = nil
        end
    end

    LocalPlayer:GetAttributeChangedSignal(CheaterModeConfig.Attribute):Connect(refresh)
    if LocalPlayer:GetAttribute(CheaterModeConfig.Attribute) == true then
        arm()
    elseif v2 then
        v2 = false
        stopFly(true)
        if v4 ~= false then
            v4 = false
            local Character = LocalPlayer.Character
            local v84 = Character and Character:FindFirstChild("HumanoidRootPart")
            local v85 = Character and Character:FindFirstChildOfClass("Humanoid")
            if not v84 or not v84:IsA("BasePart") or not v85 or v85.Health <= 0 then
                v85 = nil
            end
            if v85 then
                local v86 = WalkSpeed or v85.WalkSpeed
                if v4 then
                    v86 *= CheaterModeConfig.SpeedMultiplier
                end
                if v4 then
                    v5 = v86
                else
                    v5 = nil
                end
                if v85.WalkSpeed ~= v86 then
                    v85.WalkSpeed = v86
                end
            end
        end
        for v87, v88 in v6 do
            v88:Disconnect()
        end
        table.clear(v6)
        for v89, v90 in v7 do
            v90:Disconnect()
        end
        table.clear(v7)
        v5 = nil
        WalkSpeed = nil
    end
end

return v1
