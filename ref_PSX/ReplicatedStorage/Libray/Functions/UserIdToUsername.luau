-- https://github.com/kalidrios

local Players = game:GetService("Players");
local table1 = {};
return function(p1) -- Line: 17
	--[[
		Upvalues:
			[1] = table1
			[2] = Players
	--]]
	local v1 = table1[p1];
	if v1 then
		return v1;
	end
	local success, pcall_ret2 = pcall(function() -- Line: 23
		--[[
			Upvalues:
				[1] = Players
				[2] = p1
		--]]
		return Players:GetNameFromUserIdAsync(p1);
	end);
	if not success then
		return "??";
	end
	if pcall_ret2 then
		table1[p1] = pcall_ret2;
		return pcall_ret2;
	end
	return "???";
end;
