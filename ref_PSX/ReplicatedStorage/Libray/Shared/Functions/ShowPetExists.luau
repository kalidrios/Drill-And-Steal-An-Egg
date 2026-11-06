-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").Pets);
local m_Directory = require(Library.Directory);
local m_Variables = require(script.Parent.Parent.Variables);
return function(p1) -- Line: 13
	--[[
		Upvalues:
			[1] = m_Variables
			[2] = m_Directory
	--]]
	if p1.merchData then
		return false;
	end
	if m_Variables.PetsForSale[p1.id] then
		return false;
	end
	local v1 = m_Directory.Pets[p1.id];
	if not v1 then
		return true;
	end
	if v1.isGift then
		return false;
	end
	return true;
end;
