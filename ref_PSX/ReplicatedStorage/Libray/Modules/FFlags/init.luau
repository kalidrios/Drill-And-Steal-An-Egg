-- https://github.com/kalidrios

local table1 = {};
local table2 = {};
local m_Custom = require(script.Custom);
local v1 = 1;
for key1, val1 in pairs(m_Custom) do
	assert(typeof(key1) == "string");
	assert(typeof(val1) == "table");
	local v2 = v1 + (val1.Important and 1000 or 0);
	v1 = v1 + 1;
	local v3 = val1.Name or key1:gsub("[A-Z]", function(p1) -- Line: 35
		return " " .. p1;
	end):gsub("^.", string.upper);
	local t_Default = val1.Default;
	local v4 = val1.Important or false;
	local t_Min = val1.Min;
	local t_Max = val1.Max;
	local v5 = val1.Type;
	if not v5 then
		assert(t_Default ~= nil);
		v5 = typeof(t_Default);
	end
	local v6 = val1.Nullable;
	if v6 == nil then
		if t_Default ~= nil then
			v6 = false;
		else
			v6 = true;
		end
	end
	local v7 = val1.Toggles ~= nil;
	local v8 = val1.Toggles;
	if not v8 then
		v8 = {};
		assert(v8);
		if v5 == "boolean" then
			table.insert(v8, false);
			table.insert(v8, true);
		end
	end
	if not table.find(v8, t_Default) then
		table.insert(v8, t_Default);
	end
	if v6 and not table.find(v8, nil) then
		table.insert(v8, nil);
	end
	local table4 = {
		Order = v2,
		Key = key1,
		Name = v3,
		Type = v5,
		Nullable = v6,
		Default = t_Default,
		Toggles = v8,
		HasToggles = v7,
		Important = v4,
		Min = t_Min,
		Max = t_Max
	};
	table1[key1] = table4;
	table2[key1] = key1;
end
local table3 = {
	Options = table1,
	Keys = table2,
	Admins = {
		[-1] = true,
		[-2] = true,
		[-3] = true,
		[561445931] = true, 
	}
};
return table3;
