-- https://github.com/kalidrios

local table1 = {
	"k",
	"m",
	"b",
	"t",
	"q",
	"Qt",
	"Sx"
};
return function(p1, p2, p3) -- Line: 19
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v1 = p2 or 3;
	local v2 = p3 or 0;
	local math_max_ret = math.max(math.abs(p1), (math.pow(10, -(#table1) * 3)));
	local math_ceil_ret = math.ceil((math.log10(math_max_ret)));
	local v3 = 10 ^ (math.min(math_ceil_ret, #table1 * 3 + v1) - v2 - v1);
	local v4 = math.round(math_max_ret / v3) * v3;
	local math_floor_ret = math.floor(math.log10((math.max(v4, 1))) / 3);
	local math_min_ret = math.min(math_floor_ret, #table1);
	local v5 = v4 * math.sign(p1) / 10 ^ (math_min_ret * 3);
	local string_format_ret = string.format("%f", v5);
	local gsub_ret = string_format_ret:gsub("%.?0+$", "");
	if math_min_ret >= 1 then
		return gsub_ret .. table1[math_min_ret];
	end
	return gsub_ret;
end;
