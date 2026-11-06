-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_ClipboardPopup = m_Library.GUI.ClipboardPopup;
local bool1 = false;
function UpdateScaling() -- Line: 19
end
m_Library.GUIFX.ButtonFX(t_ClipboardPopup.Close);
t_ClipboardPopup.Close.Activated:Connect(function() -- Line: 31
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_ClipboardPopup
	--]]
	if not bool1 then
		bool1 = true;
		t_ClipboardPopup.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 39
	task.defer(function() -- Line: 40
		UpdateScaling();
	end);
end);
m_Library.Network.Fired("Open Clipboard Popup"):Connect(function(p1) -- Line: 49
	--[[
		Upvalues:
			[1] = t_ClipboardPopup
	--]]
	t_ClipboardPopup.Gui.Frame.InputFrame.Input.Text = p1;
	UpdateScaling();
	t_ClipboardPopup.Gui.Enabled = true;
end);
