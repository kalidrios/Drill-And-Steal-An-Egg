-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_AuctionPet = m_Library.GUI.AuctionPet;
local t_Input = t_AuctionPet.InputFrame.Input;
local u1 = nil;
local bool1 = false;
function AuctionPet(p1, p2) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1, v2 = m_Library.Network.Invoke("Auction: Create", p1, p2);
	if not v1 then
		m_Library.Message.New(v2);
	end
	return v1;
end
function Prompt(p3) -- Line: 31
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = t_Input
			[4] = t_AuctionPet
			[5] = bool1
	--]]
	local u3, v3 = m_Library.PetCmds.Get(p3);
	if not u3 or v3 ~= m_Library.LocalPlayer then return end
	if not m_Library.Directory.Pets[u3.id] then return end
	if m_Library.Variables.AuctioningPet then return end
	m_Library.Variables.AuctioningPet = true;
	if u1 then
		u1:Disconnect();
		u1 = nil;
	end
	t_Input.Text = "";
	u1 = t_AuctionPet.Auction.Activated:Connect(function() -- Line: 55
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = t_Input
				[4] = u3
				[5] = p3
				[6] = t_AuctionPet
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
			if math_round_ret <= 0 or not m_Library.Functions.IsFinite(math_round_ret) then
				m_Library.Message.New("Please enter a price greater than zero!");
				bool1 = false;
				return;
			end
			if m_Library.Directory.Currency.Diamonds.Limit < math_round_ret then
				m_Library.Message.New("You cannot auction a pet for this much!");
				bool1 = false;
				return;
			end
			if not m_Library.Shared.CanAuctionPet(u3) then
				m_Library.Message.New("You can only auction huge and titanic pets!");
				bool1 = false;
				return;
			end
			local v7 = m_Library.Message.New("Are you sure you want to auction this pet starting at " .. m_Library.Functions.Commas(math_round_ret) .. " Diamonds? You will lose 5% of the earnings due to tax!", true);
			if v7 then
				local v8 = m_Library.Message.New("Auction will proceed even if you leave or server restarts, you will get your rewards when you rejoin! Are you still sure?", true);
				if v8 then
					local AuctionPet_ret = AuctionPet(p3, math_round_ret);
					if AuctionPet_ret then
						t_AuctionPet.Gui.Enabled = false;
						m_Library.Signal.Fire("Notification", "Submitted " .. m_Library.Shared.PetNameShort(u3) .. " for auction starting at " .. m_Library.Functions.NumberShorten(math_round_ret) .. " Diamonds!", {
							color = Color3.fromRGB(78, 244, 252),
							force = true
						});
					end
				end
			end
			bool1 = false;
		end
	end);
	t_AuctionPet.Gui.Enabled = true;
	if m_Library.Variables.Console then
		m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("ListPet"):FindFirstChild("Frame"):FindFirstChild("Auction");
	end
	while t_AuctionPet.Gui.Enabled do
		m_Library.Heartbeat();
	end
	m_Library.Variables.AuctioningPet = false;
	if m_Library.Variables.Console then
		m_Library.GuiService.SelectedObject = nil;
	end
	return true;
end
t_AuctionPet.Close.Activated:Connect(function() -- Line: 123
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_AuctionPet
	--]]
	if not bool1 then
		bool1 = true;
		t_AuctionPet.Gui.Enabled = false;
		bool1 = false;
	end
end);
t_AuctionPet.InputFrame.Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 132
	--[[
		Upvalues:
			[1] = t_AuctionPet
			[2] = m_Library
	--]]
	local t_Text = t_AuctionPet.InputFrame.Input.Text;
	local v4 = m_Library.Functions.ParseNumberSmart(t_Text);
	if not v4 then
		t_AuctionPet.DiamondsDisplay.Frame.Amount.Text = "0";
		return;
	end
	t_AuctionPet.DiamondsDisplay.Frame.Amount.Text = m_Library.Functions.Commas((math.round(v4)));
end);
m_Library.GUIFX.ButtonFX(t_AuctionPet.Close);
m_Library.GUIFX.ButtonFX(t_AuctionPet.Auction);
m_Library.Signal.Invoked("Auction Pet").OnInvoke = function(p4) -- Line: 155
	--[[
		Upvalues:
			[1] = t_AuctionPet
			[2] = m_Library
	--]]
	t_AuctionPet.Gui.Frame.XboxAdd.Visible = m_Library.Variables.Console;
	return Prompt(p4);
end
local bool2 = false;
local bool3 = false;
local u2 = 0;
m_Library.Signal.Fired("Xbox Start Subtract"):Connect(function() -- Line: 164
	--[[
		Upvalues:
			[1] = bool2
			[2] = u2
	--]]
	bool2 = true;
	u2 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Subtract"):Connect(function() -- Line: 170
	--[[
		Upvalues:
			[1] = bool2
			[2] = u2
	--]]
	bool2 = false;
	u2 = 0;
end);
m_Library.Signal.Fired("Xbox Start Add"):Connect(function() -- Line: 176
	--[[
		Upvalues:
			[1] = bool3
			[2] = u2
	--]]
	bool3 = true;
	u2 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Add"):Connect(function() -- Line: 181
	--[[
		Upvalues:
			[1] = bool3
			[2] = u2
	--]]
	bool3 = false;
	u2 = 0;
end);
local t_Input2 = t_AuctionPet.Gui.Frame.InputFrame.Input;
m_Library.RunService.Heartbeat:Connect(function(p5) -- Line: 187
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_AuctionPet
			[3] = bool2
			[4] = bool3
			[5] = u2
			[6] = t_Input2
	--]]
	if not m_Library.Variables.Console then return end
	if t_AuctionPet.Gui.Enabled and (bool2 or bool3) then
		u2 = u2 + p5;
		local math_pow_ret = math.pow(10, (math.floor(u2 / 3)));
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
