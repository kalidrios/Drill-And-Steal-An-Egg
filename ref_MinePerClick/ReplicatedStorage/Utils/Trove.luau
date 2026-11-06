-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = newproxy()
local v2 = newproxy()
local t = { "Destroy", "Disconnect", "destroy", "disconnect" }
local RunService = game:GetService("RunService")

local function GetObjectCleanupFunction(p1, p2) --[[ GetObjectCleanupFunction | Line: 11 | Upvalues: v1 (copy), v2 (copy), t (copy) ]]
	local v12 = typeof(p1)

	if v12 == "function" then
		return v1
	end

	if v12 == "thread" then
		return v2
	end

	if p2 then
		return p2
	end

	if v12 == "Instance" then
		return "Destroy"
	end

	if v12 == "RBXScriptConnection" then
		return "Disconnect"
	end

	if v12 == "table" then
		for v22, v3 in t do
			if typeof(p1[v3]) == "function" then
				return v3
			end
		end
	end

	error("Failed to get cleanup function for object " .. v12 .. ": " .. tostring(p1), 3)
end

local function AssertPromiseLike(p1) --[[ AssertPromiseLike | Line: 35 ]]
	if typeof(p1) == "table" and (typeof(p1.getStatus) == "function" and (typeof(p1.finally) == "function" and typeof(p1.cancel) == "function")) then
		return
	end

	error("Did not receive a Promise as an argument", 3)
end

local t2 = {}

t2.__index = t2
function t2.new() --[[ new | Line: 58 | Upvalues: t2 (copy) ]]
	local v2 = setmetatable({}, t2)

	v2._objects = {}
	v2._cleaning = false

	return v2
end
function t2.Extend(p1) --[[ Extend | Line: 84 | Upvalues: t2 (copy) ]]
	if not p1._cleaning then
		return p1:Construct(t2)
	end

	error("Cannot call trove:Extend() while cleaning", 2)
end
function t2.Clone(p1, p2) --[[ Clone | Line: 95 ]]
	if not p1._cleaning then
		return p1:Add(p2:Clone())
	end

	error("Cannot call trove:Clone() while cleaning", 2)
end
function t2.Construct(p1, p2, ...) --[[ Construct | Line: 135 ]]
	if p1._cleaning then
		error("Cannot call trove:Construct() while cleaning", 2)
	end

	local v1 = nil
	local v2 = type(p2)

	if v2 == "table" then
		v1 = p2.new(...)
	elseif v2 == "function" then
		v1 = p2(...)
	end

	return p1:Add(v1)
end
function t2.Connect(p1, p2, p3) --[[ Connect | Line: 164 ]]
	if not p1._cleaning then
		return p1:Add(p2:Connect(p3))
	end

	error("Cannot call trove:Connect() while cleaning", 2)
end
function t2.BindToRenderStep(p1, p2, p3, p4) --[[ BindToRenderStep | Line: 184 | Upvalues: RunService (copy) ]]
	if p1._cleaning then
		error("Cannot call trove:BindToRenderStep() while cleaning", 2)
	end

	RunService:BindToRenderStep(p2, p3, p4)
	p1:Add(function() --[[ Line: 189 | Upvalues: RunService (ref), p2 (copy) ]]
		RunService:UnbindFromRenderStep(p2)
	end)
end
function t2.AddPromise(p1, p2) --[[ AddPromise | Line: 217 ]]
	if p1._cleaning then
		error("Cannot call trove:AddPromise() while cleaning", 2)
	end

	if typeof(p2) == "table" and (typeof(p2.getStatus) == "function" and typeof(p2.finally) == "function") then
		if typeof(p2.cancel) ~= "function" then
			error("Did not receive a Promise as an argument", 3)
		end
	else
		error("Did not receive a Promise as an argument", 3)
	end

	if p2:getStatus() == "Started" then
		p2:finally(function() --[[ Line: 223 | Upvalues: p1 (copy), p2 (copy) ]]
			if not p1._cleaning then
				p1:_findAndRemoveFromObjects(p2, false)
			end
		end)
		p1:Add(p2, "cancel")
	end

	return p2
end
function t2.Add(p1, p2, p3) --[[ Add | Line: 282 | Upvalues: GetObjectCleanupFunction (copy) ]]
	if not p1._cleaning then
		local v1, v2

		v1 = GetObjectCleanupFunction(p2, p3)
		v2 = p1._objects
		table.insert(v2, { p2, v1 })

		return p2
	end

	error("Cannot call trove:Add() while cleaning", 2)
end
function t2.Remove(p1, p2) --[[ Remove | Line: 301 ]]
	if not p1._cleaning then
		return p1:_findAndRemoveFromObjects(p2, true)
	end

	error("Cannot call trove:Remove() while cleaning", 2)
end
function t2.Clean(p1) --[[ Clean | Line: 314 ]]
	if p1._cleaning then
		return
	end

	p1._cleaning = true

	for v1, v2 in p1._objects do
		p1:_cleanupObject(v2[1], v2[2])
	end

	table.clear(p1._objects)
	p1._cleaning = false
end
function t2._findAndRemoveFromObjects(p1, p2, p3) --[[ _findAndRemoveFromObjects | Line: 326 ]]
	local _objects = p1._objects

	for i, v in ipairs(_objects) do
		if v[1] == p2 then
			local v1 = #_objects

			_objects[i] = _objects[v1]
			_objects[v1] = nil

			if not p3 then
				return true
			end

			p1:_cleanupObject(v[1], v[2])

			return true
		end
	end

	return false
end
function t2._cleanupObject(p1, p2, p3) --[[ _cleanupObject | Line: 342 | Upvalues: v1 (copy), v2 (copy) ]]
	if p3 == v1 then
		p2()

		return
	end

	if p3 == v2 then
		pcall(task.cancel, p2)
	else
		p2[p3](p2)
	end
end
function t2.AttachToInstance(p1, p2) --[[ AttachToInstance | Line: 365 ]]
	if p1._cleaning then
		error("Cannot call trove:AttachToInstance() while cleaning", 2)
	elseif not p2:IsDescendantOf(game) then
		error("Instance is not a descendant of the game hierarchy", 2)
	end

	return p1:Connect(p2.Destroying, function() --[[ Line: 371 | Upvalues: p1 (copy) ]]
		p1:Destroy()
	end)
end
function t2.Destroy(p1) --[[ Destroy | Line: 379 ]]
	p1:Clean()
end

return t2