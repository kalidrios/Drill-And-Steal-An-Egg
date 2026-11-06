-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").Pets);
local t_HugeMachine = m_Library.GUI.HugeMachine;
local Random_new_ret = Random.new();
local u1 = m_Library.Shared.HugeMachineUseProducts[1];
local u2 = m_Library.Shared.HugeMachineUseProducts[2];
local u3 = m_Library.Shared.HugeMachineUseProducts[3];
local bool1 = false;
local table1 = {};
local u4 = 0;
local bool2 = false;
local u5 = {};
function UpdatePoints() -- Line: 37
	--[[
		Upvalues:
			[1] = u4
			[2] = table1
			[3] = m_Library
	--]]
	u4 = 0;
	for _, val1 in ipairs(table1) do
		local v16 = m_Library.PetCmds.Get(val1);
		if not val1 then continue end
		assert(v16);
		local v17 = m_Library.Directory.Pets[v16.id];
		if not v17 then continue end
		local v18 = m_Library.Shared.ComputeHugeMachinePoints(v16, v17);
		if not v18 then continue end
		assert(v18);
		u4 = u4 + v18;
	end
end
function Convert() -- Line: 69
	--[[
		Upvalues:
			[1] = u5
			[2] = m_Library
			[3] = t_HugeMachine
			[4] = bool2
	--]]
	if #u5 > 0 then
		m_Library.Variables.UsingMachine = true;
		t_HugeMachine.Gui.Enabled = false;
		bool2 = true;
		local v19, v20, v21 = m_Library.Network.Invoke("Attempt Use Huge Machine", u5);
		if not v19 then
			m_Library.Message.New(v20);
			bool2 = false;
		elseif v21 then
			m_Library.Shared.PromptPurchase(v21, true);
		else
			task.delay(3, function() -- Line: 85
				--[[
					Upvalues:
						[1] = bool2
				--]]
				bool2 = false;
			end);
		end
		m_Library.Variables.UsingMachine = false;
	end
end
function Select(p1) -- Line: 95
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = u4
			[4] = Random_new_ret
	--]]
	if table.find(table1, p1) then
		return false;
	end
	local v1 = m_Library.PetCmds.Get(p1);
	if not p1 then
		return false;
	end
	assert(v1);
	local v2 = m_Library.Directory.Pets[v1.id];
	if not v2 then
		return false;
	end
	assert(v2);
	local v3 = m_Library.Shared.ComputeHugeMachinePoints(v1, v2);
	if not v3 then
		return false;
	end
	assert(v3);
	local v4 = u4;
	local v5 = v4 + v3;
	local HugeMachineProduct = m_Library.Shared.GetHugeMachineProduct(v4);
	local HugeMachineProduct2 = m_Library.Shared.GetHugeMachineProduct(v5);
	if HugeMachineProduct then
		if not HugeMachineProduct2 then
			return false;
		end
		if HugeMachineProduct == HugeMachineProduct2 and not m_Library.Shared.GetHugeMachineProduct(v5, 0) then
			return false;
		end
	end
	table.insert(table1, p1);
	u4 = v5;
	m_Library.Audio.Play("rbxassetid://7139317934", script, Random_new_ret:NextNumber(0.95, 1.05), 0.75);
	Update();
	return true;
end
function Deselect(p2) -- Line: 154
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table_find_ret = table.find(table1, p2);
	if table_find_ret then
		table.remove(table1, table_find_ret);
		Update();
		return true;
	end
	return false;
end
function GetInfo() -- Line: 167
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u4
	--]]
	return m_Library.Shared.GetHugeMachineProduct(u4);
end
function Update() -- Line: 172
	--[[
		Upvalues:
			[1] = t_HugeMachine
			[2] = m_Library
			[3] = table1
			[4] = u4
			[5] = u1
			[6] = u2
			[7] = u3
	--]]
	UpdatePoints();
	local function UpdatePets() -- Line: 176
		--[[
			Upvalues:
				[1] = t_HugeMachine
				[2] = m_Library
				[3] = table1
		--]]
		for _, child8 in ipairs(t_HugeMachine.Holder:GetChildren()) do
			if child8.ClassName ~= "TextButton" or child8.Name == "Template" then continue end
			local t_Name = child8.Name;
			local Attribute = child8:GetAttribute("DirId");
			local Attribute2 = child8:GetAttribute("Locked");
			if not Attribute then continue end
			local v32 = m_Library.Functions.SearchArray(table1, t_Name);
			child8.Equipped.Visible = v32;
			child8.BackgroundColor3 = v32 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			if Attribute2 then continue end
			child8.BackgroundColor3 = v32 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
			child8.PetIcon.ImageTransparency = 0;
		end
	end
	local function UpdateSide() -- Line: 202
		--[[
			Upvalues:
				[1] = table1
				[2] = t_HugeMachine
				[3] = m_Library
				[4] = u4
				[5] = u1
				[6] = u2
				[7] = u3
		--]]
		local v31 = #table1 > 0;
		t_HugeMachine.Side.Notice.Visible = not v31;
		t_HugeMachine.Side.PriceFrame.Visible = not v31;
		t_HugeMachine.Side.FinalPriceFrame.Visible = v31;
		t_HugeMachine.Side.PointsFrame.Visible = v31;
		if not v31 then
			t_HugeMachine.Side.AddMoreNotice.Visible = false;
		end
		if m_Library.Variables.Console then
			t_HugeMachine.Side.Convert.ButtonKeybind.Visible = true;
		else
			t_HugeMachine.Side.Convert.ButtonKeybind.Visible = false;
		end
		if v31 then
			local Info = GetInfo();
			if Info then
				local t_price = Info.price;
				if t_price then
					t_HugeMachine.Side.FinalPriceFrame.Cost.Text = m_Library.Functions.Commas(t_price);
					t_HugeMachine.Side.FinalPriceFrame.Icon.Visible = true;
				else
					t_HugeMachine.Side.FinalPriceFrame.Cost.Text = "FREE";
					t_HugeMachine.Side.FinalPriceFrame.Icon.Visible = false;
				end
				t_HugeMachine.Side.FinalPriceFrame.Cost.Visible = true;
				t_HugeMachine.Side.AddMoreNotice.Visible = false;
			else
				t_HugeMachine.Side.FinalPriceFrame.Cost.Visible = false;
				t_HugeMachine.Side.FinalPriceFrame.Icon.Visible = false;
				t_HugeMachine.Side.AddMoreNotice.Visible = true;
			end
			t_HugeMachine.Side.PointsFrame.Tier1.Text = math.min(u4, u1.pointsMin) .. "/" .. u1.pointsMin .. " points";
			t_HugeMachine.Side.PointsFrame.Tier2.Text = math.min(u4, u2.pointsMin) .. "/" .. u2.pointsMin .. " points";
			t_HugeMachine.Side.PointsFrame.Tier3.Text = math.min(u4, u3.pointsMin) .. "/" .. u3.pointsMin .. " points";
			local v33 = u4 >= u1.pointsMin;
			local v34 = u4 >= u2.pointsMin;
			local v35 = u4 >= u3.pointsMin;
			local function UpdateText(p13, p14) -- Line: 252
				p13.TextColor3 = p14 and Color3.fromRGB(92, 255, 65) or Color3.fromRGB(28, 69, 82);
				p13.TextStrokeColor3 = p14 and Color3.fromRGB(22, 60, 15) or Color3.fromRGB(0, 0, 0);
				p13.TextStrokeTransparency = p14 and 0 or 1;
			end
			UpdateText(t_HugeMachine.Side.PointsFrame.Tier1, v33);
			UpdateText(t_HugeMachine.Side.PointsFrame.Tier2, v34);
			UpdateText(t_HugeMachine.Side.PointsFrame.Tier3, v35);
		end
	end
	t_HugeMachine.Side.Convert.ImageColor3 = u4 >= u1.pointsMin and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	UpdatePets();
	UpdateSide();
	Scaling();
end
function PetOrder(p3, p4) -- Line: 274
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_id = p3.id;
	local t_id2 = p4.id;
	local v8 = m_Library.Directory.Pets[t_id];
	local v9 = m_Library.Directory.Pets[t_id2];
	local v10 = m_Library.Shared.ComputeHugeMachinePoints(p3, v8) or 0;
	local v11 = m_Library.Shared.ComputeHugeMachinePoints(p4, v9) or 0;
	if v11 < v10 then
		return -1;
	end
	if v10 < v11 then
		return 1;
	end
	return m_Library.Shared.PetOrderBest(p3, p4);
end
function Setup() -- Line: 291
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_HugeMachine
			[3] = bool1
			[4] = table1
	--]]
	local v12 = m_Library.Save.Get();
	if not v12 then return end
	assert(v12);
	local table2 = {};
	for _, val2 in ipairs(v12.Pets) do
		local v22 = m_Library.Directory.Pets[val2.id];
		if not v22 then continue end
		assert(v22);
		local v23 = m_Library.Shared.ComputeHugeMachinePoints(val2, v22);
		if not v23 then continue end
		table.insert(table2, val2);
	end
	table.sort(table2, function(p11, p12) -- Line: 320
		return PetOrder(p11, p12) < 0;
	end);
	for key3, val3 in ipairs(table2) do
		local t_uid = val3.uid;
		local Clone_ret = t_HugeMachine.Pets.Holder.Template:Clone();
		m_Library.PetUI.Create(Clone_ret, t_uid);
		local v24 = m_Library.Directory.Pets[val3.id];
		local v25 = m_Library.Shared.ComputeHugeMachinePoints(val3, v24);
		Clone_ret.Stars.Visible = false;
		Clone_ret.Points.Text = tostring(v25) .. "pt";
		Clone_ret.Visible = true;
		Clone_ret.LayoutOrder = key3;
		Clone_ret:SetAttribute("DirId", val3.id);
		Clone_ret.Parent = t_HugeMachine.Holder;
		Clone_ret.Activated:Connect(function() -- Line: 345
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
				local v38 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_uid);
				if val3.l then
					m_Library.Message.New("This pet is locked! Unlock it before you can use it in the Huge Machine!");
				elseif v38 then
					m_Library.Message.New("This pet is currently in your trading booth! Remove it before you can use it in the Huge Machine!");
				elseif not m_Library.Functions.SearchArray(table1, t_uid) then
					Select(t_uid);
				else
					Deselect(t_uid);
				end
				bool1 = false;
			end
		end);
		m_Library.GUIFX.ButtonFX(Clone_ret);
	end
	Update();
	Scaling();
end
function Scaling() -- Line: 374
	--[[
		Upvalues:
			[1] = t_HugeMachine
			[2] = m_Library
	--]]
	local t_Holder = t_HugeMachine.Pets.Holder;
	local UIGridLayout = t_Holder:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	local v13 = m_Library.Functions.ResolutionScale();
	local v14 = (t_Holder.AbsoluteSize.X - t_Holder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / (v13 <= 0.5 and 4 or v13 <= 1.1 and 5 or 6) - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v14, 0, v14);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 30);
end
function Clear() -- Line: 398
	--[[
		Upvalues:
			[1] = table1
			[2] = u4
			[3] = t_HugeMachine
	--]]
	table1 = {};
	u4 = 0;
	for _, child4 in ipairs(t_HugeMachine.Holder:GetChildren()) do
		if child4.ClassName ~= "TextButton" or child4.Name == "Template" then continue end
		child4:Destroy();
	end
end
local bool3 = false;
local table3 = {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
function updateInventoryDrag(p5, p6, p7, p8) -- Line: 413
	--[[
		Upvalues:
			[1] = t_HugeMachine
			[2] = m_Library
			[3] = bool3
			[4] = table3
			[5] = table1
	--]]
	if not t_HugeMachine.Gui.Enabled then return end
	if m_Library.Variables.MessageOpen then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.DragDelete) then return end
	if bool3 then return end
	bool3 = true;
	local t_Holder2 = t_HugeMachine.Pets.Holder;
	local v15 = t_Holder2.AbsolutePosition.Y + t_Holder2.AbsoluteSize.Y;
	local t_Y = t_Holder2.AbsolutePosition.Y;
	if p6 == p8 then
		p8 = p8 + 1;
	end
	local vec2 = Vector2.new(p5, p6);
	local vec2_2 = Vector2.new(p7, p8);
	if (vec2 - vec2_2).magnitude < 20 then
		bool3 = false;
		return;
	end
	local table4 = {};
	for _, child5 in ipairs(t_Holder2:GetChildren()) do
		if not child5:isA("TextButton") then continue end
		table.insert(table4, child5);
	end
	local num1 = nil;
	for _, val6 in ipairs(table3) do
		local t_Name3 = val6.Name;
		local _ = m_Library.PetCmds.Get(t_Name3);
		local t_AbsolutePosition = val6.AbsolutePosition;
		local v26 = t_AbsolutePosition.X or 0;
		local v27 = t_AbsolutePosition.Y or 0;
		if v15 < v27 or v27 < t_Y then continue end
		local t_AbsoluteSize = val6.AbsoluteSize;
		local vec2_5 = Vector2.new(v26, v27);
		local vec2_6 = Vector2.new(v26 + t_AbsoluteSize.X, v27 + t_AbsoluteSize.Y);
		if m_Library.Functions.CheckRectangleIntersection(vec2, vec2_2, vec2_5, vec2_6) then continue end
		if num1 == nil then
			num1 = 1;
		end
		if num1 == 1 then
			for _, val9 in ipairs(table1) do
				if val9 ~= t_Name3 then continue end
				Deselect(t_Name3);
				break;
			end
		end
		table.remove(table3, table.find(table3, val6));
	end
	for _, val7 in ipairs(table4) do
		if table.find(table3, val7) or not val7:GetAttribute("isVisible") or not val7.Visible then continue end
		local t_X = val7.AbsolutePosition.X;
		local t_Y2 = val7.AbsolutePosition.Y;
		local vec2_3 = Vector2.new(t_X, t_Y2);
		local vec2_4 = Vector2.new(t_X + val7.AbsoluteSize.X, t_Y2 + val7.AbsoluteSize.Y);
		local bool4 = false;
		if not m_Library.Functions.CheckRectangleIntersection(vec2, vec2_2, vec2_3, vec2_4) or v15 < t_Y2 + val7.AbsoluteSize.Y / 2 or t_Y2 + val7.AbsoluteSize.Y / 2 < t_Y then continue end
		local t_Name2 = val7.Name;
		local v28, _ = m_Library.PetCmds.Get(t_Name2);
		if not v28 then
			warn("Couldn't lookup petdata!");
			continue;
		end
		assert(v28);
		if not m_Library.Functions.SearchArray(table1, t_Name2) then
			if num1 == nil then
				num1 = 0;
			end
			if num1 == 0 then
				local v37 = m_Library.Signal.Invoke("Is Trading Booth Pet", t_Name2);
				if v28.l or v37 or m_Library.Functions.SearchArray(table1, t_Name2) then continue end
				Select(t_Name2);
				bool4 = true;
			end
		end
		if not bool4 then continue end
		table.insert(table3, val7);
	end
	bool3 = false;
end
function newDrag() -- Line: 559
	--[[
		Upvalues:
			[1] = u7
			[2] = u8
			[3] = u6
			[4] = m_Library
	--]]
	assert(u7 and u8);
	local Mouse = game.Players.LocalPlayer:GetMouse();
	local t_X2 = Mouse.X;
	local t_Y3 = Mouse.Y;
	u6 = Instance.new("ScreenGui");
	assert(u6);
	u6.DisplayOrder = 9999;
	u6.Name = "DragUI";
	local Frame = Instance.new("Frame");
	Frame.BackgroundColor3 = Color3.fromRGB(39, 233, 55);
	Frame.Parent = u6;
	u6.Parent = m_Library.LocalPlayer.PlayerGui;
	Frame.Position = UDim2.new(0, u7, 0, u8);
	Frame.Size = UDim2.new(0, t_X2 - u7, 0, t_Y3 - u8);
	Frame.ZIndex = 9999;
	Frame.BackgroundTransparency = 0.5;
end
function updateDrag() -- Line: 579
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u7
			[3] = u8
	--]]
	local DragUI = m_Library.LocalPlayer.PlayerGui:FindFirstChild("DragUI");
	if not DragUI then return end
	local Frame2 = DragUI:FindFirstChild("Frame");
	if not Frame2 then return end
	assert(u7 and u8);
	local Mouse2 = game.Players.LocalPlayer:GetMouse();
	local t_X3 = Mouse2.X;
	local t_Y4 = Mouse2.Y;
	Frame2.Position = UDim2.new(0, u7, 0, u8);
	Frame2.Size = UDim2.new(0, t_X3 - u7, 0, t_Y4 - u8);
end
m_Library.Signal.Fired("Click Drag Complete"):Connect(function() -- Line: 599
	--[[
		Upvalues:
			[1] = table3
	--]]
	table3 = {};
end);
m_Library.Signal.Fired("Click Drag Update"):Connect(updateInventoryDrag);
m_Library.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) -- Line: 605
	--[[
		Upvalues:
			[1] = t_HugeMachine
			[2] = m_Library
			[3] = u7
			[4] = u8
	--]]
	if not t_HugeMachine.Gui.Enabled then return end
	if m_Library.Variables.MessageOpen then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.DragDelete) then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.BankDragDelete) then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local Mouse3 = game.Players.LocalPlayer:GetMouse();
		u7 = Mouse3.X;
		u8 = Mouse3.Y;
		m_Library.Signal.Fire("Click Drag Start", u7, u8);
	end
end);
m_Library.UserInputService.InputEnded:Connect(function(input2, gameProcessedEvent2) -- Line: 632
	--[[
		Upvalues:
			[1] = u7
			[2] = u8
			[3] = m_Library
			[4] = u6
	--]]
	if input2.UserInputType == Enum.UserInputType.MouseButton1 then
		local Mouse4 = game.Players.LocalPlayer:GetMouse();
		local t_X4 = Mouse4.X;
		local t_Y5 = Mouse4.Y;
		if u7 and u8 then
			m_Library.Signal.Fire("Click Drag Complete", u7, u8, t_X4, t_Y5);
			if u6 then
				u6:Destroy();
				u6 = nil;
			end
			u7 = nil;
			u8 = nil;
		end
	end
end);
m_Library.UserInputService.InputChanged:Connect(function(input3, gameProcessedEvent3) -- Line: 650
	--[[
		Upvalues:
			[1] = u7
			[2] = u8
			[3] = u6
			[4] = m_Library
	--]]
	if input3.UserInputType == Enum.UserInputType.MouseMovement and u7 and u8 then
		if not u6 then
			newDrag();
			return;
		end
		updateDrag();
		local Mouse5 = game.Players.LocalPlayer:GetMouse();
		local t_X5 = Mouse5.X;
		local t_Y6 = Mouse5.Y;
		m_Library.Signal.Fire("Click Drag Update", u7, u8, t_X5, t_Y6);
	end
end);
MarketplaceService.PromptProductPurchaseFinished:Connect(function() -- Line: 673
	--[[
		Upvalues:
			[1] = bool2
	--]]
	bool2 = false;
end);
t_HugeMachine.Side.Convert.Activated:Connect(function() -- Line: 678
	--[[
		Upvalues:
			[1] = u4
			[2] = u1
			[3] = bool1
			[4] = u5
			[5] = m_Library
			[6] = table1
	--]]
	if u4 < u1.pointsMin then return end
	if not bool1 then
		bool1 = true;
		u5 = m_Library.Functions.DeepCopyUnsafe(table1);
		local v29 = m_Library.Message.New("Are you sure you want to use " .. #u5 .. " exclusive pets to get a Huge Machine Egg?", true);
		if v29 then
			Convert();
		end
		bool1 = false;
	end
end);
t_HugeMachine.Close.Activated:Connect(function() -- Line: 702
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_HugeMachine
	--]]
	if not bool1 then
		bool1 = true;
		t_HugeMachine.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_HugeMachine.Close);
m_Library.GUIFX.ButtonFX(t_HugeMachine.Side.Convert);
m_Library.Signal.Fired("Window Closed"):Connect(function(p9) -- Line: 718
	--[[
		Upvalues:
			[1] = bool2
			[2] = t_HugeMachine
	--]]
	if bool2 then return end
	if p9 == t_HugeMachine.Gui then
		Clear();
	end
end);
m_Library.Signal.Fired("Window Opened"):Connect(function(p10) -- Line: 729
	--[[
		Upvalues:
			[1] = t_HugeMachine
			[2] = bool2
			[3] = m_Library
	--]]
	if p10 == t_HugeMachine.Gui then
		if bool2 then
			t_HugeMachine.Gui.Enabled = false;
			return;
		end
		local v30 = m_Library.Save.Get();
		if not v30 then return end
		assert(v30);
		if not v30.OwnsHugeMachine then
			m_Library.Message.New("You don't own this machine! Buy it in the Town area!");
			return;
		end
		Clear();
		Setup();
		if t_HugeMachine.Gui.Enabled and m_Library.Variables.Console then
			m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("HugeMachine"):FindFirstChild("Frame"):FindFirstChild("Pets"):FindFirstChild("Holder");
		end
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 757
	--[[
		Upvalues:
			[1] = t_HugeMachine
	--]]
	if t_HugeMachine.Gui.Enabled then
		task.defer(function() -- Line: 759
			Scaling();
		end);
	end
end);
