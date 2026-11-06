-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}
local v2 = {
    ParticleEmitter = {
        { "Size", "sequence" },
        { "Speed", "range" },
        { "Acceleration", "vector" },
        { "Drag", "number" },
        { "ZOffset", "number" }
    },
    Beam = {
        { "Width0", "number" },
        { "Width1", "number" },
        { "CurveSize0", "number" },
        { "CurveSize1", "number" },
        { "TextureLength", "number" }
    },
    Trail = {
        { "TextureLength", "number" },
        { "MinLength", "number" }
    },
    PointLight = { { "Range", "number" } },
    SpotLight = { { "Range", "number" } },
    SurfaceLight = { { "Range", "number" } },
    Fire = { { "Size", "number" } },
    Smoke = {
        { "Size", "number" },
        { "RiseVelocity", "number" }
    }
}

local function scaleValue(v3, v4, v5) -- line 71
    local function v6(v7, ...)
        table.insert(v7, ...)
    end

    if v4 == "number" then
        return v3 * v5
    end
    if v4 == "vector" then
        return v3 * v5
    end
    if v4 == "range" then
        return NumberRange.new(v3.Min * v5, v3.Max * v5)
    end
    local v8 = {}
    for v9, v10 in v3.Keypoints do
        v6(v8, NumberSequenceKeypoint.new(v10.Time, v10.Value * v5, v10.Envelope * v5))
    end
    return NumberSequence.new(v8)
end

local function NewRig() -- line 88
    return {
        lastScale = 1,
        entries = {}
    }
end

v1.NewRig = NewRig

function v1.CaptureInstance(v11, v12) -- line 95 | captures: v2
    local v13 = v2[v12.ClassName]
    if v13 then
        local v14 = {}
        for v15, v16 in v13 do
            v14[v15] = v12[v16[1]]
        end
        local entries = v11.entries
        local v17 = {
            instance = v12,
            spec = v13,
            values = v14
        }
        table.insert(entries, v17)
        return true
    end
    return false
end

function v1.Capture(v18) -- line 110 | captures: v1
    local v19 = v1.NewRig()
    v1.CaptureInstance(v19, v18)
    for v20, v21 in v18:GetDescendants() do
        v1.CaptureInstance(v19, v21)
    end
    return v19
end

function v1.Apply(v22, v23, v24) -- line 120 | captures: scaleValue
    if v23 ~= v22.lastScale then
        local v25
        if not v24 then
            local v26 = v23 - v22.lastScale
            v25 = math.abs(v26) < v22.lastScale * 0.01
        end
        if v24 or not v25 then
            v22.lastScale = v23
            for v27, v28 in v22.entries do
                local instance = v28.instance
                if instance.Parent then
                    for v29, v30 in v28.spec do
                        instance[v30[1]] = scaleValue(v28.values[v29], v30[2], v23)
                    end
                end
            end
        end
    end
end

function v1.ScaleParticle(v31, v32) -- line 153 | captures: v2, scaleValue
    for v33, v34 in v2.ParticleEmitter do
        v31[v34[1]] = scaleValue(v31[v34[1]], v34[2], v32)
    end
end

function v1.ScaleBy(v35, v36) -- line 161 | captures: v1
    if v36 ~= 1 then
        v1.Apply(v1.Capture(v35), v36)
    end
end

return v1
