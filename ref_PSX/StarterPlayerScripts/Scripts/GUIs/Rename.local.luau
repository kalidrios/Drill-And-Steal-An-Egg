-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Rename = m_Library.GUI.Rename;
local Random_new_ret = Random.new();
local t_Input = t_Rename.InputFrame.Input;
local u1 = nil;
local bool1 = false;
function Rename(p1, p2) -- Line: 22
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1, v2 = m_Library.Network.Invoke("Rename Pet", p1, p2);
	if not v1 then
		local v5 = v2 or "Something went wrong. Try again!";
		m_Library.Message.New(v5);
	end
	m_Library.Signal.Fire("Nickname Changed", p1, p2);
	return v1;
end
function Prompt(p3) -- Line: 36
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = t_Input
			[4] = t_Rename
			[5] = bool1
	--]]
	local v3, v4 = m_Library.PetCmds.Get(p3);
	if not v3 or v4 ~= m_Library.LocalPlayer then return end
	if m_Library.Variables.RenamingPet then return end
	m_Library.Variables.RenamingPet = true;
	if v3.snk then
		local v6 = m_Library.Message.New("This pet is signed - are you sure you want to rename it? The signature will be erased.", true);
		if not v6 then
			m_Library.Variables.RenamingPet = false;
			return;
		end
		m_Library.Heartbeat();
		m_Library.Heartbeat();
	end
	if u1 then
		u1:Disconnect();
		u1 = nil;
	end
	t_Input.Text = v3.nk;
	local t_LocalPlayer = m_Library.LocalPlayer;
	local Attribute = t_LocalPlayer:GetAttribute("CanSign");
	t_Rename.SignInfo.Subtitle.Text = 'Sign pets by naming them "' .. t_LocalPlayer.Name .. '"';
	t_Rename.SignInfo.Visible = Attribute;
	u1 = t_Rename.Done.Activated:Connect(function() -- Line: 87
		--[[
			Upvalues:
				[1] = bool1
				[2] = t_Input
				[3] = p3
				[4] = m_Library
				[5] = t_Rename
		--]]
		if not bool1 then
			bool1 = true;
			local tostring_ret = tostring(t_Input.Text);
			local Rename_ret = Rename(p3, tostring_ret);
			if Rename_ret then
				m_Library.Audio.Play("rbxassetid://7163248956", script, 1, 0.5);
				t_Rename.Gui.Enabled = false;
			end
			bool1 = false;
		end
	end);
	t_Rename.Gui.Enabled = true;
	if m_Library.Variables.Console then
		print("Set selected obj");
		m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("Rename"):FindFirstChild("Frame"):FindFirstChild("Done");
	end
	while t_Rename.Gui.Enabled do
		m_Library.Heartbeat();
	end
	m_Library.Variables.RenamingPet = false;
	if m_Library.Variables.Console then
		print("Set selected obj");
		m_Library.GuiService.SelectedObject = nil;
	end
	return true;
end
t_Rename.InputFrame.RNG.Activated:Connect(function() -- Line: 125
	--[[
		Upvalues:
			[1] = t_Rename
			[2] = bool1
			[3] = m_Library
			[4] = Random_new_ret
			[5] = t_Input
	--]]
	if t_Rename.Gui.Enabled and not bool1 then
		bool1 = true;
		local t_Nicknames = m_Library.Shared.Nicknames;
		t_Input.Text = t_Nicknames[Random_new_ret:NextInteger(1, #t_Nicknames)];
		bool1 = false;
	end
end);
t_Rename.SignInfo.Rename.Activated:Connect(function() -- Line: 137
	--[[
		Upvalues:
			[1] = t_Rename
			[2] = bool1
			[3] = m_Library
			[4] = t_Input
	--]]
	if t_Rename.Gui.Enabled and not bool1 then
		bool1 = true;
		t_Input.Text = m_Library.LocalPlayer.Name;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_Rename.Done);
m_Library.GUIFX.ButtonFX(t_Rename.InputFrame.RNG);
m_Library.GUIFX.ButtonFX(t_Rename.SignInfo.Rename);
m_Library.Signal.Invoked("Rename Pet").OnInvoke = function(p4) -- Line: 159
	return Prompt(p4);
end
