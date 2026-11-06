-- https://github.com/kalidrios

local m_IsFinite = require(script.Parent.IsFinite);
return function(p1) -- Line: 5
	--[[
		Upvalues:
			[1] = m_IsFinite
	--]]
	return m_IsFinite(p1.X) and m_IsFinite(p1.Y) and m_IsFinite(p1.Z);
end;
