-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Shared.IsTradingPlaza or m_Library.RunService:IsStudio();
local table1 = {};
local table2 = {};
local table3 = {};
local bool1 = false;
local Color3_fromHSV_ret = nil;
local table4 = {};
function ThrottleRequest(p1, p2) -- Line: 26
	--[[
		Upvalues:
			[1] = table4
	--]]
	if table4[p1] then
		return true;
	end
	table4[p1] = true;
	task.delay(p2 or 1, function() -- Line: 33
		--[[
			Upvalues:
				[1] = table4
				[2] = p1
		--]]
		table4[p1] = nil;
	end);
	return false;
end
function getStyle(p3) -- Line: 40
	if p3 == nil then
		return "Default Booth";
	end
	return p3;
end
function SetupModel(p4, p5) 
	local Map = m_Library.WorldCmds.GetMap();

	local Clone_ret = m_Library.Directory.Booths[getStyle(p5.Style)].Model:Clone();
	
	p5.Model = Clone_ret;
	SetupModelPosition(p4, p5.Model);
	local Interactive = Map:FindFirstChild("Interactive");
	local Booths = Interactive:FindFirstChild("Booths");
	Clone_ret.Parent = Booths;
end
function UpdateModel(p6, p7, p8) 
	if p8.Model then
		p8.Model:Destroy();
	end
	SetupModel(p7, p8);
	if p8.Owner == m_Library.LocalPlayer.UserId then
		SetupEditInteract(p6, p8);
		return;
	end
	SetupViewInteract(p6, p8);
end
function GetFullName(p9) -- Line: 79
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local str1 = "";
	local t_name = m_Library.Directory.Pets[p9.id].name;
	local t_g = p9.g;
	local t_r = p9.r;
	local t_dm = p9.dm;
	if t_g then
		str1 = "Golden ";
	elseif t_r then
		str1 = "Rainbow ";
	elseif t_dm then
		str1 = "Dark Matter ";
	end
	return str1 .. t_name;
end
function AttemptBuy(p10, p11, p12, p13) -- Line: 100
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table3
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	if ThrottleRequest("AttemptBuy", 7) then
		m_Library.Message.New("You are doing this too fast!");
		return;
	end
	if v1.Diamonds < p13 then
		m_Library.Message.New("You don't have enough Diamonds to buy this!");
		return;
	end
	local v2 = m_Library.Directory.Pets[p12.id];
	local math_ceil_ret = math.ceil(table3[p10].Listings[p11].Timestamp + 3 - workspace:GetServerTimeNow());
	if math_ceil_ret > 0 and (v2.isGift and m_Library.Message.New("Would you like to buy this " .. GetFullName(p12) .. " for " .. m_Library.Functions.Commas(p13) .. " Diamonds?", true, math_ceil_ret, true) or m_Library.Message.New("Would you like to buy this " .. GetFullName(p12) .. " pet for " .. m_Library.Functions.Commas(p13) .. " Diamonds?", true, math_ceil_ret, true)) or v2.isGift and m_Library.Message.New("Would you like to buy this " .. GetFullName(p12) .. " for " .. m_Library.Functions.Commas(p13) .. " Diamonds?", true) or m_Library.Message.New("Would you like to buy this " .. GetFullName(p12) .. " pet for " .. m_Library.Functions.Commas(p13) .. " Diamonds?", true) then
		local v21, v22 = m_Library.Network.Invoke("Purchase Trading Booth Pet", p10, p11);
		if not v21 then
			m_Library.Message.New(v22);
			return;
		end
		m_Library.Signal.Fire("Notification", "Success! \226\156\133", {
			color = Color3.fromRGB(105, 255, 168),
			sound = "rbxassetid://11648890466"
		});
	end
end
function UpdateUI(p14, p15, p16) -- Line: 150
	--[[
		Upvalues:
			[1] = m_Library
			[2] = bool1
			[3] = Color3_fromHSV_ret
	--]]
	if not p15.Model then return end
	local t_PetScroll = p15.Model.Pets.SurfaceGui.PetScroll;
	local t_Frame = p15.Model.Info.SurfaceGui.Frame;
	local t_Top = t_Frame.Top;
	local t_Bottom = t_Frame.Bottom;
	--local t_PetHolder = t_PetScroll:FindFirstChild("PetHolder");
	--if not t_PetHolder then
	local t_PetHolder = script.PetHolder
	--end
	
	for _, child1 in pairs(t_PetScroll:GetChildren()) do
		if not child1:IsA("Frame") or child1:GetAttribute("Template") or p15.Listings[child1.Name] then continue end
		child1:Destroy();
	end
	local table5 = {};
	for key2, _ in pairs(p15.Listings) do
		local v23 = m_Library.PetCmds.Get(key2);
		if v23 then
			table.insert(table5, v23);
			continue;
		end
		if not p16 then
			p16 = 1;
		end
		if p16 <= 3 then
			task.delay(0.25, UpdateUI, p14, p15, p16 + 1);
		end
		return;
	end
	local v3 = 0;
	local v4 = m_Library.Shared.SortPets(nil, table5);
	for _, val3 in ipairs(v4) do
		local t_uid = val3.uid;
		local _ = p15.Listings[t_uid];
		local t_Price = p15.Listings[t_uid].Price;
		local _ = p15.Listings[t_uid].Timestamp;
		if t_PetScroll:FindFirstChild(t_uid) then
			t_PetScroll:FindFirstChild(t_uid).LayoutOrder = v3;
			v3 = v3 + 1;
			continue;
		end
		local Clone_ret2 = t_PetHolder:Clone();
		Clone_ret2:SetAttribute("Template", false);
		Clone_ret2.Pet:Destroy();
		Clone_ret2.Visible = true;
		Clone_ret2.Name = t_uid;
		Clone_ret2.LayoutOrder = v3;
		v3 = v3 + 1;
		local Clone_ret3 = m_Library.Assets.UI.Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret3, t_uid);
		Clone_ret3:SetAttribute("DirId", val3.id);
		Clone_ret3:SetAttribute("Hardcore", val3.hc);
		Clone_ret3.Parent = Clone_ret2;
		Clone_ret3:SetAttribute("SurfaceElement", true);
		Clone_ret3.AnchorPoint = t_PetHolder.Pet.AnchorPoint;
		Clone_ret3.Position = t_PetHolder.Pet.Position;
		Clone_ret3.Size = t_PetHolder.Pet.Size;
		Clone_ret2.Buy.Cost.Text = m_Library.Functions.NumberShorten(t_Price);
		m_Library.GUIFX.ButtonFX(Clone_ret2.Buy);
		if p15.Owner ~= m_Library.LocalPlayer.UserId then
			m_Library.GUIFX.ButtonFX(Clone_ret2.Buy);
			Clone_ret2.Buy.Activated:Connect(function() -- Line: 231
				--[[
					Upvalues:
						[1] = bool1
						[2] = p14
						[3] = t_uid
						[4] = val3
						[5] = t_Price
				--]]
				if not bool1 then
					bool1 = true;
					AttemptBuy(p14, t_uid, val3, t_Price);
					bool1 = false;
				end
			end);
		else
			Clone_ret2.Buy.HoverImage = "";
			Clone_ret2.Buy.PressedImage = "";
		end
		Clone_ret2.Parent = t_PetScroll;
		if not val3.r then continue end
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 248
			--[[
				Upvalues:
					[1] = Clone_ret3
					[2] = Clone_ret2
					[3] = Color3_fromHSV_ret
					[4] = m_Library
			--]]
			while Clone_ret3 and Clone_ret3.Parent and Clone_ret2.Parent do
				Clone_ret3.PetIcon.ImageColor3 = Color3_fromHSV_ret;
				m_Library.RenderStepped();
			end
		end);
		coroutine_wrap_ret();
	end
	local PlayerByUserId = game.Players:GetPlayerByUserId(p15.Owner);
	if PlayerByUserId then
		t_Top.Text = PlayerByUserId.DisplayName .. "'s Stand";
		local v24 = m_Library.Save.Get(PlayerByUserId);
		if v24 then
			local v26 = v24.BoothDiamondsEarned or 0;
			t_Bottom.Text = m_Library.Functions.NumberShorten(v26) .. " Diamonds Earned";
		else
			t_Bottom.Text = "0 Diamonds Earned";
		end
	else
		t_Top.Text = "Unknown's Stand";
		t_Bottom.Text = "0 Diamonds Earned";
	end
	BoothScrolling(p15);
end
function GetBooth() -- Line: 277
	--[[
		Upvalues:
			[1] = table3
			[2] = m_Library
	--]]
	for _, val4 in pairs(table3) do
		if val4.Owner ~= m_Library.LocalPlayer.UserId then continue end
		return val4;
	end
	return nil;
end
function BoothScrolling(p17) -- Line: 288
	if not p17.Model then return end
	local t_PetScroll2 = p17.Model.Pets.SurfaceGui.PetScroll;
	local UIPadding = t_PetScroll2:FindFirstChildOfClass("UIPadding");
	local UIListLayout = t_PetScroll2:FindFirstChildOfClass("UIListLayout");
	UIListLayout:ApplyLayout();
	t_PetScroll2.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + UIPadding.PaddingLeft.Offset + 15, 0, 0);
end
function SetupUnclaimed(p18, p19, _) -- Line: 300
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Clone_ret4 = m_Library.Directory.Booths["Default Booth"].Model:Clone();
	local table6 = {
		ID = p18,
		Model = Clone_ret4
	};
	SetupModelPosition(p19, Clone_ret4);
	if not GetBooth() then
		SetupClaimInteract(table6);
	end
	local Map2 = m_Library.WorldCmds.GetMap();
	local Interactive2 = Map2:FindFirstChild("Interactive");
	local Booths2 = Interactive2:FindFirstChild("Booths");
	Clone_ret4.Parent = Booths2;
	BoothScrolling(table6);
	return table6;
end
function SetupClaimed(p20, p21, p22) -- Line: 325
	--[[
		Upvalues:
			[1] = table3
	--]]
	table3[p20] = p21;
	if p22 then
		SetupModel(p22, p21);
	end
	SetupViewInteract(p20, p21);
	UpdateUI(p20, p21);
	BoothScrolling(p21);
end
function SetupModelPosition(p23, p24) -- Line: 338
	local v5 = p23.Position.Y - Vector3.new(1, 1, 1).Y / 2 + p24.PrimaryPart.Size.Y / 2 - p23.Position.Y;
	p24:SetPrimaryPartCFrame(p23.CFrame + Vector3.new(0, v5, 0));
end
function ClaimBooth(p25) -- Line: 350
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table3
	--]]
	local v6, v7 = m_Library.Network.Invoke("Claim Trading Booth", p25.ID);
	if not v6 then
		m_Library.Signal.Fire("Notification", v7, {color = Color3.fromRGB(255, 46, 46)});
		return;
	end
	m_Library.Signal.Fire("Notification", "Booth claimed!", {color = Color3.fromRGB(33, 255, 218)});
	local v8 = table3[p25.ID];
	if not v8 then return end
	if v8.Model then
		m_Library.Audio.Play(11648890586, v8.Model:GetPrimaryPartCFrame().p, 1, 1, 100);
	end
end
function EditBooth(p26) -- Line: 371
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Signal.Fire("Show Booth", p26);
end
function ViewBooth(p27) -- Line: 376
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Signal.Fire("Show Booth", p27);
end
function SetupClaimInteract(p28) -- Line: 381
	--[[
		Upvalues:
			[1] = m_Library
			[2] = bool1
	--]]
	if p28.InteractDestroy then
		p28.InteractDestroy();
	end
	task.delay(1, function() -- Line: 386
		--[[
			Upvalues:
				[1] = p28
				[2] = m_Library
				[3] = bool1
		--]]
		if p28.Model and p28.Model.Parent then
			local Booth = p28.Model:FindFirstChild("Booth");
			if Booth then
				Booth.Transparency = 0.6;
			end
			for _, child14 in pairs(p28.Model:GetChildren()) do
				if child14.Name ~= "Backface" then continue end
				child14.Material = Enum.Material.SmoothPlastic;
				child14.Transparency = 0.6;
			end
			local Interact = p28.Model:FindFirstChild("Interact");
			local v28, v29 = m_Library.Interact.Add(Interact, {
				dist = 12,
				label = "Claim Booth!"
			});
			p28.InteractDestroy = v29;
			if v28 then
				v28:Connect(function() -- Line: 405
					--[[
						Upvalues:
							[1] = bool1
							[2] = p28
					--]]
					if not bool1 then
						bool1 = true;
						ClaimBooth(p28);
						bool1 = false;
					end
				end);
			end
		end
	end);
end
function SetupEditInteract(p29, p30) -- Line: 418
	--[[
		Upvalues:
			[1] = table3
			[2] = m_Library
			[3] = bool1
	--]]
	if p30.InteractDestroy then
		p30.InteractDestroy();
	end
	task.delay(1, function() -- Line: 423
		--[[
			Upvalues:
				[1] = table3
				[2] = p29
				[3] = p30
				[4] = m_Library
				[5] = bool1
		--]]
		if table3[p29] and table3[p29].Owner == p30.Owner then
			if not p30.Model then
				warn("Can't find booth model!", p30.Name);
				return;
			end
			local Booth2 = p30.Model:FindFirstChild("Booth");
			if Booth2 then
				Booth2.Transparency = 0;
			end
			for _, child15 in pairs(p30.Model:GetChildren()) do
				if child15.Name ~= "Backface" then continue end
				child15.Material = Enum.Material.Neon;
				child15.Transparency = 0;
			end
			local Interact2 = p30.Model:FindFirstChild("Interact");
			local v30, v31 = m_Library.Interact.Add(Interact2, {
				dist = 12,
				label = "Edit Booth!"
			});
			p30.InteractDestroy = v31;
			if v30 then
				v30:Connect(function() -- Line: 446
					--[[
						Upvalues:
							[1] = bool1
							[2] = p29
					--]]
					if not bool1 then
						bool1 = true;
						EditBooth(p29);
						bool1 = false;
					end
				end);
			end
			SetupYourBoothBillboard(p30);
		end
	end);
end
function SetupYourBoothBillboard(p31) -- Line: 461
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_Model = p31.Model;
	if not t_Model or t_Model:FindFirstChild("YourBoothAttachment") then return end
	local YourBoothAttachment = Instance.new("Attachment");
	YourBoothAttachment.Name = "YourBoothAttachment";
	YourBoothAttachment.Position = Vector3.new(0, 8, 0);
	YourBoothAttachment.Parent = t_Model.PrimaryPart;
	local Clone_ret5 = m_Library.Assets.Billboards.YourBooth:Clone();
	Clone_ret5.Parent = YourBoothAttachment;
end
function RemoveYourBoothBillboard(p32) -- Line: 477
	local t_Model2 = p32.Model;
	if not t_Model2 or not t_Model2:FindFirstChild("YourBoothAttachment") then return end
	t_Model2:FindFirstChild("YourBoothAttachment"):Destroy();
end
function SetupViewInteract(p33, p34) -- Line: 487
	--[[
		Upvalues:
			[1] = m_Library
			[2] = bool1
	--]]
	if not p34.Model then return end
	local Interact3 = p34.Model:FindFirstChild("Interact");
	local v9, v10 = m_Library.Interact.Add(Interact3, {
		dist = 12,
		label = "View Booth!"
	});
	if p34.InteractDestroy then
		p34.InteractDestroy();
	end
	p34.InteractDestroy = v10;
	local Booth3 = p34.Model:FindFirstChild("Booth");
	if Booth3 then
		Booth3.Transparency = 0;
	end
	for _, child5 in pairs(p34.Model:GetChildren()) do
		if child5.Name ~= "Backface" then continue end
		child5.Material = Enum.Material.Neon;
		child5.Transparency = 0;
	end
	if v9 then
		v9:Connect(function() -- Line: 514
			--[[
				Upvalues:
					[1] = bool1
					[2] = p33
			--]]
			if not bool1 then
				bool1 = true;
				ViewBooth(p33);
				bool1 = false;
			end
		end);
	end
end
function UpdateBooth(p35, p36) 
	local v11 = table3[p35];
	if not v11 then return end
	local t_Style = v11.Style;
	v11.Owner = p36.Owner;
	v11.Style = p36.Style;
	v11.Listings = p36.Listings;
	if t_Style ~= v11.Style and v11.Owner == m_Library.LocalPlayer.UserId then
		local v25 = m_Library.Save.Get();
		if v25 then
			v25.SelectedTradingBooth = v11.Style;
			m_Library.Signal.Fire("Booth Style Updated", v25.SelectedTradingBooth);
			m_Library.Audio.Play("rbxassetid://11648890653", script, 1, 1);
		end
	end
	if getStyle(p36.Style) ~= getStyle(t_Style) then
		UpdateModel(p35, table1[p35], v11);
	end
	UpdateUI(p35, v11);
end
function Setup() -- Line: 556
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = table2
			[4] = table1
	--]]
	if not u1 then return end
	local v12 = m_Library.Network.Invoke("Get All Booths");
	local v13 = m_Library.Functions.DeepCopyUnsafe(v12);
	for key6, val6 in pairs(v13) do
		if typeof(key6) ~= "string" then continue end
		v12[tonumber(key6)] = val6;
		v12[key6] = nil;
	end
	local Map3 = m_Library.WorldCmds.GetMap();
	local BoothSpawns = Map3:FindFirstChild("BoothSpawns");
	if BoothSpawns then
		for _, child8 in pairs(BoothSpawns:GetChildren()) do
			local Attribute = child8:GetAttribute("ID");
			local v27 = v12[Attribute];
			local Part = Instance.new("Part");
			Part.Anchored = true;
			Part.Transparency = 1;
			Part.Size = Vector3.new(1, 1, 1);
			Part.CFrame = child8.PrimaryPart.CFrame;
			Part.Position = Part.Position - Vector3.new(0, child8.PrimaryPart.Size.Y / 2, 0) + Vector3.new(0, Part.Size.Y / 2, 0);
			Part.Parent = BoothSpawns;
			child8:Destroy();
			if v27 then
				SetupClaimed(Attribute, v27, Part);
			else
				table2[Attribute] = SetupUnclaimed(Attribute, Part);
			end
			table1[Attribute] = Part;
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p37) -- Line: 603
	if p37 == "Trading Plaza" then
		Setup();
	end
end);
m_Library.Signal.Invoked("Is Trading Booth Pet").OnInvoke = function(p38) -- Line: 610
	--[[
		Upvalues:
			[1] = table3
	--]]
	for _, val7 in pairs(table3) do
		for key9, _ in pairs(val7.Listings) do
			if key9 ~= p38 then continue end
			return true;
		end
	end
	return false;
end
m_Library.Signal.Fired("Other Stat Changed"):Connect(function(p39, p40) -- Line: 623
	--[[
		Upvalues:
			[1] = table3
	--]]
	if p40 == "BoothDiamondsEarned" then
		for key10, val10 in ipairs(table3) do
			if val10.Owner ~= p39.UserId then continue end
			UpdateUI(key10, val10);
			return;
		end
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p41) -- Line: 635
	--[[
		Upvalues:
			[1] = table3
			[2] = m_Library
	--]]
	if p41 == "BoothDiamondsEarned" then
		for key11, val11 in ipairs(table3) do
			if val11.Owner ~= m_Library.LocalPlayer.UserId then continue end
			UpdateUI(key11, val11);
			return;
		end
	end
end);
m_Library.Signal.Invoked("Get Booth By Id").OnInvoke = function(p42) -- Line: 646
	--[[
		Upvalues:
			[1] = table3
	--]]
	return table3[p42];
end
m_Library.Network.Fired("Trade Booth Updated"):Connect(function(p43, p44) -- Line: 651
	UpdateBooth(p43, p44);
end);
m_Library.Network.Fired("Trading Booth Claimed"):Connect(function(p45, p46) -- Line: 656
	--[[
		Upvalues:
			[1] = table2
			[2] = table3
			[3] = table1
			[4] = m_Library
	--]]
	local v14 = table2[p45];
	if v14 then
		v14.Model:Destroy();
		table2[p45] = nil;
	end
	table3[p45] = p46;
	local v15 = table1[p45];
	if v15 then
		SetupModel(v15, p46);
	end
	if p46.Owner == m_Library.LocalPlayer.UserId then
		for _, val12 in pairs(table2) do
			if not val12.InteractDestroy then continue end
			val12.InteractDestroy();
			val12.InteractDestroy = nil;
		end
		SetupEditInteract(p45, p46);
	else
		SetupViewInteract(p45, p46);
	end
	UpdateUI(p45, p46);
	BoothScrolling(p46);
end);
m_Library.Network.Fired("Trading Booth Unclaimed"):Connect(function(p47) -- Line: 688
	--[[
		Upvalues:
			[1] = table3
			[2] = table1
			[3] = table2
			[4] = m_Library
	--]]
	local v16 = table3[p47];
	if not v16 then return end
	table3[p47] = nil;
	if v16.Model then
		v16.Model:Destroy();
	end
	local v17 = table1[p47];
	if v17 then
		table2[p47] = SetupUnclaimed(p47, v17);
	end
	if v16.Owner == m_Library.LocalPlayer.UserId then
		for _, val13 in pairs(table2) do
			if val13.InteractDestroy then continue end
			SetupClaimInteract(val13);
		end
	end
end);
m_Library.Network.Fired("Trading Booth Particle"):Connect(function(p48, _, _, p49, p50, p51) -- Line: 715
	--[[
		Upvalues:
			[1] = table3
			[2] = m_Library
	--]]
	local v18 = table3[p48];
	if not v18 or not v18.Model or not v18.Model.Table then return end
	m_Library.Audio.Play(11648890524, v18.Model:GetPrimaryPartCFrame().p, 1, 1, 80);
	local t_Booth = m_Library.Assets.Particles.Booth;
	local t_Table = v18.Model.Table;
	local t_Attachment = t_Table.Attachment;
	local Clone_ret6 = t_Booth.Diamonds:Clone();
	Clone_ret6.Rate = Clone_ret6.Rate * p49;
	local v19 = Vector2.new(Clone_ret6.Speed.Min, Clone_ret6.Speed.Max);
	if p50 then
		v19 = v19 * p50;
	end
	Clone_ret6.Speed = NumberRange.new(v19.X, v19.Y);
	local Clone_ret7 = t_Booth.Shine:Clone();
	Clone_ret7.Parent = t_Attachment;
	Clone_ret6.Parent = t_Table;
	local v20 = p51 * 1;
	task.delay(v20, function() -- Line: 742
		--[[
			Upvalues:
				[1] = Clone_ret7
				[2] = Clone_ret6
		--]]
		Clone_ret7.Enabled = false;
		Clone_ret6.Enabled = false;
		task.delay(10, function() -- Line: 746
			--[[
				Upvalues:
					[1] = Clone_ret7
					[2] = Clone_ret6
			--]]
			Clone_ret7:Destroy();
			Clone_ret6:Destroy();
		end);
	end);
end);
local u2 = 0;
game:GetService("RunService").RenderStepped:Connect(function(p52) -- Line: 755
	--[[
		Upvalues:
			[1] = u2
			[2] = Color3_fromHSV_ret
	--]]
	u2 = u2 + p52;
	Color3_fromHSV_ret = Color3.fromHSV(u2 / 2 % 1, 1, 1);
end);
