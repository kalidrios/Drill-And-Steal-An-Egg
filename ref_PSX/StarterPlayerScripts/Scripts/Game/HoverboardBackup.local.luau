-- https://github.com/kalidrios

local t_Q = Enum.KeyCode.Q;
local table1 = {
	[1] = 57.5,
	[2] = 75,
	[3] = 90
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Hoverboard = m_Library.GUI.Main.Tools.Hoverboard;
local _ = m_Library.Directory.Gamepasses.Hoverboard.ID;
local bool1 = false;
local u1 = nil;
function Create(p1) -- Line: 32
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = table1
	--]]
	local u2 = m_Library.Player.Character(p1);
	local u3 = m_Library.Player.PrimaryPart(p1);
	local u4 = m_Library.Player.Humanoid(p1);
	local u5 = p1 == m_Library.LocalPlayer;
	local function Check() -- Line: 36
		--[[
			Upvalues:
				[1] = m_Library
				[2] = u2
				[3] = u3
				[4] = u4
		--]]
		return not m_Library.Variables.LoadingWorld and u2 and u3 and u4.Health > 0;
	end
	if m_Library.Variables.LoadingWorld or not u2 or not u3 or u4.Health <= 0 then return end
	local v1 = m_Library.Save.Get(p1);
	if not v1 then return end
	local t_EquippedHoverboard = v1.EquippedHoverboard;
	local u6 = m_Library.Directory.Hoverboards[t_EquippedHoverboard];
	if t_EquippedHoverboard == "" or not u6 then return end
	if u2:FindFirstChild("__HOVERBOARD") then
		Remove(p1);
	end
	local Clone_ret = u6.board:Clone();
	local u7 = u4.HipHeight + u3.Size.Y / 2;
	local t_Y = Clone_ret:FindFirstChild("Center").Position.Y;
	Clone_ret.CFrame = u3.CFrame * CFrame.Angles(0, 1.5707963267948966, 0) - Vector3.new(0, u7, 0) - Vector3.new(0, t_Y, 0);
	Clone_ret.CanCollide = false;
	Clone_ret.Name = "__HOVERBOARD";
	Clone_ret.Parent = u2;
	local _ = m_Library.Functions.Weld(u3, Clone_ret);
	local Sparkles = Clone_ret.Back:FindFirstChild("Sparkles");
	local Running = m_Library.Player.PrimaryPart(p1):FindFirstChild("Running");
	local t_Volume = nil;
	if Running then
		t_Volume = Running.Volume;
		Running.Volume = 0;
	end
	local BodyPosition = nil;
	local BodyGyro = nil;
	local u8 = 600;
	local tick_ret = tick();
	if u5 then
		BodyPosition = Instance.new("BodyPosition");
		BodyPosition.MaxForce = Vector3.new(0, math.huge, 0);
		BodyPosition.Position = Clone_ret.Position;
		BodyPosition.D = u8;
		BodyPosition.Parent = Clone_ret;
		BodyGyro = Instance.new("BodyGyro");
		BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge);
		BodyGyro.CFrame = CFrame.Angles(0, -1.5707963267948966, 0);
		BodyGyro.Parent = Clone_ret;
	end
	local Clone_ret2 = m_Library.Assets.Particles:FindFirstChild("Hoverboard Spawn"):Clone();
	Clone_ret2.Parent = Clone_ret.Center;
	Clone_ret2:Emit(10);
	m_Library.Audio.Play(u6.sounds.equip, Clone_ret, 1, 0.5);
	local u9 = m_Library.Audio.Play(u6.sounds.idle, Clone_ret, 1, 0.1, nil, nil, true);
	if u5 then
		u1 = m_Library.Functions.Animation(3510226236, u4);
	end
	local function PerformRays() -- Line: 113
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = u3
				[3] = u7
		--]]
		local v5 = Clone_ret.Size.X / 2;
		local v6 = Clone_ret.Size.Z / 2;
		local v7 = nil;
		for index1 = 1, 5 do
			local Ray_new_ret = Ray.new(u3.CFrame.p + (index1 == 1 and Vector3.new(-v5, 0, v6) or index1 == 2 and Vector3.new(v5, 0, -v6) or index1 == 3 and Vector3.new(v5, 0, v6) or index1 == 4 and Vector3.new(-v5, 0, -v6) or Vector3.new(0, 0, 0)), (Vector3.new(0, -(u7 + 3), 0)));
			local FindPartOnRayWithWhitelist_ret1, FindPartOnRayWithWhitelist_ret2 = game.Workspace:FindPartOnRayWithWhitelist(Ray_new_ret, {game.Workspace.__MAP});
			if FindPartOnRayWithWhitelist_ret1 and FindPartOnRayWithWhitelist_ret2 and (not v7 or FindPartOnRayWithWhitelist_ret2.Y > v7.Y) then
				v7 = FindPartOnRayWithWhitelist_ret2;
			end
		end
		return v7;
	end
	local os_clock_ret = os.clock();
	local u11 = 0;
	local u12 = 0;
	local u13 = table1[u6.speed];
	local function RangeMap(p11, p12, p13, p14, p15) -- Line: 153
		return (p11 - p12) / (p13 - p12) * (p15 - p14) + p14;
	end
	local function HoverboardCalculation(_) -- Line: 157
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = m_Library
				[3] = u2
				[4] = u3
				[5] = u4
				[6] = Running
				[7] = t_Volume
				[8] = p1
				[9] = u5
				[10] = os_clock_ret
				[11] = PerformRays
				[12] = u12
				[13] = BodyPosition
				[14] = u8
				[15] = u8
				[16] = tick_ret
				[17] = BodyGyro
				[18] = u11
				[19] = u6
				[20] = u13
				[21] = u9
				[22] = Sparkles
		--]]
		if not Clone_ret or not Clone_ret.Parent or m_Library.Variables.LoadingWorld or not u2 or not u3 or u4.Health <= 0 then
			if Running then
				Running.Volume = t_Volume;
			end
			pcall(function() -- Line: 162
				--[[
					Upvalues:
						[1] = m_Library
						[2] = p1
				--]]
				m_Library.RunService:UnbindFromRenderStep("Hoverboard " .. p1.Name);
			end);
			return;
		end
		if u5 then
			u4.PlatformStand = true;
			local v8 = math.sin((os.clock() - os_clock_ret) * 3) / 2 - 0.5;
			local v9 = PerformRays();
			local v10 = v9 ~= nil;
			local v11 = v10 and v9.Y + 3 or Clone_ret.Position.Y - u12;
			u12 = v10 and 0 or math.clamp(u12 * 1.065, 2, 10);
			local v12 = v11 + v8;
			if v12 - BodyPosition.Position.Y > 0.05 and u8 ~= 360 then
				u8 = BodyPosition.D;
				u8 = 360;
				tick_ret = tick();
			elseif v12 - BodyPosition.Position.Y < 0.05 and u8 ~= 1400 then
				u8 = BodyPosition.D;
				u8 = 1400;
				tick_ret = tick();
			end
			if BodyPosition.D ~= u8 then
				local v16 = BodyPosition;
				local math_clamp_ret = math.clamp(tick() - tick_ret, 0, 0.2);
				local v17 = u8;
				v16.D = (math_clamp_ret - 0) / 0.2 * (u8 - v17) + v17;
			end
			BodyPosition.Position = Vector3.new(0, v11 + v8, 0);
			local v13 = u3.Position + u4.MoveDirection;
			if v13 ~= u3.Position then
				BodyGyro.CFrame = CFrame.new(u3.Position, v13) * CFrame.Angles(0, 1.5707963267948966, 0);
			end
			if u4.Jump and v10 and os.clock() - u11 >= 1 then
				u11 = os.clock();
				m_Library.Audio.Play(u6.sounds.jump, Clone_ret, 1.25, 0.4);
			end
			local v14 = os.clock() - u11 <= 0.3 and (1 - math.clamp((os.clock() - u11) / 0.3, 0, 1) ^ 2) * 7000 or 0;
			local v15 = u4.MoveDirection * u13;
			local vec3 = Vector3.new(v15.X, -v14, v15.Z);
			u3.Velocity = u3.Velocity:Lerp(vec3, 0.035);
		end
		local t_Magnitude = u3.Velocity.Magnitude;
		u9.Pitch = math.clamp(t_Magnitude / u13 + 1, 1, 2);
		Sparkles.Enabled = t_Magnitude > 8;
	end
	m_Library.RunService:BindToRenderStep("Hoverboard " .. p1.Name, Enum.RenderPriority.Character.Value + 1, HoverboardCalculation);
end
function Remove(p2) -- Line: 247
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local v3 = m_Library.Player.Character(p2);
	local __HOVERBOARD = v3:FindFirstChild("__HOVERBOARD");
	if __HOVERBOARD then
		__HOVERBOARD:Destroy();
	end
	if p2 == m_Library.LocalPlayer then
		if u1 then
			u1:Stop();
		end
		m_Library.Player.PrimaryPart().Velocity = Vector3.new();
		m_Library.Player.Humanoid().PlatformStand = false;
		m_Library.RunService:UnbindFromRenderStep("Hoverboard " .. p2.Name);
	end
end
function UpdateButton() -- Line: 268
	--[[
		Upvalues:
			[1] = t_Hoverboard
			[2] = m_Library
	--]]
	t_Hoverboard.Keybind.Visible = not m_Library.Variables.Mobile;
	t_Hoverboard.Keybind.Desktop.Visible = m_Library.Variables.Desktop;
	t_Hoverboard.Keybind.Xbox.Visible = m_Library.Variables.Console;
	t_Hoverboard.BackgroundColor3 = m_Library.Variables.UsingHoverboard and Color3.fromRGB(252, 209, 59) or Color3.fromRGB(39, 233, 55);
end
function Toggle() -- Line: 280
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Variables.UsingHoverboard = not m_Library.Variables.UsingHoverboard;
	if not m_Library.Variables.UsingHoverboard then
		Remove(m_Library.LocalPlayer);
	else
		Create(m_Library.LocalPlayer);
	end
	UpdateButton();
	m_Library.Signal.Fire("Toggled Hoverboard", m_Library.Variables.UsingHoverboard);
	m_Library.Network.Fire("Update Hoverboard State", m_Library.Variables.UsingHoverboard);
end
function CanUseHoverboard() -- Line: 296
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	return m_Library.Save.Get().EquippedHoverboard ~= "";
end
function ProcessInput(_) -- Line: 304
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if CanUseHoverboard() and m_Library.WorldCmds.CanDoAction() then
		Toggle();
	end
	m_Library.Variables.HoverboardMenuActive = m_Library.Variables.UsingHoverboard or not m_Library.Variables.HoverboardMenuActive;
	m_Library.Signal.Fire("Toggled Hoverboard Menu");
end
m_Library.GUIFX.Tooltip(t_Hoverboard, "Hoverboard");
m_Library.GUIFX.ButtonFX(t_Hoverboard);
t_Hoverboard.Activated:Connect(function() -- Line: 326
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		ProcessInput();
		bool1 = false;
	end
end);
UpdateButton();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 337
	if p3 == "Gamepasses" then
		UpdateButton();
	end
end);
m_Library.Signal.Fired("Changed Platform"):Connect(function() -- Line: 343
	UpdateButton();
end);
m_Library.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) -- Line: 352
	--[[
		Upvalues:
			[1] = t_Q
			[2] = bool1
	--]]
	if not gameProcessedEvent and (input.KeyCode == t_Q or input.KeyCode == Enum.KeyCode.DPadUp) and not bool1 then
		bool1 = true;
		ProcessInput(true);
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Entered Cannon"):Connect(function() -- Line: 364
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if m_Library.Variables.UsingHoverboard then
		Toggle();
	end
end);
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 371
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if m_Library.Variables.UsingHoverboard then
		Toggle();
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p4) -- Line: 378
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if p4 == "EquippedHoverboard" and m_Library.Variables.UsingHoverboard then
		Create(m_Library.LocalPlayer);
	end
end);
m_Library.Signal.Fired("Other Stat Changed"):Connect(function(p5, p6) -- Line: 385
	if p6 == "EquippedHoverboard" and p5:GetAttribute("UsingHoverboard") then
		Create(p5);
	end
end);
function UpdatePlayer(p7, p8) -- Line: 397
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v4 = m_Library.Player.Character(p7);
	if p8 and not v4:FindFirstChild("__HOVERBOARD") then
		Create(p7);
		return;
	end
	if not p8 and v4:FindFirstChild("__HOVERBOARD") then
		Remove(p7);
	end
end
function TrackPlayer(p9) -- Line: 407
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Attribute = p9:GetAttribute("UsingHoverboard");
	if Attribute then
		while m_Library.Variables.LoadingWorld do
			m_Library.Heartbeat();
		end
		UpdatePlayer(p9, true);
	end
	p9:GetAttributeChangedSignal("UsingHoverboard"):Connect(function() -- Line: 415
		--[[
			Upvalues:
				[1] = p9
		--]]
		local Attribute2 = p9:GetAttribute("UsingHoverboard");
		UpdatePlayer(p9, Attribute2);
	end);
end
game.Players.PlayerAdded:Connect(function(p10) -- Line: 422
	TrackPlayer(p10);
end);
for _, val1 in ipairs(game.Players:GetPlayers()) do
	TrackPlayer(val1);
end
