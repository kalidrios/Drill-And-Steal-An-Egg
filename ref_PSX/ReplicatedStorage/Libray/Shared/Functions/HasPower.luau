-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").Pets);
return function(p1, p2) -- Line: 11
	local t_powers = p1.powers;
	if t_powers then
		for _, val1 in ipairs(t_powers) do
			if val1[1] ~= p2 then continue end
			return true, val1[2];
		end
	end
	return false, 0;
end;
