-- https://github.com/kalidrios

local table1 = {
	CharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
	BitsToNum = function(p10) -- BitsToNum (Line: 5)
		assert(typeof(p10) == "string", "Arg1: Expected string, got " .. typeof(p10));
		local v5 = 0;
		local v6 = 1;
		for index7 = 1, #p10 do
			if string.sub(p10, -index7, -index7) == "1" then
				v5 = v5 + v6;
			end
			v6 = v6 * 2;
		end
		return v5;
	end,
	NumToBits = function(p11, p12) -- NumToBits (Line: 20)
		assert(typeof(p11) == "number", "Arg1: Expected number, got " .. typeof(p11));
		assert(typeof(p12) == "number" and true or typeof(p12) == "nil", "Arg2: Expected number, got " .. typeof(p12));
		if not p12 then
			p12 = math.floor(math.log(p11, 2) + 1);
		end
		local v7 = "";
		for index8 = p12, 1, -1 do
			v7 = v7 .. tostring((bit32.extract(p11, index8 - 1, 1)));
		end
		return v7;
	end
};
function table1.CharToNum(p1) -- Line: 35
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(typeof(p1) == "string", "Arg1: Expected string, got " .. typeof(p1));
	assert(#p1 == 1, "Arg1: String must be of length 1, got string of length " .. #p1);
	for index1 = 1, 64 do
		if string.sub(table1.CharSet, index1, index1) == p1 then
			return index1 - 1;
		end
	end
	return nil;
end
function table1.NumToChar(p2) -- Line: 47
	--[[
		Upvalues:
			[1] = table1
	--]]
	p2 = math.floor(p2);
	assert(typeof(p2) == "number", "Arg1: Expected number, got " .. typeof(p2));
	assert(p2 >= 0 and p2 <= 63 or false, "Arg1: Expected number between 0 and 63 (inclusive), got " .. tostring(p2));
	return string.sub(table1.CharSet, p2 + 1, p2 + 1);
end
function table1.EncodeBytes(p3, p4) -- Line: 55
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(typeof(p3) == "table", "Arg1: Expected table, got " .. typeof(p3));
	assert(typeof(p4) == "boolean" and true or typeof(p4) == "nil", "Arg2: Expected boolean, got " .. typeof(p4));
	local v1 = "";
	local v2 = "";
	for index2 = 1, #p3 do
		v2 = v2 .. table1.NumToBits(p3[index2], 8);
	end
	local v3 = v2 .. string.rep("0", 6 - #v2 % 6);
	for index3 = 1, #v3, 6 do
		v1 = v1 .. table1.NumToChar(table1.BitsToNum((string.sub(v3, index3, index3 + 5))));
	end
	if p4 then
		v1 = v1 .. string.rep("=", 4 - #v1 % 4);
	end
	return v1;
end
function table1.EncodeString(p5, p6) -- Line: 78
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(typeof(p5) == "string", "Arg1: Expected string, got " .. typeof(p5));
	assert(typeof(p6) == "boolean" and true or typeof(p6) == "nil", "Arg2: Expected boolean, got " .. typeof(p6));
	local table2 = {};
	for index4 = 1, #p5 do
		table2[index4] = string.byte((string.sub(p5, index4, index4)));
	end
	return table1.EncodeBytes(table2, p6);
end
function table1.Decode(p7) -- Line: 89
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(typeof(p7) == "string", "Arg1: Expected string, got " .. typeof(p7));
	local v4 = "";
	local table3 = {};
	for index5 = 1, #p7 do
		local v8 = table1.CharToNum((string.sub(p7, index5, index5)));
		if v8 then
			v4 = v4 .. table1.NumToBits(v8, 6);
		end
	end
	for index6 = 1, math.floor(#v4 / 8) do
		table3[index6] = table1.BitsToNum((string.sub(v4, index6 * 8 - 8 + 1, index6 * 8)));
	end
	return table3;
end
function table1.BytesToString(p8) -- Line: 109
	assert(typeof(p8) == "table", "Arg1: Expected table, got " .. typeof(p8));
	return string.char(table.unpack(p8));
end
function table1.DecodeToString(p9) -- Line: 115
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.BytesToString(table1.Decode(p9));
end
return table1;
