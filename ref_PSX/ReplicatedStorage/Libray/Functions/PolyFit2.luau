-- https://github.com/kalidrios

local m_Gauss = require(script.Parent.Gauss);
return function(p1, p2, p3) -- Line: 5
	--[[
		Upvalues:
			[1] = m_Gauss
	--]]
	local v1 = #p1;
	assert(v1 == #p2);
	local v2 = p3 or v1;
	assert(v2 > 0);
	local table1 = {};
	for index1 = 1, v2 do
		local table_create_ret3 = table.create(v2, 0);
		for index4 = 1, v2 do
			local v6 = 0;
			for index6 = 1, v1 do
				v6 = v6 + p1[index6] ^ (index1 + index4 - 2);
			end
			table_create_ret3[index4] = v6;
		end
		table.insert(table1, table_create_ret3);
	end
	local table_create_ret = table.create(v2, 0);
	local table_create_ret2 = table.create(v2, 0);
	for index2 = 1, v2 do
		local v5 = Vector2.new();
		for index5 = 1, v1 do
			v5 = v5 + p2[index5] * p1[index5] ^ (index2 - 1);
		end
		local t_X = v5.X;
		local t_Y = v5.Y;
		table_create_ret[index2] = t_X;
		table_create_ret2[index2] = t_Y;
	end
	local v3 = m_Gauss(table1, table_create_ret);
	local v4 = m_Gauss(table1, table_create_ret2);
	local table2 = {};
	for index3 = 1, v2 do
		table.insert(table2, Vector2.new(v3[index3], v4[index3]));
	end
	return table2;
end;
