-- https://github.com/kalidrios

function cubic_spline(p1, p2) -- Line: 3
	local u1 = #p1;
	local table1 = {};
	local table2 = {};
	local table3 = {};
	local table4 = {};
	local table5 = {};
	local table6 = {};
	local table7 = {};
	local table8 = {};
	for index1 = 1, u1 - 1 do
		table1[index1] = p1[index1 + 1] - p1[index1];
	end
	for index2 = 2, u1 - 1 do
		table2[index2] = (p2[index2 + 1] - p2[index2]) * 3 / table1[index2] - (p2[index2] - p2[index2 - 1]) * 3 / table1[index2 - 1];
	end
	table3[1] = 1;
	table4[1] = 0;
	table5[1] = 0;
	for index3 = 2, u1 - 1 do
		table3[index3] = (p1[index3 + 1] - p1[index3 - 1]) * 2 - table1[index3 - 1] * table4[index3 - 1];
		table4[index3] = table1[index3] / table3[index3];
		table5[index3] = (table2[index3] - table1[index3 - 1] * table5[index3 - 1]) / table3[index3];
	end
	table3[u1] = 1;
	table5[u1] = 0;
	table6[u1] = 0;
	for index4 = u1 - 1, 1, -1 do
		table6[index4] = table5[index4] - table4[index4] * table6[index4 + 1];
		table7[index4] = (p2[index4 + 1] - p2[index4]) / table1[index4] - table1[index4] * (table6[index4 + 1] + table6[index4] * 2) / 3;
		table8[index4] = (table6[index4 + 1] - table6[index4]) / (table1[index4] * 3);
	end
	return function(p5) -- Line: 45
		--[[
			Upvalues:
				[1] = p1
				[2] = p2
				[3] = u1
				[4] = table7
				[5] = table6
				[6] = table8
		--]]
		if p5 <= p1[1] then
			return p2[1];
		end
		if p1[u1] <= p5 then
			return p2[u1];
		end
		local v5 = 1;
		while p1[v5 + 1] < p5 do
			v5 = v5 + 1;
		end
		local v6 = p5 - p1[v5];
		return p2[v5] + table7[v5] * v6 + table6[v5] * v6 ^ 2 + table8[v5] * v6 ^ 3;
	end;
end
return function(p3, p4) -- SmoothedAmounts (Line: 62)
	local v1 = #p3;
	assert(v1 == #p4);
	local v2 = 0;
	for index5 = 1, v1 do
		local v3 = p4[index5];
		assert(v3 > 0);
		assert(v3 == v3);
		assert(v3 ~= math.huge);
		v2 = v2 + v3;
	end
	local table_create_ret = table.create(v1, 0);
	for index6 = 1, v1 do
		table_create_ret[index6] = index6;
	end
	table.sort(table_create_ret, function(p6, p7) -- Line: 82
		--[[
			Upvalues:
				[1] = p4
		--]]
		return p4[p6] > p4[p7];
	end);
	local table_create_ret2 = table.create(v1, 0);
	for index7 = 2, v1 do
		table_create_ret2[index7] = table_create_ret2[index7 - 1] + p4[table_create_ret[index7 - 1]] / v2;
	end
	local u2 = p3[table_create_ret[1]];
	local u3 = p3[table_create_ret[v1]];
	if u2 < u3 then
		local table_create_ret4 = table.create(v1, 0);
		for index10 = 2, v1 do
			assert(p3[table_create_ret[index10 - 1]] <= p3[table_create_ret[index10]]);
		end
		for index11 = 1, v1 do
			local v8 = p3[table_create_ret[index11]];
			assert(v8 == v8);
			assert(v8 ~= -math.huge);
			assert(v8 ~= math.huge);
			table_create_ret4[index11] = 1 / v8;
		end
		local cubic_spline_ret2 = cubic_spline(table_create_ret2, table_create_ret4);
		return function(p9) -- Line: 108
			--[[
				Upvalues:
					[1] = u2
					[2] = u3
					[3] = cubic_spline_ret2
			--]]
			local v9 = p9 or math.random();
			if v9 <= 0 then
				return u2;
			end
			if v9 >= 1 then
				return u3;
			end
			return 1 / cubic_spline_ret2(v9);
		end;
	end
	local table_create_ret3 = table.create(v1, 0);
	for index8 = 2, v1 do
		assert(p3[table_create_ret[index8 - 1]] >= p3[table_create_ret[index8]]);
	end
	for index9 = 1, v1 do
		local v4 = p3[table_create_ret[index9]];
		assert(v4 == v4);
		assert(v4 ~= -math.huge);
		assert(v4 ~= math.huge);
		table_create_ret3[index9] = v4;
	end
	local cubic_spline_ret = cubic_spline(table_create_ret2, table_create_ret3);
	return function(p8) -- Line: 135
		--[[
			Upvalues:
				[1] = u2
				[2] = u3
				[3] = cubic_spline_ret
		--]]
		local v7 = p8 or math.random();
		if v7 <= 0 then
			return u2;
		end
		if v7 >= 1 then
			return u3;
		end
		return cubic_spline_ret(v7);
	end;
end;
