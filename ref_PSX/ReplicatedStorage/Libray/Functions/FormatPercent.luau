-- https://github.com/kalidrios

local m_FormatAbbreviated = require(script.Parent.FormatAbbreviated);
return function(p1) -- Line: 17
	--[[
		Upvalues:
			[1] = m_FormatAbbreviated
	--]]
	p1 = p1 * 100;
	local v1 = math.max(1, 10 ^ (math.ceil(-math.log10((math.abs(p1)))) + 1));
	if v1 == math.huge then
		v1 = 1;
	end
	p1 = math.round(p1 * v1) / v1;
	return m_FormatAbbreviated(p1) .. "%";
end;
