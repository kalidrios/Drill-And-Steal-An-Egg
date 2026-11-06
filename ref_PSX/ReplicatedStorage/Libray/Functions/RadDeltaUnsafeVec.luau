-- https://github.com/kalidrios

local m_RadDeltaUnsafe = require(script.Parent.RadDeltaUnsafe);
return function(p1, p2) -- Line: 9
	--[[
		Upvalues:
			[1] = m_RadDeltaUnsafe
	--]]
	return Vector3.new(m_RadDeltaUnsafe(p1.X, p2.X), m_RadDeltaUnsafe(p1.Y, p2.Y), m_RadDeltaUnsafe(p1.Z, p2.Z));
end;
