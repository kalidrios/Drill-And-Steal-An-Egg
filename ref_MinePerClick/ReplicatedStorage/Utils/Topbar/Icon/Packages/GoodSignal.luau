-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = nil

local function acquireRunnerThreadAndCallEventHandler(p1, ...) --[[ acquireRunnerThreadAndCallEventHandler | Line: 34 | Upvalues: v1 (ref) ]]
	local v12 = v1

	v1 = nil
	p1(...)
	v1 = v12
end

local function runEventHandlerInFreeThread() --[[ runEventHandlerInFreeThread | Line: 45 | Upvalues: acquireRunnerThreadAndCallEventHandler (copy) ]]
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local t = {}

t.__index = t
function t.new(p1, p2) --[[ new | Line: 60 | Upvalues: t (copy) ]]
	return setmetatable({
		_connected = true,
		_next = false,
		_signal = p1,
		_fn = p2
	}, t)
end
function t.Disconnect(p1) --[[ Disconnect | Line: 69 ]]
	p1._connected = false

	if p1._signal._handlerListHead == p1 then
		p1._signal._handlerListHead = p1._next

		return
	end

	local _handlerListHead = p1._signal._handlerListHead

	while _handlerListHead and _handlerListHead._next ~= p1 do
		_handlerListHead = _handlerListHead._next
	end

	if not _handlerListHead then
		return
	end

	_handlerListHead._next = p1._next
end
t.Destroy = t.Disconnect
setmetatable(t, {
	__index = function(p1, p2) --[[ __index | Line: 92 ]]
		error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p2))), 2)
	end,
	__newindex = function(p1, p2, p3) --[[ __newindex | Line: 95 ]]
		error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p2))), 2)
	end
})

local t3 = {}

t3.__index = t3
function t3.new() --[[ new | Line: 104 | Upvalues: t3 (copy) ]]
	return setmetatable({
		_handlerListHead = false
	}, t3)
end
function t3.Connect(p1, p2) --[[ Connect | Line: 110 | Upvalues: t (copy) ]]
	local v1 = t.new(p1, p2)

	if p1._handlerListHead then
		v1._next = p1._handlerListHead
	end

	p1._handlerListHead = v1

	return v1
end
function t3.DisconnectAll(p1) --[[ DisconnectAll | Line: 123 ]]
	p1._handlerListHead = false
end
t3.Destroy = t3.DisconnectAll
function t3.Fire(p1, ...) --[[ Fire | Line: 132 | Upvalues: v1 (ref), runEventHandlerInFreeThread (copy) ]]
	local _handlerListHead = p1._handlerListHead

	while _handlerListHead do
		if _handlerListHead._connected then
			if not v1 then
				v1 = coroutine.create(runEventHandlerInFreeThread)
				coroutine.resume(v1)
			end

			task.spawn(v1, _handlerListHead._fn, ...)
		end

		_handlerListHead = _handlerListHead._next
	end
end
function t3.Wait(p1) --[[ Wait | Line: 149 ]]
	local v1 = coroutine.running()
	local v2 = nil

	v2 = p1:Connect(function(...) --[[ Line: 152 | Upvalues: v2 (ref), v1 (copy) ]]
		v2:Disconnect()
		task.spawn(v1, ...)
	end)

	return coroutine.yield()
end
function t3.Once(p1, p2) --[[ Once | Line: 161 ]]
	local v1 = nil

	v1 = p1:Connect(function(...) --[[ Line: 163 | Upvalues: v1 (ref), p2 (copy) ]]
		if not v1._connected then
			p2(...)

			return
		end

		v1:Disconnect()
		p2(...)
	end)

	return v1
end
setmetatable(t3, {
	__index = function(p1, p2) --[[ __index | Line: 174 ]]
		error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p2))), 2)
	end,
	__newindex = function(p1, p2, p3) --[[ __newindex | Line: 177 ]]
		error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p2))), 2)
	end
})

return t3