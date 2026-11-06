-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Hoverboards = m_Library.GUI.Hoverboards;
local Random_new_ret = Random.new();
local t_Holder = t_Hoverboards.Container.Holder;
local t_Customize = m_Library.GUI.Main.Left.Tools.Hoverboard.Customize;
local bool1 = false;
function Equip(p1) -- Line: 25
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret
	--]]
	local v1, v2 = m_Library.Network.Invoke("Equip Hoverboard", p1);
	if v1 then
		m_Library.Audio.Play("rbxassetid://8304479813", script, Random_new_ret:NextNumber(0.95, 1.05), 1);
		return;
	end
	m_Library.Message.New(v2 or "Something went wrong.");
end
function Update() -- Line: 35
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Holder
			[3] = bool1
	--]]
	local u1 = m_Library.Save.Get();
	if not u1 then return end
	for key1, val1 in pairs(m_Library.Directory.Hoverboards) do
		if key1 ~= "Original" then continue end
		local u2 = t_Holder:FindFirstChild(key1);
		if not u2 then
			u2 = m_Library.Assets.UI.Hoverboards.Hoverboard:Clone();
			u2.Icon.Image = val1.thumbnail;
			u2.Name = key1;
			u2.Speed:FindFirstChild(1).Visible = val1.speed >= 1;
			u2.Speed:FindFirstChild(2).Visible = val1.speed >= 2;
			u2.Speed:FindFirstChild(3).Visible = val1.speed >= 3;
			u2.Parent = t_Holder;
			m_Library.GUIFX.ButtonFX(u2);
			u2.Activated:Connect(function() -- Line: 55
				--[[
					Upvalues:
						[1] = bool1
						[2] = key1
				--]]
				if not bool1 then
					bool1 = true;
					Equip(key1);
					bool1 = false;
				end
			end);
			local function ShowOverlay() -- Line: 63
				--[[
					Upvalues:
						[1] = u1
						[2] = m_Library
						[3] = key1
						[4] = val1
						[5] = u2
				--]]
				u1 = m_Library.Save.Get();
				local v10 = m_Library.Functions.SearchArray(u1.Hoverboards, key1);
				local table1 = {
					{
						"Title",
						val1.name
					},
					{
						"HoverboardSpeed",
						val1.speed
					},
					{
						"HoverboardNeeded",
						val1.neededDesc
					}
				};
				if v10 then
					table.insert(table1, {"HoverboardUnlocked"});
				end
				m_Library.InfoOverlay.Add(u2, unpack(table1));
			end
			u2.MouseEnter:Connect(function() -- Line: 73
				--[[
					Upvalues:
						[1] = m_Library
						[2] = ShowOverlay
				--]]
				m_Library.Audio.Play("rbxassetid://6907626084", script, 1, 0.2);
				ShowOverlay();
			end);
			u2.SelectionGained:Connect(function() -- Line: 78
				--[[
					Upvalues:
						[1] = m_Library
						[2] = ShowOverlay
				--]]
				m_Library.Audio.Play("rbxassetid://90715434687021", script, 1, 0.2);
				ShowOverlay();
			end);
		end
		local v8 = u1.EquippedHoverboard == key1;
		local v9 = m_Library.Functions.SearchArray(u1.Hoverboards, key1);
		u2.Locked.Visible = not v9;
		u2.Icon.ImageColor3 = v9 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(143, 143, 143);
		if v8 then
			u2.Background.BackgroundColor3 = Color3.fromRGB(64, 252, 59);
		else
			u2.Background.BackgroundColor3 = Color3.fromRGB(39, 233, 55) or Color3.fromRGB(143, 143, 143);
		end
		if v8 and not u2.Equipped.Visible then
			u2.Equipped.Size = UDim2.new(0.8, 0, 0.8, 0);
			m_Library.Functions.Tween(u2.Equipped, {Size = UDim2.new(0.4, 0, 0.4, 0)}, {
				0.25,
				"Back",
				"Out"
			});
		else
			u2.BackgroundColor3 = v8 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
		end
		u2.Equipped.Visible = v8;
		u2.LayoutOrder = v9 and 1 or 100;
	end
	Scaling();
end
function Scaling() -- Line: 110
	--[[
		Upvalues:
			[1] = t_Holder
			[2] = m_Library
	--]]
	local UIGridLayout = t_Holder:FindFirstChildOfClass("UIGridLayout");
	local UIPadding = t_Holder:FindFirstChildOfClass("UIPadding");
	local v3 = m_Library.Functions.ResolutionScale();
	local num1 = 6;
	if v3 <= 0.65 then
		num1 = 3;
	elseif v3 <= 1 then
		num1 = 4;
	elseif v3 <= 1.2 then
		num1 = 5;
	end
	local v4 = (t_Holder.AbsoluteSize.X - t_Holder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / num1 - UIGridLayout.CellPadding.X.Offset;
	local udim2 = UDim2.new(0, v4, 0, v4);
	UIGridLayout.CellSize = udim2;
	UIGridLayout:ApplyLayout();
	t_Holder.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset));
end
function UpdateGamepassFrame() -- Line: 131
	--[[
		Upvalues:
			[1] = t_Hoverboards
			[2] = m_Library
	--]]
	local t_BuyGamepass = t_Hoverboards.BuyGamepass;
	local v5 = m_Library.Gamepasses.Owns(m_Library.Directory.Gamepasses.Hoverboard.ID);
	if v5 then
		t_BuyGamepass.Visible = false;
		t_Hoverboards.Container.Size = UDim2.new(1, 32, 1, 0);
		return;
	end
	t_BuyGamepass.Visible = true;
	t_Hoverboards.Container.Size = UDim2.new(1, 32, 0.8, -15);
end
function UpdateCustomizeButton() -- Line: 145
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Customize
	--]]
	local t_HoverboardMenuActive = m_Library.Variables.HoverboardMenuActive;
	local v6 = m_Library.Save.Get();
	if not v6 then return end
	local v7 = m_Library.Directory.Hoverboards[v6.EquippedHoverboard];
	if v7 then
		t_Customize.HoverboardIcon.Image = v7.thumbnail;
	else
		t_Customize.HoverboardIcon.Image = m_Library.Directory.Hoverboards.Original.thumbnail;
	end
	if not t_Customize.Visible then
		local t_Position = t_Customize.Position;
		t_Customize.Position = UDim2.new(1, t_Position.X.Offset, t_Position.Y.Scale, t_Position.Y.Offset);
		t_Customize.Swap.Rotation = 0;
		m_Library.Functions.Tween(t_Customize, {Position = UDim2.new(1.5, t_Position.X.Offset, t_Position.Y.Scale, t_Position.Y.Offset)}, {
			0.2,
			"Expo",
			"Out"
		});
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 166
			--[[
				Upvalues:
					[1] = t_Customize
					[2] = m_Library
			--]]
			local os_clock_ret = os.clock();
			repeat
				local math_clamp_ret = math.clamp((os.clock() - os_clock_ret) / 0.3, 0, 1);
				t_Customize.Swap.Rotation = m_Library.Functions.Easing(math_clamp_ret, "Sine", "Out") * 360;
				m_Library.RenderStepped();
			until math_clamp_ret > 1 or not t_Customize.Visible;
		end);
		coroutine_wrap_ret();
	end
	t_Customize.Visible = t_HoverboardMenuActive;
end
m_Library.GUIFX.ButtonFX(t_Hoverboards.Close);
t_Hoverboards.Close.Activated:Connect(function() -- Line: 183
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Hoverboards
	--]]
	if not bool1 then
		bool1 = true;
		t_Hoverboards.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Hoverboards.BuyGamepass.Buy);
t_Hoverboards.BuyGamepass.Buy.Robux.Text = m_Library.Functions.Commas(m_Library.Functions.GetPrice(m_Library.Directory.Gamepasses.Hoverboard.ID));
t_Hoverboards.BuyGamepass.Buy.Activated:Connect(function() -- Line: 194
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Shared.PromptPurchase(m_Library.Directory.Gamepasses.Hoverboard.ID);
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Customize);
t_Customize.Activated:Connect(function() -- Line: 204
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = t_Hoverboards
	--]]
	if not bool1 and m_Library.WorldCmds.CanDoAction() then
		t_Hoverboards.Gui.Enabled = not t_Hoverboards.Gui.Enabled;
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 214
	task.defer(function() -- Line: 215
		Scaling();
	end);
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p2) -- Line: 221
	if p2 == "Hoverboards" or p2 == "EquippedHoverboard" then
		Update();
		UpdateCustomizeButton();
		return;
	end
	if p2 == "Gamepasses" then
		UpdateGamepassFrame();
	end
end);

m_Library.Signal.Fired("Toggled Hoverboard Menu"):Connect(function() -- Line: 231
	UpdateCustomizeButton();
end);
Update();
UpdateGamepassFrame();
UpdateCustomizeButton();
