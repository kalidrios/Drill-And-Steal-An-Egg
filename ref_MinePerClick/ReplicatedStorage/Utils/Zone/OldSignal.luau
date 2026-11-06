-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local Heartbeat = game:GetService("RunService").Heartbeat
local t = {}

t.__index = t
t.ClassName = "Signal"
t.totalConnections = 0
function t.new(p1) --[[ new | Line: 12 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)

	if p1 then
		v2.connectionsChanged = t.new()
	end

	v2.connections = {}
	v2.totalConnections = 0
	v2.waiting = {}
	v2.totalWaiting = 0

	return v2
end
function t.Fire(p1, ...) --[[ Fire | Line: 30 ]]
	for k, v in pairs(p1.connections) do
		task.spawn(v.Handler, ...)
	end

	if not (p1.totalWaiting > 0) then
		return
	end

	local v1 = table.pack(...)

	for k, v in pairs(p1.waiting) do
		p1.waiting[k] = v1
	end
end
t.fire = t.Fire
function t.Connect(p1, p2) --[[ Connect | Line: 44 | Upvalues: HttpService (copy) ]]
	if type(p2) ~= "function" then
		error(("connect(%s)"):format((typeof(p2))), 2)
	end

	local v1 = HttpService:GenerateGUID(false)
	local t = {
		Connected = true,
		ConnectionId = v1,
		Handler = p2
	}

	p1.connections[v1] = t
	function t.Disconnect(p12) --[[ Disconnect | Line: 57 | Upvalues: p1 (copy), v1 (copy), t (copy) ]]
		p1.connections[v1] = nil
		t.Connected = false

		local v12 = p1

		v12.totalConnections = v12.totalConnections - 1

		if not p1.connectionsChanged then
			return
		end

		p1.connectionsChanged:Fire(-1)
	end
	t.Destroy = t.Disconnect
	t.destroy = t.Disconnect
	t.disconnect = t.Disconnect
	p1.totalConnections = p1.totalConnections + 1

	if not p1.connectionsChanged then
		return t
	end

	p1.connectionsChanged:Fire(1)

	return t
end
t.connect = t.Connect
function t.Wait(p1) --[[ Wait | Line: 77 | Upvalues: HttpService (copy), Heartbeat (copy) ]]
	local v1 = HttpService:GenerateGUID(false)

	p1.waiting[v1] = true
	p1.totalWaiting = p1.totalWaiting + 1

	repeat
		Heartbeat:Wait()
	until p1.waiting[v1] ~= true

	p1.totalWaiting = p1.totalWaiting - 1

	local v2 = p1.waiting[v1]

	p1.waiting[v1] = nil

	return unpack(v2)
end
t.wait = t.Wait
function t.Destroy(p1) --[[ Destroy | Line: 89 ]]
	if p1.bindableEvent then
		p1.bindableEvent:Destroy()
		p1.bindableEvent = nil
	end

	if p1.connectionsChanged then
		p1.connectionsChanged:Fire(-p1.totalConnections)
		p1.connectionsChanged:Destroy()
		p1.connectionsChanged = nil
	end

	p1.totalConnections = 0

	for k, v in pairs(p1.connections) do
		p1.connections[k] = nil
	end
end
t.destroy = t.Destroy
t.Disconnect = t.Destroy
t.disconnect = t.Destroy

return t