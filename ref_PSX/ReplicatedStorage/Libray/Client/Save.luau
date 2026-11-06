local v1 = {};
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__Players__3 = game:GetService("Players");
local l__ReplicatedFirst__4 = game:GetService("ReplicatedFirst");
local l__Library__5 = l__ReplicatedStorage__2:WaitForChild("Library");
local l__Client__6 = l__Library__5:WaitForChild("Client");
local v7 = require(l__Library__5.Signal);
local v8 = require(l__Client__6.Network);
local v9 = require(l__Client__6.Settings);
local v10 = require(l__ReplicatedStorage__2:WaitForChild("X"):WaitForChild("Util").Mutex);
local v11 = require(l__Library__5:WaitForChild("Modules").DefaultStats);
local u1 = {};
l__Players__3.PlayerRemoving:Connect(function(p1)
	local v12 = u1[p1];
	if v12 then
		u1[p1] = nil;
		v12:destroy();
	end;
end);
local u2 = {};
function v1.GetSaves()
	return u2;
end;
function v1.Get(p2, p3)
	local v13 = true;
	if p3 ~= nil then
		v13 = p3 == true;
	end;
	local v14 = p2 or l__Players__3.LocalPlayer;
	if not v14 or not v14.Parent then
		return nil;
	end;
	if v13 then
		return u2[v14];
	end;
	local v15 = u1[v14];
	if not v15 then
		v15 = v10.new();
		u1[v14] = v15;
	end;
	local v16, v17 = v15:runLocked(function()
		if not v14 or not v14.Parent then
			return nil;
		end;
		if not Update(v14) and v14 and v14 == l__Players__3.LocalPlayer then
			while true do
				wait(1);
				if not v14 then
					break;
				end;
				if not v14.Parent then
					break;
				end;
				if Update(v14) then
					break;
				end;			
			end;
		end;
		if not v14 then
			return nil;
		end;
		return u2[v14];
	end);
	if v16 then
		return v17;
	end;
	return nil;
end;
function Update(p4)
	local v18 = false;
	if typeof(p4) == "Instance" then
		v18 = p4:IsA("Player");
	end;
	assert(v18);
	local l__UserId__19 = p4.UserId;
	local v20 = p4 == l__Players__3.LocalPlayer;
	local v21, v22 = pcall(function()
		return v8.Invoke("Get Stats", p4);
	end);
	if not v21 then
		warn(string.format("[SAVE] Player '%d' save failed to load: '%s'", l__UserId__19, tostring(v22)));
		return false;
	end;
	if not p4 then
		warn(string.format("[SAVE] Player '%d' logged out while loading save", l__UserId__19));
		return false;
	end;
	if not v22 then
		return false;
	end;
	if typeof(v22) ~= "table" then
		warn(string.format("[SAVE] Player '%d' save was invalid type: '%s'", l__UserId__19, (typeof(v22))));
		if v20 then
			p4.Character = nil;
			p4:Kick("Something went wrong. Please rejoin!");
		end;
		return false;
	end;
	for v26, v27 in pairs(v22) do
		if typeof(v27) == "table" then
			if not v9.StatsNoFreeze[v26] then
				table.freeze(v27);
			end;
		end;	
	end;
	local v28 = u2[p4];
	if v28 then
		for v32, v33 in pairs(v22) do
			v28[v32] = v33;		
		end;
		for v37, v38 in pairs(v28) do
			v28[v37] = v22[v37];		
		end;
	else
		u2[p4] = v22;
	end;
	if v20 then
		v7.Fire("Loaded Stats", p4);
	else
		v7.Fire("Loaded Other Stats", p4);
	end;
	return true;
end;
function ProcessChanges(p5, p6)
	assert(typeof(p6) == "table");
	local v39 = false;
	if typeof(p5) == "Instance" then
		v39 = p5:IsA("Player");
	end;
	assert(v39);
	local v40 = u2[p5];
	if v40 then
		for v44, v45 in pairs(p6) do
			if typeof(v45) == "table" then
				if not v9.StatsNoFreeze[v44] then
					table.freeze(v45);
				end;
			end;
			v40[v44] = v45;		
		end;
		local v46 = p5 == l__Players__3.LocalPlayer;
		for v50, v51 in pairs(p6) do
			if v46 then
				v7.Fire("Stat Changed", v50);
			else
				v7.Fire("Other Stat Changed", p5, v50);
			end;		
		end;
		if v46 then
			v7.Fire("Stats Changed");
			return;
		end;
		v7.Fire("Other Stats Changed", p5);
	end;
end;
function v1.FetchPlayer(p7)
	local v52 = false;
	if typeof(p7) == "Instance" then
		v52 = p7:IsA("Player");
	end;
	assert(v52);
	local v53 = u1[p7];
	if not v53 then
		v53 = v10.new();
		u1[p7] = v53;
	end;
	v53:runLocked(function()
		while p7 and not u2[p7] do
			Update(p7);
			if not p7 then
				break;
			end;
			if u2[p7] then
				break;
			end;
			wait(0.5);		
		end;
	end);
end;
v8.Fired("New Stats"):Connect(function(p8, p9)
	ProcessChanges(p9 or l__Players__3.LocalPlayer, p8);
end);
game.Players.PlayerAdded:Connect(function(p10)
	task.spawn(v1.FetchPlayer, p10);
end);
game.Players.PlayerRemoving:Connect(function(p11)
	if u2[p11] then
		task.delay(5, function()
			u2[p11] = nil;
			v7.Fire("Stats Removed", p11);
		end);
	end;
end);
for v54, v55 in ipairs(l__Players__3:GetPlayers()) do
	task.spawn(v1.FetchPlayer, v55);
end;
return v1;
