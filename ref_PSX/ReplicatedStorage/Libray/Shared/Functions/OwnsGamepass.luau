-- https://github.com/kalidrios

local m_GetSave = require(script.Parent.GetSave);
return function(p1, p2) -- Line: 5
	--[[
		Upvalues:
			[1] = m_GetSave
	--]]
	local v1 = m_GetSave(p1);
	if not v1 then
		return false;
	end
	return table.find(v1.Gamepasses, p2) ~= nil;
end;
