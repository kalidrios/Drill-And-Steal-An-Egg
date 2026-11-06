-- https://github.com/kalidrios

local m_IsNaN = require(script.Parent.IsNaN);
local m_IsInf = require(script.Parent.IsInf);
return function(p1) -- Line: 10
	--[[
		Upvalues:
			[1] = m_IsNaN
			[2] = m_IsInf
	--]]
	return not m_IsNaN(p1) and not m_IsInf(p1);
end;
