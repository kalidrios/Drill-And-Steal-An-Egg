local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local table1 = {
	Color3.fromRGB(255, 49, 49),
	Color3.fromRGB(255, 179, 55),
	Color3.fromRGB(255, 255, 53),
	Color3.fromRGB(105, 255, 79),
	Color3.fromRGB(70, 252, 255),
	Color3.fromRGB(193, 85, 255),
	Color3.fromRGB(255, 169, 225)
};
local bool1 = false;
local t_FireworkLauncher = m_Library.GUI.FireworkLauncher;
local t_Close = t_FireworkLauncher.Close;
local t_FireworkProjectile = m_Library.Assets.Models.FireworkProjectile;
local t_FireworkLauncher2 = m_Library.Assets.Models.FireworkLauncher;
local _ = {};
local table2 = {};
local table3 = {
	fpsOffset = CFrame.new(1.5, -1, -3),
	fpsRot = CFrame.Angles(0, 3.141592653589793, 0),
	lao = CFrame.new(0.5, -1.5, -2),
	lar = CFrame.Angles(1.5707963267948966, -0.17453292519943295, 0.5235987755982988),
	rao = CFrame.new(2.5, -2, -2),
	rar = CFrame.Angles(1.5707963267948966, -0.5235987755982988, 0),
	rotx = -1.5707963267948966,
	roty = 3.141592653589793,
	rotz = -1.5707963267948966,
	offset = CFrame.new(-0.5, -0.6, 0.2)
};
local Mouse = game.Players.LocalPlayer:GetMouse();
function createProjectile(p1, p2, p3, p4, p5)  
	if p1 == m_Library.LocalPlayer then
		m_Library.Network.Fire("FireworkLauncher_FireProjectile", p2, p3, p4, p5);
	end
	m_Library.Audio.Play(4537511307, p2, nil);
	local u1 = m_Library.Functions.GenerateUID();
	local Clone_ret = t_FireworkProjectile:Clone();
	Clone_ret.Anchored = true;
	Clone_ret.Position = p2;
	Clone_ret.Parent = workspace.__DEBRIS;
	Clone_ret.CFrame = CFrame.new(p2.X, p2.Y, p2.Z);
	Clone_ret.CanCollide = false;
	local u2 = table1[Random_new_ret:NextInteger(1, #table1)];
	local Clone_ret2 = m_Library.Assets.Particles.Achievements:FindFirstChild("SuperFirework-Trail"):Clone();
	Clone_ret2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, u2),
		ColorSequenceKeypoint.new(1, u2)
	});
	Clone_ret2.Parent = Clone_ret;
	local u3 = p5 * math.tan(p4) > 600 and 600 / (p5 * math.tan(p4)) or 1;
	local function getCFrame(p16)  
		local v7 = p2.X + math.cos(p3) * p5 * p16 * u3;
		local v8 = p2.Z + math.sin(p3) * p5 * p16 * u3;
		local vec3 = Vector3.new(v7, p2.Y + (p5 * math.tan(p4) * p16 - math.pow(p16, 2) * 28.099999999999994) * u3, v8);
		return CFrame.new(vec3, vec3 + (vec3 - Clone_ret.CFrame.p)) * CFrame.Angles(0, math.pi / 2, 0);
	end
	local tick_ret = nil;
	local v1 = getCFrame(0.0001);
	local t_LookVector = CFrame.new(Clone_ret.CFrame.Position, v1.Position).LookVector;
	Clone_ret.CFrame = CFrame.new(Clone_ret.CFrame.Position + t_LookVector * (Clone_ret.Size.X / 2), v1.Position + t_LookVector * (Clone_ret.Size.X / 2)) * CFrame.Angles(0, 1.5707963267948966, 0);
	p2 = Clone_ret.CFrame.Position;
	m_Library.Services.RunService:BindToRenderStep("Projectile" .. u1, 1, function() 
		if not tick_ret then
			tick_ret = tick();
		end
		local t_Position = Clone_ret.CFrame.Position;
		Clone_ret.CFrame = getCFrame(tick() - tick_ret);
		local Ray_new_ret = Ray.new(Clone_ret.CFrame.Position, (t_Position - Clone_ret.CFrame.Position).Magnitude * CFrame.new(t_Position, Clone_ret.CFrame.Position).LookVector);
		local table4 = {workspace.__DEBRIS};
		if p1.Character then
			table.insert(table4, p1.Character);
		end
		local FindPartOnRayWithIgnoreList_ret1, FindPartOnRayWithIgnoreList_ret2 = workspace:FindPartOnRayWithIgnoreList(Ray_new_ret, table4);
		if FindPartOnRayWithIgnoreList_ret1 or tick() - tick_ret > 10 then
			m_Library.Services.RunService:UnbindFromRenderStep("Projectile" .. u1);
			local v10 = FindPartOnRayWithIgnoreList_ret2 or Clone_ret.CFrame.Position;
			local firework = Instance.new("Part");
			firework.CanCollide = false;
			firework.Anchored = true;
			firework.CFrame = CFrame.new(v10);
			firework.Size = Vector3.new();
			firework.Name = "firework";
			firework.Parent = m_Library.Debris;
			local Clone_ret3 = m_Library.Assets.Particles.Achievements:FindFirstChild("SuperFirework"):Clone();
			Clone_ret3.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, u2),
				ColorSequenceKeypoint.new(1, u2)
			});
			Clone_ret3.Parent = firework;
			Clone_ret3:Emit(250);
			m_Library.Audio.Play("rbxassetid://11981238658", firework, 1, 1.2, 250);
			m_Library.Functions.AddDebris(firework, 4);
			local FindFirstChild_ret = Clone_ret:FindFirstChild("SuperFirework-Trail");
			if FindFirstChild_ret then
				FindFirstChild_ret.Enabled = false;
			end
			m_Library.Functions.AddDebris(Clone_ret, 1);
			if m_Library.Functions.VerifyPlayerMagnitude(m_Library.LocalPlayer, v10, 200) then
				local table5 = {
					10231636855,
					10231636725,
					10231636318
				};
				m_Library.Audio.Play(table5[math.random(#table5)], v10, nil, 0.35);
			end
			if FindPartOnRayWithIgnoreList_ret1 then
				local FindFirstAncestorOfClass_ret = FindPartOnRayWithIgnoreList_ret1:FindFirstAncestorOfClass("Model");
				if FindFirstAncestorOfClass_ret then
					local PlayerFromCharacter = m_Library.Players:GetPlayerFromCharacter(FindFirstAncestorOfClass_ret);
					if PlayerFromCharacter and PlayerFromCharacter ~= p1 then
						local _ = FindFirstAncestorOfClass_ret.PrimaryPart;
						local Highlight = Instance.new("Highlight");
						Highlight.Adornee = FindFirstAncestorOfClass_ret;
						Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
						Highlight.FillColor = Color3.new(1, 0, 0);
						Highlight.FillTransparency = 0.5;
						Highlight.OutlineTransparency = 1;
						Highlight.Parent = FindFirstAncestorOfClass_ret;
						m_Library.Functions.Tween(Highlight, {FillTransparency = 1}, {
							0.25,
							"Cubic",
							"In"
						});
						m_Library.Functions.AddDebris(Highlight, 0.25);
					end
				end
			end
		end
	end);
end
function disableUpperBody(_)  
end
function enableUpperBody(_)  
end
function getWeaponState(p6)  
	return table2[p6 or m_Library.LocalPlayer];
end
function fireWeapon()  
	local WeaponState = getWeaponState();
	if not WeaponState then return end
	if WeaponState.lastShot and tick() - WeaponState.lastShot < 0.35 then return end
	WeaponState.lastShot = tick();
	if WeaponState.gyro then
		WeaponState.gyro.P = 100000;
		task.spawn(function()  
			task.wait(0.2);
			if WeaponState.gyro and WeaponState.gyro.P == 100000 then
				WeaponState.gyro.P = 400;
			end
		end);
	end
	task.spawn(function()   
		local t_part = WeaponState.part;
		if not t_part:FindFirstChild("TipAttachment") then return end
		Mouse.TargetFilter = workspace.__DEBRIS;
		local t_WorldPosition = t_part.TipAttachment.WorldPosition;
		local t_p = Mouse.Hit.p;
		local vec2 = Vector2.new(t_p.X, t_p.Z);
		local vec2_2 = Vector2.new(t_WorldPosition.X, t_WorldPosition.Z);
		local v9 = vec2 - vec2_2;
		local math_atan2_ret = math.atan2(v9.Y, v9.X);
		local math_atan_ret = math.atan((t_p.Y - t_WorldPosition.Y) / (vec2 - vec2_2).Magnitude);
		createProjectile(m_Library.LocalPlayer, t_WorldPosition, math_atan2_ret, math_atan_ret, 200);
	end);
end
function unequipWeapon(p7)  
	if not table2[p7] then return end
	local v2 = table2[p7];
	if p7 == m_Library.LocalPlayer then
		t_FireworkLauncher.Gui.Enabled = false;
	end
	enableUpperBody(p7);
	m_Library.Services.RunService:UnbindFromRenderStep("FireworkLauncher" .. v2.uid);
	if v2.weld then
		v2.weld:Destroy();
	end
	if v2.gyro then
		v2.gyro:Destroy();
	end
	v2.part:Destroy();
	for _, val1 in pairs(v2.cframeValues) do
		val1:Destroy();
	end
	local v3 = m_Library.Player.RightShoulder(p7);
	local v4 = m_Library.Player.LeftShoulder(p7);
	v3.C0 = v2.originalRightShoulder;
	v4.C0 = v2.originalLeftShoulder;
	m_Library.Network.Fire("FireworkLauncher_UnequipServer", p7)
	table2[p7] = nil;
end
function equipWeapon(p8) 
	if getWeaponState(p8) then return end
	if p8 == game.Players.LocalPlayer and not p8:GetAttribute("FireworkLauncher") then return end
	local u5 = p8 == m_Library.LocalPlayer;
	local v5 = m_Library.Functions.GenerateUID();
	local Clone_ret4 = t_FireworkLauncher2:Clone();
	Clone_ret4.Parent = workspace.__DEBRIS;
	Clone_ret4.Name = "WEAPON_" .. p8.Name;
	local table6 = {
		uid = v5,
		part = Clone_ret4,
		character = m_Library.Player.Character(p8),
		isEquipped = true,
		lastShot = nil,
		weld = nil,
		gyro = nil,
		cframeValues = {}
	};
	table2[p8] = table6;
	if u5 then
		t_Close.Activated:Connect(function()  
			unequipWeapon(m_Library.LocalPlayer);
		end);
		t_FireworkLauncher.Gui.Enabled = true;
	end
	local function make3rdPersonWeld()  
		local Weld = Instance.new("Weld");
		Weld.Part0 = Clone_ret4;
		Weld.Part1 = m_Library.Player.RightHand(p8);
		Weld.Parent = Clone_ret4;
		Weld.C0 = table3.offset * CFrame.Angles(table3.rotx, table3.roty, table3.rotz);
		table6.weld = Weld;
	end
	local u6 = m_Library.Player.PrimaryPart(p8);
	local _ = Clone_ret4.CFrame;
	if u5 then
		m_Library.Network.Fire("FireworkLauncher_Equip");
		local BodyGyro = Instance.new("BodyGyro", m_Library.Player.PrimaryPart());
		BodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000000;
		BodyGyro.P = 400;
		table6.gyro = BodyGyro;
	end
	m_Library.Audio.Play(10231636563, u6.Position);
	local u7 = m_Library.Player.RightShoulder(p8);
	local u8 = m_Library.Player.LeftShoulder(p8);
	local CFrameValue = Instance.new("CFrameValue");
	local CFrameValue2 = Instance.new("CFrameValue");
	CFrameValue.Value = table3.lao;
	CFrameValue2.Value = table3.lar;
	local CFrameValue3 = Instance.new("CFrameValue");
	local CFrameValue4 = Instance.new("CFrameValue");
	CFrameValue3.Value = table3.rao;
	CFrameValue4.Value = table3.rar;
	local CFrameValue5 = Instance.new("CFrameValue");
	local CFrameValue6 = Instance.new("CFrameValue");
	CFrameValue5.Value = table3.fpsOffset;
	CFrameValue6.Value = table3.fpsRot;
	table6.cframeValues.leftOffset = CFrameValue;
	table6.cframeValues.leftRot = CFrameValue2;
	table6.cframeValues.rightOffset = CFrameValue3;
	table6.cframeValues.rightRot = CFrameValue4;
	table6.cframeValues.weaponOffset = CFrameValue5;
	table6.cframeValues.weaponRot = CFrameValue6;
	table6.originalRightShoulder = u7.C0;
	table6.originalLeftShoulder = u8.C0;
	disableUpperBody(p8);
	local Weld2 = Instance.new("Weld");
	Weld2.Part0 = Clone_ret4;
	Weld2.Part1 = m_Library.Player.RightHand(p8);
	Weld2.Parent = Clone_ret4;
	Weld2.C0 = table3.offset * CFrame.Angles(table3.rotx, table3.roty, table3.rotz);
	table6.weld = Weld2;
	m_Library.Services.RunService:BindToRenderStep("FireworkLauncher" .. v5, 1, function()  
		m_Library.Services.UserInputService.MouseIconEnabled = true;
		local t_weld = table6.weld;
		t_weld.C0 = table3.offset * CFrame.Angles(table3.rotx, table3.roty, table3.rotz);
		u7.C0 = CFrame.new(0.5, 0.5, 0.8) * CFrame.Angles(1.5707963267948966, 0, -0.2617993877991494);
		u8.C0 = CFrame.new(-0.8, 0.5, 0) * CFrame.Angles(1.5707963267948966, 0, 1.0471975511965976);
		if u5 then
			local vec3_2 = Vector3.new(Mouse.Hit.p.X, u6.Position.Y, Mouse.Hit.p.Z);
			local t_gyro = table6.gyro;
			t_gyro.CFrame = CFrame.new(u6.Position, vec3_2);
		end
	end);
end
function initializeOtherPlayers()  
	local v6 = m_Library.Network.Invoke("FireworkLauncher_GetPlayersEquipped");
	for key2, _ in pairs(v6) do
		local PlayerByUserId = game.Players:GetPlayerByUserId(key2);
		if not PlayerByUserId or m_Library.Players.Get() == PlayerByUserId then continue end
		equipWeapon(PlayerByUserId);
	end
end
function animateTargetHit(_, _)   
end
function allTargetsHit()  
end
function shootingLoop()  
	while true do
		m_Library.RenderStepped();
		while not bool1 do
			m_Library.RenderStepped();
		end
		local WeaponState2 = getWeaponState();
		if WeaponState2 and WeaponState2.isEquipped and (not WeaponState2.lastShot or tick() - WeaponState2.lastShot > 0.35) then
			fireWeapon();
		end
	end
end
m_Library.Network.Fired("FireworkLauncher_OtherPlayerFiredProjectile"):Connect(function(p9, p10, p11, p12, p13) 
	createProjectile(p9, p10, p11, p12, p13);
end);
m_Library.Signal.Fired("FireworkLauncher_Equip"):Connect(function()  
	equipWeapon(m_Library.LocalPlayer);
end);
m_Library.Network.Fired("FireworkLauncher_Equip"):Connect(function(p14)  
	equipWeapon(p14);
end);
m_Library.Signal.Fired("FireworkLauncher_Unequip"):Connect(function()  
	unequipWeapon(m_Library.LocalPlayer);
end);
m_Library.Network.Fired("FireworkLauncher_Unequip"):Connect(function(p15)  
	unequipWeapon(p15);
end);
m_Library.Signal.Invoked("FireworkLauncher_IsEquipped").OnInvoke = function()  
	return getWeaponState(m_Library.LocalPlayer) ~= nil;
end
m_Library.Network.Fired("FireworkLauncher_HackyEquip"):Connect(function()  
	if m_Library.Signal.Invoke("FireworkLauncher_IsEquipped") then
		m_Library.Signal.Fire("FireworkLauncher_Unequip");
		return;
	end
	m_Library.Signal.Fire("FireworkLauncher_Equip");
end);
m_Library.Services.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)  
	if gameProcessedEvent then return end
	local WeaponState3 = getWeaponState();
	if not WeaponState3 then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.ButtonR2 then
		bool1 = true;
	end
end);
m_Library.Services.UserInputService.InputEnded:Connect(function(input2, gameProcessedEvent2)  
	if gameProcessedEvent2 then return end
	if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch or input2.KeyCode == Enum.KeyCode.ButtonR2 then
		bool1 = false;
	end
end);
task.spawn(initializeOtherPlayers);
task.spawn(shootingLoop);
game.Players.PlayerRemoving:Connect(unequipWeapon);
