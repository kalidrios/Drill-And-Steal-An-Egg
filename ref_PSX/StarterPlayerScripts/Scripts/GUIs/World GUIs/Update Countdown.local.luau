-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local ServerTimeNow = workspace:GetServerTimeNow();
local u6 = nil;
local t_NotificationsTop = nil;
function UpdateScreen() -- Line: 20
	--[[
		Upvalues:
			[1] = t_NotificationsTop
			[2] = m_Library
			[3] = u4
			[4] = ServerTimeNow
			[5] = u1
			[6] = u2
			[7] = u3
			[8] = u5
	--]]
	if not t_NotificationsTop or not t_NotificationsTop.ImageNotification.Notification then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.UpdateGift) then
		if t_NotificationsTop.Gui.Enabled then
			t_NotificationsTop.Gui.Enabled = false;
		end
		t_NotificationsTop.Gui.Enabled = false;
		return;
	end
	local t_Notification = t_NotificationsTop.ImageNotification.Notification;
	if not u4 or not ServerTimeNow then
		u1, u2, u3, u4, u5 = m_Library.Network.Invoke("Get Update Countdown Details");
	end
	local math_clamp_ret = math.clamp(u5 - (u4 + (workspace:GetServerTimeNow() - ServerTimeNow)), -1200, u5);
	if u2 < math_clamp_ret then
		t_NotificationsTop.Gui.Enabled = false;
		return;
	end
	t_NotificationsTop.Frame.Position = m_Library.Variables.Mobile and UDim2.new(0.5, 0, 0.25, -40) or UDim2.new(0.5, 0, 0.2, -40);
	if math_clamp_ret > 0 then
		if not t_NotificationsTop.Gui.Enabled and u3 < math_clamp_ret then
			task.spawn(function() -- Line: 53
				--[[
					Upvalues:
						[1] = m_Library
				--]]
				m_Library.Message.New("Updating soon! Be online 1 minute before to receive a FREE gift!");
			end);
		end
		t_NotificationsTop.Gui.Enabled = true;
	end
	local v1 = "Update in " .. os.date("!%X", math_clamp_ret) .. "!";
	if math_clamp_ret > 0 then
		t_Notification.Text = v1;
		return;
	end
	if math_clamp_ret > -120 then
		t_Notification.Text = "Updating now...";
		return;
	end
	t_NotificationsTop.Gui.Enabled = false;
end
function UpdateBillboard() -- Line: 75
	--[[
		Upvalues:
			[1] = u6
			[2] = u4
			[3] = ServerTimeNow
			[4] = u1
			[5] = u2
			[6] = u3
			[7] = u5
			[8] = m_Library
	--]]
	if not u6 then return end
	if not u4 or not ServerTimeNow then
		u1, u2, u3, u4, u5 = m_Library.Network.Invoke("Get Update Countdown Details");
	end
	local Countdown = u6:FindFirstChild("Countdown");
	if not Countdown or not Countdown:FindFirstChild("Timer") then return end
	if not m_Library.FFlags.Get(m_Library.FFlags.Keys.UpdateGift) then
		if Countdown.Enabled then
			Countdown.Enabled = false;
		end
		Countdown.Enabled = false;
		return;
	end
	local math_clamp_ret2 = math.clamp(u5 - (u4 + (workspace:GetServerTimeNow() - ServerTimeNow)), -1200, u5);
	if u1 < math_clamp_ret2 then
		Countdown.Enabled = false;
		return;
	end
	if math_clamp_ret2 > 0 then
		Countdown.Enabled = true;
	end
	local math_round_ret = math.round(math_clamp_ret2 / 60 / 60 / 24 - 0.5);
	local v2 = os.date("!%X", math_clamp_ret2);
	if math_round_ret and math_round_ret > 0 then
		v2 = math_round_ret .. ":" .. v2;
	end
	if math_clamp_ret2 > 0 then
		Countdown.Timer.Text = v2;
		return;
	end
	if math_clamp_ret2 > -120 then
		Countdown.Timer.Text = "Updating now...";
		return;
	end
	Countdown.Enabled = false;
end
function Check() -- Line: 129
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u6
			[3] = t_NotificationsTop
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u6 = Map.Interactive:FindFirstChild("Update Countdown");
		if u6 then
			UpdateBillboard();
		end
	end
	t_NotificationsTop = m_Library.GUI.NotificationsTop;
	if t_NotificationsTop and t_NotificationsTop.ImageNotification then
		UpdateScreen();
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 149
	--[[
		Upvalues:
			[1] = u6
	--]]
	u6 = nil;
	Check();
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 155
	while true do
		UpdateBillboard();
		UpdateScreen();
		wait(0.5);
	end
end);
coroutine_wrap_ret();
