-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {};

-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Directory = require(Library.Directory)
local Signal = require(Library.Signal)
local Network = require(ServerLibrary.Network)
local Settings = require(ServerLibrary.Settings)

local DataStoreService = require(game.ReplicatedStorage.__DATASTORE)

local v2 = Settings.DatastoreQueueWaitTime or 6;
local v3 = Instance.new("DataStoreOptions");
v3:SetExperimentalFeatures({
	v2 = true
});
local v4 = {};
local u2 = {};
local u3 = Settings.DatastoreGetAttempts or 5;
local u4 = Settings.DatastoreDebug or false;
function v1.Get(p1, p2, p3)
	if p2 == nil or p1 == nil then
		warn("Key or datastore nil");
		return;
	end;
	if type(p1) == "string" then
		p3 = p3 or "global";
		if not u2[p1] then
			u2[p1] = {};
		end;
		if not u2[p1][p3] then
			u2[p1][p3] = DataStoreService:GetDataStore(p1, p3, v3);
		end;
		p1 = u2[p1][p3];
	end;
	local v5 = 0;
	local v6 = false;
	local returnedValue 
	while v5 < u3 and returnedValue == nil do
		v5 = v5 + 1;
		v6 = pcall(function()
			returnedValue = p1:GetAsync(p2);
		end);
		if not v6 then
			wait(0.5);
		end;	
	end;
	if u4 and (u3 <= v5 or returnedValue == nil) then
		warn("Could not get key --- [bold]" .. p2 .. "[/bold]");
	end;
	return returnedValue, v6;
end;
local u6 = Settings.DatastoreSetAttempts or 5;
function v1.Set(p4, p5, p6, p7)
	local u7 = nil;
	local v7 = nil;
	if p5 == nil or p6 == nil or p4 == nil then
		warn("Key, value, or datastore nil");
		return false;
	end;
	if type(p4) == "string" then
		p7 = p7 or "global";
		if not u2[p4] then
			u2[p4] = {};
		end;
		if not u2[p4][p7] then
			u2[p4][p7] = DataStoreService:GetDataStore(p4, p7, v3);
		end;
		p4 = u2[p4][p7];
	end;
	local v8 = 0;
	while true do
		v8 = v8 + 1;
		u7 = p5;
		v7 = pcall(function()
			p4:SetAsync(u7, p6);
		end);
		if not v7 then
			wait(0.5);
		end;
		if v7 then
			break;
		end;
		if u6 <= v8 then
			break;
		end;	
	end;
	if u4 and u6 <= v8 then
		warn("Failed to set key --- [bold]" .. u7 .. "[/bold]");
	end;
	return v7;
end;
local u8 = Settings.DatastoreUpdateAttempts or 5;
function v1.Update(p8, p9, p10, p11)
	local u9 = nil;
	local v9 = nil;
	if p9 == nil or p10 == nil or p8 == nil then
		warn("Key, function, or datastore nil");
		return false;
	end;
	if type(p8) == "string" then
		p11 = p11 or "global";
		if not u2[p8] then
			u2[p8] = {};
		end;
		if not u2[p8][p11] then
			u2[p8][p11] = DataStoreService:GetDataStore(p8, p11, v3);
		end;
		p8 = u2[p8][p11];
	end;
	local v10 = 0;
	while true do
		v10 = v10 + 1;
		u9 = p9;
		v9 = pcall(function()
			p8:UpdateAsync(u9, p10);
		end);
		if not v9 then
			wait(0.5);
		end;
		if v9 then
			break;
		end;
		if u8 <= v10 then
			break;
		end;	
	end;
	if u4 and u8 <= v10 then
		warn("Failed to update key --- [bold]" .. u9 .. "[/bold]");
	end;
	return v9;
end;
return v1;
