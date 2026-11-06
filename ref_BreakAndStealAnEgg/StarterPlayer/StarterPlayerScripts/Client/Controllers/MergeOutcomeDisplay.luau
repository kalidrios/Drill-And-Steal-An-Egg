-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local AnimalRenders = require(ReplicatedStorage.Shared.AnimalRenders)
local v1 = {}
local v2 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3, v4, v5, v6
local v7 = UDim2.fromScale(1, 1)
local v8, v9
local v10 = 0
local v11 = -1
local v12 = 0
local v13 = 0
local v14 = 0
local v15, v16

local function smoothstep(v17) -- line 80
    local v18 = math.clamp(v17, 0, 1)
    return v18 * v18 * (3 - v18 * 2)
end

local function maskFor(v19, v20) -- line 89
    local function v21(v22, ...)
        table.insert(v22, ...)
    end

    local v23 = v19 * 1.1400000000000001 + -0.07 + v20
    local v24 = v23 - 0.07
    local v25 = v23 + 0.07

    local function transparencyAt(v26) -- line 93 | captures: v24, v25
        local v27 = (v26 - v24) / (v25 - v24)
        local v28 = math.clamp(v27, 0, 1)
        return v28 * v28 * (3 - v28 * 2)
    end

    local v29 = { 0, 1 }
    for v30 = 0, 4 do
        local v31 = v24 + (v25 - v24) * v30 / 4
        if v31 > 0 and v31 < 1 then
            table.insert(v29, v31)
        end
    end
    table.sort(v29)
    local v32 = {}
    local v33 = -1
    for v34, v35 in v29 do
        if v35 - v33 > 0.001 or v35 == 1 then
            if v35 == 1 and v33 > 0.999 then
                v32[#v32] = nil
            end
            local new = NumberSequenceKeypoint.new
            local v36 = (v35 - v24) / (v25 - v24)
            local v37 = math.clamp(v36, 0, 1)
            v21(v32, new(v35, v37 * v37 * (3 - v37 * 2)))
            v33 = v35
        end
    end
    return NumberSequence.new(v32)
end

local function draw(v38) -- line 120 | captures: v5, v10, v11, maskFor
    local v39 = v5
    if v39 and v39.Parent then
        v39.Transparency = maskFor(v10, v38 or 0)
        v11 = v10
    end
end

local function stopHeartbeat() -- line 133 | captures: v16
    if v16 then
        v16:Disconnect()
        v16 = nil
    end
end

local function isPartFilled() -- line 140 | captures: v10
    if v10 > 0.001 then
        return v10 < 0.999
    end
    return false
end

local function step() -- line 144 | captures: v5, v6, v9, v10, v11, v12, v13, v14, v15, v16, TweenService, maskFor
    local v40 = v5
    local v41, v42
    if v40 and v40.Parent then
        if v9 == nil then
            v42 = true
        else
            v41 = os.clock()
            local v43 = v15
            if v43 then
                local v44
                if v43.Time <= 0 then
                    v44 = 1
                else
                    local v45 = (v41 - v14) / v43.Time
                    v44 = math.clamp(v45, 0, 1)
                end
                v10 = v12 + (v13 - v12) * TweenService:GetValue(v44, v43.EasingStyle, v43.EasingDirection)
                if v44 >= 1 then
                    v15 = nil
                    v10 = v13
                end
            end
            v42 = false
        end
    else
        v42 = true
    end
    if not v42 then
        if v10 > 0.001 and v10 < 0.999 then
            local v46 = v6
            if not v46 or v46.Visible then
                local v47 = v41 * 2.1
                v40.Rotation = math.sin(v47) * 6 + -90
                local v48 = v41 * 3.3
                local v49 = math.sin(v48) * 0.012
                local v50 = v5
                if v50 and v50.Parent then
                    v50.Transparency = maskFor(v10, v49 or 0)
                    v11 = v10
                end
            end
        else
            v40.Rotation = -90
            if v10 ~= v11 then
                local v51 = v5
                if v51 and v51.Parent then
                    v51.Transparency = maskFor(v10, 0)
                    v11 = v10
                end
            end
            if v15 == nil and v16 then
                v16:Disconnect()
                v16 = nil
            end
        end
    elseif v16 then
        v16:Disconnect()
        v16 = nil
    end
end

local function ensureHeartbeat() -- line 182 | captures: v5, v9, v16, RunService, step
    if v16 == nil and v5 ~= nil and v9 ~= nil then
        v16 = RunService.Heartbeat:Connect(step)
    end
end

local function punch(v52) -- line 188 | captures: v3, v7, v8, TweenService, v2
    local v53 = v3
    if v53 and v53.Parent and v53.Visible then
        if v8 then
            v8:Cancel()
        end
    else
        return
    end
    v53.Size = UDim2.new(v7.X.Scale * v52, v7.X.Offset * v52, v7.Y.Scale * v52, v7.Y.Offset * v52)
    local v54 = TweenService:Create(v53, v2, { Size = v7 })
    v8 = v54
    v54:Play()
end

function v1.Adopt(v55) -- line 212 | captures: v3, v4, v5, v6, v7, v8, v9, v10, v11, v15, v16, maskFor
    if v16 then
        v16:Disconnect()
        v16 = nil
    end
    if v8 then
        v8:Cancel()
        v8 = nil
    end
    v3 = nil
    v4 = nil
    v5 = nil
    v6 = nil
    v9 = nil
    v10 = 0
    v11 = -1
    v15 = nil
    local v56 = v55 and (v55:FindFirstChild("BlackAnimalDisplay") or v55:FindFirstChild("AnimalDisplay"))
    local v57 = v56 and v56:FindFirstChild("AnimalDisplay")
    local v58 = v57 and v57:FindFirstChildOfClass("UIGradient")
    local v59
    if v56 and v56:IsA("ImageLabel") and v57 and v57:IsA("ImageLabel") and v58 then
        v3 = v56
        v4 = v57
        v5 = v58
        v59 = v55 and v55:FindFirstAncestor("MergeMachine")
    else
        return
    end
    if not (v59 and v59:IsA("GuiObject")) then
        v59 = nil
    end
    v6 = v59
    v7 = v56.Size
    v58.Rotation = -90
    v56.Visible = false
    local v60 = v5
    if not v60 then
        return
    end
    if not v60.Parent then
        return
    end
    v60.Transparency = maskFor(v10, 0)
    v11 = v10
end

function v1.SetAnimal(v61) -- line 242 | captures: v3, v4, v5, v9, v10, v11, v16, RunService, AnimalRenders, maskFor, step
    local v62 = v3
    local v63 = v4
    if not (not v62 or not v63) and v61 ~= v9 then
        v9 = v61
        if v61 == nil then
            if v16 then
                v16:Disconnect()
                v16 = nil
            end
            v62.Visible = false
        else
            local v64 = AnimalRenders.GetEggImage(v61)
            if v64 == "" then
                v64 = AnimalRenders.GetImage(v61)
            end
            v62.ScaleType = Enum.ScaleType.Fit
            v63.ScaleType = Enum.ScaleType.Fit
            v62.Image = v64
            v63.Image = v64
            v62.Visible = v64 ~= ""
            local v65 = v5
            if v65 and v65.Parent then
                v65.Transparency = maskFor(v10, 0)
                v11 = v10
            end
            if v16 == nil and v5 ~= nil and v9 ~= nil then
                v16 = RunService.Heartbeat:Connect(step)
            end
        end
    end
end

function v1.SetLevel(v66) -- line 273 | captures: v5, v9, v10, v11, v15, v16, RunService, maskFor, step
    local v67 = math.clamp(v66, 0, 1)
    v15 = nil
    v10 = v67
    if not (v10 > 0.001 and v10 < 0.999) then
        local v68 = v5
        if v68 and v68.Parent then
            v68.Transparency = maskFor(v10, 0)
            v11 = v10
        end
    end
    if v16 == nil and v5 ~= nil and v9 ~= nil then
        v16 = RunService.Heartbeat:Connect(step)
    end
end

function v1.TweenLevel(v69, v70) -- line 284 | captures: v5, v9, v10, v12, v13, v14, v15, v16, RunService, step
    local v71 = math.clamp(v69, 0, 1)
    v12 = v10
    v13 = v71
    v14 = os.clock()
    v15 = v70
    if v16 == nil and v5 ~= nil and v9 ~= nil then
        v16 = RunService.Heartbeat:Connect(step)
    end
end

function v1.Punch(v72) -- line 294 | captures: punch
    local v73 = if v72 then 1.14 else 1.06
    punch(v73)
end

return v1
