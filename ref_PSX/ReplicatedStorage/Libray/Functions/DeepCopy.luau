-- https://github.com/kalidrios

local function deep_copy(p1, p2) -- Line: 3
	--[[
		Upvalues:
			[1] = deep_copy
	--]]
	if typeof(p1) ~= "table" then
		return p1;
	end
	local table1;
	if p2 then
		local v2 = p2[p1];
		if v2 ~= nil then
			return v2;
		end
		table1 = {};
		p2[p1] = table1;
	else
		table1 = {};
		local table2 = {[p1] = table1};
		p2 = table2;
	end
	local v1 = #p1;
	if v1 > 0 then
		for index1 = 1, v1 do
			table.insert(table1, deep_copy(p1[index1], p2));
		end
	else
		for key1, val1 in next, p1 do
			table1[deep_copy(key1, p2)] = deep_copy(val1, p2);
		end
	end
	local metatable = getmetatable(p1);
	if metatable then
		setmetatable(table1, (deep_copy(metatable, p2)));
	end
	return table1;
end
return deep_copy;
