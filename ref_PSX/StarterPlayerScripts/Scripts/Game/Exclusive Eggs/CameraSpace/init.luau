-- https://github.com/kalidrios

local m_Hungarian = require(script.Hungarian);
local table1 = {};
function computePosition(p1, p2) -- Line: 12
	local v1 = p2 <= 3 and 1 or math.ceil((math.pow(p2, 1 / 3)));
	local math_ceil_ret = math.ceil(p2 / v1);
	local math_floor_ret = math.floor(p2 / math_ceil_ret);
	local v2 = p2 - math_floor_ret * math_ceil_ret;
	local math_floor_ret2 = math.floor((p1 - 1) / math_ceil_ret);
	return Vector2.new(((p1 - 1) % math_ceil_ret + 0.5) / (math_floor_ret2 < math_floor_ret and math_ceil_ret or v2), (math_floor_ret2 + 0.5) / v1);
end
function table1.new() -- Line: 45
	--[[
		Upvalues:
			[1] = m_Hungarian
	--]]
	local table2 = {};
	local table3 = {};
	local function modify(p3) -- Line: 50
		--[[
			Upvalues:
				[1] = table3
				[2] = m_Hungarian
		--]]
		local v3 = #table3;
		local table4 = {};
		for index1 = 1, v3 do
			table.insert(table4, computePosition(index1, v3));
		end
		p3();
		local v4 = #table3;
		local table5 = {};
		for index2 = 1, v4 do
			table.insert(table5, computePosition(index2, v4));
		end
		if #table4 >= 1 and #table5 >= 1 then
			local v5 = m_Hungarian.minimize_distance(table4, table5);
			for key1, val1 in pairs(v5) do
				if key1 == val1 then continue end
				local v6 = table3;
				local v7 = table3;
				local v8 = table3[val1];
				local v9 = table3[key1];
				v6[key1] = v8;
				v7[val1] = v9;
				table3[key1].index = key1;
				table3[val1].index = val1;
			end
		end
	end
	function table2.add() -- Anonymous function at line 87
		--[[
			Upvalues:
				[1] = table3
				[2] = modify
		--]]
		local table6 = {index = #table3 + 1};
		modify(function() -- Line: 91
			--[[
				Upvalues:
					[1] = table3
					[2] = table6
			--]]
			table.insert(table3, table6);
		end);
		return table6;
	end
	function table2.remove(p4) -- Anonymous function at line 97
		--[[
			Upvalues:
				[1] = table3
				[2] = modify
		--]]
		local t_index = p4.index;
		if table3[t_index] ~= p4 then return end
		modify(function() -- Line: 104
			--[[
				Upvalues:
					[1] = table3
					[2] = t_index
			--]]
			table.remove(table3, t_index);
			for index3 = t_index, #table3 do
				table3[index3].index = index3;
			end
		end);
	end
	function table2.compute(p5) -- Anonymous function at line 115
		--[[
			Upvalues:
				[1] = table3
		--]]
		return computePosition(p5.index, #table3);
	end
	return table2;
end
return table1;
