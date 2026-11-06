-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local CameraShakeInstance = require(script.CameraShakeInstance)
local CameraShakeState = CameraShakeInstance.CameraShakeState
local v1 = {}

v1.__index = v1
v1.CameraShakeInstance = CameraShakeInstance
v1.Presets = require(script.CameraShakePresets)

local v2 = 0

function v1.new(v3, v4) -- line 43 | captures: v2, v1
    local v5 = type(v3) == "number"
    assert(v5, "RenderPriority must be a number")
    local v6 = type(v4) == "function"
    assert(v6, "Callback must be a function")
    v2 += 1
    local v7 = {
        _running = false,
        _renderName = ("CameraShaker_%*"):format(v2),
        _renderPriority = v3,
        _camShakeInstances = {},
        _callback = v4
    }
    return (setmetatable(v7, v1))
end

function v1.Start(v8) -- line 59 | captures: RunService
    if v8._running then
        return
    end
    v8._running = true
    local _renderName = v8._renderName
    local _renderPriority = v8._renderPriority
    RunService:BindToRenderStep(_renderName, _renderPriority, function(v9) -- line 64 | captures: v8
        if #v8._camShakeInstances ~= 0 then
            v8._callback(v8:Update(v9))
        end
    end)
end

function v1.Stop(v10) -- line 74 | captures: RunService
    if v10._running then
        RunService:UnbindFromRenderStep(v10._renderName)
        v10._running = false
    end
end

function v1.Update(v11, v12) -- line 82 | captures: CameraShakeState
    local v13 = Vector3.new(0, 0, 0)
    local v14 = Vector3.new(0, 0, 0)
    local _camShakeInstances = v11._camShakeInstances
    local v15 = #_camShakeInstances
    for v16 = v15, 1, -1 do
        local v17 = _camShakeInstances[v16]
        local v18 = v17:GetState()
        if not (v18 == CameraShakeState.Inactive and v17.DeleteOnInactive) then
            if v18 ~= CameraShakeState.Inactive then
                local v19 = v17:UpdateShake(v12)
                v13, v14 = v13 + v19 * v17.PositionInfluence, v14 + v19 * v17.RotationInfluence
            end
        else
            table.remove(_camShakeInstances, v16)
        end
    end
    local v20 = CFrame.new(v13)
    local Angles = CFrame.Angles
    local X = v14.X
    local v21 = math.rad(X)
    local Y = v14.Y
    local v22 = math.rad(Y)
    local Z = v14.Z
    return v20 * Angles(v21, v22, (math.rad(Z)))
end

local function Shake(v23, v24) -- line 104
    local _camShakeInstances = v23._camShakeInstances
    table.insert(_camShakeInstances, v24)
    return v24
end

v1.Shake = Shake

local function ShakeSustain(v25, v26) -- line 110
    v26:StartFadeIn(v26.fadeInDuration)
    local _camShakeInstances = v25._camShakeInstances
    table.insert(_camShakeInstances, v26)
    return v26
end

v1.ShakeSustain = ShakeSustain

function v1.ShakeOnce(v27, v28, v29, v30, v31, v32, v33) -- line 117 | captures: CameraShakeInstance
    local v34 = CameraShakeInstance.new(v28, v29, v30, v31)
    if typeof(v32) == "Vector3" then
        v34.PositionInfluence = v32
    else
        v34.PositionInfluence = Vector3.new(0.15000000596046448, 0.15000000596046448, 0.15000000596046448)
    end
    if typeof(v33) == "Vector3" then
        v34.RotationInfluence = v33
    else
        v34.RotationInfluence = Vector3.new(1, 1, 1)
    end
    local _camShakeInstances = v27._camShakeInstances
    table.insert(_camShakeInstances, v34)
    return v34
end

local function StopSustained(v35, v36) -- line 133
    for v37, v38 in v35._camShakeInstances do
        if v38.fadeOutDuration == 0 then
            v38:StartFadeOut(v36 or v38.fadeInDuration)
        end
    end
end

v1.StopSustained = StopSustained
return v1
