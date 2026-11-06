-- https://github.com/kalidrios

local m_lambda = require(script.Parent.lambda);
local table1 = {
	compact = function(p4) -- compact (Line: 7)
		local v3 = #p4;
		local v4 = 0;
		for index1 = 1, v3 do
			if p4[index1] ~= nil then
				v4 = v4 + 1;
				p4[v4] = p4[index1];
			end
		end
		for index2 = v3, v4 + 1, -1 do
			p4[index2] = nil;
		end
		return p4;
	end,
	clear = function(p5) -- clear (Line: 22)
		for index3 = #p5, 1, -1 do
			p5[index3] = nil;
		end
		return p5;
	end,
	binary_search = function(p6, p7) -- binary_search (Line: 32)
		local v5 = 1;
		local v6 = #p6;
		while true do
			if v5 > v6 then
				return -v5 - 1;
			end
			local math_floor_ret = math.floor((v5 + v6) / 2);
			local v11 = p7(p6[math_floor_ret]);
			if v11 > 0 then
				v6 = math_floor_ret - 1;
			else
				if v11 >= 0 then
					return math_floor_ret;
				end
				v5 = math_floor_ret + 1;
			end
		end
	end,
	binary_search_left_ins = function(p8, p9) -- binary_search_left_ins (Line: 72)
		local v7 = 1;
		local v8 = #p8;
		while v7 <= v8 do
			local math_floor_ret2 = math.floor((v7 + v8) / 2);
			if p9(p8[math_floor_ret2]) >= 0 then
				v8 = math_floor_ret2 - 1;
			else
				v7 = math_floor_ret2 + 1;
			end
		end
		return v7;
	end,
	binary_search_right_ins = function(p10, p11) -- binary_search_right_ins (Line: 110)
		local v9 = 1;
		local v10 = #p10;
		while v9 <= v10 do
			local math_floor_ret3 = math.floor((v9 + v10) / 2);
			if p11(p10[math_floor_ret3]) > 0 then
				v10 = math_floor_ret3 - 1;
			else
				v9 = math_floor_ret3 + 1;
			end
		end
		return v9;
	end
};
function table1.binary_search_insert_right(p1, p2, p3) -- Line: 134
	--[[
		Upvalues:
			[1] = m_lambda
			[2] = table1
	--]]
	local v1 = m_lambda.comparator_to_order(p2, p3);
	local v2 = table1.binary_search_right_ins(p1, v1);
	table.insert(p1, v2, p3);
	return v2;
end
return table1;
