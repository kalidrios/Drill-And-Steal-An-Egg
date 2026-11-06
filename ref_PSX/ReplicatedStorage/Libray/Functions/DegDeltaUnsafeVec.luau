-- https://github.com/kalidrios

local m_DegDeltaUnsafe = require(script.Parent.DegDeltaUnsafe);
return function(p1, p2) -- Line: 9
	--[[
		Upvalues:
			[1] = m_DegDeltaUnsafe
	--]]
	return Vector3.new(m_DegDeltaUnsafe(p1.X, p2.X), m_DegDeltaUnsafe(p1.Y, p2.Y), m_DegDeltaUnsafe(p1.Z, p2.Z));
end;
