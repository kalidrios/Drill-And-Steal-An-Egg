-- https://github.com/kalidrios

local m_Variables = require(script.Parent.Parent.Variables);
return function(p1) -- Line: 6
	--[[
		Upvalues:
			[1] = m_Variables
	--]]
	for _, val1 in ipairs(m_Variables.DarkMatterSkipProducts) do
		if p1 > val1.timeLeft then continue end
		return val1.productId;
	end
	return nil;
end;
