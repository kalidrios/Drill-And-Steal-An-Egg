-- https://github.com/kalidrios

local _ = {
	Player = "#2cff79",
	Number = "#2ffcff",
	Boolean = "#b339ff",
	String = "#ffe02b",
	Any = "#ececec"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Library = game.ReplicatedStorage:WaitForChild("Library");
local m_FFlags = require(Library:WaitForChild("Modules").FFlags);
local t_FFlags = m_Library.GUI.FFlags;
local t_Flags = t_FFlags.Frame.Flags;
local t_Input = t_FFlags.Frame.Search.Input;
local t_Commit = t_FFlags.Frame.Commit;
local t_Cancel = t_FFlags.Frame.Cancel;
local u1 = m_Library.Functions.DeepCopyUnsafe(m_Library.FFlags.currentData);
local u2 = m_Library.Functions.DeepCopyUnsafe(u1);
local bool1 = false;
local u3 = false;
local u4 = "";
local u5 = m_Library.Functions.Debounce();
function RunLoadingUI() -- Line: 40
	--[[
		Upvalues:
			[1] = t_Cancel
			[2] = t_Commit
			[3] = t_FFlags
			[4] = bool1
	--]]
	t_Cancel.Visible = false;
	t_Commit.Visible = false;
	t_FFlags.Frame.Close.Visible = false;
	task.spawn(function() -- Line: 44
		--[[
			Upvalues:
				[1] = t_FFlags
				[2] = bool1
		--]]
		local v20 = 0;
		local tick_ret = tick();
		local v21 = tick_ret;
		local t_Loading = t_FFlags.Frame.Loading;
		local t_Disclaimer = t_Loading.Disclaimer;
		t_Loading.Visible = true;
		t_Disclaimer.Visible = false;
		while bool1 do
			local tick_ret2 = tick();
			t_Loading.Text = ("Processing%*"):format((string.rep(".", v20)));
			if tick_ret2 - v21 > 0.2 then
				v20 = v20 < 3 and v20 + 1 or 1;
				v21 = tick_ret2;
			end
			t_Disclaimer.Visible = tick_ret2 - tick_ret > 1.5;
			task.wait();
		end
		t_Loading.Visible = false;
		t_FFlags.Frame.Close.Visible = true;
	end);
end
function Get(p1, p2) -- Line: 67
	--[[
		Upvalues:
			[1] = u1
			[2] = m_FFlags
	--]]
	local v1 = p2 or u1;
	local v2 = m_FFlags.Options[p1];
	local v3 = v1[p1];
	if v3 == nil and not v2.Nullable then
		v3 = v2.Default;
	end
	return v3;
end
local function CommitChanges() -- Line: 77
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = u2
			[4] = bool1
	--]]
	if m_Library.Functions.DeepEqualsUnsafe(u1, u2) then
		m_Library.Message.New("\226\157\140 Nothing changed!");
		return;
	end
	bool1 = true;
	RunLoadingUI();
	local v4 = m_Library.Network.Invoke("FFlags Commit", u1);
	bool1 = false;
	if v4 then
		m_Library.Message.New("\226\156\133 Succesfully commited!");
	else
		m_Library.Message.New("\226\157\140 Error commiting! Please try again.");
	end
	task.delay(1, function() -- Line: 91
		Update();
	end);
end
function getCommitChanges() -- Line: 96
	--[[
		Upvalues:
			[1] = m_FFlags
			[2] = u1
			[3] = u2
	--]]
	local v5 = 0;
	local bool2 = false;
	for v6, v7 in m_FFlags.Options do
		if Get(v6, u1) == Get(v6, u2) then continue end
		v5 = v5 + 1;
		if not v7.Important then continue end
		bool2 = true;
	end
	return v5, bool2;
end
function isInSearch(p3) -- Line: 110
	--[[
		Upvalues:
			[1] = u4
			[2] = m_Library
	--]]
	local lower_ret = p3:lower();
	local lower_ret2 = u4:lower();
	if lower_ret:find(lower_ret2) then
		return true;
	end
	for _, v8 in lower_ret:split(" ") do
		if m_Library.Functions.LevDist(lower_ret2, v8) >= 3 or #v8 < 4 then continue end
		return true;
	end
	local sub_ret = lower_ret:sub(1, #lower_ret2);
	local v9 = m_Library.Functions.LevDist(lower_ret2, sub_ret);
	if #lower_ret2 >= 4 and v9 / #sub_ret <= 0.35 then
		return true;
	end
	return false;
end
function updateOption(p4) -- Line: 129
	--[[
		Upvalues:
			[1] = u1
			[2] = t_Flags
			[3] = u3
			[4] = m_Library
			[5] = u5
	--]]
	local t_Name = p4.Name;
	local t_Type = p4.Type;
	local t_Important = p4.Important;
	local t_Key = p4.Key;
	local t_HasToggles = p4.HasToggles;
	local u8 = t_Type == "boolean";
	local u9 = t_Type == "string";
	local u10 = t_Type == "number";
	local bool3 = false;
	local t_Boolean = nil;
	local t_NumberInput = nil;
	local t_StringInput = nil;
	local t_Toggle = nil;
	if u1[t_Key] == nil and not p4.Nullable then
		local _ = p4.Default;
	end
	local u11 = t_Flags:FindFirstChild(p4.Key);
	if u3 and not isInSearch(p4.Name) then
		if u11 then
			u11:Destroy();
		end
		return;
	end
	local function UpdateValue() -- Line: 157
		--[[
			Upvalues:
				[1] = bool3
				[2] = u8
				[3] = t_Key
				[4] = m_Library
				[5] = t_Boolean
				[6] = u10
				[7] = t_NumberInput
				[8] = u9
				[9] = t_StringInput
				[10] = t_HasToggles
				[11] = t_Toggle
		--]]
		local v22 = bool3 and 0 or 0.3;
		if u8 then
			if Get(t_Key) then
				m_Library.Functions.Tween(t_Boolean.Slider, {
					Position = UDim2.new(0.5, 0, 0, 0),
					BackgroundColor3 = Color3.fromRGB(44, 255, 33)
				}, {
					v22,
					"Sine",
					"Out"
				});
				m_Library.Functions.Tween(t_Boolean, {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0
				}, {
					v22,
					"Sine",
					"Out"
				});
			else
				m_Library.Functions.Tween(t_Boolean.Slider, {
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundColor3 = Color3.fromRGB(255, 30, 97)
				}, {
					v22,
					"Sine",
					"Out"
				});
				m_Library.Functions.Tween(t_Boolean, {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.5
				}, {
					v22,
					"Sine",
					"Out"
				});
			end
		end
		if u10 then
			t_NumberInput.Text = Get(t_Key);
		end
		if u9 then
			t_StringInput.Text = '"' .. Get(t_Key) .. '"';
		end
		if t_HasToggles then
			t_Toggle.Text = Get(t_Key);
		end
	end
	local t_Inputs;
	if not u11 then
		u11 = m_Library.Assets.UI.FRAMEWORK.FFlags.Cmd:Clone();
		u11.Name = t_Key;
		u11.LayoutOrder = p4.Order;
		u11.Parent = t_Flags;
		t_Inputs = u11.Header.Inputs;
		local t_Title = u11.Header.Title;
		bool3 = true;
		t_Inputs.Toggle.Activated:Connect(function() -- Line: 189
			--[[
				Upvalues:
					[1] = u5
					[2] = t_Key
					[3] = p4
					[4] = u1
			--]]
			u5(0.15, function() -- Line: 190
				--[[
					Upvalues:
						[1] = t_Key
						[2] = p4
						[3] = u1
				--]]
				local Get_ret = Get(t_Key);
				local table_find_ret = table.find(p4.Toggles, Get_ret);
				u1[p4.Key] = p4.Toggles[table_find_ret < #p4.Toggles and table_find_ret + 1 or 1];
				Update();
			end);
		end);
		t_Inputs.Boolean.Activated:Connect(function() -- Line: 200
			--[[
				Upvalues:
					[1] = u5
					[2] = t_Key
					[3] = u1
					[4] = p4
			--]]
			u5(0.35, function() -- Line: 201
				--[[
					Upvalues:
						[1] = t_Key
						[2] = u1
						[3] = p4
				--]]
				local v28 = not Get(t_Key);
				u1[p4.Key] = v28;
				Update();
			end);
		end);
		t_Inputs.NumberInput.FocusLost:Connect(function() -- Line: 210
			--[[
				Upvalues:
					[1] = t_Inputs
					[2] = t_Key
					[3] = u5
					[4] = p4
					[5] = m_Library
					[6] = t_Name
					[7] = u10
					[8] = u1
			--]]
			local function fail() -- Line: 211
				--[[
					Upvalues:
						[1] = t_Inputs
						[2] = t_Key
				--]]
				t_Inputs.NumberInput.Text = tostring(Get(t_Key));
			end
			u5(0.35, function() -- Line: 214
				--[[
					Upvalues:
						[1] = t_Inputs
						[2] = fail
						[3] = p4
						[4] = m_Library
						[5] = t_Name
						[6] = u10
						[7] = u1
				--]]
				local tonumber_ret = tonumber(t_Inputs.NumberInput.Text);
				if not tonumber_ret then
					return fail();
				end
				if p4.Min and tonumber_ret < p4.Min then
					m_Library.Message.New((("Value of flag %* cannot be lower than %*"):format(t_Name, p4.Min)));
					return fail();
				end
				if p4.Max and p4.Max < tonumber_ret then
					m_Library.Message.New((("Value of flag %* cannot be greater than %*"):format(t_Name, p4.Max)));
					return fail();
				end
				if not u10 then
					return fail();
				end
				u1[p4.Key] = tonumber_ret;
				Update();
			end);
		end);
		t_Inputs.StringInput.FocusLost:Connect(function(p8) -- Line: 236
			--[[
				Upvalues:
					[1] = m_Library
					[2] = t_Inputs
					[3] = t_Title
					[4] = t_Key
					[5] = u5
					[6] = u9
					[7] = u1
			--]]
			m_Library.Functions.Tween(t_Inputs, {Size = UDim2.new(0.15, 0, 1, 0)}, {
				0.25,
				"Sine",
				"Out"
			});
			m_Library.Functions.Tween(t_Title, {
				Size = UDim2.new(0.832, 0, 1, 0),
				Position = UDim2.new(0.155, 0, 0, 0),
				AnchorPoint = Vector2.zero
			}, {
				0.25,
				"Sine",
				"Out"
			});
			local function fail() -- Line: 247
				--[[
					Upvalues:
						[1] = t_Inputs
						[2] = t_Key
				--]]
				t_Inputs.StringInput.Text = ('"%*"'):format((Get(t_Key)));
			end
			if not p8 then
				return fail();
			end
			u5(0.35, function() -- Line: 253
				--[[
					Upvalues:
						[1] = t_Inputs
						[2] = u9
						[3] = u1
						[4] = t_Key
				--]]
				local t_Text = t_Inputs.StringInput.Text;
				if not u9 then return end
				u1[t_Key] = t_Text;
				Update();
			end);
		end);
		t_Inputs.StringInput.Focused:Connect(function() -- Line: 262
			--[[
				Upvalues:
					[1] = m_Library
					[2] = t_Inputs
					[3] = t_Title
			--]]
			m_Library.Functions.Tween(t_Inputs, {Size = UDim2.new(1, 0, 1, 0)}, {
				0.25,
				"Sine",
				"Out"
			});
			m_Library.Functions.Tween(t_Title, {
				Size = UDim2.new(0, 0, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0)
			}, {
				0.25,
				"Sine",
				"Out"
			});
		end);
	else
		t_Inputs = u11.Header.Inputs;
		local _ = u11.Header.Title;
	end
	t_Boolean = t_Inputs.Boolean;
	t_StringInput = t_Inputs.StringInput;
	t_NumberInput = t_Inputs.NumberInput;
	t_Toggle = t_Inputs.Toggle;
	local t_Inputs2 = u11.Header.Inputs;
	local v11 = t_HasToggles and t_Toggle or u8 and t_Boolean or u9 and t_StringInput or u10 and t_NumberInput or nil;
	assert(v11);
	for _, child1 in t_Inputs2:GetChildren() do
		if not child1:IsA("GuiBase") then continue end
		child1.Visible = v11 == child1;
	end
	local function Title() -- Line: 300
		--[[
			Upvalues:
				[1] = t_Name
				[2] = t_Important
				[3] = u11
		--]]
		local v23 = t_Name;
		if t_Important then
			v23 = ('%* <font color="rgb(255,170,0)"><b>[Important]</b></font>'):format(v23);
		end
		u11.Header.Title.Text = v23;
	end
	local v12 = t_Name;
	if t_Important then
		v12 = ('%* <font color="rgb(255,170,0)"><b>[Important]</b></font>'):format(v12);
	end
	u11.Header.Title.Text = v12;
	UpdateValue();
end
function CancelChanges() -- Line: 312
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = u2
	--]]
	u1 = m_Library.Functions.DeepCopy(u2);
	Update();
end
function Update() -- Line: 318
	--[[
		Upvalues:
			[1] = m_FFlags
			[2] = t_Commit
			[3] = t_Cancel
			[4] = t_Flags
	--]]
	for _, v13 in m_FFlags.Options do
		updateOption(v13);
	end
	local getCommitChanges_ret1, _ = getCommitChanges();
	t_Commit.Visible = getCommitChanges_ret1 > 0;
	t_Cancel.Visible = getCommitChanges_ret1 > 0;
	local table1 = {};
	for _, v14 in m_FFlags.Options do
		local FindFirstChild_ret = t_Flags:FindFirstChild(v14.Key);
		if not FindFirstChild_ret then continue end
		table.insert(table1, {
			FindFirstChild_ret,
			v14
		});
	end
	table.sort(table1, function(p6, p7) -- Line: 338
		local v24 = p6[2];
		local v25 = p7[2];
		if v24.Important and not v25.Important then
			return true;
		end
		if not v24.Importand and v25.Important then
			return false;
		end
		return v24.Key < v25.Key;
	end);
	local v15 = nil;
	local v16 = nil;
	for v17, v18 in table1, v15, v16 do
		v18[1].LayoutOrder = v17;
	end
end
function Scaling() -- Line: 354
	--[[
		Upvalues:
			[1] = t_FFlags
	--]]
	local t_Flags2 = t_FFlags.Frame.Flags;
	local UIListLayout = t_Flags2:FindFirstChildOfClass("UIListLayout");
	t_Flags2.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y);
	UIListLayout:ApplyLayout();
end
function Toggle() -- Line: 361
	--[[
		Upvalues:
			[1] = t_FFlags
	--]]
	t_FFlags.Gui.Enabled = not t_FFlags.Gui.Enabled;
	if not t_FFlags.Gui.Enabled then
		CancelChanges();
		Update();
	end
end
t_FFlags.Frame.Close.Activated:Connect(function() -- Line: 369
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_FFlags
	--]]
	if getCommitChanges() > 0 and not m_Library.Message.New("You have uncommitted changes.  Are you sure you'd like to exit?", true) then return end
	CancelChanges();
	task.spawn(function() -- Line: 375
		--[[
			Upvalues:
				[1] = t_FFlags
		--]]
		for index1 = 1, 60 do
			t_FFlags.Gui.Enabled = false;
			task.wait();
		end
	end);
end);
m_Library.UserInputService.InputBegan:connect(function(input, gameProcessedEvent) -- Line: 383
	--[[
		Upvalues:
			[1] = m_FFlags
			[2] = m_Library
	--]]
	if input.KeyCode == Enum.KeyCode.F3 and m_FFlags.Admins[m_Library.LocalPlayer.UserId] then
		Toggle();
	end
end);
task.defer(function() -- Line: 389
	Update();
end);
m_Library.Signal.Fired("FFlags Changed"):Connect(function(p5) -- Line: 393
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = m_Library
	--]]
	local v19 = m_Library.Functions.DeepCopyUnsafe(p5);
	u2 = m_Library.Functions.DeepCopyUnsafe(p5);
	u1 = v19;
	Update();
end);
m_Library.Network.Fired("Open FFlags"):Connect(function() -- Line: 398
	--[[
		Upvalues:
			[1] = t_FFlags
	--]]
	t_FFlags.Gui.Enabled = true;
end);
local u7 = m_Library.Functions.Debounce();
t_Commit.Activated:Connect(function() -- Line: 403
	--[[
		Upvalues:
			[1] = u7
			[2] = bool1
			[3] = m_Library
			[4] = CommitChanges
	--]]
	u7(1, function() -- Line: 404
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = CommitChanges
		--]]
		local getCommitChanges_ret1_2, getCommitChanges_ret2 = getCommitChanges();
		if bool1 then
			m_Library.Message.New("Already processing request... try again in a few seconds.");
			return;
		end
		if not m_Library.Message.New(("Are you sure you'd like to change %* flag%*?  This will instantly take effect on all live servers."):format(getCommitChanges_ret1_2, getCommitChanges_ret1_2 > 1 and "s" or ""), true) then return end
		if getCommitChanges_ret2 and not m_Library.Message.New("At least one flag you've changed is flagged as [Important].  Are you ABSOLUTELY SURE you'd like to commit these changes?", true) then return end
		CommitChanges();
	end);
end);
t_Cancel.Activated:Connect(function() -- Line: 422
	CancelChanges();
	Update();
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 427
	--[[
		Upvalues:
			[1] = t_FFlags
			[2] = u3
			[3] = t_Input
			[4] = u4
			[5] = m_Library
	--]]
	while true do
		if t_FFlags.Gui.Enabled and t_FFlags.Frame.Visible then
			Scaling();
			u3 = #t_Input.Text > 0 and t_Input.Text ~= t_Input.PlaceholderText or false;
			local v27 = u4;
			if u3 then
				u4 = t_Input.Text;
			else
				u4 = "";
			end
			if u4 ~= v27 then
				Update();
			end
		end
		m_Library.RenderStepped();
	end
end);
coroutine_wrap_ret();
m_Library.GUIFX.ButtonFX(t_Cancel);
m_Library.GUIFX.ButtonFX(t_Commit);
