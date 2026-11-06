-- https://github.com/kalidrios

local m_Erf = require(script.Parent.Erf);
return function(p1) -- Line: 6
	--[[
		Upvalues:
			[1] = m_Erf
	--]]
	if p1 > 1 or p1 < -1 then
		return 0;
	end
	local table1 = {
		[1] = 0.886226899,
		[2] = -1.645349621,
		[3] = 0.914624893,
		[4] = -0.140543331
	};
	local table2 = {
		[1] = -2.118377725,
		[2] = 1.442710462,
		[3] = -0.329097515,
		[4] = 0.012229801
	};
	local table3 = {
		[1] = -1.970840454,
		[2] = -1.624906493,
		[3] = 3.429567803,
		[4] = 1.641345311
	};
	local table4 = {
		[1] = 3.5438892,
		[2] = 1.6370678
	};
	local v2;
	if math.abs(p1) == 1 then
		v2 = -p1 * -(1/0);
	elseif p1 < -0.7 then
		local math_sqrt_ret2 = math.sqrt(-math.log((p1 + 1) / 2));
		v2 = -(((table3[4] * math_sqrt_ret2 + table3[3]) * math_sqrt_ret2 + table3[2]) * math_sqrt_ret2 + table3[1]) / ((table4[2] * math_sqrt_ret2 + table4[1]) * math_sqrt_ret2 + 1);
	elseif p1 < 0.7 then
		local v3 = p1 * p1;
		v2 = p1 * (((table1[4] * v3 + table1[3]) * v3 + table1[2]) * v3 + table1[1]) / ((((table2[4] * v3 + table2[4]) * v3 + table2[2]) * v3 + table2[1]) * v3 + 1);
	else
		local math_sqrt_ret = math.sqrt(-math.log((1 - p1) / 2));
		v2 = (((table3[4] * math_sqrt_ret + table3[3]) * math_sqrt_ret + table3[2]) * math_sqrt_ret + table3[1]) / ((table4[2] * math_sqrt_ret + table4[1]) * math_sqrt_ret + 1);
	end
	local v1 = v2 - (m_Erf(v2) - p1) / (2 / math.sqrt(math.pi) * math.exp(-v2 * v2));
	return v1 - (m_Erf(v1) - p1) / (2 / math.sqrt(math.pi) * math.exp(-v1 * v1));
end;
