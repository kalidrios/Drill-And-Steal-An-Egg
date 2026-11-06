-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
local _ = require(Modules.DefaultStats);
function test(p1, p2) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Directory
	--]]
	if p1.UserId == 561445931 or p1.UserId == 1365955553 or p1.UserId == 1518402401 then
		return true;
	end
	if p1.UserId == 321306213 then
		return true;
	end
	if p2 then
		local v2 = 0;
		for _, val1 in ipairs(p2.Pets) do
			local v3 = m_Directory.Pets[val1.id];
			if not v3 then continue end
			if v3.titanic then
				v2 = v2 + 10;
			end
			if not v3.huge then continue end
			v2 = v2 + 1;
		end
		if v2 >= 10 then
			return true;
		end
	end
	return false;
end
if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService");
	local m_Saving = require(ServerScriptService:WaitForChild("Library").Saving);
	return function(p4) -- Line: 59
		--[[
			Upvalues:
				[1] = m_Saving
		--]]
		assert(p4);
		return test(p4, m_Saving.Get(p4));
	end;
end
local m_Save = require(Library:WaitForChild("Client").Save);
return function(p3) -- Line: 68
	--[[
		Upvalues:
			[1] = Players
			[2] = m_Save
	--]]
	local v1 = p3 or Players.LocalPlayer;
	return test(v1, m_Save.Get(v1));
end;
