-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_ListPet = m_Library.GUI.ListPet;
local t_Input = t_ListPet.InputFrame.Input;
local u1 = nil;
local bool1 = false;
function List(p1, p2) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local table1 = {};
	for _, val1 in ipairs(p1) do
		table.insert(table1, {
			val1,
			p2
		});
	end
	local v1, v2 = m_Library.Network.Invoke("Add Trading Booth Pet", table1);
	if not v1 then
		m_Library.Message.New(v2);
	end
	return v1;
end
function Prompt(p3) -- Line: 36
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = t_Input
			[4] = t_ListPet
			[5] = bool1
	--]]
	for _, val2 in ipairs(p3) do
		local v4, v5 = m_Library.PetCmds.Get(val2);
		if v4 and v5 == m_Library.LocalPlayer then continue end
		return;
	end
	if m_Library.Variables.ListingPet then return end
	m_Library.Variables.ListingPet = true;
	if u1 then
		u1:Disconnect();
		u1 = nil;
	end
	t_Input.Text = "";
	u1 = t_ListPet.Sell.Activated:Connect(function() -- Line: 57
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = t_Input
				[4] = p3
				[5] = t_ListPet
		--]]
		if not bool1 then
			bool1 = true;
			local v7 = m_Library.Functions.ParseNumberSmart(t_Input.Text);
			if typeof(v7) ~= "number" or not m_Library.Functions.IsFinite(v7) then
				m_Library.Message.New("Please enter a valid number!");
				bool1 = false;
				return;
			end
			local math_round_ret = math.round(v7);
			if math_round_ret <= 0 then
				m_Library.Message.New("Please enter a price greater than zero!");
				bool1 = false;
				return;
			end
			local bool2 = false;
			local bool3 = false;
			for _, val3 in ipairs(p3) do
				local v10 = m_Library.Directory.Pets[m_Library.PetCmds.Get(val3).id];
				if not v10 then
					m_Library.Message.New("Invalid pet!");
					bool1 = false;
					return;
				end
				if v10.huge and math_round_ret < 1000000000 then
					bool2 = true;
					continue;
				end
				if not v10.isPremium or math_round_ret >= 100000000 then continue end
				bool3 = true;
			end
			local v8 = #p3 > 1 and "(" .. #p3 .. ") " or "";
			local v9 = m_Library.Message.New("Are you sure you want to list these pets " .. v8 .. "for " .. m_Library.Functions.Commas(math_round_ret) .. " Diamonds?", true);
			if v9 then
				if bool2 then
					local v11 = m_Library.Message.New("ARE YOU SURE? You are only listing a huge pet for " .. m_Library.Functions.Commas(math_round_ret) .. "!", true);
					if v11 then
						local List_ret3 = List(p3, math_round_ret);
						if List_ret3 then
							t_ListPet.Gui.Enabled = false;
							m_Library.Audio.Play("rbxassetid://11648890721", script, 1, 1);
						end
					end
					bool1 = false;
					return;
				end
				if bool3 then
					local v12 = m_Library.Message.New("ARE YOU SURE? You are only listing this premium pet for " .. m_Library.Functions.Commas(math_round_ret) .. "!", true);
					if v12 then
						local List_ret2 = List(p3, math_round_ret);
						if List_ret2 then
							t_ListPet.Gui.Enabled = false;
							m_Library.Audio.Play("rbxassetid://11648890721", script, 1, 1);
						end
					end
					bool1 = false;
					return;
				end
				local List_ret = List(p3, math_round_ret);
				if List_ret then
					t_ListPet.Gui.Enabled = false;
					m_Library.Audio.Play("rbxassetid://11648890721", script, 1, 1);
				end
			end
			bool1 = false;
		end
	end);
	t_ListPet.Gui.Enabled = true;
	if m_Library.Variables.Console then
		m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("ListPet"):FindFirstChild("Frame"):FindFirstChild("Sell");
	end
	while t_ListPet.Gui.Enabled do
		m_Library.Heartbeat();
	end
	m_Library.Variables.ListingPet = false;
	if m_Library.Variables.Console then
		m_Library.GuiService.SelectedObject = nil;
	end
	return true;
end
t_ListPet.Close.Activated:Connect(function() -- Line: 199
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_ListPet
	--]]
	if not bool1 then
		bool1 = true;
		t_ListPet.Gui.Enabled = false;
		bool1 = false;
	end
end);
t_ListPet.InputFrame.Input:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 208
	--[[
		Upvalues:
			[1] = t_ListPet
			[2] = m_Library
	--]]
	local t_Text = t_ListPet.InputFrame.Input.Text;
	local v3 = m_Library.Functions.ParseNumberSmart(t_Text);
	if not v3 then
		t_ListPet.DiamondsDisplay.Frame.Amount.Text = "0";
		return;
	end
	t_ListPet.DiamondsDisplay.Frame.Amount.Text = m_Library.Functions.Commas((math.round(v3)));
end);
m_Library.GUIFX.ButtonFX(t_ListPet.Close);
m_Library.GUIFX.ButtonFX(t_ListPet.Sell);
m_Library.Signal.Invoked("List Pet").OnInvoke = function(p4) -- Line: 231
	--[[
		Upvalues:
			[1] = t_ListPet
			[2] = m_Library
	--]]
	t_ListPet.Gui.Frame.XboxAdd.Visible = m_Library.Variables.Console;
	return Prompt(p4);
end
local bool4 = false;
local bool5 = false;
local u2 = 0;
m_Library.Signal.Fired("Xbox Start Subtract"):Connect(function() -- Line: 240
	--[[
		Upvalues:
			[1] = bool4
			[2] = u2
	--]]
	bool4 = true;
	u2 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Subtract"):Connect(function() -- Line: 246
	--[[
		Upvalues:
			[1] = bool4
			[2] = u2
	--]]
	bool4 = false;
	u2 = 0;
end);
m_Library.Signal.Fired("Xbox Start Add"):Connect(function() -- Line: 252
	--[[
		Upvalues:
			[1] = bool5
			[2] = u2
	--]]
	bool5 = true;
	u2 = 0;
end);
m_Library.Signal.Fired("Xbox Stop Add"):Connect(function() -- Line: 257
	--[[
		Upvalues:
			[1] = bool5
			[2] = u2
	--]]
	bool5 = false;
	u2 = 0;
end);
local t_Input2 = t_ListPet.Gui.Frame.InputFrame.Input;
m_Library.RunService.Heartbeat:Connect(function(p5) -- Line: 263
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_ListPet
			[3] = bool4
			[4] = bool5
			[5] = u2
			[6] = t_Input2
	--]]
	if not m_Library.Variables.Console then return end
	if t_ListPet.Gui.Enabled and (bool4 or bool5) then
		u2 = u2 + p5;
		local math_pow_ret = math.pow(10, (math.floor(u2 / 3)));
		local v6 = t_Input2:GetAttribute("Amount") or 0;
		if bool4 then
			v6 = v6 - math_pow_ret * 1;
			if v6 < 10 then
				v6 = 0;
			end
		elseif bool5 then
			v6 = v6 + math_pow_ret * 1;
			if v6 < 10 then
				v6 = 10;
			end
		end
		if (bool5 or bool4) and (v6 > 0 or v6 == 0) then
			t_Input2.PlaceholderText = v6 > 0 and v6 or "None";
			t_Input2.Text = v6;
			t_Input2:SetAttribute("Amount", v6);
		end
	end
end);
