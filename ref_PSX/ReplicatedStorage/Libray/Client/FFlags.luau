-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Library = ReplicatedStorage:WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local Modules = Library:WaitForChild("Modules");
local m_Functions = require(Library.Functions);
local m_Signal = require(Library.Signal);
local m_Network = require(Client.Network);
local m_FFlags = require(Modules.FFlags);
local table1 = {
	Options = m_FFlags.Options,
	Keys = m_FFlags.Keys,
	currentData = {},
	currentDataSaved = {}
};
function table1.Get(p1) -- Line: 23
	--[[
		Upvalues:
			[1] = m_FFlags
			[2] = table1
	--]]
	if typeof(p1) ~= "string" then
		error(string.format("Key must be string (was '%s')", (typeof(p1))));
	end
	local v1 = m_FFlags.Options[p1];
	if not v1 then
		error(string.format("Missing key: %s", p1));
	end
	local v2 = table1.currentData[p1];
	if v2 == nil and not v1.Nullable then
		v2 = v1.Default;
	end
	return v2;
end
local table2 = {};
function table1.CanBypass(p2) -- Line: 39
	--[[
		Upvalues:
			[1] = Players
			[2] = table2
			[3] = m_FFlags
	--]]
	assert(p2 == nil and true or typeof(p2) == "Instance" and p2:IsA("Player") or false);
	local u1 = p2 or Players.LocalPlayer;
	local v3 = table2[u1];
	if v3 ~= nil then
		return v3;
	end
	local bool1 = false;
	pcall(function() -- Line: 47
		--[[
			Upvalues:
				[1] = m_FFlags
				[2] = u1
				[3] = bool1
				[4] = table2
		--]]
		if m_FFlags.Admins[u1.UserId] then
			bool1 = true;
		end
		table2[u1] = bool1;
	end);
	return bool1;
end
m_Network.Fired("FFlags Changed"):Connect(function(p3) -- Line: 60
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Functions
			[3] = m_Signal
	--]]
	local v4 = table1;
	local v5 = table1;
	local v6 = m_Functions.DeepCopyUnsafe(p3);
	local v7 = m_Functions.DeepCopyUnsafe(p3);
	v4.currentData = v6;
	v5.currentDataSaved = v7;
	task.spawn(function() -- Line: 62
		--[[
			Upvalues:
				[1] = m_Signal
				[2] = m_Functions
				[3] = p3
		--]]
		m_Signal.Fire("FFlags Changed", m_Functions.DeepCopyUnsafe(p3));
	end);
end);
return table1;
