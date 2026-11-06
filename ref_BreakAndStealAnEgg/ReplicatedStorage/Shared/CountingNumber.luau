-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local v1 = {}

v1.__index = v1

function v1.new(v2, v3) -- line 51 | captures: v1
    local v4 = {
        _value = 0,
        _target = 0,
        _shown = nil,
        _connection = nil,
        _apply = v2,
        _onStep = v3
    }
    return (setmetatable(v4, v1))
end

local function _stop(v5) -- line 62
    if v5._connection ~= nil then
        v5._connection:Disconnect()
        v5._connection = nil
    end
end

v1._stop = _stop

local function _applyIfChanged(v6, v7) -- line 74
    local v8 = v7 * 2
    local v9 = math.floor(v8)
    if v9 ~= v6._shown then
        v6._shown = v9
        v6._apply(v7)
    end
end

v1._applyIfChanged = _applyIfChanged

local function Snap(v10, v11) -- line 83
    v10:_stop()
    v10._target = v11
    v10._value = v11
    v10:_applyIfChanged(v11)
    if v10._onStep then
        v10._onStep(v11)
    end
end

v1.Snap = Snap

local function Value(v12) -- line 94
    return v12._value
end

v1.Value = Value

local function snapEpsilon(v13) -- line 101
    local v14 = math.abs(v13) * 0.000000001
    return (math.max(0.5, v14))
end

function v1.Set(v15, v16) -- line 106 | captures: RunService
    v15._target = v16
    local v17 = v16 - v15._value
    local v18 = math.abs(v17)
    local v19
    if v18 == v18 then
        if v18 == (1/0) then
            v19 = true
        else
            local v20 = math.abs(v16) * 0.000000001
            if v18 <= math.max(0.5, v20) then
                v19 = true
            else
                if v15._connection == nil then
                    local Heartbeat = RunService.Heartbeat
                    v15._connection = Heartbeat:Connect(function(v21) -- line 119 | captures: v15
                        local v22 = v15._target - v15._value
                        local v23 = math.abs(v22)
                        local _target = v15._target
                        local v24 = math.abs(_target) * 0.000000001
                        if v23 <= math.max(0.5, v24) then
                            v15:Snap(v15._target)
                        else
                            v15._value = v15._target - v22 * 0.025 ^ v21
                            v15:_applyIfChanged(v15._value)
                            if v15._onStep then
                                v15._onStep(v15._value)
                            end
                        end
                    end)
                end
                v19 = false
            end
        end
    else
        v19 = true
    end
    if not v19 then
        return
    end
    v15:Snap(v16)
end

local function Destroy(v25) -- line 136
    v25:_stop()
end

v1.Destroy = Destroy
return v1
