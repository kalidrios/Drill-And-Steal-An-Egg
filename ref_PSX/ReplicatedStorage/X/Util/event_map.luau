-- https://github.com/kalidrios

local table1 = {};
function table1.new() -- Line: 10
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {connections = {}};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.destroy(p1) -- Line: 18
	local t_connections = p1.connections;
	p1.connections = {};
	for key1, _ in pairs(t_connections) do
		key1:Disconnect();
	end
end
function table1.connect(p2, p3, p4) -- Line: 26
	local Connect_ret = p3:Connect(p4);
	p2.connections[Connect_ret] = {};
	return Connect_ret;
end
function table1.track(p5, p6) -- Line: 32
	p5.connections[p6] = {};
	return p6;
end
return table1;
