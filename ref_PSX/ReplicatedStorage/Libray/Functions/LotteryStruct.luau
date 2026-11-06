-- https://github.com/kalidrios

local Random_new_ret = Random.new();
return function(p1) -- Line: 32
	--[[
		Upvalues:
			[1] = Random_new_ret
	--]]
	assert(typeof(p1) == "table");
	if #p1 == 0 then
		return nil, 0, 0, 0;
	end
	local v1 = 0;
	local v2 = 0;
	local v3 = -1;
	for key1, val1 in ipairs(p1) do
		local t_chance2 = val1.chance;
		if t_chance2 <= 0 or t_chance2 ~= t_chance2 or t_chance2 == math.huge then continue end
		v1 = v1 + 1;
		v2 = v2 + t_chance2;
		v3 = key1;
	end
	if v1 == 0 then
		return nil, 0, 0, 0;
	end
	local NextNumber_ret = Random_new_ret:NextNumber(0, v2);
	local v4 = NextNumber_ret;
	for key2, val2 in ipairs(p1) do
		local t_chance = val2.chance;
		if t_chance <= 0 or t_chance ~= t_chance or t_chance == math.huge then continue end
		v4 = v4 - t_chance;
		if v4 > 0 and key2 ~= v3 then continue end
		return val2.value, NextNumber_ret / v2, t_chance / v2, key2;
	end
	error("impossible");
end;
