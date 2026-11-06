-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
local _ = require(Modules.Pets);
local m_Variables = require(script.Parent.Parent.Variables);
return function(p1) -- Line: 13
	--[[
		Upvalues:
			[1] = m_Directory
			[2] = m_Variables
	--]]
	for key1, val1 in pairs(m_Directory.Eggs) do
		if val1.disabled or val1.isGolden then continue end
		for _, val2 in ipairs(val1.drops) do
			if val2[1] ~= p1 or val2[2] <= 0 or val2[3] and not m_Variables.IsHardcore then continue end
			return key1, val1;
		end
	end
	return nil, nil;
end;
