-- https://github.com/kalidrios

local m_DegDeltaUnsafe = require(script.Parent.DegDeltaUnsafe);
local m_DegNorm = require(script.Parent.DegNorm);
return function(p1, p2) -- Line: 10
	--[[
		Upvalues:
			[1] = m_DegDeltaUnsafe
			[2] = m_DegNorm
	--]]
	return Vector3.new(m_DegDeltaUnsafe(m_DegNorm(p1.X), m_DegNorm(p2.X)), m_DegDeltaUnsafe(m_DegNorm(p1.Y), m_DegNorm(p2.Y)), m_DegDeltaUnsafe(m_DegNorm(p1.Z), m_DegNorm(p2.Z)));
end;
