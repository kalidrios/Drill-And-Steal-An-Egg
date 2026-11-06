-- https://github.com/kalidrios

local m_RadDeltaUnsafe = require(script.Parent.RadDeltaUnsafe);
local m_RadNorm = require(script.Parent.RadNorm);
return function(p1, p2) -- Line: 10
	--[[
		Upvalues:
			[1] = m_RadDeltaUnsafe
			[2] = m_RadNorm
	--]]
	return m_RadDeltaUnsafe(m_RadNorm(p1), m_RadNorm(p2));
end;
