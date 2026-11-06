-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local EggRewards = require(script.Parent.EggRewards)
local v1 = {
    AnimatedTag = "AnimatedRarityGradient",
    RarityAttribute = "Rarity"
}
local v2 = NumberSequence.new(0)
local v3 = {
    Mythic = 0.35,
    Secret = 0.5,
    Divine = 0.16,
    Celestial = 0.28,
    Cosmic = 0.4,
    Inferno = 0.55,
    Void = 0.22,
    Omega = 0.65
}
local v4 = { Secret = 60 }

local function frameCountFor(v5, v6) -- line 95 | captures: v4
    local v7 = v4[v5]
    if v7 then
        return v7
    end
    local v8 = 60 / math.max(v6, 0.001)
    local v9 = math.ceil(v8)
    return (math.clamp(v9, 60, 360))
end

local v10 = {}
local v11
local v12 = 0

local function tintSequence(v13, v14, v15) -- line 134
    local function v16(v17, ...)
        table.insert(v17, ...)
    end

    if v14 and v15 and not (v15 <= 0) then
        local v18 = {}
        for v19, v20 in v13.Keypoints do
            v16(v18, ColorSequenceKeypoint.new(v20.Time, v20.Value:Lerp(v14, v15)))
        end
        return ColorSequence.new(v18)
    end
    return v13
end

local function buildLoop(v21) -- line 149
    local Keypoints = v21.Keypoints
    local Value = Keypoints[1].Value
    local v22 = Value == Keypoints[#Keypoints].Value
    local v23 = if v22 then 1 else 0.8695652173913044
    local v24 = {}
    for v25, v26 in Keypoints do
        local v27 = {
            Time = v26.Time * v23,
            Value = v26.Value
        }
        table.insert(v24, v27)
    end
    if v22 then
        v24[#v24].Time = 1
    else
        local v28 = {
            Time = 1,
            Value = Value
        }
        table.insert(v24, v28)
    end
    return v24
end

local function byTime(v29, v30) -- line 169
    return v29.Time < v30.Time
end

local v31 = {}

local function evalLoop(v32, v33) -- line 177
    local v34 = #v32 - 1
    for v35 = 1, v34 do
        local v36 = v32[v35]
        local v37 = v32[v35 + 1]
        if v36.Time <= v33 and v33 <= v37.Time then
            local v38 = v37.Time - v36.Time
            local Value = v36.Value
            local Value_2 = v37.Value
            local v39 = if v38 > 0 then (v33 - v36.Time) / v38 else 0
            return Value:Lerp(Value_2, v39)
        end
    end
    return v32[#v32].Value
end

local function shiftedSequence(v40, v41, v42, v43) -- line 193 | captures: tintSequence, byTime, v31, evalLoop
    local function v44(v45, ...)
        table.insert(v45, ...)
    end

    local function v46(v47, ...)
        table.insert(v47, ...)
    end

    local v48 = evalLoop(v40, -v41 % 1)
    table.clear(v31)
    for v49, v50 in v40 do
        local v51 = (v50.Time + v41) % 1
        if v51 > 0.005 and v51 < 0.995 then
            local v52 = {
                Time = v51,
                Value = v50.Value
            }
            table.insert(v31, v52)
        end
    end
    table.sort(v31, byTime)
    local v53 = { ColorSequenceKeypoint.new(0, v48) }
    local Time = 0
    for v54, v55 in v31 do
        if not (v55.Time - Time < 0.005) then
            Time = v55.Time
            v44(v53, ColorSequenceKeypoint.new(v55.Time, v55.Value))
        end
    end
    v46(v53, ColorSequenceKeypoint.new(1, v48))
    return tintSequence(ColorSequence.new(v53), v42, v43)
end

local v56 = {}
local v57 = {}
local v58 = { __mode = "k" }
local v59 = setmetatable(v57, v58)

local function masterKey(v60) -- line 236 | captures: v59
    local v61 = v59[v60]
    if not v61 then
        v61 = tostring(v60)
        v59[v60] = v61
    end
    return v61
end

local function framesFor(v62, v63, v64) -- line 245 | captures: buildLoop, shiftedSequence, v56, v59
    local v65 = v59[v62]
    if not v65 then
        v65 = tostring(v62)
        v59[v62] = v65
    end
    local v66 = ("%*|%*"):format(v65, v64)
    if v63 then
        v66 ..= ("|%*|%*"):format(v63.Target, v63.Alpha)
    end
    local v67 = v56[v66]
    if v67 then
        return v67
    end
    local v68 = buildLoop(v62)
    local v69 = table.create(v64)
    for v70 = 1, v64 do
        local v71 = -((v70 - 1) / v64)
        local v72, v73
        if v63 then
            v73 = v63.Target
            v72 = v63.Alpha
        else
            v73 = v63
            v72 = v63
        end
        v69[v70] = shiftedSequence(v68, v71, v73, v72)
    end
    v56[v66] = v69
    return v69
end

local function visibilityOf(v74) -- line 273 | captures: Players
    if v74:IsDescendantOf(game) then
        local Parent = v74.Parent
        while true do
            if Parent then
                if Parent == game then
                    return true
                end
                if Parent:IsA("GuiObject") then
                    if Parent.Visible then
                        Parent = Parent.Parent
                        continue
                    end
                    break
                end
                if Parent:IsA("LayerCollector") then
                    if Parent.Enabled then
                        local LocalPlayer = Players.LocalPlayer
                        if LocalPlayer and Parent:IsA("BillboardGui") and Parent.PlayerToHideFrom == LocalPlayer then
                            return false
                        end
                    else
                        return false
                    end
                end
                Parent = Parent.Parent
                continue
            end
            return true
        end
        return false
    end
    return nil
end

local function paintActive() -- line 299 | captures: v10, visibilityOf
    local v75 = os.clock()
    for v76, v77 in v10 do
        if v77.NextVisCheck <= v75 then
            v77.NextVisCheck = v75 + 0.5
            local v78 = visibilityOf(v76)
            if v78 == nil then
                v10[v76] = nil
            else
                v77.Visible = v78
                if v77.Visible then
                    local v79 = v75 * v77.Speed % 1 * v77.FrameCount
                    local v80 = math.floor(v79) + 1
                    if v80 ~= v77.LastIndex then
                        v77.LastIndex = v80
                        v76.Color = v77.Frames[v80]
                    end
                end
            end
        elseif v77.Visible then
            local v81 = v75 * v77.Speed % 1 * v77.FrameCount
            local v82 = math.floor(v81) + 1
            if v82 ~= v77.LastIndex then
                v77.LastIndex = v82
                v76.Color = v77.Frames[v82]
            end
        end
    end
end

local function ensureHeartbeat() -- line 321 | captures: v11, v12, RunService, v10, paintActive
    v11 = v11 or
    RunService.Heartbeat:Connect(function(v83) -- line 325 | captures: v11, v12, v10, paintActive
        v12 += v83
        if v12 < 0.015 then
            return
        end
        v12 = 0
        paintActive()
        if next(v10) == nil and v11 then
            v11:Disconnect()
            v11 = nil
        end
    end)
end

function v1.IsAnimated(v84) -- line 342 | captures: EggRewards
    if v84 == nil then
        return false
    end
    return EggRewards.AnimatedRarityGradients[v84] == true
end

function v1.Detach(v85) -- line 347 | captures: v10
    v10[v85] = nil
end

function v1.Attach(v86, v87, v88, v89) -- line 360 | captures: v11, v12, CollectionService, RunService, EggRewards, v1, v3, v4, v10, tintSequence, framesFor, paintActive
    v1.Detach(v86)
    local Master = v89 and v89.Master or v87 and EggRewards.RarityGradients[v87]
    local Rotation
    if Master and v87 then
        Rotation = v89 and v89.Rotation or EggRewards.RarityGradientRotations[v87]
    else
        return false
    end
    if Rotation then
        v86.Rotation = Rotation
    end
    local v90, v91
    if v88 then
        v91 = v88.Target
        v90 = v88.Alpha
    else
        v91 = v88
        v90 = v88
    end
    v86.Color = tintSequence(Master, v91, v90)
    v86:SetAttribute(v1.RarityAttribute, v87)
    if v1.IsAnimated(v87) then
        if RunService:IsServer() then
            CollectionService:AddTag(v86, v1.AnimatedTag)
        else
            local v92 = v3[v87] or 0.4
            local v93 = v4[v87]
            if not v93 then
                local v94 = 60 / math.max(v92, 0.001)
                local v95 = math.ceil(v94)
                v93 = math.clamp(v95, 60, 360)
            end
            v10[v86] = {
                Visible = true,
                LastIndex = 0,
                Frames = framesFor(Master, v88, v93),
                FrameCount = v93,
                Speed = v92,
                NextVisCheck = os.clock() + math.random() * 0.5
            }
            v11 = v11 or
            RunService.Heartbeat:Connect(function(v96) -- line 325 | captures: v11, v12, v10, paintActive
                v12 += v96
                if v12 < 0.015 then
                    return
                end
                v12 = 0
                paintActive()
                if next(v10) == nil and v11 then
                    v11:Disconnect()
                    v11 = nil
                end
            end)
        end
    else
        CollectionService:RemoveTag(v86, v1.AnimatedTag)
    end
    return true
end

local function resolveLabelGradient(v97) -- line 417 | captures: v1, v2
    local UIGradient
    for v98, v99 in v97:GetChildren() do
        if v99:IsA("UIGradient") then
            if UIGradient then
                if v99.Name == "RarityGradient" then
                    v1.Detach(UIGradient)
                    UIGradient:Destroy()
                    UIGradient = v99
                else
                    v1.Detach(v99)
                    v99:Destroy()
                end
            else
                UIGradient = v99
            end
        end
    end
    if not UIGradient then
        UIGradient = Instance.new("UIGradient")
        UIGradient.Parent = v97
    end
    UIGradient.Name = "RarityGradient"
    UIGradient.Enabled = true
    UIGradient.Offset = Vector2.zero
    UIGradient.Transparency = v2
    return UIGradient
end

function v1.ApplyToLabel(v100, v101) -- line 452 | captures: EggRewards, v1, resolveLabelGradient
    if not (v101 and EggRewards.RarityGradients[v101]) then
        return nil
    end
    local v102 = resolveLabelGradient(v100)
    v100.TextColor3 = Color3.new(1, 1, 1)
    v1.Attach(v102, v101)
    return v102
end

return v1
