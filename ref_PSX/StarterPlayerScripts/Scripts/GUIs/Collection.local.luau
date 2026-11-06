-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Collection = m_Library.GUI.Collection;
local bool1 = false;
local bool2 = false;
local u1 = false;
local u2 = false;
local str1 = "";
function Update() -- Line: 23
	local v1 = m_Library.Save.Get();
	if not v1 or not v1.Collection then return end
	local v10;
	if t_Collection.Query.Text == "" then
		v10 = false;
	else
		v10 = t_Collection.Query.Text ~= nil;
	end
	local v2 = v10 and m_Library.Functions.RegexEscape(string.lower(tostring(t_Collection.Query.Text))) or nil;
	for _, child1 in ipairs(t_Collection.Container.Holder:GetChildren()) do
		if not child1:GetAttribute("petId") then continue end
		local Attribute = child1:GetAttribute("petId");
		local Attribute2 = child1:GetAttribute("name");
		local Attribute3 = child1:GetAttribute("rarity");
		local Attribute4 = child1:GetAttribute("isGolden");
		local Attribute5 = child1:GetAttribute("isRainbow");
		local Attribute6 = child1:GetAttribute("isDarkMatter");
		local v11 = m_Library.Functions.SearchArray(v1.Collection, Attribute .. "-" .. (Attribute4 and 2 or Attribute5 and 3 or Attribute6 and 4 or 1));
		child1.PetIcon.ImageColor3 = v11 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
		child1.PetIcon.Locked.Visible = not v11;
		local str2 = nil;
		if Attribute4 then
			str2 = "Golden";
		elseif Attribute5 then
			str2 = "Rainbow";
		elseif Attribute6 then
			str2 = "Dark Matter";
		end
		local v12 = true;
		if v10 then
			local bool3 = false;
			if string.find(string.lower(Attribute2), v2, 1, true) then
				bool3 = true;
			elseif string.find(string.lower(Attribute3), v2, 1, true) then
				bool3 = true;
			elseif str2 and string.find(string.lower(str2), v2, 1, true) then
				bool3 = true;
			end
			v12 = bool3;
		end
		if u2 then
			child1.Visible = not v11 and v12;
			continue;
		end
		child1.Visible = v12;
	end
	UpdateBottom();
end
function UpdateBottom() -- Line: 83
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Collection
			[3] = u1
			[4] = u2
	--]]
	local v3 = m_Library.Save.Get();
	if not v3 or not v3.Collection then return end
	local t_CollectionTier = v3.CollectionTier;
	local v4 = #v3.Collection;
	local v5 = m_Library.Shared.PetCollectionTiers[t_CollectionTier + 1];
	local v6 = v5 and v5 <= v4;
	t_Collection.Bottom.Tier.Text = "Tier " .. t_CollectionTier;
	t_Collection.Bottom.PetGoal.Text = v5 and m_Library.Functions.Commas(v5) .. " Pets" or "Max";
	t_Collection.Bottom.PetProgress.Text = m_Library.Functions.Commas(v4) .. " Pets";
	t_Collection.Bottom.Redeem.Visible = v6;
	t_Collection.Bottom.Progress.Visible = not v6;
	t_Collection.Bottom.Title.Visible = not v6;
	t_Collection.BottomBar.Grid.Image = u1 and "rbxassetid://6958935961" or "rbxassetid://6958936066";
	t_Collection.BottomBar.Missing.Image = u2 and "rbxassetid://11783443248" or "rbxassetid://11783443142";
	if not v6 then
		local v13 = 1;
		if v5 then
			local v23 = m_Library.Shared.PetCollectionTiers[t_CollectionTier] or 0;
			v13 = math.clamp((v4 - v23) / (v5 - v23), 0, 1);
		end
		t_Collection.Bottom.Progress.Bar.Size = UDim2.new(v13, 0, 1, 0);
	end
end
function Render(p1) -- Line: 119
	--[[
		Upvalues:
			[1] = m_Library
			[2] = bool2
			[3] = t_Collection
			[4] = u2
	--]]
	local u3 = m_Library.Save.Get();
	if not u3 or not u3.Collection then return end
	bool2 = true;
	local AllCollectablePets = m_Library.Shared.GetAllCollectablePets();
	table.sort(AllCollectablePets, function(p5, p6) -- Line: 130
		--[[
			Upvalues:
				[1] = m_Library
		--]]
		local v15 = m_Library.Directory.Pets[p5.petId];
		local v16 = m_Library.Directory.Pets[p6.petId];
		local v17 = m_Library.Shared.PetRarityNumbers[v15.rarity];
		local v18 = m_Library.Shared.PetRarityNumbers[v16.rarity];
		local v19 = (v15.strengthMin + v15.strengthMax) / 2;
		local v20 = (v16.strengthMin + v16.strengthMax) / 2;
		local v21 = p5.isGolden and 2 or p5.isRainbow and 3 or p5.isDarkMatter and 4 or 1;
		local v22 = p6.isGolden and 2 or p6.isRainbow and 3 or p6.isDarkMatter and 4 or 1;
		if v17 == v18 then
			if v19 == v20 then
				if v21 == v22 then
					return tonumber(p5.petId) > tonumber(p6.petId);
				end
				return v21 < v22;
			end
			return v19 < v20;
		end
		return v17 < v18;
	end);
	task.spawn(function() -- Line: 151
		--[[
			Upvalues:
				[1] = AllCollectablePets
				[2] = bool2
				[3] = m_Library
				[4] = u3
				[5] = t_Collection
				[6] = u2
				[7] = p1
		--]]
		for key3, val3 in ipairs(AllCollectablePets) do
			if not bool2 then return end
			if key3 % 50 == 0 then
				Scaling();
				wait(0.1);
			end
			local t_petId = val3.petId;
			local t_isGolden = val3.isGolden;
			local t_isRainbow = val3.isRainbow;
			local t_isDarkMatter = val3.isDarkMatter;
			local v24 = m_Library.Directory.Pets[t_petId];
			local t_name = v24.name;
			local t_rarity = v24.rarity;
			local Clone_ret = m_Library.Assets.UI.Inventory.Pet:Clone();
			m_Library.PetUI.Create(Clone_ret, t_petId, {
				g = t_isGolden,
				r = t_isRainbow,
				dm = t_isDarkMatter
			});
			Clone_ret:FindFirstChild("Level"):Destroy();
			if v24.titanic then
				Clone_ret.LayoutOrder = 9999999;
			elseif v24.huge then
				Clone_ret.LayoutOrder = 99999;
			else
				Clone_ret.LayoutOrder = key3;
			end
			Clone_ret:SetAttribute("petId", t_petId);
			Clone_ret:SetAttribute("name", t_name);
			Clone_ret:SetAttribute("rarity", t_rarity);
			Clone_ret:SetAttribute("isGolden", t_isGolden);
			Clone_ret:SetAttribute("isRainbow", t_isRainbow);
			Clone_ret:SetAttribute("isDarkMatter", t_isDarkMatter);
			local Attribute7 = Clone_ret:GetAttribute("petId");
			local Attribute8 = Clone_ret:GetAttribute("isGolden");
			local Attribute9 = Clone_ret:GetAttribute("isRainbow");
			local Attribute10 = Clone_ret:GetAttribute("isDarkMatter");
			local v25 = m_Library.Functions.SearchArray(u3.Collection, Attribute7 .. "-" .. (Attribute8 and 2 or Attribute9 and 3 or Attribute10 and 4 or 1));
			Clone_ret.PetIcon.ImageColor3 = v25 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
			Clone_ret.PetIcon.Locked.Visible = not v25;
			local v28;
			if t_Collection.Query.Text == "" then
				v28 = false;
			else
				v28 = t_Collection.Query.Text ~= nil;
			end
			local v26 = v28 and m_Library.Functions.RegexEscape(string.lower(tostring(t_Collection.Query.Text))) or nil;
			local str3 = nil;
			if Attribute8 then
				str3 = "Golden";
			elseif Attribute9 then
				str3 = "Rainbow";
			elseif Attribute10 then
				str3 = "Dark Matter";
			end
			local v27 = true;
			if v28 then
				local bool4 = false;
				if string.find(string.lower(t_name), v26, 1, true) then
					bool4 = true;
				elseif string.find(string.lower(t_rarity), v26, 1, true) then
					bool4 = true;
				elseif str3 and string.find(string.lower(str3), v26, 1, true) then
					bool4 = true;
				end
				v27 = bool4;
			end
			if u2 then
				Clone_ret.Visible = not v25 and v27;
			else
				Clone_ret.Visible = v27;
			end
			Clone_ret.Parent = t_Collection.Container.Holder;
		end
		if p1 then
			p1();
		end
	end);
end
function Scaling() -- Line: 235
	--[[
		Upvalues:
			[1] = t_Collection
			[2] = m_Library
			[3] = u1
	--]]
	local t_Holder = t_Collection.Container.Holder;
	local UIGridLayout = t_Holder:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	local v7 = m_Library.Functions.ResolutionScale();
	local v8 = v7 <= 0.5 and 6 or v7 <= 1.1 and 7 or 8;
	if u1 then
		UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10);
	else
		UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 20);
	end
	local v9 = (t_Holder.AbsoluteSize.X - t_Holder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / v8 - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v9, 0, v9);
	if u1 then
		udim2 = UDim2.new(0, udim2.X.Offset / 2, 0, udim2.Y.Offset / 2);
	end
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + (u1 and 25.38 or 30));
end
function ToggleGrid() -- Line: 270
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	debug.profilebegin("Collection.ToggleGrid");
	u1 = not u1;
	m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
	Scaling();
	UpdateBottom();
	debug.profileend();
end
function ToggleMissing() -- Line: 280
	--[[
		Upvalues:
			[1] = u2
	--]]
	debug.profilebegin("Collection.ToggleGrid");
	u2 = not u2;
	Update();
	Scaling();
	debug.profileend();
end
function Clear() -- Line: 289
	--[[
		Upvalues:
			[1] = t_Collection
			[2] = u1
			[3] = str1
			[4] = bool2
	--]]
	for _, child2 in ipairs(t_Collection.Container.Holder:GetChildren()) do
		if not child2:GetAttribute("petId") then continue end
		child2:Destroy();
	end
	u1 = false;
	str1 = "";
	bool2 = false;
end
m_Library.GUIFX.ButtonFX(t_Collection.BottomBar.Grid);
m_Library.GUIFX.Tooltip(t_Collection.BottomBar.Grid, "Toggle Grid View");
t_Collection.BottomBar.Grid.Activated:Connect(function() -- Line: 306
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		ToggleGrid();
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Collection.BottomBar.Missing);
m_Library.GUIFX.Tooltip(t_Collection.BottomBar.Missing, "Toggle Missing Only");
t_Collection.BottomBar.Missing.Activated:Connect(function() -- Line: 317
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		ToggleMissing();
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Collection.Close);
t_Collection.Close.Activated:Connect(function() -- Line: 327
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Collection
	--]]
	if not bool1 then
		bool1 = true;
		t_Collection.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Collection.Bottom.Redeem);
t_Collection.Bottom.Redeem.Activated:Connect(function() -- Line: 337
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		local v14 = m_Library.Network.Invoke("Redeem Pet Collection");
		if v14 then
			m_Library.Audio.Play("rbxassetid://135554994529814", script);
			m_Library.Message.New("Congrats! You earned +1 Brainrot Equipped! \240\159\152\132");
		else
			m_Library.Message.New("Could not redeem.");
		end
		bool1 = false;
	end
end);
t_Collection.BottomBar.Search.Query:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 355
	--[[
		Upvalues:
			[1] = t_Collection
	--]]
	if t_Collection.BottomBar.Search.Query.Text ~= "" then
		t_Collection.Container.Holder.CanvasPosition = Vector2.new();
	end
	Update();
	Scaling();
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p2) -- Line: 368
	--[[
		Upvalues:
			[1] = t_Collection
			[2] = bool2
			[3] = m_Library
	--]]
	if p2 == t_Collection.Gui and not bool2 then
		Render(function() -- Line: 370
			Update();
			Scaling();
		end);
		if t_Collection.Gui.Enabled and m_Library.Variables.Console then
			print("Set selected obj");
			m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("Collection"):FindFirstChild("Frame"):FindFirstChild("Container"):FindFirstChild("Holder");
		end
	end
end);
m_Library.Signal.Fired("Window Closed"):Connect(function(p3) -- Line: 383
	--[[
		Upvalues:
			[1] = t_Collection
	--]]
	if p3 == t_Collection.Gui then
		Clear();
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p4) -- Line: 390
	if p4 == "Collection" or p4 == "CollectionTier" then
		Update();
		Scaling();
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 398
	task.defer(function() -- Line: 399
		Scaling();
	end);
end);
