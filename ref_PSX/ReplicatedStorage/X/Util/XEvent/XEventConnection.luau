-- https://github.com/kalidrios

local table1 = {};
function table1.new(p1, p2, p3) -- Line: 13
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(typeof(p1) == "function");
	assert(typeof(p2) == "number");
	assert(p3 == nil and true or typeof(p3) == "function");
	local table2 = {
		fn = p1,
		priority = p2,
		removeFn = p3,
		disconnected = false
	};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.getFunction(p4) -- Line: 31
	return p4.fn;
end
function table1.getPriority(p5) -- Line: 35
	return p5.priority;
end
function table1.isDisconnected(p6) -- Line: 39
	return p6.disconnected;
end
function table1.disconnect(p7) -- Line: 43
	if p7.disconnected then
		return false;
	end
	p7.disconnected = true;
	if p7.removeFn then
		p7.removeFn(p7);
	end
	return true;
end
function table1.fire(p8, ...) -- Line: 54
	if p8:isDisconnected() then
		return false, nil;
	end
	return pcall(p8.fn, ...);
end
return table1;
