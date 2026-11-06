-- https://github.com/kalidrios

local HttpService = game:GetService("HttpService");
local table1 = {
	is_valid_uuid = function(p31) -- is_valid_uuid (Line: 7)
		if typeof(p31) == "string" and #p31 == 36 then
			return true;
		end
		return false;
	end,
	is_uuid = function(p32) -- is_uuid (Line: 18)
		return typeof(p32) == "string" and (#p32 == 38 and string.match(p32, "^{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x}$") ~= nil or false) or false;
	end,
	generateUUID = function(p33) -- generateUUID (Line: 22)
		--[[
			Upvalues:
				[1] = HttpService
		--]]
		if p33 == nil then
			p33 = true;
		end
		return HttpService:GenerateGUID(p33);
	end,
	regex_escape = function(p34) -- regex_escape (Line: 29)
		return p34:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1");
	end,
	regex_any_case = function(p35) -- regex_any_case (Line: 34)
		return p35:gsub("([%a])", function(p38) -- Line: 36
			return "[" .. p38:lower() .. p38:upper() .. "]";
		end);
	end
};
function table1.replace(p1, p2, p3) -- Line: 39
	--[[
		Upvalues:
			[1] = table1
	--]]
	p2 = table1.regex_escape(p2);
	p3 = p3:gsub("%%", "%%%%");
	return p1:gsub(p2, p3);
end
function table1.starts_with(p4, p5) -- Line: 45
	if #p4 < #p5 then
		return false;
	end
	if p5 == "" then
		return true;
	end
	if p4:sub(1, #p5) == p5 then
		return true;
	end
	return false;
end
function table1.ends_with(p6, p7) -- Line: 58
	if #p6 < #p7 then
		return false;
	end
	if p7 == "" then
		return true;
	end
	if p6:sub(-(#p7)) == p7 then
		return true;
	end
	return false;
end
function table1.equals_ignore_case(p8, p9) -- Line: 71
	return p8:lower() == p9:lower();
end
function table1.quote(p10) -- Line: 76
	return '"' .. p10:gsub('"', '\\"') .. '"';
end
local table2 = {
	["\a"] = "\\a",
	["\b"] = "\\b",
	["\f"] = "\\f",
	["\n"] = "\\n",
	["\r"] = "\\r",
	["	"] = "\\t",
	["\v"] = "\\v"
};
local table3 = {};
for index1 = 0, 31 do
	local string_char_ret = string.char(index1);
	if not table2[string_char_ret] then
		table2[string_char_ret] = "\\" .. index1;
		table3[string_char_ret] = string.format("\\%03d", index1);
	end
end
function table1.escape(p11) -- Line: 95
	--[[
		Upvalues:
			[1] = table3
			[2] = table2
	--]]
	local gsub_ret = p11:gsub("\\", "\\\\");
	local gsub_ret2 = gsub_ret:gsub("(%c)%f[0-9]", table3);
	return gsub_ret2:gsub("%c", table2);
end
function table1.format_string(p12) -- Line: 101
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.quote(table1.escape(p12));
end
function table1.format_instance(p13) -- Line: 105
	--[[
		Upvalues:
			[1] = table1
	--]]
	return "Instance(" .. table1.format_string(p13.ClassName) .. ", " .. table1.format_string(p13.Name) .. ", " .. table1.format(p13.Parent) .. ")";
end
function table1.format_axes(p14) -- Line: 109
	return "Axes(" .. tostring(p14.X) .. ", " .. tostring(p14.Y) .. ", " .. tostring(p14.Z) .. ", " .. tostring(p14.Top) .. ", " .. tostring(p14.Bottom) .. ", " .. tostring(p14.Left) .. ", " .. tostring(p14.Right) .. ", " .. tostring(p14.Back) .. ", " .. tostring(p14.Front) .. ")";
end
function table1.format_brick_color(p15) -- Line: 113
	--[[
		Upvalues:
			[1] = table1
	--]]
	return "BrickColor(" .. table1.format_string(p15.Name) .. ")";
end
function table1.format_cframe(p16) -- Line: 117
	local GetComponents_ret1, GetComponents_ret2, GetComponents_ret3, GetComponents_ret4, GetComponents_ret5, GetComponents_ret6, GetComponents_ret7, GetComponents_ret8, GetComponents_ret9, GetComponents_ret10, GetComponents_ret11, GetComponents_ret12 = p16:GetComponents();
	return "CFrame(" .. tostring(GetComponents_ret1) .. ", " .. tostring(GetComponents_ret2) .. ", " .. tostring(GetComponents_ret3) .. ",\n" .. tostring(GetComponents_ret4) .. ", " .. tostring(GetComponents_ret5) .. ", " .. tostring(GetComponents_ret6) .. ", \n" .. tostring(GetComponents_ret7) .. ", " .. tostring(GetComponents_ret8) .. ", " .. tostring(GetComponents_ret9) .. ", \n" .. tostring(GetComponents_ret10) .. ", " .. tostring(GetComponents_ret11) .. ", " .. tostring(GetComponents_ret12) .. ")";
end
function table1.format_color3(p17) -- Line: 125
	return "Color3(" .. tostring(p17.R) .. ", " .. tostring(p17.G) .. ", " .. tostring(p17.B) .. ")";
end
function table1.format_date_time(p18) -- Line: 129
	return "DateTime(" .. tostring(p18.UnixTimestampMillis) .. ")";
end
function table1.format_rect(p19) -- Line: 133
	return "Rect(" .. tostring(p19.Min.X) .. ", " .. tostring(p19.Min.Y) .. tostring(p19.Max.X) .. ", " .. tostring(p19.Max.Y) .. ")";
end
function table1.format_region3(p20) -- Line: 137
	--[[
		Upvalues:
			[1] = table1
	--]]
	local t_CFrame = p20.CFrame;
	local v1 = p20.Size / 2;
	local v2 = t_CFrame * -v1;
	local v3 = t_CFrame * v1;
	return "Region3(" .. table1.format_vector3(v2) .. ", " .. table1.format_vector3(v3) .. ")";
end
function table1.format_udim(p21) -- Line: 144
	return "UDim(" .. tostring(p21.Scale) .. ", " .. tostring(p21.Offset) .. ")";
end
function table1.format_udim2(p22) -- Line: 148
	return "UDim2(" .. tostring(p22.X) .. ", " .. tostring(p22.Y) .. ", " .. tostring(p22.Width) .. ", " .. tostring(p22.Height) .. ")";
end
function table1.format_vector2(p23) -- Line: 152
	return "Vector2(" .. tostring(p23.X) .. ", " .. tostring(p23.Y) .. ")";
end
function table1.format_vector3(p24) -- Line: 156
	return "Vector3(" .. tostring(p24.X) .. ", " .. tostring(p24.Y) .. ", " .. tostring(p24.Z) .. ")";
end
function table1.format_table(p25, p26, p27) -- Line: 160
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v11;
	if p26 then
		if p26[p25] then
			return "...";
		end
		p26[p25] = true;
		v11 = p26;
	else
		local table4 = {[p25] = true};
		v11 = table4;
	end
	local v4 = p27 and p27 or "";
	local v5 = v4 .. "	";
	local bool1 = true;
	local v6 = 0;
	local v7 = math.huge;
	local v8 = 0;
	for key1, _ in pairs(p25) do
		if typeof(key1) ~= "number" or key1 < 1 or math.floor(key1) ~= key1 then
			bool1 = false;
			break;
		end
		if key1 < v7 then
			v7 = key1;
		end
		if v8 < key1 then
			v8 = key1;
		end
		v6 = v6 + 1;
	end
	local v9;
	if v6 > 0 then
		if v7 ~= 1 or v6 ~= v8 then
			bool1 = false;
		end
		local v12 = "{";
		if bool1 then
			for _, val2 in ipairs(p25) do
				v12 = v12 .. "\n" .. v5 .. table1.format(val2, v11, v5);
			end
		else
			for key3, val3 in pairs(p25) do
				v12 = v12 .. "\n" .. v5 .. "[" .. table1.format(key3, v11, v5) .. "] = " .. table1.format(val3, v11, v5);
			end
		end
		v9 = v12 .. "\n" .. v4 .. "}";
	else
		v9 = "{}";
	end
	if p26 then
		p26[p25] = nil;
	end
	return v9;
end
local table5 = {
	string = table1.format_string,
	number = function(p36) -- Line: 230
		return tostring(p36);
	end,
	boolean = function(p37) -- Line: 233
		return tostring(p37);
	end,
	["nil"] = function(_) -- Line: 236
		return "nil";
	end,
	table = table1.format_table,
	Axes = table1.format_axes,
	BrickColor = table1.format_brick_color,
	CFrame = table1.format_cframe,
	Color3 = table1.format_color3,
	DateTime = table1.format_date_time,
	Instance = table1.format_instance,
	Rect = table1.format_rect,
	Region3 = table1.format_region3,
	UDim = table1.format_udim,
	UDim2 = table1.format_udim2,
	Vector2 = table1.format_vector2,
	Vector3 = table1.format_vector3
};
function table1.format(p28, p29, p30) -- Line: 334
	--[[
		Upvalues:
			[1] = table5
	--]]
	local typeof_ret = typeof(p28);
	local v10 = table5[typeof_ret];
	if v10 then
		return v10(p28, p29, p30);
	end
	return "<" .. typeof_ret .. ">";
end
return table1;
