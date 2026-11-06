-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Settings = m_Library.GUI.Settings;
local bool1 = false;
function ToggleSetting(p1) -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	assert(v1);
	m_Library.Audio.Play("rbxassetid://7004248320", script, 1, 0.5);
	local v2 = v1.Settings[p1] or 1;
	local v3 = m_Library.Shared.SettingsInfo[p1].options[v2 + 1] and v2 + 1 or 1;
	local v4 = v1.Settings[p1];
	v1.Settings[p1] = v3;
	Update();
	local v5, _, v6 = m_Library.Network.Invoke("Toggle Setting", p1);
	if v5 then
		v1.Settings[p1] = v6;
		Update();
		return;
	end
	if v1.Settings[p1] == v3 then
		v1.Settings[p1] = v4;
		Update();
	end
end
function Update() -- Line: 52
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Settings
			[3] = bool1
	--]]
	local v7 = m_Library.Save.Get();
	if not v7 then return end
	assert(v7);
	for key1, val1 in pairs(v7.Settings) do
		local v8 = m_Library.Shared.SettingsInfo[key1];
		if not v8 then continue end
		local v9 = v8.options[val1];
		local v10 = t_Settings.Container:FindFirstChild(key1);
		if not v10 then
			v10 = m_Library.Assets.UI.Settings.Setting:Clone();
			v10.Name = key1;
			v10.LayoutOrder = v8.sort;
			v10.Parent = t_Settings.Container;
			m_Library.GUIFX.ButtonFX(v10.Toggle);
			v10.Toggle.Activated:Connect(function() -- Line: 75
				--[[
					Upvalues:
						[1] = bool1
						[2] = key1
				--]]
				if not bool1 then
					bool1 = true;
					ToggleSetting(key1);
					bool1 = false;
				end
			end);
		end
		v10.Title.Text = v8.title;
		v10.Toggle.Label.Text = v9;
		if v9 == "Off" or v9 == "No" or v9 == "Disabled" then
			v10.Toggle.Image = "rbxassetid://7045637481";
			v10.Toggle.HoverImage = "rbxassetid://7045637564";
			continue;
		end
		if v9 == "On" or v9 == "Yes" or v9 == "Enabled" then
			v10.Toggle.Image = "rbxassetid://7045637286";
			v10.Toggle.HoverImage = "rbxassetid://7045637411";
			continue;
		end
		v10.Toggle.Image = "rbxassetid://7045637286";
		v10.Toggle.HoverImage = "rbxassetid://7045637411";
	end
	local UIListLayout = t_Settings.Container:FindFirstChildOfClass("UIListLayout");
	local UIPadding = t_Settings.Container:FindFirstChildOfClass("UIPadding");
	t_Settings.Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
end
m_Library.GUIFX.ButtonFX(t_Settings.Close);
t_Settings.Close.Activated:Connect(function() -- Line: 110
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_Settings
	--]]
	if not bool1 then
		bool1 = true;
		t_Settings.Gui.Enabled = false;
		bool1 = false;
	end
end);
Update();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p2) -- Line: 125
	if p2 == "Settings" then
		Update();
	end
end);
