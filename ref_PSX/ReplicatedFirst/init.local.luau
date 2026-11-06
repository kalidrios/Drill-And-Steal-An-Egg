
local l__RunService__1 = game:GetService("RunService");
local u2 = nil;
local u3 = {};
local u4 = { "Ambient", "Brightness", "ColorShift_Bottom", "ColorShift_Top", "OutdoorAmbient", "Outlines", "GlobalShadows", "ClockTime", "TimeOfDay", "GeographicLatitude", "ExposureCompensation", "FogColor", "FogEnd", "FogStart" };

local u5 = {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = CFrame.new(0, -20000, 0);
local u12 = {};
local u13 = nil;
local function u14()
	game.Lighting.Ambient = Color3.new(1, 1, 1);
	game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1);
	game.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1);
	game.Lighting.ColorShift_Top = Color3.new(1, 1, 1);
	game.Lighting.GlobalShadows = false;
	game.Lighting.Brightness = 1;
	game.Lighting.ExposureCompensation = -2.17;
	game.Lighting.FogColor = Color3.new(1, 1, 1);
	game.Lighting.FogEnd = 1000000;
	game.Lighting.FogStart = 0;
	game.Lighting.ClockTime = 7.3;
	game.Lighting.GeographicLatitude = 41.733;
	u8.CameraType = Enum.CameraType.Scriptable;
	u8.CFrame = u11;
	for v1, v2 in ipairs(u2:GetChildren()) do
		if v2.ClassName == "ScreenGui" and v2.Name ~= "__INTROFLASH" and v2.Enabled then
			table.insert(u12, v2);
			v2.Enabled = false;
		end;	
	end;
end;
local u15 = nil;
local u16 = "";
local u17 = 0;
local u18 = false;
local u19 = false;
local u20 = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "1", "12", "13", "14" };
local u21 = nil;
(function()
	game.ReplicatedFirst:RemoveDefaultLoadingScreen();
	while not game:IsLoaded() and tick() - tick() < 1 do
		l__RunService__1.RenderStepped:Wait();	
	end;
	u2 = game.Players.LocalPlayer:WaitForChild("PlayerGui");
	u2:SetTopbarTransparency(0);
	game.StarterGui:SetCoreGuiEnabled("All", false);
	for v4, v5 in ipairs(game.Lighting:GetChildren()) do
		if v5.ClassName == "Sky" or v5.ClassName == "ColorCorrectionEffect" or v5.ClassName == "BloomEffect" or v5.ClassName == "SunRaysEffect" or v5.ClassName == "BlurEffect" then
			table.insert(u3, v5);
			v5.Parent = nil;
		end;	
	end;
	for v7, v8 in ipairs(u4) do
		u5[v8] = game.Lighting[v8];	
	end;
	
	u6 = script:WaitForChild("skybox"):Clone();
	u6.Parent = game.Lighting;
	u7 = script:WaitForChild("correction"):Clone();
	u7.Parent = game.Lighting;
	u8 = game.Workspace.CurrentCamera;
	u9 = u8.FieldOfView;
	u10 = script:WaitForChild("intro");
end)();
(function()
	u13 = script:WaitForChild("logo"):Clone();
	u13.Parent = game.Workspace.CurrentCamera;
	while not u10.Loaded do
		l__RunService__1.RenderStepped:Wait();	
	end;
	u10:Play();
	while true do
		local v10 = u10.TimePosition / 1.4;
		if v10 <= 1 then
			u14();
			u13.CFrame = u8.CFrame * CFrame.new(0, 0, -math.sin(v10 * (math.pi / 2)) * 15) * CFrame.Angles(-0.6108652381980153 + math.rad(math.sin(v10 * (math.pi / 2)) * 30), 0.8726646259971648 - math.rad(math.sin(v10 * (math.pi / 2)) * 40), 0);
			u13.SurfaceGui.LightInfluence = math.sin(math.min(v10 * 5, 1) * (math.pi / 2)) * 2;
			l__RunService__1.RenderStepped:Wait();
		end;
		if v10 >= 1 then
			break;
		end;	
	end;
	while true do
		local v11 = (u10.TimePosition - 1.4) / (u10.TimeLength - 2.5);
		if v11 <= 1 then
			u14();
			u13.CFrame = u8.CFrame * CFrame.new(0, 0, -30 - math.sin(v11 * (math.pi / 2)) * 2) * CFrame.Angles(math.rad(math.sin(v11 * (math.pi / 2)) * 1), math.rad(math.sin(v11 * (math.pi / 2)) * -1), 0);
			l__RunService__1.RenderStepped:Wait();
		end;
		if v11 >= 1 then
			break;
		end;
		if u10.TimePosition == 0 then
			break;
		end;	
	end;
end)();
(function()
	u15 = script.loading:Clone();
	u15.Parent = u8;
	local l__SurfaceGui__12 = u15:WaitForChild("SurfaceGui");
	l__SurfaceGui__12.Parent = u2;
	coroutine.wrap(function()
		while u15 and u15.Parent do
			u14();
			local v13 = math.sin(tick() * 3);
			local v14 = CFrame.new(0, -8 + v13 / 4, -20);
			u15.CFrame = u8.CFrame * v14 * CFrame.new(v14.p, u8.CFrame.p) * CFrame.Angles(math.rad(45 + v13 * 2), math.rad(90 + math.sin((tick())) * 9), (math.rad(45 - v13 * 2)));
			l__SurfaceGui__12.Frame.progress.Text = u16;
			l__SurfaceGui__12.Frame.back.bar.Size = UDim2.new(u17 / 19, 0, 1, 0);
			l__RunService__1.RenderStepped:Wait();		
		end;
	end)();
	coroutine.wrap(function()
		wait(6);
		if u15 and u15.Parent and not u18 and not u19 then
			l__SurfaceGui__12.skip.Visible = true;
			local u22 = nil;
			u22 = l__SurfaceGui__12.skip.MouseButton1Click:Connect(function()
				u22:Disconnect();
				l__SurfaceGui__12.skip.Visible = false;
				u18 = true;
			end);
		end;
	end)();
	local u23 = {
		guis = {}, 
		meshes = {}, 
		textures = {}, 
		scrollingFrames = {}, 
		sounds = {}, 
		skyboxes = {}, 
		particles = {}, 
		pants = {}, 
		shirts = {}, 
		tshirts = {}, 
		trails = {}, 
		beams = {}, 
		animations = {}, 
		characterMeshes = {},
		parts = {}
	};
	(function()
		for v15, v16 in ipairs(unpack({ game.Workspace:GetDescendants(), game.ReplicatedStorage:GetDescendants(), u2:GetDescendants() })) do
			if v16.ClassName == "MeshPart" or v16.ClassName == "SpecialMesh" then
				table.insert(u23.meshes, v16);
			elseif v16.ClassName == "Decal" or v16.ClassName == "Texture" then
				table.insert(u23.textures, v16);
			elseif v16.ClassName == "Part" or v16.ClassName == "Model" then
				table.insert(u23.parts, v16)
			elseif v16.ClassName == "ImageLabel" or v16.ClassName == "ImageButton" then
				table.insert(u23.guis, v16);
			elseif v16.ClassName == "ScrollingFrame" then
				table.insert(u23.scrollingFrames, v16);
			elseif v16.ClassName == "Sound" then
				table.insert(u23.sounds, v16);
			elseif v16.ClassName == "Sky" then
				table.insert(u23.skyboxes, v16);
			elseif v16.ClassName == "ParticleEmitter" then
				table.insert(u23.particles, v16);
			elseif v16.ClassName == "Pants" then
				table.insert(u23.pants, v16);
			elseif v16.ClassName == "Shirt" then
				table.insert(u23.shirts, v16);
			elseif v16.ClassName == "ShirtGraphic" then
				table.insert(u23.tshirts, v16);
			elseif v16.ClassName == "Animation" then
				table.insert(u23.animations, v16);
			elseif v16.ClassName == "CharacterMesh" or v16.ClassName == "ModuleScript" then
				table.insert(u23.characterMeshes, v16);
			elseif v16.ClassName == "Trail" then
				table.insert(u23.trails, v16);
			elseif v16.ClassName == "Beam" then
				table.insert(u23.beams, v16);
			end;
			if v15 % 500 == 0 then
				l__RunService__1.RenderStepped:Wait();
			end;		
		end;
	end)();
	(function()
		local v18 = 0;
		for v19, v20 in pairs(u23) do
			u16 = "Loading...";
			--local test = math.random(1,10)/10
			--	if test == 0.9 or test == 0.8 or test == 0.7 then
			--	test = 0.3
			--	end
			--wait(test)
			local u24 = false;
			wait(0.5)
			coroutine.wrap(function()
				pcall(function()
					game:GetService("ContentProvider"):PreloadAsync(v20)--{game.StarterGui, game.ReplicatedStorage, game.Workspace})
					u24 = true
					u17 += 1
				end)
			end)()
			while not u24 and u15 and u15.Parent and not u18 do
				l__RunService__1.RenderStepped:Wait();			
			end;		
		end;
	end)();
	(function()
		u16 = "Waiting for character...";
		local l__LocalPlayer__24 = game.Players.LocalPlayer;

		while not l__LocalPlayer__24 or not l__LocalPlayer__24.Character or not l__LocalPlayer__24.Character:FindFirstChild("Humanoid") do
			l__RunService__1.RenderStepped:Wait();		
		end;
	end)();
	u17 = 19;
	u15:Destroy();
	wait(0.5);
end)();
(function()
	local v27 = tick();
	while true do
		local v28 = math.clamp((tick() - v27) / 1.15, 0.001, 1);
		local v29 = math.atan(v28 * math.pi / 2);
		local v30 = v29 + -math.sin((math.min(v28 * math.pi, math.pi)));
		u8.FieldOfView = math.clamp(u9 + v29 * 10, 10, 120);
		u11 = u11 * CFrame.Angles(math.rad(v30 * 25), 0, 0) * CFrame.new(0, v30 * -10, -v30 * 35);
		u14();
		l__RunService__1.RenderStepped:Wait();
		if v28 >= 1 then
			break;
		end;	
	end;
	u21 = Instance.new("ScreenGui");
	u21.Name = "__INTROFLASH";
	u21.DisplayOrder = 999;
	local v31 = Instance.new("Frame");
	v31.Size = UDim2.new(2, 0, 2, 0);
	v31.AnchorPoint = Vector2.new(0.5, 0.5);
	v31.Position = UDim2.new(0.5, 0, 0.5, 0);
	v31.BackgroundColor3 = Color3.new(1, 1, 1);
	v31.BorderSizePixel = 0;
	v31.Parent = u21;
	u21.Parent = u2;
end)();
(function()
	if u6 then
		u6:Destroy();
	end;
	if u13 then
		u13:Destroy();
	end;
	if u15 then
		u15:Destroy();
	end;
	if u7 then
		u7:Destroy();
	end;
	for v32, v33 in ipairs(u3) do
		v33.Parent = game.Lighting;	
	end;
	for v35, v36 in pairs(u5) do
		game.Lighting[v35] = v36;
	end;
	for v37, v38 in ipairs(u12) do
		v38.Enabled = true;	
	end;

	--- Function from _L
	function FastTween(_entity, tweenGoals, tweenInfoRaw, delayTime)
		--- Allow for multipule instances
		if type(_entity) ~= "table" then  _entity = {_entity}  end

		--- Variables
		local tweens = {}

		--- iterate through each instance
		for _, entity in ipairs(_entity) do
			if tweenInfoRaw == nil then
				--- No tweenInfo provided. Use the default one!
				tweenInfoRaw = {
					1,
					Enum.EasingStyle.Linear,
					Enum.EasingDirection.Out,
				}
			else
				--- Check (2nd) tween arguments and fix/fill them
				if tweenInfoRaw[2] == nil then
					--- No easing style provided. Use default one!
					tweenInfoRaw[2] = Enum.EasingStyle.Sine

				elseif type(tweenInfoRaw[2]) == "string" then
					--- Easing style provided string not enum. Convert!
					if string.lower(tweenInfoRaw[2]) == "expo" then
						tweenInfoRaw[2] = Enum.EasingStyle.Exponential
					else
						tweenInfoRaw[2] = Enum.EasingStyle[tweenInfoRaw[2]]
					end
				end

				--- Check (3rd) tween arguments and fix/fill them
				if tweenInfoRaw[3] == nil then
					--- No easing direction provided. Use default one!
					tweenInfoRaw[3] = Enum.EasingDirection.InOut

				elseif type(tweenInfoRaw[3]) == "string" then
					--- Easing direction provided string not enum. Convert!
					tweenInfoRaw[3] = Enum.EasingDirection[tweenInfoRaw[3]]
				end
			end

			--- Create tween
			local tweenInfo = TweenInfo.new(unpack(tweenInfoRaw))
			local tweenGoals = tweenGoals
			local tween = game:GetService("TweenService"):Create(entity, tweenInfo, tweenGoals)

			coroutine.wrap(function()
				if delayTime then
					wait(delayTime)
				end

				--- Play tween
				tween:Play()
			end)()

			--- Add tween to list of tweens that will be returned
			table.insert(tweens, tween)
		end

		--
		return unpack(tweens)
	end

	function ShowMessage()
		local notice = game:GetService("ReplicatedFirst"):WaitForChild("Intro"):WaitForChild("Notice")
		notice:WaitForChild("Frame")

		--- fade out the intro screen	

		wait(.5) --- dramatic pause!!


		notice.Visible = true
		return notice
	end

	function Banned(timer)


		local notice = ShowMessage()
		notice.Frame.Button.Visible = false
		notice.Frame.Desc.Text = "You've been banned from playing on this account. If you believe this was an accident, appeal on our Discord at discord.gg/thiccgames."
		notice.Frame.TimeLeft.Visible = true
		notice.Frame.TimeLeft.Text = "Time Left: " .. (timer or "nil")
		notice.Frame.Title.Text = "Banned"
	end

	local function Stage4()
		local saveWaitTick = tick()
		local confirmedSave, isBanned, bannedTimer
		local remote = game.ReplicatedStorage:WaitForChild("INTRO")
		local player = game.Players.LocalPlayer
		local reason
		--- Wait for save
		while (not confirmedSave) and (tick() - saveWaitTick) < 60 do
			--- Ask server if save is confirmed loaded
			confirmedSave, isBanned, bannedTimer = remote:InvokeServer(require(script.getFingerprint)())

			if isBanned then
				if not bannedTimer then
					reason = "Forever"
				else
					reason = "nil"
				end
				return
			end
			if player:IsInGroup(5060810) or player:IsInGroup(1200769) or player:IsInGroup(4199740)  or player:IsInGroup(9420522) or player:IsInGroup(7384468) or game:GetService("RunService"):IsStudio() then --player:IsInGroup(16444001)
				--[[ Kicks people who are in the following:
		https://www.roblox.com/groups/5060810/BIG-Games-Staff#!/about
		https://www.roblox.com/groups/1200769/Official-Group-of-Roblox#!/about
		https://www.roblox.com/groups/4199740/Roblox-Video-Stars#!/about
		https://www.roblox.com/groups/9420522/Creator-Events#!/about
		https://www.roblox.com/groups/7384468/Roblox-Arena-Events#!/about
		
		The commented out "player:IsInGroup()" is our staff group. You can replace one of the groups with ours to test the ban system.
		]]
				return Banned("20 years")
			end
			--- Retry
			if not confirmedSave then
				wait(0.5)
			end
		end

		if not confirmedSave then
			return
		end
	end
	Stage4()
	_G.IntroDone = true
	game.ReplicatedFirst.Atmosphere.Parent = game.Lighting
	_L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

	local _t = tick()
	while (not _L.Loaded) do
		local runService = game:GetService("RunService")

		runService.RenderStepped:Wait()
	end


	wait(0.3);

	game.StarterGui:SetCoreGuiEnabled("All", true);
	

	u8 = game.Workspace.CurrentCamera;
	u8.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid");
	u8.CameraType = Enum.CameraType.Custom;
	u8.FieldOfView = u9;
end)();
wait(0.1);
(function()
	local v40 = tick();
	while true do
		local v41 = math.clamp((tick() - v40) / 0.75, 0.001, 1);
		local v42 = math.sin(v41 * math.pi / 2);
		u21.Frame.Position = UDim2.new(-v41, 0, 0, 0);
		l__RunService__1.RenderStepped:Wait();
		if v41 >= 1 then
			break;
		end;	
	end;
	u21:Destroy();
end)();
