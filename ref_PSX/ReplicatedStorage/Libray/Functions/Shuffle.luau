-- https://github.com/kalidrios

return function(p1) -- Line: 4
	for index1 = #p1, 2, -1 do
		local math_random_ret = math.random(index1);
		local v1 = p1[math_random_ret];
		local v2 = p1[index1];
		p1[index1] = v1;
		p1[math_random_ret] = v2;
	end
	return p1;
end;
