-- https://github.com/kalidrios

local m_Erfc = require(script.Parent.Erfc);
return function(p1, p2, p3) -- Line: 11
	--[[
		Upvalues:
			[1] = m_Erfc
	--]]
	local v1 = p1 - p2;
	if math.abs(v1) > p3 * 40 then
		if v1 < 0 then
			return 0;
		end
		return 1;
	end
	return m_Erfc(-v1 / (p3 * 1.4142135623730951)) * 0.5;
end;
