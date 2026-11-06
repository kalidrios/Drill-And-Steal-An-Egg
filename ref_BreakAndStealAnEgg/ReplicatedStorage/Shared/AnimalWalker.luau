-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalWalkerTemplate = require(ReplicatedStorage.Shared.AnimalWalkerTemplate)
local CollisionGroups = require(ReplicatedStorage.Shared.CollisionGroups)
local ModelScaler = require(ReplicatedStorage.Shared.ModelScaler)
local v1 = { WALKER_NAME = "R6" }
local v2 = {
    BodyHitbox = true,
    MouthPoint = true
}
local v3 = { "BodyHitbox", "BodyCenter" }

local function assignGroup(v4) -- line 58 | captures: CollisionGroups
    pcall(function() -- line 59 | captures: v4, CollisionGroups
        v4.CollisionGroup = CollisionGroups.Animals
    end)
end

local function ensureWeld(v5, v6) -- line 64
    for v7, v8 in ipairs(v6:GetChildren()) do
        if v8:IsA("WeldConstraint") then
            if v8.Part0 == v5 and v8.Part1 == v6 then
                return
            end
            if v8.Part0 == v6 and v8.Part1 == v5 then
                return
            end
        end
    end
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Name = "WalkerWeld"
    WeldConstraint.Part0 = v5
    WeldConstraint.Part1 = v6
    WeldConstraint.Parent = v6
end

local function Hide(v9) -- line 82
    for v10, v11 in ipairs(v9:GetDescendants()) do
        if v11:IsA("BasePart") or v11:IsA("Decal") or v11:IsA("Texture") then
            v11.Transparency = 1
        end
    end
end

v1.Hide = Hide

local function Find(v12) -- line 93
    for v13, v14 in ipairs(v12:GetChildren()) do
        if v14:IsA("Model") then
            local Humanoid = v14:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = v14:FindFirstChild("HumanoidRootPart")
            if Humanoid ~= nil and HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                return v14
            end
        end
    end
    return nil
end

v1.Find = Find

function v1.ResolveHitPart(v15, v16, v17) -- line 113 | captures: v3
    for v18, v19 in ipairs(v3) do
        local v20 = v15:FindFirstChild(v19)
        if v20 ~= nil and v20:IsA("BasePart") and (v16 == nil or not v20:IsDescendantOf(v16)) then
            return v20
        end
    end
    local v21
    local v22 = -1
    for v23, v24 in ipairs(v15:GetDescendants()) do
        if v24:IsA("BasePart") and (v16 == nil or not v24:IsDescendantOf(v16)) then
            local Size = v24.Size
            local v25 = Size.X * Size.Y * Size.Z
            if v22 < v25 then
                v21 = v24
                v22 = v25
            end
        end
    end
    return v21 or v17
end

local function HitDistanceXZ(v26, v27) -- line 150
    local v28 = v26.CFrame:PointToObjectSpace(v27)
    local v29 = v26.Size * 0.5
    local X = v28.X
    local v30 = math.abs(X) - v29.X
    local v31 = math.max(v30, 0)
    local Z = v28.Z
    local v32 = math.abs(Z) - v29.Z
    local v33 = math.max(v32, 0)
    local v34 = v31 * v31 + v33 * v33
    return (math.sqrt(v34))
end

v1.HitDistanceXZ = HitDistanceXZ

local v35 = {}
local v36 = { __mode = "k" }
local v37 = setmetatable(v35, v36)

local function dropBuildConnections(v38) -- line 174 | captures: v37
    local v39 = v37[v38]
    if v39 then
        v37[v38] = nil
        for v40, v41 in v39 do
            v41:Disconnect()
        end
    end
end

local function disconnectAll(v42) -- line 189
    for v43, v44 in v42 do
        v44:Disconnect()
    end
end

function v1.Build(v45, v46) -- line 195 | captures: CollisionGroups, v2, ensureWeld, v37
    local function v47(v48, ...)
        table.insert(v48, ...)
    end

    local function v49(v50, ...)
        table.insert(v50, ...)
    end

    local Humanoid = v46:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = v46:FindFirstChild("HumanoidRootPart")
    local v51 = v46:GetFullName() .. " has no Humanoid"
    assert(Humanoid, v51)
    local v52 = HumanoidRootPart and HumanoidRootPart:IsA("BasePart")
    local v53 = v46:GetFullName() .. " has no HumanoidRootPart"
    assert(v52, v53)
    for v54, v55 in ipairs(v46:GetDescendants()) do
        if v55:IsA("BasePart") then
            v55.Anchored = false
            v55.Transparency = 1
            v55.CanQuery = false
            v55.CanTouch = false
            local pcall_2 = pcall
            local v56 = v55
            pcall_2(function() -- line 59 | captures: v56, CollisionGroups
                v56.CollisionGroup = CollisionGroups.Animals
            end)
        elseif v55:IsA("Decal") or v55:IsA("Texture") then
            v55.Transparency = 1
        end
    end
    v46.PrimaryPart = HumanoidRootPart
    local v57 = {}
    local v58 = {}
    for v59, v60 in ipairs(v45:GetDescendants()) do
        if not v60:IsDescendantOf(v46) and v60:IsA("BasePart") then
            if v60.Name == "HumanoidRootPart" then
                table.insert(v58, v60)
            else
                table.insert(v57, v60)
            end
        end
    end
    for v61, v62 in ipairs(v58) do
        v62:Destroy()
    end
    for v63, v64 in ipairs(v57) do
        v64.Anchored = false
        v64.CanCollide = false
        v64.Massless = true
        v64.CanQuery = v2[v64.Name] == true
        v64.CanTouch = false
        local v65 = v64
        pcall(function() -- line 59 | captures: v65, CollisionGroups
            v65.CollisionGroup = CollisionGroups.Animals
        end)
        ensureWeld(HumanoidRootPart, v64)
    end
    local v66 = v37[v45]
    if v66 then
        v37[v45] = nil
        for v67, v68 in v66 do
            v68:Disconnect()
        end
    end
    local v69 = {}
    v37[v45] = v69
    local DescendantAdded = v45.DescendantAdded
    v47(v69, DescendantAdded:Connect(function(v70) -- line 256 | captures: v46, HumanoidRootPart, CollisionGroups, ensureWeld
        if not v70:IsA("BasePart") or v70:IsDescendantOf(v46) then
            return
        end
        v70.CanCollide = false
        v70.Massless = true
        pcall(function() -- line 59 | captures: v70, CollisionGroups
            v70.CollisionGroup = CollisionGroups.Animals
        end)
        ensureWeld(HumanoidRootPart, v70)
    end))
    local Destroying = v45.Destroying
    v49(v69, Destroying:Once(function() -- line 265 | captures: v69
        for v71, v72 in v69 do
            v72:Disconnect()
        end
    end))
    v45.PrimaryPart = HumanoidRootPart
    v45:SetAttribute("RigMode", "Walker")
    Humanoid.AutoRotate = true
    Humanoid.PlatformStand = false
    Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    return Humanoid, HumanoidRootPart
end

local v73 = {
    HumanoidRootPart = true,
    BodyHitbox = true,
    BodyCenter = true,
    MouthPoint = true,
    BillboardAnchor = true,
    FloorPoint = true
}

function v1.ResolveBodyMesh(v74, v75) -- line 295 | captures: v73
    local v76
    local v77 = -1
    for v78, v79 in ipairs(v74:GetDescendants()) do
        if v79:IsA("BasePart") and not v73[v79.Name] and (v75 == nil or not v79:IsDescendantOf(v75)) then
            local Size = v79.Size
            local v80 = Size.X * Size.Y * Size.Z
            if v77 < v80 then
                v76 = v79
                v77 = v80
            end
        end
    end
    return v76
end

function v1.ResolveFeetY(v81, v82, v83) -- line 327 | captures: v73
    local v84 = (1/0)
    for v85, v86 in ipairs(v81:GetDescendants()) do
        if v86:IsA("BasePart") and not v73[v86.Name] and v86.Transparency < 1 and (v82 == nil or not v86:IsDescendantOf(v82)) then
            local CFrame = v86.CFrame
            local v87 = v86.Size * 0.5
            local Y = CFrame.RightVector.Y
            local v88 = math.abs(Y) * v87.X
            local Y_2 = CFrame.UpVector.Y
            local v89 = v88 + math.abs(Y_2) * v87.Y
            local Y_3 = CFrame.LookVector.Y
            local v90 = v89 + math.abs(Y_3) * v87.Z
            local v91 = v86.Position.Y - v90
            v84 = math.min(v84, v91)
        end
    end
    if v84 == (1/0) then
        return v83.Position.Y - v83.Size.Y * 0.5
    end
    return v84
end

function v1.ResolveTemplate(v92) -- line 360 | captures: ReplicatedStorage, AnimalWalkerTemplate, v1
    local Templates = ReplicatedStorage:FindFirstChild("Templates")
    if Templates ~= nil then
        local WalkerRig = Templates:FindFirstChild("WalkerRig")
        if WalkerRig ~= nil and WalkerRig:IsA("Model") then
            return WalkerRig
        end
    end
    for v93, v94 in ipairs(v92:GetChildren()) do
        if v94:IsA("Model") then
            local v95 = v1.Find(v94)
            if v95 ~= nil then
                return v95
            end
        end
    end
    return AnimalWalkerTemplate.Create()
end

function v1.Stamp(v96, v97, v98) -- line 410 | captures: ModelScaler, v1
    local v99 = v98 or {}
    local v100 = v1.ResolveBodyMesh(v96, nil)
    if v100 ~= nil then
        local v101 = v97:Clone()
        v101.Name = v1.WALKER_NAME
        local HumanoidRootPart = v101:FindFirstChild("HumanoidRootPart")
        local v102
        if HumanoidRootPart == nil then
            v102 = true
        elseif HumanoidRootPart:IsA("BasePart") then
            v101.PrimaryPart = HumanoidRootPart
            if v99.ScaleToAnimal then
                local v103, v104 = v101:GetBoundingBox()
                if v104.Y > 0 then
                    pcall(function() -- line 430 | captures: v100, v101, v104, ModelScaler
                        local ScaleBy = ModelScaler.ScaleBy
                        local v105 = v100.Size.Y / v104.Y
                        ScaleBy(v101, (math.max(v105, 0.05)))
                    end)
                end
            end
            v102 = false
        else
            v102 = true
        end
        if not v102 then
            local v106, v107 = v101:GetBoundingBox()
            local v108 = HumanoidRootPart.Position.Y - (v106.Position.Y - v107.Y * 0.5)
            local v109 = v1.ResolveFeetY(v96, v101, v100)
            local LookVector = v100.CFrame.LookVector
            local X = LookVector.X
            local Z = LookVector.Z
            local v110 = Vector3.new(X, 0, Z)
            local v111
            if v110.Magnitude > 0.0001 then
                v111 = CFrame.lookAt(Vector3.new(0, 0, 0), v110.Unit)
            else
                v111 = CFrame.identity
            end
            if v99.YawOffset then
                local Angles = CFrame.Angles
                local YawOffset = v99.YawOffset
                v111 *= Angles(0, math.rad(YawOffset), 0)
            end
            v101:SetPrimaryPartCFrame(CFrame.new(v100.Position.X, v109 + v108, v100.Position.Z) * v111)
            HumanoidRootPart.Anchored = true
            v1.Hide(v101)
            v101.Parent = v96
            return v101
        end
        v101:Destroy()
    end
    return nil
end

return v1
