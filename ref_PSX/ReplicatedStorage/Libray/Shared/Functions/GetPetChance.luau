-- https://github.com/kalidrios

local m_GetPetEgg = require(script.Parent.GetPetEgg);
local m_Variables = require(script.Parent.Parent.Variables);
return function(p1) -- Line: 7
	--[[
		Upvalues:
			[1] = m_GetPetEgg
			[2] = m_Variables
	--]]
	local v1, v2 = m_GetPetEgg(p1);
	if v1 and v2 then
		local v3 = 0;
		local v4 = 0;
		for _, val1 in ipairs(v2.drops) do
			if val1[3] and not m_Variables.IsHardcore then continue end
			v3 = v3 + val1[2];
			if val1[1] ~= p1 then continue end
			v4 = val1[2];
		end
		return v4 / v3;
	end
	return nil;
end;
