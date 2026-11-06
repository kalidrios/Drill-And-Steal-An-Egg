-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Size = m_Library.Assets.Billboards.Cannon.Size;
local table1 = {};
local u1 = 0;
local bool1 = false;
function Fire(p1, p2) -- Line: 22
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
	--]]
	if not p1 then
		m_Library.Print("Cannon does not exist");
		return;
	end
	local v1 = p2 == m_Library.LocalPlayer;
	local v2 = m_Library.Player.Character(p2);
	local v3 = m_Library.Player.PrimaryPart(p2);
	local v4 = m_Library.Player.Humanoid(p2);
	if not v2 or not v3 or not v4 then
		m_Library.Print("Missing character - " .. p2.Name, true);
		return;
	end
	local t_Name = p1.Name;
	local v5 = table1[t_Name];
	if v5.using then
		m_Library.Print("Cannon is already active", true);
		return;
	end
	v5.using = true;
	local t_Name2 = p1.Name;
	if not m_Library.Directory.Worlds[t_Name2] then
		m_Library.Print("World '" .. t_Name2 .. "' doesn't exist", true);
		return;
	end
	p2:SetAttribute("UsingCannon", true);
	if v1 then
		m_Library.Network.Fire("Cannon Fire", m_Library.WorldCmds.Get(), t_Name);
		m_Library.Signal.Fire("Entered Cannon");
		m_Library.Variables.UsingCannon = true;
	else
		m_Library.Signal.Fire("Other Entered Cannon", p2);
	end
	m_Library.Audio.Play("rbxassetid://7480973873", p1, 1, 1, 200);
	local v6 = p1.CFrame * CFrame.new(0, -3.8, 6) * CFrame.Angles(0.5235987755982988, 0, 0.000017453292519943296);
	local DirectionNew = p1:FindFirstChild("DirectionNew");
	if DirectionNew then
		v6 = DirectionNew.WorldCFrame;
	end
	v3.Anchored = true;
	v2:SetPrimaryPartCFrame(v6);
	local v7 = p1.MeshId == "rbxassetid://9196465083";
	local v8 = p1.MeshId == "rbxassetid://12145516344";
	local v9 = p1.MeshId == "rbxassetid://12818763791";
	-- Skip Cannon Loaded model swap (portal disguise)
	local originalTransparency = p1.Transparency;
	local table2 = {};
	local table3 = {};
	for _, descendant1 in ipairs(v2:GetDescendants()) do
		if not descendant1:IsA("BasePart") then continue end
		local table4 = {};
		table2[descendant1] = table4;
		local table5 = {};
		table3[descendant1] = table5;
		local t_Transparency = descendant1.Transparency;
		if t_Transparency < 1 then
			table4.Transparency = t_Transparency;
			descendant1.Transparency = 1;
		end
		if not v8 then continue end
		local t_Size2 = descendant1.Size;
		table5.Size = t_Size2;
		descendant1.Size = Vector3.new(t_Size2.X, t_Size2.Y, 0.125);
	end
	m_Library.Functions.Wait(1);
	for key2, val2 in pairs(table2) do
		if not key2 then continue end
		for key5, val5 in pairs(val2) do
			key2[key5] = val5;
		end
	end
	m_Library.Audio.Play(3644843750, v1 and script or p1, 1, 1, 450);
	local v10 = p1:FindFirstChild("Particles");
	if not v10 then
		v10 = Instance.new("Attachment");
		assert(v10);
		v10.Position = Vector3.new(-0.057, 4.626, -10.26);
		v10.Orientation = Vector3.new(-0.001, 89.999, 30);
		v10.Parent = p1;
	end
	for _, child3 in ipairs(m_Library.Assets.Particles.Cannon:GetChildren()) do
		local Clone_ret2 = child3:Clone();
		Clone_ret2.Parent = v10;
		Clone_ret2:Emit(20);
	end
	local t_Magnitude = (p1.CFrame.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude;
	if t_Magnitude < 100 then
		local v13 = (1 - t_Magnitude / 100) * 1.5;
		m_Library.Shake.Create(v13, 0.75, 0.15);
	end
	p1.Transparency = originalTransparency;
	if v1 then
		local __MAPDEBRIS = m_Library.Debris:FindFirstChild("__MAPDEBRIS");
		if __MAPDEBRIS then
			__MAPDEBRIS:ClearAllChildren();
		end
		local v14 = m_Library.Functions.Animation(79595171552871, v4);
		v4.PlatformStand = true;
		v3.Anchored = false;
		v3.Velocity = v6.LookVector * 450;
		m_Library.Functions.Wait(0.3);
		m_Library.WorldCmds.Load(t_Name2);
		m_Library.Variables.UsingCannon = false;
		p2:SetAttribute("UsingCannon", false);
		v14:Stop();
		for key6, val6 in pairs(table3) do
			if not key6 then continue end
			for key7, val7 in pairs(val6) do
				key6[key7] = val7;
			end
		end
	else
		wait(5);
		v10:Destroy();
		v3.Anchored = false;
	end
	v5.using = false;
end
function ClientAttemptFire(p3) -- Line: 208
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_Name3 = p3.Name;
	if not m_Library.WorldCmds.CanDoAction() then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.Cannons) and not m_Library.FFlags.CanBypass(m_Library.LocalPlayer) then
		m_Library.Message.New("Sorry this is disabled right now! Please try back later");
		return;
	end
	local v11, v12 = m_Library.Network.Invoke("Request Cannon Launch", t_Name3);
	if v11 then
		Fire(p3, m_Library.LocalPlayer);
		return;
	end
	m_Library.Message.New(v12 or "You don't have access to this area!");
end
function Init(p4) -- Line: 232
	--[[
		Upvalues:
			[1] = u1
			[2] = table1
			[3] = m_Library
			[4] = bool1
			[5] = t_Size
	--]]
	local u2 = u1;
	local t_Name4 = p4.Name;
	table1[t_Name4] = {
		physical = p4,
		using = false,
		event = nil,
		eventCancel = nil
	};
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 244
		--[[
			Upvalues:
				[1] = u1
				[2] = u2
				[3] = table1
				[4] = t_Name4
				[5] = m_Library
				[6] = p4
				[7] = bool1
		--]]
		while u1 == u2 and table1[t_Name4] do
			debug.profilebegin("Cannons.Init.pt1");
			local v17 = table1[t_Name4];
			if v17.using then
				v17.event = nil;
				if v17.eventCancel then
					v17.eventCancel();
					v17.eventCancel = nil;
				end
			elseif not v17.event then
				local v19, v20 = m_Library.Interact.Add(p4.CFrame.Position, {dist = 25});
				v17.event = v19;
				v17.eventCancel = v20;
				v19:Connect(function() -- Line: 263
					--[[
						Upvalues:
							[1] = bool1
							[2] = p4
					--]]
					if not bool1 then
						bool1 = true;
						ClientAttemptFire(p4);
						bool1 = false;
					end
				end);
			end
			debug.profileend();
			wait(0.25);
		end
	end);
	coroutine_wrap_ret();
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 277
		--[[
			Upvalues:
				[1] = p4
				[2] = m_Library
				[3] = t_Size
				[4] = u1
				[5] = u2
				[6] = table1
				[7] = t_Name4
		--]]
		local bool2 = false;
		local function Show() -- Line: 281
			--[[
				Upvalues:
					[1] = p4
					[2] = m_Library
					[3] = t_Size
			--]]
			local v18 = m_Library.Directory.Worlds[p4.Name];
			local Clone_ret3 = m_Library.Assets.Billboards.Cannon:Clone();
			Clone_ret3.Frame.World.Text = v18.display;
			Clone_ret3.Frame.Currency.Image = m_Library.Directory.Currency[v18.mainCurrency].Image;
			Clone_ret3.Name = "%HUD";
			Clone_ret3.Parent = p4;
			Clone_ret3.Size = UDim2.new(0, 0, 0, 0);
			Clone_ret3.StudsOffset = Vector3.new();
			m_Library.Functions.Tween(Clone_ret3, {
				Size = t_Size,
				StudsOffset = Vector3.new(0, 12, 0)
			}, {
				0.2,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			});
		end
		local function Hide() -- Line: 297
			--[[
				Upvalues:
					[1] = p4
					[2] = m_Library
			--]]
			local FindFirstChild_ret = p4:FindFirstChild("%HUD");
			if FindFirstChild_ret then
				m_Library.Functions.Tween(FindFirstChild_ret, {
					Size = UDim2.new(0, 0, 0, 0),
					StudsOffset = Vector3.new(0, 4, 0)
				}, {
					0.15,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.In
				}).Completed:Connect(function() -- Line: 301
					--[[
						Upvalues:
							[1] = FindFirstChild_ret
					--]]
					FindFirstChild_ret:Destroy();
				end);
			end
		end
		while u1 == u2 and table1[t_Name4] do
			local _ = table1[t_Name4];
			local DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(p4.CFrame.Position);
			if not bool2 and DistanceFromCharacter_ret <= 35 then
				bool2 = true;
				Show();
			elseif bool2 and DistanceFromCharacter_ret > 35 then
				bool2 = false;
				Hide();
			end
			wait((math.clamp(DistanceFromCharacter_ret / 35, 0.1, 1)));
		end
	end);
	coroutine_wrap_ret2();
end
function GetCannonPhysical(p5) -- Line: 326
	local __MAP = game.Workspace:WaitForChild("__MAP");
	local Cannons = __MAP:WaitForChild("Cannons");
	return Cannons:FindFirstChild(p5);
end
function LoadWorld() -- Line: 333
	--[[
		Upvalues:
			[1] = u1
			[2] = table1
	--]]
	u1 = u1 + 1;
	table1 = {};
	local __MAP2 = game.Workspace:WaitForChild("__MAP");
	local Cannons2 = __MAP2:WaitForChild("Cannons");
	for _, child4 in ipairs(Cannons2:GetChildren()) do
		Init(child4);
	end
end
m_Library.Network.Fired("Cannon Fired"):Connect(function(p6, p7, p8) -- Line: 349
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if m_Library.WorldCmds.Get() == p7 and p6 ~= m_Library.LocalPlayer and m_Library.WorldCmds.HasLoaded() then
		local CannonPhysical = GetCannonPhysical(p8);
		Fire(CannonPhysical, p6);
	end
end);
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 357
	LoadWorld();
end);
