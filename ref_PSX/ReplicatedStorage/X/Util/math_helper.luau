-- https://github.com/kalidrios

local m_random = require(script.Parent.random);
local table1 = {
	R = m_random.new(),
	EPSILON = 0.00001,
	E = 2.718281828459045,
	RADIANS_45 = math.pi / 4,
	RADIANS_90 = math.pi / 2,
	RADIANS_180 = math.pi,
	RADIANS_360 = math.pi * 2,
	lerp = function(p26, p27, p28) -- lerp (Line: 15)
		return p27 + p26 * (p28 - p27);
	end
};
function table1.eval_sequence(p1, p2) -- Line: 20
	--[[
		Upvalues:
			[1] = table1
	--]]
	local t_Keypoints = p1.Keypoints;
	local v1 = #t_Keypoints;
	p2 = math.clamp(p2, 0, 1);
	if v1 == 0 then
		return p2;
	end
	for index1 = 1, v1 - 1 do
		local v10 = t_Keypoints[index1];
		local v11 = t_Keypoints[index1 + 1];
		if v10.Time > p2 or p2 >= v11.Time then continue end
		local v12 = (p2 - v10.Time) / (v11.Time - v10.Time);
		local v13 = v10.Value + (v11.Value - v10.Value) * v12;
		local math_min_ret = math.min(v10.Envelope + (v11.Envelope - v10.Envelope) * v12, v13);
		local math_min_ret2 = math.min(math_min_ret, 1 - v13);
		if math_min_ret2 > 0 then
			v13 = v13 + table1.R:next(-math_min_ret2, math_min_ret2);
		end
		return math.clamp(v13, 0, 1);
	end
	return p2;
end
function table1.deg_norm(p3) -- Line: 52
	if p3 < 0 then
		p3 = p3 + (math.floor(-p3 / 360) + 1) * 360;
	end
	return p3 % 360;
end
function table1.rad_norm(p4) -- Line: 60
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p4 < 0 then
		p4 = p4 + (math.floor(-p4 / table1.RADIANS_360) + 1) * table1.RADIANS_360;
	end
	return p4 % table1.RADIANS_360;
end
function table1.deg_delta_unsafe(p5, p6) -- Line: 68
	local v2 = p6 - p5;
	if v2 > 180 then
		return v2 - 360;
	end
	if v2 < -180 then
		v2 = v2 + 360;
	end
	return v2;
end
function table1.deg_delta(p7, p8) -- Line: 78
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.deg_delta_unsafe(table1.deg_norm(p7), table1.deg_norm(p8));
end
function table1.rad_delta_unsafe(p9, p10) -- Line: 83
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v3 = p10 - p9;
	if table1.RADIANS_180 < v3 then
		return v3 - table1.RADIANS_360;
	end
	if v3 < -table1.RADIANS_180 then
		v3 = v3 + table1.RADIANS_360;
	end
	return v3;
end
function table1.rad_delta(p11, p12) -- Line: 93
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.rad_delta_unsafe(table1.rad_norm(p11), table1.rad_norm(p12));
end
function table1.compare(p13, p14) -- Line: 97
	if p13 < p14 then
		return -1;
	end
	if p14 < p13 then
		return 1;
	end
	return 0;
end
function table1.erf(p15) -- Line: 110
	--[[
		Upvalues:
			[1] = table1
	--]]
	return 1 - table1.erfc(p15);
end
function table1.erfc(p16) -- Line: 114
	local v4 = 1 / (p16 * 0.5 + 1);
	local v5 = v4 * math.exp(-p16 * p16 - 1.26551223 + v4 * (v4 * (v4 * (v4 * (v4 * (v4 * (v4 * (v4 * (v4 * 0.17087277 + -0.82215223) + 1.48851587) + -1.13520398) + 0.27886807) + -0.18628806) + 0.09678418) + 0.37409196) + 1.00002368));
	if p16 >= 0 then
		return v5;
	end
	return 2 - v5;
end
function table1.erfinv(p17) -- Line: 130
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p17 > 1 or p17 < -1 then
		return 0;
	end
	local table2 = {
		[1] = 0.886226899,
		[2] = -1.645349621,
		[3] = 0.914624893,
		[4] = -0.140543331
	};
	local table3 = {
		[1] = -2.118377725,
		[2] = 1.442710462,
		[3] = -0.329097515,
		[4] = 0.012229801
	};
	local table4 = {
		[1] = -1.970840454,
		[2] = -1.624906493,
		[3] = 3.429567803,
		[4] = 1.641345311
	};
	local table5 = {
		[1] = 3.5438892,
		[2] = 1.6370678
	};
	local v9;
	if math.abs(p17) == 1 then
		v9 = -p17 * -(1/0);
	elseif p17 < -0.7 then
		local math_sqrt_ret2 = math.sqrt(-math.log((p17 + 1) / 2));
		v9 = -(((table4[4] * math_sqrt_ret2 + table4[3]) * math_sqrt_ret2 + table4[2]) * math_sqrt_ret2 + table4[1]) / ((table5[2] * math_sqrt_ret2 + table5[1]) * math_sqrt_ret2 + 1);
	elseif p17 < 0.7 then
		local v14 = p17 * p17;
		v9 = p17 * (((table2[4] * v14 + table2[3]) * v14 + table2[2]) * v14 + table2[1]) / ((((table3[4] * v14 + table3[4]) * v14 + table3[2]) * v14 + table3[1]) * v14 + 1);
	else
		local math_sqrt_ret = math.sqrt(-math.log((1 - p17) / 2));
		v9 = (((table4[4] * math_sqrt_ret + table4[3]) * math_sqrt_ret + table4[2]) * math_sqrt_ret + table4[1]) / ((table5[2] * math_sqrt_ret + table5[1]) * math_sqrt_ret + 1);
	end
	local v6 = v9 - (table1.erf(v9) - p17) / (2 / math.sqrt(math.pi) * math.exp(-v9 * v9));
	return v6 - (table1.erf(v6) - p17) / (2 / math.sqrt(math.pi) * math.exp(-v6 * v6));
end
function table1.cumulative_probability(p18, p19, p20) -- Line: 178
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v7 = p18 - p19;
	if math.abs(v7) > p20 * 40 then
		if v7 < 0 then
			return 0;
		end
		return 1;
	end
	return table1.erfc(-v7 / (p20 * 1.4142135623730951)) * 0.5;
end
function table1.round(p21, p22) -- Line: 189
	local v8 = 10 ^ (p22 or 0);
	return math.floor(p21 * v8 + 0.5) / v8;
end
function table1.isnan(p23) -- Line: 194
	return p23 ~= p23;
end
function table1.isinf(p24) -- Line: 198
	return p24 == math.huge and true or p24 == -math.huge;
end
function table1.isfinite(p25) -- Line: 202
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.isnan(p25) == false and table1.isinf(p25) == false or false;
end
return table1;
