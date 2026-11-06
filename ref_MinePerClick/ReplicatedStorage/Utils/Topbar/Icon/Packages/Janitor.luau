-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Heartbeat = game:GetService("RunService").Heartbeat

local function getPromiseReference() --[[ getPromiseReference | Line: 26 ]]
	return false
end

local v1 = newproxy(true)

getmetatable(v1).__tostring = function() --[[ Line: 31 ]]
	return "IndicesReference"
end

local v2 = newproxy(true)

getmetatable(v2).__tostring = function() --[[ Line: 36 ]]
	return "LinkToInstanceIndex"
end

local t = {
	IGNORE_MEMORY_DEBUG = true,
	ClassName = "Janitor",
	__index = {
		CurrentlyCleaning = true,
		[v1] = nil
	}
}
local t2 = {
	["function"] = true,
	Promise = "cancel",
	RBXScriptConnection = "Disconnect"
}

function t.new() --[[ new | Line: 58 | Upvalues: v1 (copy), t (copy) ]]
	return setmetatable({
		CurrentlyCleaning = false,
		[v1] = nil
	}, t)
end
function t.Is(p1) --[[ Is | Line: 65 | Upvalues: t (copy) ]]
	return if type(p1) == "table" then getmetatable(p1) == t else false
end
t.is = t.Is

local function Add(p1, p2, p3, p4) --[[ Add | Line: 71 | Upvalues: v1 (copy), t2 (copy) ]]
	if p4 then
		p1:Remove(p4)

		local v12 = p1[v1]

		if not v12 then
			v12 = {}
			p1[v1] = v12
		end

		v12[p4] = p2
	end

	local v2 = typeof(p2)

	if v2 == "table" and string.match(tostring(p2), "Promise") then
		v2 = "Promise"
	end

	local v3 = if p3 then p3 else t2[v2] or "Destroy"

	if type(p2) ~= "function" and not p2[v3] then
		warn(string.format("Object %s doesn\'t have method %s, are you sure you want to add it? Traceback: %s", tostring(p2), tostring(v3), debug.traceback(nil, 2)))
	end

	p1[p2] = { v3, (debug.traceback("")) }

	return p2
end

t.__index.Add = Add
t.__index.Give = t.__index.Add

local function AddPromise(p1, p2) --[[ AddPromise | Line: 103 ]]
	local v1 = false

	if not v1 then
		return p2
	end

	if not v1.is(p2) then
		error(string.format("Invalid argument #1 to \'Janitor:AddPromise\' (Promise expected, got %s (%s))", typeof(p2), (tostring(p2))))
	end

	if p2:getStatus() == v1.Status.Started then
		local v2 = newproxy(false)
		local v3 = p1:Add(v1.new(function(p1, p22, p3) --[[ Line: 111 | Upvalues: p2 (copy) ]]
			if not p3(function() --[[ Line: 112 | Upvalues: p2 (ref) ]]
				p2:cancel()
			end) then
				p1(p2)
			end
		end), "cancel", v2)

		v3:finallyCall(p1.Remove, p1, v2)

		return v3
	end

	return p2
end

t.__index.AddPromise = AddPromise
t.__index.GivePromise = t.__index.AddPromise

local function AddObject(p1, p2) --[[ AddObject | Line: 133 ]]
	local v1 = newproxy(false)
	local v2 = false

	if v2 and v2.is(p2) then
		if p2:getStatus() == v2.Status.Started then
			local v3 = p1:Add(v2.resolve(p2), "cancel", v1)

			v3:finallyCall(p1.Remove, p1, v1)

			return v3, v1
		end

		return p2
	end

	return p1:Add(p2, false, v1), v1
end

t.__index.AddObject = AddObject
t.__index.GiveObject = t.__index.AddObject

local function Remove(p1, p2) --[[ Remove | Line: 151 | Upvalues: v1 (copy) ]]
	local v12 = p1[v1]

	if v12 then
		local v2 = v12[p2]

		if v2 then
			local v3 = p1[v2]
			local v4 = if v3 then v3[1] else v3

			if v4 then
				if v4 == true then
					v2()
				else
					local v5 = v2[v4]

					if v5 then
						v5(v2)
					end
				end

				p1[v2] = nil
			end

			v12[p2] = nil
		end
	end

	return p1
end

t.__index.Remove = Remove

local function Get(p1, p2) --[[ Get | Line: 180 | Upvalues: v1 (copy) ]]
	local v12 = p1[v1]

	if v12 then
		return v12[p2]
	end

	return nil
end

t.__index.Get = Get

local function Cleanup(p1) --[[ Cleanup | Line: 188 | Upvalues: v1 (copy) ]]
	if p1.CurrentlyCleaning then
		return
	end

	p1.CurrentlyCleaning = nil

	for v12, v2 in next, p1 do
		if v12 ~= v1 then
			local v3 = type(v12)

			if v3 == "string" or v3 == "number" then
				p1[v12] = nil

				continue
			end

			local v4 = v2[1]
			local v5 = v2[2]

			local function warnUser(p1) --[[ warnUser | Line: 205 | Upvalues: v5 (copy) ]]
				local v1 = debug.traceback("", 3)

				warn("-------- Janitor Error --------" .. "\n" .. tostring(p1) .. "\n" .. v1 .. "" .. v5)
			end

			if v4 == true then
				local ok, result = pcall(v12)

				if not ok then
					local v6 = debug.traceback("", 3)

					warn("-------- Janitor Error --------" .. "\n" .. tostring(result) .. "\n" .. v6 .. "" .. v5)
				end
			else
				local v7 = v12[v4]

				if v7 then
					local ok, result = pcall(v7, v12)

					if not (ok or (if typeof(v12) == "Instance" then v7 == "Destroy" else false)) then
						local v9 = debug.traceback("", 3)

						warn("-------- Janitor Error --------" .. "\n" .. tostring(result) .. "\n" .. v9 .. "" .. v5)
					end
				end
			end

			p1[v12] = nil
		end
	end

	local v10 = p1[v1]

	if v10 then
		for v11 in next, v10 do
			v10[v11] = nil
		end

		p1[v1] = {}
	end

	p1.CurrentlyCleaning = false
end

t.__index.Cleanup = Cleanup
t.__index.Clean = t.__index.Cleanup

local function Destroy(p1) --[[ Destroy | Line: 244 ]]
	p1:Cleanup()
end

t.__index.Destroy = Destroy
t.__call = t.__index.Cleanup

local t3 = {
	Connected = true
}

t3.__index = t3
function t3.Disconnect(p1) --[[ Disconnect | Line: 254 ]]
	if not p1.Connected then
		return
	end

	p1.Connected = false
	p1.Connection:Disconnect()
end
function t3.__tostring(p1) --[[ __tostring | Line: 261 ]]
	return "Disconnect<" .. tostring(p1.Connected) .. ">"
end

local function LinkToInstance(p1, p2, p3) --[[ LinkToInstance | Line: 265 | Upvalues: v2 (copy), t3 (copy), Heartbeat (copy) ]]
	local v1 = nil
	local v22 = p3 and newproxy(false) or v2
	local v3 = if p2.Parent == nil then true else false
	local v5 = setmetatable({}, t3)

	local function ChangedFunction(p12, p2) --[[ ChangedFunction | Line: 271 | Upvalues: v5 (copy), v3 (ref), Heartbeat (ref), v1 (ref), p1 (copy) ]]
		if not v5.Connected then
			return
		end

		v3 = p2 == nil

		if not v3 then
			return
		end

		coroutine.wrap(function() --[[ Line: 277 | Upvalues: Heartbeat (ref), v5 (ref), v1 (ref), p1 (ref), v3 (ref) ]]
			Heartbeat:Wait()

			if not v5.Connected then
				return
			end

			if v1.Connected then
				while v3 and (v1.Connected and v5.Connected) do
					Heartbeat:Wait()
				end

				if not (v5.Connected and v3) then
					return
				end
			end

			p1:Cleanup()
		end)()
	end

	v1 = p2.AncestryChanged:Connect(ChangedFunction)
	v5.Connection = v1

	if v3 then
		local v6 = p2.Parent

		if v5.Connected then
			v3 = if v6 == nil then true else false

			if v3 then
				coroutine.wrap(function() --[[ Line: 277 | Upvalues: Heartbeat (ref), v5 (copy), v1 (ref), p1 (copy), v3 (ref) ]]
					Heartbeat:Wait()

					if not v5.Connected then
						return
					end

					if v1.Connected then
						while v3 and (v1.Connected and v5.Connected) do
							Heartbeat:Wait()
						end

						if not (v5.Connected and v3) then
							return
						end
					end

					p1:Cleanup()
				end)()
			end
		end
	end

	return p1:Add(v5, "Disconnect", v22)
end

t.__index.LinkToInstance = LinkToInstance

local function LinkToInstances(p1, ...) --[[ LinkToInstances | Line: 308 | Upvalues: t (copy) ]]
	local v1 = t.new()

	for i, v in ipairs({ ... }) do
		v1:Add(p1:LinkToInstance(v, true), "Disconnect")
	end

	return v1
end

t.__index.LinkToInstances = LinkToInstances

for v3, v4 in next, t.__index do
	local v5 = string.lower(v3)

	t.__index[string.sub(v5, 1, 1) .. string.sub(v3, 2)] = v4
end

return t