-- https://github.com/kalidrios

local m_Erfc = require(script.Parent.Erfc);
return function(p1) -- Line: 5
	--[[
		Upvalues:
			[1] = m_Erfc
	--]]
	return 1 - m_Erfc(p1);
end;
