-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_BidPet = m_Library.GUI.BidPet;
local t_Input = t_BidPet.InputFrame.Input;
local t_Amount = t_BidPet.DiamondsDisplayMin.Frame.Amount;
local t_InputButton = t_BidPet.InputFrame.InputButton;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = 0;
local bool1 = false;
function Bid(p1) -- Line: 25
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u3
	--]]
	local v1 = m_Library.Signal.Invoke("Get Current Auction");
	if not v1 or not u3 or v1.Id ~= u3.Id then
		m_Library.Message.New("That auction has ended!");
		return;
	end
	local v2, v3 = m_Library.Network.Invoke("Auction: Bid", u3.Id, p1);
	if not v2 then
		m_Library.Message.New(v3);
	end
	return v2;
end
function Prompt() -- Line: 42
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = t_Input
			[4] = t_Amount
			[5] = m_Library
			[6] = u4
			[7] = t_InputButton
			[8] = bool1
			[9] = t_BidPet
	--]]
	if u1 then
		u1:Disconnect();
		u1 = nil;
		u2:Disconnect();
		u2 = nil;
	end
	t_Input.Text = "";
	t_Amount.Text = m_Library.Functions.Commas(u4);
	m_Library.GUIFX.ButtonFX(t_InputButton);
	u2 = t_InputButton.Activated:Connect(function() -- Line: 55
		--[[
			Upvalues:
				[1] = bool1
				[2] = t_Input
				[3] = u4
		--]]
		bool1 = true;
		t_Input.Text = u4;
		bool1 = false;
	end);
	u1 = t_BidPet.Bid.Activated:Connect(function() -- Line: 63
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = t_Input
				[4] = t_BidPet
		--]]
		if not bool1 then
			bool1 = true;
			local v6 = m_Library.Functions.ParseNumberSmart(t_Input.Text);
			if typeof(v6) ~= "number" or not m_Library.Functions.IsFinite(v6) then
				m_Library.Message.New("Please enter a valid number!");
				bool1 = false;
				return;
			end
			local math_round_ret = math.round(v6);
			if math_round_ret <= 0 then
				m_Library.Message.New("Please enter a price greater than zero!");
				bool1 = false;
				return;
			end
			local v7 = m_Library.Message.New("Are you sure you want to bid " .. m_Library.Functions.Commas(math_round_ret) .. " Diamonds for this pet?", true);
			if v7 then
				local Bid_ret = Bid(math_round_ret);
				if Bid_ret then
					t_BidPet.Gui.Enabled = false;
				end
			end
			bool1 = false;
		end
	end);
	t_BidPet.Gui.Enabled = true;
	if m_Library.Variables.Console then
		m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("ListPet"):FindFirstChild("Frame"):FindFirstChild("Sell");
	end
	while t_BidPet.Gui.Enabled do
		m_Library.Heartbeat();
	end
	if m_Library.Variables.Console then
		m_Library.GuiService.SelectedObject = nil;
	end
	return true;
end
t_BidPet.Close.Activated:Connect(function() -- Line: 112
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_BidPet
	--]]
	if not bool1 then
		bool1 = true;
		t_BidPet.Gui.Enabled = false;
		bool1 = false;
	end
end);
t_BidPet.InputFrame.Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 121
	--[[
		Upvalues:
			[1] = t_BidPet
			[2] = m_Library
	--]]
	local t_Text = t_BidPet.InputFrame.Input.Text;
	local v4 = m_Library.Functions.ParseNumberSmart(t_Text);
	if not v4 then
		t_BidPet.DiamondsDisplayPrice.Frame.Amount.Text = "0";
		return;
	end
	t_BidPet.DiamondsDisplayPrice.Frame.Amount.Text = m_Library.Functions.Commas((math.round(v4)));
end);
m_Library.GUIFX.ButtonFX(t_BidPet.Close);
m_Library.GUIFX.ButtonFX(t_BidPet.Bid);
m_Library.Signal.Fired("Auction Bid"):Connect(function(p2, p3) -- Line: 144
	--[[
		Upvalues:
			[1] = t_BidPet
			[2] = m_Library
			[3] = u3
			[4] = u4
	--]]
	if not p2 then return end
	t_BidPet.Gui.Frame.XboxAdd.Visible = m_Library.Variables.Console;
	u3 = p2;
	u4 = p3;
	Prompt();
end);
m_Library.Signal.Fired("Minimum Bid Update"):Connect(function(p4) -- Line: 157
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u4
			[3] = t_Amount
	--]]
	if not m_Library.GUI.BidPet.Gui.Enabled then return end
	u4 = p4;
	t_Amount.Text = m_Library.Functions.Commas((math.round(p4)));
end);
m_Library.Signal.Fired("Auction Ended"):Connect(function(p5) -- Line: 167
	--[[
		Upvalues:
			[1] = u3
			[2] = m_Library
	--]]
	if not u3 or u3.Id ~= p5.Id or not m_Library.GUI.BidPet.Gui.Enabled then return end
	m_Library.GUI.BidPet.Gui.Enabled = false;
	m_Library.Message.New("The auction has ended! You can no longer bid on this pet!");
end);
local bool2 = false;
local bool3 = false;
local u5 = 0;
m_Library.Signal.Fired("Xbox Start Subtract"):Connect(function() -- Line: 180
	--[[
		Upvalues:
			[1] = bool2
			[2] = u5
	--]]
	bool2 = true;
	u5 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Subtract"):Connect(function() -- Line: 186
	--[[
		Upvalues:
			[1] = bool2
			[2] = u5
	--]]
	bool2 = false;
	u5 = 0;
end);
m_Library.Signal.Fired("Xbox Start Add"):Connect(function() -- Line: 192
	--[[
		Upvalues:
			[1] = bool3
			[2] = u5
	--]]
	bool3 = true;
	u5 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Add"):Connect(function() -- Line: 198
	--[[
		Upvalues:
			[1] = bool3
			[2] = u5
	--]]
	bool3 = false;
	u5 = 0;
end);
local t_Input2 = t_BidPet.Gui.Frame.InputFrame.Input;
m_Library.RunService.Heartbeat:Connect(function(p6) -- Line: 205
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_BidPet
			[3] = bool2
			[4] = bool3
			[5] = u5
			[6] = t_Input2
	--]]
	if not m_Library.Variables.Console then return end
	if t_BidPet.Gui.Enabled and (bool2 or bool3) then
		u5 = u5 + p6;
		local math_pow_ret = math.pow(10, (math.floor(u5 / 3)));
		local v5 = t_Input2:GetAttribute("Amount") or 0;
		if bool2 then
			v5 = v5 - math_pow_ret * 1;
			if v5 < 10 then
				v5 = 0;
			end
		elseif bool3 then
			v5 = v5 + math_pow_ret * 1;
			if v5 < 10 then
				v5 = 10;
			end
		end
		if (bool3 or bool2) and (v5 > 0 or v5 == 0) then
			t_Input2.PlaceholderText = v5 > 0 and v5 or "None";
			t_Input2.Text = v5;
			t_Input2:SetAttribute("Amount", v5);
		end
	end
end);
