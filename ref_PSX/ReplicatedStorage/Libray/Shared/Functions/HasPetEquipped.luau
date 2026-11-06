-- https://github.com/kalidrios

local m_Variables = require(script.Parent.Parent.Variables);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local _ = require(Modules.DefaultStats);
local _ = require(Modules.Pets);
return function(p1, p2) -- Line: 13
	--[[
		Upvalues:
			[1] = m_Variables
	--]]
	if p2 and (m_Variables.IsHardcore and p1.HardcorePetsEquipped or p1.PetsEquipped)[p2.uid] then
		return true;
	end
	return false;
end;
