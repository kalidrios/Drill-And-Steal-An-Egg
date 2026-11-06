-- https://github.com/kalidrios

local m_Variables = require(script.Parent.Parent.Variables);
return function(p1, p2) -- Line: 6
	--[[
		Upvalues:
			[1] = m_Variables
	--]]
	local v1 = p2 or m_Variables.HugeMachineMaxPetPoints - 1;
	local v2 = nil;
	for _, val1 in ipairs(m_Variables.HugeMachineUseProducts) do
		if val1.pointsMin > p1 or v2 and v2.pointsMin >= val1.pointsMin or p1 > val1.pointsMax + v1 then continue end
		v2 = val1;
	end
	return v2;
end;
