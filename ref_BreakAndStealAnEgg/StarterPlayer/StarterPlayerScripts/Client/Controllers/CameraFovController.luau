-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CameraFovConfig = require(ReplicatedStorage.Shared.CameraFovConfig)
local v1 = {}
local v2
local v3 = {}
local v4 = false
local v5 = 0
local v6
local v7 = false

local function getOriginal() -- line 38 | captures: v2, Workspace, CameraFovConfig
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    return v2
end

local function hasOffsets() -- line 46 | captures: v3
    return next(v3) ~= nil
end

local function targetFov() -- line 50 | captures: v2, Workspace, CameraFovConfig, v3
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    local v8 = v2
    for v9, v10 in v3 do
        v8 += v10
    end
    local MinFov = CameraFovConfig.MinFov
    local MaxFov = CameraFovConfig.MaxFov
    return (math.clamp(v8, MinFov, MaxFov))
end

local function apply() -- line 58 | captures: v2, v4, Workspace, CameraFovConfig, v3
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera == nil then
        return
    end
    v4 = true
    -- [[ targetFov
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    local v11 = v2
    for v12, v13 in v3 do
        v11 += v13
    end
    local MinFov = CameraFovConfig.MinFov
    local MaxFov = CameraFovConfig.MaxFov
    -- ]] targetFov
    CurrentCamera.FieldOfView = math.clamp(v11, MinFov, MaxFov)
    v4 = false
end

local function onFovChanged() -- line 70 | captures: v2, v4, v5, Workspace, CameraFovConfig, v3
    if v4 or not (next(v3) == nil) then
        return
    end
    v5 += 1
    local v14 = v5
    task.delay(CameraFovConfig.StrayResetDelay, function() -- line 76 | captures: v14, v2, v4, v5, Workspace, CameraFovConfig, v3
        if v14 == v5 and next(v3) == nil then
            local CurrentCamera = Workspace.CurrentCamera
            if CurrentCamera ~= nil then
                local FieldOfView = CurrentCamera.FieldOfView
                if v2 == nil then
                    local CurrentCamera = Workspace.CurrentCamera
                    if CurrentCamera == nil then
                        v2 = CameraFovConfig.DefaultFov
                    else
                        v2 = CurrentCamera.FieldOfView
                    end
                end
                local v15 = FieldOfView - v2
                if math.abs(v15) > 0.01 then
                    local CurrentCamera = Workspace.CurrentCamera
                    if CurrentCamera == nil then
                        return
                    end
                    v4 = true
                    if v2 == nil then
                        local CurrentCamera = Workspace.CurrentCamera
                        if CurrentCamera == nil then
                            v2 = CameraFovConfig.DefaultFov
                        else
                            v2 = CurrentCamera.FieldOfView
                        end
                    end
                    local v16 = v2
                    for v17, v18 in v3 do
                        v16 += v18
                    end
                    local MinFov = CameraFovConfig.MinFov
                    local MaxFov = CameraFovConfig.MaxFov
                    CurrentCamera.FieldOfView = math.clamp(v16, MinFov, MaxFov)
                    v4 = false
                end
            end
        end
    end)
end

local function watchCamera() -- line 87 | captures: v2, v4, v6, Workspace, CameraFovConfig, v3, onFovChanged
    if v6 ~= nil then
        v6:Disconnect()
        v6 = nil
    end
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera == nil then
        return
    end
    v6 = CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(onFovChanged)
    local CurrentCamera_2 = Workspace.CurrentCamera
    if CurrentCamera_2 == nil then
        return
    end
    v4 = true
    -- [[ targetFov
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    local v19 = v2
    for v20, v21 in v3 do
        v19 += v21
    end
    local MinFov = CameraFovConfig.MinFov
    local MaxFov = CameraFovConfig.MaxFov
    -- ]] targetFov
    CurrentCamera_2.FieldOfView = math.clamp(v19, MinFov, MaxFov)
    v4 = false
end

function v1.Set(v22, v23) -- line 101 | captures: v2, v4, v5, Workspace, CameraFovConfig, v3
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    if math.abs(v23) < 0.001 then
        v3[v22] = nil
    else
        v3[v22] = v23
    end
    v5 += 1
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera == nil then
        return
    end
    v4 = true
    -- [[ targetFov
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    local v24 = v2
    for v25, v26 in v3 do
        v24 += v26
    end
    local MinFov = CameraFovConfig.MinFov
    local MaxFov = CameraFovConfig.MaxFov
    -- ]] targetFov
    CurrentCamera.FieldOfView = math.clamp(v24, MinFov, MaxFov)
    v4 = false
end

function v1.Clear(v27) -- line 114 | captures: v2, v4, Workspace, CameraFovConfig, v3
    if v3[v27] == nil then
        return
    end
    v3[v27] = nil
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera == nil then
        return
    end
    v4 = true
    -- [[ targetFov
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    local v28 = v2
    for v29, v30 in v3 do
        v28 += v30
    end
    local MinFov = CameraFovConfig.MinFov
    local MaxFov = CameraFovConfig.MaxFov
    -- ]] targetFov
    CurrentCamera.FieldOfView = math.clamp(v28, MinFov, MaxFov)
    v4 = false
end

function v1.Reset() -- line 123 | captures: v2, v4, Workspace, CameraFovConfig, v3
    table.clear(v3)
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera == nil then
        return
    end
    v4 = true
    -- [[ targetFov
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    local v31 = v2
    for v32, v33 in v3 do
        v31 += v33
    end
    local MinFov = CameraFovConfig.MinFov
    local MaxFov = CameraFovConfig.MaxFov
    -- ]] targetFov
    CurrentCamera.FieldOfView = math.clamp(v31, MinFov, MaxFov)
    v4 = false
end

function v1.GetOriginal() -- line 129 | captures: v2, Workspace, CameraFovConfig
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    return v2
end

function v1.Start() -- line 133 | captures: v2, v4, v6, v7, Workspace, CameraFovConfig, v3, onFovChanged, watchCamera
    if v7 then
        return
    end
    v7 = true
    if v2 == nil then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera == nil then
            v2 = CameraFovConfig.DefaultFov
        else
            v2 = CurrentCamera.FieldOfView
        end
    end
    if v6 ~= nil then
        v6:Disconnect()
        v6 = nil
    end
    local CurrentCamera = Workspace.CurrentCamera
    local CurrentCamera_2, v34
    if CurrentCamera == nil then
        v34 = true
    else
        v6 = CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(onFovChanged)
        CurrentCamera_2 = Workspace.CurrentCamera
        if CurrentCamera_2 == nil then
            v34 = true
        else
            v4 = true
            if v2 == nil then
                local CurrentCamera = Workspace.CurrentCamera
                if CurrentCamera == nil then
                    v2 = CameraFovConfig.DefaultFov
                else
                    v2 = CurrentCamera.FieldOfView
                end
            end
            v34 = false
        end
    end
    if not v34 then
        local v35 = v2
        for v36, v37 in v3 do
            v35 += v37
        end
        local MinFov = CameraFovConfig.MinFov
        local MaxFov = CameraFovConfig.MaxFov
        CurrentCamera_2.FieldOfView = math.clamp(v35, MinFov, MaxFov)
        v4 = false
    end
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera)
end

return v1
