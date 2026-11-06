-- https://github.com/kalidrios

return function(p1) -- Line: 3
	p1 = math.round(p1);
	local math_floor_ret = math.floor(p1 / 60);
	local math_floor_ret2 = math.floor(p1 - math_floor_ret * 60);
	local math_floor_ret3 = math.floor(math_floor_ret / 60);
	local v1 = math_floor_ret - math_floor_ret3 * 60;
	return string.format("%02d:%02d:%02d", math_floor_ret3, v1, math_floor_ret2);
end;
