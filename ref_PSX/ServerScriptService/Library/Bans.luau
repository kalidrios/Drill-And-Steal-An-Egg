-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local Settings = require(script.Parent.Settings)
local Datastore = require(script.Parent.Datastore)
local Network = require(script.Parent.Network)
local Saving = require(script.Parent.Saving)
local Admins = require(script.Parent.Admins)
local Gamepasses = require(script.Parent.Gamepasses)
local Signal = require(game.ReplicatedStorage.Library.Signal)
local Functions = require(game.ReplicatedStorage.Library.Functions)
local DatastoreService = require(game.ReplicatedStorage.Library.Services).DataStoreService --game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")

local v1 = "new" .. Settings.BanVersion;
local v2 = DatastoreService:GetDataStore("BanPlayer" .. v1);
local l__RunService__3 = game:GetService("RunService");
local u2 = {};
local u3 = DatastoreService:GetOrderedDataStore("BanRecent" .. v1);
function u2.Ban(p1, p2, p3)
	if type(p1) == "userdata" and p1.ClassName == "Player" then
		p1 = p1.UserId;
	end;
	p2 = p2 or 1;
	p3 = p3 or "Automated";
	if u2.IsBanned(p1) == false then
		local v4 = u2.GetProfile(p1, true);
		if v4 then
			table.insert(v4.History, 1, {
				type = "Ban", 
				moderator = p2, 
				reason = p3, 
				date = os.time()
			});
			u2.UpdateProfile(p1, {
				History = v4.History, 
				Bans = v4.Bans + 1, 
				IsBanned = true
			});
			wait(1);
			local v5 = Datastore.Set(u3, HttpService:JSONEncode({
				t = "Ban", 
				m = p2, 
				v = p1
			}), os.time());
			if v5 then
				Signal.Fire("Banned Player", p1);
				local v6 = game.Players:GetPlayerByUserId(p1);
				if v6 then
					v6:Kick("Please rejoin.");
					Network.FireAll("Chat Msg", v6.DisplayName .. " was banned.", Color3.fromRGB(255, 60, 60));
				end;
			end;
			pcall(function()
				MessagingService:PublishAsync("Player Banned", p1);
			end);
			if v5 then
				print("Successfully banned " .. p1);
				return true;
			end;
			print("May have failed to ban " .. p1);
		else
			print("Player doesn't have profile (" .. p1 .. ")");
		end;
	else
		print("Player is already banned (" .. p1 .. ")");
	end;
	return false;
end;
function u2.Warn(p4, p5, p6)
	if type(p4) == "userdata" and p4.ClassName == "Player" then
		p4 = p4.UserId;
	end;
	p5 = p5 or 1;
	p6 = p6 or "Automated";
	if u2.IsBanned(p4) == false and u2.IsWarned(p4) == false then
		local v7 = u2.GetProfile(p4, true);
		if v7 then
			table.insert(v7.History, 1, {
				type = "Warn", 
				moderator = p5, 
				reason = p6, 
				date = os.time()
			});
			u2.UpdateProfile(p4, {
				History = v7.History, 
				Warns = v7.Warns + 1, 
				WarnTick = os.time(), 
				IsWarned = true
			});
			wait(1);
			local v8 = Datastore.Set(u3, HttpService:JSONEncode({
				t = "Warn", 
				m = p5, 
				v = p4
			}), os.time());
			local v9 = game.Players:GetPlayerByUserId(p4);
			if v8 then
				Signal.Fire("Warned Player", p4);
				local v10 = game.Players:GetPlayerByUserId(p4);
				if v10 then
					v10:Kick("Please rejoin.");
					Network.FireAll("Chat Msg", v10.DisplayName .. " was banned.", Color3.fromRGB(255, 60, 60));
				end;
			end;
			pcall(function()
				MessagingService:PublishAsync("Player Banned", p4);
			end);
			if v8 then
				print("Successfully warned " .. p4);
				return true;
			end;
			print("May have failed to warn " .. p4);
		else
			print("Player doesn't have profile (" .. p4 .. ")");
		end;
	else
		print("Player is already warned or banned (" .. p4 .. ")");
	end;
	return false;
end;
function u2.Clear(p7, p8, p9)
	if type(p7) == "userdata" and p7.ClassName == "Player" then
		p7 = p7.UserId;
	end;
	p8 = p8 or 1;
	p9 = p9 or "Automated";
	if u2.IsBanned(p7) == true or u2.IsWarned(p7) == true then
		local v11 = u2.GetProfile(p7, true);
		if v11 then
			table.insert(v11.History, 1, {
				type = "Unban", 
				moderator = p8, 
				reason = p9, 
				date = os.time()
			});
			u2.UpdateProfile(p7, {
				History = v11.History, 
				Unbans = v11.Unbans + 1, 
				IsBanned = false, 
				IsWarned = false
			});
			wait(1);
			if Datastore.Set(u3, HttpService:JSONEncode({
				t = "Unban", 
				m = p8, 
				v = p7
				}), os.time()) then
				print("Successfully cleared " .. p7);
				return true;
			end;
			print("May have failed to clear " .. p7);
		else
			print("Player doesn't have profile (" .. p7 .. ")");
		end;
	else
		print("Player is cleared already (" .. p7 .. ")");
	end;
	return false;
end;
function u2.IsBanned(p10)
	if type(p10) == "userdata" and p10.ClassName == "Player" then
		p10 = p10.UserId;
	end;
	local v12 = u2.GetProfile(p10);
	if not v12 then
		return false;
	end;
	return v12.IsBanned;
end;
local u4 = Settings.WarnTime or 259200;
function u2.IsWarned(p11)
	if type(p11) == "userdata" and p11.ClassName == "Player" then
		p11 = p11.UserId;
	end;
	local v13 = u2.GetProfile(p11);
	if v13 then
		local v14 = u4 - (os.time() - v13.WarnTick);
		local v15 = Functions.TimeString(v14);
		if v13.IsWarned and v14 > 0 then
			return true, v15;
		end;
	end;
	return false;
end;
function u2.HasProfile(p12)
	return u2.GetProfile(p12) ~= nil;
end;
local u5 = {};
local u6 = {};
function u2.GetProfile(p13, p14)
	if type(p13) == "userdata" and p13.ClassName == "Player" then
		p13 = p13.UserId;
	end;
	if p14 == nil then

	end;
	local v16 = game.Players:GetPlayerByUserId(p13);
	if u5[p13] and u6[p13] and not p14 and os.clock() - u6[p13] <= 60 then
		return u5[p13];
	end;
	local v17 = Datastore.Get(v2, p13);
	if v17 and not u5[p13] then
		u5[p13] = v17;
		u6[p13] = os.clock();
	end;
	return v17;
end;
function u2.UpdateProfile(p15, p16)
	if type(p15) == "userdata" and p15.ClassName == "Player" then
		p15 = p15.UserId;
	end;
	local v18 = game.Players:GetPlayerByUserId(p15);
	local v19 = nil;
	local v20 = nil;
	local v21 = nil;
	local v22 = nil;
	local v23 = nil;
	if v18 then
		v23 = Saving.Get(v18);
		if v23 then
			v19 = v18.AccountAge;
			v20 = tostring(v18.MembershipType);
			v21 = Gamepasses.OwnsAmount(v18);
			v22 = os.time();
		end;
	end;
	Datastore.Update(v2, p15, function(p17)
		if v23 then
			p17.AccountAge = v19;
			p17.Membership = v20;
			p17.Gamepasses = v21;
			p17.LastUpdate = v22;
			p17.Paid = v23.PaidPlayer;
			p17.RobuxSpent = v23.RobuxSpent;
		end;
		if p17.IsWarned and u4 <= os.time() - p17.WarnTick then
			p17.IsWarned = false;
			p17.WarnTick = 0;
		end;
		if p16 then
			for v24, v25 in pairs(p16) do
				p17[v24] = v25;
			end;
		end;
		u5[p15] = p17;
		u6[p15] = os.clock();
		return p17;
	end);
end;
function u2.CreateProfile(p18)
	local v26 = nil;
	if type(p18) == "userdata" and p18.ClassName == "Player" then
		p18 = p18.UserId;
	end;
	local v27 = game.Players:GetPlayerByUserId(p18);
	v26 = Saving.Get(v27);
	if not v27 or not v26 then
		return;
	end;
	local v28 = {
		History = {}, 
		IsBanned = false, 
		IsWarned = false, 
		WarnTick = 0, 
		Bans = 0, 
		Warns = 0, 
		Unbans = 0, 
		AccountAge = v27.AccountAge, 
		Membership = tostring(v27.MembershipType), 
		Gamepasses = Gamepasses.OwnsAmount(v27), 
		LastUpdate = os.time(), 
		Paid = v26.PaidPlayer, 
		RobuxSpent = v26.RobuxSpent
	};
	Datastore.Set(v2, v27.UserId, v28);
	u5[p18] = v28;
	u6[p18] = os.clock();
	return v28;
end;
local u7 = {};
local u8 = {};
function u2.GetRecentList(p19)
	if u7[p19] and os.clock() - u8[p19] >= 60 then
		return u7[p19];
	end;
	local v29 = {};
	local v30 = u3:GetSortedAsync(false, 100);
	local v31 = 1;
	while true do
		local v32 = {}; 
		for v33, v34 in ipairs((v30:GetCurrentPage())) do
			local v35 = HttpService:JSONDecode(v34.key);
			local l__value__36 = v34.value;
			table.insert(v32, v33, {
				d = l__value__36, 
				tp = os.time() - l__value__36, 
				t = v35.t, 
				m = v35.m, 
				v = v35.v
			});
		end;
		u7[v31] = v32;
		u8[v31] = os.clock();
		if v31 == p19 then
			v29 = v32;
		end;
		if v30.IsFinished then
			break;
		end;
		if v31 == p19 then
			return v29;
		end;
		v30:AdvanceTkalidriostPageAsync();
		v31 = v31 + 1;	
	end;
	return v29;
end;
local u9 = Settings.AdminsBannable or false;
local u10 = Random.new();
local u11 = l__RunService__3:IsStudio();
function TrackPlayer(p20)
	coroutine.wrap(function()
		while true do
			if not Saving.IsLoaded(p20) then

			else
				break;
			end;
			if p20 then

			else
				break;
			end;
			l__RunService__3.Heartbeat:Wait()
		end;
		if not p20 then
			return;
		end;
		while true do
			if p20 then

			else
				break;
			end;
			if game.Players:FindFirstChild(p20.Name) then

			else
				break;
			end;
			local v37 = u2.GetProfile(p20.UserId) or u2.CreateProfile(p20.UserId);
			local v39
			local v38 
			if Admins.IsAdmin(p20) then
				if u9 then
					v38 = u2.IsWarned(p20.UserId);
					if not u2.IsBanned(p20.UserId) then
						if v38 then
							v39 = false;
							if v38 then
								if 0 < u4 - (os.time() - v37.WarnTick) then
									v39 = true;
								end;
							else
								v39 = true;
							end;
							if v39 then
								p20:Kick("Please rejoin.");
							end;
						end;
					else
						v39 = false;
						if v38 then
							if 0 < u4 - (os.time() - v37.WarnTick) then
								v39 = true;
							end;
						else
							v39 = true;
						end;
						if v39 then
							p20:Kick("Please rejoin.");
						end;
					end;
				end;
			else
				v38 = u2.IsWarned(p20.UserId);
				if not u2.IsBanned(p20.UserId) then
					if v38 then
						v39 = false;
						if v38 then
							if 0 < u4 - (os.time() - v37.WarnTick) then
								v39 = true;
							end;
						else
							v39 = true;
						end;
						if v39 then
							p20:Kick("Please rejoin.");
						end;
					end;
				else
					v39 = false;
					if v38 then
						if 0 < u4 - (os.time() - v37.WarnTick) then
							v39 = true;
						end;
					else
						v39 = true;
					end;
					if v39 then
						p20:Kick("Please rejoin.");
					end;
				end;
			end;
			wait(90 * u10:NextNumber(0.5, 1));
			if p20 then
				if game.Players:FindFirstChild(p20.Name) then
					if not u11 then
						u2.UpdateProfile(p20.UserId);
					end;
				end;
			end;		
		end;
	end)();
end;
for v40, v41 in ipairs(game.Players:GetPlayers()) do
	TrackPlayer(v41);
end;
game.Players.PlayerAdded:Connect(function(p21)
	TrackPlayer(p21);
end);
coroutine.wrap(function()
	(function()
		local v42, v43 = pcall(function()
			return MessagingService:SubscribeAsync("Player Banned", function(p22)
				if p22 then
					for v44, v45 in ipairs(game.Players:GetPlayers()) do
						if v45 and v45.UserId == p22 then
							v45:Kick("Please rejoin.");
							Network.FireAll("Chat Msg", v45.DisplayName .. " was banned.", Color3.fromRGB(255, 60, 60));
							return;
						end;
					end;
				end;
			end);
		end);
		if not v42 then
			print("Failed to connect to live _L.Bans updates.");
		end;
	end)();
end)();
return u2;
