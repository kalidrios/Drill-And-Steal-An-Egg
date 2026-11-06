-- https://github.com/kalidrios

local m_RadDeltaUnsafe = require(script.Parent.RadDeltaUnsafe);
local m_RadNorm = require(script.Parent.RadNorm);
return function(p1, p2) -- Line: 11
	--[[
		Upvalues:
			[1] = m_RadDeltaUnsafe
			[2] = m_RadNorm
	--]]
	return Vector3.new(m_RadDeltaUnsafe(m_RadNorm(p1.X), m_RadNorm(p2.X)), m_RadDeltaUnsafe(m_RadNorm(p1.Y), m_RadNorm(p2.Y)), m_RadDeltaUnsafe(m_RadNorm(p1.Z), m_RadNorm(p2.Z)));
end;
