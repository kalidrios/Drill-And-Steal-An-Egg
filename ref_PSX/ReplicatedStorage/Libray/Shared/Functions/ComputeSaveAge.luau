-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").DefaultStats);
return function(p1, p2) -- Line: 10
	local v1 = p1.Age or 0;
	local t_LoginTime = p1.LoginTime;
	if t_LoginTime then
		v1 = v1 + math.max(0, (p2 or workspace:GetServerTimeNow()) - t_LoginTime);
	end
	return v1;
end;
