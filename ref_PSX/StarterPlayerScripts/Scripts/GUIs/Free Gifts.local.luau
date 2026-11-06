-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_FreeGifts = m_Library.GUI.FreeGifts;
local t_Container = t_FreeGifts.Frame.Container;
local t_Button = m_Library.GUI.FreeGiftsTop.Button;
local u1 = m_Library.Network.Invoke("Get OSTime");
local os_clock_ret = os.clock();
local bool1 = false;
function Redeem(p1) -- Line: 21
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1, v2 = m_Library.Network.Invoke("Redeem Free Gift", p1);
	if v1 then
		local v11 = m_Library.Directory.FreeGifts[p1];
		m_Library.Signal.Fire("Fireworks Animation");
		m_Library.Audio.Play(v11.rare and "rbxassetid://82988663084124" or "rbxassetid://87989123899674", script, 1, 1.5);
		return;
	end
	m_Library.Message.New(v2 or "Something went wrong.");
end
function Update() -- Line: 34
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Container
			[3] = u1
			[4] = os_clock_ret
	--]]
	local v3 = m_Library.Save.Get();
	if not v3 then return end
	for key1, val1 in ipairs(m_Library.Directory.FreeGifts) do
		local FindFirstChild_ret = t_Container.Gifts:FindFirstChild("Gift" .. key1);
		local v12 = v3.FreeGiftsTime >= val1.waitTime;
		local v13 = m_Library.Functions.SearchArray(v3.FreeGiftsRedeemed, key1);
		if v13 then
			FindFirstChild_ret.Timer.Text = "\226\156\133";
			FindFirstChild_ret.Progress.Visible = false;
			continue;
		end
		if v12 then
			FindFirstChild_ret.Timer.Text = "Redeem!";
			FindFirstChild_ret.Progress.Visible = false;
			continue;
		end
		local t_FreeGiftsTime = v3.FreeGiftsTime;
		local t_waitTime = val1.waitTime;
		local math_clamp_ret = math.clamp(t_FreeGiftsTime / t_waitTime, 0, 1);
		local math_max_ret = math.max(t_waitTime - t_FreeGiftsTime, 0);
		FindFirstChild_ret.Timer.Text = m_Library.Functions.TimerString(math_max_ret);
		FindFirstChild_ret.Progress:SetAttribute("Progress", math_clamp_ret);
		FindFirstChild_ret.Progress.Visible = true;
	end
	local v4 = v3.FreeGiftsResetTime - (u1 + (os.clock() - os_clock_ret));
	local v5 = #v3.FreeGiftsRedeemed;
	local v6 = #m_Library.Directory.FreeGifts;
	if v4 >= 7200 and v5 < v6 then
		t_Container.Top.Claimed.Visible = true;
		t_Container.Top.RefreshTime.Visible = false;
	else
		t_Container.Top.Claimed.Visible = false;
		t_Container.Top.RefreshTime.Visible = true;
	end
	if v4 > 0 then
		t_Container.Top.RefreshTime.Text = "New gifts ready in " .. m_Library.Functions.TimerString(v4);
	else
		t_Container.Top.RefreshTime.Text = "Refreshing gifts...";
	end
	t_Container.Top.Claimed.Text = string.format("%s/%s Gifts Claimed", v5, v6);
end
function Render() -- Line: 87
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Container
			[3] = bool1
			[4] = t_FreeGifts
	--]]
	for key2, val2 in ipairs(m_Library.Directory.FreeGifts) do
		local Clone_ret = m_Library.Assets.UI.FreeGifts.Gift:Clone();
		Clone_ret.Name = "Gift" .. key2;
		Clone_ret.Icon.Image = val2.icon;
		Clone_ret.LayoutOrder = key2;
		m_Library.GUIFX.CircularBar(Clone_ret.Progress);
		m_Library.GUIFX.ButtonFX(Clone_ret);
		Clone_ret.Parent = t_Container.Gifts;
		Clone_ret.Activated:Connect(function() -- Line: 100
			--[[
				Upvalues:
					[1] = bool1
					[2] = key2
			--]]
			if not bool1 then
				bool1 = true;
				Redeem(key2);
				bool1 = false;
			end
		end);
		if not t_FreeGifts.Enabled or not m_Library.Variables.Console then continue end
		print("Set selected obj");
		m_Library.GuiService.SelectedObject = Clone_ret;
	end
end
function UpdateTop() -- Line: 116
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Button
	--]]
	local v7 = m_Library.Save.Get();
	if not v7 then return end
	for key3, val3 in ipairs(m_Library.Directory.FreeGifts) do
		if v7.FreeGiftsTime < val3.waitTime or m_Library.Functions.SearchArray(v7.FreeGiftsRedeemed, key3) then continue end
		t_Button.Timer.Text = "Ready!";
		t_Button.Progress:SetAttribute("Progress", 1);
		return;
	end
	local v8 = nil;
	local v9 = 99999999;
	for key4, val4 in ipairs(m_Library.Directory.FreeGifts) do
		if val4.waitTime < v7.FreeGiftsTime or val4.waitTime >= v9 then continue end
		v8 = key4;
		v9 = val4.waitTime;
	end
	local v10 = m_Library.Directory.FreeGifts[v8];
	if v10 then
		local v14 = m_Library.Directory.FreeGifts[v8 - 1];
		local t_FreeGiftsTime2 = v7.FreeGiftsTime;
		local t_waitTime2 = v10.waitTime;
		local v15 = v14 and v14.waitTime or 0;
		local math_clamp_ret2 = math.clamp((t_FreeGiftsTime2 - v15) / (t_waitTime2 - v15), 0, 1);
		local math_max_ret2 = math.max(t_waitTime2 - t_FreeGiftsTime2, 0);
		t_Button.Timer.Text = m_Library.Functions.TimerString(math_max_ret2);
		t_Button.Progress:SetAttribute("Progress", math_clamp_ret2);
		return;
	end
	t_Button.Timer.Text = "";
	t_Button.Progress:SetAttribute("Progress", 0);
end
function TopAnimation() -- Line: 158
	--[[
		Upvalues:
			[1] = t_Button
			[2] = m_Library
	--]]
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 159
		--[[
			Upvalues:
				[1] = t_Button
				[2] = m_Library
		--]]
		local t_Position = t_Button.Icon.Position;
		while true do
			m_Library.Functions.Tween(t_Button.Icon, {Position = t_Position - UDim2.new(0, 0, 0.05, 0)}, {
				0.5,
				"Sine",
				"InOut"
			}).Completed:Wait();
			m_Library.Functions.Tween(t_Button.Icon, {Position = t_Position}, {
				1,
				"Sine",
				"InOut"
			}).Completed:Wait();
		end
	end);
	coroutine_wrap_ret();
end
m_Library.GUIFX.Sparkles(t_Button, 2);
m_Library.GUIFX.CircularBar(t_Button.Progress);
m_Library.GUIFX.ButtonFX(t_Button);
t_Button.Activated:Connect(function() -- Line: 177
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_FreeGifts
	--]]
	if not bool1 then
		bool1 = true;
		if not m_Library.Variables.InTutorial and not m_Library.Variables.PickingStarter then
			t_FreeGifts.Gui.Enabled = not t_FreeGifts.Gui.Enabled;
		end
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_FreeGifts.Close);
t_FreeGifts.Close.Activated:Connect(function() -- Line: 187
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_FreeGifts
	--]]
	if not bool1 then
		bool1 = true;
		t_FreeGifts.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Important Window Toggled"):Connect(function(p2) -- Line: 199
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Button
	--]]
	if m_Library.Variables.Mobile then
		t_Button.Visible = not p2;
	end
end);
if m_Library.Shared.IsTradingPlaza then
	t_Container.Top.Claimed.Visible = false;
	t_Container.Top.RefreshTime.Visible = false;
	t_FreeGifts.TradingPlaza.Visible = true;
	t_Button.Timer.Text = "";
	t_Button.Progress:SetAttribute("Progress", 0);
	return;
end
Render();
UpdateTop();
TopAnimation();
Update();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 222
	if p3 == "FreeGiftsRedeemed" or p3 == "FreeGiftsTime" or p3 == "FreeGiftsResetTime" then
		Update();
		UpdateTop();
	end
end);
m_Library.Signal.Fired("Opening Egg"):Connect(function(_) -- Line: 229
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.GUI.FreeGiftsTop.Gui.Enabled = m_Library.Variables.OpeningEgg <= 0;
end);
m_Library.Signal.Fired("Done Opening Egg"):Connect(function(_) -- Line: 233
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.GUI.FreeGiftsTop.Gui.Enabled = m_Library.Variables.OpeningEgg <= 0;
end);
