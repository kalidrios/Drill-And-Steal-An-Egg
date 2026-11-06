-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_FusePets = m_Library.GUI.FusePets;
local t_FuseMinPets = m_Library.Shared.FuseMinPets;
local t_FuseMaxPets = m_Library.Shared.FuseMaxPets;
local t_FusePetsCost = m_Library.Shared.FusePetsCost;
local t_FuseHardcoreCost = m_Library.Shared.FuseHardcoreCost;
local Random_new_ret = Random.new();
local bool1 = false;
local table1 = {};
local bool2 = false;
local u1 = {};
local u2 = false;
function Fuse() -- Line: 25
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = t_FusePets
	--]]
	if #u1 > 0 then
		m_Library.Variables.UsingMachine = true;
		t_FusePets.Gui.Enabled = false;
		local v9, v10 = m_Library.Network.Invoke("Fuse Pets", u1);
		if v9 then
			m_Library.Functions.Wait(1.2);
		else
			m_Library.Message.New(v10 or "Something went wrong. Try again!");
		end
		m_Library.Variables.UsingMachine = false;
	end
end
function Select(p1) -- Line: 47
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = u2
			[4] = t_FuseMaxPets
			[5] = Random_new_ret
	--]]
	local v1 = m_Library.PetCmds.Get(p1);
	if not p1 then return end
	if #table1 > 0 and (v1.hc or false) ~= u2 then return end
	if t_FuseMaxPets <= #table1 then return end
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
	table.insert(table1, p1);
	u2 = v1.hc or false;
	Update();
end
function Deselect(p2) -- Line: 75
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = u2
	--]]
	for key1, val1 in ipairs(table1) do
		if val1 ~= p2 then continue end
		m_Library.Audio.Play("rbxassetid://7139317909", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
		table.remove(table1, key1);
		break;
	end
	if #table1 <= 0 then
		u2 = false;
	end
	Update();
end
function Update() -- Line: 94
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = t_FusePets
			[4] = u2
			[5] = t_FuseHardcoreCost
			[6] = t_FusePetsCost
			[7] = t_FuseMinPets
			[8] = t_FuseMaxPets
	--]]
	local function UpdatePets() -- Line: 96
		--[[
			Upvalues:
				[1] = table1
				[2] = m_Library
				[3] = t_FusePets
				[4] = u2
		--]]
		local v12 = table1[1] and m_Library.PetCmds.Get(table1[1]) or nil;
		for _, child4 in ipairs(t_FusePets.Holder:GetChildren()) do
			if child4.ClassName ~= "TextButton" then continue end
			local t_Name = child4.Name;
			local v17 = m_Library.Functions.SearchArray(table1, t_Name);
			child4.Equipped.Visible = v17;
			child4.BackgroundColor3 = v17 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			local Attribute = child4:GetAttribute("Locked");
			if not Attribute then
				child4.BackgroundColor3 = v17 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
				child4.PetIcon.ImageTransparency = 0;
			end
			child4.Visible = v12 == nil and true or child4:GetAttribute("Hardcore") == u2;
		end
	end
	local function UpdateSide() -- Line: 123
		--[[
			Upvalues:
				[1] = u2
				[2] = t_FuseHardcoreCost
				[3] = t_FusePetsCost
				[4] = table1
				[5] = t_FuseMinPets
				[6] = t_FusePets
				[7] = m_Library
				[8] = t_FuseMaxPets
		--]]
		local v13 = u2 and t_FuseHardcoreCost or t_FusePetsCost;
		local v14 = t_FuseMinPets <= #table1 and table1[1] or false;
		t_FusePets.Side.Fuse.ImageColor3 = v14 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
		t_FusePets.Side.CostFrame.Cost.Text = m_Library.Functions.Commas(v13);
		if m_Library.Variables.Console then
			t_FusePets.Side.Fuse.ButtonKeybind.Visible = true;
		else
			t_FusePets.Side.Fuse.ButtonKeybind.Visible = false;
		end
		if v14 then
			t_FusePets.Side.Notice.Text = "Fuse " .. #table1 .. "/" .. t_FuseMaxPets .. " Pets";
			return;
		end
		t_FusePets.Side.Notice.Text = "Select 3+ pets you want to fuse!";
	end
	UpdatePets();
	UpdateSide();
	Scaling();
end
function Setup() -- Line: 147
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_FusePets
			[3] = bool1
			[4] = table1
	--]]
	local v4 = m_Library.Save.Get();
	if not v4 then return end
	local v5 = 0;
	local v6 = m_Library.Shared.SortPets(v4, table.clone(v4.Pets));
	for key2, val2 in ipairs(v6) do
		local t_uid = val2.uid;
		local _ = val2.s;
		local t_hc = val2.hc;
		local v11 = m_Library.Directory.Pets[val2.id];
		local t_rarity = v11.rarity;
		if v11.isPremium or t_rarity == "Event" or t_rarity == "Exclusive" or t_rarity == "Secret" or t_rarity == "Mythical" or v11.isGift then continue end
		local Clone_ret = m_Library.Assets.UI.Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret, t_uid);
		Clone_ret.LayoutOrder = key2;
		Clone_ret:SetAttribute("DirId", val2.id);
		Clone_ret:SetAttribute("Hardcore", t_hc or false);
		Clone_ret.Parent = t_FusePets.Holder;
		Clone_ret.Activated:Connect(function() -- Line: 177
			--[[
				Upvalues:
					[1] = bool1
					[2] = m_Library
					[3] = t_uid
					[4] = val2
					[5] = table1
			--]]
			if not bool1 then
				bool1 = true;
				local v18 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid);
				if val2.l then
					m_Library.Message.New("This pet is locked! Unlock it before you can fuse it!");
				elseif v18 then
					m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can fuse it!");
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
	t_FusePets.Container.NoPets.Visible = v5 <= 0;
	Update();
	Scaling();
end
function Scaling() -- Line: 208
	--[[
		Upvalues:
			[1] = t_FusePets
			[2] = m_Library
	--]]
	local t_Holder = t_FusePets.Container.Holder;
	local UIGridLayout = t_Holder:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	local v7 = m_Library.Functions.ResolutionScale();
	local v8 = (t_Holder.AbsoluteSize.X - t_Holder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / (v7 <= 0.5 and 4 or v7 <= 1.1 and 5 or 6) - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v8, 0, v8);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 30);
end
function Clear() -- Line: 232
	--[[
		Upvalues:
			[1] = table1
			[2] = u2
			[3] = t_FusePets
	--]]
	table1 = {};
	u2 = false;
	for _, child3 in ipairs(t_FusePets.Holder:GetChildren()) do
		if child3.ClassName ~= "TextButton" then continue end
		child3:Destroy();
	end
end
t_FusePets.Side.Fuse.Activated:Connect(function() -- Line: 247
	--[[
		Upvalues:
			[1] = bool1
			[2] = bool2
			[3] = table1
			[4] = t_FuseMinPets
			[5] = u1
			[6] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		bool2 = true;
		if t_FuseMinPets <= #table1 then
			u1 = m_Library.Functions.DeepCopyUnsafe(table1);
			local v15 = m_Library.Message.New("Are you sure?", true);
			if v15 then
				Fuse();
			end
		end
		bool2 = false;
		bool1 = false;
	end
end);
t_FusePets.Close.Activated:Connect(function() -- Line: 269
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_FusePets
	--]]
	if not bool1 then
		bool1 = true;
		t_FusePets.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_FusePets.Close);
m_Library.GUIFX.ButtonFX(t_FusePets.Side.Fuse);
m_Library.Signal.Fired("Window Closed"):Connect(function(p3) -- Line: 285
	--[[
		Upvalues:
			[1] = t_FusePets
	--]]
	if p3 == t_FusePets.Gui then
		Clear();
	end
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p4) -- Line: 296
	--[[
		Upvalues:
			[1] = bool2
			[2] = t_FusePets
			[3] = m_Library
	--]]
	if bool2 then return end
	if p4 == t_FusePets.Gui then
		Clear();
		Setup();
		if t_FusePets.Gui.Enabled and m_Library.Variables.Console then
			print("Set selected obj");
			m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("FusePets"):FindFirstChild("Frame"):FindFirstChild("Container"):FindFirstChild("Holder");
		end
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 313
	--[[
		Upvalues:
			[1] = t_FusePets
	--]]
	if t_FusePets.Gui.Enabled then
		task.defer(function() -- Line: 315
			Scaling();
		end);
	end
end);
m_Library.Signal.Fired("Attempt Fuse"):Connect(function() -- Line: 321
	--[[
		Upvalues:
			[1] = bool1
			[2] = bool2
			[3] = table1
			[4] = t_FuseMinPets
			[5] = u1
			[6] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		bool2 = true;
		if t_FuseMinPets <= #table1 then
			u1 = m_Library.Functions.DeepCopyUnsafe(table1);
			local v16 = m_Library.Message.New("Are you sure?", true);
			if v16 then
				Fuse();
			end
		end
		bool2 = false;
		bool1 = false;
	end
end);
