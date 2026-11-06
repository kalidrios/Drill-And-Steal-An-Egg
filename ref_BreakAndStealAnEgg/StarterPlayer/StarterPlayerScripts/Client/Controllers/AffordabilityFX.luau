-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StrokeColors = require(ReplicatedStorage.Shared.StrokeColors)
local PurchaseButtonStyles = require(ReplicatedStorage.Shared.PurchaseButtonStyles)
local v1 = {}
local v2 = {
    {
        Time = 0,
        SaturationScale = 0.78,
        Brightness = 1
    },
    {
        Time = 0.5,
        SaturationScale = 1,
        Brightness = 0.93
    },
    {
        Time = 1,
        SaturationScale = 1,
        Brightness = 0.62
    }
}

local function isNeutral(v3) -- line 91
    local v4, v5, v6 = Color3.toHSV(v3)
    if v5 < 0.15 then
        return true
    end
    return v6 <= 0.15
end

local LocalPlayer = Players.LocalPlayer
local v7 = {}
local v8 = {}

local function rampSequence(v9, v10) -- line 138 | captures: v2
    local function v11(v12, ...)
        table.insert(v12, ...)
    end

    local v13 = {}
    for v14, v15 in v2 do
        local v16 = Color3.fromHSV(v9, v10 * v15.SaturationScale, v15.Brightness)
        v11(v13, ColorSequenceKeypoint.new(v15.Time, v16))
    end
    return ColorSequence.new(v13)
end

local function yellowStrokeColor(v17, v18, v19) -- line 148 | captures: StrokeColors
    if v17.Name == "Inner" then
        return StrokeColors.InnerFromSequence(v19)
    end
    local v20, v21, v22 = Color3.toHSV(v18)
    if v21 < 0.15 or v22 <= 0.15 then
        return v18
    end
    return Color3.fromHSV(0.13, 0.9450000000000001, 0.5)
end

local v23 = { CPS = true }

local function isExcludedGradient(v24, v25) -- line 167 | captures: v23
    local v26 = v24
    while true do
        if v26 == nil then
            return false
        end
        if v26 == v25 then
            return false
        end
        if v23[v26.Name] then
            break
        end
        v26 = v26.Parent
    end
    return true
end

local function resolveGradient(v27) -- line 178
    local UiGradient = v27:FindFirstChild("UiGradient")
    if not (UiGradient and UiGradient:IsA("UIGradient")) then
        return v27:FindFirstChildWhichIsA("UIGradient")
    end
    return UiGradient
end

local function resolveStrokes(v28, v29, v30) -- line 188 | captures: StrokeColors, PurchaseButtonStyles
    local v31 = {}
    for v32, v33 in v28:GetChildren() do
        if v33:IsA("UIStroke") then
            local v34 = PurchaseButtonStyles.SnapshotStroke(v33)
            if v29 then
                for v35, v36 in v29.Strokes do
                    if v36.Stroke == v33 then
                        v34 = v36.Authored
                        break
                    end
                end
            end
            local v37 = {
                Stroke = v33,
                Authored = v34
            }
            local Color = v34.Color
            if v33.Name == "Inner" then
                Color = StrokeColors.InnerFromSequence(v30)
            else
                local v38, v39, v40 = Color3.toHSV(Color)
                if not (v39 < 0.15 or v40 <= 0.15) then
                    Color = Color3.fromHSV(0.13, 0.9450000000000001, 0.5)
                end
            end
            v37.Yellow = Color
            table.insert(v31, v37)
        end
    end
    return v31
end

local function resolveLabelStrokes(v41, v42) -- line 217
    local v43 = {}
    for v44, v45 in v41:GetDescendants() do
        if v45:IsA("UIStroke") then
            local Parent = v45.Parent
            if Parent ~= nil and Parent ~= v41 and (Parent:IsA("TextLabel") or Parent:IsA("TextButton")) then
                local Color = v45.Color
                if v42 then
                    for v46, v47 in v42.LabelStrokes do
                        if v47.Stroke == v45 then
                            Color = v47.Authored
                            break
                        end
                    end
                end
                local v48 = {
                    Stroke = v45,
                    Label = Parent,
                    Authored = Color
                }
                table.insert(v43, v48)
            end
        end
    end
    return v43
end

local function resolveExtraGradients(v49, v50, v51) -- line 253 | captures: v23
    local v52 = {}
    for v53, v54 in v49:GetDescendants() do
        if v54:IsA("UIGradient") and v54 ~= v50 then
            local v55 = v54
            local v56
            while true do
                if v55 == nil then
                    v56 = false
                    break
                end
                if v55 == v49 then
                    v56 = false
                    break
                end
                if v23[v55.Name] then
                    v56 = true
                    break
                end
                v55 = v55.Parent
            end
            if not v56 then
                local Color = v54.Color
                if v51 then
                    for v57, v58 in v51.ExtraGradients do
                        if v58.Gradient == v54 then
                            Color = v58.Authored
                            break
                        end
                    end
                end
                local v59 = {
                    Gradient = v54,
                    Authored = Color
                }
                table.insert(v52, v59)
            end
        end
    end
    return v52
end

local function paintLabelStrokes(v60) -- line 295 | captures: StrokeColors
    for v61, v62 in v60.LabelStrokes do
        local TextColor3 = v62.Label.TextColor3
        local v63, v64, v65 = Color3.toHSV(TextColor3)
        local v66
        if v64 < 0.15 or v65 <= 0.15 then
            local Authored = v62.Authored
            local v67, v68, v69 = Color3.toHSV(Authored)
            if v68 < 0.15 or v69 <= 0.15 then
                v66 = v62.Authored
            else
                v66 = StrokeColors.Outer(TextColor3)
            end
        else
            v66 = StrokeColors.Outer(TextColor3)
        end
        if v62.Stroke.Color ~= v66 then
            v62.Stroke.Color = v66
        end
    end
end

local function cash(v70) -- line 307 | captures: LocalPlayer
    local v71 = LocalPlayer:GetAttribute(v70)
    if typeof(v71) == "number" then
        return v71
    end
    return 0
end

local function applyTemplate(v72, v73) -- line 314 | captures: PurchaseButtonStyles
    local v74 = PurchaseButtonStyles.Get(v73)
    PurchaseButtonStyles.ApplyGradient(v72.Gradient, v74 and v74.Gradient or v72.Authored)
    for v75, v76 in v72.Strokes do
        local v77 = v74 and v74.Strokes[v76.Stroke.Name]
        PurchaseButtonStyles.ApplyStroke(v76.Stroke, v77 or v76.Authored)
    end
    v74 = v74 and v74.Gradient and v74.Gradient.Color
    for v78, v79 in v72.ExtraGradients do
        v79.Gradient.Color = v74 or v79.Authored
    end
end

local function applyMaxed(v80) -- line 333 | captures: PurchaseButtonStyles
    PurchaseButtonStyles.ApplyGradient(v80.Gradient, {
        Rotation = 90,
        Color = v80.Yellow,
        Transparency = v80.Authored.Transparency,
        Offset = v80.Authored.Offset
    })
    for v81, v82 in v80.Strokes do
        PurchaseButtonStyles.ApplyStroke(v82.Stroke, {
            Color = v82.Yellow,
            Transparency = v82.Authored.Transparency
        })
    end
    for v83, v84 in v80.ExtraGradients do
        v84.Gradient.Color = v80.Yellow
    end
end

local function paint(v85, v86) -- line 354 | captures: PurchaseButtonStyles, paintLabelStrokes, applyTemplate, applyMaxed
    paintLabelStrokes(v85)
    local v87 = v85.CostOf()
    local v88
    if v87 == nil then
        v88 = "Maxed"
    elseif v87 <= v86 then
        v88 = "Affordable"
    else
        v88 = "TooPoor"
    end
    if v88 ~= v85.State then
        v85.State = v88
        if v88 == "Affordable" then
            applyTemplate(v85, PurchaseButtonStyles.Affordable)
        elseif v88 == "TooPoor" then
            applyTemplate(v85, PurchaseButtonStyles.NoneAffordable)
        else
            applyMaxed(v85)
        end
    end
end

function v1.Refresh() -- line 385 | captures: LocalPlayer, v7, paint
    for v89, v90 in v7 do
        if v90.Gradient.Parent == nil then
            v7[v89] = nil
        else
            local Currency = v90.Currency
            local v91 = LocalPlayer:GetAttribute(Currency)
            if typeof(v91) ~= "number" then
                v91 = 0
            end
            paint(v90, v91)
        end
    end
end

function v1.Bind(v92, v93, v94) -- line 399 | captures: PurchaseButtonStyles, v1, LocalPlayer, v7, v8, rampSequence, resolveStrokes, resolveLabelStrokes, resolveExtraGradients, paint
    local v95 = v94 or "Cash"
    local UiGradient = v92:FindFirstChild("UiGradient")
    if not (UiGradient and UiGradient:IsA("UIGradient")) then
        UiGradient = v92:FindFirstChildWhichIsA("UIGradient")
    end
    if not UiGradient then
        return
    end
    local v96 = v7[v92]
    local v97 = if v96 == nil then false else v96.Gradient == UiGradient
    local v98
    if not v97 or not v96 then
        v98 = PurchaseButtonStyles.SnapshotGradient(UiGradient)
    else
        v98 = v96.Authored
    end
    local v99 = rampSequence(0.13, 0.9)
    local v100 = {
        State = nil,
        Gradient = UiGradient,
        Authored = v98,
        Yellow = v99,
        Strokes = resolveStrokes(v92, v96, v99),
        LabelStrokes = resolveLabelStrokes(v92, v96),
        ExtraGradients = resolveExtraGradients(v92, UiGradient, v96),
        CostOf = v93,
        Currency = v95
    }
    v7[v92] = v100
    if not v8[v95] then
        v8[v95] = true
        LocalPlayer:GetAttributeChangedSignal(v95):Connect(v1.Refresh)
    end
    local v101 = LocalPlayer:GetAttribute(v95)
    if typeof(v101) ~= "number" then
        v101 = 0
    end
    paint(v100, v101)
end

return v1
