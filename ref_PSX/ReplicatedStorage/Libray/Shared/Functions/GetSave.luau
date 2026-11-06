-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").DefaultStats);
if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService");
	local m_Saving = require(ServerScriptService:WaitForChild("Library").Saving);
	return function(p2) -- Line: 18
		--[[
			Upvalues:
				[1] = m_Saving
		--]]
		return m_Saving.Get(p2, nil, true);
	end;
end
local m_Save = require(Library:WaitForChild("Client").Save);
return function(p1) -- Line: 26
	--[[
		Upvalues:
			[1] = m_Save
	--]]
	return m_Save.Get(p1);
end;
