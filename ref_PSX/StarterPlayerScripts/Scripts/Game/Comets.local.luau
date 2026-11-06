-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local table1 = {};
function HasLanded(p1) -- Line: 38
	return p1 and workspace:GetServerTimeNow() + 0.5 >= p1.EndTime;
end
function CometAnimation(p2) -- Line: 43
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if not p2 or HasLanded(p2) then return end
	animating = true;
	local Clone_ret = m_Library.Assets.Models.Comets:FindFirstChild(p2.Type):Clone();
	local Model = Instance.new("Model");
	Clone_ret.Parent = Model;
	Model.PrimaryPart = Clone_ret;
	if p2.Type == "Massive Comet" then
		local v18 = m_Library.Functions.Scaler();
		v18(Model, 3);
	end
	p2.Model = Clone_ret;
	local v1 = p2.EndPosition + Vector3.new(0, Clone_ret.Size.Y / 2 - Clone_ret.Size.Y / 3, 0);
	local v2 = (p2.EndTime - workspace:GetServerTimeNow()) / p2.Speed;
	print(v1)
	warn(p2.StartPosition.Z, p2.EndPosition.Z)
	local v3 = p2.StartPosition.Y - v1.Y;
	local v4 = v3 * 0.4663076581549986;
	Clone_ret.Position = v1 + Vector3.new(0, v3 * v2, v4);
	Clone_ret.Orientation = Vector3.new(25, 0, 0);
	Model.Parent = m_Library.Things:WaitForChild("Comets");
	local v5 = p2.Speed * v2;
	local TweenInfo_new_ret = TweenInfo.new(v5, Enum.EasingStyle.Circular, Enum.EasingDirection.In, 0);
	p2.TravelTween = m_Library.TweenService:Create(Clone_ret, TweenInfo_new_ret, {Position = v1});
	p2.TravelTween:Play();
	p2.TravelTween.Completed:Connect(function(p19) -- Line: 90
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = m_Library
				[3] = p2
		--]]
		if p19 == Enum.PlaybackState.Cancelled then return end
		Clone_ret.Transparency = 1;
		m_Library.Functions.AddDebris(Clone_ret, 5);
		for _, child5 in pairs(Clone_ret:GetChildren()) do
			if child5.Name == "Explosion" then continue end
			child5:Destroy();
		end
		local Explosion = Clone_ret:FindFirstChild("Explosion");
		for _, child6 in pairs(Explosion:GetChildren()) do
			child6:Emit(child6:GetAttribute("EmitCount") or 1);
		end
		animating = false;
		if p2.Coin then
			m_Library.Signal.Fire("Comets: Setup Breakable", p2.CoinId, p2.Coin);
		end
		local v21 = m_Library.Save.Get();
		if v21 then
			if p2.Type == "Massive Comet" and v21.World == p2.WorldId then
				m_Library.Shake.Create(2, 1, 0.3);
				local v34 = m_Library.Audio.Play("rbxassetid://12669914523", Clone_ret, 1, 0.6);
				v34.RollOffMaxDistance = 800;
				v34.RollOffMinDistance = 300;
				p2.LandSound = true;
				return;
			end
			if p2.Type == "Mini Comet" and v21.World == p2.WorldId then
				m_Library.Shake.Create(1, 0.3, 0.3);
				local v35 = m_Library.Audio.Play("rbxassetid://12669914204", Clone_ret, 1, 0.4);
				v35.RollOffMaxDistance = 500;
				v35.RollOffMinDistance = 200;
			end
		end
	end);
end
function CancelAnimation(p3) -- Line: 140
	animating = false;
	if not p3 then return end
	if p3.Model then
		p3.Model:Destroy();
		p3.Model = nil;
	end
	if p3.TravelTween then
		p3.TravelTween:Cancel();
		p3.TravelTween = nil;
	end
end
function RemoveBroken(p4) -- Line: 159
	if not p4 then return end
	if p4.BrokenModel then
		p4.BrokenModel:Destroy();
		p4.BrokenModel = nil;
	end
	if p4.Egg then
		p4.Egg:Destroy();
		p4.Egg = nil;
	end
end
function SpawnComet(p5, p6) -- Line: 176
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	local table2 = {
		Id = p5.Id,
		Type = p5.Type,
		WorldId = p5.WorldId,
		AreaId = p5.AreaId,
		CoinId = p5.CoinId,
		StartPosition = p5.SpawnPosition,
		EndPosition = p5.EndPosition,
		Speed = p5.Speed,
		EndTime = p5.EndTime,
		Destroyed = p5.Destroyed,
		Opened = p6
	};
	table1[table2.Id] = table2;
	local v6 = m_Library.Save.Get();
	if not v6 then return end
	if table2.Type == "Massive Comet" and not HasLanded(table2) then
		local v19 = table2.Speed * ((table2.EndTime - workspace:GetServerTimeNow()) / table2.Speed);
		local v20 = m_Library.Directory.Areas[table2.AreaId];
		m_Library.Signal.Fire("Notification", "A Massive Comet is landing in " .. v20.name .. "!", {
			color = Color3.fromRGB(0, 170, 255),
			force = true
		});
		m_Library.ChatMsg.New("A Massive Comet is landing in " .. v20.name .. "!", Color3.fromRGB(0, 170, 255));
		m_Library.Shake.Create(v19, 0.1, 0.3, true);
	elseif table2.Type == "Mini Comet" and not HasLanded(table2) then
		local _ = (table2.EndTime - workspace:GetServerTimeNow()) / table2.Speed;
		local v24 = m_Library.Directory.Areas[table2.AreaId];
		m_Library.Signal.Fire("Notification", "A Mini Comet is landing in " .. v24.name .. "!", {
			color = Color3.fromRGB(0, 170, 255),
			force = true
		});
		m_Library.ChatMsg.New("A Mini Comet is landing in " .. v24.name .. "!", Color3.fromRGB(0, 170, 255));
	end
	if v6.World == table2.WorldId and not table2.Destroyed then
		CometAnimation(table2);
	end
end
function SetupCometEgg(p7) -- Line: 221
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if not p7 or not p7.Coin then return end
	p7.Destroyed = true;
	local Clone_ret2 = m_Library.Assets.Models.Comets:WaitForChild("Massive Comet Broken"):Clone();
	local v7 = m_Library.Functions.Scaler();
	v7(Clone_ret2, 4);
	Clone_ret2.CFrame = p7.Coin.CFrame - Vector3.new(0, Clone_ret2.Size.Y / 6, 0);
	Clone_ret2.Parent = m_Library.Things:WaitForChild("Comets");
	p7.BrokenModel = Clone_ret2;
	local v8 = m_Library.Audio.Play("rbxassetid://12669914691", Clone_ret2, 1, 0.2, nil, nil, true);
	v8.RollOffMaxDistance = 300;
	v8.RollOffMinDistance = 100;
	if not p7.Opened then
		local Clone_ret3 = m_Library.Assets.Models.Comets:WaitForChild("Comet Egg"):Clone();
		Clone_ret3:SetPrimaryPartCFrame(CFrame.new(Clone_ret2.Position + Vector3.new(0, Clone_ret2.Size.Y / 4, 0)) * CFrame.Angles(0, 0, 1.5707963267948966));
		Clone_ret3.Parent = m_Library.Things:WaitForChild("Comets");
		p7.Egg = Clone_ret3;
		SetupEgg(p7);
	end
end
function RequestData() -- Line: 252
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v9, v10 = m_Library.Network.Invoke("Comets: Get Data");
	for _, val1 in pairs(v9) do
		SpawnComet(val1, v10[val1.Id][m_Library.LocalPlayer.UserId]);
	end
end
function GetCometByCoinId(p8) -- Line: 261
	--[[
		Upvalues:
			[1] = table1
	--]]
	for _, val2 in pairs(table1) do
		if val2.CoinId ~= p8 then continue end
		return val2;
	end
	return nil;
end
m_Library.Network.Fired("Comets: Announcement"):Connect(function(p9, p10) -- Line: 275
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v11 = m_Library.Directory.Areas[p9];
	m_Library.Signal.Fire("Notification", "A Massive Comet will land in " .. v11.name .. " in " .. m_Library.Functions.FormatTimeShort(p10, false) .. "!", {
		color = Color3.fromRGB(0, 170, 255),
		force = true
	});
	m_Library.ChatMsg.New("A Massive Comet will land in " .. v11.name .. " in " .. m_Library.Functions.FormatTimeShort(p10, false) .. "!", Color3.fromRGB(0, 170, 255));
	m_Library.Shake.Create(5, 0.25, 0.15, true);
	m_Library.Audio.Play("rbxassetid://12669908963", script, 1, 0.2);
end);
m_Library.Network.Fired("Comets: Spawn Client"):Connect(function(p11) -- Line: 285
	SpawnComet(p11, false);
end);
m_Library.Network.Fired("Comets: Massive Broken"):Connect(function(p12) -- Line: 290
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	print("BROKEN:   ",p12, table1)
	local v12 = table1[p12];
	print(v12)
	if not v12 or not v12.Coin then 
		print("???")
		return 
	end
	SetupCometEgg(v12);
	m_Library.Shake.Create(2, 1, 0.3);
	local v13 = m_Library.Audio.Play("rbxassetid://12669914084", v12.BrokenModel, 1, 0.6);
	v13.RollOffMaxDistance = 800;
	v13.RollOffMinDistance = 300;
end);
m_Library.Network.Fired("Comets: Removed"):Connect(function(p13) -- Line: 306
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	local v14 = table1[p13];
	if not v14 then return end
	if v14.Model then
		m_Library.WorldFX.CometDespawn(v14.Model.Position);
		v14.Model:Destroy();
	end
	if v14.TravelTween then
		v14.TravelTween:Cancel();
	end
	if v14.Egg then
		v14.Egg:Destroy();
	end
	if v14.BrokenModel then
		m_Library.WorldFX.CometDespawn(v14.BrokenModel.Position);
		v14.BrokenModel:Destroy();
	end
	table1[p13] = nil;
end);
m_Library.Signal.Invoked("Comets: Landed").OnInvoke = function(p14) -- Line: 335
	local CometByCoinId = GetCometByCoinId(p14);
	if not CometByCoinId then
		return nil;
	end
	return HasLanded(CometByCoinId);
end
m_Library.Signal.Fired("World Changed"):Connect(function(p15) -- Line: 346
	--[[
		Upvalues:
			[1] = table1
	--]]
	for _, val3 in pairs(table1) do
		if val3.WorldId == p15 then
			if not animating then
				CometAnimation(val3);
			end
			if not val3.Destroyed then continue end
			SetupCometEgg(val3);
			continue;
		end
		if animating then
			CancelAnimation(val3);
		end
		if not val3.Destroyed then continue end
		RemoveBroken(val3);
	end
end);
m_Library.Signal.Fired("Comets: Setup Breakable"):Connect(function(p16, p17) -- Line: 369
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local CometByCoinId2 = GetCometByCoinId(p16);
	if not CometByCoinId2 then return end
	local HasLanded_ret = HasLanded(CometByCoinId2);
	local Attachment = p17:WaitForChild("Attachment");
	p17.Transparency = HasLanded_ret and 0 or 1;
	for _, child4 in pairs(Attachment:GetChildren()) do
		child4.Enabled = HasLanded_ret;
	end
	p17:SetAttribute("PreventClick", not HasLanded_ret);
	local ClickDetector = p17:FindFirstChild("ClickDetector");
	if ClickDetector then
		ClickDetector.MaxActivationDistance = HasLanded_ret and m_Library.Settings.CoinGrabDistance or 0;
	end
	CometByCoinId2.Coin = p17;
	local v15 = m_Library.Audio.Play("rbxassetid://12669914691", p17, 1, 0.2, nil, nil, true);
	v15.RollOffMaxDistance = 300;
	v15.RollOffMinDistance = 100;
end);
task.spawn(RequestData);
local bool1 = false;
local table3 = {};
function SetupEgg(p18) -- Line: 409
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table3
			[3] = bool1
	--]]
	if not p18 or not p18.Egg then return end
	local t_Egg = p18.Egg.Egg;
	local bool2 = false;
	local v16, v17 = m_Library.Interact.Add(t_Egg.CFrame.p, {
		label = "Collect",
		dist = 20
	});
	table.insert(table3, v17);
	v16:Connect(function() -- Line: 420
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = p18
				[4] = table3
		--]]
		if not bool1 then
			bool1 = true;
			local v25, v26 = m_Library.Network.Invoke("Comets: Open Egg", p18.Id);
			if not v25 and v26 then
				m_Library.Message.New(v26);
				bool1 = false;
				return;
			end
			p18.Opened = true;
			p18.Egg:Destroy();
			for _, val8 in ipairs(table3) do
				val8();
			end
			table3 = {};
			bool1 = false;
		end
	end);
	local function Show() -- Line: 445
		--[[
			Upvalues:
				[1] = m_Library
				[2] = t_Egg
		--]]
		local v22 = m_Library.Directory.Eggs["Comet Egg"];
		local Clone_ret4 = m_Library.Assets.Billboards.EggInfo:Clone();
		local t_drops = v22.drops;
		local t_isGolden = v22.isGolden;
		local v23 = m_Library.Save.Get();
		if type(t_drops) == "string" then
			t_drops = m_Library.Directory.Eggs[t_drops].drops;
		end
		for key7, val7 in ipairs(t_drops) do
			local v27 = val7[1];
			local v28 = m_Library.Directory.Pets[v27];
			local t_rarity = v28.rarity;
			local v29 = val7[3];
			if t_rarity == "Secret" or v29 and not m_Library.Shared.IsHardcore then continue end
			local Clone_ret5 = m_Library.Assets.UI.EggInfo.Pet:Clone();
			Clone_ret5:SetAttribute("PetId", v27);
			local function CalculatePetChance() -- Line: 470
				--[[
					Upvalues:
						[1] = t_drops
						[2] = val7
				--]]
				local v37 = 0;
				for _, val11 in ipairs(t_drops) do
					v37 = v37 + val11[2];
				end
				return val7[2] / v37 * 100;
			end
			local v30 = 0;
			for _, val9 in ipairs(t_drops) do
				v30 = v30 + val9[2];
			end
			local v31 = val7[2] / v30 * 100;
			Clone_ret5.Thumbnail.Image = t_isGolden and v28.goldenThumbnail or v28.thumbnail;
			Clone_ret5.LayoutOrder = 9999 - v31;
			if v23.AutoDelete[v28.rarity] then
				Clone_ret5.DeleteImage.Visible = true;
			else
				Clone_ret5.DeleteImage.Visible = false;
			end
			if t_rarity == "Legendary" or t_rarity == "Mythical" or t_rarity == "Event" or t_rarity == "Exclusive" or v31 <= 0.0099 then
				Clone_ret5.Thumbnail.Chance.Text = "??";
				m_Library.GUIFX.Rainbow(Clone_ret5.Thumbnail.Chance, "TextColor3");
			else
				local math_clamp_ret = math.clamp(math.pow(0.9315, v31) * 94.2467 / 100, 0, 1);
				local Lerp_ret = Color3.fromRGB(49, 255, 39):Lerp(Color3.fromRGB(255, 75, 39), math_clamp_ret);
				local Color3_toHSV_ret1, Color3_toHSV_ret2, Color3_toHSV_ret3 = Color3.toHSV(Lerp_ret);
				local Color3_fromHSV_ret = Color3.fromHSV(Color3_toHSV_ret1, Color3_toHSV_ret2, Color3_toHSV_ret3 * 2);
				Clone_ret5.Thumbnail.Chance.TextColor3 = Color3_fromHSV_ret;
				Clone_ret5.Thumbnail.Chance.Text = m_Library.Functions.FormatChance(v31 / 100);
			end
			if v28.titanic then
				Clone_ret5.TitanicCrown.Visible = true;
			end
			Clone_ret5.Thumbnail.Position = UDim2.new(0, 0, 1, 0);
			Clone_ret5.Thumbnail.ImageTransparency = 1;
			m_Library.Functions.Tween(Clone_ret5.Thumbnail, {
				Position = UDim2.new(0, 0, 0, 0),
				ImageTransparency = 0
			}, {
				key7 / 9 / 3 + 0.45,
				Enum.EasingStyle.Quart,
				Enum.EasingDirection.Out
			});
			Clone_ret5.Parent = Clone_ret4.Frame.Pets;
		end
		Clone_ret4.Size = UDim2.new(0, 0, 0, 0);
		Clone_ret4.StudsOffset = Vector3.new(0, 4, 0);
		m_Library.Functions.Tween(Clone_ret4, {
			Size = UDim2.new(10, 0, 10, 0),
			StudsOffset = Vector3.new(0, 10, 0)
		}, {
			0.2,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		});
		local UIGridLayout = Clone_ret4.Frame.Pets:FindFirstChild("UIGridLayout");
		UIGridLayout:ApplyLayout();
		Clone_ret4.Parent = t_Egg;
	end
	local function Hide() -- Line: 538
		--[[
			Upvalues:
				[1] = t_Egg
				[2] = m_Library
		--]]
		local EggInfo = t_Egg:FindFirstChild("EggInfo");
		if EggInfo then
			m_Library.Functions.Tween(EggInfo, {
				Size = UDim2.new(0, 0, 0, 0),
				StudsOffset = Vector3.new(0, 4, 0)
			}, {
				0.15,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.In
			}).Completed:Connect(function() -- Line: 542
				--[[
					Upvalues:
						[1] = EggInfo
				--]]
				EggInfo:Destroy();
			end);
		end
	end
	local Random_new_ret = Random.new();
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 552
		--[[
			Upvalues:
				[1] = t_Egg
				[2] = Random_new_ret
				[3] = m_Library
		--]]
		local t_CFrame = t_Egg.CFrame;
		local NextNumber_ret = Random_new_ret:NextNumber(1, 10);
		local os_clock_ret = os.clock();
		local os_clock_ret2 = nil;
		while t_Egg and t_Egg.Parent do
			if not os_clock_ret2 or os.clock() - os_clock_ret2 >= 2 then
				local DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(t_Egg.CFrame.p);
				if DistanceFromCharacter_ret >= 300 then
					wait((math.clamp(DistanceFromCharacter_ret / 600, 0.5, 3)));
				else
					os_clock_ret2 = os.clock();
				end
			end
			local v32 = os.clock() - os_clock_ret + NextNumber_ret;
			t_Egg.CFrame = t_CFrame * CFrame.new(0, math.sin(v32 * 1) / 2, 0) * CFrame.Angles(0, v32, 0);
			m_Library.RenderStepped();
		end
	end);
	coroutine_wrap_ret();
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 577
		--[[
			Upvalues:
				[1] = m_Library
				[2] = p18
				[3] = t_Egg
				[4] = bool2
				[5] = Show
				[6] = Hide
		--]]
		local _ = m_Library.Save.Get();
		while p18.Egg and p18.Egg.Parent and p18.Egg:FindFirstChild("Egg") do
			local v33 = (t_Egg and m_Library.LocalPlayer:DistanceFromCharacter(t_Egg.CFrame.p) or 999) <= 20;
			local _ = t_Egg:FindFirstChild("EggInfo");
			if v33 and not bool2 then
				bool2 = true;
				Show();
			elseif bool2 and not v33 then
				bool2 = false;
				Hide();
			end
			m_Library.Heartbeat(5);
		end
	end);
	coroutine_wrap_ret2();
end
task.spawn(function() -- Line: 600
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
	--]]
	local u3 = 0;
	m_Library.RunService.Heartbeat:Connect(function(p20) -- Line: 604
		--[[
			Upvalues:
				[1] = u3
				[2] = table1
				[3] = m_Library
		--]]
		u3 = u3 + p20;
		if u3 > 1 then
			u3 = u3 - 1;
			for _, val10 in pairs(table1) do
				if val10.Type ~= "Massive Comet" or val10.LandSound or not HasLanded(val10) then continue end
				local v36 = m_Library.Save.Get();
				if not v36 or v36.World == val10.WorldId then continue end
				val10.LandSound = true;
				m_Library.Shake.Create(2, 0.2, 0.3);
				m_Library.Audio.Play("rbxassetid://12669913959", script, 1, 0.4);
			end
		end
	end);
end);
