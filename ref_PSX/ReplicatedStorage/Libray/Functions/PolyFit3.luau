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
		local table_create_ret4 = table.create(v2, 0);
		for index4 = 1, v2 do
			local v7 = 0;
			for index6 = 1, v1 do
				v7 = v7 + p1[index6] ^ (index1 + index4 - 2);
			end
			table_create_ret4[index4] = v7;
		end
		table.insert(table1, table_create_ret4);
	end
	local table_create_ret = table.create(v2, 0);
	local table_create_ret2 = table.create(v2, 0);
	local table_create_ret3 = table.create(v2, 0);
	for index2 = 1, v2 do
		local v6 = Vector3.new();
		for index5 = 1, v1 do
			v6 = v6 + p2[index5] * p1[index5] ^ (index2 - 1);
		end
		local t_X = v6.X;
		local t_Y = v6.Y;
		local t_Z = v6.Z;
		table_create_ret[index2] = t_X;
		table_create_ret2[index2] = t_Y;
		table_create_ret3[index2] = t_Z;
	end
	local v3 = m_Gauss(table1, table_create_ret);
	local v4 = m_Gauss(table1, table_create_ret2);
	local v5 = m_Gauss(table1, table_create_ret3);
	local table2 = {};
	for index3 = 1, v2 do
		table.insert(table2, (Vector3.new(v3[index3], v4[index3], v5[index3])));
	end
	return table2;
end;
