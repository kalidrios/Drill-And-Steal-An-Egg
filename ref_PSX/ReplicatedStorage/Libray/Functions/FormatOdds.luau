-- https://github.com/kalidrios

local m_FormatAbbreviated = require(script.Parent.FormatAbbreviated);
return function(p1) -- Line: 17
	--[[
		Upvalues:
			[1] = m_FormatAbbreviated
	--]]
	return "1/" .. m_FormatAbbreviated(1 / p1);
end;
