-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_VerifyTwitter = m_Library.GUI.VerifyTwitter;
local bool1 = false;
local u1 = false;
local u2 = "";
function Verify() -- Line: 20
	--[[
		Upvalues:
			[1] = u1
			[2] = t_VerifyTwitter
			[3] = m_Library
			[4] = u2
	--]]
	if u1 then return end
	t_VerifyTwitter.Verify.ImageColor3 = Color3.new(0.5, 0.5, 0.5);
	t_VerifyTwitter.Verify.TextLabel.Text = "(...)";
	local tostring_ret = tostring(t_VerifyTwitter.Input.Text);
	if tostring_ret and tostring_ret ~= "" then
		local v2, v3 = m_Library.Network.Invoke("Verify Twitter", tostring_ret);
		if not v2 then
			m_Library.Message.New(v3 or "Failed to verify.");
		else
			m_Library.Audio.Play("rbxassetid://7055150312", script, 1, 1);
			m_Library.Message.New("\226\156\133 Verified!");
		end
		t_VerifyTwitter.Input.Text = "";
		u2 = "";
	end
	t_VerifyTwitter.Verify.ImageColor3 = Color3.new(1, 1, 1);
	t_VerifyTwitter.Verify.TextLabel.Text = "Verify!";
end
t_VerifyTwitter.Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 45
	--[[
		Upvalues:
			[1] = t_VerifyTwitter
			[2] = m_Library
			[3] = u2
	--]]
	if #t_VerifyTwitter.Input.Text <= 15 and m_Library.Functions.IsASCII(t_VerifyTwitter.Input.Text) then
		u2 = t_VerifyTwitter.Input.Text;
		return;
	end
	t_VerifyTwitter.Input.Text = u2;
end);
function Update() -- Line: 54
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = t_VerifyTwitter
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	u1 = v1.IsFollowingOnTwitter;
	t_VerifyTwitter.Verified.Visible = u1;
	t_VerifyTwitter.Verify.Visible = not u1;
	t_VerifyTwitter.Input.Visible = not u1;
	t_VerifyTwitter.Help.Visible = not u1;
end
m_Library.GUIFX.ButtonFX(t_VerifyTwitter.Verify);
t_VerifyTwitter.Verify.Activated:Connect(function() -- Line: 72
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		Verify();
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_VerifyTwitter.Close);
t_VerifyTwitter.Close.Activated:Connect(function() -- Line: 82
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_VerifyTwitter
	--]]
	if not bool1 then
		bool1 = true;
		t_VerifyTwitter.Gui.Enabled = false;
		bool1 = false;
	end
end);
Update();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p1) -- Line: 97
	if p1 == "IsFollowingOnTwitter" then
		Update();
	end
end);
