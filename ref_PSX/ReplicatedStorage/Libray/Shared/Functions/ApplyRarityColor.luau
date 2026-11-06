-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local UI = Assets:WaitForChild("UI");
local Raritys = UI:WaitForChild("Raritys");
return function(p1, p2) -- Line: 10
	--[[
		Upvalues:
			[1] = Raritys
	--]]
	local Clone_ret = Raritys:WaitForChild(p2):Clone();
	Clone_ret.Parent = p1;
end;
