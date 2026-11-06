-- https://github.com/kalidrios

local m_list_helper = require(script.Parent.list_helper);
local _ = require(script.Parent.objects);
local m_XEventConnection = require(script.XEventConnection);
local table1 = {DefaultPriority = 0};
function table1.new() -- Line: 17
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {
		conns = {},
		destroyed = false
	};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.fireWithDefault(p1, p2, ...) -- Line: 26
	assert(not p1.destroyed);
	for _, val1 in ipairs(p1.conns) do
		local table_pack_ret = table.pack(val1:fire(...));
		if table_pack_ret[1] then
			if #table_pack_ret <= 2 or not table_pack_ret[2] then continue end
			return table.unpack(table_pack_ret, 2);
		end
		warn(string.format("XEvent error: %s", tostring(table_pack_ret[2])));
	end
	return p2;
end
function table1.fire(p3, ...) -- Line: 41
	return p3:fireWithDefault(nil, ...);
end
function table1.connect(p4, p5, p6) -- Line: 45
	--[[
		Upvalues:
			[1] = m_XEventConnection
			[2] = table1
			[3] = m_list_helper
	--]]
	assert(not p4.destroyed);
	local u1 = m_XEventConnection.new(p5, p6 or table1.DefaultPriority, function(p11) -- Line: 50
		--[[
			Upvalues:
				[1] = p4
		--]]
		p4:_remove(p11);
	end);
	local t_conns = p4.conns;
	local v1 = m_list_helper.binary_search_right_ins(t_conns, function(p12) -- Line: 57
		--[[
			Upvalues:
				[1] = u1
		--]]
		return p12:getPriority() - u1:getPriority();
	end);
	table.insert(t_conns, v1, u1);
	return u1;
end
function table1._remove(p7, p8) -- Line: 65
	--[[
		Upvalues:
			[1] = m_list_helper
	--]]
	if p7.destroyed then
		return false;
	end
	local t_conns2 = p7.conns;
	local v2 = m_list_helper.binary_search_left_ins(t_conns2, function(p13) -- Line: 72
		--[[
			Upvalues:
				[1] = p8
		--]]
		return p13:getPriority() - p8:getPriority();
	end);
	for index1 = v2, #t_conns2 do
		local v3 = t_conns2[index1];
		if v3 == p8 then
			table.remove(t_conns2, index1);
			return true;
		end
		if v3:getPriority() ~= p8:getPriority() then break end
	end
	return false;
end
function table1.isDestroyed(p9) -- Line: 89
	return p9.destroyed;
end
function table1.destroy(p10) -- Line: 93
	if p10.destroyed then
		return false;
	end
	local t_conns3 = p10.conns;
	p10.conns = {};
	for _, val2 in ipairs(t_conns3) do
		val2:disconnect();
	end
	return true;
end
return table1;
