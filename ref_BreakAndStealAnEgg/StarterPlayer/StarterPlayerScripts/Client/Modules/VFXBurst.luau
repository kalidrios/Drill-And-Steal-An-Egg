-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ModelScaler = require(ReplicatedStorage.Shared.ModelScaler)
local v1 = {}
local v2 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function getTemplate(v4) -- line 35 | captures: ReplicatedStorage
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    return VFX and VFX:FindFirstChild(v4)
end

local function quiet(v5) -- line 40
    v5.Anchored = true
    v5.CanCollide = false
    v5.CanQuery = false
    v5.CanTouch = false
    v5.CastShadow = false
end

local function playShockwave(v6, v7) -- line 49 | captures: TweenService, v2, v3
    for v8, v9 in v7:GetDescendants() do
        if v9:IsA("Decal") or v9:IsA("Texture") then
            v9.Transparency = 1
        end
    end
    TweenService:Create(v6, v2, {
        Size = v7.Size,
        CFrame = v7.CFrame
    }):Play()
    local SpecialMesh = v6:FindFirstChildWhichIsA("SpecialMesh")
    local SpecialMesh_2 = v7:FindFirstChildWhichIsA("SpecialMesh")
    if SpecialMesh and SpecialMesh_2 then
        TweenService:Create(SpecialMesh, v2, { Scale = SpecialMesh_2.Scale }):Play()
    end
    for v10, v11 in v6:GetDescendants() do
        if v11:IsA("Decal") or v11:IsA("Texture") then
            TweenService:Create(v11, v3, { Transparency = 1 }):Play()
        end
    end
end

local function tintSequence(v12, v13, v14) -- line 70
    local function v15(v16, ...)
        table.insert(v16, ...)
    end

    local v17 = {}
    for v18, v19 in v12.Keypoints do
        v15(v17, ColorSequenceKeypoint.new(v19.Time, v19.Value:Lerp(v13, v14)))
    end
    return ColorSequence.new(v17)
end

function v1.Tint(v20, v21, v22) -- line 79 | captures: v1, tintSequence
    local v23 = v22 or v1.TintStrength
    local v24 = math.clamp(v23, 0, 1)
    for v25, v26 in v20:GetDescendants() do
        if v26:IsA("ParticleEmitter") or v26:IsA("Beam") or v26:IsA("Trail") then
            v26.Color = tintSequence(v26.Color, v21, v24)
        elseif v26:IsA("Decal") or v26:IsA("Texture") then
            v26.Color3 = v26.Color3:Lerp(v21, v24)
        elseif v26:IsA("PointLight") or v26:IsA("SpotLight") or v26:IsA("SurfaceLight") then
            v26.Color = v26.Color:Lerp(v21, v24)
        end
    end
end

v1.TintStrength = 0.75

local v27 = {}
local v28 = 0

local function build(v29, v30, v31, v32) -- line 106 | captures: ModelScaler, v1
    local Model = Instance.new("Model")
    Model.Name = ("VFXBurst_%*"):format(v29)
    local Part
    if v30:IsA("Attachment") then
        Part = Instance.new("Part")
        Part.Name = "Anchor"
        Part.Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224)
        Part.Transparency = 1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        v30:Clone().Parent = Part
        Part.Parent = Model
    elseif v30:IsA("BasePart") then
        Part = v30:Clone()
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Transparency = 1
        Part.Parent = Model
    elseif v30:IsA("Model") then
        for v33, v34 in v30:GetChildren() do
            v34:Clone().Parent = Model
        end
        Part = v30.PrimaryPart and Model:FindFirstChild(v30.PrimaryPart.Name)
        if not (Part and Part:IsA("BasePart")) then
            Part = Model:FindFirstChildWhichIsA("BasePart", true)
        end
        if Part then
            for v35, v36 in Model:GetDescendants() do
                if v36:IsA("BasePart") then
                    v36.Anchored = true
                    v36.CanCollide = false
                    v36.CanQuery = false
                    v36.CanTouch = false
                    v36.CastShadow = false
                end
            end
        else
            Model:Destroy()
            return nil
        end
    else
        Model:Destroy()
        return nil
    end
    Model.PrimaryPart = Part
    Model:SetPrimaryPartCFrame(CFrame.new(Part.Position))
    if v31 ~= 1 then
        ModelScaler.ScaleBy(Model, v31)
    end
    if v32 then
        v1.Tint(Model, v32)
    end
    local v37 = 0.6
    for v38, v39 in Model:GetDescendants() do
        if v39:IsA("ParticleEmitter") then
            v39.Enabled = false
            local Max = v39.Lifetime.Max
            local TimeScale = v39.TimeScale
            local v40 = Max / math.max(TimeScale, 0.05)
            v37 = math.max(v37, v40)
        end
    end
    return {
        Source = v30,
        Host = Model,
        Longest = v37
    }
end

local function getPrepared(v41, v42, v43, v44) -- line 164 | captures: v28, v27, build
    local v45
    if v44 then
        v45 = v44:ToHex()
    else
        v45 = ""
    end
    local v46 = ("%*|%*|%*"):format(v41, v43, v45)
    local v47 = v27[v46]
    if v47 and v47.Source == v42 then
        return v47
    end
    if v47 then
        v47.Host:Destroy()
        v27[v46] = nil
        v28 -= 1
    end
    if v28 >= 32 then
        for v48, v49 in v27 do
            v49.Host:Destroy()
        end
        table.clear(v27)
        v28 = 0
    end
    local v50 = build(v41, v42, v43, v44)
    if v50 then
        v27[v46] = v50
        v28 += 1
    end
    return v50
end

function v1.Play(v51, v52, v53, v54) -- line 194 | captures: ReplicatedStorage, Workspace, playShockwave, getPrepared
    local function v55(...)
        return (tonumber(...))
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local v56 = VFX and VFX:FindFirstChild(v51)
    if v56 then
        local v57 = v53 or 1
        local v58 = math.max(v57, 0.01)
        local v59 = getPrepared(v51, v56, v58, v54)
        if v59 then
            local v60 = v59.Host:Clone()
            v60:SetPrimaryPartCFrame(v52)
            v60.Parent = Workspace
            for v61, v62 in v60:GetDescendants() do
                if v62:IsA("ParticleEmitter") then
                    local v63 = v55(v62:GetAttribute("EmitCount"))
                    if not v63 then
                        local Rate = v62.Rate
                        v63 = math.floor(Rate)
                    end
                    v62:Emit((math.max(v63, 1)))
                elseif v62:IsA("Model") then
                    local Start = v62:FindFirstChild("Start")
                    local End = v62:FindFirstChild("End")
                    if Start and End and Start:IsA("BasePart") and End:IsA("BasePart") then
                        playShockwave(Start, End)
                    end
                end
            end
            task.delay(v59.Longest + 0.5, function() -- line 224 | captures: v60
                v60:Destroy()
            end)
        end
    else
        warn((("[VFXBurst] ReplicatedStorage.VFX.%* missing"):format(v51)))
    end
end

return v1
