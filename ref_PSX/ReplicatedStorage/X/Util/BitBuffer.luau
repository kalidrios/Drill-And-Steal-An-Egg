-- https://github.com/kalidrios

local table1 = {};
local table2 = {};
for index1 = 1, 64 do
	table1[index1 - 1] = string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", index1, index1);
	table2[string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", index1, index1)] = index1 - 1;
end
local table3 = {
	["0"] = "0000",
	["1"] = "0001",
	["2"] = "0010",
	["3"] = "0011",
	["4"] = "0100",
	["5"] = "0101",
	["6"] = "0110",
	["7"] = "0111",
	["8"] = "1000",
	["9"] = "1001",
	a = "1010",
	b = "1011",
	c = "1100",
	d = "1101",
	e = "1110",
	f = "1111"
};
local table4 = {
	[0] = Vector3.new(1, 0, 0),
	[1] = Vector3.new(0, 1, 0),
	[2] = Vector3.new(0, 0, 1),
	[3] = Vector3.new(-1, 0, 0),
	[4] = Vector3.new(0, -1, 0),
	[5] = Vector3.new(0, 0, -1)
};
local vec3 = Vector3.new(1, 1, 1);
local table5 = {
	[true] = 1,
	[false] = 0
};
local table6 = {};
for index2 = 0, 255 do
	local v1 = index2;
	for index5 = 1, 8 do
		local v74 = -bit32.band(v1, 1);
		v1 = bit32.bxor(bit32.rshift(v1, 1), (bit32.band(3988292384, v74)));
	end
	table6[index2] = v1;
end
local table7 = {};
for index3 = 0, 64 do
	table7[index3] = 2 ^ index3;
end
local table8 = {};
for index4 = 0, 255 do
	table8[index4] = string.format("%02x", index4);
end
return function(p1) -- bitBuffer (Line: 60)
	--[[
		Upvalues:
			[1] = table8
			[2] = table3
			[3] = table1
			[4] = table6
			[5] = table7
			[6] = table5
			[7] = table2
			[8] = vec3
			[9] = table4
	--]]
	if p1 ~= nil then
		assert(type(p1) == "string", "argument to BitBuffer constructor must be either nil or a string");
	end
	local u1 = 0;
	local u2 = {};
	local u3 = 0;
	local u4 = 0;
	local u5 = 0;
	local u6 = 0;
	local u7 = 1;
	if p1 then
		u4 = #p1;
		u5 = u4 * 8;
		u2 = table.create(#p1);
		for index6 = 1, u4 do
			u2[index6] = string.byte(p1, index6, index6);
		end
	end
	local function dumpBinary() -- Line: 91
		--[[
			Upvalues:
				[1] = u4
				[2] = u2
				[3] = table8
				[4] = table3
				[5] = u1
		--]]
		local table_create_ret = table.create(u4);
		for key1, val1 in ipairs(u2) do
			table_create_ret[key1] = string.gsub(table8[val1], "%x", table3);
		end
		if u1 ~= 0 then
			table_create_ret[u4] = string.sub(table_create_ret[u4], 1, u1);
		end
		return table.concat(table_create_ret, " ");
	end
	local function dumpString() -- Line: 107
		--[[
			Upvalues:
				[1] = u4
				[2] = u2
		--]]
		local table_create_ret2 = table.create((math.ceil(u4 / 4096)));
		local v75 = 1;
		for index7 = 1, u4, 4096 do
			table_create_ret2[v75] = string.char(table.unpack(u2, index7, (math.min(u4, index7 + 4095))));
			v75 = v75 + 1;
		end
		return table.concat(table_create_ret2, "");
	end
	local function dumpHex() -- Line: 123
		--[[
			Upvalues:
				[1] = u4
				[2] = u2
				[3] = table8
		--]]
		local table_create_ret3 = table.create(u4);
		for key2, val2 in ipairs(u2) do
			table_create_ret3[key2] = table8[val2];
		end
		return table.concat(table_create_ret3, "");
	end
	local function dumpBase64() -- Line: 133
		--[[
			Upvalues:
				[1] = u4
				[2] = u2
				[3] = table1
		--]]
		local table_create_ret4 = table.create((math.ceil(u4 * 1.333)));
		local v76 = 1;
		for index8 = 1, u4, 3 do
			local v255 = u2[index8];
			local v256 = u2[index8 + 1];
			local v257 = u2[index8 + 2];
			local bit32_bor_ret = bit32.bor(bit32.lshift(v255, 16), bit32.lshift(v256 or 0, 8), v257 or 0);
			table_create_ret4[v76] = table1[bit32.rshift(bit32.band(bit32_bor_ret, 16515072), 18)];
			table_create_ret4[v76 + 1] = table1[bit32.rshift(bit32.band(bit32_bor_ret, 258048), 12)];
			table_create_ret4[v76 + 2] = v256 and table1[bit32.rshift(bit32.band(bit32_bor_ret, 4032), 6)] or 61;
			table_create_ret4[v76 + 3] = v257 and table1[bit32.band(bit32_bor_ret, 63)] or 61;
			v76 = v76 + 4;
		end
		local v77 = v76 - 1;
		local table_create_ret5 = table.create((math.ceil(v77 / 4096)));
		local v78 = 1;
		for index9 = 1, v77, 4096 do
			table_create_ret5[v78] = string.char(table.unpack(table_create_ret4, index9, (math.min(v77, index9 + 4095))));
			v78 = v78 + 1;
		end
		return table.concat(table_create_ret5, "");
	end
	local function exportChunk(p2) -- Line: 167
		--[[
			Upvalues:
				[1] = u4
				[2] = u2
		--]]
		assert(type(p2) == "number", "argument #1 to BitBuffer.exportChunk should be a number");
		assert(p2 > 0, "argument #1 to BitBuffer.exportChunk should be above zero");
		assert(p2 % 1 == 0, "argument #1 to BitBuffer.exportChunk should be an integer");
		return coroutine.wrap(function() -- Line: 175
			--[[
				Upvalues:
					[1] = p2
					[2] = u4
					[3] = u2
			--]]
			local v311 = p2 - 1;
			for index31 = 1, u4, p2 do
				local string_char_ret = string.char(table.unpack(u2, index31, (math.min(u4, index31 + v311))));
				coroutine.yield(index31, string_char_ret);
			end
		end);
	end
	local function exportBase64Chunk(p3) -- Line: 185
		--[[
			Upvalues:
				[1] = u4
				[2] = u2
				[3] = table1
		--]]
		p3 = p3 or 76;
		assert(type(p3) == "number", "argument #1 to BitBuffer.exportBase64Chunk should be a number");
		assert(p3 > 0, "argument #1 to BitBuffer.exportBase64Chunk should be above zero");
		assert(p3 % 1 == 0, "argument #1 to BitBuffer.exportBase64Chunk should be an integer");
		local table_create_ret6 = table.create((math.ceil(u4 * 0.333)));
		local v79 = 1;
		for index10 = 1, u4, 3 do
			local v258 = u2[index10];
			local v259 = u2[index10 + 1];
			local v260 = u2[index10 + 2];
			local bit32_bor_ret2 = bit32.bor(bit32.lshift(v258, 16), bit32.lshift(v259 or 0, 8), v260 or 0);
			table_create_ret6[v79] = table1[bit32.rshift(bit32.band(bit32_bor_ret2, 16515072), 18)];
			table_create_ret6[v79 + 1] = table1[bit32.rshift(bit32.band(bit32_bor_ret2, 258048), 12)];
			table_create_ret6[v79 + 2] = v259 and table1[bit32.rshift(bit32.band(bit32_bor_ret2, 4032), 6)] or 61;
			table_create_ret6[v79 + 3] = v260 and table1[bit32.band(bit32_bor_ret2, 63)] or 61;
			v79 = v79 + 4;
		end
		local u20 = v79 - 1;
		return coroutine.wrap(function() -- Line: 207
			--[[
				Upvalues:
					[1] = p3
					[2] = u20
					[3] = table_create_ret6
			--]]
			local v312 = p3 - 1;
			for index32 = 1, u20, p3 do
				local string_char_ret2 = string.char(table.unpack(table_create_ret6, index32, (math.min(u20, index32 + v312))));
				coroutine.yield(string_char_ret2);
			end
		end);
	end
	local function exportHexChunk(p4) -- Line: 216
		--[[
			Upvalues:
				[1] = u4
				[2] = table8
				[3] = u2
		--]]
		assert(type(p4) == "number", "argument #1 to BitBuffer.exportHexChunk should be a number");
		assert(p4 > 0, "argument #1 to BitBuffer.exportHexChunk should be above zero");
		assert(p4 % 1 == 0, "argument #1 to BitBuffer.exportHexChunk should be an integer");
		local math_floor_ret = math.floor(p4 / 2);
		if p4 % 2 == 0 then
			return coroutine.wrap(function() -- Line: 224
				--[[
					Upvalues:
						[1] = u4
						[2] = math_floor_ret
						[3] = table8
						[4] = u2
				--]]
				local table10 = {};
				for index33 = 1, u4, math_floor_ret do
					for index34 = 0, math_floor_ret - 1 do
						table10[index34] = table8[u2[index33 + index34]];
					end
					coroutine.yield(table.concat(table10, "", 0));
				end
			end);
		end
		return coroutine.wrap(function() -- Line: 234
			--[[
				Upvalues:
					[1] = u4
					[2] = math_floor_ret
					[3] = table8
					[4] = u2
			--]]
			local table9 = {[0] = ""};
			local v313 = "";
			local v314 = 1;
			while v314 <= u4 do
				if v313 == "" then
					table9[0] = "";
					for index35 = 0, math_floor_ret - 1 do
						table9[index35 + 1] = table8[u2[v314 + index35]];
					end
					local v319 = table8[u2[v314 + math_floor_ret]];
					if v319 then
						table9[math_floor_ret + 1] = string.sub(v319, 1, 1);
						v313 = string.sub(v319, 2, 2);
					end
					v314 = v314 + 1;
				else
					table9[0] = v313;
					for index36 = 0, math_floor_ret - 1 do
						table9[index36 + 1] = table8[u2[v314 + index36]];
					end
					table9[math_floor_ret + 1] = "";
					v313 = "";
				end
				coroutine.yield(table.concat(table9, "", 0));
				v314 = v314 + math_floor_ret;
			end
		end);
	end
	local function crc32() -- Line: 267
		--[[
			Upvalues:
				[1] = u2
				[2] = table6
		--]]
		local v80 = 4294967295;
		for _, val3 in ipairs(u2) do
			local v261 = table6[bit32.band(bit32.bxor(v80, val3), 255)];
			v80 = bit32.bxor(bit32.rshift(v80, 8), v261);
		end
		return bit32.bnot(v80) % 4294967295;
	end
	local function getLength() -- Line: 278
		--[[
			Upvalues:
				[1] = u5
		--]]
		return u5;
	end
	local function getByteLength() -- Line: 282
		--[[
			Upvalues:
				[1] = u4
		--]]
		return u4;
	end
	local function getPointer() -- Line: 286
		--[[
			Upvalues:
				[1] = u6
		--]]
		return u6;
	end
	local function setPointer(p5) -- Line: 291
		--[[
			Upvalues:
				[1] = u5
				[2] = u6
				[3] = u7
		--]]
		assert(type(p5) == "number", "argument #1 to BitBuffer.setPointer should be a number");
		assert(p5 >= 0, "argument #1 to BitBuffer.setPointer should be zero or higher");
		assert(p5 % 1 == 0, "argument #1 to BitBuffer.setPointer should be an integer");
		assert(p5 <= u5, "argument #1 to BitBuffer.setPointerByte should within range of the buffer");
		u6 = p5;
		u7 = math.floor(p5 / 8) + 1;
	end
	local function setPointerFromEnd(p6) -- Line: 301
		--[[
			Upvalues:
				[1] = u5
				[2] = u6
				[3] = u7
		--]]
		assert(type(p6) == "number", "argument #1 to BitBuffer.setPointerFromEnd should be a number");
		assert(p6 >= 0, "argument #1 to BitBuffer.setPointerFromEnd should be zero or higher");
		assert(p6 % 1 == 0, "argument #1 to BitBuffer.setPointerFromEnd should be an integer");
		assert(p6 <= u5, "argument #1 to BitBuffer.setPointerFromEnd should within range of the buffer");
		u6 = u5 - p6;
		u7 = math.floor(u6 / 8 + 1);
	end
	local function getPointerByte() -- Line: 311
		--[[
			Upvalues:
				[1] = u7
		--]]
		return u7;
	end
	local function setPointerByte(p7) -- Line: 315
		--[[
			Upvalues:
				[1] = u4
				[2] = u6
				[3] = u7
		--]]
		assert(type(p7) == "number", "argument #1 to BitBuffer.setPointerByte should be a number");
		assert(p7 > 0, "argument #1 to BitBuffer.setPointerByte should be positive");
		assert(p7 % 1 == 0, "argument #1 to BitBuffer.setPointerByte should be an integer");
		assert(p7 <= u4, "argument #1 to BitBuffer.setPointerByte should be within range of the buffer");
		u6 = p7 * 8;
		u7 = p7;
	end
	local function setPointerByteFromEnd(p8) -- Line: 325
		--[[
			Upvalues:
				[1] = u4
				[2] = u7
				[3] = u6
		--]]
		assert(type(p8) == "number", "argument #1 to BitBuffer.setPointerByteFromEnd should be a number");
		assert(p8 >= 0, "argument #1 to BitBuffer.setPointerByteFromEnd should be zero or higher");
		assert(p8 % 1 == 0, "argument #1 to BitBuffer.setPointerByteFromEnd should be an integer");
		assert(p8 <= u4, "argument #1 to BitBuffer.setPointerByteFromEnd should be within range of the buffer");
		u7 = u4 - p8;
		u6 = u7 * 8;
	end
	local function isFinished() -- Line: 335
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
		--]]
		return u6 == u5;
	end
	local function writeBits(...) -- Line: 339
		--[[
			Upvalues:
				[1] = u5
				[2] = u1
				[3] = u4
				[4] = u3
				[5] = table7
				[6] = u2
		--]]
		local select_ret = select("#", ...);
		if select_ret == 0 then return end
		u5 = u5 + select_ret;
		local table_pack_ret = table.pack(...);
		for _, val4 in ipairs(table_pack_ret) do
			assert(val4 == 1 and true or val4 == 0, "arguments to BitBuffer.writeBits should be either 1 or 0");
			if u1 == 0 then
				u4 = u4 + 1;
			end
			u3 = u3 + (val4 == 1 and table7[7 - u1] or 0);
			u1 = u1 + 1;
			if u1 ~= 8 then continue end
			u1 = 0;
			u2[u4] = u3;
			u3 = 0;
		end
		if u1 ~= 0 then
			u2[u4] = u3;
		end
	end
	local function writeBoolean(p9) -- Line: 369
		--[[
			Upvalues:
				[1] = writeBits
				[2] = table5
		--]]
		assert(typeof(p9) == "boolean", "argument #1 to BitBuffer.writeBoolean should be a boolean");
		writeBits(table5[p9]);
	end
	local function writeByte(p10) -- Line: 374
		--[[
			Upvalues:
				[1] = u1
				[2] = u4
				[3] = u2
				[4] = u3
				[5] = u5
		--]]
		assert(type(p10) == "number", "argument #1 to BitBuffer.writeByte should be a number");
		assert(p10 >= 0 and p10 <= 255 or false, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
		assert(p10 % 1 == 0, "argument #1 to BitBuffer.writeByte should be an integer");
		if u1 == 0 then
			u4 = u4 + 1;
			u2[u4] = p10;
		else
			u2[u4] = u3 + bit32.rshift(p10, u1);
			u4 = u4 + 1;
			u3 = bit32.band(bit32.lshift(p10, 8 - u1), 255);
			u2[u4] = u3;
		end
		u5 = u5 + 8;
	end
	local function writeUnsigned(p11, p12) -- Line: 394
		--[[
			Upvalues:
				[1] = table7
				[2] = writeByte
				[3] = table5
				[4] = writeBits
		--]]
		assert(type(p11) == "number", "argument #1 to BitBuffer.writeUnsigned should be a number");
		assert(p11 >= 1 and p11 <= 64 or false, "argument #1 to BitBuffer.writeUnsigned should be in the range [1, 64]");
		assert(p11 % 1 == 0, "argument #1 to BitBuffer.writeUnsigned should be an integer");
		assert(type(p12) == "number", "argument #2 to BitBuffer.writeUnsigned should be a number");
		assert(p12 >= 0 and p12 <= table7[p11] - 1 or false, "argument #2 to BitBuffer.writeUnsigned is out of range");
		assert(p12 % 1 == 0, "argument #2 to BitBuffer.writeUnsigned should be an integer");
		local math_floor_ret2 = math.floor(p11 / 8);
		local v81 = p11 % 8;
		local table_create_ret7 = table.create(v81);
		if p11 <= 32 then
			local v262 = p11;
			for index28 = 1, math_floor_ret2 do
				v262 = v262 - 8;
				writeByte((bit32.extract(p12, v262, 8)));
			end
			for index29 = v81 - 1, 0, -1 do
				table_create_ret7[v81 - index29] = table5[bit32.btest(p12, table7[index29])];
			end
			writeBits(table.unpack(table_create_ret7));
			return;
		end
		local v82 = p12 % 4294967296;
		local math_floor_ret3 = math.floor(p12 / 4294967296);
		local v83 = p11 - 32;
		for index11 = 1, math_floor_ret2 - 4 do
			v83 = v83 - 8;
			writeByte((bit32.extract(math_floor_ret3, v83, 8)));
		end
		for index12 = v81 - 1, 0, -1 do
			table_create_ret7[v81 - index12] = table5[bit32.btest(math_floor_ret3, table7[index12])];
		end
		writeBits(table.unpack(table_create_ret7));
		writeByte((bit32.extract(v82, 24, 8)));
		writeByte((bit32.extract(v82, 16, 8)));
		writeByte((bit32.extract(v82, 8, 8)));
		writeByte((bit32.extract(v82, 0, 8)));
	end
	local function writeSigned(p13, p14) -- Line: 447
		--[[
			Upvalues:
				[1] = table7
				[2] = writeBits
				[3] = writeUnsigned
		--]]
		assert(type(p13) == "number", "argument #1 to BitBuffer.writeSigned should be a number");
		assert(p13 >= 2 and p13 <= 64 or false, "argument #1 to BitBuffer.writeSigned should be in the range [2, 64]");
		assert(p13 % 1 == 0, "argument #1 to BitBuffer.writeSigned should be an integer");
		assert(type(p14) == "number", "argument #2 to BitBuffer.writeSigned should be a number");
		assert(-table7[p13 - 1] <= p14 and table7[p13 - 1] - 1 >= p14 or false, "argument #2 to BitBuffer.writeSigned is out of range");
		assert(p14 % 1 == 0, "argument #2 to BitBuffer.writeSigned should be an integer");
		if p14 >= 0 then
			writeBits(0);
			writeUnsigned(p13 - 1, p14);
			return;
		end
		writeBits(1);
		writeUnsigned(p13 - 1, table7[p13 - 1] + p14);
	end
	local function writeFloat(p15, p16, p17) -- Line: 472
		--[[
			Upvalues:
				[1] = table7
				[2] = writeBits
				[3] = table5
				[4] = writeUnsigned
		--]]
		assert(type(p15) == "number", "argument #1 to BitBuffer.writeFloat should be a number");
		assert(p15 >= 1 and p15 <= 64 or false, "argument #1 to BitBuffer.writeFloat should be in the range [1, 64]");
		assert(p15 % 1 == 0, "argument #1 to BitBuffer.writeFloat should be an integer");
		assert(type(p16) == "number", "argument #2 to BitBuffer.writeFloat should be a number");
		assert(p16 >= 1 and p16 <= 64 or false, "argument #2 to BitBuffer.writeFloat should be in the range [1, 64]");
		assert(p16 % 1 == 0, "argument #2 to BitBuffer.writeFloat should be an integer");
		assert(type(p17) == "number", "argument #3 to BitBuffer.writeFloat should be a number");
		local v84 = table7[p15 - 1] - 1;
		local v85 = p17 < 0;
		p17 = math.abs(p17);
		local math_frexp_ret1, math_frexp_ret2 = math.frexp(p17);
		if p17 == math.huge then
			writeBits(table5[v85]);
			writeUnsigned(p15, table7[p15] - 1);
			writeUnsigned(p16, 0);
			return;
		end
		if p17 ~= p17 then
			writeBits(table5[v85]);
			writeUnsigned(p15, table7[p15] - 1);
			writeUnsigned(p16, 10);
			return;
		end
		if p17 == 0 then
			writeUnsigned(p15 + p16 + 1, 0);
			return;
		end
		if math_frexp_ret2 + v84 <= 1 then
			local math_floor_ret5 = math.floor(math_frexp_ret1 * table7[p16] + 0.5);
			writeBits(table5[v85]);
			writeUnsigned(p15, 0);
			writeUnsigned(p16, math_floor_ret5);
			return;
		end
		local math_floor_ret4 = math.floor((math_frexp_ret1 - 0.5) * 2 * table7[p16] + 0.5);
		writeBits(table5[v85]);
		writeUnsigned(p15, math_frexp_ret2 + v84 - 1);
		writeUnsigned(p16, math_floor_ret4);
	end
	local function writeBase64(p18) -- Line: 576
		--[[
			Upvalues:
				[1] = table2
				[2] = writeByte
		--]]
		assert(type(p18) == "string", "argument #1 to BitBuffer.writeBase64 should be a string");
		assert(not string.find(p18, "[^%w%+/=]"), "argument #1 to BitBuffer.writeBase64 should only contain valid base64 characters");
		for index13 = 1, #p18, 4 do
			local string_byte_ret1, string_byte_ret2, string_byte_ret3, string_byte_ret4 = string.byte(p18, index13, index13 + 3);
			local v263 = table2[string_byte_ret1];
			local v264 = table2[string_byte_ret2];
			local v265 = table2[string_byte_ret3];
			local v266 = table2[string_byte_ret4];
			local bit32_bor_ret3 = bit32.bor(bit32.lshift(v263, 18), bit32.lshift(v264, 12), bit32.lshift(v265 or 0, 6), v266 or 0);
			writeByte((bit32.rshift(bit32_bor_ret3, 16)));
			if not v265 then break end
			writeByte((bit32.band(bit32.rshift(bit32_bor_ret3, 8), 255)));
			if not v266 then break end
			writeByte((bit32.band(bit32_bor_ret3, 255)));
		end
	end
	local function writeString(p19) -- Line: 605
		--[[
			Upvalues:
				[1] = writeUnsigned
				[2] = writeByte
		--]]
		assert(type(p19) == "string", "argument #1 to BitBuffer.writeString  should be a string");
		writeUnsigned(24, #p19);
		for index14 = 1, #p19 do
			writeByte(string.byte(p19, index14, index14));
		end
	end
	local function writeTerminatedString(p20) -- Line: 621
		--[[
			Upvalues:
				[1] = writeByte
				[2] = u1
				[3] = u4
				[4] = u2
				[5] = u3
				[6] = u5
		--]]
		assert(type(p20) == "string", "argument #1 to BitBuffer.writeTerminatedString should be a string");
		for index15 = 1, #p20 do
			writeByte(string.byte(p20, index15, index15));
		end
		assert(true, "argument #1 to BitBuffer.writeByte should be a number");
		assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
		assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
		if u1 == 0 then
			u4 = u4 + 1;
			u2[u4] = 0;
		else
			u2[u4] = u3 + bit32.rshift(0, u1);
			u4 = u4 + 1;
			u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
			u2[u4] = u3;
		end
		u5 = u5 + 8;
	end
	local function writeSetLengthString(p21) -- Line: 633
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(type(p21) == "string", "argument #1 to BitBuffer.writeSetLengthString should be a string");
		for index16 = 1, #p21 do
			writeByte(string.byte(p21, index16, index16));
		end
	end
	local function writeField(...) -- Line: 644
		--[[
			Upvalues:
				[1] = writeUnsigned
		--]]
		local v86 = 0;
		local table_pack_ret2 = table.pack(...);
		for index17 = 1, table_pack_ret2.n do
			v86 = v86 * 2;
			if table_pack_ret2[index17] then
				v86 = v86 + 1;
			end
		end
		writeUnsigned(table_pack_ret2.n, v86);
	end
	local function writeUInt8(p22) -- Line: 665
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(type(p22) == "number", "argument #1 to BitBuffer.writeUInt8 should be a number");
		assert(p22 >= 0 and p22 <= 255 or false, "argument #1 to BitBuffer.writeUInt8 should be in the range [0, 255]");
		assert(p22 % 1 == 0, "argument #1 to BitBuffer.writeUInt8 should be an integer");
		writeByte(p22);
	end
	local function writeUInt16(p23) -- Line: 673
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(type(p23) == "number", "argument #1 to BitBuffer.writeUInt16 should be a number");
		assert(p23 >= 0 and p23 <= 65535 or false, "argument #1 to BitBuffer.writeInt16 should be in the range [0, 65535]");
		assert(p23 % 1 == 0, "argument #1 to BitBuffer.writeUInt16 should be an integer");
		writeByte((bit32.rshift(p23, 8)));
		writeByte((bit32.band(p23, 255)));
	end
	local function writeUInt32(p24) -- Line: 682
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(type(p24) == "number", "argument #1 to BitBuffer.writeUInt32 should be a number");
		assert(p24 >= 0 and p24 <= 4294967295 or false, "argument #1 to BitBuffer.writeUInt32 should be in the range [0, 4294967295]");
		assert(p24 % 1 == 0, "argument #1 to BitBuffer.writeUInt32 should be an integer");
		writeByte((bit32.rshift(p24, 24)));
		writeByte((bit32.band(bit32.rshift(p24, 16), 255)));
		writeByte((bit32.band(bit32.rshift(p24, 8), 255)));
		writeByte((bit32.band(p24, 255)));
	end
	local function writeInt8(p25) -- Line: 696
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(type(p25) == "number", "argument #1 to BitBuffer.writeInt8 should be a number");
		assert(p25 >= -128 and p25 <= 127 or false, "argument #1 to BitBuffer.writeInt8 should be in the range [-128, 127]");
		assert(p25 % 1 == 0, "argument #1 to BitBuffer.writeInt8 should be an integer");
		if p25 < 0 then
			p25 = p25 + 128 + 128;
		end
		writeByte(p25);
	end
	local function writeInt16(p26) -- Line: 708
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(type(p26) == "number", "argument #1 to BitBuffer.writeInt16 should be a number");
		assert(p26 >= -32768 and p26 <= 32767 or false, "argument #1 to BitBuffer.writeInt16 should be in the range [-32768, 32767]");
		assert(p26 % 1 == 0, "argument #1 to BitBuffer.writeInt16 should be an integer");
		if p26 < 0 then
			p26 = p26 + 32768 + 32768;
		end
		writeByte((bit32.rshift(p26, 8)));
		writeByte((bit32.band(p26, 255)));
	end
	local function writeInt32(p27) -- Line: 721
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(type(p27) == "number", "argument #1 to BitBuffer.writeInt32 should be a number");
		assert(p27 >= -2147483648 and p27 <= 2147483647 or false, "argument #1 to BitBuffer.writeInt32 should be in the range [-2147483648, 2147483647]");
		assert(p27 % 1 == 0, "argument #1 to BitBuffer.writeInt32 should be an integer");
		if p27 < 0 then
			p27 = p27 + 2147483648 + 2147483648;
		end
		writeByte((bit32.rshift(p27, 24)));
		writeByte((bit32.band(bit32.rshift(p27, 16), 255)));
		writeByte((bit32.band(bit32.rshift(p27, 8), 255)));
		writeByte((bit32.band(p27, 255)));
	end
	local function writeFloat16(p28) -- Line: 739
		--[[
			Upvalues:
				[1] = u1
				[2] = u4
				[3] = u2
				[4] = u3
				[5] = u5
				[6] = writeByte
		--]]
		assert(type(p28) == "number", "argument #1 to BitBuffer.writeFloat16 should be a number");
		local v87 = p28 < 0;
		p28 = math.abs(p28);
		local math_frexp_ret1_2, math_frexp_ret2_2 = math.frexp(p28);
		if p28 ~= math.huge then
			if p28 ~= p28 then
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 127;
				else
					u2[u4] = u3 + bit32.rshift(127, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(127, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 255;
				else
					u2[u4] = u3 + bit32.rshift(255, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
				return;
			end
			if p28 == 0 then
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 0;
				else
					u2[u4] = u3 + bit32.rshift(0, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 0;
				else
					u2[u4] = u3 + bit32.rshift(0, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
				return;
			end
			if math_frexp_ret2_2 + 15 <= 1 then
				local math_floor_ret7 = math.floor(math_frexp_ret1_2 * 1024 + 0.5);
				if v87 then
					writeByte(bit32.rshift(math_floor_ret7, 8) + 128);
				else
					writeByte((bit32.rshift(math_floor_ret7, 8)));
				end
				writeByte((bit32.band(math_floor_ret7, 255)));
				return;
			end
			local math_floor_ret6 = math.floor((math_frexp_ret1_2 - 0.5) * 2048 + 0.5);
			if v87 then
				writeByte(bit32.lshift(math_frexp_ret2_2 + 14, 2) + 128 + bit32.rshift(math_floor_ret6, 8));
			else
				writeByte(bit32.lshift(math_frexp_ret2_2 + 14, 2) + bit32.rshift(math_floor_ret6, 8));
			end
			writeByte((bit32.band(math_floor_ret6, 255)));
			return;
		end
		if v87 then
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 252;
			else
				u2[u4] = u3 + bit32.rshift(252, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(252, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
		else
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 124;
			else
				u2[u4] = u3 + bit32.rshift(124, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(124, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
		end
		assert(true, "argument #1 to BitBuffer.writeByte should be a number");
		assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
		assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
		if u1 == 0 then
			u4 = u4 + 1;
			u2[u4] = 0;
		else
			u2[u4] = u3 + bit32.rshift(0, u1);
			u4 = u4 + 1;
			u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
			u2[u4] = u3;
		end
		u5 = u5 + 8;
	end
	local function writeFloat32(p29) -- Line: 786
		--[[
			Upvalues:
				[1] = u1
				[2] = u4
				[3] = u2
				[4] = u3
				[5] = u5
				[6] = writeByte
		--]]
		assert(type(p29) == "number", "argument #1 to BitBuffer.writeFloat32 should be a number");
		local v88 = p29 < 0;
		p29 = math.abs(p29);
		local math_frexp_ret1_3, math_frexp_ret2_3 = math.frexp(p29);
		if p29 == math.huge then
			if v88 then
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 255;
				else
					u2[u4] = u3 + bit32.rshift(255, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
			else
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 127;
				else
					u2[u4] = u3 + bit32.rshift(127, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(127, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
			end
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 128;
			else
				u2[u4] = u3 + bit32.rshift(128, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(128, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			return;
		end
		if p29 ~= p29 then
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 127;
			else
				u2[u4] = u3 + bit32.rshift(127, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(127, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			return;
		end
		if p29 == 0 then
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			return;
		end
		if math_frexp_ret2_3 + 127 > 1 then
			local math_floor_ret8 = math.floor((math_frexp_ret1_3 - 0.5) * 16777216 + 0.5);
			if v88 then
				writeByte(bit32.rshift(math_frexp_ret2_3 + 126, 1) + 128);
			else
				writeByte((bit32.rshift(math_frexp_ret2_3 + 126, 1)));
			end
			writeByte(bit32.band(bit32.lshift(math_frexp_ret2_3 + 126, 7), 255) + bit32.rshift(math_floor_ret8, 16));
			writeByte((bit32.band(bit32.rshift(math_floor_ret8, 8), 255)));
			writeByte((bit32.band(math_floor_ret8, 255)));
			return;
		end
		local math_floor_ret9 = math.floor(math_frexp_ret1_3 * 8388608 + 0.5);
		if v88 then
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 128;
			else
				u2[u4] = u3 + bit32.rshift(128, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(128, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
		else
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
		end
		writeByte((bit32.rshift(math_floor_ret9, 16)));
		writeByte((bit32.band(bit32.rshift(math_floor_ret9, 8), 255)));
		writeByte((bit32.band(math_floor_ret9, 255)));
	end
	local function writeFloat64(p30) -- Line: 843
		--[[
			Upvalues:
				[1] = u1
				[2] = u4
				[3] = u2
				[4] = u3
				[5] = u5
				[6] = writeByte
		--]]
		assert(type(p30) == "number", "argument #1 to BitBuffer.writeFloat64 should be a number");
		local v89 = p30 < 0;
		p30 = math.abs(p30);
		local math_frexp_ret1_4, math_frexp_ret2_4 = math.frexp(p30);
		if p30 == math.huge then
			if v89 then
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 255;
				else
					u2[u4] = u3 + bit32.rshift(255, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
			else
				assert(true, "argument #1 to BitBuffer.writeByte should be a number");
				assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
				assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
				if u1 == 0 then
					u4 = u4 + 1;
					u2[u4] = 127;
				else
					u2[u4] = u3 + bit32.rshift(127, u1);
					u4 = u4 + 1;
					u3 = bit32.band(bit32.lshift(127, 8 - u1), 255);
					u2[u4] = u3;
				end
				u5 = u5 + 8;
			end
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 240;
			else
				u2[u4] = u3 + bit32.rshift(240, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(240, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			return;
		end
		if p30 ~= p30 then
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 127;
			else
				u2[u4] = u3 + bit32.rshift(127, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(127, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 255;
			else
				u2[u4] = u3 + bit32.rshift(255, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(255, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			return;
		end
		if p30 == 0 then
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
			return;
		end
		if math_frexp_ret2_4 + 1023 > 1 then
			local math_floor_ret10 = math.floor((math_frexp_ret1_4 - 0.5) * 9007199254740992 + 0.5);
			if v89 then
				writeByte(bit32.rshift(math_frexp_ret2_4 + 1022, 4) + 128);
			else
				writeByte((bit32.rshift(math_frexp_ret2_4 + 1022, 4)));
			end
			local v267 = math_floor_ret10 % 4294967296;
			local math_floor_ret11 = math.floor(math_floor_ret10 / 4294967296);
			writeByte(bit32.band(bit32.lshift(math_frexp_ret2_4 + 1022, 4), 255) + bit32.rshift(math_floor_ret11, 16));
			writeByte((bit32.band(bit32.rshift(math_floor_ret11, 8), 255)));
			writeByte((bit32.band(math_floor_ret11, 255)));
			writeByte((bit32.rshift(v267, 24)));
			writeByte((bit32.band(bit32.rshift(v267, 16), 255)));
			writeByte((bit32.band(bit32.rshift(v267, 8), 255)));
			writeByte((bit32.band(v267, 255)));
			return;
		end
		local math_floor_ret12 = math.floor(math_frexp_ret1_4 * 4503599627370496 + 0.5);
		if v89 then
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 128;
			else
				u2[u4] = u3 + bit32.rshift(128, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(128, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
		else
			assert(true, "argument #1 to BitBuffer.writeByte should be a number");
			assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
			assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
			if u1 == 0 then
				u4 = u4 + 1;
				u2[u4] = 0;
			else
				u2[u4] = u3 + bit32.rshift(0, u1);
				u4 = u4 + 1;
				u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
				u2[u4] = u3;
			end
			u5 = u5 + 8;
		end
		local v90 = math_floor_ret12 % 4294967296;
		local math_floor_ret13 = math.floor(math_floor_ret12 / 4294967296);
		writeByte((bit32.rshift(math_floor_ret13, 16)));
		writeByte((bit32.band(bit32.rshift(math_floor_ret13, 8), 255)));
		writeByte((bit32.band(math_floor_ret13, 255)));
		writeByte((bit32.rshift(v90, 24)));
		writeByte((bit32.band(bit32.rshift(v90, 16), 255)));
		writeByte((bit32.band(bit32.rshift(v90, 8), 255)));
		writeByte((bit32.band(v90, 255)));
	end
	local function writeBrickColor(p31) -- Line: 928
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(typeof(p31) == "BrickColor", "argument #1 to BitBuffer.writeBrickColor should be a BrickColor");
		local t_Number = p31.Number;
		assert(type(t_Number) == "number", "argument #1 to BitBuffer.writeUInt16 should be a number");
		assert(t_Number >= 0 and t_Number <= 65535 or false, "argument #1 to BitBuffer.writeInt16 should be in the range [0, 65535]");
		assert(t_Number % 1 == 0, "argument #1 to BitBuffer.writeUInt16 should be an integer");
		writeByte((bit32.rshift(t_Number, 8)));
		writeByte((bit32.band(t_Number, 255)));
	end
	local function writeColor3(p32) -- Line: 934
		--[[
			Upvalues:
				[1] = writeByte
		--]]
		assert(typeof(p32) == "Color3", "argument #1 to BitBuffer.writeColor3 should be a Color3");
		writeByte((math.floor(p32.R * 255 + 0.5)));
		writeByte((math.floor(p32.G * 255 + 0.5)));
		writeByte((math.floor(p32.B * 255 + 0.5)));
	end
	local function writeCFrame(p33) -- Line: 942
		--[[
			Upvalues:
				[1] = vec3
				[2] = table4
				[3] = writeByte
				[4] = writeFloat32
				[5] = u1
				[6] = u4
				[7] = u2
				[8] = u3
				[9] = u5
		--]]
		assert(typeof(p33) == "CFrame", "argument #1 to BitBuffer.writeCFrame should be a CFrame");
		local t_UpVector = p33.UpVector;
		local t_RightVector = p33.RightVector;
		local math_abs_ret = math.abs((t_RightVector:Dot(vec3)));
		local math_abs_ret2 = math.abs((t_UpVector:Dot(vec3)));
		if (math.abs(1 - math_abs_ret) < 0.00001 or math_abs_ret == 0) and (math.abs(1 - math_abs_ret2) < 0.00001 and true or math_abs_ret2 == 0) or false then
			local t_Position = p33.Position;
			local v268 = nil;
			local v269 = nil;
			for index30 = 0, 5 do
				local v315 = table4[index30];
				if 1 - v315:Dot(t_RightVector) < 0.00001 then
					v268 = index30;
				end
				if 1 - v315:Dot(t_UpVector) < 0.00001 then
					v269 = index30;
				end
			end
			writeByte(v268 * 6 + v269);
			writeFloat32(t_Position.X);
			writeFloat32(t_Position.Y);
			writeFloat32(t_Position.Z);
			return;
		end
		assert(true, "argument #1 to BitBuffer.writeByte should be a number");
		assert(true, "argument #1 to BitBuffer.writeByte should be in the range [0, 255]");
		assert(true, "argument #1 to BitBuffer.writeByte should be an integer");
		if u1 == 0 then
			u4 = u4 + 1;
			u2[u4] = 0;
		else
			u2[u4] = u3 + bit32.rshift(0, u1);
			u4 = u4 + 1;
			u3 = bit32.band(bit32.lshift(0, 8 - u1), 255);
			u2[u4] = u3;
		end
		u5 = u5 + 8;
		local GetComponents_ret1, GetComponents_ret2, GetComponents_ret3, GetComponents_ret4, GetComponents_ret5, GetComponents_ret6, GetComponents_ret7, GetComponents_ret8, GetComponents_ret9, GetComponents_ret10, GetComponents_ret11, GetComponents_ret12 = p33:GetComponents();
		writeFloat32(GetComponents_ret1);
		writeFloat32(GetComponents_ret2);
		writeFloat32(GetComponents_ret3);
		writeFloat32(GetComponents_ret4);
		writeFloat32(GetComponents_ret5);
		writeFloat32(GetComponents_ret6);
		writeFloat32(GetComponents_ret7);
		writeFloat32(GetComponents_ret8);
		writeFloat32(GetComponents_ret9);
		writeFloat32(GetComponents_ret10);
		writeFloat32(GetComponents_ret11);
		writeFloat32(GetComponents_ret12);
	end
	local function writeVector3(p34) -- Line: 1006
		--[[
			Upvalues:
				[1] = writeFloat32
		--]]
		assert(typeof(p34) == "Vector3", "argument #1 to BitBuffer.writeVector3 should be a Vector3");
		writeFloat32(p34.X);
		writeFloat32(p34.Y);
		writeFloat32(p34.Z);
	end
	local function writeVector2(p35) -- Line: 1014
		--[[
			Upvalues:
				[1] = writeFloat32
		--]]
		assert(typeof(p35) == "Vector2", "argument #1 to BitBuffer.writeVector2 should be a Vector2");
		writeFloat32(p35.X);
		writeFloat32(p35.Y);
	end
	local function writeUDim2(p36) -- Line: 1021
		--[[
			Upvalues:
				[1] = writeFloat32
				[2] = writeInt32
		--]]
		assert(typeof(p36) == "UDim2", "argument #1 to BitBuffer.writeUDim2 should be a UDim2");
		writeFloat32(p36.X.Scale);
		writeInt32(p36.X.Offset);
		writeFloat32(p36.Y.Scale);
		writeInt32(p36.Y.Offset);
	end
	local function writeUDim(p37) -- Line: 1030
		--[[
			Upvalues:
				[1] = writeFloat32
				[2] = writeInt32
		--]]
		assert(typeof(p37) == "UDim", "argument #1 to BitBuffer.writeUDim should be a UDim");
		writeFloat32(p37.Scale);
		writeInt32(p37.Offset);
	end
	local function writeRay(p38) -- Line: 1037
		--[[
			Upvalues:
				[1] = writeFloat32
		--]]
		assert(typeof(p38) == "Ray", "argument #1 to BitBuffer.writeRay should be a Ray");
		writeFloat32(p38.Origin.X);
		writeFloat32(p38.Origin.Y);
		writeFloat32(p38.Origin.Z);
		writeFloat32(p38.Direction.X);
		writeFloat32(p38.Direction.Y);
		writeFloat32(p38.Direction.Z);
	end
	local function writeRect(p39) -- Line: 1049
		--[[
			Upvalues:
				[1] = writeFloat32
		--]]
		assert(typeof(p39) == "Rect", "argument #1 to BitBuffer.writeRect should be a Rect");
		writeFloat32(p39.Min.X);
		writeFloat32(p39.Min.Y);
		writeFloat32(p39.Max.X);
		writeFloat32(p39.Max.Y);
	end
	local function writeRegion3(p40) -- Line: 1059
		--[[
			Upvalues:
				[1] = writeFloat32
		--]]
		assert(typeof(p40) == "Region3", "argument #1 to BitBuffer.writeRegion3 should be a Region3");
		local v91 = p40.CFrame.Position - p40.Size / 2;
		local v92 = p40.CFrame.Position + p40.Size / 2;
		writeFloat32(v91.X);
		writeFloat32(v91.Y);
		writeFloat32(v91.Z);
		writeFloat32(v92.X);
		writeFloat32(v92.Y);
		writeFloat32(v92.Z);
	end
	local function writeEnum(p41) -- Line: 1074
		--[[
			Upvalues:
				[1] = writeTerminatedString
				[2] = writeByte
		--]]
		assert(typeof(p41) == "EnumItem", "argument #1 to BitBuffer.writeEnum should be an EnumItem");
		writeTerminatedString(tostring(p41.EnumType));
		local t_Value = p41.Value;
		assert(type(t_Value) == "number", "argument #1 to BitBuffer.writeUInt16 should be a number");
		assert(t_Value >= 0 and t_Value <= 65535 or false, "argument #1 to BitBuffer.writeInt16 should be in the range [0, 65535]");
		assert(t_Value % 1 == 0, "argument #1 to BitBuffer.writeUInt16 should be an integer");
		writeByte((bit32.rshift(t_Value, 8)));
		writeByte((bit32.band(t_Value, 255)));
	end
	local function writeNumberRange(p42) -- Line: 1082
		--[[
			Upvalues:
				[1] = writeFloat32
		--]]
		assert(typeof(p42) == "NumberRange", "argument #1 to BitBuffer.writeNumberRange should be a NumberRange");
		writeFloat32(p42.Min);
		writeFloat32(p42.Max);
	end
	local function writeNumberSequence(p43) -- Line: 1089
		--[[
			Upvalues:
				[1] = writeUInt32
				[2] = writeFloat32
		--]]
		assert(typeof(p43) == "NumberSequence", "argument #1 to BitBuffer.writeNumberSequence should be a NumberSequence");
		writeUInt32(#p43.Keypoints);
		for _, val5 in ipairs(p43.Keypoints) do
			writeFloat32(val5.Time);
			writeFloat32(val5.Value);
			writeFloat32(val5.Envelope);
		end
	end
	local function writeColorSequence(p44) -- Line: 1103
		--[[
			Upvalues:
				[1] = writeUInt32
				[2] = writeFloat32
				[3] = writeByte
		--]]
		assert(typeof(p44) == "ColorSequence", "argument #1 to BitBuffer.writeColorSequence should be a ColorSequence");
		writeUInt32(#p44.Keypoints);
		for _, val6 in ipairs(p44.Keypoints) do
			local t_Value2 = val6.Value;
			writeFloat32(val6.Time);
			writeByte((math.floor(t_Value2.R * 255 + 0.5)));
			writeByte((math.floor(t_Value2.G * 255 + 0.5)));
			writeByte((math.floor(t_Value2.B * 255 + 0.5)));
		end
	end
	local function readBits(p45) -- Line: 1121
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
				[5] = table7
				[6] = table5
		--]]
		assert(type(p45) == "number", "argument #1 to BitBuffer.readBits should be a number");
		assert(p45 > 0, "argument #1 to BitBuffer.readBits should be greater than zero");
		assert(p45 % 1 == 0, "argument #1 to BitBuffer.readBits should be an integer");
		assert(u6 + p45 <= u5, "BitBuffer.readBits cannot read past the end of the stream");
		local table_create_ret8 = table.create(p45);
		local v93 = u2[u7];
		local v94 = u6 % 8;
		for index18 = 1, p45 do
			table_create_ret8[index18] = table5[bit32.btest(v93, table7[7 - v94])];
			v94 = v94 + 1;
			if v94 == 8 then
				u7 = u7 + 1;
				v93 = u2[u7];
				v94 = 0;
			end
		end
		u6 = u6 + p45;
		return table_create_ret8;
	end
	local function readBoolean() -- Line: 1149
		--[[
			Upvalues:
				[1] = readBits
		--]]
		return readBits(1)[1] == 1;
	end
	local function readByte() -- Line: 1153
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v95 = u6 % 8;
		local v96 = u2[u7];
		u6 = u6 + 8;
		if v95 == 0 then
			u7 = u7 + 1;
			return v96;
		end
		u7 = u7 + 1;
		return bit32.band(bit32.lshift(v96, v95), 255) + bit32.rshift(u2[u7], 8 - v95);
	end
	local function readUnsigned(p46) -- Line: 1171
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
				[5] = readBits
		--]]
		assert(type(p46) == "number", "argument #1 to BitBuffer.readUnsigned should be a number");
		assert(p46 >= 1 and p46 <= 64 or false, "argument #1 to BitBuffer.readUnsigned should be in the range [1, 64]");
		assert(p46 % 1 == 0, "argument #1 to BitBuffer.readUnsigned should be an integer");
		assert(u6 + p46 <= u5, "BitBuffer.readUnsigned cannot read past the end of the stream");
		local math_floor_ret14 = math.floor(p46 / 8);
		local v97 = p46 % 8;
		local v98 = 0;
		for index19 = 1, math_floor_ret14 do
			local v270 = v98 * 256;
			assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
			local v271 = u6 % 8;
			local v272 = u2[u7];
			u6 = u6 + 8;
			local v308;
			if v271 == 0 then
				u7 = u7 + 1;
				v308 = v272;
			else
				u7 = u7 + 1;
				v308 = bit32.band(bit32.lshift(v272, v271), 255) + bit32.rshift(u2[u7], 8 - v271);
			end
			v98 = v270 + v308;
		end
		if v97 ~= 0 then
			for _, val8 in ipairs((readBits(p46 % 8))) do
				v98 = v98 * 2 + val8;
			end
		end
		return v98;
	end
	local function readSigned(p47) -- Line: 1199
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readBits
				[4] = readUnsigned
				[5] = table7
		--]]
		assert(type(p47) == "number", "argument #1 to BitBuffer.readSigned should be a number");
		assert(p47 >= 2 and p47 <= 64 or false, "argument #1 to BitBuffer.readSigned should be in the range [2, 64]");
		assert(p47 % 1 == 0, "argument #1 to BitBuffer.readSigned should be an integer");
		assert(u6 + 8 <= u5, "BitBuffer.readSigned cannot read past the end of the stream");
		local v99 = readBits(1)[1];
		local v100 = readUnsigned(p47 - 1);
		if v99 == 0 then
			return v100;
		end
		return v100 - table7[p47 - 1];
	end
	local function readFloat(p48, p49) -- Line: 1218
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = table7
				[4] = readBits
				[5] = readUnsigned
		--]]
		assert(type(p48) == "number", "argument #1 to BitBuffer.readFloat should be a number");
		assert(p48 >= 1 and p48 <= 64 or false, "argument #1 to BitBuffer.readFloat should be in the range [1, 64]");
		assert(p48 % 1 == 0, "argument #1 to BitBuffer.readFloat should be an integer");
		assert(type(p49) == "number", "argument #2 to BitBuffer.readFloat should be a number");
		assert(p49 >= 1 and p49 <= 64 or false, "argument #2 to BitBuffer.readFloat should be in the range [1, 64]");
		assert(p49 % 1 == 0, "argument #2 to BitBuffer.readFloat should be an integer");
		assert(u6 + p48 + p49 + 1 <= u5, "BitBuffer.readFloat cannot read past the end of the stream");
		local v101 = table7[p48 - 1] - 1;
		local v102 = readBits(1)[1];
		local v103 = readUnsigned(p48);
		local v104 = readUnsigned(p49);
		if v103 == table7[p48] - 1 then
			if v104 ~= 0 then
				return 0/0;
			end
			return v102 == 0 and math.huge or -math.huge;
		end
		if v103 == 0 then
			if v104 == 0 then
				return 0;
			end
			local v273 = v104 / table7[p49];
			return v102 == 1 and -math.ldexp(v273, -v101 + 1) or math.ldexp(v273, -v101 + 1);
		end
		local v105 = v104 / table7[p49] + 1;
		return v102 == 1 and -math.ldexp(v105, v103 - v101) or math.ldexp(v105, v103 - v101);
	end
	local function readString() -- Line: 1275
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readUnsigned
				[4] = u2
				[5] = u7
		--]]
		assert(u6 + 24 <= u5, "BitBuffer.readString cannot read past the end of the stream");
		local v106 = readUnsigned(24);
		assert(u6 + v106 * 8 <= u5, "BitBuffer.readString cannot read past the end of the stream");
		local table_create_ret9 = table.create(v106);
		for index20 = 1, v106 do
			assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
			local v274 = u6 % 8;
			local v275 = u2[u7];
			u6 = u6 + 8;
			local v276;
			if v274 == 0 then
				u7 = u7 + 1;
				v276 = v275;
			else
				u7 = u7 + 1;
				v276 = bit32.band(bit32.lshift(v275, v274), 255) + bit32.rshift(u2[u7], 8 - v274);
			end
			table_create_ret9[index20] = v276;
		end
		local table_create_ret10 = table.create((math.ceil(v106 / 4096)));
		local v107 = 1;
		for index21 = 1, v106, 4096 do
			table_create_ret10[v107] = string.char(table.unpack(table_create_ret9, index21, (math.min(v106, index21 + 4095))));
			v107 = v107 + 1;
		end
		return table.concat(table_create_ret10);
	end
	local function readTerminatedString() -- Line: 1299
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		local table11 = {};
		local v108 = 0;
		while true do
			assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
			local v277 = u6 % 8;
			local v278 = u2[u7];
			u6 = u6 + 8;
			local v309;
			if v277 == 0 then
				u7 = u7 + 1;
				v309 = v278;
			else
				u7 = u7 + 1;
				v309 = bit32.band(bit32.lshift(v278, v277), 255) + bit32.rshift(u2[u7], 8 - v277);
			end
			if not v309 then
				error("BitBuffer.readTerminatedString cannot read past the end of the stream", 2);
			else
				if v309 == 0 then break end
				v108 = v108 + 1;
				table11[v108] = v309;
			end
		end
		local table_create_ret11 = table.create((math.ceil(v108 / 4096)));
		local v109 = 1;
		for index22 = 1, v108, 4096 do
			table_create_ret11[v109] = string.char(table.unpack(table11, index22, (math.min(v108, index22 + 4095))));
			v109 = v109 + 1;
		end
		return table.concat(table_create_ret11);
	end
	local function readSetLengthString(p50) -- Line: 1326
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(type(p50) == "number", "argument #1 to BitBuffer.readSetLengthString should be a number");
		assert(p50 >= 0, "argument #1 to BitBuffer.readSetLengthString should be zero or higher.");
		assert(p50 % 1 == 0, "argument #1 to BitBuffer.readSetLengthString should be an integer");
		assert(u6 + p50 * 8 <= u5, "BitBuffer.readSetLengthString cannot read past the end of the stream");
		local table_create_ret12 = table.create(p50);
		for index23 = 1, p50 do
			assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
			local v279 = u6 % 8;
			local v280 = u2[u7];
			u6 = u6 + 8;
			local v281;
			if v279 == 0 then
				u7 = u7 + 1;
				v281 = v280;
			else
				u7 = u7 + 1;
				v281 = bit32.band(bit32.lshift(v280, v279), 255) + bit32.rshift(u2[u7], 8 - v279);
			end
			table_create_ret12[index23] = v281;
		end
		local table_create_ret13 = table.create((math.ceil(p50 / 4096)));
		local v110 = 1;
		for index24 = 1, p50, 4096 do
			table_create_ret13[v110] = string.char(table.unpack(table_create_ret12, index24, (math.min(p50, index24 + 4095))));
			v110 = v110 + 1;
		end
		return table.concat(table_create_ret13);
	end
	local function readField(p51) -- Line: 1353
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readUnsigned
		--]]
		assert(type(p51) == "number", "argument #1 to BitBuffer.readField should be a number");
		assert(p51 > 0, "argument #1 to BitBuffer.readField should be above 0");
		assert(p51 % 1 == 0, "argument #1 to BitBuffer.readField should be an integer");
		assert(u6 + p51 <= u5, "BitBuffer.readField cannot read past the end of the stream");
		local v111 = readUnsigned(p51);
		local table_create_ret14 = table.create(p51);
		for index25 = p51, 1, -1 do
			table_create_ret14[index25] = v111 % 2 == 1;
			v111 = math.floor(v111 / 2);
		end
		return table_create_ret14;
	end
	local function readUInt8() -- Line: 1374
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 8 <= u5, "BitBuffer.readUInt8 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v112 = u6 % 8;
		local v113 = u2[u7];
		u6 = u6 + 8;
		if v112 == 0 then
			u7 = u7 + 1;
			return v113;
		end
		u7 = u7 + 1;
		return bit32.band(bit32.lshift(v113, v112), 255) + bit32.rshift(u2[u7], 8 - v112);
	end
	local function readUInt16() -- Line: 1380
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 16 <= u5, "BitBuffer.readUInt16 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v114 = u6 % 8;
		local v115 = u2[u7];
		u6 = u6 + 8;
		local v229;
		if v114 == 0 then
			u7 = u7 + 1;
			v229 = v115;
		else
			u7 = u7 + 1;
			v229 = bit32.band(bit32.lshift(v115, v114), 255) + bit32.rshift(u2[u7], 8 - v114);
		end
		local num1 = 8;
		local bit32_lshift_ret = bit32.lshift(v229, num1);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v116 = u6 % 8;
		local v117 = u2[u7];
		u6 = u6 + 8;
		local v230;
		if v116 == 0 then
			u7 = u7 + 1;
			v230 = v117;
		else
			u7 = u7 + 1;
			v230 = bit32.band(bit32.lshift(v117, v116), 255) + bit32.rshift(u2[u7], 8 - v116);
		end
		return bit32_lshift_ret + v230;
	end
	local function readUInt32() -- Line: 1386
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 32 <= u5, "BitBuffer.readUInt32 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v118 = u6 % 8;
		local v119 = u2[u7];
		u6 = u6 + 8;
		local v231;
		if v118 == 0 then
			u7 = u7 + 1;
			v231 = v119;
		else
			u7 = u7 + 1;
			v231 = bit32.band(bit32.lshift(v119, v118), 255) + bit32.rshift(u2[u7], 8 - v118);
		end
		local num2 = 24;
		local bit32_lshift_ret2 = bit32.lshift(v231, num2);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v120 = u6 % 8;
		local v121 = u2[u7];
		u6 = u6 + 8;
		local v282;
		if v120 == 0 then
			u7 = u7 + 1;
			v282 = v121;
		else
			u7 = u7 + 1;
			v282 = bit32.band(bit32.lshift(v121, v120), 255) + bit32.rshift(u2[u7], 8 - v120);
		end
		local num3 = 16;
		local v122 = bit32_lshift_ret2 + bit32.lshift(v282, num3);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v123 = u6 % 8;
		local v124 = u2[u7];
		u6 = u6 + 8;
		local v283;
		if v123 == 0 then
			u7 = u7 + 1;
			v283 = v124;
		else
			u7 = u7 + 1;
			v283 = bit32.band(bit32.lshift(v124, v123), 255) + bit32.rshift(u2[u7], 8 - v123);
		end
		local num4 = 8;
		local v125 = v122 + bit32.lshift(v283, num4);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v126 = u6 % 8;
		local v127 = u2[u7];
		u6 = u6 + 8;
		local v232;
		if v126 == 0 then
			u7 = u7 + 1;
			v232 = v127;
		else
			u7 = u7 + 1;
			v232 = bit32.band(bit32.lshift(v127, v126), 255) + bit32.rshift(u2[u7], 8 - v126);
		end
		return v125 + v232;
	end
	local function readInt8() -- Line: 1392
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 8 <= u5, "BitBuffer.readInt8 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v128 = u6 % 8;
		local v129 = u2[u7];
		u6 = u6 + 8;
		local v233;
		if v128 == 0 then
			u7 = u7 + 1;
			v233 = v129;
		else
			u7 = u7 + 1;
			v233 = bit32.band(bit32.lshift(v129, v128), 255) + bit32.rshift(u2[u7], 8 - v128);
		end
		local bit32_btest_ret = bit32.btest(v233, 128);
		local bit32_band_ret = bit32.band(v233, 127);
		if bit32_btest_ret then
			return bit32_band_ret - 128;
		end
		return bit32_band_ret;
	end
	local function readInt16() -- Line: 1406
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 16 <= u5, "BitBuffer.readInt16 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v130 = u6 % 8;
		local v131 = u2[u7];
		u6 = u6 + 8;
		local v234;
		if v130 == 0 then
			u7 = u7 + 1;
			v234 = v131;
		else
			u7 = u7 + 1;
			v234 = bit32.band(bit32.lshift(v131, v130), 255) + bit32.rshift(u2[u7], 8 - v130);
		end
		local num5 = 8;
		local bit32_lshift_ret3 = bit32.lshift(v234, num5);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v132 = u6 % 8;
		local v133 = u2[u7];
		u6 = u6 + 8;
		local v235;
		if v132 == 0 then
			u7 = u7 + 1;
			v235 = v133;
		else
			u7 = u7 + 1;
			v235 = bit32.band(bit32.lshift(v133, v132), 255) + bit32.rshift(u2[u7], 8 - v132);
		end
		local v134 = bit32_lshift_ret3 + v235;
		local bit32_btest_ret2 = bit32.btest(v134, 32768);
		local bit32_band_ret2 = bit32.band(v134, 32767);
		if bit32_btest_ret2 then
			return bit32_band_ret2 - 32768;
		end
		return bit32_band_ret2;
	end
	local function readInt32() -- Line: 1420
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 32 <= u5, "BitBuffer.readInt32 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v135 = u6 % 8;
		local v136 = u2[u7];
		u6 = u6 + 8;
		local v236;
		if v135 == 0 then
			u7 = u7 + 1;
			v236 = v136;
		else
			u7 = u7 + 1;
			v236 = bit32.band(bit32.lshift(v136, v135), 255) + bit32.rshift(u2[u7], 8 - v135);
		end
		local num6 = 24;
		local bit32_lshift_ret4 = bit32.lshift(v236, num6);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v137 = u6 % 8;
		local v138 = u2[u7];
		u6 = u6 + 8;
		local v284;
		if v137 == 0 then
			u7 = u7 + 1;
			v284 = v138;
		else
			u7 = u7 + 1;
			v284 = bit32.band(bit32.lshift(v138, v137), 255) + bit32.rshift(u2[u7], 8 - v137);
		end
		local num7 = 16;
		local v139 = bit32_lshift_ret4 + bit32.lshift(v284, num7);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v140 = u6 % 8;
		local v141 = u2[u7];
		u6 = u6 + 8;
		local v285;
		if v140 == 0 then
			u7 = u7 + 1;
			v285 = v141;
		else
			u7 = u7 + 1;
			v285 = bit32.band(bit32.lshift(v141, v140), 255) + bit32.rshift(u2[u7], 8 - v140);
		end
		local num8 = 8;
		local v142 = v139 + bit32.lshift(v285, num8);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v143 = u6 % 8;
		local v144 = u2[u7];
		u6 = u6 + 8;
		local v237;
		if v143 == 0 then
			u7 = u7 + 1;
			v237 = v144;
		else
			u7 = u7 + 1;
			v237 = bit32.band(bit32.lshift(v144, v143), 255) + bit32.rshift(u2[u7], 8 - v143);
		end
		local v145 = v142 + v237;
		local bit32_btest_ret3 = bit32.btest(v145, 2147483648);
		local bit32_band_ret3 = bit32.band(v145, 2147483647);
		if bit32_btest_ret3 then
			return bit32_band_ret3 - 2147483648;
		end
		return bit32_band_ret3;
	end
	local function readFloat16() -- Line: 1434
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 16 <= u5, "BitBuffer.readFloat16 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v146 = u6 % 8;
		local v147 = u2[u7];
		u6 = u6 + 8;
		local v238;
		if v146 == 0 then
			u7 = u7 + 1;
			v238 = v147;
		else
			u7 = u7 + 1;
			v238 = bit32.band(bit32.lshift(v147, v146), 255) + bit32.rshift(u2[u7], 8 - v146);
		end
		local bit32_btest_ret4 = bit32.btest(v238, 128);
		local bit32_rshift_ret = bit32.rshift(bit32.band(v238, 127), 2);
		local bit32_lshift_ret5 = bit32.lshift(bit32.band(v238, 3), 8);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v148 = u6 % 8;
		local v149 = u2[u7];
		u6 = u6 + 8;
		local v239;
		if v148 == 0 then
			u7 = u7 + 1;
			v239 = v149;
		else
			u7 = u7 + 1;
			v239 = bit32.band(bit32.lshift(v149, v148), 255) + bit32.rshift(u2[u7], 8 - v148);
		end
		local v150 = bit32_lshift_ret5 + v239;
		if bit32_rshift_ret == 31 then
			if v150 ~= 0 then
				return 0/0;
			end
			return bit32_btest_ret4 and -math.huge or math.huge;
		end
		if bit32_rshift_ret == 0 then
			if v150 == 0 then
				return 0;
			end
			return bit32_btest_ret4 and -math.ldexp(v150 / 1024, -14) or math.ldexp(v150 / 1024, -14);
		end
		local v151 = v150 / 1024 + 1;
		return bit32_btest_ret4 and -math.ldexp(v151, bit32_rshift_ret - 15) or math.ldexp(v151, bit32_rshift_ret - 15);
	end
	local function readFloat32() -- Line: 1461
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 32 <= u5, "BitBuffer.readFloat32 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v152 = u6 % 8;
		local v153 = u2[u7];
		u6 = u6 + 8;
		local v240;
		if v152 == 0 then
			u7 = u7 + 1;
			v240 = v153;
		else
			u7 = u7 + 1;
			v240 = bit32.band(bit32.lshift(v153, v152), 255) + bit32.rshift(u2[u7], 8 - v152);
		end
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v154 = u6 % 8;
		local v155 = u2[u7];
		u6 = u6 + 8;
		local v286;
		if v154 == 0 then
			u7 = u7 + 1;
			v286 = v155;
		else
			u7 = u7 + 1;
			v286 = bit32.band(bit32.lshift(v155, v154), 255) + bit32.rshift(u2[u7], 8 - v154);
		end
		local bit32_btest_ret5 = bit32.btest(v240, 128);
		local v156 = bit32.band(bit32.lshift(v240, 1), 255) + bit32.rshift(v286, 7);
		local bit32_lshift_ret6 = bit32.lshift(bit32.band(v286, 127), 16);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v157 = u6 % 8;
		local v158 = u2[u7];
		u6 = u6 + 8;
		local v287;
		if v157 == 0 then
			u7 = u7 + 1;
			v287 = v158;
		else
			u7 = u7 + 1;
			v287 = bit32.band(bit32.lshift(v158, v157), 255) + bit32.rshift(u2[u7], 8 - v157);
		end
		local num9 = 8;
		local v159 = bit32_lshift_ret6 + bit32.lshift(v287, num9);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v160 = u6 % 8;
		local v161 = u2[u7];
		u6 = u6 + 8;
		local v288;
		if v160 == 0 then
			u7 = u7 + 1;
			v288 = v161;
		else
			u7 = u7 + 1;
			v288 = bit32.band(bit32.lshift(v161, v160), 255) + bit32.rshift(u2[u7], 8 - v160);
		end
		local num10 = 0;
		local v162 = v159 + bit32.lshift(v288, num10);
		if v156 == 255 then
			if v162 ~= 0 then
				return 0/0;
			end
			return bit32_btest_ret5 and -math.huge or math.huge;
		end
		if v156 == 0 then
			if v162 == 0 then
				return 0;
			end
			return bit32_btest_ret5 and -math.ldexp(v162 / 8388608, -126) or math.ldexp(v162 / 8388608, -126);
		end
		local v163 = v162 / 8388608 + 1;
		return bit32_btest_ret5 and -math.ldexp(v163, v156 - 127) or math.ldexp(v163, v156 - 127);
	end
	local function readFloat64() -- Line: 1492
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 64 <= u5, "BitBuffer.readFloat64 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v164 = u6 % 8;
		local v165 = u2[u7];
		u6 = u6 + 8;
		local v241;
		if v164 == 0 then
			u7 = u7 + 1;
			v241 = v165;
		else
			u7 = u7 + 1;
			v241 = bit32.band(bit32.lshift(v165, v164), 255) + bit32.rshift(u2[u7], 8 - v164);
		end
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v166 = u6 % 8;
		local v167 = u2[u7];
		u6 = u6 + 8;
		local v289;
		if v166 == 0 then
			u7 = u7 + 1;
			v289 = v167;
		else
			u7 = u7 + 1;
			v289 = bit32.band(bit32.lshift(v167, v166), 255) + bit32.rshift(u2[u7], 8 - v166);
		end
		local bit32_btest_ret6 = bit32.btest(v241, 128);
		local v168 = bit32.lshift(bit32.band(v241, 127), 4) + bit32.rshift(v289, 4);
		local bit32_lshift_ret7 = bit32.lshift(bit32.band(v289, 15), 16);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v169 = u6 % 8;
		local v170 = u2[u7];
		u6 = u6 + 8;
		local v290;
		if v169 == 0 then
			u7 = u7 + 1;
			v290 = v170;
		else
			u7 = u7 + 1;
			v290 = bit32.band(bit32.lshift(v170, v169), 255) + bit32.rshift(u2[u7], 8 - v169);
		end
		local num11 = 8;
		local v171 = bit32_lshift_ret7 + bit32.lshift(v290, num11);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v172 = u6 % 8;
		local v173 = u2[u7];
		u6 = u6 + 8;
		local v242;
		if v172 == 0 then
			u7 = u7 + 1;
			v242 = v173;
		else
			u7 = u7 + 1;
			v242 = bit32.band(bit32.lshift(v173, v172), 255) + bit32.rshift(u2[u7], 8 - v172);
		end
		local v174 = v171 + v242;
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v175 = u6 % 8;
		local v176 = u2[u7];
		u6 = u6 + 8;
		local v243;
		if v175 == 0 then
			u7 = u7 + 1;
			v243 = v176;
		else
			u7 = u7 + 1;
			v243 = bit32.band(bit32.lshift(v176, v175), 255) + bit32.rshift(u2[u7], 8 - v175);
		end
		local num12 = 24;
		local bit32_lshift_ret8 = bit32.lshift(v243, num12);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v177 = u6 % 8;
		local v178 = u2[u7];
		u6 = u6 + 8;
		local v291;
		if v177 == 0 then
			u7 = u7 + 1;
			v291 = v178;
		else
			u7 = u7 + 1;
			v291 = bit32.band(bit32.lshift(v178, v177), 255) + bit32.rshift(u2[u7], 8 - v177);
		end
		local num13 = 16;
		local v179 = bit32_lshift_ret8 + bit32.lshift(v291, num13);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v180 = u6 % 8;
		local v181 = u2[u7];
		u6 = u6 + 8;
		local v292;
		if v180 == 0 then
			u7 = u7 + 1;
			v292 = v181;
		else
			u7 = u7 + 1;
			v292 = bit32.band(bit32.lshift(v181, v180), 255) + bit32.rshift(u2[u7], 8 - v180);
		end
		local num14 = 8;
		local v182 = v179 + bit32.lshift(v292, num14);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v183 = u6 % 8;
		local v184 = u2[u7];
		u6 = u6 + 8;
		local v293;
		if v183 == 0 then
			u7 = u7 + 1;
			v293 = v184;
		else
			u7 = u7 + 1;
			v293 = bit32.band(bit32.lshift(v184, v183), 255) + bit32.rshift(u2[u7], 8 - v183);
		end
		local v185 = v174 * 4294967296 + (v182 + v293);
		if v168 == 2047 then
			if v185 ~= 0 then
				return 0/0;
			end
			return bit32_btest_ret6 and -math.huge or math.huge;
		end
		if v168 == 0 then
			if v185 == 0 then
				return 0;
			end
			return bit32_btest_ret6 and -math.ldexp(v185 / 4503599627370496, -1022) or math.ldexp(v185 / 4503599627370496, -1022);
		end
		local v186 = v185 / 4503599627370496 + 1;
		return bit32_btest_ret6 and -math.ldexp(v186, v168 - 1023) or math.ldexp(v186, v168 - 1023);
	end
	local function readBrickColor() -- Line: 1533
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 16 <= u5, "BitBuffer.readBrickColor cannot read past the end of the stream");
		local BrickColor_new = BrickColor.new;
		assert(u6 + 16 <= u5, "BitBuffer.readUInt16 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v187 = u6 % 8;
		local v188 = u2[u7];
		u6 = u6 + 8;
		local v244;
		if v187 == 0 then
			u7 = u7 + 1;
			v244 = v188;
		else
			u7 = u7 + 1;
			v244 = bit32.band(bit32.lshift(v188, v187), 255) + bit32.rshift(u2[u7], 8 - v187);
		end
		local num15 = 8;
		local bit32_lshift_ret9 = bit32.lshift(v244, num15);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v189 = u6 % 8;
		local v190 = u2[u7];
		u6 = u6 + 8;
		local v294;
		if v189 == 0 then
			u7 = u7 + 1;
			v294 = v190;
		else
			u7 = u7 + 1;
			v294 = bit32.band(bit32.lshift(v190, v189), 255) + bit32.rshift(u2[u7], 8 - v189);
		end
		return BrickColor_new(bit32_lshift_ret9 + v294);
	end
	local function readColor3() -- Line: 1539
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
		--]]
		assert(u6 + 24 <= u5, "BitBuffer.readColor3 cannot read past the end of the stream");
		local Color3_fromRGB = Color3.fromRGB;
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v191 = u6 % 8;
		local v192 = u2[u7];
		u6 = u6 + 8;
		local v245;
		if v191 == 0 then
			u7 = u7 + 1;
			v245 = v192;
		else
			u7 = u7 + 1;
			v245 = bit32.band(bit32.lshift(v192, v191), 255) + bit32.rshift(u2[u7], 8 - v191);
		end
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v193 = u6 % 8;
		local v194 = u2[u7];
		u6 = u6 + 8;
		local v246;
		if v193 == 0 then
			u7 = u7 + 1;
			v246 = v194;
		else
			u7 = u7 + 1;
			v246 = bit32.band(bit32.lshift(v194, v193), 255) + bit32.rshift(u2[u7], 8 - v193);
		end
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v195 = u6 % 8;
		local v196 = u2[u7];
		u6 = u6 + 8;
		local v247;
		if v195 == 0 then
			u7 = u7 + 1;
			v247 = v196;
		else
			u7 = u7 + 1;
			v247 = bit32.band(bit32.lshift(v196, v195), 255) + bit32.rshift(u2[u7], 8 - v195);
		end
		return Color3_fromRGB(v245, v246, v247);
	end
	local function readCFrame() -- Line: 1545
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
				[5] = readFloat32
				[6] = table4
		--]]
		assert(u6 + 8 <= u5, "BitBuffer.readCFrame cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v197 = u6 % 8;
		local v198 = u2[u7];
		u6 = u6 + 8;
		local v248;
		if v197 == 0 then
			u7 = u7 + 1;
			v248 = v198;
		else
			u7 = u7 + 1;
			v248 = bit32.band(bit32.lshift(v198, v197), 255) + bit32.rshift(u2[u7], 8 - v197);
		end
		if v248 == 0 then
			assert(u6 + 384 <= u5, "BitBuffer.readCFrame cannot read past the end of the stream");
			return CFrame.new(readFloat32(), readFloat32(), readFloat32(), readFloat32(), readFloat32(), readFloat32(), readFloat32(), readFloat32(), readFloat32(), readFloat32(), readFloat32(), (readFloat32()));
		end
		assert(u6 + 96 <= u5, "BitBuffer.readCFrame cannot read past the end of the stream");
		local v199 = table4[math.floor(v248 / 6)];
		local v200 = table4[v248 % 6];
		local Cross_ret = v199:Cross(v200);
		return CFrame.new(readFloat32(), readFloat32(), readFloat32(), v199.X, v200.X, Cross_ret.X, v199.Y, v200.Y, Cross_ret.Y, v199.Z, v200.Z, Cross_ret.Z);
	end
	local function readVector3() -- Line: 1578
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
		--]]
		assert(u6 + 96 <= u5, "BitBuffer.readVector3 cannot read past the end of the stream");
		return Vector3.new(readFloat32(), readFloat32(), (readFloat32()));
	end
	local function readVector2() -- Line: 1584
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
		--]]
		assert(u6 + 64 <= u5, "BitBuffer.readVector2 cannot read past the end of the stream");
		return Vector2.new(readFloat32(), (readFloat32()));
	end
	local function readUDim2() -- Line: 1590
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
				[4] = readInt32
		--]]
		assert(u6 + 128 <= u5, "BitBuffer.readUDim2 cannot read past the end of the stream");
		return UDim2.new(readFloat32(), readInt32(), readFloat32(), (readInt32()));
	end
	local function readUDim() -- Line: 1596
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
				[4] = readInt32
		--]]
		assert(u6 + 64 <= u5, "BitBuffer.readUDim cannot read past the end of the stream");
		return UDim.new(readFloat32(), (readInt32()));
	end
	local function readRay() -- Line: 1602
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
		--]]
		assert(u6 + 192 <= u5, "BitBuffer.readRay cannot read past the end of the stream");
		return Ray.new(Vector3.new(readFloat32(), readFloat32(), (readFloat32())), (Vector3.new(readFloat32(), readFloat32(), (readFloat32()))));
	end
	local function readRect() -- Line: 1611
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
		--]]
		assert(u6 + 128 <= u5, "BitBuffer.readRect cannot read past the end of the stream");
		return Rect.new(readFloat32(), readFloat32(), readFloat32(), (readFloat32()));
	end
	local function readRegion3() -- Line: 1617
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
		--]]
		assert(u6 + 192 <= u5, "BitBuffer.readRegion3 cannot read past the end of the stream");
		return Region3.new(Vector3.new(readFloat32(), readFloat32(), (readFloat32())), (Vector3.new(readFloat32(), readFloat32(), (readFloat32()))));
	end
	local function readEnum() -- Line: 1626
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readTerminatedString
				[4] = u2
				[5] = u7
		--]]
		assert(u6 + 8 <= u5, "BitBuffer.readEnum cannot read past the end of the stream");
		local v201 = readTerminatedString();
		assert(u6 + 16 <= u5, "BitBuffer.readEnum cannot read past the end of the stream");
		assert(u6 + 16 <= u5, "BitBuffer.readUInt16 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v202 = u6 % 8;
		local v203 = u2[u7];
		u6 = u6 + 8;
		local v249;
		if v202 == 0 then
			u7 = u7 + 1;
			v249 = v203;
		else
			u7 = u7 + 1;
			v249 = bit32.band(bit32.lshift(v203, v202), 255) + bit32.rshift(u2[u7], 8 - v202);
		end
		local num16 = 8;
		local bit32_lshift_ret10 = bit32.lshift(v249, num16);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v204 = u6 % 8;
		local v205 = u2[u7];
		u6 = u6 + 8;
		local v250;
		if v204 == 0 then
			u7 = u7 + 1;
			v250 = v205;
		else
			u7 = u7 + 1;
			v250 = bit32.band(bit32.lshift(v205, v204), 255) + bit32.rshift(u2[u7], 8 - v204);
		end
		local v206 = bit32_lshift_ret10 + v250;
		for _, val7 in ipairs(Enum[v201]:GetEnumItems()) do
			if val7.Value ~= v206 then continue end
			return val7;
		end
		error("BitBuffer.readEnum could not get value: `" .. tostring(v206) .. "` is not a valid member of `" .. v201 .. "`", 2);
	end
	local function readNumberRange() -- Line: 1653
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = readFloat32
		--]]
		assert(u6 + 64 <= u5, "BitBuffer.readNumberRange cannot read past the end of the stream");
		return NumberRange.new(readFloat32(), (readFloat32()));
	end
	local function readNumberSequence() -- Line: 1659
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
				[5] = readFloat32
		--]]
		assert(u6 + 32 <= u5, "BitBuffer.readNumberSequence cannot read past the end of the stream");
		assert(u6 + 32 <= u5, "BitBuffer.readUInt32 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v207 = u6 % 8;
		local v208 = u2[u7];
		u6 = u6 + 8;
		local v251;
		if v207 == 0 then
			u7 = u7 + 1;
			v251 = v208;
		else
			u7 = u7 + 1;
			v251 = bit32.band(bit32.lshift(v208, v207), 255) + bit32.rshift(u2[u7], 8 - v207);
		end
		local num17 = 24;
		local bit32_lshift_ret11 = bit32.lshift(v251, num17);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v209 = u6 % 8;
		local v210 = u2[u7];
		u6 = u6 + 8;
		local v295;
		if v209 == 0 then
			u7 = u7 + 1;
			v295 = v210;
		else
			u7 = u7 + 1;
			v295 = bit32.band(bit32.lshift(v210, v209), 255) + bit32.rshift(u2[u7], 8 - v209);
		end
		local num18 = 16;
		local v211 = bit32_lshift_ret11 + bit32.lshift(v295, num18);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v212 = u6 % 8;
		local v213 = u2[u7];
		u6 = u6 + 8;
		local v296;
		if v212 == 0 then
			u7 = u7 + 1;
			v296 = v213;
		else
			u7 = u7 + 1;
			v296 = bit32.band(bit32.lshift(v213, v212), 255) + bit32.rshift(u2[u7], 8 - v212);
		end
		local num19 = 8;
		local v214 = v211 + bit32.lshift(v296, num19);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v215 = u6 % 8;
		local v216 = u2[u7];
		u6 = u6 + 8;
		local v252;
		if v215 == 0 then
			u7 = u7 + 1;
			v252 = v216;
		else
			u7 = u7 + 1;
			v252 = bit32.band(bit32.lshift(v216, v215), 255) + bit32.rshift(u2[u7], 8 - v215);
		end
		local v217 = v214 + v252;
		assert(u6 + v217 * 96, "BitBuffer.readColorSequence cannot read past the end of the stream");
		local table_create_ret15 = table.create(v217);
		for index26 = 1, v217 do
			local v297 = readFloat32();
			local v298 = readFloat32();
			local v310;
			if v298 >= 0 then
				v310 = readFloat32();
			else
				v310 = nil;
			end
			table_create_ret15[index26] = NumberSequenceKeypoint.new(v297, v298, v310);
		end
		return NumberSequence.new(table_create_ret15);
	end
	local function readColorSequence() -- Line: 1686
		--[[
			Upvalues:
				[1] = u6
				[2] = u5
				[3] = u2
				[4] = u7
				[5] = readFloat32
		--]]
		assert(u6 + 32 <= u5, "BitBuffer.readColorSequence cannot read past the end of the stream");
		assert(u6 + 32 <= u5, "BitBuffer.readUInt32 cannot read past the end of the stream");
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v218 = u6 % 8;
		local v219 = u2[u7];
		u6 = u6 + 8;
		local v253;
		if v218 == 0 then
			u7 = u7 + 1;
			v253 = v219;
		else
			u7 = u7 + 1;
			v253 = bit32.band(bit32.lshift(v219, v218), 255) + bit32.rshift(u2[u7], 8 - v218);
		end
		local num20 = 24;
		local bit32_lshift_ret12 = bit32.lshift(v253, num20);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v220 = u6 % 8;
		local v221 = u2[u7];
		u6 = u6 + 8;
		local v299;
		if v220 == 0 then
			u7 = u7 + 1;
			v299 = v221;
		else
			u7 = u7 + 1;
			v299 = bit32.band(bit32.lshift(v221, v220), 255) + bit32.rshift(u2[u7], 8 - v220);
		end
		local num21 = 16;
		local v222 = bit32_lshift_ret12 + bit32.lshift(v299, num21);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v223 = u6 % 8;
		local v224 = u2[u7];
		u6 = u6 + 8;
		local v300;
		if v223 == 0 then
			u7 = u7 + 1;
			v300 = v224;
		else
			u7 = u7 + 1;
			v300 = bit32.band(bit32.lshift(v224, v223), 255) + bit32.rshift(u2[u7], 8 - v223);
		end
		local num22 = 8;
		local v225 = v222 + bit32.lshift(v300, num22);
		assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
		local v226 = u6 % 8;
		local v227 = u2[u7];
		u6 = u6 + 8;
		local v254;
		if v226 == 0 then
			u7 = u7 + 1;
			v254 = v227;
		else
			u7 = u7 + 1;
			v254 = bit32.band(bit32.lshift(v227, v226), 255) + bit32.rshift(u2[u7], 8 - v226);
		end
		local v228 = v225 + v254;
		assert(u6 + v228 * 56, "BitBuffer.readColorSequence cannot read past the end of the stream");
		local table_create_ret16 = table.create(v228);
		for index27 = 1, v228 do
			local ColorSequenceKeypoint_new = ColorSequenceKeypoint.new;
			local v301 = readFloat32();
			local Color3_fromRGB2 = Color3.fromRGB;
			assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
			local v302 = u6 % 8;
			local v303 = u2[u7];
			u6 = u6 + 8;
			local v316;
			if v302 == 0 then
				u7 = u7 + 1;
				v316 = v303;
			else
				u7 = u7 + 1;
				v316 = bit32.band(bit32.lshift(v303, v302), 255) + bit32.rshift(u2[u7], 8 - v302);
			end
			assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
			local v304 = u6 % 8;
			local v305 = u2[u7];
			u6 = u6 + 8;
			local v317;
			if v304 == 0 then
				u7 = u7 + 1;
				v317 = v305;
			else
				u7 = u7 + 1;
				v317 = bit32.band(bit32.lshift(v305, v304), 255) + bit32.rshift(u2[u7], 8 - v304);
			end
			assert(u6 + 8 <= u5, "BitBuffer.readByte cannot read past the end of the stream");
			local v306 = u6 % 8;
			local v307 = u2[u7];
			u6 = u6 + 8;
			local v318;
			if v306 == 0 then
				u7 = u7 + 1;
				v318 = v307;
			else
				u7 = u7 + 1;
				v318 = bit32.band(bit32.lshift(v307, v306), 255) + bit32.rshift(u2[u7], 8 - v306);
			end
			table_create_ret16[index27] = ColorSequenceKeypoint_new(v301, Color3_fromRGB2(v316, v317, v318));
		end
		return ColorSequence.new(table_create_ret16);
	end
	local table12 = {
		dumpBinary = dumpBinary,
		dumpString = dumpString,
		dumpHex = dumpHex,
		dumpBase64 = dumpBase64,
		exportChunk = exportChunk,
		exportBase64Chunk = exportBase64Chunk,
		exportHexChunk = exportHexChunk,
		crc32 = crc32,
		getLength = getLength,
		getByteLength = getByteLength,
		getPointer = getPointer,
		setPointer = setPointer,
		setPointerFromEnd = setPointerFromEnd,
		getPointerByte = getPointerByte,
		setPointerByte = setPointerByte,
		setPointerByteFromEnd = setPointerByteFromEnd,
		isFinished = isFinished,
		writeBits = writeBits,
		writeBoolean = writeBoolean,
		writeByte = writeByte,
		writeUnsigned = writeUnsigned,
		writeSigned = writeSigned,
		writeFloat = writeFloat,
		writeBase64 = writeBase64,
		writeString = writeString,
		writeTerminatedString = writeTerminatedString,
		writeSetLengthString = writeSetLengthString,
		writeField = writeField,
		writeUInt8 = writeUInt8,
		writeUInt16 = writeUInt16,
		writeUInt32 = writeUInt32,
		writeInt8 = writeInt8,
		writeInt16 = writeInt16,
		writeInt32 = writeInt32,
		writeFloat16 = writeFloat16,
		writeFloat32 = writeFloat32,
		writeFloat64 = writeFloat64,
		writeBrickColor = writeBrickColor,
		writeColor3 = writeColor3,
		writeCFrame = writeCFrame,
		writeVector3 = writeVector3,
		writeVector2 = writeVector2,
		writeUDim2 = writeUDim2,
		writeUDim = writeUDim,
		writeRay = writeRay,
		writeRect = writeRect,
		writeRegion3 = writeRegion3,
		writeEnum = writeEnum,
		writeNumberRange = writeNumberRange,
		writeNumberSequence = writeNumberSequence,
		writeColorSequence = writeColorSequence,
		readBits = readBits,
		readBoolean = readBoolean,
		readByte = readByte,
		readUnsigned = readUnsigned,
		readSigned = readSigned,
		readFloat = readFloat,
		readString = readString,
		readTerminatedString = readTerminatedString,
		readSetLengthString = readSetLengthString,
		readField = readField,
		readUInt8 = readUInt8,
		readUInt16 = readUInt16,
		readUInt32 = readUInt32,
		readInt8 = readInt8,
		readInt16 = readInt16,
		readInt32 = readInt32,
		readFloat16 = readFloat16,
		readFloat32 = readFloat32,
		readFloat64 = readFloat64,
		readBrickColor = readBrickColor,
		readColor3 = readColor3,
		readCFrame = readCFrame,
		readVector3 = readVector3,
		readVector2 = readVector2,
		readUDim2 = readUDim2,
		readUDim = readUDim,
		readRay = readRay,
		readRect = readRect,
		readRegion3 = readRegion3,
		readEnum = readEnum,
		readNumberRange = readNumberRange,
		readNumberSequence = readNumberSequence,
		readColorSequence = readColorSequence
	};
	return table12;
end;
