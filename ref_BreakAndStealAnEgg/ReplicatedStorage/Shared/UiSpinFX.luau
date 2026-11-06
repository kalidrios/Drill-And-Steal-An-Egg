-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local UiSpinConfig = require(script.Parent.UiSpinConfig)
local v1 = {}
local v2 = 1 / UiSpinConfig.UpdatesPerSecond
local v3 = {}
local v4 = 0
local v5
local v6 = 0

local function hostOf(v7) -- line 57
    if v7:IsA("GuiObject") then
        return v7
    end
    return v7:FindFirstAncestorWhichIsA("GuiObject")
end

local function isOnScreen(v8) -- line 66
    local v9
    if v8:IsA("GuiObject") then
        v9 = v8
    else
        v9 = v8:FindFirstAncestorWhichIsA("GuiObject")
    end
    if not (v9 and v9.Visible) then
        return false
    end
    local Parent = v9.Parent
    while true do
        if Parent then
            if Parent:IsA("GuiObject") then
                if Parent.Visible then
                    Parent = Parent.Parent
                    continue
                end
                return false
            end
            if Parent:IsA("LayerCollector") then
                break
            end
            Parent = Parent.Parent
            continue
        end
        return false
    end
    return Parent.Enabled and Parent:IsDescendantOf(game)
end

local function ensureHeartbeat() -- line 89 | captures: v4, v5, v6, RunService, v2, v3
    if not v5 then
        v6 = 0
        v5 = RunService.Heartbeat:Connect(function(v10) -- line 94 | captures: v4, v5, v6, v2, v3
            v6 += v10
            if v6 < v2 * 0.9 then
                return
            end
            local v11 = v6
            v6 = 0
            for v12, v13 in v3 do
                if v13.Visible then
                    v12.Rotation = (v12.Rotation + v13.Speed * v11) % 360
                end
            end
            if v4 <= 0 and v5 then
                v5:Disconnect()
                v5 = nil
            end
        end)
    end
end

local function refresh(v14, v15) -- line 125 | captures: v4, v5, v6, RunService, v2, v3, isOnScreen
    local v16 = isOnScreen(v14)
    if v16 == v15.Visible then
        return
    end
    v15.Visible = v16
    local v17 = v4
    local v18 = if v16 then 1 else -1
    v4 = v17 + v18
    if not v16 then
        return
    end
    if v5 then
        return
    end
    v6 = 0
    v5 = RunService.Heartbeat:Connect(function(v19) -- line 94 | captures: v4, v5, v6, v2, v3
        v6 += v19
        if v6 < v2 * 0.9 then
            return
        end
        local v20 = v6
        v6 = 0
        for v21, v22 in v3 do
            if v22.Visible then
                v21.Rotation = (v21.Rotation + v22.Speed * v20) % 360
            end
        end
        if v4 <= 0 and v5 then
            v5:Disconnect()
            v5 = nil
        end
    end)
end

local function clearWatchers(v23) -- line 137
    for v24, v25 in v23.Watchers do
        v25:Disconnect()
    end
    table.clear(v23.Watchers)
end

local v26

function v26(v27, v28) -- line 147 | captures: v4, v5, v6, v26, RunService, v1, v2, v3, isOnScreen
    local function v29(v30, ...)
        table.insert(v30, ...)
    end

    local function v31(v32, ...)
        table.insert(v32, ...)
    end

    local function v33(v34, ...)
        table.insert(v34, ...)
    end

    local function v35(v36, ...)
        table.insert(v36, ...)
    end

    local function v37(v38, ...)
        table.insert(v38, ...)
    end

    for v39, v40 in v28.Watchers do
        v40:Disconnect()
    end
    table.clear(v28.Watchers)

    local function onChanged() -- line 150 | captures: v27, v28, v4, v5, v6, RunService, v2, v3, isOnScreen
        local v41 = isOnScreen(v27)
        if v41 == v28.Visible then
            return
        end
        v28.Visible = v41
        local v42 = v4
        local v43 = if v41 then 1 else -1
        v4 = v42 + v43
        if not v41 then
            return
        end
        if v5 then
            return
        end
        v6 = 0
        v5 = RunService.Heartbeat:Connect(function(v44) -- line 94 | captures: v4, v5, v6, v2, v3
            v6 += v44
            if v6 < v2 * 0.9 then
                return
            end
            local v45 = v6
            v6 = 0
            for v46, v47 in v3 do
                if v47.Visible then
                    v46.Rotation = (v46.Rotation + v47.Speed * v45) % 360
                end
            end
            if v4 <= 0 and v5 then
                v5:Disconnect()
                v5 = nil
            end
        end)
    end

    local v48
    if v27:IsA("GuiObject") then
        v48 = v27
    else
        v48 = v27:FindFirstAncestorWhichIsA("GuiObject")
    end
    local Parent
    if v48 then
        v29(v28.Watchers, v48:GetPropertyChangedSignal("Visible"):Connect(onChanged))
        Parent = v48.Parent
    else
        Parent = v27.Parent
    end
    while Parent do
        if Parent:IsA("GuiObject") then
            v31(v28.Watchers, Parent:GetPropertyChangedSignal("Visible"):Connect(onChanged))
        elseif Parent:IsA("LayerCollector") then
            v33(v28.Watchers, Parent:GetPropertyChangedSignal("Enabled"):Connect(onChanged))
            break
        end
        Parent = Parent.Parent
    end
    v35(v28.Watchers, v27.AncestryChanged:Connect(function() -- line 173 | captures: v27, v28, v4, v5, v6, v26, RunService, v1, v2, v3, isOnScreen
        if v3[v27] == v28 then
            if v27:IsDescendantOf(game) then
                v26(v27, v28)
                local v49 = isOnScreen(v27)
                if v49 ~= v28.Visible then
                    v28.Visible = v49
                    local v50 = v4
                    local v51 = if v49 then 1 else -1
                    v4 = v50 + v51
                    if v49 then
                        if v5 then
                            return
                        end
                        v6 = 0
                        v5 = RunService.Heartbeat:Connect(function(v52) -- line 94 | captures: v4, v5, v6, v2, v3
                            v6 += v52
                            if v6 < v2 * 0.9 then
                                return
                            end
                            local v53 = v6
                            v6 = 0
                            for v54, v55 in v3 do
                                if v55.Visible then
                                    v54.Rotation = (v54.Rotation + v55.Speed * v53) % 360
                                end
                            end
                            if v4 <= 0 and v5 then
                                v5:Disconnect()
                                v5 = nil
                            end
                        end)
                    end
                end
            else
                task.defer(function() -- line 184 | captures: v27, v28, v1, v3
                    if v3[v27] == v28 and not v27:IsDescendantOf(game) then
                        v1.Detach(v27)
                    end
                end)
            end
        end
    end))
    v37(v28.Watchers, v27.Destroying:Connect(function() -- line 196 | captures: v27, v1
        v1.Detach(v27)
    end))
end

function v1.Detach(v56) -- line 206 | captures: v4, v3
    local v57 = v3[v56]
    if not v57 then
        return
    end
    v3[v56] = nil
    if v57.Visible then
        v4 -= 1
    end
    for v58, v59 in v57.Watchers do
        v59:Disconnect()
    end
    table.clear(v57.Watchers)
end

function v1.Attach(v60, v61) -- line 221 | captures: v4, v5, v6, v26, RunService, v1, v2, v3, isOnScreen
    local v62 = if typeof(v61) == "number" then v61 else 0
    if v62 == 0 then
        v1.Detach(v60)
    else
        local v63 = v3[v60]
        if v63 then
            v63.Speed = v62
        else
            local v64 = {
                Visible = false,
                Speed = v62,
                Watchers = {}
            }
            v3[v60] = v64
            v26(v60, v64)
            local v65 = isOnScreen(v60)
            if v65 ~= v64.Visible then
                v64.Visible = v65
                local v66 = v4
                local v67 = if v65 then 1 else -1
                v4 = v66 + v67
                if v65 then
                    if v5 then
                        return
                    end
                    v6 = 0
                    v5 = RunService.Heartbeat:Connect(function(v68) -- line 94 | captures: v4, v5, v6, v2, v3
                        v6 += v68
                        if v6 < v2 * 0.9 then
                            return
                        end
                        local v69 = v6
                        v6 = 0
                        for v70, v71 in v3 do
                            if v71.Visible then
                                v70.Rotation = (v70.Rotation + v71.Speed * v69) % 360
                            end
                        end
                        if v4 <= 0 and v5 then
                            v5:Disconnect()
                            v5 = nil
                        end
                    end)
                end
            end
        end
    end
end

return v1
