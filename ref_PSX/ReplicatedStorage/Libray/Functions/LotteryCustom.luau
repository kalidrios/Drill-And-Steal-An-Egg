-- https://github.com/kalidrios

local Random_new_ret = Random.new();
return function(p1, ...) -- Line: 29
	--[[
		Upvalues:
			[1] = Random_new_ret
	--]]
	local v1 = p1 or Random_new_ret;
	local v2 = {...};
	if #v2 == 1 and typeof(v2[1]) == "table" and typeof(v2[1][2]) ~= "number" then
		v2 = v2[1];
	end
	local v3 = 0;
	local v4 = 0;
	local v5 = 0;
	for key1, val1 in ipairs(v2) do
		local v7 = val1[2];
		assert(typeof(v7) == "number");
		if v7 <= 0 or v7 ~= v7 or v7 == math.huge then continue end
		v3 = v3 + 1;
		v4 = v4 + v7;
		v5 = key1;
	end
	if v3 == 0 then
		return nil, 0, 0, 0;
	end
	local NextNumber_ret = v1:NextNumber(0, v4);
	local v6 = NextNumber_ret;
	for key2, val2 in ipairs(v2) do
		local v8 = val2[2];
		if v8 <= 0 or v8 ~= v8 or v8 == math.huge then continue end
		v6 = v6 - v8;
		if v6 > 0 and key2 ~= v5 then continue end
		return val2[1], NextNumber_ret / v4, v8 / v4, key2;
	end
	error("impossible");
end;
