-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalWalker = require(ReplicatedStorage.Shared.AnimalWalker)
local CollisionGroups = require(ReplicatedStorage.Shared.CollisionGroups)
local WaitFor = require(ReplicatedStorage.Shared.WaitFor)
local v1 = {}
local v2 = {
    HumanoidRootPart = true,
    BodyHitbox = true,
    BodyCenter = true,
    MouthPoint = true,
    BillboardAnchor = true,
    FloorPoint = true
}
local v3 = PhysicalProperties.new(0.7, 1, 0, 10, 0)
local v4 = false

local function assignGroup(v5) -- line 89 | captures: v4, CollisionGroups
    if not pcall(function() -- line 90 | captures: v5, CollisionGroups
            v5.CollisionGroup = CollisionGroups.Animals
        end) and
        not v4 then
        v4 = true
        warn(("[AnimalRig] collision group \"%*\" is not registered yet; "):format(CollisionGroups.Animals) .. "animals will collide with each other until CollisionGroupService runs")
    end
end

function v1.WaitForCollisionGroups(v6) -- line 103 | captures: PhysicsService, CollisionGroups, WaitFor
    WaitFor.Until(function() -- line 106 | captures: PhysicsService, CollisionGroups
        local v7, v8 = pcall(function() -- line 107 | captures: PhysicsService, CollisionGroups
            return PhysicsService:IsCollisionGroupRegistered(CollisionGroups.Animals)
        end)
        return not v7 or v8
    end, v6 or 5)
end

function v1.ResolveMesh(v9) -- line 118 | captures: AnimalWalker, v2
    local v10 = AnimalWalker.Find(v9)

    local function isWalkerPart(v11) -- line 122 | captures: v10
        if v10 == nil then
            return false
        end
        return (v11:IsDescendantOf(v10))
    end

    local PrimaryPart = v9.PrimaryPart
    if not (PrimaryPart == nil or v2[PrimaryPart.Name]) and not (v10 ~= nil and PrimaryPart:IsDescendantOf(v10)) then
        return PrimaryPart
    end
    local v12
    local v13 = -1
    for v14, v15 in ipairs(v9:GetDescendants()) do
        if v15:IsA("BasePart") and not (v2[v15.Name] or v10 ~= nil and v15:IsDescendantOf(v10)) then
            local Size = v15.Size
            local v16 = Size.X * Size.Y * Size.Z
            if v13 < v16 then
                v12 = v15
                v13 = v16
            end
        end
    end
    return v12
end

local function ensureWeld(v17, v18) -- line 156
    for v19, v20 in ipairs(v18:GetChildren()) do
        if v20:IsA("WeldConstraint") then
            if v20.Part0 == v17 and v20.Part1 == v18 then
                return
            end
            if v20.Part0 == v18 and v20.Part1 == v17 then
                return
            end
        end
    end
    for v21, v22 in ipairs(v18:GetChildren()) do
        if v22:IsA("Motor6D") then
            if v22.Part0 == v17 and v22.Part1 == v18 then
                return
            end
            if v22.Part0 == v18 and v22.Part1 == v17 then
                return
            end
        end
    end
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Name = "RigWeld"
    WeldConstraint.Part0 = v17
    WeldConstraint.Part1 = v18
    WeldConstraint.Parent = v18
end

local function buildRoot(v23, v24) -- line 183 | captures: assignGroup, ensureWeld
    local HumanoidRootPart = v23:FindFirstChild("HumanoidRootPart")
    if not (HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart")) then
        local v25 = v24.Position.Y - v24.Size.Y * 0.5
        local Part = Instance.new("Part")
        Part.Name = "HumanoidRootPart"
        local X = v24.Size.X
        local Z = v24.Size.Z
        Part.Size = Vector3.new(X, 1, Z)
        Part.CFrame = v24.CFrame
        Part.Transparency = 1
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Parent = v23
        ensureWeld(Part, v24)
        local Part_2 = Instance.new("Part")
        Part_2.Name = "FloorPoint"
        Part_2.Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224)
        Part_2.CFrame = CFrame.new(v24.Position.X, v25, v24.Position.Z)
        Part_2.Transparency = 1
        Part_2.Anchored = false
        Part_2.CanCollide = false
        Part_2.CanQuery = false
        Part_2.CanTouch = false
        Part_2.Massless = true
        Part_2.Parent = v23
        ensureWeld(Part, Part_2)
        assignGroup(Part_2)
        return Part
    end
    ensureWeld(HumanoidRootPart, v24)
    return HumanoidRootPart
end

local v26 = Vector3.new(2.049999952316284, 1.6200000047683716, 2.2300000190734863) / Vector3.new(2.369999885559082, 3.3399999141693115, 3.9800000190734863)
local v27 = Vector3.new(0, 0.18000000715255737, -0.10999999940395355) / Vector3.new(2.369999885559082, 3.3399999141693115, 3.9800000190734863)
local v28 = Vector3.new(0, 0.14000000059604645, 0) / Vector3.new(2.369999885559082, 3.3399999141693115, 3.9800000190734863)
local v29 = Vector3.new(0, 1.059999942779541, -1.7899999618530273) / Vector3.new(2.369999885559082, 3.3399999141693115, 3.9800000190734863)
local v30 = Vector3.new(0, 4.849999904632568, -1.0399999618530273) / Vector3.new(2.369999885559082, 3.3399999141693115, 3.9800000190734863)

local function buildMarker(v31, v32, v33, v34, v35) -- line 271 | captures: assignGroup, ensureWeld
    local v36 = v31:FindFirstChild(v33)
    if not (v36 ~= nil and v36:IsA("BasePart")) then
        local Part = Instance.new("Part")
        Part.Name = v33
        Part.Size = v34
        Part.CFrame = v32.CFrame * CFrame.new(v35)
        Part.Transparency = 1
        Part.Anchored = false
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Massless = true
        Part.Parent = v31
        ensureWeld(v32, Part)
        assignGroup(Part)
        return Part
    end
    ensureWeld(v32, v36)
    return v36
end

local function buildMarkers(v37, v38, v39) -- line 300 | captures: v26, v27, v28, v29, v30, buildMarker
    local Size = v38.Size
    buildMarker(v37, v39, "BodyHitbox", Size * v26, Size * v27)
    buildMarker(v37, v39, "BodyCenter", Vector3.new(1, 1, 1) * (Size.Y * 0.29940119760479045), Size * v28)
    buildMarker(v37, v39, "MouthPoint", Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224), Size * v29)
    buildMarker(v37, v39, "BillboardAnchor", Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224), Size * v30)
end

local v40 = {}
local v41 = { __mode = "k" }
local v42 = setmetatable(v40, v41)

local function dropRigConnections(v43) -- line 319 | captures: v42
    local v44 = v42[v43]
    if v44 then
        v42[v43] = nil
        for v45, v46 in v44 do
            v46:Disconnect()
        end
    end
end

local function disconnectAll(v47) -- line 334
    for v48, v49 in v47 do
        v49:Disconnect()
    end
end

function v1.Build(v50) -- line 340 | captures: AnimalWalker, v1, v2, v3, assignGroup, buildRoot, buildMarkers, v42
    local function v51(v52, ...)
        table.insert(v52, ...)
    end

    local function v53(v54, ...)
        table.insert(v54, ...)
    end

    local function v55(v56, ...)
        table.insert(v56, ...)
    end

    local v57 = AnimalWalker.Find(v50)
    if v57 == nil then
        local v58 = v1.ResolveMesh(v50)
        local v59 = ("%* has no BasePart to rig"):format((v50:GetFullName()))
        assert(v58, v59)
        local v60 = buildRoot(v50, v58)
        for v61, v62 in ipairs(v50:GetDescendants()) do
            if v62:IsA("BasePart") and v62 ~= v60 then
                v62.Anchored = false
                v62.CanCollide = false
                v62.Massless = v2[v62.Name] == true
                assignGroup(v62)
            end
        end
        v60.Anchored = false
        v60.CanCollide = true
        v60.Massless = false
        v60.CustomPhysicalProperties = v3
        assignGroup(v60)
        v50.PrimaryPart = v60
        buildMarkers(v50, v58, v60)
        local Humanoid = v50:FindFirstChildOfClass("Humanoid")
        local Humanoid_2 = Humanoid
        if Humanoid == nil then
            Humanoid = Instance.new("Humanoid")
            Humanoid_2 = Humanoid
            Humanoid.RequiresNeck = false
            Humanoid.BreakJointsOnDeath = false
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            Humanoid.Parent = v50
        end
        Humanoid.AutomaticScalingEnabled = false
        local v63 = v58.Size.Y * 0.5 - v60.Size.Y * 0.5
        if v63 <= 0 then
            warn(("[AnimalRig] %*: computed HipHeight %* from mesh \"%*\" "):format(v50.Name, v63, v58.Name) .. ("(height %*) and root height %*. The resolved mesh is not "):format(v58.Size.Y, v60.Size.Y) .. "the body - the animal will stand in the ground.")
        end
        Humanoid.HipHeight = v63
        local v64 = v42[v50]
        if v64 then
            v42[v50] = nil
            for v65, v66 in v64 do
                v66:Disconnect()
            end
        end
        local v67 = {}
        v42[v50] = v67
        local HipHeight = Humanoid:GetPropertyChangedSignal("HipHeight")
        v51(v67, HipHeight:Connect(function() -- line 443 | captures: Humanoid_2, v63
            if Humanoid_2.HipHeight ~= v63 then
                Humanoid_2.HipHeight = v63
            end
        end))
        local Destroying = v50.Destroying
        v53(v67, Destroying:Once(function() -- line 448 | captures: v67
            for v68, v69 in v67 do
                v69:Disconnect()
            end
        end))
        v50:SetAttribute("RigHipHeight", v63)
        Humanoid_2.AutoRotate = true
        Humanoid_2.PlatformStand = false
        local FallingDown = Enum.HumanoidStateType.FallingDown
        Humanoid_2:SetStateEnabled(FallingDown, false)
        local Ragdoll = Enum.HumanoidStateType.Ragdoll
        Humanoid_2:SetStateEnabled(Ragdoll, false)
        local PlatformStanding = Enum.HumanoidStateType.PlatformStanding
        Humanoid_2:SetStateEnabled(PlatformStanding, false)
        local DescendantAdded = v50.DescendantAdded
        v55(v67, DescendantAdded:Connect(function(v70) -- line 464 | captures: v60, v2, assignGroup
            local v71, v72
            if v70:IsA("BasePart") then
                if v70 == v60 then
                    v72 = true
                else
                    v70.CanCollide = false
                    v71 = v2[v70.Name] == true
                    v72 = false
                end
            else
                v72 = true
            end
            if not v72 then
                v70.Massless = v71
                assignGroup(v70)
            end
        end))
        return Humanoid_2, v60
    end
    return AnimalWalker.Build(v50, v57)
end

function v1.EnforcePhysics(v73) -- line 484 | captures: v2
    if v73:GetAttribute("RigMode") ~= "Walker" then
        local HumanoidRootPart = v73:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
            for v74, v75 in ipairs(v73:GetDescendants()) do
                if v75:IsA("BasePart") and v75 ~= HumanoidRootPart then
                    v75.CanCollide = false
                    v75.Massless = v2[v75.Name] == true
                end
            end
            HumanoidRootPart.CanCollide = true
            HumanoidRootPart.Massless = false
            local Humanoid = v73:FindFirstChildOfClass("Humanoid")
            local RigHipHeight = v73:GetAttribute("RigHipHeight")
            if Humanoid ~= nil and typeof(RigHipHeight) == "number" then
                Humanoid.AutomaticScalingEnabled = false
                Humanoid.HipHeight = RigHipHeight
            end
        end
    end
end

return v1
