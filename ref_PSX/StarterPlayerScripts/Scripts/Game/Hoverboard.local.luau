-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local l__ID__2 = v1.Directory.Gamepasses.Hoverboard.ID;
local u1 = nil;
local u2 = { 71.875, 93.75, 112.5 };
local u3 = { 7, 12, 17 };
function Create(p1)
	local v3 = v1.Player.Character(p1);
	local v4 = p1 == v1.LocalPlayer;
	if not v3 then
		return;
	end;
	local u4 = v1.Player.PrimaryPart(p1);
	local u5 = v1.Player.Humanoid(p1);
	if not (not v1.Variables.LoadingWorld and (v3 and (u4 and 0 < u5.Health))) then
		return;
	end;
	local v5 = v1.Save.Get(p1);
	if not v5 then
		return;
	end;
	local l__EquippedHoverboard__6 = v5.EquippedHoverboard;
	local v7 = v1.Directory.Hoverboards[l__EquippedHoverboard__6];
	if l__EquippedHoverboard__6 ~= "" then
		if not v7 then
			return;
		end;
	else
		return;
	end;
	if v3:FindFirstChild("__HOVERBOARD") then
		Remove(p1);
	end;
	local v8 = v7.board:Clone();
	v8.Massless = true;
	v8.Anchored = false;
	v8.CanCollide = false;
	v8.CanQuery = true;
	v8.CanTouch = true;
	v8.AssemblyLinearVelocity = Vector3.new();
	v8.AssemblyAngularVelocity = Vector3.new();
	local v9 = u5.HipHeight + u4.Size.Y / -40
	local l__Center__10 = v8:WaitForChild("Center");
	v8.CFrame = u4.CFrame * CFrame.Angles(0, 1.5707963267948966, 0) - Vector3.new(0, v9, 0) - Vector3.new(0, l__Center__10.Position.Y, 0);
	v8.CanCollide = false;
	v8.Name = "__HOVERBOARD";
	v8.Parent = v3;
	local v11 = v1.Functions.Weld(u4, v8);
	local l__Sparkles__12 = v8.Back:FindFirstChild("Sparkles");
	local v13 = l__Sparkles__12:Clone();
	v13.Name = "SparklesJump";
	v13.Enabled = false;
	v13.Rate = v13.Rate * 5;
	v13.SpreadAngle = Vector2.new(-90, 90);
	v13.EmissionDirection = Enum.NormalId.Bottom;
	v13.Speed = NumberRange.new(5, 10);
	v13.Parent = l__Center__10;
	local l__Running__14 = v1.Player.PrimaryPart(p1):FindFirstChild("Running");
	local v15 = nil;
	if l__Running__14 then
		v15 = l__Running__14.Volume;
		l__Running__14.Volume = 0;
	end;
	local v16 = nil;
	local v17 = nil;
	local v18 = tick();
	if v4 then
		v16 = Instance.new("BodyPosition");
		v16.MaxForce = Vector3.new(0, math.huge, 0);
		v16.Position = v8.Position;
		v16.D = 600;
		v16.Parent = v8;
		v17 = Instance.new("BodyGyro");
		v17.MaxTorque = Vector3.new(math.huge, math.huge, math.huge);
		v17.CFrame = CFrame.Angles(0, -1.5707963267948966, 0);
		v17.Parent = v8;
	end;
	local v19 = v1.Assets.Particles:FindFirstChild("Hoverboard Spawn"):Clone();
	v19.Parent = v8.Center;
	v19:Emit(10);
	v1.Audio.Play(v7.sounds.equip, v8, 1, 0.5);
	local v20 = v1.Audio.Play(v7.sounds.idle, v8, 1, 0.1, nil, nil, true);
	if v4 then
		u1 = v1.Functions.Animation(90715434687021, u5);
	end;
	local u6 = os.clock();
	local function u7(p2)
		local v21 = v8.Size.X / 2 * 1;
		local v22 = v8.Size.Z / 2 * 1;
		local v23 = nil;
		for v24 = 1, 5 do
			local v25
			if v24 == 1 then
				v25 = Vector3.new(-v21, 0, v22);
			elseif v24 == 2 then
				v25 = Vector3.new(v21, 0, -v22);
			elseif v24 == 3 then
				v25 = Vector3.new(v21, 0, v22);
			elseif v24 == 4 then
				v25 = Vector3.new(-v21, 0, -v22);
			else
				v25 = Vector3.new(0, 0, 0);
			end;
			local v26, v27 = game.Workspace:FindPartOnRayWithWhitelist(Ray.new(u4.CFrame.p + v25, (Vector3.new(0, -(3.5 + v9 + 1 + p2), 0))), { game.Workspace.__MAP });
			if v26 then
				if v27 then
					if v23 then
						if v23.Y < v27.Y then
							v23 = v27;
						end;
					else
						v23 = v27;
					end;
				end;
			end;
		end	
		return v23;
	end;
	local u8 = 0;
	local u9 = 0;
	local u10 = 600;
	local u11 = 600;
	local u12 = v18;
	local u13 = u3[v7.speed];
	local u14 = u2[v7.speed];
	local l__Volume__15 = v20.Volume;
	v1.RunService:BindToRenderStep("Hoverboard " .. p1.Name, Enum.RenderPriority.Character.Value + 1, function(p3)
		if v8 then
			if v8.Parent then
				if not (not v1.Variables.LoadingWorld and (v3 and (u4 and 0 < u5.Health))) then

				elseif v4 then
					u5.PlatformStand = true;
					local v28 = math.sin((os.clock() - u6) * 3) * 0.5;
					local v29 = u7(v28);
					local v30 = v29 ~= nil;
					local v31
					if v30 then
						v31 = 0;
					else
						v31 = math.clamp(u8 * 1.065, 2, 10);
					end;
					u8 = v31;
					local v32 = os.clock() - u9 <= 0.6;
					local v33 = (v30 and v29.Y + 3.5 or v8.Position.Y - u8) + v28;
					if v32 then
						if u10 ~= 2000 then
							u11 = v16.D;
							u10 = 2000;
							u12 = tick();
						end;
					elseif -0.35 < v33 - v16.Position.Y then
						if u10 ~= 360 then
							u11 = v16.D;
							u10 = 360;
							u12 = tick();
						end;
					elseif v33 - v16.Position.Y <= -0.35 then
						if u10 ~= 1400 then
							u11 = v16.D;
							u10 = 1400;
							u12 = tick();
						end;
					end;
					if v16.D ~= u10 then
						v16.D = (math.clamp(tick() - u12, 0, 0.2) - 0) / 0.2 * (u10 - u11) + u11;
					end;
					v16.Position = Vector3.new(0, v33, 0);
					local v34 = u4.Position + u5.MoveDirection;
					if v34 ~= u4.Position then
						v17.CFrame = CFrame.new(u4.Position, v34) * CFrame.Angles(0, 1.5707963267948966, 0);
					end;
					if u5.Jump then
						if v30 then
							if 1 <= os.clock() - u9 then
								u9 = os.clock();
								v1.Audio.Play(v7.sounds.jump, v8, 1.25, 0.4);
							end;
						end;
					end;
					local v35 = 0;
					if os.clock() - u9 <= 0.3 then
						v35 = (1 - math.clamp((os.clock() - u9) / 0.3, 0, 1) ^ 2) * (1000 * u13);
					end;
					local v36 = u5.MoveDirection * u14;
					local v37 = Vector3.new(v36.X, -v35, v36.Z);
					local l__Magnitude__38 = u4.Velocity.Magnitude;
					l__Sparkles__12.Enabled = 8 < l__Magnitude__38;
					if os.clock() - u9 <= 0.3 then
						local v39 = math.sin(2 * math.pi * math.clamp((os.clock() - u9) / 0.3, 0, 1));
						v37 = v37 + v37 * Vector3.new(1, 0, 1) * (u13 / 10);
						v13.Enabled = true;
					else
						v20.Volume = l__Volume__15;
						v13.Enabled = false;
					end;
					u4.Velocity = u4.Velocity:Lerp(v37, 0.035);
					v20.Pitch = math.clamp(1 + l__Magnitude__38 / u14, 1, 2);
					return;
				else
					local l__Magnitude__40 = u4.Velocity.Magnitude;
					v20.Pitch = math.clamp(1 + l__Magnitude__40 / u14, 1, 2);
					l__Sparkles__12.Enabled = 8 < l__Magnitude__40;
					return;
				end;
			end;
		end;
		if l__Running__14 then
			l__Running__14.Volume = v15;
		end;
		pcall(function()
			v1.RunService:UnbindFromRenderStep("Hoverboard " .. p1.Name);
		end);
	end);
end;
function Remove(p4)
	local l____HOVERBOARD__41 = v1.Player.Character(p4):FindFirstChild("__HOVERBOARD");
	if l____HOVERBOARD__41 then
		l____HOVERBOARD__41:Destroy();
	end;
	if p4 == v1.LocalPlayer then
		if u1 then
			u1:Stop();
		end;
		v1.Player.PrimaryPart().Velocity = Vector3.new();
		v1.Player.Humanoid().PlatformStand = false;
		v1.RunService:UnbindFromRenderStep("Hoverboard " .. p4.Name);
	end;
end;
local l__Hoverboard__16 = v1.GUI.Main.Tools.Hoverboard;
function UpdateButton()
	l__Hoverboard__16.Keybind.Visible = not v1.Variables.Mobile;
	l__Hoverboard__16.Keybind.Desktop.Visible = v1.Variables.Desktop;
	l__Hoverboard__16.Keybind.Xbox.Visible = v1.Variables.Console;
	l__Hoverboard__16.BackgroundColor3 = v1.Variables.UsingHoverboard and Color3.fromRGB(252, 209, 59) or Color3.fromRGB(39, 233, 55);
end;
function Toggle()
	v1.Variables.UsingHoverboard = not v1.Variables.UsingHoverboard;
	UpdateButton();
	v1.Signal.Fire("Toggled Hoverboard", v1.Variables.UsingHoverboard);
	v1.Network.Fire("Update Hoverboard State", v1.Variables.UsingHoverboard);
	task.defer(function()
		if not v1.Variables.UsingHoverboard then
			Remove(v1.LocalPlayer);
			return;
		end;
		Create(v1.LocalPlayer);
	end);
end;
function CanUseHoverboard()
	return v1.Save.Get().EquippedHoverboard ~= "";
end;
function ProcessInput(p5)
	if CanUseHoverboard() then
		if v1.WorldCmds.CanDoAction() then
			Toggle();
		end;
	end;
	v1.Variables.HoverboardMenuActive = v1.Variables.UsingHoverboard or not v1.Variables.HoverboardMenuActive;
	v1.Signal.Fire("Toggled Hoverboard Menu");
end;
v1.GUIFX.Tooltip(l__Hoverboard__16, "Carpet");
v1.GUIFX.ButtonFX(l__Hoverboard__16);
local u17 = false;
l__Hoverboard__16.Activated:Connect(function()
	if not u17 then
		u17 = true;
		ProcessInput();
		u17 = false;
	end;
end);
UpdateButton();
v1.Signal.Fired("Stat Changed"):Connect(function(p6)
	if p6 == "Gamepasses" then
		UpdateButton();
	end;
end);
v1.Signal.Fired("Changed Platform"):Connect(function()
	UpdateButton();
end);
local l__Enum_KeyCode_Q__18 = Enum.KeyCode.Q;
v1.UserInputService.InputBegan:Connect(function(p7, p8)
	if not p8 and ((p7.KeyCode == l__Enum_KeyCode_Q__18 or p7.KeyCode == Enum.KeyCode.DPadUp) and not u17) then
		u17 = true;
		ProcessInput(true);
		u17 = false;
	end;
end);
v1.Signal.Fired("Entered Cannon"):Connect(function()
	if v1.Variables.UsingHoverboard then
		Toggle();
	end;
end);
v1.Signal.Fired("World Changed"):Connect(function()
	if v1.Variables.UsingHoverboard then
		Toggle();
	end;
end);
v1.Signal.Fired("Stop Using Hoverboard"):Connect(function()
	if v1.Variables.UsingHoverboard then
		Toggle();
	end;
end);
v1.Signal.Fired("Stat Changed"):Connect(function(p9)
	if p9 == "EquippedHoverboard" and v1.Variables.UsingHoverboard then
		Create(v1.LocalPlayer);
	end;
end);
v1.Signal.Fired("Other Stat Changed"):Connect(function(p10, p11)
	if p11 == "EquippedHoverboard" and p10:GetAttribute("UsingHoverboard") then
		task.delay(0.1, function()
			Create(p10);
		end);
	end;
end);
function UpdatePlayer(p12, p13)
	local v42 = v1.Player.Character(p12);
	if v42 then
		if p13 then
			if not v42:FindFirstChild("__HOVERBOARD") then
				task.delay(0.1, function()
					Create(p12);
				end);
				return;
			end;
		end;
	end;
	if not p13 then
		if v42:FindFirstChild("__HOVERBOARD") then
			Remove(p12);
		end;
	end;
end;
function TrackPlayer(p14)
	if p14:GetAttribute("UsingHoverboard") then
		while true do
			if v1.Variables.LoadingWorld then

			else
				break;
			end;
			v1.Heartbeat();		
		end;
		UpdatePlayer(p14, true);
	end;
	p14:GetAttributeChangedSignal("UsingHoverboard"):Connect(function()
		UpdatePlayer(p14, (p14:GetAttribute("UsingHoverboard")));
	end);
end;
game.Players.PlayerAdded:Connect(function(p15)
	TrackPlayer(p15);
end);
for v43, v44 in ipairs(game.Players:GetPlayers()) do
	TrackPlayer(v44);
end;
