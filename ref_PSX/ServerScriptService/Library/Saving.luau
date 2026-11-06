-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {};

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Datastore = require(ServerLibrary.Datastore)
local Settings = require(ServerLibrary.Settings)
local Network = require(ServerLibrary.Network)
local Functions = require(Library.Functions)
local Signal = require(Library.Signal)

local v2 
if Settings.ReplicateOtherStatsInstantly then
	v2 = 0;
else
	v2 = Settings.ReplicateOtherStatsBuffer or 0.33;
end;

local v4 = RunService:IsStudio() or RunService:IsRunMode();
local u2 = Settings.DisableSaving or false;
local u3 = Settings.SaveDebugging or false;
local u4 = {};
local DatastoreService = game:GetService("DataStoreService")
local u5 = DatastoreService:GetDataStore((Settings.DisableLoading or false) == false and Settings.StatsVersion or "NonSave0");
function v1.Save(p1, p2, p3)
	local v5 = type(p1) == "number";
	local v6 = v5 and p1 or p1.UserId;
	local v7 = v5 and v6 or p1.Name;
	if u2 then
		if u3 then
			print("Cancelled save for " .. v7 .. " because saving is disabled");
		end;
		return true;
	end;
	local v8 = p3 or u4["u" .. v6];
	if v8 ~= nil then
		local v9 = Datastore.Update(u5, v6, function(p4)
			if p4 ~= nil then
				local l__LastSaveTimestamp__10 = p4.LastSaveTimestamp;
				if u3 and l__LastSaveTimestamp__10 ~= nil then
					print("Time elapsed since last save for" .. v7 .. ": " .. Functions.TimeString(os.time() - l__LastSaveTimestamp__10));
				end;
			end;
			v8.LastSaveTimestamp = os.time();
			v8.PlayingSession = not p2 or not false;
			return HttpService:JSONEncode(v8);
		end);
		if u3 and v9 then
			print("Successfully saved" .. v7 .. "'s stats!");
		end;
		if v9 then
			return v9;
		end;
	end;
	warn("Failed to save " .. v7 .. "'s stats");
	coroutine.wrap(function()
		if not v5 and p1 then
			Network.Fire("Save Failed", p1);
			wait(5);
			if p1 then
				p1:Kick("Periodic Save Failed");
			end;
		end;
	end)();
	return false;
end;
local u6 = Settings.SavePlayerID or 0;
local u7 = Random.new();
function v1.Retrieve(p5)
	local v11 = false;
	local v12 = false;
	local v13

	local v14
	local attempts = 0
	while attempts < 6 and not v11 and not v12 do
		if not p5 then
			break;
		end;
		if not p5.Parent then
			break;
		end;
		if v4 then
			v13 = u6 > 0 and u6 or p5.UserId;
		else
			v13 = p5.UserId;
		end;
		v14, v11 = Datastore.Get(u5, v13);
		if v14 and v14.PlayingSession and not v4 then
			v11 = false;
		elseif not v14 and v11 then
			v12 = true;
		end;

		if v14 then v14 = HttpService:JSONDecode(v14) end

		attempts = attempts + 1

		if not v11 then
			wait(u7:NextNumber(5, 8));
		end;	
	end;
	if v14 and v14.PlayingSession then
		warn("Stats were retrieved, but PlayingSession flag was saved as true. Ignore this if test session.");
		v11 = true;
	end;
	if v12 then
		if u3 then
			print("New player, " .. p5.Name .. ", joined the game!");
		end;
		return {};
	end;
	if u3 then
		if v11 then
			if u3 then
				print("Successfully retrieved stats for " .. p5.Name .. "!");
			end;
		else
			warn("Failed to retrieve stats for " .. p5.Name .. "");
		end;
	end;
	if not v11 then
		return "Error";
	end;
	if u6 ~= 0 then
		print(u6);
	end;
	return v14;
end;
local u8 = {};
local u9 = {};
function v1.Init(p6)
	if u8[p6.UserId] then
		return;
	end;
	u8[p6.UserId] = true;
	local function v17()
		local l__UserId__18 = p6.UserId;
		while (u4["u" .. l__UserId__18] ~= nil or not (not u9["u" .. l__UserId__18])) and p6 do
			if not p6.Parent then
				break;
			end;
			RunService.Heartbeat:Wait();		
		end;
		if u4["u" .. l__UserId__18] == nil and not u9["u" .. l__UserId__18] and p6 and p6.Parent then
			local v19 = v1.Retrieve(p6);
			if not p6 or not p6.Parent then
				return;
			elseif v19 == "Error" then
				warn("Saving.Init | MAJOR ERROR: Stats returned error for " .. p6.Name);
				return false;
			elseif v19 then
				v19.PlayingSession = true;
				if not v1.Save(p6, nil, v19) or not p6 or not p6.Parent then
					return false;
				else
					if v19 then
						u4["u" .. l__UserId__18] = v19;
						for v20, v21 in pairs(Settings.DefaultStats) do
							if v19[v20] == nil then
								u4["u" .. l__UserId__18][v20] = type(v21) == "table" and Functions.CloneTable(v21) or v21;
							end;
						end;
					else
						u4["u" .. l__UserId__18] = Functions.CloneTable(Settings.DefaultStats);
						u4["u" .. l__UserId__18].PlayingSession = true;
					end;
					Signal.Fire("Player Added", p6);
					local v22 = {};
					local v23 = {};
					local v24 = os.clock();
					while p6 and p6.Parent and u4["u" .. l__UserId__18] do
						local v25 = {};
						for v26, v27 in pairs(u4["u" .. l__UserId__18]) do
							if not Settings.StatsNetworkingBlacklist[v26] then
								local v28 = v22[v26];
								local v29 = type(v27) == "table";
								if v28 == nil then
									if v29 then
										local v30 = Functions.CloneTable(v27, false);
										v25[v26] = v30;
										v22[v26] = v30;
										v23[v26] = v30;
									else
										v25[v26] = v27;
										v22[v26] = v27;
										v23[v26] = v27;
									end;
									Signal.Fire("Stat Changed", p6, v26);
								elseif v29 then
									if not Functions.CompareTable(v27, v28) then
										local v31 = Functions.CloneTable(v27, false);
										v25[v26] = v31;
										v22[v26] = v31;
										v23[v26] = v31;
										Signal.Fire("Stat Changed", p6, v26);
									end;
								elseif v27 ~= v28 then
									v25[v26] = v27;
									v22[v26] = v27;
									v23[v26] = v27;
									Signal.Fire("Stat Changed", p6, v26);
								end;
							end;
						end;
						if Functions.DictionaryLength(v25) > 0 then
							Network.Fire("New Stats", p6, v25, p6);
						end;
						if v2 <= os.clock() - v24 and Functions.DictionaryLength(v23) > 0 then
							v24 = os.clock();
							for v32, v33 in ipairs(game.Players:GetPlayers()) do
								if v33 ~= p6 then
									coroutine.wrap(function()
										Network.Fire("New Stats", v33, v23, p6);
									end)();
								end;							
							end;
							v23 = {};
						end;
						RunService.Heartbeat:Wait();					
					end;
					return true;
				end;
			else
				if v19 then
					u4["u" .. l__UserId__18] = v19;
					for v20, v21 in pairs(Settings.DefaultStats) do
						if v19[v20] == nil then
							u4["u" .. l__UserId__18][v20] = type(v21) == "table" and Functions.CloneTable(v21) or v21;
						end;
					end;
				else
					u4["u" .. l__UserId__18] = Functions.CloneTable(Settings.DefaultStats);
					u4["u" .. l__UserId__18].PlayingSession = true;
				end;
				Signal.Fire("Player Added", p6);
				local v22 = {};
				local v23 = {};
				local v24 = os.clock();
				while p6 and p6.Parent and u4["u" .. l__UserId__18] do
					local v25 = {};
					for v26, v27 in pairs(u4["u" .. l__UserId__18]) do
						if not Settings.StatsNetworkingBlacklist[v26] then
							local v28 = v22[v26];
							local v29 = type(v27) == "table";
							if v28 == nil then
								if v29 then
									local v30 = Functions.CloneTable(v27, false);
									v25[v26] = v30;
									v22[v26] = v30;
									v23[v26] = v30;
								else
									v25[v26] = v27;
									v22[v26] = v27;
									v23[v26] = v27;
								end;
								Signal.Fire("Stat Changed", p6, v26);
							elseif v29 then
								if not Functions.CompareTable(v27, v28) then
									local v31 = Functions.CloneTable(v27, false);
									v25[v26] = v31;
									v22[v26] = v31;
									v23[v26] = v31;
									Signal.Fire("Stat Changed", p6, v26);
								end;
							elseif v27 ~= v28 then
								v25[v26] = v27;
								v22[v26] = v27;
								v23[v26] = v27;
								Signal.Fire("Stat Changed", p6, v26);
							end;
						end;
					end;
					if Functions.DictionaryLength(v25) > 0 then
						Network.Fire("New Stats", p6, v25, p6);
					end;
					if v2 <= os.clock() - v24 and Functions.DictionaryLength(v23) > 0 then
						v24 = os.clock();
						for v32, v33 in ipairs(game.Players:GetPlayers()) do
							if v33 ~= p6 then
								coroutine.wrap(function()
									Network.Fire("New Stats", v33, v23, p6);
								end)();
							end;						
						end;
						v23 = {};
					end;
					RunService.Heartbeat:Wait();				
				end;
				return true;
			end;
		end;
	end;
	local v35 = 0;
	local v36 = false;
	while not v36 and v35 < 3 and p6 do
		if not p6.Parent then
			break;
		end;
		v36 = v17();
		RunService.Heartbeat:Wait();
		if not v36 then
			v35 = v35 + 1;
			wait(0.5);
		end;	
	end;
	if not v36 and p6 then
		warn("MAJOR ERROR: Could not init " .. p6.Name .. "'s stats!");
		p6:Kick("Something went wrong. Please rejoin!");
	end;
	u8[p6.UserId] = nil;
end;
function v1.Get(p7, p8)
	local v37
	if p8 == nil then
		v37 = true;
	else
		v37 = p8;
	end;
	p8 = v37;
	if not p7 then
		return;
	end;
	if u9["u" .. p7.UserId] then
		return;
	end;
	local v38 = u4["u" .. p7.UserId];
	if not v38 then
		local u10 = v38;
		pcall(function()
			local v39 = os.clock();
			if p8 then
				while not u10 and os.clock() - v39 <= 5 and p7 do
					if not p7.Parent then
						break;
					end;
					RunService.Heartbeat:Wait();
					u10 = u4["u" .. p7.UserId];				
				end;
			end;
			if not u10 and u3 then
				warn("Failed to index " .. p7.Name .. "'s stats");
			end;
		end);
	end;
	return v38;
end;
function v1.Remove(p9)
	local v40 = type(p9) == "number";
	local v41 = v40 and p9 or p9.UserId;
	if not pcall(function()
			u4["u" .. v41] = nil;
			wait(10);
			u9["u" .. v41] = nil;
		end) then
		local u11 = v40 and v41 or p9.Name;
		pcall(function()
			warn("Failed to remove session stats for " .. u11 .. "!");
		end);
	end;
end;
function v1.Reset(p10)
	if u4["u" .. p10.UserId] then
		u4["u" .. p10.UserId] = Functions.CloneTable(Settings.DefaultStats);
		v1.Save(p10);
	end;
end;
function v1.IsLoaded(p11)
	local v42 = p11 and p11:FindFirstChild("__LOADED") ~= nil;
	return v42;
end;
local function v43(p12)
	local v44 = type(p12) == "number" and p12 or p12.UserId;
	if u4["u" .. v44] and not u9["u" .. v44] then
		u9["u" .. v44] = true;
		wait(8);
		v1.Save(v44, true);
		wait(1);
		v1.Remove(v44);
	end;
end;
for v45, v46 in ipairs(game.Players:GetPlayers()) do
	coroutine.wrap(function()
		v1.Init(v46);
	end)();
end;
game.Players.PlayerAdded:Connect(function(p13)
	coroutine.wrap(function()
		v1.Init(p13);
	end)();
end);
game.Players.PlayerRemoving:Connect(v43);
coroutine.wrap(function()
	while true do
		for v48, v49 in pairs(u4) do
			local v50 = tonumber(string.sub(v48, 2));
			if not u9[v48] and not game.Players:GetPlayerByUserId(v50) then
				v43(v50);
			end;
		end;
		RunService.Heartbeat:Wait();	
	end;
end)();
function game.OnClose()
	if not u2 then
		for v51, v52 in ipairs(game.Players:GetPlayers()) do
			coroutine.wrap(function()
				if v52 then
					v1.Save(v52, true);
				end;
			end)();	
			Signal.Fire("Server Closing", v52);
		end;
		game.Workspace:SetAttribute("ServerClosing", true)
		Network.FireAll("Start Shutdown")

		wait(RunService:IsStudio() and 0 or 30);
	end;
end;
local u12 = Settings.SaveDuration or 60;
coroutine.wrap(function()
	while true do
		for v55, v56 in pairs(u4) do
			if v55 and v56 then
				wait(u12 / #game.Players:GetPlayers());
				pcall(function()
					local v57 = tonumber(string.sub(v55, 2));
					local v58 = game.Players:GetPlayerByUserId(v57);
					if v58 and not u9["u" .. v57] and u4["u" .. v57] then
						coroutine.wrap(function()
							v1.Save(v58);
						end)();
					end;
				end);
			end;
		end;
		RunService.Heartbeat:Wait();	
	end;
end)();
Network.Invoked("Get Stats").OnInvoke = function(p14, p15, p16)
	if not p15 then
		p15 = p14;
	end;
	local save = v1.Get(p15, p16)
	if not save then
		return nil
	end
	return save;
end;
return v1;
