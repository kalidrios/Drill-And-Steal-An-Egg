-- https://github.com/kalidrios

local m_Factorial = require(script.Parent.Factorial);
return function(p1, p2) -- Line: 6
	--[[
		Upvalues:
			[1] = m_Factorial
	--]]
	return m_Factorial(p1) / (m_Factorial(p2) * m_Factorial(p1 - p2));
end;
