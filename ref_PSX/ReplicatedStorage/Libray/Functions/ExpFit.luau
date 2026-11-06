-- https://github.com/kalidrios

function sum(p1) -- Line: 4
	local v1 = 0;
	for index1 = 1, #p1 do
		v1 = v1 + p1[index1];
	end
	return v1;
end
return function(p2, p3) -- Line: 13
	assert(#p2 == #p3, "x and y arrays must have the same length");
	local v2 = #p2;
	assert(v2 >= 2, "at least two data points are required");
	local v3 = 0;
	for index2 = 1, v2 do
		assert(p3[index2] > 0, "y values must be positive for exponential curve fit");
		v3 = v3 + math.log(p3[index2]);
	end
	local v4 = 0;
	local v5 = 0;
	local v6 = 0;
	local v7 = 0;
	for index3 = 1, v2 do
		v4 = v4 + p2[index3];
		v5 = v5 + p2[index3] ^ 2;
		v6 = v6 + p2[index3] * math.log(p3[index3]);
		v7 = v7 + p3[index3];
	end
	local u1 = (v2 * v6 - v4 * v3) / (v2 * v5 - v4 ^ 2);
	local u2 = v7 / v2 / math.exp(u1 * v4 / v2);
	return function(p4) -- evaluate_curve (Line: 43)
		--[[
			Upvalues:
				[1] = u2
				[2] = u1
		--]]
		return u2 * math.exp(u1 * p4);
	end;
end;
