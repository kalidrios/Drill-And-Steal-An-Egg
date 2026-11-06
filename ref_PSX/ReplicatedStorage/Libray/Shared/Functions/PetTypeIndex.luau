-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").Pets);
return function(p1) -- Line: 11
	local v1 = 0;
	if p1.dm == true then
		v1 = v1 + 8;
	end
	if p1.sh == true then
		v1 = v1 + 4;
	end
	if p1.r == true then
		v1 = v1 + 2;
	end
	if p1.g == true then
		v1 = v1 + 1;
	end
	return v1;
end;
