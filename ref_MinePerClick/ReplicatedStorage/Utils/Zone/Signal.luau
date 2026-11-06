-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = nil

local function acquireRunnerThreadAndCallEventHandler(p1, ...) --[[ acquireRunnerThreadAndCallEventHandler | Line: 34 | Upvalues: v1 (ref) ]]
	local v12 = v1

	v1 = nil
	p1(...)
	v1 = v12
end

local function runEventHandlerInFreeThread(...) --[[ runEventHandlerInFreeThread | Line: 45 | Upvalues: acquireRunnerThreadAndCallEventHandler (copy) ]]
	acquireRunnerThreadAndCallEventHandler(...)

	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local t = {}

t.__index = t
function t.new(p1, p2) --[[ new | Line: 56 | Upvalues: t (copy) ]]
	return setmetatable({
		_connected = true,
		_next = false,
		_signal = p1,
		_fn = p2
	}, t)
end
function t.Disconnect(p1) --[[ Disconnect | Line: 65 ]]
	assert(p1._connected, "Can\'t disconnect a connection twice.", 2)
	p1._connected = false

	local _signal = p1._signal

	if _signal._handlerListHead == p1 then
		_signal._handlerListHead = p1._next
	else
		local _handlerListHead = _signal._handlerListHead

		while _handlerListHead and _handlerListHead._next ~= p1 do
			_handlerListHead = _handlerListHead._next
		end

		if _handlerListHead then
			_handlerListHead._next = p1._next
		end
	end

	if not _signal.connectionsChanged then
		return
	end

	_signal.totalConnections = _signal.totalConnections - 1
	_signal.connectionsChanged:Fire(-1)
end
setmetatable(t, {
	__index = function(p1, p2) --[[ __index | Line: 94 ]]
		error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p2))), 2)
	end,
	__newindex = function(p1, p2, p3) --[[ __newindex | Line: 97 ]]
		error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p2))), 2)
	end
})

local t3 = {}

t3.__index = t3
function t3.new(p1) --[[ new | Line: 106 | Upvalues: t3 (copy) ]]
	local v2 = setmetatable({
		_handlerListHead = false
	}, t3)

	if p1 then
		v2.totalConnections = 0
		v2.connectionsChanged = t3.new()
	end

	return v2
end
function t3.Connect(p1, p2) --[[ Connect | Line: 117 | Upvalues: t (copy) ]]
	local v1 = t.new(p1, p2)

	if p1._handlerListHead then
		v1._next = p1._handlerListHead
	end

	p1._handlerListHead = v1

	if not p1.connectionsChanged then
		return v1
	end

	p1.totalConnections = p1.totalConnections + 1
	p1.connectionsChanged:Fire(1)

	return v1
end
function t3.DisconnectAll(p1) --[[ DisconnectAll | Line: 135 ]]
	p1._handlerListHead = false

	if not p1.connectionsChanged then
		return
	end

	p1.connectionsChanged:Fire(-p1.totalConnections)
	p1.connectionsChanged:Destroy()
	p1.connectionsChanged = nil
	p1.totalConnections = 0
end
t3.Destroy = t3.DisconnectAll
t3.destroy = t3.DisconnectAll
function t3.Fire(p1, ...) --[[ Fire | Line: 152 | Upvalues: v1 (ref), runEventHandlerInFreeThread (copy) ]]
	local _handlerListHead = p1._handlerListHead

	while _handlerListHead do
		if _handlerListHead._connected then
			if not v1 then
				v1 = coroutine.create(runEventHandlerInFreeThread)
			end

			task.spawn(v1, _handlerListHead._fn, ...)
		end

		_handlerListHead = _handlerListHead._next
	end
end
function t3.Wait(p1) --[[ Wait | Line: 167 ]]
	local v1 = coroutine.running()
	local v2 = nil

	v2 = p1:Connect(function(...) --[[ Line: 170 | Upvalues: v2 (ref), v1 (copy) ]]
		v2:Disconnect()
		task.spawn(v1, ...)
	end)

	return coroutine.yield()
end

return t3