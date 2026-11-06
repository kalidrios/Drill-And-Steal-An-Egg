-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_ServerBoosts = m_Library.GUI.ServerBoosts;
local table1 = {};
local bool1 = false;
function Update() -- Line: 22
	--[[
		Upvalues:
			[1] = m_Library
			[2] = bool1
			[3] = t_ServerBoosts
			[4] = table1
	--]]
	local function GetBoostingPlayers(p9) -- Line: 23
		local table2 = {};
		for _, val2 in ipairs(p9) do
			if not val2.userId then continue end
			table2[tostring(val2.userId)] = val2.name;
		end
		return table2;
	end
	local function UpdateBoost(p10) -- Line: 35
		--[[
			Upvalues:
				[1] = m_Library
				[2] = GetBoostingPlayers
		--]]
		local v5 = m_Library.Save.Get();
		if not v5 then return end
		local ActiveBoosts = m_Library.ServerBoosts.GetActiveBoosts();
		local Attribute = p10:GetAttribute("RequiredBoost");
		local v6 = ActiveBoosts[p10:GetAttribute("ServerBoost")];
		p10.TimeLeft.Visible = v6 ~= nil;
		p10.Heads.Visible = v6 ~= nil;
		if v6 then
			local v8 = GetBoostingPlayers(v6.boosters);
			local t_totalTimeLeft = v6.totalTimeLeft;
			if t_totalTimeLeft < 86400 then
				p10.TimeLeft.Text = m_Library.Functions.TimerString(t_totalTimeLeft);
			else
				p10.TimeLeft.Text = m_Library.Functions.TimeString(t_totalTimeLeft) .. " Left";
			end
			local table3 = {};
			for _, child3 in pairs(p10.Heads:GetChildren()) do
				if not child3:IsA("ImageLabel") or child3:GetAttribute("Template") then continue end
				if not v8[child3.Name] or table3[child3.Name] then
					child3:Destroy();
					continue;
				end
				table3[child3.Name] = true;
			end
			local ImageLabel = p10.Heads:WaitForChild("ImageLabel");
			for key4, val4 in pairs(v8) do
				local FindFirstChild_ret = p10.Heads:FindFirstChild(key4);
				if FindFirstChild_ret then continue end
				pcall(function() -- Line: 78
					--[[
						Upvalues:
							[1] = key4
							[2] = ImageLabel
							[3] = p10
							[4] = m_Library
							[5] = val4
					--]]
					local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(key4, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
					local Clone_ret = ImageLabel:Clone();
					Clone_ret:SetAttribute("Template", false);
					Clone_ret.Name = key4;
					Clone_ret.Image = UserThumbnailAsync;
					Clone_ret.Visible = true;
					Clone_ret.Parent = p10.Heads;
					m_Library.GUIFX.Tooltip(Clone_ret, val4);
				end);
			end
		end
		local v7 = v5.BoostsInventory[Attribute] or 0;
		local Use = p10.Buttons:FindFirstChild("Use");
		Use:FindFirstChild("Label").Text = "Use x20 (" .. m_Library.Functions.Commas(v7) .. ")";
		Use.ImageColor3 = v7 >= 20 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	end
	local function SetupBoost(p11) -- Line: 98
		--[[
			Upvalues:
				[1] = m_Library
				[2] = bool1
		--]]
		local _ = m_Library.Directory.Products[p11:GetAttribute("Product")].ID;
		local Attribute2 = p11:GetAttribute("ServerBoost");
		local Buttons = p11:FindFirstChild("Buttons");
		local Use2 = Buttons:FindFirstChild("Use");
		m_Library.GUIFX.ButtonFX(Use2);
		Use2.Activated:Connect(function() -- Line: 105
			--[[
				Upvalues:
					[1] = bool1
					[2] = m_Library
					[3] = Attribute2
			--]]
			if not bool1 then
				bool1 = true;
				m_Library.Network.Fire("Activate Server Boost", Attribute2);
				bool1 = false;
			end
		end);
	end
	for _, child1 in ipairs(t_ServerBoosts.Container:GetChildren()) do
		if not child1:GetAttribute("ServerBoost") then continue end
		UpdateBoost(child1);
		if table1[child1] then continue end
		table1[child1] = true;
		SetupBoost(child1);
	end
end
function UpdatePriceFrame(p1, p2, p3) -- Line: 130
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v3, v4 = m_Library.Functions.GetPrice(p2, not p3);
	local Robux = p1:FindFirstChild("Robux");
	if v4 and v3 > 0 then
		Robux.Text = m_Library.Functions.Commas(v3);
		return v3;
	end
	Robux.Text = "???";
	return v3;
end
function Scrolling() -- Line: 144
	--[[
		Upvalues:
			[1] = t_ServerBoosts
	--]]
	local t_Container = t_ServerBoosts.Container;
	local UIListLayout = t_Container:FindFirstChildOfClass("UIListLayout");
	local UIPadding = t_Container:FindFirstChildOfClass("UIPadding");
	t_Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
end
m_Library.GUIFX.ButtonFX(t_ServerBoosts.Close);
t_ServerBoosts.Close.Activated:Connect(function() -- Line: 156
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_ServerBoosts
	--]]
	if not bool1 then
		bool1 = true;
		t_ServerBoosts.Gui.Enabled = false;
		bool1 = false;
	end
end);
Update();
Scrolling();
m_Library.Network.Fired("Server Boost Update"):Connect(function(p4) -- Line: 172
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.ServerBoosts.SetActiveBoosts(p4);
	Update();
	m_Library.Signal.Fire("Server Boosts Changed");
end);
m_Library.Network.Fired("Server Boost Activated"):Connect(function(p5, p6, p7) -- Line: 179
	--[[
		Upvalues:
			[1] = m_Library
	--]]
    if p5 == m_Library.LocalPlayer then
		m_Library.Audio.Play("rbxassetid://11603330782", script, 1, 1);
	end
	local t_msg = m_Library.Shared.ServerBoostsInfo[p6].msg;
	if p5 then
		m_Library.ChatMsg.New("Server " .. p6 .. " Boost activated by " .. p5.DisplayName .. "!", Color3.fromRGB(46, 255, 63));
		return;
    end
	m_Library.ChatMsg.New("Server Event " .. p6 .. " has started for " .. p7 / 60 .. " minutes! " .. (t_msg and t_msg or ""), Color3.fromRGB(46, 255, 63));
end);
m_Library.Network.Fired("Server Boost Ended"):Connect(function(p8) -- Line: 197
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.ChatMsg.New("Server " .. p8 .. " Boost has ended!", Color3.fromRGB(46, 255, 63));
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 202
	task.defer(function() -- Line: 203
		Scrolling();
	end);
end);
