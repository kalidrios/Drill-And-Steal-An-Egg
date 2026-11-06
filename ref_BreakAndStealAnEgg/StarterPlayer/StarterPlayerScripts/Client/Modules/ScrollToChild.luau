-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local TweenService = game:GetService("TweenService")
local v1 = {}
local v2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = {}
local v4 = {}

function v1.Cancel(v5) -- line 36 | captures: v3, v4
    local v6 = v3[v5]
    if v6 == nil then
        return
    end
    v6:Cancel()
    v3[v5] = nil
    v4[v5] = nil
end

local function IsInView(v7, v8) -- line 47
    local AbsolutePosition = v7.AbsolutePosition
    local v9 = AbsolutePosition + v7.AbsoluteWindowSize
    local AbsolutePosition_2 = v8.AbsolutePosition
    local v10 = AbsolutePosition_2 + v8.AbsoluteSize
    local X = AbsolutePosition_2.X
    if AbsolutePosition.X - 1 <= X then
        local Y = AbsolutePosition_2.Y
        if AbsolutePosition.Y - 1 <= Y and v10.X <= v9.X + 1 then
            return v10.Y <= v9.Y + 1
        end
    end
    return false
end

v1.IsInView = IsInView

local function canvasOffsetOf(v11, v12) -- line 60
    return v12.AbsolutePosition - v11.AbsolutePosition + v11.CanvasPosition
end

local function glideTo(v13, v14, v15) -- line 66 | captures: TweenService, v2, v3, v4
    local v16 = TweenService:Create(v13, v15 or v2, { CanvasPosition = v14 })
    v3[v13] = v16
    v4[v13] = v14
    v16.Completed:Once(function() -- line 72 | captures: v13, v16, v3, v4
        if v3[v13] == v16 then
            v3[v13] = nil
            v4[v13] = nil
        end
    end)
    v16:Play()
end

function v1.Tween(v17, v18, v19) -- line 83 | captures: v1, glideTo
    v1.Cancel(v17)
    local v20 = v18.AbsolutePosition - v17.AbsolutePosition + v17.CanvasPosition + v18.AbsoluteSize / 2 - v17.AbsoluteWindowSize / 2
    local v21 = v17.AbsoluteCanvasSize - v17.AbsoluteWindowSize
    local new = Vector2.new
    local X = v20.X
    local X_2 = v21.X
    local v22 = math.max(X_2, 0)
    local v23 = math.clamp(X, 0, v22)
    local Y = v20.Y
    local Y_2 = v21.Y
    local v24 = math.max(Y_2, 0)
    glideTo(v17, new(v23, (math.clamp(Y, 0, v24))), v19)
end

local function inheritedScale(v25) -- line 97
    local v26 = 1
    local v27 = v25
    while v27 do
        if v27:IsA("LayerCollector") then
            break
        end
        for v28, v29 in v27:GetChildren() do
            if v29:IsA("UIScale") and v29.Scale > 0 then
                v26 *= v29.Scale
            end
        end
        v27 = v27.Parent
    end
    return v26
end

local function sectionTargetY(v30, v31, v32) -- line 116 | captures: inheritedScale
    local v33 = inheritedScale(v30)

    local function canvasY(v34) -- line 118 | captures: v30, v33
        return (v34 - v30.AbsolutePosition.Y) / v33 + v30.CanvasPosition.Y
    end

    local v35 = (v31.AbsolutePosition.Y - v30.AbsolutePosition.Y) / v33 + v30.CanvasPosition.Y
    local v36 = (v31.AbsolutePosition.Y + v31.AbsoluteSize.Y - v30.AbsolutePosition.Y) / v33 + v30.CanvasPosition.Y
    for v37, v38 in v32 do
        local v39 = (v38.AbsolutePosition.Y + v38.AbsoluteSize.Y - v30.AbsolutePosition.Y) / v33 + v30.CanvasPosition.Y
        v36 = math.max(v36, v39)
    end
    local v40 = v36 - v30.AbsoluteWindowSize.Y / v33
    local v41 = math.max(v35, v40)
    local v42 = (v30.AbsoluteCanvasSize.Y - v30.AbsoluteWindowSize.Y) / v33
    local v43 = math.max(v42, 0)
    return (math.clamp(v41, 0, v43))
end

function v1.JumpToSection(v44, v45, v46) -- line 135 | captures: v1, sectionTargetY
    v1.Cancel(v44)
    v44.CanvasPosition = Vector2.new(v44.CanvasPosition.X, (sectionTargetY(v44, v45, v46)))
end

function v1.TweenToSection(v47, v48, v49, v50) -- line 144 | captures: v1, v4, glideTo, sectionTargetY
    local v51 = sectionTargetY(v47, v48, v49)
    local v52 = (v4[v47] or v47.CanvasPosition).Y - v51
    if not (math.abs(v52) < 1) then
        v1.Cancel(v47)
        glideTo(v47, Vector2.new(v47.CanvasPosition.X, v51), v50)
    end
end

return v1
