-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RagdollPhysics = require(script.Parent.RagdollPhysics)
local v1 = {}
local v2 = {}
local v3 = {}

local function clearRagdollAttachments(v4) -- line 55
    if v4 ~= nil then
        for v5, v6 in ipairs(v4:GetChildren()) do
            if v6:IsA("Attachment") and v6:GetAttribute("RagdollAttachment") then
                v6:Destroy()
            end
        end
    end
end

local function clearRagdollConstraints(v7) -- line 66
    if v7 ~= nil then
        for v8, v9 in ipairs(v7:GetChildren()) do
            if v9:GetAttribute("RagdollConstraint") then
                v9:Destroy()
            end
        end
    end
end

local function isNeckJoint(v10) -- line 91
    if v10.Name == "Neck" then
        return true
    end
    local v11, v12 = pcall(function() -- line 96 | captures: v10
        if v10:IsA("Motor6D") then
            local Part0 = v10.Part0
            local Part1 = v10.Part1
            if Part0 ~= nil and Part0.Name == "Head" then
                return true
            end
            if Part1 == nil then
                return false
            end
            return Part1.Name == "Head"
        end
        local Attachment0 = v10.Attachment0
        local Attachment1 = v10.Attachment1
        local v13, v14
        if Attachment0 == nil or Attachment0.Parent == nil then
            v14 = false
        elseif Attachment0.Parent.Name == "Head" then
            v13 = true
            v14 = true
        else
            v14 = false
        end
        if not v14 then
            if Attachment1 == nil or Attachment1.Parent == nil then
                v13 = false
            else
                v13 = Attachment1.Parent.Name == "Head"
            end
        end
        return v13
    end)
    return v11 and v12
end

local function isToolJoint(v15) -- line 120
    if v15:FindFirstAncestorOfClass("Tool") == nil then
        local Part1 = v15.Part1
        if Part1 == nil then
            return false
        end
        return Part1:FindFirstAncestorOfClass("Tool") ~= nil
    end
    return true
end

local function createConstraintFromMotor6D(v16) -- line 129
    local Part0 = v16.Part0
    local Part1 = v16.Part1
    if Part0 == nil or Part1 == nil then
        return nil
    end
    local Attachment = Instance.new("Attachment")
    local Attachment_2 = Instance.new("Attachment")
    Attachment.Name = ("RagdollAttachment_%*_A"):format(v16.Name)
    Attachment_2.Name = ("RagdollAttachment_%*_B"):format(v16.Name)
    Attachment:SetAttribute("RagdollAttachment", v16.Name)
    Attachment_2:SetAttribute("RagdollAttachment", v16.Name)
    Attachment.CFrame = v16.C0
    Attachment_2.CFrame = v16.C1
    Attachment.Parent = Part0
    Attachment_2.Parent = Part1
    local HingeConstraint
    if v16.Name == "Root" or v16.Name == "Neck" then
        HingeConstraint = Instance.new("HingeConstraint")
        HingeConstraint.LimitsEnabled = true
    else
        HingeConstraint = Instance.new("BallSocketConstraint")
        HingeConstraint.LimitsEnabled = true
        HingeConstraint.TwistLimitsEnabled = true
    end
    HingeConstraint.Name = ("RagdollConstraint_%*"):format(v16.Name)
    HingeConstraint:SetAttribute("RagdollConstraint", v16.Name)
    HingeConstraint.Attachment0 = Attachment
    HingeConstraint.Attachment1 = Attachment_2
    HingeConstraint.Parent = v16.Parent
    return HingeConstraint
end

local function limpAnimationConstraint(v17) -- line 190
    local v18, v19 = pcall(function() -- line 191 | captures: v17
        return {
            IsKinematic = v17.IsKinematic,
            MaxForce = v17.MaxForce,
            MaxTorque = v17.MaxTorque
        }
    end)
    if v18 and
        pcall(function() -- line 203 | captures: v17
            v17.IsKinematic = false
            v17.MaxForce = 0
            v17.MaxTorque = 0
        end) then
        return v19
    end
    v17.Enabled = false
    return nil
end

local function restoreAnimationConstraint(v20, v21) -- line 215
    if v21 == nil then
        v20.Enabled = true
    else
        pcall(function() -- line 220 | captures: v20, v21
            v20.MaxForce = v21.MaxForce
            v20.MaxTorque = v21.MaxTorque
            v20.IsKinematic = v21.IsKinematic
        end)
    end
end

local function createRagdollConstraints(v22) -- line 227 | captures: createConstraintFromMotor6D
    for v23, v24 in ipairs(v22:GetDescendants()) do
        if v24:IsA("Motor6D") then
            local v25
            if v24.Name == "Neck" then
                v25 = true
            else
                local pcall_2 = pcall
                local v26 = v24
                local v27, v28 = pcall_2(function() -- line 96 | captures: v26
                    if v26:IsA("Motor6D") then
                        local Part0 = v26.Part0
                        local Part1 = v26.Part1
                        if Part0 ~= nil and Part0.Name == "Head" then
                            return true
                        end
                        if Part1 == nil then
                            return false
                        end
                        return Part1.Name == "Head"
                    end
                    local Attachment0 = v26.Attachment0
                    local Attachment1 = v26.Attachment1
                    local v29, v30
                    if Attachment0 == nil or Attachment0.Parent == nil then
                        v30 = false
                    elseif Attachment0.Parent.Name == "Head" then
                        v29 = true
                        v30 = true
                    else
                        v30 = false
                    end
                    if not v30 then
                        if Attachment1 == nil or Attachment1.Parent == nil then
                            v29 = false
                        else
                            v29 = Attachment1.Parent.Name == "Head"
                        end
                    end
                    return v29
                end)
                v25 = v27 and v28
            end
            if not v25 then
                local v31
                if v24:FindFirstAncestorOfClass("Tool") == nil then
                    local Part1 = v24.Part1
                    if Part1 == nil then
                        v31 = false
                    else
                        v31 = Part1:FindFirstAncestorOfClass("Tool") ~= nil
                    end
                else
                    v31 = true
                end
                if not v31 then
                    createConstraintFromMotor6D(v24)
                    v24.Enabled = false
                end
            end
        end
    end
end

local function destroyRagdollConstraints(v32) -- line 238 | captures: clearRagdollAttachments, clearRagdollConstraints
    for v33, v34 in ipairs(v32:GetDescendants()) do
        if v34:IsA("Motor6D") then
            v34.Enabled = true
        elseif v34:IsA("BasePart") then
            clearRagdollConstraints(v34)
            clearRagdollAttachments(v34)
        end
    end
end

function v1.IsRagdolled(v35) -- line 250
    if v35 == nil then
        return false
    end
    if v35:GetAttribute("Ragdolled") then
        return true
    end
    local Humanoid = v35:FindFirstChildOfClass("Humanoid")
    if Humanoid == nil then
        return false
    end
    return Humanoid:GetState() == Enum.HumanoidStateType.Physics
end

function v1.IsActive(v36) -- line 271 | captures: v2
    local v37 = v2[v36]
    if v37 == nil then
        return false
    end
    return os.clock() < v37
end

function v1.RagdollFor(v38) -- line 322 | captures: RunService, RagdollPhysics, v2, v3, limpAnimationConstraint, createRagdollConstraints, destroyRagdollConstraints
    local Character = v38.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if Humanoid ~= nil and HumanoidRootPart ~= nil and not (Humanoid.Health <= 0) then
        if Humanoid:GetState() == Enum.HumanoidStateType.Physics then
            return false
        end
        local v39 = os.clock()
        if v2[v38.Player] and v39 < v2[v38.Player] then
            return false
        end
        v2[v38.Player] = v39 + v38.Duration
        Character:SetAttribute("Ragdolled", true)
        local DevEnableMouseLock
        if RunService:IsServer() then
            DevEnableMouseLock = v38.Player.DevEnableMouseLock
            v38.Player.DevEnableMouseLock = false
        end
        local RequiresNeck = Humanoid.RequiresNeck
        Humanoid.RequiresNeck = false
        local v40 = 0
        local v41 = {}
        local v42 = 0
        for v43, v44 in ipairs(Character:GetDescendants()) do
            if v44:IsA("Motor6D") then
                local v45
                if v44:FindFirstAncestorOfClass("Tool") == nil then
                    local Part1 = v44.Part1
                    if Part1 == nil then
                        v45 = false
                    else
                        v45 = Part1:FindFirstAncestorOfClass("Tool") ~= nil
                    end
                else
                    v45 = true
                end
                if not v45 then
                    local v46 = v42 + 1
                    v40 = v46
                    v42 = v46
                end
            elseif v44:IsA("AnimationConstraint") and v44.Enabled then
                local v47
                if v44.Name == "Neck" then
                    v47 = true
                else
                    local pcall_2 = pcall
                    local v48 = v44
                    local v49, v50 = pcall_2(function() -- line 96 | captures: v48
                        if v48:IsA("Motor6D") then
                            local Part0 = v48.Part0
                            local Part1 = v48.Part1
                            if Part0 ~= nil and Part0.Name == "Head" then
                                return true
                            end
                            if Part1 == nil then
                                return false
                            end
                            return Part1.Name == "Head"
                        end
                        local Attachment0 = v48.Attachment0
                        local Attachment1 = v48.Attachment1
                        local v51, v52
                        if Attachment0 == nil or Attachment0.Parent == nil then
                            v52 = false
                        elseif Attachment0.Parent.Name == "Head" then
                            v51 = true
                            v52 = true
                        else
                            v52 = false
                        end
                        if not v52 then
                            if Attachment1 == nil or Attachment1.Parent == nil then
                                v51 = false
                            else
                                v51 = Attachment1.Parent.Name == "Head"
                            end
                        end
                        return v51
                    end)
                    v47 = v49 and v50
                end
                if not v47 then
                    table.insert(v41, v44)
                end
            end
        end
        local v53 = #v41 > 0
        local UpperTorso = Character:FindFirstChild("UpperTorso")
        local LowerTorso = Character:FindFirstChild("LowerTorso")
        if not (UpperTorso ~= nil and UpperTorso:IsA("BasePart")) then
            UpperTorso = nil
        end
        local v54 = false
        local v55
        if RunService:IsServer() then
            if v38.ClientDriven then
                v55 = false
            else
                local v56 = RagdollPhysics.SetCharacterNetworkOwner(Character, nil)
                v54 = v56
                v55 = v56
            end
        else
            v55 = false
        end
        local v57 = Humanoid:GetStateEnabled(Enum.HumanoidStateType.GettingUp)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        local AutoRotate = Humanoid.AutoRotate
        Humanoid.AutoRotate = false
        local PlatformStand = Humanoid.PlatformStand
        if v53 then
            Humanoid.PlatformStand = true
        end
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        local Velocity
        if v38.ClientDriven then
        else
            Velocity = v38.Velocity
        end
        local v58 = Vector3.new(0, 0, 0)
        local v59 = v58
        local v60
        if Velocity == nil then
            v60 = v58
        else
            local X = Velocity.X
            local Z = Velocity.Z
            local v61 = Vector3.new(X, 0, Z)
            local v62 = v38.TumbleSpin or 0
            local v63
            if v62 == 0 then
                v63 = v58
            elseif v61.Magnitude > 0.01 then
                v63 = Vector3.new(0, 1, 0):Cross(v61.Unit) * v62
                v59 = v63
            else
                v63 = v58
            end
            RagdollPhysics.SetCharacterVelocity(Character, Velocity, v63)
            v60 = v63
        end
        if v42 > 0 then
            createRagdollConstraints(Character)
        end
        local v64 = {}
        for v65, v66 in ipairs(v41) do
            v64[v65] = limpAnimationConstraint(v66)
        end
        local v67 = {}
        local v68 = {}
        for v69, v70 in ipairs(Character:GetChildren()) do
            if v70:IsA("BasePart") and v70 ~= HumanoidRootPart and (v70.Name == "Head" or Humanoid:GetBodyPartR15(v70) ~= Enum.BodyPartR15.Unknown) then
                v67[v70] = v70.CanCollide
                v70.CanCollide = true
                table.insert(v68, v70)
            end
        end
        HumanoidRootPart.CanCollide = false
        local Motor6D
        local CustomPhysicalProperties = HumanoidRootPart.CustomPhysicalProperties
        local Motor6D_2, v71
        if v53 then
            if UpperTorso == nil then
                v71 = true
            else
                Motor6D_2 = Instance.new("Motor6D")
                Motor6D = Motor6D_2
                Motor6D_2.Name = "RagdollAltRoot"
                if LowerTorso ~= nil and LowerTorso:IsA("BasePart") then
                    Motor6D_2.C0 = CFrame.new(0, LowerTorso.Size.Y * 0.7, 0)
                end
                v71 = false
            end
        else
            v71 = true
        end
        if not v71 then
            Motor6D_2.Part0 = HumanoidRootPart
            Motor6D_2.Part1 = UpperTorso
            Motor6D_2.Parent = UpperTorso
            HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0, 0, 0)
        end
        if v55 then
            RagdollPhysics.SetCharacterNetworkOwner(Character, nil)
        end
        if Velocity == nil then
            if not v38.ClientDriven then
                local v72
                if v53 then
                    if UpperTorso == nil then
                        v72 = HumanoidRootPart
                    else
                        v72 = UpperTorso
                    end
                else
                    v72 = HumanoidRootPart
                end
                local Impulse = v38.Impulse
                local v73 = Vector3.new(0, 0, 0)
                v72:ApplyImpulse(Impulse or v73)
            end
        else
            RagdollPhysics.SetCharacterVelocity(Character, Velocity, v60)
        end
        RagdollPhysics.ApplyLowGravity(Character, v38.GravityScale or 1)
        local GravityDuration = v38.GravityDuration
        if GravityDuration ~= nil and GravityDuration > 0 then
            local v74 = v2[v38.Player]
            task.delay(GravityDuration, function() -- line 584 | captures: v38, Character, v74, RagdollPhysics, v2
                if Character.Parent ~= nil and v2[v38.Player] == v74 then
                    RagdollPhysics.RemoveLowGravity(Character)
                end
            end)
        end
        local v75
        if RunService:IsServer() and not v38.ClientDriven then
            v75 = RagdollPhysics.StartAntiTunnelGuard(Character, v38.Duration + 1, {
                CollideParts = v68,
                ReferencePart = UpperTorso or HumanoidRootPart
            })
        end
        if Velocity ~= nil then
            local v76 = v2[v38.Player]
            local Heartbeat = RunService.Heartbeat
            local Velocity_2 = Velocity
            Heartbeat:Once(function() -- line 618 | captures: v59, v38, Character, v76, Velocity_2, RagdollPhysics, v2
                if Character.Parent ~= nil and v2[v38.Player] == v76 then
                    RagdollPhysics.SetCharacterVelocity(Character, Velocity_2, v59)
                end
            end)
        end
        local v77
        if not v53 and not v38.ClientDriven then
            v77 = Humanoid.StateChanged:Connect(function(v78, v79) -- line 638 | captures: Humanoid
                if v79 ~= Enum.HumanoidStateType.Physics and v79 ~= Enum.HumanoidStateType.Dead then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                end
            end)
        end
        local v80 = false

        local function release() -- line 646 | captures: DevEnableMouseLock, v40, v54, Motor6D, v75, v77, v80, v38, Character, Humanoid, HumanoidRootPart, RequiresNeck, v41, v57, AutoRotate, PlatformStand, v64, v67, CustomPhysicalProperties, RagdollPhysics, v2, v3, destroyRagdollConstraints
            if v80 then
                return
            end
            v80 = true
            if v77 ~= nil then
                v77:Disconnect()
            end
            if v75 ~= nil then
                v75()
                v75 = nil
            end
            v2[v38.Player] = nil
            v3[Character] = nil
            Character:SetAttribute("Ragdolled", nil)
            if DevEnableMouseLock ~= nil and v38.Player.Parent ~= nil then
                v38.Player.DevEnableMouseLock = DevEnableMouseLock
            end
            if not (Character.Parent == nil or Humanoid.Parent == nil or Humanoid.Health <= 0) then
                if v40 > 0 then
                    destroyRagdollConstraints(Character)
                end
                for v81, v82 in ipairs(v41) do
                    if v82.Parent ~= nil then
                        local v83 = v64[v81]
                        if v83 == nil then
                            v82.Enabled = true
                        else
                            local pcall_2 = pcall
                            local v84 = v82
                            pcall_2(function() -- line 220 | captures: v83, v84
                                v84.MaxForce = v83.MaxForce
                                v84.MaxTorque = v83.MaxTorque
                                v84.IsKinematic = v83.IsKinematic
                            end)
                        end
                    end
                end
                RagdollPhysics.RemoveLowGravity(Character)
                for v85, v86 in pairs(v67) do
                    if v85.Parent ~= nil then
                        v85.CanCollide = v86
                    end
                end
                if Motor6D ~= nil then
                    Motor6D:Destroy()
                end
                HumanoidRootPart.CustomPhysicalProperties = CustomPhysicalProperties
                for v87, v88 in ipairs(Character:GetDescendants()) do
                    if v88:IsA("BasePart") then
                        v88.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        v88.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
                Humanoid.RequiresNeck = RequiresNeck
                Humanoid.PlatformStand = PlatformStand
                Humanoid.AutoRotate = AutoRotate
                HumanoidRootPart.CanCollide = true
                if not v38.ClientDriven then
                    RagdollPhysics.SnapUpright(Character)
                end
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, v57)
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                if v38.OnRelease ~= nil then
                    task.spawn(v38.OnRelease)
                end
                if v54 then
                    RagdollPhysics.SetCharacterNetworkOwner(Character, v38.Player)
                end
            elseif v54 and Character.Parent ~= nil then
                RagdollPhysics.SetCharacterNetworkOwner(Character, v38.Player)
            end
        end

        v3[Character] = release
        task.delay(v38.Duration, release)
        return true
    end
    return false
end

function v1.Release(v89) -- line 764 | captures: v3
    if v89 ~= nil then
        local v90 = v3[v89]
        if v90 ~= nil then
            v90()
        end
    end
end

Players.PlayerRemoving:Connect(function(v91) -- line 774 | captures: v2
    v2[v91] = nil
end)
return v1
