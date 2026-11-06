-- https://github.com/kalidrios

local m_GetPetEgg = require(script.Parent.GetPetEgg);
return function(p1) -- Line: 6
	--[[
		Upvalues:
			[1] = m_GetPetEgg
	--]]
	return m_GetPetEgg(p1) ~= nil;
end;
