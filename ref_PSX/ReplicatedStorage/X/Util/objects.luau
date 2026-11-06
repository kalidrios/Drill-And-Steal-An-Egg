-- https://github.com/kalidrios

local _ = require(script.Parent.lambda);
local table1 = {
	lock = function(p7, p8) -- lock (Line: 90)
		local v6 = getmetatable(p7) or {};
		local t___index = v6.__index;
		if t___index ~= nil then
			function v6.__index(_, p24) -- Anonymous function at line 94
				--[[
					Upvalues:
						[1] = t___index
						[2] = p8
				--]]
				local v16 = t___index[p24];
				if v16 == nil then
					error(string.format("%s is not in %s!", tostring(p24), tostring(p8)), 3);
				end
				return v16;
			end
		else
			function v6.__index(_, p25) -- Anonymous function at line 102
				--[[
					Upvalues:
						[1] = p8
				--]]
				error(string.format("%s is not in %s!", tostring(p25), tostring(p8)), 3);
			end
		end
		function v6.__newindex(_, p23, _) -- Anonymous function at line 106
			--[[
				Upvalues:
					[1] = p8
			--]]
			error(string.format("Cannot createa new member %s in %s", tostring(p23), tostring(p8)), 3);
		end
		setmetatable(p7, v6);
		return p7;
	end,
	assert_type = function(p9, p10, p11) -- assert_type (Line: 113)
		if typeof(p9) == p10 then return end
		error(string.format("%s must be a %s", p11, p10), 2);
	end,
	load_once = function(p12, p13, p14) -- load_once (Line: 120)
		local v7 = p12[p13];
		if v7 then
			return v7.value;
		end
		local table2 = {};
		p12[p13] = table2;
		local v8 = p14(p13);
		if v8 ~= nil then
			table2.value = v8;
		end
		return table2.value;
	end,
	load_once_any = function(p15, p16, p17) -- load_once_any (Line: 135)
		local v9 = p15[p16];
		if v9 then
			return v9.value;
		end
		local table3 = {};
		p15[p16] = table3;
		local v10 = p17(p16);
		if v10 ~= nil then
			table3.value = v10;
		end
		return table3.value;
	end,
	optional = function(p18, p19) -- optional (Line: 150)
		if p18 ~= nil then
			return p18;
		end
		return p19;
	end,
	type_cast = function(p20, p21) -- type_cast (Line: 157)
		if p20 ~= nil then
			if not p21 then
				return p20;
			end
			if typeof(p20) == p21 then
				return p20;
			end
		end
		return nil;
	end,
	rawpairs = function(p22) -- rawpairs (Line: 170)
		return next, p22, nil;
	end
};
function table1.deep_equals(p1, p2, p3) -- Line: 174
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p1 == p2 then
		return true;
	end
	if typeof(p1) ~= "table" or typeof(p2) ~= "table" then
		return false;
	end
	local v1 = p1;
	local v2 = p2;
	local v3 = nil;
	local v4 = nil;
	local metatable = getmetatable(v1);
	local metatable2 = getmetatable(v2);
	if metatable then
		if metatable.__eq then
			return false;
		end
		if metatable.__len then
			v3 = #v1;
		end
	end
	if metatable2 then
		if metatable2.__eq then
			return false;
		end
		if metatable2.__len then
			v4 = #v2;
		end
	end
	if v3 ~= v4 and v3 and v4 then
		return false;
	end
	local v11;
	if v3 then
		v11 = v3;
	else
		v11 = 0;
		for _, _ in pairs(v1) do
			v11 = v11 + 1;
		end
	end
	local v12;
	if v4 then
		v12 = v4;
	else
		v12 = 0;
		for _, _ in pairs(v2) do
			v12 = v12 + 1;
		end
	end
	if v11 ~= v12 then
		return false;
	end
	if p3 then
		local v13 = p3[v1];
		if v13 and v13[v2] then
			return true;
		end
		local v14 = p3[v2];
		if v14 and v14[v1] then
			return true;
		end
		if v13 then
			v13[v2] = true;
		elseif v14 then
			v14[v1] = true;
		else
			p3[v1] = {[v2] = true};
		end
	else
		local table4 = {[v1] = {[v2] = true}};
		p3 = table4;
	end
	for key1, val1 in pairs(v2) do
		if table1.deep_equals(v1[key1], val1, p3) then continue end
		return false;
	end
	return true;
end
function table1.deep_copy(p4, p5) -- Line: 270
	--[[
		Upvalues:
			[1] = table1
	--]]
	if typeof(p4) ~= "table" then
		return p4;
	end
	local table5;
	if p5 then
		local v15 = p5[p4];
		if v15 ~= nil then
			return v15;
		end
		table5 = {};
		p5[p4] = table5;
	else
		table5 = {};
		local table6 = {[p4] = table5};
		p5 = table6;
	end
	for key2, val2 in next, p4 do
		table5[table1.deep_copy(key2, p5)] = table1.deep_copy(val2, p5);
	end
	local metatable3 = getmetatable(p4);
	if metatable3 then
		setmetatable(table5, (table1.deep_copy(metatable3, p5)));
	end
	return table5;
end
function table1.is_empty(p6) -- Line: 306
	assert(typeof(p6) == "table");
	local pairs_ret1_4, pairs_ret2_4, pairs_ret3 = pairs(p6);
	local v5, _ = pairs_ret1_4(pairs_ret2_4, pairs_ret3);
	if --[[generic for]] v5 then
		return false;
	end
	return true;
end
return table1;
