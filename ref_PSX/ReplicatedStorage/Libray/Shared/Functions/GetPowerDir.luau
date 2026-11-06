-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
return function(p1, p2) -- Line: 11
	--[[
		Upvalues:
			[1] = m_Directory
	--]]
	local tonumber_ret = tonumber(p2);
	if not tonumber_ret then
		warn("GetPowerDir was given nil tier!!!!!");
		return nil, nil;
	end
	assert(tonumber_ret);
	local v1 = m_Directory.Powers[p1];
	if not v1 then
		return nil, nil;
	end
	assert(v1);
	local v2 = v1.tiers[tonumber_ret];
	if not v2 then
		return nil, nil;
	end
	assert(v2);
	return v2, v1;
end;
