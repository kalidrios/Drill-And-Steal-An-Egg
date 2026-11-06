-- https://github.com/kalidrios

return function(p1, p2, p3) -- Line: 3
	p1 = math.round(p1);
	local math_floor_ret = math.floor(p1 / 60);
	local math_floor_ret2 = math.floor(p1 - math_floor_ret * 60);
	local math_floor_ret3 = math.floor(math_floor_ret / 60);
	local math_floor_ret4 = math.floor(math_floor_ret3 / 24);
	local v1 = math_floor_ret - math_floor_ret3 * 60;
	local v2 = math_floor_ret3 - math_floor_ret4 * 24;
	local v3 = "";
	if p2 then
		v3 = math_floor_ret2 .. "s";
		if p3 then
			v3 = " " .. v3;
		end
	end
	local v4 = v1 .. "m" .. v3;
	if p3 then
		v4 = " " .. v4;
	end
	if v2 > 0 then
		v4 = v2 .. "hr" .. v4;
		if p3 then
			v4 = " " .. v4;
		end
	end
	if math_floor_ret4 > 0 then
		v4 = math_floor_ret4 .. "d" .. v4;
	end
	return v4;
end;
