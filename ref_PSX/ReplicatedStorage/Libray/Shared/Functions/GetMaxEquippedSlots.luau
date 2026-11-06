-- https://github.com/kalidrios

local m_Variables = require(script.Parent.Parent.Variables);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").DefaultStats);
return function(p1) -- Line: 12
	--[[
		Upvalues:
			[1] = m_Variables
	--]]
	local v1 = 1;
	if m_Variables.IsHardcore then
		v1 = v1 * 2;
	end
	return p1.MaxEquipped * v1;
end;
