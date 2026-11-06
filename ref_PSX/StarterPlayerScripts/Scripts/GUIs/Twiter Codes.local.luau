-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_TwitterCodes = m_Library.GUI.TwitterCodes;
local bool1 = false;
function Redeem() -- Line: 18
	--[[
		Upvalues:
			[1] = t_TwitterCodes
			[2] = m_Library
	--]]
	t_TwitterCodes.Redeem.ImageColor3 = Color3.new(0.5, 0.5, 0.5);
	t_TwitterCodes.Redeem.TextLabel.Text = "(...)";
	local tostring_ret = tostring(t_TwitterCodes.Input.Text);
	if tostring_ret and tostring_ret ~= "" then
		local v1, v2 = m_Library.Network.Invoke("Redeem Twitter Code", tostring_ret);
		if not v1 then
			m_Library.Message.New(v2 or "Could not redeem");
		else
			m_Library.Audio.Play("rbxassetid://7055150312", script, 1, 1);
			m_Library.Message.New("\226\156\133 Successfully redeemed!");
		end
		t_TwitterCodes.Input.Text = "";
	end
	t_TwitterCodes.Redeem.ImageColor3 = Color3.new(1, 1, 1);
	t_TwitterCodes.Redeem.TextLabel.Text = "Redeem!";
end
m_Library.GUIFX.ButtonFX(t_TwitterCodes.Redeem);
t_TwitterCodes.Redeem.Activated:Connect(function() -- Line: 40
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		Redeem();
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_TwitterCodes.Close);
t_TwitterCodes.Close.Activated:Connect(function() -- Line: 50
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_TwitterCodes
	--]]
	if not bool1 then
		bool1 = true;
		t_TwitterCodes.Gui.Enabled = false;
		bool1 = false;
	end
end);
