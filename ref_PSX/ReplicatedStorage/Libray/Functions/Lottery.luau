-- https://github.com/kalidrios

local m_LotteryCustom = require(script.Parent.LotteryCustom);
return function(...) -- Line: 28
	--[[
		Upvalues:
			[1] = m_LotteryCustom
	--]]
	return m_LotteryCustom(nil, ...);
end;
