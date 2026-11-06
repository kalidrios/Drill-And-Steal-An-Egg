-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage.Library);
m_Library.Load();
local _ = require(game.ReplicatedStorage.Library.Modules.Pets);
local u1 = require(script.CameraSpace).new();
local ExclusiveEggs = m_Library.Things:WaitForChild("ExclusiveEggs");
local ExclusiveEggPets = m_Library.Things:WaitForChild("ExclusiveEggPets");
local t_ExclusiveEggSpacingRadius = m_Library.Shared.ExclusiveEggSpacingRadius;
local t_ExclusiveEggRadiusRange = m_Library.Shared.ExclusiveEggRadiusRange;
local t_ExclusiveEggRadiusStep = m_Library.Shared.ExclusiveEggRadiusStep;
local _ = m_Library.Shared.ExclusiveEggRadiusBuffer;
local t_ExclusiveEggMaxHeight = m_Library.Shared.ExclusiveEggMaxHeight;
local t_ExclusiveEggHeightOffset = m_Library.Shared.ExclusiveEggHeightOffset;
local _ = m_Library.Shared.ExclusiveEggMaxHeightBuffer;
local table1 = {
	Enum.NormalId.Back,
	Enum.NormalId.Front,
	Enum.NormalId.Left,
	Enum.NormalId.Right,
	Enum.NormalId.Top,
	Enum.NormalId.Bottom
};
local table2 = {};
local table3 = {
	EGG_LAND = {"rbxassetid://98596675069622"},
	EGG_OPEN = {"rbxassetid://75530263501470"},
	EGG_OPEN_RARE = {"rbxassetid://127650892139757"},
	EGG_OPEN_HUGE = {"rbxassetid://86673917266391"},
	EGG_OPEN_TITANIC = {"rbxassetid://73133901102521"},
	EGG_SPAWN = {
		"rbxassetid://87569523388454",
		"rbxassetid://119755656122134"
	},
	EGG_THROW = {
		"rbxassetid://77119872024361",
		"rbxassetid://124416888548844"
	},
	EGG_SHAKE = {"rbxassetid://123281540977140"},
	EGG_GROW_HUGE = {"rbxassetid://123281540977140"},
	EGG_GROW_TITANIC = {"rbxassetid://92856561721060"},
	PET_REMOVE = {"rbxassetid://119359240287694"},
	INVENTORY_OPEN = {"rbxassetid://119025099140922"}
};
function preloadAssets() -- Line: 92
	--[[
		Upvalues:
			[1] = table3
			[2] = m_Library
	--]]
	local table4 = {};
	for _, val1 in pairs(table3) do
		for _, val6 in ipairs(val1) do
			table.insert(table4, val6);
		end
	end
	m_Library.Functions.wcall(function() -- Line: 102
		--[[
			Upvalues:
				[1] = m_Library
				[2] = table4
		--]]
		m_Library.ContentProvider:PreloadAsync(table4);
	end);
end
function autoControlPoint(p1, p2) -- Line: 107
	local v1 = (p1 + p2) / 2;
	local t_Magnitude = ((p1 - p2) * Vector3.new(1, 0, 1)).Magnitude;
	local v2 = math.max(p1.Y, p2.Y) + t_Magnitude;
	return Vector3.new(v1.X, v2, v1.Z);
end
function createPetGui(p3, p4) -- Line: 117
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v3 = m_Library.Directory.Pets[p4.id];
	assert(v3);
	local v4 = v3.name;
	if p4.dm then
		v4 = "Dark Matter " .. v4;
	elseif p4.r then
		v4 = "Rainbow " .. v4;
	elseif p4.g then
		v4 = "Golden " .. v4;
	end
	if p4.sh then
		v4 = "Shiny " .. v4;
	end
	local Clone_ret = m_Library.Assets.Billboards.ExclusivePet:Clone();
	Clone_ret.Name = "__BILLBOARD";
	Clone_ret.StudsOffset = Vector3.new(0, (p3.center.Position - p3.bottom.Position).Y * 2 + 0.5, 0);
	Clone_ret.PetName.Text = v4;
	Clone_ret.PetIcon.Image = p4.dm and v3.darkMatterThumbnail or p4.g and v3.goldenThumbnail or v3.thumbnail;
	Clone_ret.Rarity.Text = v3.rarity;
	m_Library.Shared.ApplyRarityColor(Clone_ret.Rarity, v3.rarity);
	if p4.r then
		m_Library.GUIFX.Rainbow(Clone_ret.PetName, "TextColor3", 2);
		m_Library.GUIFX.Rainbow(Clone_ret.PetIcon, "ImageColor3", 2);
	end
	Clone_ret.Parent = p3.part;
	return Clone_ret;
end
function performAnimation(p5) -- Line: 163
	--[[
		Upvalues:
			[1] = m_Library
			[2] = ExclusiveEggs
			[3] = table3
			[4] = table2
			[5] = table1
			[6] = u1
			[7] = ExclusiveEggPets
	--]]
	local t_player = p5.player;
	local t_origin = p5.origin;
	local t_eggId = p5.eggId;
	local t_petData = p5.petData;
	local t_position = p5.position;
	local table5 = {
		Timing = {
			DelayPerEgg = 0.15,
			UpscaleDuration = 0.75,
			TrailLifetime = 0.35,
			MoveDuration = 0.75,
			BounceDuration = 0.55,
			DramaticPauseDuration = 1,
			ImpactParticleLifetime = 0.5,
			ShakePreDuration = 1.75,
			ShakePostDuration = 1,
			PauseDuration = 5,
			GrowScreenShakeDurationBuffer = 2,
			GrowHugeDuration = 4,
			GrowTitanicDuration = 8.5,
			GrowTitanicAuraDelay = 5.5,
			GrowTitanicAuraScreenShakeDuration = 1,
			GrowTitanicAuraParticleLifetime = 1,
			ExplodeParticleLifetime = 1.5,
			ExplodeTitanicParticleDuration = 7,
			ExplodeUpscaleDuration = 1,
			SpawnPetDelay = 0.25,
			PetLookAtPlayerDuration = 2.5,
			PetLookAtPlayerDurationOther = 4,
			PetFlyIntoPlayerDuration = 0.7,
			PetCameraMoveDuration = 0.5,
			PetCameraIdleDuration = 2.5,
			PetCameraFadeDuration = 0.5
		},
		Other = {
			BounceHeight = 2.25,
			ShakePitchMagnitude = -30,
			ShakePitchA = 1.5,
			ShakePitchB = 7,
			ShakeRollMagnitude = 30,
			ShakeRollA = 1.5,
			ShakeRollB = 7,
			GrowHugeScale = 3,
			GrowHugeScreenShakeMagnitude = 0.2,
			GrowHugeShakeRate = 60,
			GrowHugeShakeMagnitude = 5,
			GrowTitanicScale = 7,
			GrowTitanicScreenShakeMagnitude = 0.4,
			GrowTitanicShakeRate = 60,
			GrowTitanicShakeMagnitude = 10,
			GrowTitanicAuraScreenShakeMagnitude = 2,
			GrowTitanicAuraScreenShakeSmoothness = 0.1,
			GrowScreenShakeSmoothness = 0.5,
			GrowScreenShakeDistance = 400,
			ExplodeUpscaleSize = 3,
			OpenRareChance = 10,
			ExplodeTitanicShakeMagnitude = 1,
			ExplodeTitanicShakeSmoothness = 0.5,
			LuckyClickTimeout = 1,
			AnnouncementNotificationDuration = 5,
			PetLookAtPlayerFloatRate = 0.5,
			PetLookAtPlayerFloatHeight = 1,
			PetCameraDistance = 7.2,
			PetCameraTargetEMA = 0.1,
			PetCameraTargetRate = 60,
			PetCameraIdleNoUpdatesAfter = 0.75
		}
	};
	local v5 = m_Library.Directory.Pets[t_petData.id];
	assert(v5);
	local u2 = m_Library.Directory.Eggs[t_eggId];
	assert(u2);
	local Model = Instance.new("Model");
	Model:SetAttribute("Target", t_position);
	local Clone_ret2 = u2.model:Clone();
	Clone_ret2.Anchored = true;
	Clone_ret2.Parent = Model;
	Model.PrimaryPart = Clone_ret2;
	Model:PivotTo(CFrame.new(t_origin) * CFrame.fromOrientation(0, math.pi * 2 * math.random(), 0));
	local v6 = t_position + Vector3.new(0, Clone_ret2.Size.Y / 2, 0);
	for _, descendant2 in ipairs(Model:GetDescendants()) do
		if not descendant2:IsA("BasePart") then continue end
		descendant2.CanCollide = false;
		descendant2.CanQuery = true;
		descendant2.CanTouch = true;
		descendant2.CastShadow = false;
	end
	local Bottom = Instance.new("Attachment");
	Bottom.Name = "Bottom";
	Bottom.Position = Vector3.new(0, -Clone_ret2.Size.Y / 2, 0);
	Bottom.Parent = Clone_ret2;
	local Top = Instance.new("Attachment");
	Top.Name = "Top";
	Top.Position = Vector3.new(0, Clone_ret2.Size.Y / 2, 0);
	Top.Parent = Clone_ret2;
	local Clone_ret3 = script.Trail:Clone();
	Clone_ret3.Attachment0 = Bottom;
	Clone_ret3.Attachment1 = Top;
	Clone_ret3.Lifetime = table5.Timing.TrailLifetime;
	Clone_ret3.Parent = Clone_ret2;
	local ClickDetector = Instance.new("ClickDetector");
	ClickDetector.MaxActivationDistance = math.huge;
	ClickDetector.CursorIcon = "rbxassetid://12429634668";
	ClickDetector.Parent = Clone_ret2;
	local RaycastParams_new_ret = RaycastParams.new();
	RaycastParams_new_ret.FilterDescendantsInstances = {Model};
	RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
	RaycastParams_new_ret.RespectCanCollide = false;
	RaycastParams_new_ret.IgnoreWater = true;
	local os_clock_ret = nil;
	ClickDetector.MouseClick:Connect(function() -- Line: 341
		--[[
			Upvalues:
				[1] = os_clock_ret
				[2] = m_Library
				[3] = Clone_ret2
				[4] = RaycastParams_new_ret
				[5] = t_petData
		--]]
		os_clock_ret = os.clock();
		local MouseLocation = m_Library.UserInputService:GetMouseLocation();
		local v50 = m_Library.Player.Camera();
		local ViewportPointToRay_ret = v50:ViewportPointToRay(MouseLocation.X, MouseLocation.Y, 0);
		local t_Origin = ViewportPointToRay_ret.Origin;
		local v51 = ViewportPointToRay_ret.Direction.Unit * (t_Origin - Clone_ret2.Position).Magnitude;
		local v52 = t_Origin + v51;
		local Raycast_ret = workspace:Raycast(t_Origin, v51, RaycastParams_new_ret);
		if Raycast_ret then
			v52 = Raycast_ret.Position;
		end
		local v53, v54 = m_Library.Functions.CreateParticleHost(v52);
		local _, v55 = m_Library.Functions.Emit(v54, nil, script:WaitForChild("LuckyParticle"));
		m_Library.Functions.AddDebris(v53, v55);
		m_Library.Network.Fire("Exclusive Eggs: Lucky", t_petData.uid);
	end);
	local u3 = m_Library.Functions.Scaler();
	u3(Model, 0);
	local u4 = m_Library.Functions.Transparency();
	Model.Parent = ExclusiveEggs;
	task.wait((p5.partyIndex - 1) * table5.Timing.DelayPerEgg);
	local v7 = (p5.partyIndex - 1) * 0.1 + 0.7;
	m_Library.Audio.Play(table3.EGG_SPAWN, Clone_ret2, v7, 0.75, 350);
	m_Library.Functions.RenderStepped(function(_, p26) -- Line: 404
		--[[
			Upvalues:
				[1] = m_Library
				[2] = u3
				[3] = Model
		--]]
		local v56 = m_Library.Functions.Easing(p26, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
		u3(Model, v56);
	end, table5.Timing.UpscaleDuration, true);
	u3(Model, 1);
	m_Library.Audio.Play(table3.EGG_THROW, Clone_ret2, (p5.partyIndex - 1) * 0.05 + 1, 0.5, 175);
	local u5 = m_Library.Functions.Bezier(t_origin, autoControlPoint(t_origin, v6), v6);
	local v8 = m_Library.Functions.RenderStepped(function(_, p37) -- Line: 427
		--[[
			Upvalues:
				[1] = m_Library
				[2] = Model
				[3] = u5
		--]]
		local v63 = m_Library.Functions.Easing(p37, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
		Model:PivotTo(CFrame.new(u5(v63)) * Model:GetPivot().Rotation);
	end, table5.Timing.MoveDuration, true);
	v8:Wait();
	Model:PivotTo(CFrame.new(v6) * Model:GetPivot().Rotation);
	m_Library.Audio.Play(table3.EGG_LAND, Clone_ret2, 1, 0.55, 250);
	local v9, v10 = m_Library.Functions.CreateParticleHost(t_position);
	local _, v11 = m_Library.Functions.Emit(v10, function(p38) -- Line: 440
		--[[
			Upvalues:
				[1] = table5
		--]]
		p38.Lifetime = NumberRange.new(p38.Lifetime.Min * table5.Timing.ImpactParticleLifetime, p38.Lifetime.Max * table5.Timing.ImpactParticleLifetime);
	end, table.unpack(script:WaitForChild("Impact"):GetChildren()));
	m_Library.Functions.AddDebris(v9, v11);
	local Pivot = Model:GetPivot();
	local v12 = m_Library.Functions.RenderStepped(function(_, p39) -- Line: 452
		--[[
			Upvalues:
				[1] = m_Library
				[2] = Pivot
				[3] = table5
				[4] = Model
		--]]
		p39 = 1 - m_Library.Functions.Easing(p39, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
		Model:PivotTo(Pivot + Vector3.new(0, table5.Other.BounceHeight, 0) * p39);
	end, table5.Timing.BounceDuration, true);
	v12:Wait();
	Model:PivotTo(Pivot);
	task.wait(table5.Timing.DramaticPauseDuration);
	Clone_ret3:Destroy();
	local u6 = nil;
	local Pivot2 = Model:GetPivot();
	local u7 = table5.Timing.ShakePreDuration + table5.Timing.ShakePostDuration;
	local u8 = 0;
	local v13 = m_Library.Functions.RenderStepped(function(_, p40) -- Line: 472
		--[[
			Upvalues:
				[1] = table2
				[2] = p5
				[3] = table5
				[4] = u8
				[5] = u7
				[6] = u6
				[7] = m_Library
				[8] = table3
				[9] = Clone_ret2
				[10] = Pivot2
				[11] = Model
		--]]
		local v64 = 0;
		local table6 = {};
		for key13, _ in pairs(table2) do
			if p5 == key13 or key13.completed or p5.priority <= key13.priority then continue end
			table6[key13.priority] = true;
		end
		for _, _ in pairs(table6) do
			v64 = v64 + table5.Timing.PauseDuration;
		end
		u8 = math.max(u8, v64);
		if u7 + u8 <= p40 then
			return true;
		end
		if p40 >= 0.25 and not u6 then
			u6 = m_Library.Audio.Play(table3.EGG_SHAKE, Clone_ret2, {
				0.9,
				1.1
			}, 0.035, 175);
		end
		local v65 = p40 / (table5.Timing.ShakePreDuration + table5.Timing.ShakePostDuration);
		local math_clamp_ret = math.clamp(v65, 0, 1.5);
		local math_clamp_ret2 = math.clamp(p40 / table5.Timing.ShakePreDuration, 0, 1);
		local v66 = m_Library.Functions.Easing(math_clamp_ret2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		Model:PivotTo(Pivot2 * CFrame.fromOrientation(math.rad(table5.Other.ShakePitchMagnitude * math.sin(math.pi * 2 * (v65 * (math_clamp_ret * table5.Other.ShakePitchA)) * table5.Other.ShakePitchB) * v66), 0, (math.rad(table5.Other.ShakeRollMagnitude * math.sin(math.pi * 2 * (v65 * (math_clamp_ret * table5.Other.ShakeRollA)) * table5.Other.ShakeRollB) * v66))));
	end);
	v13:Wait();
	Model:PivotTo(Pivot2);
	if u6 then
		u6:Stop();
		u6:Destroy();
	end
	ClickDetector:Destroy();
	local u9 = 1;
	local v14 = 0;
	local u10 = 0;
	local u11 = 0;
	if v5.titanic then
		u9 = table5.Other.GrowTitanicScale;
		v14 = table5.Timing.GrowTitanicDuration;
		u10 = table5.Other.GrowTitanicScreenShakeMagnitude;
		u11 = table5.Other.GrowTitanicShakeRate;
		local _ = table5.Other.GrowTitanicShakeMagnitude;
	elseif v5.huge then
		u9 = table5.Other.GrowHugeScale;
		v14 = table5.Timing.GrowHugeDuration;
		u10 = table5.Other.GrowHugeScreenShakeMagnitude;
		u11 = table5.Other.GrowHugeShakeRate;
		local _ = table5.Other.GrowHugeShakeMagnitude;
	end
	if u9 > 1 then
		local v32 = nil;
		if v5.titanic then
			v32 = m_Library.Audio.Play(table3.EGG_GROW_TITANIC, Clone_ret2.CFrame, 1, 3.25, 1000);
		elseif v5.huge then
			v32 = m_Library.Audio.Play(table3.EGG_GROW_HUGE, Clone_ret2.CFrame, 1, 2.25, 700);
		end
		if u10 > 0 then
			local v67 = t_player == m_Library.LocalPlayer;
			if not v67 then
				local v78 = m_Library.Player.Optional.PrimaryPart(m_Library.LocalPlayer);
				if v78 and (v78.Position - t_origin).Magnitude < table5.Other.GrowScreenShakeDistance then
					v67 = true;
				end
			end
			if v67 then
				local u25 = v14 + table5.Timing.GrowScreenShakeDurationBuffer;
				m_Library.Shake.Create(u25, u10, table5.Other.GrowScreenShakeSmoothness, true);
				if v5.titanic then
					task.delay(table5.Timing.GrowTitanicAuraDelay, function() -- Line: 601
						--[[
							Upvalues:
								[1] = m_Library
								[2] = table5
								[3] = u25
								[4] = u10
						--]]
						m_Library.Shake.Create(table5.Timing.GrowTitanicAuraScreenShakeDuration, table5.Other.GrowTitanicAuraScreenShakeMagnitude, table5.Other.GrowTitanicAuraScreenShakeSmoothness, false);
						task.delay(table5.Timing.GrowTitanicAuraScreenShakeDuration, function() -- Line: 610
							--[[
								Upvalues:
									[1] = m_Library
									[2] = u25
									[3] = table5
									[4] = u10
							--]]
							m_Library.Shake.Create(u25 - table5.Timing.GrowTitanicAuraDelay - table5.Timing.GrowTitanicAuraScreenShakeDuration, u10, table5.Other.GrowScreenShakeSmoothness, false);
						end);
					end);
				end
			end
		end
		if v5.titanic then
			task.delay(table5.Timing.GrowTitanicAuraDelay, function() -- Line: 624
				--[[
					Upvalues:
						[1] = m_Library
						[2] = Clone_ret2
						[3] = table5
						[4] = u9
				--]]
				local v105, v106 = m_Library.Functions.CreateParticleHost(Clone_ret2.Position);
				local _, v107 = m_Library.Functions.Emit(v106, function(p58) -- Line: 628
					--[[
						Upvalues:
							[1] = table5
							[2] = m_Library
							[3] = u9
					--]]
					p58.Lifetime = NumberRange.new(p58.Lifetime.Min * table5.Timing.GrowTitanicAuraParticleLifetime, p58.Lifetime.Max * table5.Timing.GrowTitanicAuraParticleLifetime);
					m_Library.Functions.ScaleParticle(p58, u9 * 2.5);
				end, table.unpack(script:WaitForChild("TitanicAura"):GetChildren()));
				m_Library.Functions.AddDebris(v105, v107);
			end);
		end
		local table7 = {};
		if v5.titanic then
			for _, descendant15 in ipairs(Model:GetDescendants()) do
				for _, val18 in ipairs(table1) do
					local _SELECTIONFX = Instance.new("Decal");
					_SELECTIONFX.Texture = "rbxassetid://6381483576";
					_SELECTIONFX.Name = "_SELECTIONFX";
					_SELECTIONFX.Transparency = 1;
					_SELECTIONFX.Face = val18;
					_SELECTIONFX.Parent = descendant15;
					table.insert(table7, _SELECTIONFX);
				end
			end
			local v68 = m_Library.Functions.RenderStepped(function(_, p57) -- Line: 657
				--[[
					Upvalues:
						[1] = m_Library
						[2] = table7
				--]]
				local v108 = m_Library.Functions.Easing(p57, Enum.EasingStyle.Circular, Enum.EasingDirection.In);
				for _, val21 in ipairs(table7) do
					val21.Transparency = 1 - v108;
				end
			end, v14, true);
			v68:Then(function() -- Line: 662
				--[[
					Upvalues:
						[1] = table7
				--]]
				for _, val19 in ipairs(table7) do
					val19:Destroy();
				end
			end);
		end
		local Pivot7 = Model:GetPivot();
		local v33 = m_Library.Functions.RenderStepped(function(_, p49) -- Line: 671
			--[[
				Upvalues:
					[1] = m_Library
					[2] = u3
					[3] = Model
					[4] = u9
					[5] = Pivot7
					[6] = u11
					[7] = u10
			--]]
			local v79 = m_Library.Functions.Easing(p49, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut);
			u3(Model, (1 - v79) * 1 + u9 * v79, (Vector3.new(0, -0.5, 0)));
			local Pivot8 = Model:GetPivot();
			Model:PivotTo(Pivot8 - (Pivot8.Position - Pivot7.Position) * Vector3.new(1, 0, 1) + Vector3.new(math.noise(v79 * u11, -u10, u10), 0, math.noise(-v79 * u11, -u10, u10)));
		end, v14, true);
		v33:Wait();
		u3(Model, u9);
		local Pivot9 = Model:GetPivot();
		Model:PivotTo(Pivot9 - (Pivot9.Position - Pivot7.Position) * Vector3.new(1, 0, 1));
		for _, val7 in ipairs(table7) do
			val7:Destroy();
		end
		if v32 then
			v32:Stop();
			v32:Destroy();
		end
	end
	if v5.titanic then
		m_Library.Audio.Play(table3.EGG_OPEN_TITANIC, Clone_ret2.CFrame, 1, 6, 1000);
	elseif v5.huge then
		m_Library.Audio.Play(table3.EGG_OPEN_HUGE, Clone_ret2.CFrame, 1, 3, 700);
	elseif p5.chance <= table5.Other.OpenRareChance / 100 then
		m_Library.Audio.Play(table3.EGG_OPEN_RARE, Clone_ret2.CFrame, 1, 1.1, 500);
	else
		m_Library.Audio.Play(table3.EGG_OPEN, Clone_ret2.CFrame, 1, 1, 400);
	end
	local v15, v16 = m_Library.Functions.CreateParticleHost(Clone_ret2.Position);
	local _, v17 = m_Library.Functions.Emit(v16, function(p41) -- Line: 720
		--[[
			Upvalues:
				[1] = table5
				[2] = m_Library
				[3] = u9
		--]]
		p41.Lifetime = NumberRange.new(p41.Lifetime.Min * table5.Timing.ExplodeParticleLifetime, p41.Lifetime.Max * table5.Timing.ExplodeParticleLifetime);
		m_Library.Functions.ScaleParticle(p41, u9);
		local math_ceil_ret = math.ceil((p41:GetAttribute("EmitCount") or p41.Rate) * u9);
		p41:SetAttribute("EmitCount", math_ceil_ret);
	end, table.unpack(script:WaitForChild("Explode"):GetChildren()));
	m_Library.Functions.AddDebris(v15, v17);
	if v5.titanic then
		local v34, v35 = m_Library.Functions.CreateParticleHost(Clone_ret2.Position);
		local _, v36 = m_Library.Functions.Emit(v35, function(p50) -- Line: 742
			--[[
				Upvalues:
					[1] = table5
			--]]
			p50.Lifetime = NumberRange.new(p50.Lifetime.Min * table5.Timing.ExplodeParticleLifetime, p50.Lifetime.Max * table5.Timing.ExplodeParticleLifetime);
		end, table.unpack(script:WaitForChild("TitanicExplode"):GetChildren()));
		m_Library.Functions.AddDebris(v34, v36);
		local u21, _ = m_Library.Functions.CreateParticleHost(t_position);
		local Children = script:WaitForChild("TitanicExplodeAOE"):GetChildren();
		for key8, val8 in ipairs(Children) do
			local Clone_ret4 = val8:Clone();
			Children[key8] = Clone_ret4;
			Clone_ret4.Parent = u21;
		end
		task.delay(table5.Timing.ExplodeTitanicParticleDuration, function() -- Line: 760
			--[[
				Upvalues:
					[1] = Children
					[2] = m_Library
					[3] = u21
			--]]
			local v73 = 0;
			for _, val16 in ipairs(Children) do
				val16.Enabled = false;
				v73 = math.max(v73, val16.Lifetime.Max);
			end
			m_Library.Functions.AddDebris(u21, v73);
		end);
		m_Library.Shake.Create(table5.Timing.ExplodeTitanicParticleDuration, table5.Other.ExplodeTitanicShakeMagnitude, table5.Other.ExplodeTitanicShakeSmoothness, true);
	end
	local Pivot3 = Model:GetPivot();
	for _, descendant3 in ipairs(Model:GetDescendants()) do
		if not descendant3:IsA("MeshPart") then continue end
		descendant3.TextureID = "";
		descendant3.Color = Color3.new(1, 1, 1);
		descendant3.Material = Enum.Material.SmoothPlastic;
	end
	m_Library.Functions.RenderStepped(function(_, p27) -- Line: 790
		--[[
			Upvalues:
				[1] = m_Library
				[2] = u3
				[3] = Model
				[4] = u9
				[5] = table5
				[6] = u4
		--]]
		local v57 = m_Library.Functions.Easing(p27, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
		u3(Model, u9 * (1 - v57) + u9 * table5.Other.ExplodeUpscaleSize * v57, (Vector3.new(0, -0.5, 0)));
		u4(Model, 1, v57);
	end, table5.Timing.ExplodeUpscaleDuration, true);
	u3(Model, u9 * table5.Other.ExplodeUpscaleSize, (Vector3.new(0, -0.5, 0)));
	u4(Model, 1, 1);
	local u12 = m_Library.PetCmds.Spawn(t_petData, t_player, true);
	local createPetGui_ret = createPetGui(u12, t_petData);
	local t_part = u12.part;
	local function getPetTarget() -- Line: 808
		--[[
			Upvalues:
				[1] = t_origin
				[2] = m_Library
				[3] = t_player
		--]]
		local v58 = t_origin;
		local v59 = m_Library.Player.PrimaryPart(t_player);
		if v59 then
			v58 = v59:GetPivot().Position;
		end
		return v58;
	end
	local function lookAtTarget(p28, p29) -- Line: 821
		local vec3 = Vector3.new(p29.X, p28.Y, p29.Z);
		if (p28.Position - vec3).Magnitude < 0.001 then
			return p28;
		end
		return CFrame.lookAt(p28.Position, vec3);
	end
	local v19 = t_origin;
	local v20 = m_Library.Player.PrimaryPart(t_player);
	if v20 then
		v19 = v20:GetPivot().Position;
	end
	t_part:PivotTo(lookAtTarget(Pivot3, v19));
	local u13 = t_player == m_Library.LocalPlayer and u1.add() or nil;
	task.wait(table5.Timing.SpawnPetDelay);
	local v21, v22, v23 = m_Library.Shared.HatchMessage(t_petData, t_player);
	if v23 then
		m_Library.ChatMsg.New(v21, v22);
	end
	if v5.titanic or v5.huge then
		m_Library.Signal.Fire("Notification", v21, {
			color = v22,
			force = true,
			time = table5.Other.AnnouncementNotificationDuration
		});
	end
	local u14 = m_Library.Functions.RenderStepped(function(p42, p43) -- Line: 859
		--[[
			Upvalues:
				[1] = t_part
				[2] = u12
				[3] = m_Library
				[4] = t_petData
		--]]
		if not t_part.Parent then
			return true;
		end
		if u12.moving then
			local v80 = u12;
			v80.movingTick = v80.movingTick + p42;
		else
			u12.movingTick = 0;
		end
		m_Library.PetCmds.Effects(u12, t_petData, p43, p42, true);
	end);
	t_part.Destroying:Connect(function() -- Line: 871
		--[[
			Upvalues:
				[1] = u14
		--]]
		u14:Disconnect();
	end);
	t_part.Parent = ExclusiveEggPets;
	local v24 = t_player == m_Library.LocalPlayer and table5.Timing.PetLookAtPlayerDuration or table5.Timing.PetLookAtPlayerDurationOther;
	local Pivot4 = t_part:GetPivot();
	local v25 = m_Library.Functions.RenderStepped(function(_, p44) -- Line: 883
		--[[
			Upvalues:
				[1] = Pivot4
				[2] = table5
				[3] = t_origin
				[4] = m_Library
				[5] = t_player
				[6] = t_part
		--]]
		local v69 = Pivot4 + Vector3.new(0, math.sin(math.pi * 2 * p44 * table5.Other.PetLookAtPlayerFloatRate) * table5.Other.PetLookAtPlayerFloatHeight, 0);
		local v70 = t_origin;
		local v71 = m_Library.Player.PrimaryPart(t_player);
		if v71 then
			v70 = v71:GetPivot().Position;
		end
		local vec3_2 = Vector3.new(v70.X, v69.Y, v70.Z);
		local v72 = (v69.Position - vec3_2).Magnitude < 0.001 and v69 or CFrame.lookAt(v69.Position, vec3_2);
		t_part:PivotTo(v72);
	end, v24, true);
	v25:Wait();
	Model:Destroy();
	local function hitCameraSFX(p30, p31) -- Line: 898
		--[[
			Upvalues:
				[1] = t_petData
				[2] = m_Library
				[3] = u2
		--]]
		if t_petData.r then
			m_Library.Audio.Play("rbxassetid://7503155199", p30, 1, p31 * 1, 100);
		elseif t_petData.g and not u2.isGolden then
			m_Library.Audio.Play("rbxassetid://7503155258", p30, 1, p31 * 0.85, 100);
		end
		if t_petData.sh then
			m_Library.Audio.Play("rbxassetid://11788145043", p30, 1, p31 * 1, 100);
		end
	end
	if t_player == m_Library.LocalPlayer then
		if t_player == m_Library.LocalPlayer then
			local _ = m_Library.Variables.OpeningEgg <= 0;
			local t_Variables2 = m_Library.Variables;
			t_Variables2.OpeningEgg = t_Variables2.OpeningEgg + 1;
			m_Library.Signal.Fire("Opening Egg", t_eggId);
		end
		local workspace_CurrentCamera = workspace.CurrentCamera;
		t_part.Parent = workspace_CurrentCamera;
		local function computeCameraSpace() -- Line: 927
			--[[
				Upvalues:
					[1] = u1
					[2] = u13
					[3] = m_Library
			--]]
			local v74 = u1.compute(u13);
			return m_Library.Functions.Map2(v74, Vector2.new(0, 0), Vector2.new(1, 1), Vector2.new(0.05, 0), Vector2.new(0.95, 0.85));
		end
		local function computePetCameraTarget(p45, p46) -- Line: 937
			--[[
				Upvalues:
					[1] = workspace_CurrentCamera
			--]]
			local v75 = workspace_CurrentCamera.ViewportSize * p45;
			local ViewportPointToRay_ret2 = workspace_CurrentCamera:ViewportPointToRay(v75.X, v75.Y, p46);
			return CFrame.new(ViewportPointToRay_ret2.Origin) * CFrame.lookAt(Vector3.new(), -ViewportPointToRay_ret2.Direction, workspace_CurrentCamera.CFrame.UpVector);
		end
		local function updateRelativePos(p47, p48) -- Line: 944
			--[[
				Upvalues:
					[1] = computeCameraSpace
					[2] = table5
			--]]
			local v76 = computeCameraSpace();
			local math_clamp_ret3 = math.clamp(1 - math.pow(1 - table5.Other.PetCameraTargetEMA, p48 * table5.Other.PetCameraTargetRate), 0, 1);
			p47 = p47:Lerp(v76, math_clamp_ret3);
			return p47;
		end
		local v37 = v5.titanic and 7.5 or v5.huge and 4.5 or 1.5;
		local v38 = (v37 + 0.5) / 2;
		local vec3_4 = Vector3.new(0, u12.bottom.Position.Y - v37 / 2, 0);
		local v39 = v38 * 1.3;
		createPetGui_ret.Size = UDim2.new(createPetGui_ret.Size.X.Scale / 2.5 * v39, createPetGui_ret.Size.X.Offset, createPetGui_ret.Size.Y.Scale * v39, createPetGui_ret.Size.Y.Offset);
		createPetGui_ret.StudsOffset = vec3_4;
		createPetGui_ret.AlwaysOnTop = true;
		local u23 = computeCameraSpace();
		local t_PetCameraDistance = table5.Other.PetCameraDistance;
		local u24 = v5.titanic and t_PetCameraDistance + 9.15 or v5.huge and t_PetCameraDistance + 2.7 or t_PetCameraDistance + 1.3;
		u12.moving = true;
		local Pivot6 = t_part:GetPivot();
		local v40 = m_Library.Functions.RenderStepped(function(p51, p52) -- Line: 992
			--[[
				Upvalues:
					[1] = m_Library
					[2] = u23
					[3] = table5
					[4] = computeCameraSpace
					[5] = u24
					[6] = workspace_CurrentCamera
					[7] = Pivot6
					[8] = t_part
			--]]
			local v81 = m_Library.Functions.Easing(p52, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
			local v82 = u23;
			local v83 = p51 * table5.Timing.PetCameraMoveDuration;
			local v84 = computeCameraSpace();
			local math_clamp_ret4 = math.clamp(1 - math.pow(1 - table5.Other.PetCameraTargetEMA, v83 * table5.Other.PetCameraTargetRate), 0, 1);
			u23 = v82:Lerp(v84, math_clamp_ret4);
			local v85 = u23;
			local v86 = u24;
			local v87 = workspace_CurrentCamera.ViewportSize * v85;
			local ViewportPointToRay_ret3 = workspace_CurrentCamera:ViewportPointToRay(v87.X, v87.Y, v86);
			local Lerp_ret = Pivot6:Lerp(CFrame.new(ViewportPointToRay_ret3.Origin) * CFrame.lookAt(Vector3.new(), -ViewportPointToRay_ret3.Direction, workspace_CurrentCamera.CFrame.UpVector), v81);
			t_part:PivotTo(Lerp_ret);
		end, table5.Timing.PetCameraMoveDuration, true);
		v40:Wait();
		u12.moving = false;
		hitCameraSFX(script, 1);
		local v41 = m_Library.Functions.RenderStepped(function(p53, p54) -- Line: 1006
			--[[
				Upvalues:
					[1] = table5
					[2] = u23
					[3] = computeCameraSpace
					[4] = u24
					[5] = workspace_CurrentCamera
					[6] = t_part
			--]]
			if p54 <= table5.Other.PetCameraIdleNoUpdatesAfter then
				local v109 = u23;
				local v110 = p53 * table5.Timing.PetCameraIdleDuration;
				local v111 = computeCameraSpace();
				local math_clamp_ret5 = math.clamp(1 - math.pow(1 - table5.Other.PetCameraTargetEMA, v110 * table5.Other.PetCameraTargetRate), 0, 1);
				u23 = v109:Lerp(v111, math_clamp_ret5);
			end
			local v88 = u23;
			local v89 = u24;
			local v90 = workspace_CurrentCamera.ViewportSize * v88;
			local ViewportPointToRay_ret4 = workspace_CurrentCamera:ViewportPointToRay(v90.X, v90.Y, v89);
			t_part:PivotTo(CFrame.new(ViewportPointToRay_ret4.Origin) * CFrame.lookAt(Vector3.new(), -ViewportPointToRay_ret4.Direction, workspace_CurrentCamera.CFrame.UpVector));
		end, table5.Timing.PetCameraIdleDuration, true);
		v41:Wait();
		local v42 = m_Library.Functions.RenderStepped(function(_, p55) -- Line: 1016
			--[[
				Upvalues:
					[1] = m_Library
					[2] = u23
					[3] = u24
					[4] = workspace_CurrentCamera
					[5] = t_part
					[6] = u4
					[7] = u3
			--]]
			local v91 = m_Library.Functions.Easing(p55, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
			local v92 = m_Library.Functions.Bezier2(u23, Vector2.new(0.5, 0.1), Vector2.new(0.5, 0.9));
			local v93 = v92(v91);
			local v94 = u24;
			local v95 = workspace_CurrentCamera.ViewportSize * v93;
			local ViewportPointToRay_ret5 = workspace_CurrentCamera:ViewportPointToRay(v95.X, v95.Y, v94);
			t_part:PivotTo(CFrame.new(ViewportPointToRay_ret5.Origin) * CFrame.lookAt(Vector3.new(), -ViewportPointToRay_ret5.Direction, workspace_CurrentCamera.CFrame.UpVector));
			local v96 = m_Library.Functions.Easing(p55, Enum.EasingStyle.Exponential, Enum.EasingDirection.In);
			u4(t_part, 1, v96);
			u3(t_part, 1 - v96);
		end, table5.Timing.PetCameraFadeDuration, true);
		v42:Wait();
		u4(t_part, 1, 1);
		u3(t_part, 0);
		if t_player == m_Library.LocalPlayer then
			local t_Variables = m_Library.Variables;
			t_Variables.OpeningEgg = t_Variables.OpeningEgg - 1;
			m_Library.Signal.Fire("Done Opening Egg", t_eggId);
			local _ = m_Library.Variables.OpeningEgg <= 0;
		end
	else
		local Pivot5 = t_part:GetPivot();
		u12.moving = true;
		local v43 = m_Library.Functions.RenderStepped(function(_, p56) -- Line: 1054
			--[[
				Upvalues:
					[1] = Pivot5
					[2] = t_origin
					[3] = m_Library
					[4] = t_player
					[5] = t_part
					[6] = u4
					[7] = u3
			--]]
			local v97 = Pivot5;
			local v98 = t_origin;
			local v99 = m_Library.Player.PrimaryPart(t_player);
			if v99 then
				v98 = v99:GetPivot().Position;
			end
			local v100 = v98;
			local v101 = m_Library.Functions.Bezier(Pivot5.Position, autoControlPoint(Pivot5.Position, v100), v100);
			local v102 = CFrame.new(v101(p56)) * v97.Rotation;
			local vec3_3 = Vector3.new(v100.X, v102.Y, v100.Z);
			local v103 = (v102.Position - vec3_3).Magnitude < 0.001 and v102 or CFrame.lookAt(v102.Position, vec3_3);
			t_part:PivotTo(v103);
			local v104 = m_Library.Functions.Easing(p56, Enum.EasingStyle.Exponential, Enum.EasingDirection.In);
			u4(t_part, 1, v104);
			u3(t_part, 1 - v104);
		end, table5.Timing.PetFlyIntoPlayerDuration, true);
		v43:Wait();
		u4(t_part, 1, 1);
		u3(t_part, 0);
		u12.moving = false;
		hitCameraSFX(t_part.Position, 0.5);
	end
	m_Library.Audio.Play(table3.PET_REMOVE, t_part.Position, m_Library.Random.number(0.95, 1.05), 0.4, 100);
	u14:Disconnect();
	t_part:Destroy();
	if u13 then
		u1.remove(u13);
	end
end
function performOpen(p6, p7, p8, p9, p10, p11) -- Line: 1098
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table2
	--]]
	m_Library.Asserts.Player(p6);
	m_Library.Asserts.finiteVector3(p7);
	m_Library.Asserts.string(p8);
	m_Library.Asserts.array.table(p9);
	m_Library.Asserts.array.finiteVector3(p10);
	m_Library.Asserts.array.number(p11);
	assert(m_Library.Directory.Eggs[p8]);
	assert(#p9 >= 1);
	assert(#p9 == #p10);
	assert(#p9 == #p11);
	if p6 == m_Library.LocalPlayer then
		local table10 = {};
		for _, val9 in ipairs(p9) do
			table.insert(table10, val9.uid);
		end
		m_Library.Signal.Fire("Hide Pets", table10);
	end
	local table8 = {};
	local v27 = #p9;
	for index1 = 1, v27 do
		local v44 = p9[index1];
		local v45 = p10[index1];
		local v46 = p11[index1];
		local v47 = m_Library.Directory.Pets[v44.id];
		local v48 = v47.titanic and 3 or v47.huge and 2 or 1;
		local table9 = {
			player = p6,
			origin = p7,
			eggId = p8,
			petData = v44,
			position = v45,
			chance = v46,
			priority = v48,
			partyIndex = index1,
			partyCount = v27,
			completed = false
		};
		table.insert(table8, table9);
		table2[table9] = true;
	end
	preloadAssets();
	local function onComplete() -- Line: 1175
		--[[
			Upvalues:
				[1] = p6
				[2] = m_Library
				[3] = p9
		--]]
		if p6 == m_Library.LocalPlayer then
			for _, val17 in ipairs(p9) do
				task.spawn(function() -- Line: 1179
					--[[
						Upvalues:
							[1] = m_Library
							[2] = val17
							[3] = p6
					--]]
					local v116, _ = m_Library.Network.Invoke("Equip Pet", val17.uid);
					if v116 then
						m_Library.PetCmds.LocalEquipPet(p6, val17.uid, true);
					end
				end);
			end
		end
	end
	local u16 = #table8;
	for _, val4 in ipairs(table8) do
		task.spawn(function() -- Line: 1192
			--[[
				Upvalues:
					[1] = m_Library
					[2] = val4
					[3] = table2
					[4] = p6
					[5] = u16
					[6] = onComplete
			--]]
			m_Library.Functions.wcall(function() -- Line: 1194
				--[[
					Upvalues:
						[1] = val4
				--]]
				performAnimation(val4);
			end);
			val4.completed = true;
			table2[val4] = nil;
			if p6 == m_Library.LocalPlayer then
				m_Library.Signal.Fire("Show Pets", {val4.petData.uid});
			end
			u16 = u16 - 1;
			if u16 <= 0 then
				onComplete();
			end
		end);
	end
end
function computePositions(p12, p13) -- Line: 1216
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table2
			[3] = t_ExclusiveEggHeightOffset
			[4] = t_ExclusiveEggMaxHeight
			[5] = t_ExclusiveEggSpacingRadius
			[6] = t_ExclusiveEggRadiusRange
			[7] = t_ExclusiveEggRadiusStep
	--]]
	local v28 = p12 or 1;
	local u17 = 360 / (v28 * 6);
	local t_Character = m_Library.LocalPlayer.Character;
	if not t_Character then
		return nil;
	end
	assert(t_Character);
	local t_PrimaryPart = t_Character.PrimaryPart;
	if not t_PrimaryPart then
		return nil;
	end
	assert(t_PrimaryPart);
	local Humanoid = t_Character:FindFirstChildOfClass("Humanoid");
	if not Humanoid then
		return nil;
	end
	assert(Humanoid);
	local Pivot10 = t_Character:GetPivot();
	local t_Position = Pivot10.Position;
	local u18 = t_Position - Pivot10.UpVector * Vector3.new(0, Humanoid.HipHeight + t_PrimaryPart.Size.Y / 2, 0);
	if not m_Library.WorldCmds.HasLoaded() then
		return nil;
	end
	local Map = m_Library.WorldCmds.GetMap();
	local table11 = {};
	for key5, _ in pairs(table2) do
		if key5.completed then continue end
		table.insert(table11, key5.position);
	end
	if p13 then
		for _, val10 in ipairs(p13) do
			table.insert(table11, val10);
		end
	end
	local table12 = {
		Map,
		m_Library.Things:WaitForChild("Comets")
	};
	local RaycastParams_new_ret2 = RaycastParams.new();
	RaycastParams_new_ret2.FilterDescendantsInstances = table12;
	RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
	RaycastParams_new_ret2.IgnoreWater = false;
	RaycastParams_new_ret2.RespectCanCollide = false;
	local function randomPosition(p32) -- Line: 1301
		--[[
			Upvalues:
				[1] = t_Position
		--]]
		local v60 = math.pi * 2 * math.random();
		return t_Position + Vector3.new(p32 * math.cos(v60), 0, p32 * math.sin(v60));
	end
	local function findGround(p33) -- Line: 1311
		--[[
			Upvalues:
				[1] = t_ExclusiveEggHeightOffset
				[2] = t_ExclusiveEggMaxHeight
				[3] = RaycastParams_new_ret2
		--]]
		local Raycast_ret2 = workspace:Raycast(p33 + Vector3.new(0, t_ExclusiveEggHeightOffset, 0), Vector3.new(0, -(t_ExclusiveEggMaxHeight + t_ExclusiveEggHeightOffset), 0), RaycastParams_new_ret2);
		if not Raycast_ret2 then
			return nil;
		end
		assert(Raycast_ret2);
		local t_Instance = Raycast_ret2.Instance;
		if not t_Instance then
			return nil;
		end
		assert(t_Instance);
		return Raycast_ret2;
	end
	local function hasConflict(p34) -- Line: 1342
		--[[
			Upvalues:
				[1] = table11
				[2] = t_ExclusiveEggSpacingRadius
		--]]
		for _, val11 in ipairs(table11) do
			if (p34 - val11).Magnitude > t_ExclusiveEggSpacingRadius * 2 then continue end
			return true;
		end
		return false;
	end
	local function canSee(p35, p36) -- Line: 1357
		--[[
			Upvalues:
				[1] = t_ExclusiveEggSpacingRadius
				[2] = t_Position
				[3] = u18
				[4] = RaycastParams_new_ret2
		--]]
		local workspace_CurrentCamera2 = workspace.CurrentCamera;
		local v61 = p35 + Vector3.new(0, t_ExclusiveEggSpacingRadius, 0);
		local vec3_5 = Vector3.new(0, 0.25, 0);
		local table13 = {
			{
				workspace_CurrentCamera2.Focus.Position,
				v61
			},
			{
				t_Position,
				v61
			},
			{
				u18 + vec3_5,
				v61
			},
			{
				workspace_CurrentCamera2.Focus.Position,
				p35
			},
			{
				t_Position,
				p35
			},
			{
				u18 + vec3_5,
				p35
			}
		};
		for _, val12 in ipairs(table13) do
			local v77 = val12[1];
			local Raycast_ret3 = workspace:Raycast(v77, val12[2] - v77, RaycastParams_new_ret2);
			if not Raycast_ret3 then continue end
			assert(Raycast_ret3);
			if Raycast_ret3.Instance == p36 then continue end
			return false;
		end
		return true;
	end
	local function tryFind() -- Line: 1402
		--[[
			Upvalues:
				[1] = Pivot10
				[2] = t_ExclusiveEggRadiusRange
				[3] = t_ExclusiveEggRadiusStep
				[4] = u17
				[5] = t_ExclusiveEggSpacingRadius
				[6] = t_Position
				[7] = findGround
				[8] = table11
				[9] = canSee
		--]]
		local table14 = {
			-1,
			1
		};
		local _, ToOrientation_ret2, _ = Pivot10:ToOrientation();
		local v62 = ToOrientation_ret2 + math.pi / 2;
		for index3 = t_ExclusiveEggRadiusRange.X, t_ExclusiveEggRadiusRange.Y, t_ExclusiveEggRadiusStep do
			for index4 = 0, 180, u17 do
				for _, val20 in ipairs(table14) do
					local v112 = index4 * val20;
					local v113 = t_ExclusiveEggSpacingRadius + index3;
					local v114 = math.rad(v112) - v62;
					local v115 = findGround(t_Position + Vector3.new(v113 * math.cos(v114), 0, v113 * math.sin(v114)));
					if not v115 then continue end
					assert(v115);
					local t_Position2 = v115.Position;
					local control1;
					for _, val22 in ipairs(table11) do
						if (t_Position2 - val22).Magnitude <= t_ExclusiveEggSpacingRadius * 2 then
							control1 = 1;
							break;
						end
					end
					local bool1;
					if control1 == nil then
						bool1 = false;
					elseif control1 == 1 then
						bool1 = true;
					end
					if bool1 or not canSee(t_Position2, v115.Instance) then continue end
					return t_Position2;
				end
			end
		end
		return nil;
	end
	local table15 = {};
	for index2 = 1, v28 do
		local v49 = tryFind();
		if not v49 then
			return nil;
		end
		assert(v49);		
		table.insert(table15, v49);
		table.insert(table11, v49);
	end
	return table15;
end
function requestToOpen(p14, p15) -- Line: 1473
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table3
	--]]
	m_Library.Asserts.string(p14);
	m_Library.Asserts.integer(p15);
	assert(p15 > 0);
	local computePositions_ret = computePositions(p15);
	if not computePositions_ret then
		return false, "Not enough space, try a more open area!";
	end
	assert(computePositions_ret);
	m_Library.Audio.Play(table3.INVENTORY_OPEN, script, 1, 1);
	local v30, v31 = m_Library.Network.Invoke("Exclusive Eggs: Open", p14, p15, computePositions_ret);
	return v30, v31;
end
m_Library.Signal.Invoked("Exclusive Eggs: Open").OnInvoke = function(p16, p17) -- Line: 1505
	return requestToOpen(p16, p17);
end
m_Library.Network.Fired("Exclusive Eggs: Animation"):Connect(function(p18, p19, p20, p21, p22, p23) -- Line: 1517
	performOpen(p18, p19, p20, p21, p22, p23);
end);
m_Library.Network.Invoked("Exclusive Eggs: Compute Positions").OnInvoke = function(p24, p25) -- Line: 1535
	return computePositions(p24, p25);
end
