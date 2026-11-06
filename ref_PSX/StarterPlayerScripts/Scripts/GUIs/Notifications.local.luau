-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Notifications = m_Library.GUI.Notifications;
local u1 = 0;
local u2 = 0;
function Add(p1, p2) -- Line: 30
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = u1
			[4] = t_Notifications
	--]]
	while not m_Library.WorldCmds.CanDoAction() or m_Library.Variables.PickingStarter or os.clock() - u2 < 1.5 do
		m_Library.Heartbeat(5);
	end
	p2 = p2 or {};
	local v1 = m_Library.Save.Get();
	if not v1 or v1.Settings.Notifications == 2 and not p2.force then return end
	if p2.world and v1.World ~= p2.world then return end
	u2 = os.clock();
	u1 = u1 + 1;
	m_Library.Audio.Play("rbxassetid://7029271451", script, 1, 1);
	local v2 = p2.color or Color3.new(1, 1, 1);
	local v3 = p2.time or 5;
	local t_sound = p2.sound;
	local v4 = p2.volume or 1.5;
	if t_sound then
		m_Library.Audio.Play(t_sound, script, 1, v4);
	end
	local Clone_ret = script.Notification:Clone();
	local UIScale = Clone_ret:FindFirstChildOfClass("UIScale");
	local UIStroke = Clone_ret:FindFirstChildOfClass("UIStroke");
	UIScale.Scale = 1.3;
	Clone_ret.Text = p1;
	Clone_ret.LayoutOrder = u1;
	Clone_ret.TextColor3 = v2;
	Clone_ret.Parent = t_Notifications.Frame;
	m_Library.Functions.Tween(UIScale, {Scale = 1}, {
		0.3,
		"Expo",
		"Out"
	});
	task.delay(v3, function() -- Line: 71
		--[[
			Upvalues:
				[1] = m_Library
				[2] = UIStroke
				[3] = Clone_ret
		--]]
		m_Library.Functions.Tween(UIStroke, {Transparency = 1}, {
			0.4,
			"Expo",
			"Out"
		});
		m_Library.Functions.Tween(Clone_ret, {
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}, {
			0.4,
			"Expo",
			"Out"
		}).Completed:Wait();
		Clone_ret:Destroy();
	end);
end
m_Library.Signal.Fired("Notification"):Connect(function(p3, p4) -- Line: 80
	Add(p3, p4);
end);
m_Library.Network.Fired("Notification"):Connect(function(p5, p6) -- Line: 85
	Add(p5, p6);
end);
