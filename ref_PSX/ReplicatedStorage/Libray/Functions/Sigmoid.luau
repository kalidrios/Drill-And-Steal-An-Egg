-- https://github.com/kalidrios

return function(p1, p2, p3) -- Line: 6
	if p1 <= 0.000001 then
		return 0;
	end
	if p1 >= 0.999999 then
		return 1;
	end
	local v1 = p2 or 2.718281828459045;
	local v2 = v1 ^ (p3 or 0);
	return v2 / (v2 + (p1 / (1 - p1)) ^ (-v1));
end;
