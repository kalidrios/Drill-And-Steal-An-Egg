-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
local _ = require(Modules.Pets);
return function(p1) -- Line: 13
	--[[
		Upvalues:
			[1] = m_Directory
	--]]
	local v1 = m_Directory.Pets[p1.id];
	local table1 = {};
	if p1.sh then
		table.insert(table1, "Shiny");
	end
	if p1.r then
		table.insert(table1, "Rainbow");
	elseif p1.g then
		table.insert(table1, "Golden");
	end
	local v2 = table.concat(table1, " ");
	if #table1 > 0 then
		v2 = v2 .. " ";
	end
	return v2 .. v1.name;
end;
