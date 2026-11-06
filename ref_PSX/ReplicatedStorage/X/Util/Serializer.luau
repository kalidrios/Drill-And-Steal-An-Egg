-- https://github.com/kalidrios

local m_BitBuffer = require(script.Parent.BitBuffer);
local table1 = {};
function table1.new(p1) -- Line: 17
	--[[
		Upvalues:
			[1] = m_BitBuffer
			[2] = table1
	--]]
	local table2 = {
		b = m_BitBuffer(p1),
		stringWriteCache = {},
		tableWriteCache = {},
		tableWriteCacheIndex = 0,
		instanceIndices = {},
		instances = {}
	};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.writeCacheIndex(p2, p3, p4) -- Line: 30
	if p4 <= 127 then
		p2.b.writeUInt8(p3);
		return;
	end
	if p4 <= 32767 then
		p2.b.writeUInt16(p3);
		return;
	end
	p2.b.writeUInt32(p3);
end
local table3 = {
	[false] = 1,
	[true] = 2
};
local u1 = nil;
function table1.write(_, p5) -- Line: 56
	--[[
		Upvalues:
			[1] = u1
	--]]
	local typeof_ret = typeof(p5);
	if not u1[typeof_ret] then
		error(string.format("Unknown type: %s", typeof_ret));
	end
end
local table4 = {
	["nil"] = function(p7) -- Line: 79
		p7.b.writeUInt8(0);
	end,
	boolean = function(p8, p9) -- boolean (Line: 83)
		--[[
			Upvalues:
				[1] = table3
		--]]
		p8.b.writeUInt8(table3[p9]);
	end,
	number = function(p10, p11) -- number (Line: 87)
		if p11 == 0 then
			p10.b.writeUInt8(3);
			return;
		end
		if p11 % 1 ~= 0 then
			local v8 = p11;
			local num1 = 0;
			local v11;
			if v8 < 0 then
				v11 = bit32.bnot(v8);
				num1 = 3;
			else
				v11 = v8 - 1;
			end
			if v11 <= 127 then
				p10.b.writeUInt8(num1 + 4);
				p10.b.writeUInt8(v11);
				return;
			end
			if v11 <= 32767 then
				p10.b.writeUInt8(num1 + 5);
				p10.b.writeUInt16(v11);
				return;
			end
			if v11 <= 2147483647 then
				p10.b.writeUInt8(num1 + 6);
				p10.b.writeUInt32(v11);
				return;
			end
		end
		p10.b.writeUInt8(10);
		p10.b.writeFloat64(p11);
	end,
	string = function(p12, p13) -- string (Line: 126)
		p12.b.writeUInt8(11);
		p12.b.writeString(p13);
	end,
	table = function(p14, p15) -- Line: 131
		assert(getmetatable(p15) == nil, "Cannot write metatable");
		local v3 = p14.tableWriteCache[p15];
		if v3 then
			p14.b.writeUInt8(12);
			p14:writeCacheIndex(v3, p14.tableWriteCacheIndex);
			return;
		end
		local t_tableWriteCacheIndex = p14.tableWriteCacheIndex;
		p14.tableWriteCacheIndex = t_tableWriteCacheIndex + 1;
		p14.tableWriteCache[p15] = t_tableWriteCacheIndex;
		local v4 = #p15;
		if v4 <= 0 then
			local v9 = 0;
			for _, _ in pairs(p15) do
				v9 = v9 + 1;
			end
			if v9 == 0 then
				p14.b.writeUInt8(13);
				return;
			end
			local v10 = v9 - 1;
			if v10 <= 127 then
				p14.b.writeUInt8(14);
				p14.b.writeUInt8(v10);
			elseif v10 <= 32767 then
				p14.b.writeUInt8(15);
				p14.b.writeUInt16(v10);
			else
				p14.b.writeUInt8(16);
				p14.b.writeUInt32(v10);
			end
			for key4, val4 in pairs(p15) do
				p14:write(key4);
				p14:write(val4);
			end
			return;
		end
		local v5 = v4 - 1;
		if v5 <= 127 then
			p14.b.writeUInt8(17);
			p14.b.writeUInt8(v5);
		elseif v5 <= 32767 then
			p14.b.writeUInt8(18);
			p14.b.writeUInt16(v5);
		else
			p14.b.writeUInt8(19);
			p14.b.writeUInt32(v5);
		end
		for _, val2 in ipairs(p15) do
			p14:write(val2);
		end
	end,
	Instance = function(p16, p17) -- Instance (Line: 190)
		local v6 = p16.instanceIndices[p17];
		if v6 then
			p16.b.writeUInt8(20);
			p16:writeCacheIndex(v6, #p16.instances);
			return;
		end
		local v7 = #p16.instances;
		table.insert(p16.instances, p17);
		p16.instanceIndices[p17] = v7;
		p16.b.writeUInt8(21);
	end
};
u1 = table4;
function table1.read(_) -- Line: 204
	return nil;
end
function table1.encodeArgs(...) -- Line: 210
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v1 = table1.new();
	local table_pack_ret = table.pack(...);
	for _, val1 in ipairs(table_pack_ret) do
		v1.write(val1);
	end
	return v1.b.dumpString(), v1.instances;
end
function table1.decodeArgs(p6) -- Line: 219
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(typeof(p6) == "string");
	local v2 = table1.new(p6);
	local table5 = {};
	while not v2.b.isFinished() do
		table.insert(table5, v2:read());
	end
	return table.unpack(table5);
end
return table1;
