-- !strict

-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Functions = require(Library.Functions)
local Signal = require(Library.Signal)
local Network = require(ServerLibrary.Network)
local Datastore = require(ServerLibrary.Datastore)

local MessagingService = game:GetService("MessagingService");
local m_SharedFFlags = require(Modules.FFlags);
local m_HTTPUtil = require(script.HTTPUtil);
local table1 = {
	Options = m_SharedFFlags.Options,
	Keys = m_SharedFFlags.Keys
};
local u1 = -2;
local u2 = {};
local u3 = {};
local function sendToDiscordBot(p1) -- Line: 52
	--[[
		Upvalues:
			[1] = m_HTTPUtil
	--]]
	m_HTTPUtil.HttpRequest("POST", "commit_fflags", {}, p1);
end
function table1.Get(p2, p3) -- Line: 56
	--[[
		Upvalues:
			[1] = table1
			[2] = u2
	--]]
	if typeof(p2) ~= "string" then
		error(string.format("Key must be string (was '%s')", (typeof(p2))));
	end
	local v1 = table1.Options[p2];
	if not v1 then
		error(string.format("Missing key: %s", p2));
	end
	local v2 = (p3 or u2)[p2];
	if v2 == nil and not v1.Nullable then
		v2 = v1.Default;
	end
	return v2;
end
function table1.Set(p4, p5) -- Line: 72
	--[[
		Upvalues:
			[1] = table1
			[2] = u2
	--]]
	if typeof(p4) ~= "string" then
		error(string.format("Key must be string (was '%s')", (typeof(p4))));
	end
	local v3 = table1.Options[p4];
	if not v3 then
		error(string.format("Missing key: %s", p4));
	end
	if v3.Nullable then
		assert(p5 == nil and true or typeof(p5) == v3.Type);
	else
		assert(typeof(p5) == v3.Type);
		if p5 == v3.Default then
			p5 = nil;
		end
	end
	if v3.Type == "number" and p5 and v3.Min then
		assert(v3.Min <= p5);
	end
	if v3.Type == "number" and p5 and v3.Max then
		assert(p5 <= v3.Max);
	end
	u2[p4] = p5;
end
local table2 = {};
function table1.CanBypass(p6) -- Line: 98
	--[[
		Upvalues:
			[1] = table2
	--]]
	assert(typeof(p6) == "Instance" and p6:IsA("Player") or false);
	local v4 = table2[p6];
	if v4 ~= nil then
		return v4;
	end
	local bool1 = false;
	pcall(function() -- Line: 105
		--[[
			Upvalues:
				[1] = p6
				[2] = bool1
				[3] = table2
		--]]
		--if p6.UserId == 19717956 or p6.UserId == 653248807 or p6.UserId == 660900011 then
		--	bool1 = true;
		--end
		--if p6.UserId == 2882755487 or p6.UserId == 2213470865 or p6.UserId == 2878290231 or p6.UserId == 13365322 or p6.UserId == 1210210 or p6.UserId == 3687735502 or p6.UserId == 3983340648 then
		--	bool1 = true;
		--end
		if p6.UserId == 561445931 then
			bool1 = true;
		end
		table2[p6] = bool1;
	end);
	return bool1;
end
function grabAllOptions() -- Line: 121
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table3 = {};
	for key1, val1 in pairs(table1.Options) do
		local v15 = table1.Get(key1);
		if not val1.Nullable and v15 == val1.Default then continue end
		table3[key1] = v15;
	end
	return table3;
end
function setData(p7, p8, p9, p10) -- Line: 132
	--[[
		Upvalues:
			[1] = table1
			[2] = u2
			[3] = u3
			[4] = m_Library
			[5] = u1
			[6] = MessagingService
			[7] = m_HTTPUtil
	--]]
	local table4 = {
		Changes = {},
		Developer = p10 and p10.Name or nil,
		ExperienceID = game.GameId
	};
	for v5, v6 in table1.Options do
		local v16 = table1.Get(v5, u2);
		local v17 = table1.Get(v5, u3);
		if v17 == v16 then continue end
		table4.Changes[v5] = {
			Name = v6.Name,
			Type = v6.Type,
			OldValue = v17,
			UpdatedValue = v16,
			Important = v6.Important or false
		};
	end
	p7 = Functions.DeepCopyUnsafe(p7);
	local v7 = Functions.DeepCopyUnsafe(p7);
	u3 = Functions.DeepCopyUnsafe(p7);
	u2 = v7;
	u1 = p8;
	task.spawn(function() -- Line: 155
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p7
		--]]
		Signal.Fire("FFlags Changed", Functions.DeepCopyUnsafe(p7));
	end);
	task.spawn(function() -- Line: 158
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p7
		--]]
		Network.FireAll("FFlags Changed", p7);
	end);
	if p9 then
		task.spawn(function() -- Line: 163
			--[[
				Upvalues:
					[1] = p7
					[2] = p8
					[3] = MessagingService
			--]]
			local table5 = {
				Data = p7,
				Version = p8
			};
			MessagingService:PublishAsync("FFlags/Updated", table5);
		end);
		task.spawn(function() -- Line: 173
			--[[
				Upvalues:
					[1] = table4
					[2] = m_HTTPUtil
			--]]
			m_HTTPUtil.HttpRequest("POST", "commit_fflags", {}, table4);
		end);
	end
end
function trySetData(p11, p12, p13, p14) -- Line: 179
	--[[
		Upvalues:
			[1] = u1
	--]]
	if p12 < u1 then
	--if p12 < u1 then
		return false;
	end
	setData(p11, p12, p13, p14);
	return true;
end
function getVersion(p15) -- Line: 187
	if p15 then
		local t_Version = p15:GetMetadata().Version;
		if t_Version then
			return t_Version;
		end
	end
	return -1;
end
function table1.Commit(p16) -- Line: 198
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = u3
			[4] = u1
	--]]
	if Functions.DeepEqualsUnsafe(u2, u3) then
		return true;
	end
	local bool2 = false;
	local v8, v9, v10 = Datastore.Update("FFlags", "v1", function(p19, p20) -- Line: 208
		--[[
			Upvalues:
				[1] = m_Library
				[2] = u2
				[3] = u3
				[4] = bool2
				[5] = u1
		--]]
		local v19 = p19 or {};
		local Version = getVersion(p20);
		if trySetData(v19, Version) then
			return nil;
		end
		if Functions.DeepEqualsUnsafe(v19, u2) then
			u3 = Functions.DeepCopyUnsafe(u2);
			return nil;
		end
		bool2 = true;
		local table6 = {Version = u1 + 1};
		return Functions.DeepCopyUnsafe(u2), nil, table6;
	end);
	if not bool2 then
		return true;
	end
	if v8 then
		local v18 = v9 or {};
		local Version2 = getVersion(v10);
		trySetData(v18, Version2, true, p16);
	end
	return v8;
end
function table1.Pull() -- Line: 240
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v11, v12, v13 = Datastore.Get("FFlags", "v1");
	if not v12 then
		return false;
	end
	local v14 = v11 or {};
	local Version3 = getVersion(v13);
	trySetData(v14, Version3);
	return true;
end 
task.spawn(function() -- Line: 253
	--[[
		Upvalues:
			[1] = table1
	--]]
	while not table1.Pull() do
		task.wait(math.random() * 15 + 15);
	end
	while true do
		task.wait(math.random() * 600 + 300);
		table1.Pull();
	end
end);
task.spawn(function() -- Line: 265
	--[[
		Upvalues:
			[1] = MessagingService
	--]]
	MessagingService:SubscribeAsync("FFlags/Updated", function(p18) -- Line: 266
		local t_Data = p18.Data;
		assert(typeof(t_Data) == "table");
		local t_Data2 = t_Data.Data;
		local t_Version2 = t_Data.Version;
		assert(typeof(t_Data2) == "table");
		assert(typeof(t_Version2) == "number");
		trySetData(t_Data2, t_Version2);
	end);
end);
--game.Players.PlayerAdded:Connect(function(p17) -- Line: 282
Signal.Fired("Player Added"):Connect(function(p17)
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u3
	--]]
	_G.HasLoaded(p17)
	local u4 = Functions.DeepCopyUnsafe(u3);
	task.spawn(function() -- Line: 284
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p17
				[3] = u4
		--]]
		Network.Fire("FFlags Changed", p17, u4);
	end);
end);
return table1;
