-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")

game:GetService("ReplicatedStorage")

if RunService:IsServer() then
	return {
		apply = function(p1, p2) --[[ apply | Line: 7 ]]
			local v1 = ("Gradients_%*"):format(p2)

			p1:AddTag(v1)

			return function() --[[ Line: 11 | Upvalues: p1 (copy), v1 (copy) ]]
				p1:RemoveTag(v1)
			end
		end
	}
end

local Observers = require(script.Parent:WaitForChild("Observers"))
local t = {}
local tbl = {}

for i, v in ipairs(script.Effects:GetChildren()) do
	t[v.Name] = require(v)
	tbl[v.Name] = {}
end

local function applyEffect(p1, p2) --[[ applyEffect | Line: 28 | Upvalues: t (copy), tbl (copy) ]]
	assert(if typeof(p2) == "string" then true else false, "Effect name must be a string")

	local v3 = assert(t[p2], "Effect not found").apply(p1, p2)
	local t2 = {
		main = v3.main,
		stroke = v3.stroke
	}
	local v4 = tbl[p2]

	table.insert(v4, t2)

	local v5 = nil

	local function cleanup() --[[ cleanup | Line: 39 | Upvalues: v5 (ref), tbl (ref), p2 (copy), t2 (copy), v3 (ref) ]]
		if v5 then
			v5:Disconnect()
			v5 = nil
		end

		local v1 = table.find(tbl[p2], t2)

		if v1 then
			table.remove(tbl[p2], v1)
		end

		if not (v3 and v3.cleanup) then
			return
		end

		v3.cleanup()
		v3 = nil
	end

	v5 = p1.Destroying:Connect(cleanup)

	return cleanup
end

RunService.PostSimulation:Connect(function(p1) --[[ Line: 61 | Upvalues: tbl (copy), t (copy) ]]
	debug.profilebegin("Gradients:Simulate")

	for k, v in pairs(tbl) do
		if #v ~= 0 then
			debug.profilebegin(k)
			debug.profilebegin("Simulate")

			local v1 = t[k].simulate(p1)

			debug.profileend()
			debug.profilebegin("Apply")

			for i, v2 in ipairs(v) do
				v2.main.Color = v1.main

				if v2.stroke and v1.stroke then
					v2.stroke.Color = v1.stroke
				end
			end

			debug.profileend()
			debug.profileend()
		end
	end

	debug.profileend()
end)

for k in pairs(tbl) do
	Observers.observeTag(("Gradients_%*"):format(k), function(p1) --[[ Line: 87 | Upvalues: applyEffect (copy), k (copy) ]]
		return applyEffect(p1, k)
	end)
end

return {
	apply = applyEffect
}