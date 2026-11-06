-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local v1 = nil

local function AcquireRunnerThreadAndCallEventHandler(p1, ...) --[[ AcquireRunnerThreadAndCallEventHandler | Line: 60 | Upvalues: v1 (ref) ]]
	local v12 = v1

	v1 = nil
	p1(...)
	v1 = v12
end

local function RunEventHandlerInFreeThread(...) --[[ RunEventHandlerInFreeThread | Line: 68 | Upvalues: AcquireRunnerThreadAndCallEventHandler (copy) ]]
	AcquireRunnerThreadAndCallEventHandler(...)

	while true do
		AcquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local t2 = {
	Disconnect = function(p1) --[[ Disconnect | Line: 88 | Upvalues: v1 (ref), RunEventHandlerInFreeThread (copy) ]]
		local _listener = p1._listener

		if _listener ~= nil then
			local _listener_table = p1._listener_table
			local v12 = table.find(_listener_table, _listener)

			if v12 ~= nil then
				table.remove(_listener_table, v12)
			end

			p1._listener = nil
		end

		if p1._disconnect_listener == nil then
			return
		end

		if not v1 then
			v1 = coroutine.create(RunEventHandlerInFreeThread)
		end

		task.spawn(v1, p1._disconnect_listener, p1._disconnect_param)
		p1._disconnect_listener = nil
	end
}

function t.NewArrayScriptConnection(p1, p2, p3, p4) --[[ NewArrayScriptConnection | Line: 107 | Upvalues: t2 (copy) ]]
	return {
		_listener = p2,
		_listener_table = p1,
		_disconnect_listener = p3,
		_disconnect_param = p4,
		Disconnect = t2.Disconnect
	}
end

local t3 = {}

t3.__index = t3
function t3.Disconnect(p1) --[[ Disconnect | Line: 132 | Upvalues: v1 (ref), RunEventHandlerInFreeThread (copy) ]]
	if p1._is_connected == false then
		return
	end

	p1._is_connected = false

	local _script_signal = p1._script_signal

	_script_signal._listener_count = _script_signal._listener_count - 1

	if p1._script_signal._head == p1 then
		p1._script_signal._head = p1._next
	else
		local _head = p1._script_signal._head

		while _head ~= nil and _head._next ~= p1 do
			_head = _head._next
		end

		if _head ~= nil then
			_head._next = p1._next
		end
	end

	if p1._disconnect_listener == nil then
		return
	end

	if not v1 then
		v1 = coroutine.create(RunEventHandlerInFreeThread)
	end

	task.spawn(v1, p1._disconnect_listener, p1._disconnect_param)
	p1._disconnect_listener = nil
end

local t4 = {}

t4.__index = t4
function t4.Connect(p1, p2, p3, p4) --[[ Connect | Line: 173 | Upvalues: t3 (copy) ]]
	local t = {
		_is_connected = true,
		_listener = p2,
		_script_signal = p1,
		_disconnect_listener = p3,
		_disconnect_param = p4,
		_next = p1._head
	}

	setmetatable(t, t3)
	p1._head = t
	p1._listener_count = p1._listener_count + 1

	return t
end
function t4.GetListenerCount(p1) --[[ GetListenerCount | Line: 193 ]]
	return p1._listener_count
end
function t4.Fire(p1, ...) --[[ Fire | Line: 197 | Upvalues: v1 (ref), RunEventHandlerInFreeThread (copy) ]]
	local _head = p1._head

	while _head ~= nil do
		if _head._is_connected == true then
			if not v1 then
				v1 = coroutine.create(RunEventHandlerInFreeThread)
			end

			task.spawn(v1, _head._listener, ...)
		end

		_head = _head._next
	end
end
function t4.FireUntil(p1, p2, ...) --[[ FireUntil | Line: 210 ]]
	local _head = p1._head

	while _head ~= nil do
		if _head._is_connected == true then
			_head._listener(...)

			if p2() ~= true then
				break
			end
		end

		_head = _head._next
	end
end
function t.NewScriptSignal() --[[ NewScriptSignal | Line: 223 | Upvalues: t4 (copy) ]]
	return {
		_head = nil,
		_listener_count = 0,
		Connect = t4.Connect,
		GetListenerCount = t4.GetListenerCount,
		Fire = t4.Fire,
		FireUntil = t4.FireUntil
	}
end

return t