-- https://github.com/kalidrios

local table1 = {};
local HttpService = game:GetService("HttpService");
local table2 = {};
local table3 = {};
local u1 = 0;
local bool1 = false;
function table1.Encode(p1) -- Anonymous function at line 44
	--[[
		Upvalues:
			[1] = HttpService
	--]]
	local bool2 = false;
	if type(p1) == "table" then
		local success = pcall(function() -- Line: 51
			--[[
				Upvalues:
					[1] = p1
					[2] = HttpService
					[3] = bool2
			--]]
			p1 = HttpService:JSONEncode(p1);
			bool2 = true;
		end);
		if not success or not p1 then
			warn("Failed to convert table to string");
			return;
		end
	end
	local Encode_ret = Encode(p1);
	if utf8.len(p1) > utf8.len(Encode_ret) then
		return Encode_ret;
	end
	return p1, bool2;
end
function table1.Decode(p2) -- Anonymous function at line 78
	local Decode_ret = Decode(p2);
	if not Decode_ret then
		warn("Failed to decode string");
		return;
	end
	return Decode_ret;
end
function Encode(p3) -- Line: 98
	--[[
		Upvalues:
			[1] = bool1
			[2] = table3
	--]]
	if not bool1 then
		Init();
	end
	local Copy_ret = Copy(table3);
	local v1 = "";
	local table4 = {};
	local v2 = #Copy_ret;
	local u2 = 1;
	local table5 = {};
	local u3 = 0;
	local function listkey(p10) -- Line: 108
		--[[
			Upvalues:
				[1] = Copy_ret
				[2] = u2
				[3] = u3
				[4] = table5
				[5] = table4
		--]]
		local ToBase93_ret = ToBase93(Copy_ret[p10]);
		if u2 < #ToBase93_ret then
			local v18 = table5;
			local v19 = u2;
			u2 = #ToBase93_ret;
			u3 = 0;
			v18[v19] = u3;
		end
		table4[#table4 + 1] = (" "):rep(u2 - #ToBase93_ret) .. ToBase93_ret;
		u3 = u3 + 1;
	end
	p3 = Escape(p3);
	for index1 = 1, #p3 do
		local sub_ret = p3:sub(index1, index1);
		local v8 = v1 .. sub_ret;
		if Copy_ret[v8] then
			v1 = v8;
		else
			local ToBase93_ret3 = ToBase93(Copy_ret[v1]);
			if u2 < #ToBase93_ret3 then
				local v20 = #ToBase93_ret3;
				local num2 = 0;
				table5[u2] = u3;
				u2 = v20;
				u3 = num2;
			end
			table4[#table4 + 1] = (" "):rep(u2 - #ToBase93_ret3) .. ToBase93_ret3;
			u3 = u3 + 1;
			v1 = sub_ret;
			v2 = v2 + 1;
			Copy_ret[v8] = v2;
			Copy_ret[v2] = v8;
		end
	end
	local ToBase93_ret2 = ToBase93(Copy_ret[v1]);
	if u2 < #ToBase93_ret2 then
		local v9 = #ToBase93_ret2;
		local num1 = 0;
		table5[u2] = u3;
		u2 = v9;
		u3 = num1;
	end
	table4[#table4 + 1] = (" "):rep(u2 - #ToBase93_ret2) .. ToBase93_ret2;
	u3 = u3 + 1;
	table5[u2] = u3;
	return table.concat(table5, ",") .. "|" .. table.concat(table4);
end
function Decode(p4) -- Line: 137
	--[[
		Upvalues:
			[1] = bool1
			[2] = table3
	--]]
	if not bool1 then
		Init();
	end
	local Copy_ret2 = Copy(table3);
	local table6 = {};
	local match_ret1, match_ret2 = p4:match("(.-)|(.*)");
	local table7 = {};
	local v3 = 1;
	for v4 in match_ret1:gmatch("%d+") do
		local v10 = #table7 + 1;
		table7[v10] = match_ret2:sub(v3, v3 + v4 * v10 - 1);
		v3 = v3 + v4 * v10;
	end
	local v5 = nil;
	for index2 = 1, #table7 do
		for v11 in table7[index2]:gmatch(("."):rep(index2)) do
			local v15 = Copy_ret2[ToBase10(v11)];
			if v5 then
				if v15 then
					table6[#table6 + 1] = v15;
					Copy_ret2[#Copy_ret2 + 1] = v5 .. v15:sub(1, 1);
				else
					v15 = v5 .. v5:sub(1, 1);
					table6[#table6 + 1] = v15;
					Copy_ret2[#Copy_ret2 + 1] = v15;
				end
			else
				table6[1] = v15;
			end
			v5 = v15;
		end
	end
	return Unescape(table.concat(table6));
end
function Escape(p5) -- Line: 178
	--[[
		Upvalues:
			[1] = table2
	--]]
	return p5:gsub('[%c"\\]', function(p11) -- Line: 179
		--[[
			Upvalues:
				[1] = table2
		--]]
		return "\127" .. table2[p11];
	end);
end
function Unescape(p6) -- Line: 185
	--[[
		Upvalues:
			[1] = table2
	--]]
	return p6:gsub("\127(.)", function(p12) -- Line: 186
		--[[
			Upvalues:
				[1] = table2
		--]]
		return table2[p12];
	end);
end
function Copy(p7) -- Line: 192
	local table8 = {};
	for key1, val1 in pairs(p7) do
		table8[key1] = val1;
	end
	return table8;
end
function ToBase93(p8) -- Line: 201
	--[[
		Upvalues:
			[1] = table3
	--]]
	local v6 = "";
	repeat
		local v12 = p8 % 93;
		v6 = table3[v12] .. v6;
		p8 = (p8 - v12) / 93;
	until p8 == 0;
	return v6;
end
function ToBase10(p9) -- Line: 212
	--[[
		Upvalues:
			[1] = table3
	--]]
	local v7 = 0;
	for index3 = 1, #p9 do
		v7 = v7 + 93 ^ (index3 - 1) * table3[p9:sub(-index3, -index3)];
	end
	return v7;
end
function Init() -- Line: 221
	--[[
		Upvalues:
			[1] = table3
			[2] = u1
			[3] = table2
			[4] = bool1
	--]]
	for index4 = 32, 127 do
		if index4 ~= 34 and index4 ~= 92 then
			local string_char_ret3 = string.char(index4);
			local v16 = table3;
			local v17 = u1;
			table3[string_char_ret3] = u1;
			v16[v17] = string_char_ret3;
			u1 = u1 + 1;
		end
	end
	for index5 = 1, 34 do
		local v13 = ({
			34,
			92,
			127
		})[index5 - 31] or index5;
		local string_char_ret = string.char(v13);
		local string_char_ret2 = string.char(v13 + 31);
		local v14 = table2;
		table2[string_char_ret] = string_char_ret2;
		v14[string_char_ret2] = string_char_ret;
	end
	bool1 = true;
end
return table1;
