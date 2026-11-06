-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = { Rotation = -90 }
local v2 = NumberSequence.new(0)
local v3 = {
    {
        Time = 0,
        Sat = 0.5,
        Val = 1.35,
        White = 0.5
    },
    {
        Time = 0.4,
        Sat = 0.92,
        Val = 1.18,
        White = 0.1
    },
    {
        Time = 0.74,
        Sat = 1,
        Val = 1,
        White = 0
    },
    {
        Time = 1,
        Sat = 1.12,
        Val = 0.6,
        White = 0
    }
}

v1.StrokeSaturationScale = 1.15
v1.StrokeBrightness = 0.3

local v4 = Color3.new(1, 1, 1)

local function shade(v5, v6) -- line 78 | captures: v4
    local v7, v8, v9 = v5:ToHSV()
    local fromHSV = Color3.fromHSV
    local v10 = v8 * v6.Sat
    local v11 = math.clamp(v10, 0, 1)
    local v12 = v9 * v6.Val
    local v13 = fromHSV(v7, v11, (math.clamp(v12, 0, 1)))
    if v6.White > 0 then
        v13 = v13:Lerp(v4, v6.White)
    end
    return v13
end

local function tintSequence(v14, v15) -- line 89
    local function v16(v17, ...)
        table.insert(v17, ...)
    end

    if not v15 or v15.Alpha <= 0 then
        return v14
    end
    local v18 = {}
    for v19, v20 in v14.Keypoints do
        v16(v18, ColorSequenceKeypoint.new(v20.Time, v20.Value:Lerp(v15.Target, v15.Alpha)))
    end
    return ColorSequence.new(v18)
end

function v1.Sequence(v21, v22) -- line 102 | captures: v3, v4, tintSequence
    local function v23(v24, ...)
        table.insert(v24, ...)
    end

    local v25 = {}
    for v26, v27 in v3 do
        local new = ColorSequenceKeypoint.new
        local Time = v27.Time
        local v28, v29, v30 = v21:ToHSV()
        local fromHSV = Color3.fromHSV
        local v31 = v29 * v27.Sat
        local v32 = math.clamp(v31, 0, 1)
        local v33 = v30 * v27.Val
        local v34 = fromHSV(v28, v32, (math.clamp(v33, 0, 1)))
        if v27.White > 0 then
            v34 = v34:Lerp(v4, v27.White)
        end
        v23(v25, new(Time, v34))
    end
    return tintSequence(ColorSequence.new(v25), v22)
end

function v1.Attach(v35, v36, v37) -- line 113 | captures: v1, v2
    v35.Enabled = true
    v35.Offset = Vector2.zero
    v35.Transparency = v2
    v35.Rotation = v1.Rotation
    v35.Color = v1.Sequence(v36, v37)
end

local function ResolveLabelGradient(v38, v39) -- line 128
    local UIGradient
    for v40, v41 in v38:GetChildren() do
        if v41:IsA("UIGradient") then
            if UIGradient then
                if v41.Name == v39 then
                    UIGradient:Destroy()
                    UIGradient = v41
                else
                    v41:Destroy()
                end
            else
                UIGradient = v41
            end
        end
    end
    if not UIGradient then
        UIGradient = Instance.new("UIGradient")
        UIGradient.Parent = v38
    end
    UIGradient.Name = v39
    return UIGradient
end

v1.ResolveLabelGradient = ResolveLabelGradient
v1.LabelGradientName = "PrettyGradient"
v1.StrokeShieldName = "StrokeShield"

local v42 = ColorSequence.new(v4)

function v1.StrokeColor(v43, v44) -- line 162 | captures: v1, v4
    local v45 = {
        Time = 1,
        White = 0,
        Sat = v1.StrokeSaturationScale,
        Val = v1.StrokeBrightness
    }
    local v46, v47, v48 = v43:ToHSV()
    local fromHSV = Color3.fromHSV
    local v49 = v47 * v45.Sat
    local v50 = math.clamp(v49, 0, 1)
    local v51 = v48 * v45.Val
    local v52 = fromHSV(v46, v50, (math.clamp(v51, 0, 1)))
    if v45.White > 0 then
        v52 = v52:Lerp(v4, v45.White)
    end
    if v44 and v44.Alpha > 0 then
        v52 = v52:Lerp(v44.Target, v44.Alpha)
    end
    return v52
end

function v1.PaintStrokes(v53, v54, v55) -- line 191 | captures: v1, v42
    local v56 = v1.StrokeColor(v54, v55)
    for v57, v58 in v53:GetChildren() do
        if v58:IsA("UIStroke") then
            v58.Color = v56
            local v59 = v58:FindFirstChild(v1.StrokeShieldName)
            if not (v59 and v59:IsA("UIGradient")) then
                v59 = Instance.new("UIGradient")
                v59.Name = v1.StrokeShieldName
                v59.Parent = v58
            end
            v59.Color = v42
            v59.Rotation = 0
            v59.Enabled = true
        end
    end
end

function v1.ApplyToLabel(v60, v61, v62) -- line 213 | captures: v1, v4
    local v63 = v1.ResolveLabelGradient(v60, v1.LabelGradientName)
    v60.TextColor3 = v4
    v1.PaintStrokes(v60, v61, v62)
    v1.Attach(v63, v61, v62)
    return v63
end

return v1
