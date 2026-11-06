-- https://github.com/kalidrios

local table1 = {
	"Epic",
	"Legendary",
	"Mythical",
	"Secret",
	"Event",
	"Exclusive"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_EggOpenInfo = m_Library.GUI.EggOpenInfo;
local Random_new_ret = Random.new();
local t_ID = m_Library.Directory.Gamepasses["Skip Egg Open"].ID;
local t_CurrentCamera = game.Workspace.CurrentCamera;
local _ = t_CurrentCamera.FieldOfView;
function OpenEgg(p1, p2) -- Line: 23
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = t_ID
			[4] = t_EggOpenInfo
			[5] = t_CurrentCamera
			[6] = Random_new_ret
	--]]
	local t_Variables = m_Library.Variables;
	t_Variables.OpeningEgg = t_Variables.OpeningEgg + 1;
	m_Library.Signal.Fire("Opening Egg", p1);
	debug.profilebegin("Open Eggs.OpenEgg.pt1");
	local v1 = m_Library.Save.Get();
	local v2 = m_Library.Directory.Eggs[p1];
	local v3 = #p2 == 3;
	local u1 = #p2 == 8;
	local v4 = false;
	local bool1 = false;
	local t_rarity = nil;
	local bool2 = false;
	local bool3 = false;
	for _, val1 in ipairs(p2) do
		if val1.r then
			bool3 = true;
		elseif val1.g then
			bool2 = true;
		end
		local v8 = m_Library.Directory.Pets[val1.id];
		v4 = v4 or m_Library.Functions.SearchArray(table1, v8.rarity);
		if not t_rarity then
			t_rarity = v8.rarity;
		elseif m_Library.Shared.PetRarityNumbers[v8.rarity] > m_Library.Shared.PetRarityNumbers[t_rarity] then
			t_rarity = v8.rarity;
		end
		if not val1.sh then continue end
		bool1 = true;
	end
	table.sort(p2, function(p5, p6) -- Line: 57
		--[[
			Upvalues:
				[1] = m_Library
		--]]
		local v22 = m_Library.Directory.Pets[p5.id];
		local v23 = m_Library.Directory.Pets[p6.id];
		if m_Library.Shared.PetRarityNumbers[v22.rarity] == m_Library.Shared.PetRarityNumbers[v23.rarity] then
			if v22.titanic == v23.titanic then
				if v22.huge == v23.huge then
					if p5.dm == p6.dm then
						if p5.r == p6.r then
							if p5.g == p6.g then
								return v22.strengthMax > v23.strengthMax;
							end
							return p5.g;
						end
						return p5.r;
					end
					return p5.dm;
				end
				return v22.huge;
			end
			return v22.titanic;
		end
		return m_Library.Shared.PetRarityNumbers[v22.rarity] > m_Library.Shared.PetRarityNumbers[v23.rarity];
	end);
	local u2 = m_Library.Audio.Play(4211241679, script, 1, 0.35);
	local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect");
	DepthOfFieldEffect.FarIntensity = 0;
	DepthOfFieldEffect.FocusDistance = 0;
	DepthOfFieldEffect.InFocusRadius = 1.5;
	DepthOfFieldEffect.NearIntensity = 0;
	DepthOfFieldEffect.Parent = game.Lighting;
	local _ = v1.Settings.EggSkip or 1;
	local u3 = m_Library.Gamepasses.Owns(t_ID);
	local num1 = 1;
	if not v2.hatchable then
		u3 = true;
	end
	local bool4 = false;
	local u4 = nil;
	local function Skip() -- Line: 111
		--[[
			Upvalues:
				[1] = bool4
				[2] = num1
				[3] = u2
				[4] = u4
		--]]
		bool4 = true;
		num1 = 7.5;
		u2:Stop();
		u4:Disconnect();
	end
	u4 = m_Library.UserInputService.InputEnded:Connect(function(input, gameProcessedEvent) -- Line: 118
		--[[
			Upvalues:
				[1] = u3
				[2] = bool4
				[3] = num1
				[4] = u2
				[5] = u4
		--]]
		if not gameProcessedEvent and u3 then
			local _ = input.UserInputType;
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.ButtonX then
				bool4 = true;
				num1 = 7.5;
				u2:Stop();
				u4:Disconnect();
			end
		end
	end);
	if u3 and m_Library.Variables.AutoHatchEnabled then
		bool4 = true;
		num1 = 7.5;
		u2:Stop();
		u4:Disconnect();
	end
	t_EggOpenInfo.SkipLabel.Text = m_Library.Variables.Console and "(Press X to skip)" or m_Library.Variables.Mobile and "(Tap anywhere to skip)" or "(Click anywhere to skip)";
	t_EggOpenInfo.SkipLabel.Visible = u3;
	t_EggOpenInfo.Gui.Enabled = true;
	local table2 = {};
	local table3 = {};
	local num2 = 1;
	if v3 then
		num2 = 3;
	elseif u1 then
		num2 = 8;
	end
	for index1 = 1, num2 do
		local Clone_ret7 = v2.model:Clone();
		Clone_ret7.Size = Clone_ret7.Size / 3.5;
		Clone_ret7.CanCollide = false;
		Clone_ret7.CastShadow = false;
		Clone_ret7.Parent = t_CurrentCamera;
		if index1 == 1 then
			local PointLight = Instance.new("PointLight");
			PointLight.Range = 5;
			PointLight.Brightness = 5;
			PointLight.Parent = Clone_ret7;
		end
		local v9 = (not v3 and not u1 or v3) and CFrame.new(index1 == 2 and 1.25 or index1 == 3 and -1.25 or 0, 0, index1 > 1 and -1 or 0) * CFrame.Angles(0, 3.141592653589793, 0) or CFrame.new((index1 == 1 or index1 == 3) and 0.75 or (index1 == 2 or index1 == 4) and -0.75 or (index1 == 5 or index1 == 7) and 2.5 or (index1 == 6 or index1 == 8) and -2.5 or false, (index1 <= 2 or index1 > 4 and index1 <= 6) and 0.9 or -0.9, index1 <= 4 and 0 or -1) * CFrame.Angles(0, 3.141592653589793, 0);
		table2[index1] = Clone_ret7;
		table3[index1] = v9;
	end
	debug.profileend();
	local os_clock_ret = os.clock();
	repeat
		debug.profilebegin("Open Eggs.OpenEgg.pt2");
		local math_clamp_ret = math.clamp((os.clock() - os_clock_ret) / (0.85 / num1), 0, 1);
		local v10 = m_Library.Functions.Easing(math_clamp_ret, "Quint", "Out");
		for key6, val6 in ipairs(table2) do
			local v24 = table3[key6];
			val6.CFrame = t_CurrentCamera.CFrame * CFrame.new(0, v10 * 5 + -5, v10 * 5 + -7.5) * v24;
		end
		DepthOfFieldEffect.FarIntensity = math_clamp_ret;
		DepthOfFieldEffect.NearIntensity = math_clamp_ret;
		debug.profileend();
		m_Library.RenderStepped();
	until math_clamp_ret >= 1;
	local cf = CFrame.new(0, 0, -2.5);
	local t_Size = table2[1].Size;
	for index2 = 1, 3 do
		local v11 = index2 % 2 == 0 and Random_new_ret:NextNumber(-45, -25) or Random_new_ret:NextNumber(25, 45);
		m_Library.Audio.Play(index2 == 1 and 4211240259 or index2 == 2 and 4211240648 or 4211241079, script, 1, 0.75);
		local os_clock_ret8 = os.clock();
		local v12 = 0.1 / math.max(index2 * 0.6, 1);
		repeat
			debug.profilebegin("Open Eggs.OpenEgg.pt3");
			local math_clamp_ret9 = math.clamp((os.clock() - os_clock_ret8) / (v12 / num1), 0, 1);
			local v25 = m_Library.Functions.Easing(math_clamp_ret9, "Elastic", "Out");
			for key14, val14 in ipairs(table2) do
				val14.CFrame = t_CurrentCamera.CFrame * cf * table3[key14] * CFrame.new(0, 0, v25 * 0.1) * CFrame.Angles(0, 0, (math.rad(v11 * v25)));
			end
			debug.profileend();
			m_Library.RenderStepped();
		until math_clamp_ret9 >= 1;
		local os_clock_ret9 = os.clock();
		local v13 = 0.4 / math.max(index2 * 0.7, 1);
		repeat
			debug.profilebegin("Open Eggs.OpenEgg.pt4");
			local math_clamp_ret10 = math.clamp((os.clock() - os_clock_ret9) / (v13 / num1), 0, 1);
			local v26 = m_Library.Functions.Easing(math_clamp_ret10, "Quad", "Out");
			for key15, val15 in ipairs(table2) do
				val15.CFrame = t_CurrentCamera.CFrame * cf * table3[key15] * CFrame.new(0, 0, 0.1 - v26 * 0.1) * CFrame.Angles(0, 0, (math.rad(v11 - v26 * v11)));
			end
			debug.profileend();
			m_Library.RenderStepped();
		until math_clamp_ret10 >= 1;
	end
	local os_clock_ret2 = os.clock();
	repeat
		debug.profilebegin("Open Eggs.OpenEgg.pt5");
		local math_clamp_ret2 = math.clamp((os.clock() - os_clock_ret2) / (0.4 / num1), 0, 1);
		local v14 = m_Library.Functions.Easing(math_clamp_ret2, "Quart", "Out");
		for key7, val7 in ipairs(table2) do
			local v27 = table3[key7];
			val7.Size = t_Size * (1 - v14 * 0.75);
			val7.CFrame = t_CurrentCamera.CFrame * cf * v27;
		end
		u2.Volume = 0.5 - math_clamp_ret2 * 0.5;
		debug.profileend();
		m_Library.RenderStepped();
	until math_clamp_ret2 >= 1;
	debug.profilebegin("Open Eggs.OpenEgg.pt6");
	local t_Size2 = table2[1].Size;
	u4:Disconnect();
	u4 = nil;
	t_EggOpenInfo.SkipLabel.Visible = false;
	debug.profilebegin("Open Eggs.OpenEgg.pt7.spawn");
	local table4 = {};
	local t_CurrentCamera2 = game.Workspace.CurrentCamera;
	for index3 = 1, Random_new_ret:NextInteger(50, 100) do
		local table6 = {
			Random_new_ret:NextNumber(-2, 2),
			Random_new_ret:NextNumber(),
			Random_new_ret:NextNumber()
		};
		local NextNumber_ret = Random_new_ret:NextNumber(4, 8);
		local Clone_ret6 = m_Library.Assets.Models.Confetti:Clone();
		Clone_ret6.Color = Color3.fromHSV(Random_new_ret:NextNumber(), 1, 1);
		Clone_ret6.CFrame = t_CurrentCamera2.CFrame * CFrame.new(0, table6[2] + 1.5, -1);
		Clone_ret6.CastShadow = false;
		Clone_ret6.Parent = t_CurrentCamera2;
		table4[index3] = {
			confetti = Clone_ret6,
			floats = table6,
			speed = NextNumber_ret
		};
	end
	debug.profileend();
	local u5 = 0;
	local Connect_ret = nil;
	Connect_ret = game:GetService("RunService").RenderStepped:Connect(function(p7) -- Line: 283
		--[[
			Upvalues:
				[1] = u5
				[2] = table4
				[3] = t_CurrentCamera2
				[4] = m_Library
				[5] = Connect_ret
		--]]
		debug.profilebegin("Open Eggs.OpenEgg.pt7.animate");
		u5 = u5 + p7;
		local bool5 = false;
		for key16, val16 in pairs(table4) do
			local t_floats = val16.floats;
			local math_clamp_ret3 = math.clamp(u5 / 0.4, 0.001, 1);
			val16.confetti.CFrame = t_CurrentCamera2.CFrame * CFrame.new(t_floats[1], t_floats[2] + 1.5 - math_clamp_ret3 * 10, -1) * CFrame.Angles(t_floats[3] * (math_clamp_ret3 * 125), 0, 0);
			if math_clamp_ret3 >= 1 then
				table4[key16] = nil;
				m_Library.Functions.AddDebris(val16.confetti, 0);
				continue;
			end
			bool5 = true;
		end
		if not bool5 then
			Connect_ret:Disconnect();
		end
		debug.profileend();
	end);
	if t_rarity == "Secret" or t_rarity == "Mythical" or t_rarity == "Event" or t_rarity == "Exclusive" then
		m_Library.Audio.Play("rbxassetid://7255790231", script, 1, 1.5);
	elseif t_rarity == "Epic" or t_rarity == "Legendary" then
		m_Library.Audio.Play("rbxassetid://6958705357", script, 1, 1.5);
	elseif t_rarity == "Rare" then
		m_Library.Audio.Play("rbxassetid://6958705312", script, 1, 1.25);
	else
		m_Library.Audio.Play("rbxassetid://6958705265", script, 1, 1);
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 344
		--[[
			Upvalues:
				[1] = m_Library
				[2] = bool3
				[3] = bool2
				[4] = bool1
		--]]
		m_Library.Functions.Wait(0.25);
		if bool3 then
			m_Library.Audio.Play("rbxassetid://7503155199", script, 1, 1);
		elseif bool2 then
			m_Library.Audio.Play("rbxassetid://7503155258", script, 1, 0.85);
		end
		if bool1 then
			m_Library.Audio.Play("rbxassetid://11788145043", script, 1, 1);
		end
	end);
	coroutine_wrap_ret();
	debug.profileend();
	local os_clock_ret3 = os.clock();
	repeat
		debug.profilebegin("Open Eggs.OpenEgg.pt8");
		local math_clamp_ret4 = math.clamp((os.clock() - os_clock_ret3) / 0.075, 0, 1);
		local v15 = m_Library.Functions.Easing(math_clamp_ret4, "Sine", "Out");
		for key8, val8 in ipairs(table2) do
			local v28 = table3[key8];
			val8.Size = t_Size2 * (v15 * 5);
			val8.CFrame = t_CurrentCamera.CFrame * cf * v28;
		end
		debug.profileend();
		m_Library.RenderStepped();
	until math_clamp_ret4 >= 1;
	for _, val2 in ipairs(table2) do
		m_Library.Functions.AddDebris(val2, 0);
	end
	debug.profilebegin("Open Eggs.OpenEgg.pt9");
	local v5 = m_Library.GUIParticles.New(UDim2.new(0.5, 0, 0.5, 0), m_Library.Assets.Particles:FindFirstChild("Egg Open").Shine:Clone());
	v5:Emit(3);
	local v6 = m_Library.GUIParticles.New(UDim2.new(0.5, 0, 0.5, 0), m_Library.Assets.Particles:FindFirstChild("Egg Open").Sparkles:Clone());
	v6:Emit(25);
	m_Library.GUIFX.Flash(0, 0.5);
	for key3, val3 in ipairs(p2) do
		local v16 = m_Library.Directory.Pets[val3.id];
		local t_g2 = val3.g;
		local t_r2 = val3.r;
		local t_dm2 = val3.dm;
		local t_sh2 = val3.sh;
		local Clone_ret3 = ((t_g2 or t_dm2) and v16.modelGold or v16.model):Clone();
		Clone_ret3.CastShadow = false;
		if Clone_ret3:FindFirstChildOfClass("Trail") then
			m_Library.Functions.AddDebris(Clone_ret3:FindFirstChildOfClass("Trail"), 0);
		end
		if Clone_ret3:FindFirstChildOfClass("Beam") then
			m_Library.Functions.AddDebris(Clone_ret3:FindFirstChildOfClass("Beam"), 0);
		end
		local SpecialMesh = Clone_ret3:FindFirstChildOfClass("SpecialMesh");
		if t_dm2 then
			SpecialMesh.VertexColor = Vector3.new(20, 0.6, 20);
		elseif t_r2 then
			SpecialMesh.VertexColor = Vector3.new(2, 2, 2);
		elseif t_g2 then
			SpecialMesh.VertexColor = Vector3.new(1.45, 1.45, 1.45);
		elseif SpecialMesh.VertexColor == Vector3.new(1, 1, 1) then
			SpecialMesh.VertexColor = Vector3.new(1.125, 1.125, 1.125);
		end
		SpecialMesh.VertexColor = SpecialMesh.VertexColor + Vector3.new(0.1, 0.1, 0.1);
		if v16.titanic then
			SpecialMesh.Offset = Vector3.new(0, 1, 3);
		end
		if t_r2 then
			local FindFirstChild_ret = m_Library.Assets.Other:FindFirstChild("Rainbow Pet");
			for _, child17 in ipairs(FindFirstChild_ret:GetChildren()) do
				local Clone_ret5 = child17:Clone();
				Clone_ret5.Name = "__RAINBOWFX";
				Clone_ret5.Parent = Clone_ret3;
				local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 433
					--[[
						Upvalues:
							[1] = Clone_ret3
							[2] = m_Library
							[3] = Clone_ret5
					--]]
					while not Clone_ret3.Parent do
						m_Library.RenderStepped();
					end
					while Clone_ret3 and Clone_ret3.Parent do
						debug.profilebegin("Open Eggs.OpenEgg.pt9.rainbow");
						local Color3_fromHSV_ret = Color3.fromHSV(os.clock() / 1.5 % 1, 1, 1);
						Clone_ret5.Color3 = Color3_fromHSV_ret;
						debug.profileend();
						m_Library.RenderStepped();
					end
				end);
				coroutine_wrap_ret3();
			end
		end
		if t_sh2 then
			local Clone_ret4;
			if v16.titanic then
				Clone_ret4 = m_Library.Assets.Particles.Shiny:FindFirstChild("TitanicShinyParticle"):Clone();
				m_Library.Functions.ScaleParticle(Clone_ret4, 1.5);
			elseif v16.huge then
				Clone_ret4 = m_Library.Assets.Particles.Shiny:FindFirstChild("HugeShinyParticle"):Clone();
				m_Library.Functions.ScaleParticle(Clone_ret4, 1.5);
			else
				Clone_ret4 = m_Library.Assets.Particles.Shiny:FindFirstChild("ShinyParticle"):Clone();
			end
			Clone_ret4.Parent = Clone_ret3:FindFirstChild("center");
			Clone_ret4:Emit(1);
		end
		for _, descendant9 in ipairs(Clone_ret3:GetDescendants()) do
			if descendant9.ClassName == "SpecialMesh" then
				descendant9.Scale = descendant9.Scale * 0.33;
				continue;
			end
			if descendant9.ClassName == "Attachment" then
				descendant9.Position = descendant9.Position * 0.33;
				continue;
			end
			if descendant9.ClassName ~= "ParticleEmitter" then continue end
			m_Library.Functions.ScaleParticle(descendant9, 0.33);
		end
		if Clone_ret3:FindFirstChild("PropWeld") then
			if val3.id == "395" then
				Clone_ret3.PropWeld.C0 = CFrame.new(0, -0.71, 0.53);
			elseif val3.id == "403" then
				Clone_ret3.PropWeld.C0 = CFrame.new(-0.01, -0.9, -0.26);
			elseif val3.id == "419" then
				Clone_ret3.PropWeld.C0 = CFrame.new(-0.01, -0.9, -0.26);
			elseif val3.id == "2034" then
				Clone_ret3.PropWeld.C0 = CFrame.new(-0.01, -2.6, -0.8);
			end
		end
		Clone_ret3.Parent = t_CurrentCamera;
		local v17 = (not v3 and not u1 or v3) and CFrame.new(key3 == 2 and 1.35 or key3 == 3 and -1.35 or 0, 0, key3 > 1 and -0.15 or 0) or CFrame.new((key3 == 1 or key3 == 3) and -0.81 or (key3 == 2 or key3 == 4) and 0.81 or (key3 == 5 or key3 == 7) and -2.3 or (key3 == 6 or key3 == 8) and 2.3 or false, (key3 <= 2 or key3 > 4 and key3 <= 6) and 0.75 or -0.6, key3 <= 4 and 0 or -0.15);
		val3.model = Clone_ret3;
		val3.offset = v17;
	end
	for _, val4 in ipairs(p2) do
		local v18 = m_Library.Directory.Pets[val4.id];
		local t_g = val4.g;
		local t_r = val4.r;
		local t_dm = val4.dm;
		local t_sh = val4.sh;
		local v19 = v18.name;
		if t_dm then
			v19 = "Dark Matter " .. v19;
		elseif t_r then
			v19 = "Rainbow " .. v19;
		elseif t_g then
			v19 = "Golden " .. v19;
		end
		if t_sh then
			v19 = "Shiny " .. v19;
		end
		local Clone_ret = m_Library.Assets.Other.EggOpenPetInfo:Clone();
		Clone_ret.SurfaceGui.PetIcon.Image = t_dm and v18.darkMatterThumbnail or t_g and v18.goldenThumbnail or v18.thumbnail;
		Clone_ret.SurfaceGui.PetName.Text = v19;
		Clone_ret.SurfaceGui.Rarity.Text = v18.rarity;
		m_Library.Shared.ApplyRarityColor(Clone_ret.SurfaceGui.Rarity, v18.rarity);
		if t_r then
			m_Library.GUIFX.Rainbow(Clone_ret.SurfaceGui.PetIcon, "ImageColor3", 2);
		end
		if t_sh then
			local Clone_ret2 = m_Library.Assets.UI.Inventory.ShinyGradient:Clone();
			Clone_ret2.Parent = Clone_ret.SurfaceGui.PetName;
		end
		Clone_ret.Parent = t_CurrentCamera;
		val4.gui = Clone_ret;
	end
	local bool6 = false;
	local table5 = {};
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 552
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p2
				[3] = u1
				[4] = t_CurrentCamera
				[5] = table5
				[6] = bool6
		--]]
		local os_clock_ret4 = os.clock();
		repeat
			debug.profilebegin("Open Eggs.OpenEgg.pt9.gui-animation");
			local math_clamp_ret5 = math.clamp((os.clock() - os_clock_ret4) / 0.75 * 2, 0, 1);
			local v29 = m_Library.Functions.Easing(math_clamp_ret5, "Expo", "Out");
			for key18, val18 in ipairs(p2) do
				local t_gui = val18.gui;
				local v30 = val18.offset;
				if u1 then
					v30 = v30 + ((key18 >= 3 and key18 <= 4 or key18 >= 7) and Vector3.new(0, 1.45, -0.4) or Vector3.new(0, -1.6, -0.4));
				end
				local t_p = (t_CurrentCamera.CFrame * CFrame.new(0, 0, -30) * v30).p;
				local t_p2 = t_CurrentCamera.CFrame.p;
				local v31 = CFrame.lookAt(t_p, t_p2, t_CurrentCamera.CFrame.UpVector) * CFrame.new(0, -0.7, v29 * -28.3) * v30:Inverse();
				table5[t_gui] = v31;
				t_gui.CFrame = v31;
			end
			debug.profileend();
			m_Library.RenderStepped();
		until bool6;
	end);
	coroutine_wrap_ret2();
	debug.profileend();
	local os_clock_ret5 = os.clock();
	repeat
		debug.profilebegin("Open Eggs.OpenEgg.pt10");
		local math_clamp_ret6 = math.clamp((os.clock() - os_clock_ret5) / 1, 0, 1);
		local v20 = m_Library.Functions.Easing(math_clamp_ret6, "Quart", "Out");
		for _, val10 in ipairs(p2) do
			local t_model3 = val10.model;
			local t_offset3 = val10.offset;
			local Inverse_ret3 = CFrame.new(t_model3:FindFirstChild("center").Position * 0.33):Inverse();
			t_model3.CFrame = CFrame.lookAt((t_CurrentCamera.CFrame * (CFrame.new(0, 0, -2.35) * Inverse_ret3 * t_offset3)).p, t_CurrentCamera.CFrame.p, t_CurrentCamera.CFrame.UpVector) * CFrame.Angles(0, math.rad(v20 * 360), 0);
		end
		debug.profileend();
		m_Library.RenderStepped();
	until math_clamp_ret6 >= 1;
	local os_clock_ret6 = os.clock();
	local v7 = (t_rarity == "Secret" or t_rarity == "Mythical" or t_rarity == "Event" or t_rarity == "Exclusive") and 3.5 or v4 and 1.5 or 0.45;
	if bool4 and (t_rarity == "Secret" or t_rarity == "Mythical" or t_rarity == "Event" or t_rarity == "Exclusive") then
		v7 = v7 / 2;
	end
	repeat
		debug.profilebegin("Open Eggs.OpenEgg.pt11");
		local math_clamp_ret7 = math.clamp((os.clock() - os_clock_ret6) / v7, 0, 1);
		for _, val11 in ipairs(p2) do
			local t_model2 = val11.model;
			local t_offset2 = val11.offset;
			local Inverse_ret2 = CFrame.new(t_model2:FindFirstChild("center").Position * 0.33):Inverse();
			local CFrame_lookAt_ret2 = CFrame.lookAt((t_CurrentCamera.CFrame * (CFrame.new(0, 0, -2.35) * Inverse_ret2 * t_offset2)).p, t_CurrentCamera.CFrame.p, t_CurrentCamera.CFrame.UpVector);
			t_model2.CFrame = CFrame_lookAt_ret2;
		end
		debug.profileend();
		m_Library.RenderStepped();
	until math_clamp_ret7 >= 1;
	bool6 = true;
	local os_clock_ret7 = os.clock();
	repeat
		debug.profilebegin("Open Eggs.OpenEgg.pt12");
		local math_clamp_ret8 = math.clamp((os.clock() - os_clock_ret7) / 0.5, 0, 1);
		local v21 = m_Library.Functions.Easing(math_clamp_ret8, "Back", "In");
		for _, val12 in ipairs(p2) do
			local t_model = val12.model;
			local t_offset = val12.offset;
			local Inverse_ret = CFrame.new(t_model:FindFirstChild("center").Position * 0.33):Inverse();
			local CFrame_lookAt_ret = CFrame.lookAt((t_CurrentCamera.CFrame * (CFrame.new(0, 0, -2.35) * Inverse_ret * t_offset * CFrame.new(0, v21 * -5, 0))).p, t_CurrentCamera.CFrame.p, t_CurrentCamera.CFrame.UpVector);
			t_model.CFrame = CFrame_lookAt_ret;
		end
		for _, val13 in ipairs(p2) do
			local t_gui2 = val13.gui;
			t_gui2.CFrame = table5[t_gui2] * CFrame.new(0, -math_clamp_ret8 * 2, 0);
		end
		DepthOfFieldEffect.FarIntensity = 1 - math_clamp_ret8;
		DepthOfFieldEffect.NearIntensity = 1 - math_clamp_ret8;
		debug.profileend();
		m_Library.RenderStepped();
	until math_clamp_ret8 >= 1;
	debug.profilebegin("Open Eggs.OpenEgg.pt13");
	m_Library.Functions.AddDebris(v5, 0);
	m_Library.Functions.AddDebris(v6, 0);
	m_Library.Functions.AddDebris(DepthOfFieldEffect, 0);
	for _, val5 in ipairs(p2) do
		m_Library.Functions.AddDebris(val5.gui, 0);
		m_Library.Functions.AddDebris(val5.model, 0);
	end
	t_EggOpenInfo.Gui.Enabled = false;
	local t_Variables2 = m_Library.Variables;
	t_Variables2.OpeningEgg = t_Variables2.OpeningEgg - 1;
	m_Library.Signal.Fire("Done Opening Egg", p1);
	debug.profileend();
end
m_Library.Network.Fired("Open Egg"):Connect(function(p3, p4) -- Line: 682
	OpenEgg(p3, p4);
end);
m_Library.Signal.Fired("Open Egg"):Connect(OpenEgg);
