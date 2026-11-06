-- https://github.com/kalidrios

local _ = require(script.Parent.lambda);
local table1 = {prototype = {}};
table1.__index = table1.prototype;
function table1._type() -- Line: 9
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {};
	local table3 = {
		_executed = false,
		_callbacks = table2
	};
	setmetatable(table3, table1);
	return table3;
end
function table1.new() -- Line: 22
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table4 = {};
	local table5 = {
		_executed = false,
		_callbacks = table4
	};
	setmetatable(table5, table1);
	return table5;
end
local function listen(p1, p2) -- Line: 33
	if p2 then
		if p1._executed then
			p2();
			return;
		end
		local t__callbacks = p1._callbacks;
		t__callbacks[#t__callbacks + 1] = p2;
	end
end
table1.prototype.listen = listen;
local function execute(p3) -- Line: 44
	if p3._executed then return end
	p3._executed = true;
	local t__callbacks2 = p3._callbacks;
	p3._callbacks = {};
	for _, val1 in ipairs(t__callbacks2) do
		val1();
	end
end
table1.prototype.execute = execute;
return table1;
