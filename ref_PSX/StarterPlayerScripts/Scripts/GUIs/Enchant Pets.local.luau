-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_EnchantPets = m_Library.GUI.EnchantPets;
local t_EnchantCost = m_Library.Shared.EnchantCost;
local t_EnchantHardcoreCost = m_Library.Shared.EnchantHardcoreCost;
local Random_new_ret = Random.new();
local bool1 = false;
local table1 = {};
local u1 = false;
local bool2 = false;
local bool3 = false;
local table2 = {};
local table3 = {};
function GetEnchants() -- Line: 29
	--[[
		Upvalues:
			[1] = table3
			[2] = m_Library
	--]]
	if #table3 > 0 then
		return table3;
	end
	for _, val1 in pairs(m_Library.Directory.Powers) do
		table.insert(table3, val1);
	end
	table.sort(table3, function(p6, p7) -- Line: 38
		return p6.dropWeight < p7.dropWeight;
	end);
	return table3;
end
function UpdateEnchantButton() -- Line: 46
	--[[
		Upvalues:
			[1] = bool3
			[2] = t_EnchantPets
	--]]
	if bool3 then
		t_EnchantPets.Side.Enchant.TextLabel.Text = "Stop";
		t_EnchantPets.Side.Enchant.HoverImage = "rbxassetid://7045637564";
		t_EnchantPets.Side.Enchant.Image = "rbxassetid://7045637481";
		return;
	end
	t_EnchantPets.Side.Enchant.TextLabel.Text = "Enchant";
	t_EnchantPets.Side.Enchant.HoverImage = "rbxassetid://7045637411";
	t_EnchantPets.Side.Enchant.Image = "rbxassetid://7045637286";
end
function Enchant() -- Line: 59
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = t_EnchantPets
			[4] = bool3
			[5] = table2
	--]]
	if #table1 > 0 then
		m_Library.Variables.UsingMachine = true;
		t_EnchantPets.Gui.Enabled = false;
		local v12 = {};
		if bool3 then
			for _, val7 in ipairs(table1) do
				local v25 = m_Library.PetCmds.Get(val7);
				if HasAutoEnchant(v25) then continue end
				table.insert(v12, val7);
			end
			if #v12 == 0 then
				m_Library.Message.New("These pets already have the desired enchant!");
				bool3 = false;
				UpdateEnchantButton();
				m_Library.Variables.UsingMachine = false;
				return;
			end
		else
			v12 = table1;
		end
		local v13, v14 = m_Library.Network.Invoke("Enchant Pets", v12, bool3);
		if v13 then
			m_Library.Functions.Wait(2.5);
		else
			m_Library.Message.New(v14 or "Something went wrong. Try again!");
		end
		UpdateEnchantButton();
		m_Library.Variables.UsingMachine = false;
		if bool3 and #table1 > 0 and #table2 > 0 then
			local v21 = 0;
			for _, val8 in ipairs(table1) do
				local v26 = m_Library.PetCmds.Get(val8);
				v21 = v21 + (HasAutoEnchant(v26) and 1 or 0);
			end
			if #table1 <= v21 then
				bool3 = false;
				UpdateEnchantButton();
			end
		end
		if not bool3 then return end
		task.delay(2, function() -- Line: 120
			--[[
				Upvalues:
					[1] = bool3
					[2] = table1
					[3] = t_EnchantPets
					[4] = table2
			--]]
			if not bool3 then return end
			if #table1 <= 0 or not t_EnchantPets.Gui.Enabled or #table2 == 0 then
				bool3 = false;
				UpdateEnchantButton();
				return;
			end
			Enchant();
		end);
	end
end
function Select(p1) -- Line: 137
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = Random_new_ret
			[4] = u1
	--]]
	local v1 = m_Library.PetCmds.Get(p1);
	if not p1 then return end
	local v2 = m_Library.Signal.Invoke("Is Trading Booth Pet", p1);
	if v2 then
		m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can enchant it!");
		return;
	end
	if #table1 >= 3 then return end
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
	table.insert(table1, p1);
	u1 = v1.hc or false;
	Update();
end
function Deselect(p2) -- Line: 163
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret
			[3] = table1
			[4] = u1
	--]]
	m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
	m_Library.Functions.RemoveTable(table1, p2);
	u1 = false;
	Update();
end
function Update() -- Line: 173
	--[[
		Upvalues:
			[1] = t_EnchantPets
			[2] = bool1
			[3] = m_Library
			[4] = table2
			[5] = table1
	--]]
	local function UpdateAuto() -- Line: 175
		--[[
			Upvalues:
				[1] = t_EnchantPets
				[2] = bool1
				[3] = m_Library
				[4] = table2
		--]]
		local t_Holder = t_EnchantPets.Auto.Container.Holder;
		local t_AutoEnchantButton = t_Holder.AutoEnchantButton;
		local Enchants = GetEnchants();
		t_AutoEnchantButton.Visible = false;
		for _, val5 in ipairs(Enchants) do
			for _, val12 in ipairs(val5.tiers) do
				if t_Holder:FindFirstChild(val12.title) or not val5.canDrop then continue end
				local Clone_ret = t_AutoEnchantButton:Clone();
				Clone_ret.Name = val12.title;
				Clone_ret.Label.Text = val12.title;
				Clone_ret.ImageColor3 = Color3.new(0.5, 0.5, 0.5);
				Clone_ret.Visible = true;
				Clone_ret.Parent = t_Holder;
				Clone_ret.Activated:Connect(function() -- Line: 197
					--[[
						Upvalues:
							[1] = bool1
							[2] = m_Library
							[3] = table2
							[4] = val12
							[5] = Clone_ret
					--]]
					if not bool1 then
						bool1 = true;
						if m_Library.Functions.SearchArray(table2, val12.title) then
							m_Library.Functions.RemoveTable(table2, val12.title);
							Clone_ret.ImageColor3 = Color3.new(0.5, 0.5, 0.5);
						else
							table.insert(table2, val12.title);
							Clone_ret.ImageColor3 = Color3.new(1, 1, 1);
						end
						bool1 = false;
					end
				end);
				m_Library.GUIFX.ButtonFX(Clone_ret);
			end
		end
		local function Scrolling() -- Line: 217
			--[[
				Upvalues:
					[1] = t_Holder
			--]]
			local UIListLayout = t_Holder:FindFirstChildOfClass("UIListLayout");
			local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
			UIListLayout:ApplyLayout();
			t_Holder.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingBottom.Offset + UIPadding.PaddingTop.Offset);
		end
		Scrolling();
	end
	local function UpdatePets() -- Line: 228
		--[[
			Upvalues:
				[1] = t_EnchantPets
				[2] = m_Library
				[3] = table1
		--]]
		for _, child6 in ipairs(t_EnchantPets.Holder:GetChildren()) do
			if child6.ClassName ~= "TextButton" then continue end
			local t_Name = child6.Name;
			local v24 = m_Library.Functions.SearchArray(table1, t_Name);
			child6.Equipped.Visible = v24;
			child6.BackgroundColor3 = v24 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			local Attribute = child6:GetAttribute("Locked");
			if Attribute then continue end
			child6.BackgroundColor3 = v24 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			child6.PetIcon.ImageTransparency = 0;
		end
	end
	local function UpdateSide() -- Line: 249
		--[[
			Upvalues:
				[1] = table1
				[2] = m_Library
				[3] = t_EnchantPets
		--]]
		local v18 = #table1 > 0;
		local v19 = GetCost();
		if m_Library.Variables.Console then
			t_EnchantPets.Side.Enchant.ButtonKeybind.Visible = true;
		else
			t_EnchantPets.Side.Enchant.ButtonKeybind.Visible = false;
		end
		local function HasPerk() -- Line: 259
			--[[
				Upvalues:
					[1] = m_Library
			--]]
			local v27 = m_Library.Save.Get();
			if not v27 then
				return false;
			end
			local t_Enchanting = v27.Mastery.Enchanting;
			if t_Enchanting and m_Library.Shared.MasteryXPToLevel(t_Enchanting) >= 99 then
				return true;
			end
			return false;
		end
		local v20 = m_Library.Save.Get();
		local bool4;
		if not v20 then
			bool4 = false;
		else
			local t_Enchanting2 = v20.Mastery.Enchanting;
			if t_Enchanting2 and m_Library.Shared.MasteryXPToLevel(t_Enchanting2) >= 99 then
				bool4 = true;
			else
				bool4 = false;
			end
		end
		if bool4 then
			v19 = math.round(v19 * 0.75);
		end
		t_EnchantPets.Side.Enchant.ImageColor3 = v18 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
		t_EnchantPets.Side.CostFrame.Cost.Text = m_Library.Functions.Commas(v19);
	end
	UpdateAuto();
	UpdatePets();
	UpdateSide();
	Scaling();
end
function Setup() -- Line: 291
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_EnchantPets
			[3] = bool1
			[4] = table1
	--]]
	local v6 = m_Library.Save.Get();
	if not v6 then return end
	local v7 = 0;
	local v8 = m_Library.Shared.SortPets(v6, table.clone(v6.Pets));
	for key2, val2 in ipairs(v8) do
		local t_uid = val2.uid;
		local _ = val2.s;
		local v15 = m_Library.Directory.Pets[val2.id];
		local t_rarity = v15.rarity;
		if v15.isPremium or t_rarity == "Secret" or t_rarity == "Mythical" or t_rarity == "Event" or t_rarity == "Exclusive" or v15.isGift then continue end
		local Clone_ret2 = m_Library.Assets.UI.Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret2, t_uid);
		Clone_ret2.LayoutOrder = key2;
		Clone_ret2:SetAttribute("DirId", val2.id);
		Clone_ret2.Parent = t_EnchantPets.Holder;
		Clone_ret2.Activated:Connect(function() -- Line: 319
			--[[
				Upvalues:
					[1] = bool1
					[2] = m_Library
					[3] = table1
					[4] = t_uid
			--]]
			if not bool1 then
				bool1 = true;
				if not m_Library.Functions.SearchArray(table1, t_uid) then
					Select(t_uid);
				else
					Deselect(t_uid);
				end
				bool1 = false;
			end
		end);
		m_Library.GUIFX.ButtonFX(Clone_ret2);
		v7 = v7 + 1;
	end
	t_EnchantPets.Container.NoPets.Visible = v7 <= 0;
	Update();
	Scaling();
end
function Scaling() -- Line: 343
	--[[
		Upvalues:
			[1] = t_EnchantPets
			[2] = m_Library
	--]]
	local t_Holder2 = t_EnchantPets.Container.Holder;
	local UIGridLayout = t_Holder2:FindFirstChildOfClass("UIGridLayout");
	local UIPadding2 = t_Holder2:FindFirstChildOfClass("UIPadding");
	local v9 = m_Library.Functions.ResolutionScale();
	local v10 = (t_Holder2.AbsoluteSize.X - t_Holder2.ScrollBarThickness - UIPadding2.PaddingLeft.Offset - UIPadding2.PaddingRight.Offset) / (v9 <= 0.5 and 4 or v9 <= 1.1 and 5 or 6) - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v10, 0, v10);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder2.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 30);
end
function Clear() -- Line: 367
	--[[
		Upvalues:
			[1] = t_EnchantPets
	--]]
	for _, child3 in ipairs(t_EnchantPets.Holder:GetChildren()) do
		if child3.ClassName ~= "TextButton" then continue end
		child3:Destroy();
	end
end
function HasAutoEnchant(p3) -- Line: 378
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table2
	--]]
	if p3 then
		local t_powers = p3.powers;
		if t_powers then
			for _, val9 in ipairs(t_powers) do
				if not m_Library.Functions.SearchArray(table2, m_Library.Directory.Powers[val9[1]].tiers[val9[2]].title) then continue end
				return true;
			end
		end
	end
	return false;
end
function GetCost() -- Line: 397
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = t_EnchantHardcoreCost
			[4] = t_EnchantCost
	--]]
	local v11 = 0;
	for _, val4 in ipairs(table1) do
		local v16 = m_Library.PetCmds.Get(val4);
		if not v16 then continue end
		v11 = v11 + (v16.hc and t_EnchantHardcoreCost or t_EnchantCost);
	end
	return v11;
end
t_EnchantPets.Side.Enchant.Activated:Connect(function() -- Line: 415
	--[[
		Upvalues:
			[1] = bool1
			[2] = bool2
			[3] = bool3
			[4] = table1
			[5] = m_Library
			[6] = table2
	--]]
	if not bool1 then
		bool1 = true;
		bool2 = true;
		if bool3 then
			bool3 = false;
			UpdateEnchantButton();
			bool2 = false;
			bool1 = false;
			return;
		end
		if #table1 > 0 then
			local str1 = "Are you sure?";
			for _, val10 in ipairs(table1) do
				local v28 = m_Library.PetCmds.Get(val10);
				if not v28 or not v28.powers or #v28.powers <= 0 then continue end
				str1 = "Are you sure? Enchantments will be replaced.";
			end
			local v22 = m_Library.Message.New(str1, true);
			if v22 then
				if #table2 > 0 then
					bool3 = true;
					UpdateEnchantButton();
				end
				Enchant();
			end
		end
		bool2 = false;
		bool1 = false;
	end
end);
t_EnchantPets.Close.Activated:Connect(function() -- Line: 463
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_EnchantPets
	--]]
	if not bool1 then
		bool1 = true;
		t_EnchantPets.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_EnchantPets.Close);
m_Library.GUIFX.ButtonFX(t_EnchantPets.Side.Enchant);
m_Library.Signal.Fired("Window Closed"):Connect(function(p4) -- Line: 479
	--[[
		Upvalues:
			[1] = t_EnchantPets
	--]]
	if p4 == t_EnchantPets.Gui then
		Clear();
	end
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p5) -- Line: 490
	--[[
		Upvalues:
			[1] = bool2
			[2] = t_EnchantPets
			[3] = m_Library
	--]]
	if bool2 then return end
	if p5 == t_EnchantPets.Gui then
		Clear();
		Setup();
		if t_EnchantPets.Gui.Enabled and m_Library.Variables.Console then
			m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("EnchantPets"):FindFirstChild("Frame"):FindFirstChild("Container"):FindFirstChild("Holder");
		end
		m_Library.Audio.Play("rbxassetid://7216322559", script, 1, 0.5);
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 508
	--[[
		Upvalues:
			[1] = t_EnchantPets
	--]]
	if t_EnchantPets.Gui.Enabled then
		task.defer(function() -- Line: 510
			Scaling();
		end);
	end
end);
m_Library.Signal.Fired("Attempt Enchant"):Connect(function() -- Line: 517
	--[[
		Upvalues:
			[1] = table1
			[2] = bool1
			[3] = bool2
			[4] = m_Library
			[5] = table2
			[6] = bool3
	--]]
	if #table1 <= 0 then return end
	if not bool1 then
		bool1 = true;
		bool2 = true;
		if #table1 > 0 then
			local str2 = "Are you sure?";
			for _, val11 in ipairs(table1) do
				local v29 = m_Library.PetCmds.Get(val11);
				if not v29 or not v29.powers or #v29.powers <= 0 then continue end
				str2 = "Are you sure? Enchantments will be replaced.";
			end
			local v23 = m_Library.Message.New(str2, true);
			if v23 then
				if #table2 > 0 then
					bool3 = true;
					UpdateEnchantButton();
				end
				Enchant();
			end
		end
		bool2 = false;
		bool1 = false;
	end
end);
