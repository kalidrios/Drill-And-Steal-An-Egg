-- https://github.com/kalidrios

local table1 = {
	"I",
	"V",
	"X",
	"L",
	"C",
	"D",
	"M"
};
local table2 = {
	1,
	5,
	10,
	50,
	100,
	500,
	1000
};
local _ = {
	I = 1,
	V = 5,
	X = 10,
	L = 50,
	C = 100,
	D = 500,
	M = 1000
};
return function(p1) -- Line: 26
	--[[
		Upvalues:
			[1] = table2
			[2] = table1
	--]]
	local tonumber_ret = tonumber(p1);
	if not tonumber_ret or tonumber_ret ~= tonumber_ret then
		error("Unable to convert to number");
	end
	assert(tonumber_ret);
	if tonumber_ret == math.huge then
		error("Unable to convert infinity");
	end
	local v1 = math.floor(tonumber_ret);
	if v1 <= 0 then
		return tostring(v1);
	end
	local v2 = "";
	for index1 = #table2, 1, -1 do
		local v3 = table2[index1];
		while v1 - v3 >= 0 and v1 > 0 do
			v2 = v2 .. table1[index1];
			v1 = v1 - v3;
		end
		for index2 = 1, index1 - 1 do
			local v4 = table2[index2];
			if v1 - (v3 - v4) >= 0 and v1 < v3 and v1 > 0 and v3 - v4 ~= v4 then
				v2 = v2 .. table1[index2] .. table1[index1];
				v1 = v1 - (v3 - v4);
				break;
			end
		end
	end
	return v2;
end;
