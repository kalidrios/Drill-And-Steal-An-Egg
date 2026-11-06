-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local u2 = nil;
local table1 = {};
local table2 = {};
local table3 = {
	[1] = {
		Vector3.new(0, 7.864, 0),
		Vector3.new(0, 7.864, 0),
		Vector3.new(0, -17.136, 0)
	},
	[2] = {
		Vector3.new(0, 95.358, 0),
		Vector3.new(0, 70.533, 0),
		Vector3.new(0, 70.414, 0)
	},
	[3] = {
		Vector3.new(0, 88.708, 0),
		Vector3.new(0, 112.024, 0),
		Vector3.new(0, 112.024, 0)
	},
	[4] = {
		Vector3.new(0, 177.976, 0),
		Vector3.new(0, -158.024, 0),
		Vector3.new(0, -158.024, 0)
	}
};
function Reset() -- Line: 33
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table2
	--]]
	m_Library.Signal.Fire("Notification", "Kawaii Alley Minigame has reset!", {
		color = Color3.fromRGB(255, 46, 46),
		force = true,
		world = "Kawaii"
	});
	table2 = {};
	Teleport();
end
function Update() -- Line: 39
	--[[
		Upvalues:
			[1] = u2
			[2] = u1
	--]]
	if u2 == nil or u1 == nil then
		RequestData();
	end
	UpdateChests();
	UpdateWalls();
	for index1 = 1, u2.ALLEY_COUNT do
		UpdateSign(index1);
		UpdateEgg(index1);
	end
end
function UpdateChests() -- Line: 52
	--[[
		Upvalues:
			[1] = table2
	--]]
	for key1, val1 in pairs(table2) do
		UpdateChest(key1, val1);
	end
end
function UpdateEgg(p1) -- Line: 58
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then
		warn("Save wasn't loaded!");
		return;
	end
	assert(v1);
	if (m_Library.Shared.IsHardcore and v1.Hardcore.World or v1.World) ~= "Kawaii" then return end
	local v2 = m_Library.Network.Invoke("Kawaii Alley: Completed", p1);
	local Map = m_Library.WorldCmds.GetMap();
	local Eggs = Map:WaitForChild("Eggs");
	local WaitForChild_ret = Eggs:WaitForChild("Alley " .. p1);
	for _, descendant2 in ipairs(WaitForChild_ret:GetDescendants()) do
		if not descendant2:isA("BasePart") then continue end
		if not table1[descendant2] then
			table1[descendant2] = {
				CanCollide = descendant2.CanCollide,
				CanTouch = descendant2.CanTouch,
				CanQuery = descendant2.CanQuery
			};
		end
		descendant2.CanCollide = v2 and table1[descendant2].CanCollide or false;
		descendant2.CanTouch = v2 and table1[descendant2].CanTouch or false;
		descendant2.CanQuery = v2 and table1[descendant2].CanQuery or false;
	end
	local Eggs2 = WaitForChild_ret:FindFirstChild("Eggs");
	if not Eggs2 then
		warn("Eggs subfolder not loaded", p1);
		return;
	end
	local FindFirstChild_ret = Eggs2:FindFirstChild("Egg Capsule");
	if not FindFirstChild_ret then
		warn("Egg Capsule not loaded", p1);
		return;
	end
	FindFirstChild_ret:SetAttribute("Enabled", v2);
	local Attribute = FindFirstChild_ret:GetAttribute("ID");
	local PriceFrame = FindFirstChild_ret:FindFirstChild("PriceFrame");
	if PriceFrame then
		for _, child8 in pairs(PriceFrame:GetChildren()) do
			child8.Transparency = v2 and 0 or 1;
		end
	end
	for _, child3 in pairs(FindFirstChild_ret:GetChildren()) do
		if child3.Name == "PriceFrame" or child3.Name == "Center" or child3.Name == "PriceHUD" or child3.Name == "EggInfo" then continue end
		child3.Transparency = v2 and 0 or 1;
	end
	local PriceHUD = FindFirstChild_ret:FindFirstChild("PriceHUD");
	local EggCost = PriceHUD:FindFirstChild("EggCost");
	EggCost.Enabled = v2;
	local Egg = FindFirstChild_ret:FindFirstChild("Egg");
	local Sparkles = Egg:FindFirstChild("Sparkles");
	Sparkles.Enabled = v2;
	local BillboardGui = FindFirstChild_ret:FindFirstChild("Center"):FindFirstChild("BillboardGui");
	BillboardGui.Enabled = v2;
	local PLATFORM = WaitForChild_ret:FindFirstChild("PLATFORM");
	if PLATFORM then
		for _, child9 in pairs(PLATFORM:GetChildren()) do
			if child9.Name == "SectionName" then continue end
			child9.Transparency = v2 and 0 or 1;
		end
		local SectionName = PLATFORM:FindFirstChild("SectionName");
		local SurfaceGui = SectionName:FindFirstChild("SurfaceGui");
		SurfaceGui.Enabled = v2;
	end
	if v2 then
		local Timer = BillboardGui:FindFirstChild("Timer");
		local u3 = m_Library.Network.Invoke("Kawaii Alley: Get Reset Timestamp");
		local Connect_ret = nil;
		Connect_ret = m_Library.RunService.Heartbeat:Connect(function(_) -- Line: 163
			--[[
				Upvalues:
					[1] = BillboardGui
					[2] = Connect_ret
					[3] = u3
					[4] = Timer
					[5] = m_Library
			--]]
			if not BillboardGui or BillboardGui.Enabled == false then
				Connect_ret:Disconnect();
				return;
			end
			local v9 = u3 - workspace:GetServerTimeNow();
			if v9 <= 0 then
				Connect_ret:Disconnect();
				BillboardGui.Enabled = false;
				return;
			end
			Timer.Text = m_Library.Functions.FormatTime(v9);
		end);
		return;
	end
	local FindFirstChild_ret2 = m_Library.LocalPlayer.PlayerGui:FindFirstChild("__AUTOHATCH" .. Attribute);
	if FindFirstChild_ret2 then
		FindFirstChild_ret2:Destroy();
	end
end
function UpdateSign(p2) -- Line: 180
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
	--]]
	local __MAPDEBRIS = workspace:FindFirstChild("__DEBRIS"):FindFirstChild("__MAPDEBRIS");
	local Debris = __MAPDEBRIS:FindFirstChild("Debris");
	local FindFirstChild_ret3 = Debris:FindFirstChild("Alley Signs");
	if not FindFirstChild_ret3 then return end
	local v3 = m_Library.Network.Invoke("Kawaii Alley: Should Show Sign", p2);
	local FindFirstChild_ret4 = FindFirstChild_ret3:FindFirstChild(p2);
	if not FindFirstChild_ret4 then
		warn("Didn't load sign for alley", p2);
		return;
	end
	for _, descendant4 in ipairs(FindFirstChild_ret4:GetDescendants()) do
		if descendant4:isA("BasePart") then
			if not table1[descendant4] then
				table1[descendant4] = {
					CanCollide = descendant4.CanCollide,
					CanTouch = descendant4.CanTouch,
					CanQuery = descendant4.CanQuery,
					Transparency = descendant4.Transparency
				};
			end
			descendant4.CanCollide = v3 and table1[descendant4].CanCollide or false;
			descendant4.CanTouch = v3 and table1[descendant4].CanTouch or false;
			descendant4.CanQuery = v3 and table1[descendant4].CanQuery or false;
			descendant4.Transparency = v3 and table1[descendant4].Transparency or 1;
		end
		if not descendant4:isA("SurfaceGui") then continue end
		descendant4.Enabled = v3;
	end
	if v3 then
		m_Library.Audio.Play(4489274818, FindFirstChild_ret4:GetPrimaryPartCFrame().p, 1, 1, 400);
	end
end
function UpdateChest(p3, p4) -- Line: 223
	--[[
		Upvalues:
			[1] = u1
			[2] = table3
			[3] = m_Library
	--]]
	if not u1 then
		warn("No alley data!");
		return;
	end
	local ChestByCoinId = GetChestByCoinId(p3);
	if not ChestByCoinId then
		warn("No chest data!");
		return;
	end
	local v4 = u1.Status[ChestByCoinId.Alley];
	if table3[ChestByCoinId.Alley] and table3[ChestByCoinId.Alley][ChestByCoinId.Order] then
		local u4 = table3[ChestByCoinId.Alley][ChestByCoinId.Order];
		task.delay(1, function() -- Line: 239
			--[[
				Upvalues:
					[1] = p4
					[2] = u4
			--]]
			p4.Rotation = u4;
		end);
	end
	local v5 = v4 < ChestByCoinId.Order;
	p4:SetAttribute("PreventClick", v5);
	local ClickDetector = p4:FindFirstChild("ClickDetector");
	if ClickDetector then
		ClickDetector.MaxActivationDistance = v5 and 0 or m_Library.Settings.CoinGrabDistance;
	end
end
function UpdateWalls() -- Line: 253
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local __MAPDEBRIS2 = workspace:FindFirstChild("__DEBRIS"):FindFirstChild("__MAPDEBRIS");
	local Debris2 = __MAPDEBRIS2:FindFirstChild("Debris");
	local FindFirstChild_ret5 = Debris2:FindFirstChild("Alley Walls");
	if not FindFirstChild_ret5 then return end
	local v6, _ = m_Library.Network.Invoke("Kawaii Alley: Completed");
	for _, child5 in pairs(FindFirstChild_ret5:GetChildren()) do
		local t_Name = child5.Name;
		local string_split_ret = string.split(t_Name, " ");
		local v8 = u1.Status[tonumber(string_split_ret[1])] <= tonumber(string_split_ret[2]) and not v6;
		child5.PrimaryPart.CanCollide = v8;
		for _, descendant10 in ipairs(child5:GetDescendants()) do
			if descendant10.Name == "Barrier" or not descendant10:isA("BasePart") then continue end
			descendant10.Transparency = v8 and 0 or 1;
		end
	end
end
function RequestData() -- Line: 281
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = u2
	--]]
	local v7 = m_Library.Network.Invoke("Kawaii Alley: Get Data");
	if v7 and not u1 then
		u1 = v7;
	end
	if u2 == nil then
		u2 = m_Library.Network.Invoke("Kawaii Alley: Get Settings");
	end
end
function Teleport() -- Line: 291
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local __MAPDEBRIS3 = workspace:FindFirstChild("__DEBRIS"):FindFirstChild("__MAPDEBRIS");
	local Debris3 = __MAPDEBRIS3:FindFirstChild("Debris");
	local FindFirstChild_ret6 = Debris3:FindFirstChild("Alley Boxes");
	if not FindFirstChild_ret6 then return end
	for _, child6 in pairs(FindFirstChild_ret6:GetChildren()) do
		local PartsInPart = workspace:GetPartsInPart(child6);
		for _, val11 in pairs(PartsInPart) do
			if game.Players:GetPlayerFromCharacter(val11.Parent) ~= m_Library.LocalPlayer then continue end
			local FindFirstChild_ret7 = m_Library.WorldCmds.GetMap().Teleports:FindFirstChild("Kawaii Tokyo");
			if FindFirstChild_ret7 then
				local v10 = m_Library.Player.Character();
				local v11 = m_Library.Player.Humanoid();
				m_Library.GUIFX.Flash(0.25, 0.75, Color3.new(255, 255, 255));
				m_Library.Variables.Teleporting = true;
				m_Library.Signal.Fire("Teleporting");
				m_Library.Functions.Wait(0.25);
				v10:SetPrimaryPartCFrame(FindFirstChild_ret7.CFrame + Vector3.new(0, v11.HipHeight + 1, 0));
				m_Library.Audio.Play("rbxassetid://7210953148", script, 1, 1);
				m_Library.Network.Fire("Performed Teleport", "Kawaii Tokyo");
				m_Library.Functions.Wait(0.25);
				m_Library.Variables.Teleporting = false;
				return;
			end
			m_Library.Message.New("Something went wrong. Try again!");
			return;
		end
	end
end
function GetChestByCoinId(p5) -- Line: 329
	--[[
		Upvalues:
			[1] = u1
	--]]
	if not u1 then
		return nil;
	end
	local _ = u1.Status;
	for key7, val7 in pairs(u1.Chests) do
		if key7 ~= p5 then continue end
		return val7;
	end
	return nil;
end
m_Library.Network.Fired("Kawaii Alley: Progressed"):Connect(function(p6) -- Line: 346
	--[[
		Upvalues:
			[1] = u1
	--]]
	if not u1 then return end
	u1.Status = p6;
	Update();
end);
m_Library.Network.Fired("Kawaii Alley: Broadcast Data"):Connect(function(p7) -- Line: 354
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = m_Library
	--]]
	u1 = p7;
	if u2 == nil then
		u2 = m_Library.Network.Invoke("Kawaii Alley: Get Settings");
	end
	Update();
end);
m_Library.Network.Fired("Kawaii Alley: Reset"):Connect(Reset);
m_Library.Network.Fired("Kawaii Alley: Egg Found"):Connect(Update);
m_Library.Network.Fired("Kawaii Alley: Update Sign"):Connect(UpdateSign);
m_Library.Signal.Fired("Kawaii Alley: Setup Breakable"):Connect(function(p8, p9) -- Line: 368
	--[[
		Upvalues:
			[1] = table2
	--]]
	if not table2[p8] then
		table2[p8] = p9;
	end
	UpdateChests();
end);
m_Library.Signal.Fired("World Changed"):Connect(function(p10) -- Line: 375
	if p10 == "Kawaii" then
		task.defer(Update);
	end
end);
task.spawn(RequestData);
