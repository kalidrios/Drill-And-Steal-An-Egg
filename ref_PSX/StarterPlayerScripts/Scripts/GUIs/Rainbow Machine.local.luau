-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Rainbow = m_Library.GUI.Rainbow;
local t_RainbowMachineOdds = m_Library.Shared.RainbowMachineOdds;
local Random_new_ret = Random.new();
local bool1 = false;
local table1 = {};
local bool2 = false;
local u1 = {};
local u2 = false;
local table2 = nil;
function Convert() -- Line: 26
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = t_Rainbow
			[4] = table2
	--]]
	if #u1 > 0 then
		m_Library.Variables.UsingMachine = true;
		t_Rainbow.Gui.Enabled = false;
		if #u1 > 0 then
			local v22 = m_Library.PetCmds.Get(u1[1]);
			if not v22 then
				table2 = nil;
			else
				table2 = {
					PetId = v22.id,
					Hardcore = v22.hc,
					Amount = #u1
				};
			end
		end
		local v11, v12 = m_Library.Network.Invoke("Use Rainbow Machine", u1);
		m_Library.Functions.Wait(0.5);
		if v11 then
			m_Library.Audio.Play("rbxassetid://7009851850", script);
			m_Library.Message.New("\226\156\133 Success!");
		else
			m_Library.Message.New(v12 or "Something went wrong. Try again!");
		end
		m_Library.Variables.UsingMachine = false;
	end
end
function Select(p1) -- Line: 63
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = t_RainbowMachineOdds
			[4] = table1
			[5] = Random_new_ret
	--]]
	local v1 = m_Library.PetCmds.Get(p1);
	if not p1 then return end
	if #table1 >= #(u2 and t_RainbowMachineOdds.Hardcore or t_RainbowMachineOdds.Normal) then return end
	for _, val1 in ipairs(table1) do
		local v13 = m_Library.PetCmds.Get(val1);
		if v1.id == v13.id and v1.hc == v13.hc then continue end
		return;
	end
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
	table.insert(table1, p1);
	u2 = v1.hc or false;
	Update();
end
function Deselect(p2) -- Line: 95
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = Random_new_ret
	--]]
	for key2, val2 in ipairs(table1) do
		if val2 ~= p2 then continue end
		m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
		table.remove(table1, key2);
		break;
	end
	Update();
end
function Update() -- Line: 110
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = t_Rainbow
			[4] = u2
			[5] = t_RainbowMachineOdds
	--]]
	local function UpdatePets() -- Line: 112
		--[[
			Upvalues:
				[1] = table1
				[2] = m_Library
				[3] = t_Rainbow
		--]]
		local v20 = table1[1] and m_Library.PetCmds.Get(table1[1]) or nil;
		for _, child6 in ipairs(t_Rainbow.Holder:GetChildren()) do
			if child6.ClassName ~= "TextButton" then continue end
			local t_Name = child6.Name;
			local Attribute = child6:GetAttribute("DirId");
			local Attribute2 = child6:GetAttribute("Locked");
			local Attribute3 = child6:GetAttribute("Hardcore");
			if not Attribute then continue end
			local v23 = not v20 or Attribute == v20.id and Attribute3 == v20.hc or false;
			child6.Visible = v23;
			local v24 = m_Library.Functions.SearchArray(table1, t_Name);
			child6.Equipped.Visible = v24;
			child6.BackgroundColor3 = v24 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			if not v23 or Attribute2 then continue end
			child6.BackgroundColor3 = v24 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			child6.PetIcon.ImageTransparency = 0;
		end
	end
	local function UpdateSide() -- Line: 144
		--[[
			Upvalues:
				[1] = table1
				[2] = t_Rainbow
				[3] = m_Library
				[4] = u2
				[5] = t_RainbowMachineOdds
		--]]
		local v21 = #table1 > 0;
		local CanRepeat_ret = CanRepeat();
		if v21 then
			t_Rainbow.Side.Ok.Visible = true;
			t_Rainbow.Side.Notice.Visible = true;
			t_Rainbow.Side.Repeat.Visible = false;
			t_Rainbow.Side.NoticeRepeat.Visible = false;
			t_Rainbow.Side.NoticeEmpty.Visible = false;
		elseif CanRepeat_ret then
			t_Rainbow.Side.Repeat.Visible = true;
			t_Rainbow.Side.NoticeRepeat.Visible = true;
			t_Rainbow.Side.Ok.Visible = false;
			t_Rainbow.Side.Notice.Visible = false;
			t_Rainbow.Side.NoticeEmpty.Visible = false;
		else
			t_Rainbow.Side.Ok.Visible = false;
			t_Rainbow.Side.Notice.Visible = false;
			t_Rainbow.Side.Repeat.Visible = false;
			t_Rainbow.Side.NoticeRepeat.Visible = false;
			t_Rainbow.Side.NoticeEmpty.Visible = true;
		end
		if m_Library.Variables.Console then
			t_Rainbow.Side.Ok.ButtonKeybind.Visible = true;
		else
			t_Rainbow.Side.Ok.ButtonKeybind.Visible = false;
		end
		if v21 then
			local v25 = m_Library.PetCmds.Get(table1[1]);
			if not v25 then return end
			local v26 = m_Library.Directory.Pets[v25.id];
			local v27 = u2 and t_RainbowMachineOdds.Hardcore or t_RainbowMachineOdds.Normal;
			local v28 = v27[math.min(#table1, #v27)];
			local t_chance = v28.chance;
			local t_cost = v28.cost;
			t_Rainbow.Side.CostFrame.Cost.Text = m_Library.Functions.Commas(t_cost);
			t_Rainbow.Side.Percent.Text = m_Library.Functions.FormatChance(t_chance / 100);
			if u2 then
				t_Rainbow.Side.Reward.Text = "For a Hardcore Rainbow " .. v26.name;
				return;
			end
			t_Rainbow.Side.Reward.Text = "For a Rainbow " .. v26.name;
			return;
		end
		t_Rainbow.Side.CostFrame.Cost.Text = "0";
		t_Rainbow.Side.Percent.Text = "0%";
		t_Rainbow.Side.Reward.Text = "";
	end
	UpdatePets();
	UpdateSide();
	Scaling();
end
function Setup() -- Line: 215
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Rainbow
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
		local t_hc = val3.hc;
		local v14 = m_Library.Directory.Pets[val3.id];
		local t_rarity = v14.rarity;
		if v14.isPremium or not t_g or t_r or t_dm or t_rarity == "Event" or t_rarity == "Exclusive" or v14.isGift or val3.l then continue end
		local Clone_ret = m_Library.Assets.UI.Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret, t_uid);
		Clone_ret.LayoutOrder = key3;
		Clone_ret:SetAttribute("DirId", val3.id);
		Clone_ret:SetAttribute("Hardcore", t_hc);
		Clone_ret.Parent = t_Rainbow.Holder;
		Clone_ret.Activated:Connect(function() -- Line: 252
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
				local v29 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid);
				if val3.l then
					m_Library.Message.New("This pet is locked! Unlock it before you can convert it to Rainbow!");
				elseif v29 then
					m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can convert it to Rainbow!");
				elseif not m_Library.Functions.SearchArray(table1, t_uid) then
					Select(t_uid);
				else
					Deselect(t_uid);
				end
				bool1 = false;
			end
		end);
		m_Library.GUIFX.ButtonFX(Clone_ret);
		v5 = v5 + 1;
	end
	t_Rainbow.NoPets.Visible = v5 <= 0;
	Update();
	Scaling();
end
function Scaling() -- Line: 284
	--[[
		Upvalues:
			[1] = t_Rainbow
			[2] = m_Library
	--]]
	local t_Holder = t_Rainbow.Container.Holder;
	local UIGridLayout = t_Holder:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	local v7 = m_Library.Functions.ResolutionScale();
	local v8 = (t_Holder.AbsoluteSize.X - t_Holder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / (v7 <= 0.5 and 2 or v7 <= 1.1 and 3 or 4) - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v8, 0, v8);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 30);
end
function Clear() -- Line: 308
	--[[
		Upvalues:
			[1] = u2
			[2] = table1
			[3] = t_Rainbow
	--]]
	u2 = false;
	table1 = {};
	for _, child4 in ipairs(t_Rainbow.Holder:GetChildren()) do
		if child4.ClassName ~= "TextButton" then continue end
		child4:Destroy();
	end
end
function CanRepeat() -- Line: 320
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
		local v15 = m_Library.Directory.Pets[val5.id];
		local t_g2 = val5.g;
		local t_r2 = val5.r;
		local t_dm2 = val5.dm;
		local t_hc2 = val5.hc;
		local t_rarity2 = v15.rarity;
		if v15.isPremium or not t_g2 or t_r2 or t_dm2 or t_rarity2 == "Event" or t_rarity2 == "Exclusive" or v15.isGift or val5.l or t_id ~= table2.PetId or t_hc2 ~= table2.Hardcore then continue end
		table.insert(table3, val5.uid);
		if #table3 ~= table2.Amount then continue end
		table2.RetryPets = table3;
		return true;
	end
	return false;
end
t_Rainbow.Side.Ok.Activated:Connect(function() -- Line: 367
	--[[
		Upvalues:
			[1] = bool1
			[2] = bool2
			[3] = u2
			[4] = t_RainbowMachineOdds
			[5] = table1
			[6] = u1
			[7] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		bool2 = true;
		local v16 = u2 and t_RainbowMachineOdds.Hardcore or t_RainbowMachineOdds.Normal;
		local t_chance2 = v16[math.min(#table1, #v16)].chance;
		u1 = m_Library.Functions.DeepCopyUnsafe(table1);
		local v17 = m_Library.Message.New("You have a " .. t_chance2 .. "% chance. Are you sure?", true);
		if v17 then
			Convert();
		end
		bool2 = false;
		bool1 = false;
	end
end);
t_Rainbow.Side.Repeat.Activated:Connect(function() -- Line: 392
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
			for _, val7 in ipairs(table2.RetryPets) do
				Select(val7);
			end
		end
		bool2 = false;
		bool1 = false;
	end
end);
t_Rainbow.Close.Activated:Connect(function() -- Line: 426
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Rainbow
	--]]
	if not bool1 then
		bool1 = true;
		t_Rainbow.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Rainbow.Close);
m_Library.GUIFX.ButtonFX(t_Rainbow.Side.Ok);
m_Library.GUIFX.ButtonFX(t_Rainbow.Side.Repeat);
m_Library.Signal.Fired("Window Closed"):Connect(function(p3) -- Line: 443
	--[[
		Upvalues:
			[1] = bool2
			[2] = t_Rainbow
	--]]
	if bool2 then return end
	if p3 == t_Rainbow.Gui then
		Clear();
	end
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p4) -- Line: 454
	--[[
		Upvalues:
			[1] = bool2
			[2] = t_Rainbow
			[3] = m_Library
	--]]
	if bool2 then return end
	if p4 == t_Rainbow.Gui then
		Clear();
		Setup();
		if t_Rainbow.Gui.Enabled and m_Library.Variables.Console then
			print("Set selected obj");
			m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("Rainbow"):FindFirstChild("Frame"):FindFirstChild("Container"):FindFirstChild("Holder");
		end
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 471
	--[[
		Upvalues:
			[1] = t_Rainbow
	--]]
	if t_Rainbow.Gui.Enabled then
		task.defer(function() -- Line: 473
			Scaling();
		end);
	end
end);
m_Library.Signal.Fired("Attempt Rainbow"):Connect(function() -- Line: 479
	--[[
		Upvalues:
			[1] = table1
			[2] = bool1
			[3] = bool2
			[4] = u2
			[5] = t_RainbowMachineOdds
			[6] = u1
			[7] = m_Library
	--]]
	if #table1 <= 0 then return end
	if not bool1 then
		bool1 = true;
		bool2 = true;
		local v18 = u2 and t_RainbowMachineOdds.Hardcore or t_RainbowMachineOdds.Normal;
		local t_chance3 = v18[math.min(#table1, #v18)].chance;
		u1 = m_Library.Functions.DeepCopyUnsafe(table1);
		local v19 = m_Library.Message.New("You have a " .. t_chance3 .. "% chance. Are you sure?", true);
		if v19 then
			Convert();
		end
		bool2 = false;
		bool1 = false;
	end
end);
