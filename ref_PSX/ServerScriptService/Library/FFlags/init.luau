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

local l__ServerScriptService__2 = game:GetService("ServerScriptService");
local l__MessagingService__3 = game:GetService("MessagingService");
local v4 = require(Modules.FFlags);
local v5 = {
	Options = v4.Options, 
	Keys = v4.Keys
};
local u2 = require(script.HTTPUtil);
local u3 = {};
function v5.Get(p1, p2)
	if typeof(p1) ~= "string" then
		error(string.format("Key must be string (was '%s')", (typeof(p1))));
	end;
	local v6 = v5.Options[p1];
	if not v6 then
		error(string.format("Missing key: %s", p1));
	end;
	local v7 = (p2 or u3)[p1];
	if v7 == nil and not v6.Nullable then
		v7 = v6.Default;
	end;
	return v7;
end;
function v5.Set(p3, p4)
	if typeof(p3) ~= "string" then
		error(string.format("Key must be string (was '%s')", (typeof(p3))));
	end;
	local v8 = v5.Options[p3];
	if not v8 then
		error(string.format("Missing key: %s", p3));
	end;
	if v8.Nullable then
		local v9 = true;
		if p4 ~= nil then
			v9 = typeof(p4) == v8.Type;
		end;
		assert(v9);
	else
		assert(typeof(p4) == v8.Type);
		if p4 == v8.Default then
			p4 = nil;
		end;
	end;
	if v8.Type == "number" and p4 and v8.Min then
		assert(v8.Min <= p4);
	end;
	if v8.Type == "number" and p4 and v8.Max then
		assert(p4 <= v8.Max);
	end;
	u3[p3] = p4;
end;
local u4 = {};
function v5.CanBypass(p5)
	local v10 = false;
	if typeof(p5) == "Instance" then
		v10 = p5:IsA("Player");
	end;
	assert(v10);
	local v11 = u4[p5];
	if v11 ~= nil then
		return v11;
	end;
	local u5 = false;
	pcall(function() 
		if p5.UserId == 561445931 then
			u5 = true;
		end;
		u4[p5] = u5;
	end);
	return false;
end;
function grabAllOptions()
	local v12 = {};
	for v16, v17 in pairs(v5.Options) do
		local v18 = v5.Get(v16);
		if not v17.Nullable then
			if v18 ~= v17.Default then
				v12[v16] = v18;
			end;
		else
			v12[v16] = v18;
		end;	
	end;
	return v12;
end;
local u6 = {};
local u7 = -1;
function setData(p6, p7, p8, p9)
	local v19 = {
		Changes = {}, 
		Developer = p9 and p9.Name or nil, 
		ExperienceID = game.GameId
	};
	local l__Options__20 = v5.Options;
	local v21 = nil;
	local v22 = nil;
	for v23, v24 in v5.Options do
		local v25 = v5.Get(v23, u3);
		local v26 = v5.Get(v23, u6);
		if v26 ~= v25 then
			v19.Changes[v23] = {
				Name = v24.Name, 
				Type = v24.Type, 
				OldValue = v26, 
				UpdatedValue = v25, 
				Important = v24.Important or false
			};
		end;	
	end;
	p6 = Functions.DeepCopyUnsafe(p6);
	u3 = Functions.DeepCopyUnsafe(p6);
	u7 = p7;
	u6 = Functions.DeepCopyUnsafe(p6);
	task.spawn(function()
		Signal.Fire("FFlags Changed", Functions.DeepCopyUnsafe(p6));
	end);
	task.spawn(function()
		Network.FireAll("FFlags Changed", p6);
	end);
	if p8 then
		task.spawn(function()
			l__MessagingService__3:PublishAsync("FFlags/Updated", {
				Data = p6, 
				Version = p7
			});
		end);
		task.spawn(function()
			u2.HttpRequest("POST", "commit_fflags", {}, v19);
		end);
	end;
end;
function trySetData(p10, p11, p12, p13)
	if p11 <= u7 then
		return false;
	end;
	setData(p10, p11, p12, p13);
	return true;
end;
function getVersion(p14)
	if p14 then
		local l__Version__27 = p14:GetMetadata().Version;
		if l__Version__27 then
			return l__Version__27;
		end;
	end;
	return -1;
end;
function v5.Commit(p15)
	if Functions.DeepEqualsUnsafe(u3, u6) then
		return true;
	end;
	local u8 = false;
	local v28, v29, v30 = Datastore.Update("FFlags", "v1", function(p16, p17)
		local v31 = p16 or {};
		if trySetData(v31, (getVersion(p17))) then
			return nil;
		end;
		if Functions.DeepEqualsUnsafe(v31, u3) then
			u6 = Functions.DeepCopyUnsafe(u3);
			return nil;
		end;
		u8 = true;
		return Functions.DeepCopyUnsafe(u3), nil, {
			Version = u7 + 1
		};
	end);
	if not u8 then
		return true;
	end;
	if v28 then
		trySetData(v29 or {}, getVersion(v30), true, p15);
	end;
	return v28;
end;
function v5.Pull()
	local v32, v33, v34 = Datastore.Get("FFlags", "v1");
	if not v33 then
		return false;
	end;
	trySetData(v32 or {}, (getVersion(v34)));
	return true;
end;
task.spawn(function()
	while not v5.Pull() do
		task.wait(math.random() * 15 + 15);	
	end;
	while true do
		task.wait(math.random() * 600 + 300);
		v5.Pull();	
	end;
end);
task.spawn(function()
	l__MessagingService__3:SubscribeAsync("FFlags/Updated", function(p18)
		local l__Data__35 = p18.Data;
		assert(typeof(l__Data__35) == "table");
		local l__Data__36 = l__Data__35.Data;
		local l__Version__37 = l__Data__35.Version;
		assert(typeof(l__Data__36) == "table");
		assert(typeof(l__Version__37) == "number");
		trySetData(l__Data__36, l__Version__37);
	end);
end);
game.Players.PlayerAdded:Connect(function(p19)
	local u9 = Functions.DeepCopyUnsafe(u6);
	task.spawn(function()
		Network.Fire("FFlags Changed", p19, u9);
	end);
end);
return v5;
