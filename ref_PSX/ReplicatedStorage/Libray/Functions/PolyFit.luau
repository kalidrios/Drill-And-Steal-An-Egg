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
		local table_create_ret2 = table.create(v2, 0);
		for index3 = 1, v2 do
			local v4 = 0;
			for index5 = 1, v1 do
				v4 = v4 + p1[index5] ^ (index1 + index3 - 2);
			end
			table_create_ret2[index3] = v4;
		end
		table.insert(table1, table_create_ret2);
	end
	local table_create_ret = table.create(v2, 0);
	for index2 = 1, v2 do
		local v3 = 0;
		for index4 = 1, v1 do
			v3 = v3 + p2[index4] * p1[index4] ^ (index2 - 1);
		end
		table_create_ret[index2] = v3;
	end
	return m_Gauss(table1, table_create_ret);
end;
