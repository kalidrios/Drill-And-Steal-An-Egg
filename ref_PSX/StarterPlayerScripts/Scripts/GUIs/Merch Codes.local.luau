-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_MerchCodes = m_Library.GUI.MerchCodes;
local bool1 = false;
function Redeem() -- Line: 18
	--[[
		Upvalues:
			[1] = t_MerchCodes
			[2] = m_Library
	--]]
	local tostring_ret = tostring(t_MerchCodes.Input.Text);
	if tostring_ret and tostring_ret ~= "" then
		if m_Library.Message.New("Would you like to redeem this code?", "Yes", "No") == 1 then
			local v1, v2, _ = m_Library.Network.Invoke("Redeem Merch Code", tostring_ret);
			if not v1 then
				m_Library.Message.New(v2 or "We are sorry for the inconvenience, but please try again in a few hours as we are making updates to the DLC system.  If this problem persists for more than 24 hours, contact merchandise support.");
			else
				m_Library.Audio.Play("rbxassetid://7055150312", script, 1, 1);
				m_Library.Signal.Fire("Notification", "\226\156\133 Successfully redeemed! Thanks for supporting us \226\152\186\239\184\143", {
					color = Color3.fromRGB(105, 255, 168),
					force = true
				});
			end
		end
		t_MerchCodes.Input.Text = "teste";
	end
	t_MerchCodes.Redeem.ImageColor3 = Color3.new(1, 1, 1);
	t_MerchCodes.Redeem.TextLabel.Text = "Redeem!";
end
m_Library.GUIFX.ButtonFX(t_MerchCodes.Redeem);
t_MerchCodes.Redeem.Activated:Connect(function() -- Line: 46
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
m_Library.GUIFX.ButtonFX(t_MerchCodes.Close);
t_MerchCodes.Close.Activated:Connect(function() -- Line: 56
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_MerchCodes
	--]]
	if not bool1 then
		bool1 = true;
		t_MerchCodes.Gui.Enabled = false;
		bool1 = false;
	end
end);
