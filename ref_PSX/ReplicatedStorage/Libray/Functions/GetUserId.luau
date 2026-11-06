-- https://github.com/kalidrios

local Players = game:GetService("Players");
local table1 = {};
local table2 = {};
return function(p1, p2, p3, p4) -- Line: 8
	--[[
		Upvalues:
			[1] = table1
			[2] = Players
			[3] = table2
	--]]
	assert(typeof(p1) == "string");
	local match_ret = p1:match("^#(.*)");
	if match_ret then
		local tonumber_ret = tonumber(match_ret);
		if tonumber_ret then
			return tonumber_ret;
		end
		return nil, string.format("Invalid User ID: '%s'", match_ret);
	end
	local match_ret2 = p1:match("^@(.*)");
	if match_ret2 then
		p1 = match_ret2;
		p3 = false;
		p2 = false;
	end
	local lower_ret = p1:lower();
	local v1 = table1[lower_ret];
	if v1 then
		return v1;
	end
	for _, val1 in ipairs(Players:GetPlayers()) do
		if val1.Name:lower() ~= lower_ret then continue end
		local t_UserId2 = val1.UserId;
		table1[lower_ret] = t_UserId2;
		return t_UserId2;
	end
	if p2 then
		local v2 = table2[lower_ret];
		if v2 then
			return v2;
		end
		for _, val2 in ipairs(Players:GetPlayers()) do
			if val2.DisplayName:lower() ~= lower_ret then continue end
			local t_UserId = val2.UserId;
			table2[lower_ret] = t_UserId;
			return t_UserId;
		end
	end
	if p3 then
		local table3 = {};
		for _, val3 in ipairs(Players:GetPlayers()) do
			local t_Name = val3.Name;
			if #t_Name < #lower_ret or t_Name:sub(1, #lower_ret):lower() ~= lower_ret then continue end
			table.insert(table3, val3.UserId);
		end
		if p2 then
			for _, val4 in ipairs(Players:GetPlayers()) do
				local t_DisplayName = val4.DisplayName;
				if #t_DisplayName < #lower_ret or t_DisplayName:sub(1, #lower_ret):lower() ~= lower_ret then continue end
				table.insert(table3, val4.UserId);
			end
		end
		if #table3 > 0 then
			if #table3 == 1 then
				return table3[1];
			end
			return nil, string.format("Multiple players match '%s'", lower_ret);
		end
	end
	if p4 then
		local success, pcall_ret2 = pcall(function() -- Line: 92
			--[[
				Upvalues:
					[1] = Players
					[2] = p1
			--]]
			return Players:GetUserIdFromNameAsync(p1);
		end);
		if success and typeof(pcall_ret2) == "number" then
			table1[lower_ret] = pcall_ret2;
			return pcall_ret2;
		end
		return nil, string.format("Error while looking up '%s': '%s'", p1, tostring(pcall_ret2));
	end
	return nil, string.format("Unknown player: '%s'", p1);
end;
