-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VFXScaler = require(ReplicatedStorage.Shared.VFXScaler)
local v1 = { FolderName = "HatchVFX" }
local v2

local function getFolders() -- line 36 | captures: v2, ReplicatedStorage, Workspace, v1
    local v3 = v2
    if v3 then
        local v4 = #v3 > 0
        for v5, v6 in v3 do
            if not v6.Parent then
                v4 = false
                break
            end
        end
        if v4 then
            return v3
        end
    end
    local v7 = {}
    for v8, v9 in { Workspace, ReplicatedStorage } do
        local v10 = v9:FindFirstChild(v1.FolderName)
        if v10 then
            table.insert(v7, v10)
        end
    end
    v2 = v7
    return v7
end

local v11 = { Explode = { "VFX", "EggHatchVFX" } }

local function findOverride(v12) -- line 68 | captures: ReplicatedStorage, v11
    local v13 = v11[v12]
    if v13 then
        local v14 = ReplicatedStorage
        for v15, v16 in v13 do
            v14 = v14 and v14:FindFirstChild(v16)
        end
        return v14
    end
    return nil
end

local v17 = {}

local function getTemplate(v18) -- line 82 | captures: ReplicatedStorage, getFolders, v11, v17
    local v19 = v11[v18]
    local v20
    if v19 then
        v20 = ReplicatedStorage
        for v21, v22 in v19 do
            v20 = v20 and v20:FindFirstChild(v22)
        end
    end
    if v20 then
        return v20
    end
    for v23, v24 in getFolders() do
        local v25 = v24:FindFirstChild(v18)
        if v25 and v25:IsA("BasePart") then
            return v25
        end
    end
    if not v17[v18] then
        v17[v18] = true
        warn(("[HatchVFX] Missing HatchVFX.%* (checked Workspace + ReplicatedStorage \226\128\148 "):format(v18) .. "authored sets live in ServerStorage.HatchVFX, replicated by HatchVFXService)")
    end
    return nil
end

local ScaleParticle = VFXScaler.ScaleParticle

v1.ScaleParticle = ScaleParticle

local function createHost(v26) -- line 117 | captures: Workspace
    local Part = Instance.new("Part")
    Part.Name = "host"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.CastShadow = false
    Part.Size = Vector3.new(0, 0, 0)
    Part.CFrame = CFrame.new(v26)
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    Part.Parent = Workspace
    return Part, Attachment
end

local function getTemplateEmitters(v27) -- line 138
    local v28 = {}
    for v29, v30 in v27:GetDescendants() do
        if v30:IsA("ParticleEmitter") then
            table.insert(v28, v30)
        end
    end
    return v28
end

function v1.Emit(v31, v32, v33) -- line 166 | captures: getTemplate, ScaleParticle, createHost, getTemplateEmitters
    local v34 = getTemplate(v31)
    if not v34 then
        return
    end
    local v35, v36
    if v33 then
        v36 = v33.Scale
        v35 = v33.LifetimeMult
    else
        v36 = v33
        v35 = v33
    end
    local v37, v38 = createHost(v32)
    local v39 = 0
    for v40, v41 in getTemplateEmitters(v34) do
        local v42 = v41:Clone()
        v42.Enabled = false
        if v35 and v35 ~= 1 then
            v42.Lifetime = NumberRange.new(v42.Lifetime.Min * v35, v42.Lifetime.Max * v35)
        end
        local TimeScale = v42.TimeScale
        local v43 = math.max(TimeScale, 0.05)
        local v44 = v42.Lifetime.Max / v43
        if v44 > 2.5 then
            local v45 = 2.5 / v44
            v42.Lifetime = NumberRange.new(v42.Lifetime.Min * v45, v42.Lifetime.Max * v45)
        end
        if v36 and v36 ~= 1 then
            ScaleParticle(v42, v36)
        end
        local v46 = v42:GetAttribute("EmitCount") or v42.Rate
        local v47 = math.max(v46, 1)
        if v36 then
            local v48 = v47 * v36
            local v49 = math.ceil(v48)
            v47 = math.min(v49, 500)
        end
        v42.Parent = v38
        v42:Emit(v47)
        local v50 = v42.Lifetime.Max / v43
        v39 = math.max(v39, v50)
    end
    task.delay(v39 + 0.5, function() -- line 215 | captures: v37
        v37:Destroy()
    end)
    return v37
end

function v1.EnableFor(v51, v52, v53) -- line 223 | captures: getTemplate, createHost, getTemplateEmitters
    local v54 = getTemplate(v51)
    if not v54 then
        return
    end
    local v55, v56 = createHost(v52)
    local v57 = 0
    local v58 = 0
    for v59, v60 in getTemplateEmitters(v54) do
        local v61 = v60:Clone()
        v61.Enabled = true
        v61.Parent = v56
        local Max = v61.Lifetime.Max
        local TimeScale = v61.TimeScale
        local v62 = Max / math.max(TimeScale, 0.05)
        local v63 = math.max(v58, v62)
        v57 = v63
        v58 = v63
    end
    task.delay(v53, function() -- line 239 | captures: v57, v55, v56
        for v64, v65 in v56:GetChildren() do
            if v65:IsA("ParticleEmitter") then
                v65.Enabled = false
            end
        end
        task.delay(v57 + 0.5, function() -- line 245 | captures: v55
            v55:Destroy()
        end)
    end)
    return v55
end

return v1
