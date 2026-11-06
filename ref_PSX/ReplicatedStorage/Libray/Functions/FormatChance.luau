-- https://github.com/kalidrios

local m_FormatOdds = require(script.Parent.FormatOdds);
local m_FormatPercent = require(script.Parent.FormatPercent);
return function(p1, p2) -- Line: 19
	--[[
		Upvalues:
			[1] = m_FormatOdds
			[2] = m_FormatPercent
	--]]
	local math_clamp_ret = math.clamp(p2 or p1, 0, 1);
	p1 = math.clamp(p1, 0, 1);
	if math_clamp_ret <= 0.0002 and p1 <= 0.001 then
		return m_FormatOdds(p1);
	end
	return m_FormatPercent(p1);
end;
