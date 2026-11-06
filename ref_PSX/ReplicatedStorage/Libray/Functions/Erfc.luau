-- https://github.com/kalidrios

return function(p1) -- Line: 3
	local v1 = 1 / (p1 * 0.5 + 1);
	local v2 = v1 * math.exp(-p1 * p1 - 1.26551223 + v1 * (v1 * (v1 * (v1 * (v1 * (v1 * (v1 * (v1 * (v1 * 0.17087277 + -0.82215223) + 1.48851587) + -1.13520398) + 0.27886807) + -0.18628806) + 0.09678418) + 0.37409196) + 1.00002368));
	if p1 >= 0 then
		return v2;
	end
	return 2 - v2;
end;
