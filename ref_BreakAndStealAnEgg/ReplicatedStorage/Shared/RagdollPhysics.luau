-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local v1 = {
    PhysicsRate = 240,
    ThinnestFloorStuds = 1,
    SpeedSafetyFactor = 0.8,
    MinGravityScale = 0.85
}

local function worldHalfHeight(v2) -- line 126
    local CFrame = v2.CFrame
    local Size = v2.Size
    local Y = CFrame.XVector.Y
    local v3 = math.abs(Y) * Size.X
    local Y_2 = CFrame.YVector.Y
    local v4 = v3 + math.abs(Y_2) * Size.Y
    local Y_3 = CFrame.ZVector.Y
    return 0.5 * (v4 + math.abs(Y_3) * Size.Z)
end

local function SetCharacterNetworkOwner(v5, v6) -- line 161
    local v7 = {}
    local v8 = false
    for v9, v10 in ipairs(v5:GetDescendants()) do
        if v10:IsA("BasePart") and not v10.Anchored then
            local v11 = v10.AssemblyRootPart or v10
            if not v7[v11] then
                v7[v11] = true
                local v12 = pcall(function() -- line 171 | captures: v6, v11
                    v11:SetNetworkOwner(v6)
                end)
                v8 = v8 or v12
            end
        end
    end
    return v8
end

v1.SetCharacterNetworkOwner = SetCharacterNetworkOwner

local function StopCharacterDescent(v13) -- line 187
    local v14 = {}
    for v15, v16 in ipairs(v13:GetDescendants()) do
        if v16:IsA("BasePart") and not v16.Anchored then
            local v17 = v16.AssemblyRootPart or v16
            if not v14[v17] then
                v14[v17] = true
                local AssemblyLinearVelocity = v17.AssemblyLinearVelocity
                if AssemblyLinearVelocity.Y < 0 then
                    local X = AssemblyLinearVelocity.X
                    local Z = AssemblyLinearVelocity.Z
                    v17.AssemblyLinearVelocity = Vector3.new(X, 0, Z)
                end
            end
        end
    end
end

v1.StopCharacterDescent = StopCharacterDescent

local v18 = 0

function v1.ActiveGuardCount() -- line 217 | captures: v18
    return v18
end

function v1.IsSimulatingFling() -- line 225 | captures: v18
    return v18 > 0
end

function v1.MaxSafeSpeed() -- line 233 | captures: v1
    return v1.ThinnestFloorStuds * v1.PhysicsRate * v1.SpeedSafetyFactor
end

function v1.ShapeLaunch(v19, v20, v21, v22, v23) -- line 267 | captures: v1
    local v24 = v21 or 45
    local v25 = math.rad(v24)
    local v26 = math.clamp(v25, 0.08726646259971647, 1.4835298641951802)
    local v27 = v26 * 2
    local v28 = math.sin(v27)
    local v29 = v22 or 1
    local v30 = math.max(v29, 0.1)
    local v31 = math.max(v19, 0) * v20 / v28
    local v32 = math.sqrt(v31) * v30
    local v33 = v30 * v30
    local v34 = v1.MaxSafeSpeed()
    if v34 < v32 then
        local v35 = v34 * v34 * v28
        local v36 = v19 * v20
        v33 = v35 / math.max(v36, 0.000001)
    else
        v34 = v32
    end
    local v37 = v23 or v1.MinGravityScale
    local v38 = math.clamp(v37, 0.15, 4)
    local v39 = math.clamp(v33, v38, 4)
    return v34 * math.cos(v26), v34 * math.sin(v26), v39
end

local function FlightTime(v40, v41, v42) -- line 301
    local v43 = v40 * 2
    local v44 = v41 * v42
    return v43 / math.max(v44, 0.000001)
end

v1.FlightTime = FlightTime

local function ShiftCharacter(v45, v46) -- line 313
    local v47 = {}
    for v48, v49 in ipairs(v45:GetDescendants()) do
        if v49:IsA("BasePart") and not v49.Anchored then
            local v50 = v49.AssemblyRootPart or v49
            if not v47[v50] then
                v47[v50] = true
                v50.CFrame += v46
            end
        end
    end
end

v1.ShiftCharacter = ShiftCharacter

local function SetCharacterVelocity(v51, v52, v53) -- line 326
    for v54, v55 in ipairs(v51:GetDescendants()) do
        if v55:IsA("BasePart") and not v55.Anchored then
            v55.AssemblyLinearVelocity = v52
            if v53 ~= nil then
                v55.AssemblyAngularVelocity = v53
            end
        end
    end
end

v1.SetCharacterVelocity = SetCharacterVelocity

local v56 = RaycastParams.new()

v56.FilterType = Enum.RaycastFilterType.Exclude
v56.RespectCanCollide = true

local v57 = {}

function v1.FindGroundY(v58, v59) -- line 350 | captures: v56, v57
    v57[1] = v58
    v56.FilterDescendantsInstances = v57
    local X = v59.X
    local Y = v59.Y
    local v60 = math.max(Y, 0) + 500
    local Z = v59.Z
    local v61 = Vector3.new(X, v60, Z)
    local v62 = workspace:Raycast(v61, Vector3.new(0, -4000, 0), v56)
    v57[1] = nil
    v56.FilterDescendantsInstances = v57
    return v62 and v62.Position.Y or nil
end

function v1.SnapUpright(v63) -- line 378 | captures: v1
    local Humanoid = v63:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = v63:FindFirstChild("HumanoidRootPart")
    local UpperTorso, v64
    if Humanoid == nil or HumanoidRootPart == nil then
        v64 = true
    elseif HumanoidRootPart:IsA("BasePart") then
        UpperTorso = v63:FindFirstChild("UpperTorso")
        if UpperTorso == nil or not UpperTorso:IsA("BasePart") then
            UpperTorso = HumanoidRootPart
        end
        v64 = false
    else
        v64 = true
    end
    if v64 then
        return
    end
    local LookVector = HumanoidRootPart.CFrame.LookVector
    local X = LookVector.X
    local Z = LookVector.Z
    local v65 = Vector3.new(X, 0, Z)
    local v66
    if v65.Magnitude > 0.01 then
        v66 = v65.Unit
    else
        v66 = Vector3.new(0, 0, 1)
    end
    local v67 = RaycastParams.new()
    v67.FilterType = Enum.RaycastFilterType.Exclude
    v67.FilterDescendantsInstances = { v63 }
    v67.RespectCanCollide = true
    local v68 = workspace:Raycast(UpperTorso.Position + Vector3.new(0, 2, 0), Vector3.new(0, -14, 0), v67)
    local Y = v68 and v68.Position.Y or nil
    if Y == nil then
        Y = v1.FindGroundY(v63, UpperTorso.Position)
    end
    local v69 = if Y == nil then UpperTorso.Position.Y + 2 else Y + Humanoid.HipHeight + HumanoidRootPart.Size.Y * 0.5
    local X_2 = UpperTorso.Position.X
    local Z_2 = UpperTorso.Position.Z
    local v70 = Vector3.new(X_2, v69, Z_2)
    HumanoidRootPart.CFrame = CFrame.lookAt(v70, v70 + v66)
end

local function ApplyLowGravity(v71, v72) -- line 431
    local v73 = v72 - 1
    if math.abs(v73) < 0.001 then
        return
    end
    local Gravity = workspace.Gravity
    local v74 = 1 - v72
    for v75, v76 in ipairs(v71:GetDescendants()) do
        if v76:IsA("BasePart") and not v76.Anchored and not v76.Massless then
            local Attachment = Instance.new("Attachment")
            Attachment.Name = "RagdollLiftAttachment"
            Attachment.Parent = v76
            local VectorForce = Instance.new("VectorForce")
            VectorForce.Name = "RagdollLiftForce"
            VectorForce.Attachment0 = Attachment
            VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
            VectorForce.ApplyAtCenterOfMass = true
            local v77 = v76:GetMass() * Gravity * v74
            VectorForce.Force = Vector3.new(0, v77, 0)
            VectorForce.Parent = v76
        end
    end
end

v1.ApplyLowGravity = ApplyLowGravity

local function RemoveLowGravity(v78) -- line 459
    for v79, v80 in ipairs(v78:GetDescendants()) do
        if v80.Name == "RagdollLiftForce" and v80:IsA("VectorForce") or v80.Name == "RagdollLiftAttachment" and v80:IsA("Attachment") then
            v80:Destroy()
        end
    end
end

v1.RemoveLowGravity = RemoveLowGravity

function v1.StartAntiTunnelGuard(v81, v82, v83) -- line 503 | captures: v18, RunService, v1
    local HumanoidRootPart = v81:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        local v84 = v83 or {}
        local CollideParts = v84.CollideParts
        local v85 = v84.ReferencePart or HumanoidRootPart
        local v86 = RaycastParams.new()
        v86.FilterType = Enum.RaycastFilterType.Exclude
        v86.FilterDescendantsInstances = { v81 }
        v86.RespectCanCollide = true
        local v87 = HumanoidRootPart.Size + Vector3.new(1.5, 1, 1.5)
        local CFrame = HumanoidRootPart.CFrame
        local v88 = os.clock() + v82
        local v89 = v1.FindGroundY(v81, HumanoidRootPart.Position)
        local v90

        local function stop() -- line 530 | captures: v90, v18
            if not v90 then
                return
            end
            v90:Disconnect()
            v90 = nil
            v18 -= 1
        end

        v18 += 1
        local v91 = 0
        v90 = RunService.Heartbeat:Connect(function() -- line 548 | captures: CFrame, v90, v91, v81, HumanoidRootPart, CollideParts, v85, v86, v87, v88, v89, v18, v1
            local v92 = os.clock()
            if not (v88 < v92 or HumanoidRootPart.Parent == nil) then
                v91 += 1
                local v93 = v91 % 3 == 0
                if CollideParts and v93 then
                    for v94, v95 in ipairs(CollideParts) do
                        if v95.Parent ~= nil and not v95.CanCollide then
                            v95.CanCollide = true
                        end
                    end
                end
                local Position = HumanoidRootPart.CFrame.Position
                local v96, v97
                if v89 == nil then
                    v97 = true
                elseif Position.Y < v89 - 25 then
                    v96 = v1.FindGroundY(v81, Position) or v89
                    v97 = false
                else
                    v97 = true
                end
                if not v97 then
                    local ShiftCharacter = v1.ShiftCharacter
                    local v98 = v96 + 5 - Position.Y
                    ShiftCharacter(v81, (Vector3.new(0, v98, 0)))
                    v1.SetCharacterVelocity(v81, Vector3.new(0, 0, 0), (Vector3.new(0, 0, 0)))
                else
                    local v99 = Position - CFrame.Position
                    if v99.Magnitude > 0.5 then
                        local v100 = workspace:Blockcast(CFrame, v87, v99, v86)
                        if v100 and (Position - v100.Position):Dot(v100.Normal) < -0.5 then
                            local v101 = v100.Position + v100.Normal * 3
                            v1.ShiftCharacter(v81, v101 - Position)
                            local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
                            local v102 = AssemblyLinearVelocity:Dot(v100.Normal)
                            if v102 < 0 then
                                v1.SetCharacterVelocity(v81, AssemblyLinearVelocity - v100.Normal * v102)
                            end
                        end
                    end
                    if v93 and v85.Parent ~= nil then
                        local Position = v85.Position
                        local v103 = Position + Vector3.new(0, 8, 0)
                        local v104 = workspace:Raycast(v103, Vector3.new(0, -18, 0), v86)
                        if v104 then
                            local Y = Position.Y
                            local CFrame = v85.CFrame
                            local Size = v85.Size
                            local Y_2 = CFrame.XVector.Y
                            local v105 = math.abs(Y_2) * Size.X
                            local Y_3 = CFrame.YVector.Y
                            local v106 = v105 + math.abs(Y_3) * Size.Y
                            local Y_4 = CFrame.ZVector.Y
                            local v107 = Y - 0.5 * (v106 + math.abs(Y_4) * Size.Z)
                            local v108 = v104.Position.Y - v107
                            if v108 > 0.6 then
                                local ShiftCharacter = v1.ShiftCharacter
                                local v109 = math.min(v108, 0.75)
                                ShiftCharacter(v81, (Vector3.new(0, v109, 0)))
                                v1.StopCharacterDescent(v81)
                            end
                        end
                    end
                end
                CFrame = HumanoidRootPart.CFrame
            else
                if not v90 then
                    return
                end
                v90:Disconnect()
                v90 = nil
                v18 -= 1
            end
        end)
        return stop
    end
    return function() -- line 506
    end
end

return v1
