-- https://github.com/kalidrios

local m_Comb = require(script.Parent.Comb);
return function(...) -- Line: 5
	--[[
		Upvalues:
			[1] = m_Comb
	--]]
	local table_pack_ret = table.pack(...);
	local u1 = #table_pack_ret - 1;
	local table1 = {};
	for index1 = 0, u1 do
		table.insert(table1, m_Comb(u1, index1));
	end
	return function(p1) -- Line: 25
		--[[
			Upvalues:
				[1] = u1
				[2] = table1
				[3] = table_pack_ret
		--]]
		local v1 = Vector2.new();
		for index2 = 0, u1 do
			v1 = v1 + table_pack_ret[index2 + 1] * (table1[index2 + 1] * math.pow(1 - p1, u1 - index2) * math.pow(p1, index2));
		end
		return v1;
	end;
end;
