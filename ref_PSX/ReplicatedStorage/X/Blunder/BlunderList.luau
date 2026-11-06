-- https://github.com/kalidrios

local _ = require(script.Parent.BlunderMessage);
local table1 = {};
function table1.new(p1, p2, p3) -- Line: 16
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {
		playerUserId = p1,
		playerName = p2,
		playerDisplayName = p3,
		list = {},
		map = {}
	};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.add(p4, p5) -- Line: 32
	local key_ret = p5:key();
	local v1 = p4.map[key_ret];
	if v1 then
		v1:append(p5);
		return;
	end
	p4.map[key_ret] = p5;
	table.insert(p4.list, p5);
end
function table1.clear(p6) -- Line: 43
	p6.list = {};
	p6.map = {};
end
function table1.getAndClear(p7) -- Line: 48
	local t_list = p7.list;
	if #t_list > 0 then
		p7.list = {};
		p7.map = {};
		return t_list;
	end
	return nil;
end
function table1.empty(p8) -- Line: 58
	return #p8.list == 0;
end
table.freeze(table1);
return table1;
