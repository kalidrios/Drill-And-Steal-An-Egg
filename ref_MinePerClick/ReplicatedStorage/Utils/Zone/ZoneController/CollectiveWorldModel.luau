-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local v1 = nil
local RunService = game:GetService("RunService")

function t.setupWorldModel(p1) --[[ setupWorldModel | Line: 8 | Upvalues: v1 (ref), RunService (copy) ]]
	if v1 then
		return v1
	end

	local v12 = if RunService:IsClient() then "ReplicatedStorage" else "ServerStorage"

	v1 = Instance.new("WorldModel")
	v1.Name = "ZonePlusWorldModel"
	v1.Parent = game:GetService(v12)

	return v1
end
function t._getCombinedResults(p1, p2, ...) --[[ _getCombinedResults | Line: 22 | Upvalues: v1 (ref) ]]
	local v12 = workspace[p2](workspace, ...)

	if v1 then
		for k, v in pairs((v1[p2](v1, ...))) do
			table.insert(v12, v)
		end
	end

	return v12
end
function t.GetPartBoundsInBox(p1, p2, p3, p4) --[[ GetPartBoundsInBox | Line: 33 ]]
	return p1:_getCombinedResults("GetPartBoundsInBox", p2, p3, p4)
end
function t.GetPartBoundsInRadius(p1, p2, p3, p4) --[[ GetPartBoundsInRadius | Line: 37 ]]
	return p1:_getCombinedResults("GetPartBoundsInRadius", p2, p3, p4)
end
function t.GetPartsInPart(p1, p2, p3) --[[ GetPartsInPart | Line: 41 ]]
	return p1:_getCombinedResults("GetPartsInPart", p2, p3)
end

return t