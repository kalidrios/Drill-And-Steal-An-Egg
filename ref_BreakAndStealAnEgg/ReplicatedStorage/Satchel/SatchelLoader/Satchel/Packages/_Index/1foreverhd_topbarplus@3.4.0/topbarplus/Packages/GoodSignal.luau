-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local v1

local function acquireRunnerThreadAndCallEventHandler(v2, ...) -- line 34 | captures: v1
    local v3 = v1
    v1 = nil
    v2(...)
    v1 = v3
end

local function runEventHandlerInFreeThread() -- line 45 | captures: acquireRunnerThreadAndCallEventHandler
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local v4 = {}

v4.__index = v4

function v4.new(v5, v6) -- line 60 | captures: v4
    local v7 = {
        _connected = true,
        _next = false,
        _signal = v5,
        _fn = v6
    }
    return (setmetatable(v7, v4))
end

local function Disconnect(v8) -- line 69
    v8._connected = false
    if v8._signal._handlerListHead == v8 then
        v8._signal._handlerListHead = v8._next
    else
        local v9 = v8._signal._handlerListHead
        while v9 do
            if v9._next == v8 then
                break
            end
            v9 = v9._next
        end
        if v9 then
            v9._next = v8._next
        end
    end
end

v4.Disconnect = Disconnect
v4.Destroy = v4.Disconnect

local v10 = {
    __index = function(v11, v12) -- __index | line 92
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(v12))), 2)
    end,
    __newindex = function(v13, v14, v15) -- __newindex | line 95
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(v14))), 2)
    end
}
setmetatable(v4, v10)
local v16 = {}

v16.__index = v16

function v16.new() -- line 104 | captures: v16
    local v17 = { _handlerListHead = false }
    return (setmetatable(v17, v16))
end

function v16.Connect(v18, v19) -- line 110 | captures: v4
    local v20 = v4.new(v18, v19)
    if v18._handlerListHead then
        v20._next = v18._handlerListHead
    end
    v18._handlerListHead = v20
    return v20
end

local function DisconnectAll(v21) -- line 123
    v21._handlerListHead = false
end

v16.DisconnectAll = DisconnectAll
v16.Destroy = v16.DisconnectAll

function v16.Fire(v22, ...) -- line 132 | captures: v1, runEventHandlerInFreeThread
    local v23 = v22._handlerListHead
    while true do
        if v23 then
            if v23._connected then
                if not v1 then
                    v1 = coroutine.create(runEventHandlerInFreeThread)
                    coroutine.resume(v1)
                end
                task.spawn(v1, v23._fn, ...)
            end
        else
            break
        end
        v23 = v23._next
    end
end

local function Wait(v24) -- line 149
    local v25 = coroutine.running()
    local v26
    v26 = v24:Connect(function(...) -- line 152 | captures: v26, v25
        v26:Disconnect()
        task.spawn(v25, ...)
    end)
    return coroutine.yield()
end

v16.Wait = Wait

local function Once(v27, v28) -- line 161
    local v29
    v29 = v27:Connect(function(...) -- line 163 | captures: v29, v28
        if v29._connected then
            v29:Disconnect()
        end
        v28(...)
    end)
    return v29
end

v16.Once = Once

local v30 = {
    __index = function(v31, v32) -- __index | line 174
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(v32))), 2)
    end,
    __newindex = function(v33, v34, v35) -- __newindex | line 177
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(v34))), 2)
    end
}
setmetatable(v16, v30)
return v16
