-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_DarkMatter = m_Library.GUI.DarkMatter;
local t_DarkMatterMachineSettings = m_Library.Shared.DarkMatterMachineSettings;
local u1 = nil;
local os_clock_ret = nil;
local Random_new_ret = Random.new();
local bool1 = false;
local table1 = {};
local bool2 = false;
local bool3 = false;
local u2 = {};
local u3 = false;
local table2 = nil;
function PetsConvert() -- Line: 27
	--[[
		Upvalues:
			[1] = u2
			[2] = m_Library
			[3] = table2
	--]]
	if #u2 > 0 then
		if #u2 > 0 then
			local v24 = m_Library.PetCmds.Get(u2[1]);
			if not v24 then
				table2 = nil;
			else
				table2 = {
					PetId = v24.id,
					Hardcore = v24.hc,
					Amount = #u2
				};
			end
		end
		local v15, v16 = m_Library.Network.Invoke("Convert To Dark Matter", u2);
		if v15 then
			m_Library.Audio.Play("rbxassetid://7009851850", script);
			OpenTab("Queue");
			return;
		end
		m_Library.Message.New(v16 or "Something went wrong. Try again!");
	end
end
function PetsSelect(p1) -- Line: 59
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u3
			[3] = t_DarkMatterMachineSettings
			[4] = table1
			[5] = Random_new_ret
	--]]
	local v1 = m_Library.PetCmds.Get(p1);
	if not p1 then return end
	if #table1 >= #(u3 and t_DarkMatterMachineSettings.Hardcore or t_DarkMatterMachineSettings.Normal) then return end
	for _, val1 in ipairs(table1) do
		if m_Library.PetCmds.Get(val1).id == v1.id then continue end
		return;
	end
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
	table.insert(table1, p1);
	u3 = v1.hc or nil;
	PetsUpdate();
end
function PetsDeselect(p2) -- Line: 91
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = u3
	--]]
	for key2, val2 in ipairs(table1) do
		if val2 ~= p2 then continue end
		m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
		table.remove(table1, key2);
		break;
	end
	if #table1 <= 0 then
		u3 = false;
	end
	PetsUpdate();
end
function PetsUpdate() -- Line: 110
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = t_DarkMatter
			[4] = u3
			[5] = t_DarkMatterMachineSettings
	--]]
	local function UpdatePets() -- Line: 112
		--[[
			Upvalues:
				[1] = table1
				[2] = m_Library
				[3] = t_DarkMatter
		--]]
		local v22 = table1[1] and m_Library.PetCmds.Get(table1[1]) or nil;
		for _, child8 in ipairs(t_DarkMatter.Pets.Holder:GetChildren()) do
			if child8.ClassName ~= "TextButton" then continue end
			local t_Name = child8.Name;
			local Attribute = child8:GetAttribute("DirId");
			local Attribute2 = child8:GetAttribute("Locked");
			local Attribute3 = child8:GetAttribute("Hardcore");
			if not Attribute then continue end
			local v25 = not v22 or Attribute == v22.id and Attribute3 == v22.hc or false;
			child8.Visible = v25;
			local v26 = m_Library.Functions.SearchArray(table1, t_Name);
			child8.Equipped.Visible = v26;
			child8.BackgroundColor3 = v26 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			if not v25 or Attribute2 then continue end
			child8.BackgroundColor3 = v26 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			child8.PetIcon.ImageTransparency = 0;
		end
	end
	local function UpdateSide() -- Line: 144
		--[[
			Upvalues:
				[1] = t_DarkMatter
				[2] = table1
				[3] = m_Library
				[4] = u3
				[5] = t_DarkMatterMachineSettings
		--]]
		local t_Side = t_DarkMatter.Pets.Side;
		local v23 = #table1 > 0;
		local CanRepeat_ret = CanRepeat();
		t_Side.Ready.ImageColor3 = v23 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
		t_Side.TimerFrame.Visible = v23;
		t_Side.TimerTitle.Visible = v23;
		t_Side.Notice.Visible = not v23;
		if m_Library.Variables.Console then
			t_Side.Ready.ButtonKeybind.Visible = true;
		else
			t_Side.Ready.ButtonKeybind.Visible = false;
		end
		if v23 then
			local v27 = u3 and t_DarkMatterMachineSettings.Hardcore or t_DarkMatterMachineSettings.Normal;
			local v28 = v27[math.min(#table1, #v27)];
			local t_waitTime = v28.waitTime;
			local t_cost = v28.cost;
			t_Side.CostFrame.Cost.Text = m_Library.Functions.Commas(t_cost);
			t_Side.TimerFrame.Time.Text = m_Library.Functions.TimeString(t_waitTime);
		else
			t_Side.CostFrame.Cost.Text = "0";
		end
		if v23 then
			t_DarkMatter.Side.Ready.Visible = true;
			t_DarkMatter.Side.Repeat.Visible = false;
			return;
		end
		if CanRepeat_ret then
			t_DarkMatter.Side.Ready.Visible = false;
			t_DarkMatter.Side.Repeat.Visible = true;
			return;
		end
		t_DarkMatter.Side.Ready.Visible = true;
		t_DarkMatter.Side.Repeat.Visible = false;
	end
	UpdatePets();
	UpdateSide();
	PetsScaling();
end
function PetsSetup() -- Line: 191
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_DarkMatter
			[3] = bool1
			[4] = table1
	--]]
	local v4 = m_Library.Save.Get();
	if not v4 then return end
	local v5 = 0;
	local v6 = m_Library.Shared.SortPets(v4, table.clone(v4.Pets));
	for key3, val3 in ipairs(v6) do
		local t_uid = val3.uid;
		local _ = val3.s;
		local t_g = val3.g;
		local t_r = val3.r;
		local t_dm = val3.dm;
		local v17 = m_Library.Directory.Pets[val3.id];
		local _ = v17.rarity;
		if t_g or not t_r or t_dm or v17.isPremium or v17.rarity == "Event" or v17.rarity == "Exclusive" or v17.isGift then continue end
		local Clone_ret = m_Library.Assets.UI.Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret, t_uid);
		Clone_ret.LayoutOrder = key3;
		Clone_ret:SetAttribute("DirId", val3.id);
		Clone_ret:SetAttribute("Hardcore", val3.hc);
		Clone_ret.Parent = t_DarkMatter.Pets.Holder;
		Clone_ret.Activated:Connect(function() -- Line: 223
			--[[
				Upvalues:
					[1] = bool1
					[2] = m_Library
					[3] = t_uid
					[4] = val3
					[5] = table1
			--]]
			if not bool1 then
				bool1 = true;
				local v31 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid);
				if val3.l then
					m_Library.Message.New("This pet is locked! Unlock it before you can convert it to Dark Matter!");
				elseif v31 then
					m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can convert it to Dark Matter!");
				elseif not m_Library.Functions.SearchArray(table1, t_uid) then
					PetsSelect(t_uid);
				else
					PetsDeselect(t_uid);
				end
				bool1 = false;
			end
		end);
		m_Library.GUIFX.ButtonFX(Clone_ret);
		v5 = v5 + 1;
	end
	t_DarkMatter.Pets.NoPets.Visible = v5 <= 0;
	PetsUpdate();
	PetsScaling();
end
function PetsScaling() -- Line: 255
	--[[
		Upvalues:
			[1] = t_DarkMatter
			[2] = m_Library
	--]]
	local t_Holder = t_DarkMatter.Pets.Holder;
	local UIGridLayout = t_Holder:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	local v7 = m_Library.Functions.ResolutionScale();
	local v8 = (t_Holder.AbsoluteSize.X - t_Holder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / (v7 <= 0.5 and 4 or v7 <= 1.1 and 5 or 6) - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v8, 0, v8);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 30);
end
function PetsClear() -- Line: 279
	--[[
		Upvalues:
			[1] = table1
			[2] = u3
			[3] = t_DarkMatter
	--]]
	table1 = {};
	u3 = false;
	for _, child4 in ipairs(t_DarkMatter.Pets.Holder:GetChildren()) do
		if child4.ClassName ~= "TextButton" then continue end
		child4:Destroy();
	end
end
function CanRepeat() -- Line: 291
	--[[
		Upvalues:
			[1] = table2
			[2] = m_Library
	--]]
	if not table2 then
		return false;
	end
	local v9 = m_Library.Save.Get();
	if not v9 then
		return false;
	end
	local v10 = m_Library.Shared.SortPets(v9, table.clone(v9.Pets));
	local table3 = {};
	for _, val5 in ipairs(v10) do
		local t_id = val5.id;
		local v18 = m_Library.Directory.Pets[val5.id];
		local t_r2 = val5.r;
		local t_dm2 = val5.dm;
		local t_hc = val5.hc;
		local t_rarity = v18.rarity;
		if v18.isPremium or not t_r2 or t_dm2 or t_rarity == "Event" or t_rarity == "Exclusive" or v18.isGift or val5.l or t_id ~= table2.PetId or t_hc ~= table2.Hardcore then continue end
		table.insert(table3, val5.uid);
		if #table3 ~= table2.Amount then continue end
		table2.RetryPets = table3;
		return true;
	end
	return false;
end
function RedeemQueuePet(p3) -- Line: 337
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v11, v12 = m_Library.Network.Invoke("Redeem Dark Matter Pet", p3);
	if v11 then return end
	m_Library.Message.New(v12 or "Something went wrong. Try again!");
end
function PromptDarkMatterSkip(p4) -- Line: 347
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v13, v14 = m_Library.Network.Invoke("Prompt Dark Matter Skip", p4);
	if v13 and v14 then
		m_Library.Shared.PromptPurchase(v14, true);
		return;
	end
	m_Library.Message.New("Something went wrong. Try again later!");
end
function UpdateQueue() -- Line: 357
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_DarkMatter
			[3] = u1
			[4] = os_clock_ret
			[5] = bool3
			[6] = bool1
	--]]
	local u4 = m_Library.Save.Get();
	if not u4 then return end
	local t_Holder2 = t_DarkMatter.Queue.Holder;
	for key6, val6 in pairs(u4.DarkMatterQueue) do
		local u5 = t_Holder2:FindFirstChild(key6);
		if u5 then continue end
		local t_petId = val6.petId;
		local t_readyTime = val6.readyTime;
		local v19 = m_Library.Directory.Pets[t_petId];
		local function UpdateTimer() -- Line: 375
			--[[
				Upvalues:
					[1] = val6
					[2] = u4
					[3] = key6
					[4] = u1
					[5] = os_clock_ret
					[6] = m_Library
					[7] = t_readyTime
					[8] = u5
					[9] = bool3
			--]]
			val6 = u4.DarkMatterQueue[key6];
			if not val6 then return end
			if not u1 or not os_clock_ret then
				local v32 = m_Library.Network.Invoke("Get OSTime");
				os_clock_ret = os.clock();
				u1 = v32;
			end
			t_readyTime = val6.readyTime;
			local v29 = t_readyTime - (u1 + (os.clock() - os_clock_ret));
			local v30 = v29 <= 1;
			u5.TimeLeft.Visible = not v30;
			u5.Claim.Visible = v30;
			u5.Skip.Visible = not v30;
			u5.TimeDesc.Visible = not v30;
			u5.SkipDesc.Visible = not v30;
			u5.ClaimDesc.Visible = v30;
			u5.PetIcon.UIGradient.Enabled = not v30;
			if val6.hardcore then
				u5.PetIcon.ImageColor3 = Color3.fromRGB(42, 252, 255);
			end
			if not v30 then
				u5.TimeLeft.Text = m_Library.Functions.TimeString(v29);
			else
				bool3 = true;
			end
			local DMSkipProduct = m_Library.Shared.GetDMSkipProduct(v29);
			u5.Skip.Robux.Text = m_Library.Functions.Commas(m_Library.Functions.GetPrice(DMSkipProduct, true));
		end
		u5 = m_Library.Assets.UI.DarkMatter.QueuePet:Clone();
		u5.Name = key6;
		u5.PetIcon.Image = v19.darkMatterThumbnail;
		u5:SetAttribute("SlotId", key6);
		u5.Parent = t_Holder2;
		UpdateTimer();
		if not u5:FindFirstChild("Claim") then return end
		m_Library.GUIFX.ButtonFX(u5.Claim);
		u5.Claim.Activated:Connect(function() -- Line: 425
			--[[
				Upvalues:
					[1] = bool1
					[2] = key6
			--]]
			if not bool1 then
				bool1 = true;
				RedeemQueuePet(key6);
				bool1 = false;
			end
		end);
		if not u5:FindFirstChild("Skip") then return end
		m_Library.GUIFX.ButtonFX(u5.Skip);
		u5.Skip.Activated:Connect(function() -- Line: 437
			--[[
				Upvalues:
					[1] = bool1
					[2] = key6
			--]]
			if not bool1 then
				bool1 = true;
				PromptDarkMatterSkip(key6);
				bool1 = false;
			end
		end);
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 446
			--[[
				Upvalues:
					[1] = u5
					[2] = t_DarkMatter
					[3] = UpdateTimer
					[4] = m_Library
			--]]
			while u5 and u5.Parent do
				if t_DarkMatter.Gui.Enabled then
					UpdateTimer();
				end
				m_Library.Heartbeat(5);
			end
		end);
		coroutine_wrap_ret();
	end
	for _, child7 in ipairs(t_Holder2:GetChildren()) do
		local Attribute4 = child7:GetAttribute("SlotId");
		if not Attribute4 or u4.DarkMatterQueue[Attribute4] then continue end
		child7:Destroy();
	end
	t_Holder2.Parent.NoPets.Visible = m_Library.Functions.DictionaryLength(u4.DarkMatterQueue) <= 0;
	QueueScrolling();
end
function QueueScrolling() -- Line: 474
	--[[
		Upvalues:
			[1] = t_DarkMatter
	--]]
	local t_Holder3 = t_DarkMatter.Queue.Holder;
	local UIPadding2 = t_Holder3:FindFirstChildOfClass("UIPadding");
	local UIListLayout = t_Holder3:FindFirstChildOfClass("UIListLayout");
	UIListLayout:ApplyLayout();
	t_Holder3.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + UIPadding2.PaddingLeft.Offset + UIPadding2.PaddingRight.Offset, 0, 0);
end
function UpdateCategories() -- Line: 482
	--[[
		Upvalues:
			[1] = t_DarkMatter
			[2] = bool3
	--]]
	t_DarkMatter.Categories.ViewPets.Frame.PetReady.Visible = bool3;
	bool3 = false;
end
function OpenTab(p5) -- Line: 491
	--[[
		Upvalues:
			[1] = t_DarkMatter
	--]]
	t_DarkMatter.Categories.Visible = false;
	if p5 == "Pets" then
		t_DarkMatter.Pets.Visible = true;
		t_DarkMatter.Queue.Visible = false;
		PetsSetup();
		return;
	end
	t_DarkMatter.Pets.Visible = false;
	t_DarkMatter.Queue.Visible = true;
	PetsClear();
	UpdateQueue();
end
m_Library.GUIFX.ButtonFX(t_DarkMatter.Side.Repeat);
t_DarkMatter.Side.Repeat.Activated:Connect(function() -- Line: 508
	--[[
		Upvalues:
			[1] = bool1
			[2] = bool2
			[3] = table2
	--]]
	if not bool1 then
		bool1 = true;
		bool2 = true;
		if table2 and table2.RetryPets then
			for _, val9 in ipairs(table2.RetryPets) do
				PetsSelect(val9);
			end
		end
		bool2 = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_DarkMatter.Close);
t_DarkMatter.Close.Activated:Connect(function() -- Line: 526
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_DarkMatter
	--]]
	if not bool1 then
		bool1 = true;
		t_DarkMatter.Gui.Enabled = false;
		bool1 = false;
	end
end);
local t_Button = t_DarkMatter.Categories.MakePets.Frame.Button;
m_Library.GUIFX.ButtonFX(t_Button);
t_Button.Activated:Connect(function() -- Line: 537
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		OpenTab("Pets");
		bool1 = false;
	end
end);
local t_Button2 = t_DarkMatter.Categories.ViewPets.Frame.Button;
m_Library.GUIFX.ButtonFX(t_Button2);
t_Button2.Activated:Connect(function() -- Line: 548
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		OpenTab("Queue");
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_DarkMatter.Pets.Side.Ready);
t_DarkMatter.Pets.Side.Ready.Activated:Connect(function() -- Line: 558
	--[[
		Upvalues:
			[1] = bool1
			[2] = bool2
			[3] = u2
			[4] = m_Library
			[5] = table1
	--]]
	if not bool1 then
		bool1 = true;
		bool2 = true;
		u2 = m_Library.Functions.DeepCopyUnsafe(table1);
		local v20 = m_Library.Message.New("Are you sure?", true);
		if v20 then
			PetsConvert();
		end
		bool2 = false;
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p6) -- Line: 581
	if p6 == "DarkMatterQueue" or p6 == "DarkMatterSlots" then
		UpdateQueue();
	end
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p7) -- Line: 588
	--[[
		Upvalues:
			[1] = t_DarkMatter
			[2] = m_Library
	--]]
	if p7 == t_DarkMatter.Gui then
		PetsClear();
		t_DarkMatter.Categories.Visible = true;
		t_DarkMatter.Pets.Visible = false;
		t_DarkMatter.Queue.Visible = false;
		if t_DarkMatter.Gui.Enabled and m_Library.Variables.Console then
			print("Set selected obj");
			m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("DarkMatter"):FindFirstChild("Frame"):FindFirstChild("Categories"):FindFirstChild("MakePets"):FindFirstChild("Frame"):FindFirstChild("Button");
		end
		m_Library.Audio.Play("rbxassetid://7495293012", script, 1, 0.4);
	end
end);
m_Library.Signal.Fired("Window Closed"):Connect(function(p8) -- Line: 606
	--[[
		Upvalues:
			[1] = bool2
			[2] = t_DarkMatter
	--]]
	if bool2 then return end
	if p8 == t_DarkMatter.Gui then
		PetsClear();
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 617
	--[[
		Upvalues:
			[1] = t_DarkMatter
	--]]
	if t_DarkMatter.Gui.Enabled and t_DarkMatter.Pets.Visible then
		task.defer(function() -- Line: 619
			PetsScaling();
			QueueScrolling();
		end);
	end
end);
m_Library.Network.Fired("Dark Matter Timer Skipped"):Connect(function(_) -- Line: 627
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Audio.Play("rbxassetid://7495293069", script, 1, 0.5);
end);
local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 632
	while true do
		UpdateCategories();
		wait(1);
	end
end);
coroutine_wrap_ret2();
m_Library.Signal.Fired("Attempt Dark Matter"):Connect(function() -- Line: 640
	--[[
		Upvalues:
			[1] = t_DarkMatter
			[2] = table1
			[3] = bool1
			[4] = bool2
			[5] = u2
			[6] = m_Library
	--]]
	if not t_DarkMatter.Pets.Visible then return end
	if #table1 <= 0 then return end
	if not bool1 then
		bool1 = true;
		bool2 = true;
		u2 = m_Library.Functions.DeepCopyUnsafe(table1);
		local v21 = m_Library.Message.New("Are you sure?", true);
		if v21 then
			PetsConvert();
		end
		bool2 = false;
		bool1 = false;
	end
end);
