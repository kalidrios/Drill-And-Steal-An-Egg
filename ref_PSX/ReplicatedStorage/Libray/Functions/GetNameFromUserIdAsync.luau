-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Library = ReplicatedStorage:WaitForChild("Library");
local u1 = require(Library:WaitForChild("Modules").SmartCache).new(15, 3600, 60, function(p2) -- Line: 15
	--[[
		Upvalues:
			[1] = Players
	--]]
	local PlayerByUserId = Players:GetPlayerByUserId(p2);
	if PlayerByUserId then
		return true, PlayerByUserId.Name;
	end
	local NameFromUserIdAsync = Players:GetNameFromUserIdAsync(p2);
	assert(typeof(NameFromUserIdAsync) == "string");
	assert(#NameFromUserIdAsync > 0 and #NameFromUserIdAsync <= 20 or false);
	return true, NameFromUserIdAsync;
end);
return function(p1) -- Line: 27
	--[[
		Upvalues:
			[1] = u1
	--]]
	return u1.get(p1, nil, true) or u1.get(p1);
end;
