-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1 = {}

v1.__index = v1

function v1.new(v2, v3, v4, v5, v6) -- line 61 | captures: v1
    local v7 = {
        Move = nil,
        MoveStart = 0,
        Model = v2,
        Folder = v3,
        Info = v4,
        Clock = v5,
        Fade = v6 or 0.2,
        Loaded = {},
        Missing = {},
        Owner = {},
        Wanted = {}
    }
    return (setmetatable(v7, v1))
end

local function Get(v8, v9, v10) -- line 78
    local v11 = v8.Loaded[v9]
    if v11 then
        return v11
    end
    local v12 = v8.Info[v9]
    local v13, v14, v15
    if v12 then
        if v8.Missing[v9] then
            v15 = true
        else
            v13 = v8.Model:FindFirstChildWhichIsA("Animator", true)
            local v16 = v8.Model:FindFirstChild(v8.Folder)
            v14 = v16 and v16:FindFirstChild(v12.Name)
            v15 = false
        end
    else
        v15 = true
    end
    if v15 then
        return nil
    end
    if v13 and v14 and v14:IsA("Animation") then
        local v17 = v13
        local v18 = v14
        local v19, v20 = pcall(function() -- line 95 | captures: v17, v18
            return v17:LoadAnimation(v18)
        end)
        if v19 and v20 then
            v20.Priority = v10 or Enum.AnimationPriority.Action
            v8.Loaded[v9] = v20
            return v20
        end
        v8.Missing[v9] = true
        warn((("[BossTracks] couldn't load %*: %*"):format(v12.Name, v20)))
        return nil
    end
    v8.Missing[v9] = true
    warn((("[BossTracks] %*: no Animator or no %*.%* Animation"):format(v8.Model.Name, v8.Folder, v12.Name)))
    return nil
end

v1.Get = Get

local function window(v21, v22) -- line 109
    local v23 = v21.Info[v22.Track]
    local v24 = v21.Loaded[v22.Track]
    local v25
    if not (v24 and v24.Length > 0) then
        if v23 then
            v25 = v23.Length
        else
            v25 = 0
        end
    else
        v25 = v24.Length
    end
    local From = v22.From
    if not From then
        local v26 = v22.At - v22.Mark / v22.Speed
        From = math.max(v26, 0)
    end
    local v27 = if v22.Looped then v22.Until or (1/0) else v22.At + (v25 - v22.Mark) / v22.Speed - v21.Fade
    return From, (math.max(v27, From))
end

local function release(v28, v29, v30) -- line 120
    local v31 = v28.Loaded[v29]
    if v31 and v31.IsPlaying then
        v31:Stop(v30 or v28.Fade)
    end
    v28.Owner[v29] = nil
end

function v1.Step(v32) -- line 128 | captures: window
    local Move = v32.Move
    if not Move then
        return
    end
    local v33 = v32.Clock() - v32.MoveStart
    local Wanted = v32.Wanted
    table.clear(Wanted)
    local v34 = true
    for v35, v36 in Move do
        local v37, v38 = window(v32, v36)
        if v33 < v38 then
            v34 = false
        end
        if v37 <= v33 and v33 < v38 then
            Wanted[v36.Track] = v36
        end
    end
    for v39, v40 in v32.Owner do
        if Wanted[v39] ~= v40 then
            local v41 = v32.Loaded[v39]
            if v41 and v41.IsPlaying then
                v41:Stop(v32.Fade)
            end
            v32.Owner[v39] = nil
        end
    end
    for v42, v43 in Wanted do
        if v32.Owner[v42] ~= v43 then
            local v44 = v32:Get(v42)
            if v44 then
                local v45 = if v44.Length > 0 then v44.Length else v32.Info[v42].Length
                local v46 = v43.Mark + (v33 - v43.At) * v43.Speed
                if v43.Looped and v45 > 0 then
                    v46 %= v45
                end
                v44.Looped = v43.Looped == true
                v44:Play(v32.Fade, 1, v43.Speed)
                local v47 = v45 - 0.02
                local v48 = math.max(v47, 0)
                v44.TimePosition = math.clamp(v46, 0, v48)
            end
            v32.Owner[v42] = v43
        end
    end
    if v34 then
        v32.Move = nil
    end
end

local function Play(v49, v50, v51) -- line 174
    for v52 in v49.Owner do
        local v53 = v49.Loaded[v52]
        if v53 and v53.IsPlaying then
            v53:Stop(v49.Fade)
        end
        v49.Owner[v52] = nil
    end
    v49.Move = v50
    v49.MoveStart = v51
    v49:Step()
end

v1.Play = Play

local function Stop(v54, v55) -- line 183
    for v56 in v54.Owner do
        local v57 = v54.Loaded[v56]
        if v57 and v57.IsPlaying then
            v57:Stop(v55 or v54.Fade)
        end
        v54.Owner[v56] = nil
    end
    v54.Move = nil
end

v1.Stop = Stop

local function IsPlaying(v58) -- line 190
    if v58.Move == nil then
        return false
    end
    return next(v58.Owner) ~= nil
end

v1.IsPlaying = IsPlaying

local function StopAll(v59) -- line 194
    v59.Move = nil
    table.clear(v59.Owner)
    for v60, v61 in v59.Loaded do
        v61:Stop(0)
    end
end

v1.StopAll = StopAll
return v1
