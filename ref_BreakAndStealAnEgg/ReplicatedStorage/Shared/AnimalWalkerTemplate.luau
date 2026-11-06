-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = {
    {
        Name = "Torso",
        Size = Vector3.new(2, 2, 1),
        Offset = Vector3.new(0, 0, 0),
        CanCollide = true
    },
    {
        Name = "Head",
        Size = Vector3.new(2, 1, 1),
        Offset = Vector3.new(0, 1.5, 0),
        CanCollide = true
    },
    {
        Name = "Left Arm",
        Size = Vector3.new(1, 2, 1),
        Offset = Vector3.new(-1.5, 0, 0),
        CanCollide = false
    },
    {
        Name = "Right Arm",
        Size = Vector3.new(1, 2, 1),
        Offset = Vector3.new(1.5, 0, 0),
        CanCollide = false
    },
    {
        Name = "Left Leg",
        Size = Vector3.new(1, 2, 1),
        Offset = Vector3.new(-0.5, -2, 0),
        CanCollide = false
    },
    {
        Name = "Right Leg",
        Size = Vector3.new(1, 2, 1),
        Offset = Vector3.new(0.5, -2, 0),
        CanCollide = false
    }
}
local v3 = {
    {
        Name = "RootJoint",
        Part0 = "HumanoidRootPart",
        Part1 = "Torso",
        Parent = "HumanoidRootPart",
        C0 = CFrame.new(0, 0, 0) * CFrame.Angles(-1.5707963267948966, 0, 3.141592653589793),
        C1 = CFrame.new(0, 0, 0) * CFrame.Angles(-1.5707963267948966, 0, 3.141592653589793)
    },
    {
        Name = "Neck",
        Part0 = "Torso",
        Part1 = "Head",
        Parent = "Torso",
        C0 = CFrame.new(0, 1, 0) * CFrame.Angles(-1.5707963267948966, 0, 3.141592653589793),
        C1 = CFrame.new(0, -0.5, 0) * CFrame.Angles(-1.5707963267948966, 0, 3.141592653589793)
    },
    {
        Name = "Right Shoulder",
        Part0 = "Torso",
        Part1 = "Right Arm",
        Parent = "Torso",
        C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(0, 1.5707963267948966, 0),
        C1 = CFrame.new(-0.5, 0.5, 0) * CFrame.Angles(0, 1.5707963267948966, 0)
    },
    {
        Name = "Left Shoulder",
        Part0 = "Torso",
        Part1 = "Left Arm",
        Parent = "Torso",
        C0 = CFrame.new(-1, 0.5, 0) * CFrame.Angles(0, -1.5707963267948966, 0),
        C1 = CFrame.new(0.5, 0.5, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
    },
    {
        Name = "Right Hip",
        Part0 = "Torso",
        Part1 = "Right Leg",
        Parent = "Torso",
        C0 = CFrame.new(1, -1, 0) * CFrame.Angles(0, 1.5707963267948966, 0),
        C1 = CFrame.new(0.5, 1, 0) * CFrame.Angles(0, 1.5707963267948966, 0)
    },
    {
        Name = "Left Hip",
        Part0 = "Torso",
        Part1 = "Left Leg",
        Parent = "Torso",
        C0 = CFrame.new(-1, -1, 0) * CFrame.Angles(0, -1.5707963267948966, 0),
        C1 = CFrame.new(-0.5, 1, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
    }
}

local function newPart(v4, v5, v6, v7) -- line 109
    local Part = Instance.new("Part")
    Part.Name = v4
    Part.Size = v5
    Part.CFrame = v6
    Part.CanCollide = v7
    Part.Anchored = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    return Part
end

function v1.Create() -- line 127 | captures: v2, v3
    local Model = Instance.new("Model")
    Model.Name = "WalkerRig"
    local v8 = CFrame.new()
    local Part = Instance.new("Part")
    Part.Name = "HumanoidRootPart"
    Part.Size = Vector3.new(2, 2, 1)
    Part.CFrame = v8
    Part.CanCollide = false
    Part.Anchored = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Transparency = 1
    Part.Anchored = true
    Part.Parent = Model
    local v9 = { HumanoidRootPart = Part }
    for v10, v11 in ipairs(v2) do
        local Name = v11.Name
        local Size = v11.Size
        local v12 = CFrame.new(v11.Offset)
        local CanCollide = v11.CanCollide
        local Part = Instance.new("Part")
        Part.Name = Name
        Part.Size = Size
        Part.CFrame = v12
        Part.CanCollide = CanCollide
        Part.Anchored = false
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Parent = Model
        v9[v11.Name] = Part
    end
    for v13, v14 in ipairs(v3) do
        local Motor6D = Instance.new("Motor6D")
        Motor6D.Name = v14.Name
        Motor6D.Part0 = v9[v14.Part0]
        Motor6D.Part1 = v9[v14.Part1]
        Motor6D.C0 = v14.C0
        Motor6D.C1 = v14.C1
        Motor6D.Parent = v9[v14.Parent]
    end
    local Humanoid = Instance.new("Humanoid")
    Humanoid.RigType = Enum.HumanoidRigType.R6
    Humanoid.Parent = Model
    Model.PrimaryPart = Part
    return Model
end

return v1
