-- https://github.com/kalidrios

local Players = game:GetService("Players");
return function(p1) -- Line: 11
	--[[
		Upvalues:
			[1] = Players
	--]]
	local table1 = {};
	for _, val1 in ipairs(Players:GetPlayers()) do
		if p1 == val1 then continue end
		local u1 = false;
		pcall(function() -- Line: 17
			--[[
				Upvalues:
					[1] = u1
					[2] = p1
					[3] = val1
			--]]
			u1 = p1:IsFriendsWith(val1.UserId);
		end);
		if u1 then
			table.insert(table1, val1);
		end
	end
	return table1;
end;
