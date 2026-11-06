-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local v1 = {}

v1.__index = v1

local v2 = {}

local function enumItem(v3, v4, v5) -- line 68 | captures: v2
    if v4 then
        local v6 = v2[v3]
        if not v6 then
            v6 = {}
            v2[v3] = v6
        end
        local v7 = v6[v4]
        if v7 then
            return v7
        end
        local v8, v9 = pcall(function() -- line 81 | captures: v3, v4
            return v3[v4]
        end)
        if not v8 or not v9 then
            v9 = v5
        end
        v6[v4] = v9
        return v9
    end
    return v5
end

local function poseCFrame(v10, v11, v12) -- line 89
    local v13 = v10[v11]
    if v13 then
        local Pos = v13.Pos
        local Angles = CFrame.Angles
        local v14 = v13[1] or 0
        local v15 = math.rad(v14)
        local v16 = v13[2] or 0
        local v17 = math.rad(v16)
        local v18 = v13[3] or 0
        local v19 = Angles(v15, v17, (math.rad(v18)))
        if typeof(Pos) == "Vector3" then
            return CFrame.new(Pos * v12) * v19
        end
        return v19
    end
    return CFrame.identity
end

local function findJoints(v20) -- line 99
    local v21 = {}
    for v22, v23 in v20:GetDescendants() do
        if v23:IsA("Motor6D") or v23:IsA("AnimationConstraint") then
            v21[v23.Name] = v23
        end
    end
    return v21
end

local function ease(v24) -- line 109 | captures: TweenService
    return TweenService:GetValue(math.clamp(v24, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function v1.new(v25, v26, v27) -- line 113 | captures: v1, findJoints
    local v28 = {
        Started = 0,
        FadeInAt = 0,
        FadeOutAt = nil,
        FadeOutTime = 0.22,
        Mask = nil,
        AutoRelease = false,
        Connection = nil,
        Model = v25,
        Clip = v26,
        Poses = v27,
        Joints = findJoints(v25),
        Scale = v25:GetScale(),
        Scratch = {}
    }
    local v29 = setmetatable(v28, v1)
    v25.DescendantAdded:Connect(function(v30) -- line 130 | captures: v29
        if v30:IsA("Motor6D") or v30:IsA("AnimationConstraint") then
            v29.Joints[v30.Name] = v30
        end
    end)
    return v29
end

function v1.Sample(v31, v32) -- line 140 | captures: TweenService, enumItem, poseCFrame
    local Keyframes = v31.Clip.Keyframes
    local v33 = Keyframes[1]
    local v34 = Keyframes[#Keyframes]
    local v35 = #Keyframes - 1
    for v36 = 1, v35 do
        if Keyframes[v36].Time <= v32 and v32 <= Keyframes[v36 + 1].Time then
            v33, v34 = Keyframes[v36], Keyframes[v36 + 1]
            break
        end
    end
    local v37 = v34.Time - v33.Time
    local v38
    if v37 > 0 then
        local v39 = (v32 - v33.Time) / v37
        v38 = math.clamp(v39, 0, 1)
    else
        v38 = 1
    end
    local v40 = TweenService:GetValue(v38, enumItem(Enum.EasingStyle, v34.Style, Enum.EasingStyle.Linear), (enumItem(Enum.EasingDirection, v34.Direction, Enum.EasingDirection.InOut)))
    local v41 = v31.Poses[v33.Pose] or {}
    local v42 = v31.Poses[v34.Pose] or {}
    local Mask = v31.Mask
    local Scratch = v31.Scratch
    table.clear(Scratch)
    for v43 in v31.Joints do
        if Mask then
            if Mask[v43] then
                Scratch[v43] = poseCFrame(v41, v43, v31.Scale):Lerp(poseCFrame(v42, v43, v31.Scale), v40)
            end
        else
            Scratch[v43] = poseCFrame(v41, v43, v31.Scale):Lerp(poseCFrame(v42, v43, v31.Scale), v40)
        end
    end
    return Scratch
end

local function disconnect(v44) -- line 173
    if v44.Connection then
        v44.Connection:Disconnect()
        v44.Connection = nil
    end
end

function v1.Play(v45, v46, v47, v48) -- line 180 | captures: RunService, TweenService
    if v46 then
        v45.Clip = v46
    end
    if v45.Connection then
        v45.Connection:Disconnect()
        v45.Connection = nil
    end
    local Mask = v48 and v48.Mask or nil
    v45.Mask = Mask
    v45.AutoRelease = v48 and v48.Release == true
    local v49 = os.clock()
    local v50 = v47 or 0
    v45.Started = v49 - math.max(v50, 0)
    v45.FadeInAt = os.clock()
    v45.FadeOutAt = nil
    local PreSimulation = RunService.PreSimulation
    v45.Connection = PreSimulation:Connect(function() -- line 190 | captures: v45, TweenService
        if v45.Model.Parent then
            local v51 = os.clock()
            local v52 = v51 - v45.Started
            local Length = v45.Clip.Length
            local v53 = math.max(Length, 0.01)
            local v54
            if v45.Clip.Looped then
                v54 = v52 % v53
            else
                v54 = math.min(v52, v53)
            end
            if v45.AutoRelease and not v45.Clip.Looped and not v45.FadeOutAt and v53 - 0.22 <= v52 then
                v45.FadeOutAt = v51
                v45.FadeOutTime = 0.22
            end
            local v55 = (v51 - v45.FadeInAt) / 0.18
            local v56 = TweenService:GetValue(math.clamp(v55, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local FadeOutAt = v45.FadeOutAt
            if FadeOutAt then
                local v57 = v51 - FadeOutAt
                local FadeOutTime = v45.FadeOutTime
                local v58 = v57 / math.max(FadeOutTime, 0.01)
                if v58 >= 1 then
                    if v45.Connection then
                        v45.Connection:Disconnect()
                        v45.Connection = nil
                    end
                    return
                end
                v56 *= 1 - TweenService:GetValue(math.clamp(v58, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end
            for v59, v60 in v45:Sample(v54) do
                local v61 = v45.Joints[v59]
                if v61 and v61.Parent then
                    if v56 >= 1 then
                        v61.Transform = v60
                    else
                        v61.Transform = v61.Transform:Lerp(v60, v56)
                    end
                end
            end
        else
            v45:Stop()
        end
    end)
end

local function Release(v62, v63) -- line 227
    if v62.Connection and not v62.FadeOutAt then
        v62.FadeOutAt = os.clock()
        v62.FadeOutTime = v63 or 0.22
    end
end

v1.Release = Release

local function IsPlaying(v64) -- line 235
    return v64.Connection ~= nil
end

v1.IsPlaying = IsPlaying

local function Stop(v65) -- line 239
    if v65.Connection then
        v65.Connection:Disconnect()
        v65.Connection = nil
    end
    for v66, v67 in v65.Joints do
        if v67.Parent then
            v67.Transform = CFrame.identity
        end
    end
end

v1.Stop = Stop
return v1
