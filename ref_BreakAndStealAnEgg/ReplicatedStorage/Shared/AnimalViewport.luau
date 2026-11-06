-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ViewportLighting = require(script.Parent.ViewportLighting)
local v1 = {}
local v2 = Color3.fromRGB(70, 70, 70)
local v3 = {
    ARGENTAVIS = {
        nudgeRight = 0.05,
        nudgeUp = -0.05
    },
    AZHDARCHID = {
        nudgeRight = 0.07,
        nudgeUp = -0.05
    },
    Anglerfish = { nudgeUp = 0.05 },
    Fenrir = {
        yaw = -65,
        depth = 0.1
    },
    Raiju = {
        yaw = -65,
        depth = 0.1
    },
    ARCHAEOPTERYX = {
        nudgeRight = 0.06,
        nudgeUp = -0.07,
        zoom = 0.85
    },
    Amphiptere = {
        nudgeRight = -0.05,
        nudgeUp = -0.06
    },
    CALADRIUS = { nudgeUp = -0.12 },
    CERBERUS = {
        nudgeRight = 0.05,
        nudgeUp = 0.05
    },
    Dullahan = { nudgeRight = 0.08 },
    HYDRA = { nudgeRight = -0.08 },
    LEVIATHAN = { nudgeRight = 0.06 },
    Lionfish = { nudgeUp = -0.05 },
    MICRORAPTOR = { nudgeUp = -0.08 },
    PEGASUS = {
        nudgeRight = 0.06,
        zoom = 0.8
    },
    SIMURGH = {
        nudgeUp = -0.1,
        zoom = 0.8
    },
    STEGOSAURUS = {
        nudgeRight = 0.06,
        nudgeUp = 0.06
    },
    STYMPHALIANBIRD = { nudgeUp = -0.04 },
    WYVERN = { nudgeRight = 0.04 },
    sailfish = {
        nudgeRight = 0.08,
        zoom = 1.2
    },
    tuna = {
        nudgeRight = 0.08,
        nudgeUp = -0.05
    },
    Regal = { zoom = 1.5 },
    SPHINX = {
        zoom = 1.35,
        nudgeUp = -0.05
    },
    Snail = { zoom = 1.4 },
    Snake = { zoom = 1.8 },
    Turtle = { zoom = 1.5 },
    Whale = {
        zoom = 1.4,
        nudgeRight = 0.05
    }
}

local function isWalkerRig(v4) -- line 90
    local Model = v4:IsA("Model")
    if Model then
        if v4:FindFirstChildOfClass("Humanoid") == nil then
            Model = false
        else
            Model = v4:FindFirstChild("HumanoidRootPart") ~= nil
        end
    end
    return Model
end

function v1.CloneForViewport(v5) -- line 103
    local v6 = {}

    local function skip(v7) -- line 105 | captures: v6
        if v7 and v7.Archivable then
            v7.Archivable = false
            table.insert(v6, v7)
        end
    end

    local AnimSaves = v5:FindFirstChild("AnimSaves")
    if AnimSaves and AnimSaves.Archivable then
        AnimSaves.Archivable = false
        table.insert(v6, AnimSaves)
    end
    for v8, v9 in v5:GetChildren() do
        local Model = v9:IsA("Model")
        if Model then
            if v9:FindFirstChildOfClass("Humanoid") == nil then
                Model = false
            else
                Model = v9:FindFirstChild("HumanoidRootPart") ~= nil
            end
        end
        if Model and v9 and v9.Archivable then
            v9.Archivable = false
            table.insert(v6, v9)
        end
    end
    local v10 = v5:Clone()
    for v11, v12 in v6 do
        v12.Archivable = true
    end
    return v10
end

function v1.PrepareModel(v13) -- line 126 | captures: ViewportLighting
    local AnimSaves = v13:FindFirstChild("AnimSaves")
    if AnimSaves then
        AnimSaves:Destroy()
    end
    for v14, v15 in v13:GetChildren() do
        local Model = v15:IsA("Model")
        if Model then
            if v15:FindFirstChildOfClass("Humanoid") == nil then
                Model = false
            else
                Model = v15:FindFirstChild("HumanoidRootPart") ~= nil
            end
        end
        if Model then
            v15:Destroy()
        end
    end
    for v16, v17 in v13:GetDescendants() do
        if v17:IsA("Humanoid") or v17:IsA("ProximityPrompt") or v17:IsA("BillboardGui") or v17:IsA("SurfaceAppearance") then
            v17:Destroy()
        end
    end
    ViewportLighting.Unshadow(v13)
end

function v1.AttachCamera(v18, v19, v20, v21) -- line 172 | captures: ViewportLighting, v2, v3
    local v22 = v20 and v3[v20] or {}
    local v23 = v21 or {}
    local fill = v23.fill or v22.fill or 1.05
    local depth = v23.depth or v22.depth or 0.3
    local raise = v23.raise or v22.raise or 0.18
    local v24 = v23.yaw or v22.yaw
    local v25
    if v24 then
        v25 = math.rad(v24)
    else
        v25 = -0.4363323129985824
    end
    local v26, v27 = v19:GetBoundingBox()
    local v28 = v26.Position + v26.LookVector * (v27.Z * depth)
    local v29 = v27.Y * raise
    local v30 = v28 + Vector3.new(0, v29, 0)
    local Unit = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v25) * v26.LookVector).Unit
    local X = v27.X
    local Y = v27.Y
    local v31 = math.max(X, Y) / 2
    if v24 then
        local v32 = math.sin(v25)
        local v33 = math.abs(v32) * v27.Z
        local v34 = math.cos(v25)
        local v35 = (v33 + math.abs(v34) * v27.X) / 2
        local v36 = v27.Y / 2
        v31 = math.max(v35, v36)
    end
    local v37 = v31 / (fill * 0.08748866352592401) * (v22.zoom or 1) * (v23.zoom or 1)
    local v38 = CFrame.lookAt(v30 + Unit * v37, v30)
    local v39 = (v22.nudgeRight or 0) + (v23.nudgeRight or 0)
    local v40 = (v22.nudgeUp or 0) + (v23.nudgeUp or 0)
    if not (v39 == 0 and v40 == 0) then
        local v41 = 2 * v37 * 0.08748866352592401
        v38 -= (v38.RightVector * v39 + v38.UpVector * v40) * v41
    end
    v18.BackgroundColor3 = v2
    ViewportLighting.Apply(v18)
    local Camera = Instance.new("Camera")
    Camera.FieldOfView = 10
    Camera.CFrame = v38
    Camera.Parent = v18
    v18.CurrentCamera = Camera
    return Camera
end

return v1
