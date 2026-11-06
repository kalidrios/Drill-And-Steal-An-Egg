-- https://github.com/kalidrios

local _ = require(script.Parent.lambda);
local table1 = {prototype = {}};
table1.__index = table1.prototype;
function table1._type() -- Line: 11
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {_entries = nil};
	setmetatable(table2, table1);
	return table2;
end
function table1.new() -- Line: 22
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table3 = {};
	local table4 = {_entries = table3};
	setmetatable(table4, table1);
	return table4;
end
function table1.destroy(p1) -- Line: 31
	local t__entries = p1._entries;
	p1._entries = {};
	for key1, val1 in pairs(t__entries) do
		key1:Destroy();
		if not val1.destroy then continue end
		val1:destroy();
	end
end
function table1.add_static(p2, p3, p4, p5) -- Line: 42
	p3.Parent = p4;
	if not p5 then
		p5 = {};
	end
	p2._entries[p3] = p5;
	return p3, p5;
end
function table1.add(p6, p7, p8, p9) -- Line: 52
	local v1 = p9 and p9(p7) or nil;
	return p6:add_static(p7, p8, v1);
end
function table1.create_static(p10, p11, p12, p13) -- Line: 60
	local Instance_new_ret = Instance.new(p11);
	return p10:add_static(Instance_new_ret, p12, p13);
end
function table1.create(p14, p15, p16, p17) -- Line: 65
	local Instance_new_ret2 = Instance.new(p15);
	return p14:add(Instance_new_ret2, p16, p17);
end
function table1.get(p18, p19) -- Line: 70
	return p18._entries[p19];
end
function table1.remove(p20, p21) -- Line: 81
	local t__entries2 = p20._entries;
	local v2 = t__entries2[p21];
	if v2 then
		t__entries2[p21] = nil;
	end
	return v2;
end
return table1;
