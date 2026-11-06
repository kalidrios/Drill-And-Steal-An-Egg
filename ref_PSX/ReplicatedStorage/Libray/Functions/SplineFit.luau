-- https://github.com/kalidrios

function solve_tridiagonal(p1, p2, p3, p4) -- Line: 4
	local v1 = #p2;
	local table1 = {};
	local table2 = {};
	table1[1] = p4[1] / p2[1];
	table2[1] = p3[1] / p2[1];
	for index1 = 2, v1 - 1 do
		local v2 = 1 / (p2[index1] - p1[index1] * table2[index1 - 1]);
		table1[index1] = (p4[index1] - p1[index1] * table1[index1 - 1]) * v2;
		table2[index1] = p3[index1] * v2;
	end
	table1[v1] = (p4[v1] - p1[v1] * table1[v1 - 1]) / (p2[v1] - p1[v1] * table2[v1 - 1]);
	for index2 = v1 - 1, 1, -1 do
		table1[index2] = table1[index2] - table2[index2] * table1[index2 + 1];
	end
	return table1;
end
return function(p5, p6) -- Line: 28
	assert(#p5 == #p6, "x and y arrays must have the same length");
	local u1 = #p5;
	assert(u1 >= 2, "at least two data points are required");
	local table3 = {};
	local table4 = {};
	for index3 = 1, u1 - 1 do
		table3[index3] = p5[index3 + 1] - p5[index3];
		table4[index3] = (p6[index3 + 1] - p6[index3]) / table3[index3];
	end
	local table5 = {};
	local table6 = {};
	local table7 = {};
	local table8 = {};
	for index4 = 2, u1 - 1 do
		table5[index4] = table3[index4 - 1];
		table6[index4] = (table3[index4 - 1] + table3[index4]) * 2;
		table7[index4] = table3[index4];
		table8[index4] = (table4[index4] - table4[index4 - 1]) * 6;
	end
	table6[1] = 1;
	table7[1] = 0;
	table8[1] = 0;
	table5[u1] = 0;
	table6[u1] = 1;
	table8[u1] = 0;
	local solve_tridiagonal_ret = solve_tridiagonal(table5, table6, table7, table8);
	return function(p7) -- evaluate_spline (Line: 68)
		--[[
			Upvalues:
				[1] = p5
				[2] = u1
				[3] = p6
				[4] = solve_tridiagonal_ret
		--]]
		assert(p5[1] <= p7 and p7 <= p5[u1] or false, "t is outside the range of x values");
		if p7 <= p5[1] then
			return p6[1];
		end
		if p5[u1] <= p7 then
			return p6[u1];
		end
		local v3 = 1;
		while v3 < u1 and p5[v3 + 1] <= p7 do
			v3 = v3 + 1;
		end
		local v4 = p5[v3 + 1] - p5[v3];
		local v5 = (solve_tridiagonal_ret[v3 + 1] - solve_tridiagonal_ret[v3]) / (v4 * 6);
		local v6 = solve_tridiagonal_ret[v3] / 2;
		local v7 = (p6[v3 + 1] - p6[v3]) / v4 - v4 * (solve_tridiagonal_ret[v3] * 2 + solve_tridiagonal_ret[v3 + 1]) / 6;
		local v8 = p6[v3];
		local v9 = p7 - p5[v3];
		return v5 * v9 ^ 3 + v6 * v9 ^ 2 + v7 * v9 + v8;
	end;
end;
