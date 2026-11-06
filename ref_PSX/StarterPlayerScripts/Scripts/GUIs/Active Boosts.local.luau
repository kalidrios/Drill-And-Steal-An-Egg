-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Boosts = m_Library.GUI.Main.Boosts;
local t_ID = m_Library.Directory.Gamepasses.Lucky.ID;
local t_ID2 = m_Library.Directory.Gamepasses["Mythical Hunter"].ID;
local t_ID3 = m_Library.Directory.Gamepasses["Secret Hunter"].ID;
local t_ID4 = m_Library.Directory.Gamepasses["Shiny Hunter"].ID;
local t_ID5 = m_Library.Directory.Gamepasses.VIP.ID;
local t_IsTradingPlaza = m_Library.Shared.IsTradingPlaza;
local table1 = {};
function Render() -- Line: 25
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Boosts
			[3] = t_ID
			[4] = t_ID2
			[5] = t_ID3
			[6] = t_ID4
			[7] = t_ID5
			[8] = t_IsTradingPlaza
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	if not m_Library.Variables.ImportantWindowOpened then
		t_Boosts.Visible = v1.Settings.ShowBoosts == 1;
	else
		t_Boosts.Visible = false;
	end
	local v2 = m_Library.Gamepasses.Owns(t_ID);
	local v3 = m_Library.Gamepasses.Owns(t_ID2);
	local v4 = m_Library.Gamepasses.Owns(t_ID3);
	local v5 = m_Library.Gamepasses.Owns(t_ID4);
	local v6 = m_Library.Gamepasses.Owns(t_ID5);
	local v7 = m_Library.Functions.CloneTable(v1.Boosts);
	for _, child1 in pairs(t_Boosts:GetChildren()) do
		if child1.ClassName ~= "Frame" or not child1:GetAttribute("Timed") or child1:GetAttribute("ServerBooster") or child1:GetAttribute("Fruit") or string.match(child1.Name, "Server") then continue end
		local v13 = v7[child1.Name];
        if v13 and v13 > 0 then continue end
		child1:Destroy();
	end
	local function AddBoost(p2, p3) -- Line: 54
		--[[
			Upvalues:
				[1] = t_Boosts
				[2] = m_Library
				[3] = t_IsTradingPlaza
		--]]
		local v19 = t_Boosts:FindFirstChild(p2);
		if not v19 then
			v19 = m_Library.Assets.UI.Main.Boost:Clone();
			v19.TimeLeft.Text = "";
			v19.Icon.Image = m_Library.Shared.BoostsInfo[p2].icon;
			v19.Name = p2;
			v19.LayoutOrder = p3 and 1 or 2;
			v19.Parent = t_Boosts;
			if p3 then
				v19:SetAttribute("Timed", true);
			end
			local v22 = m_Library.Shared.BoostsInfo[p2].desc;
			if t_IsTradingPlaza then
				v22 = v22 .. " (paused)";
			end
			m_Library.GUIFX.Tooltip(v19, v22);
		end
		return v19;
	end
	local function RemoveBoost(p4) -- Line: 77
		--[[
			Upvalues:
				[1] = t_Boosts
		--]]
		local FindFirstChild_ret = t_Boosts:FindFirstChild(p4);
		if FindFirstChild_ret then
			FindFirstChild_ret:Destroy();
		end
	end
	for key2, val2 in pairs(v7) do
		local v14 = AddBoost(key2, true);
		if val2 >= 86400 then
			v14.TimeLeft.Text = m_Library.Functions.TimeString(val2);
			continue;
		end
		v14.TimeLeft.Text = os.date("!%X", val2);
	end
	if v2 then
		AddBoost("Lucky");
	end
	if v3 then
		AddBoost("Mythical Hunter");
	end
	if v4 then
		AddBoost("Secret Hunter");
	end
	if v5 then
		AddBoost("Shiny Hunter");
	end
	if v6 then
		AddBoost("VIP");
	end
	if v1.IsFollowingOnTwitter then
		AddBoost("Verified");
	else
		local Verified = t_Boosts:FindFirstChild("Verified");
		if Verified then
			Verified:Destroy();
		end
	end
	local v9 = m_Library.FFlags.Get(m_Library.FFlags.Keys.CoinsEvent);
	if typeof(v9) ~= "number" then
		v9 = 0;
	end
	if v9 > 1 then
		AddBoost("Coins Event");
	else
		local FindFirstChild_ret2 = t_Boosts:FindFirstChild("Coins Event");
		if FindFirstChild_ret2 then
			FindFirstChild_ret2:Destroy();
		end
	end
	local v10 = m_Library.FFlags.Get(m_Library.FFlags.Keys.LuckEvent);
	if typeof(v10) ~= "number" then
		v10 = 0;
	end
	if v10 > 0 then
		AddBoost("Luck Event");
	else
		local FindFirstChild_ret3 = t_Boosts:FindFirstChild("Luck Event");
		if FindFirstChild_ret3 then
			FindFirstChild_ret3:Destroy();
		end
	end
	if v1.FriendsBoost and v1.FriendsBoost > 1 then
		AddBoost("Friends").TimeLeft.Text = "x" .. v1.FriendsBoost;
		return;
	end
	local Friends = t_Boosts:FindFirstChild("Friends");
	if Friends then
		Friends:Destroy();
	end
end
function RenderFruit() -- Line: 150
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Boosts
			[3] = table1
	--]]
	local table2 = {};
	for key3, val3 in pairs(m_Library.FruitCmds.Directory) do
        local v15 = m_Library.FruitCmds.Get(m_Library.LocalPlayer, val3);
        local math_ceil_ret = math.ceil(v15);
		local v16 = v15 - math.floor(v15);
		if v16 <= 0 then
			v16 = 1;
		end
		local v17 = m_Library.FruitCmds.GetBonus(m_Library.LocalPlayer, val3);
		if math_ceil_ret <= 0 then continue end
		table2[key3] = {
			Amount = v15,
			FullStacks = math_ceil_ret,
			PartialStack = v16,
			Boost = v17
		};
    end
    
	local function AddFruit(p5) -- Line: 172
		--[[
			Upvalues:
				[1] = t_Boosts
				[2] = m_Library
				[3] = table2
				[4] = table1
		--]]
        local v20 = t_Boosts:FindFirstChild(p5);
		if not v20 then
            v20 = m_Library.Assets.UI.Main.Boost:Clone();
            v20.TimeLeft.Text = "";
			v20.Icon.Image = m_Library.Shared.BoostsInfo[p5].icon;
			v20.Name = p5;
			v20.LayoutOrder = 3;
			v20.Parent = t_Boosts;
			v20:SetAttribute("Fruit", true);
		end
		local v21 = table2[p5];
		local t_desc = m_Library.Shared.BoostsInfo[p5].desc;
		local gsub_ret = t_desc:gsub("{percent}", (math.ceil(v21.Boost * 100)));
		local gsub_ret2 = string.format("%0.2f", v21.Boost + 1):gsub("0*$", ""):gsub("%.$", "");
		local gsub_ret3 = gsub_ret:gsub("{mult}", gsub_ret2);
		if not table1[p5] or table1[p5].Desc ~= gsub_ret3 then
			if table1[p5] then
				table1[p5].Cancel();
			end
			local v23 = m_Library.GUIFX.Tooltip(v20, gsub_ret3);
			table1[p5] = {
				Desc = gsub_ret3,
				Cancel = v23
			};
        end
		return v20;
	end
	for key4, val4 in pairs(table2) do
        local v18 = AddFruit(key4);
		if val4.FullStacks <= 0 then continue end
		v18.TimeLeft.Text = "x" .. tostring(val4.FullStacks);
	end
	for _, child5 in pairs(t_Boosts:GetChildren()) do
        if child5.ClassName ~= "Frame" or
            not child5:GetAttribute("Fruit") or 
            table2[child5.Name] and
            m_Library.FFlags.Get(m_Library.FFlags.Keys.Fruit) then 
            continue
        end
        
        table1[child5.Name] = nil;
		child5:Destroy();
	end
end
function Scaling() -- Line: 227
	--[[
		Upvalues:
			[1] = t_Boosts
			[2] = m_Library
	--]]
	local UIGridLayout = t_Boosts:FindFirstChildOfClass("UIGridLayout");
	local v12 = m_Library.Functions.ResolutionScale();
	local num1 = 50;
	if v12 <= 0.55 then
		num1 = 35;
	elseif v12 <= 0.75 then
		num1 = 45;
	end
	UIGridLayout.CellSize = UDim2.new(0, num1, 0, num1);
end
Render();
Scaling();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p1) -- Line: 248
	if p1 == "Boosts" or p1 == "Gamepasses" or p1 == "IsFollowingOnTwitter" or p1 == "Settings" or p1 == "FriendsBoost" or p1 == "Fruits" then
		Render();
	end
end);
m_Library.Signal.Fired("Important Window Toggled"):Connect(function() -- Line: 255
	Render();
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 260
	Scaling();
end);
m_Library.Signal.Fired("FFlags Changed"):Connect(function() -- Line: 264
	Render();
end);
task.spawn(function() -- Line: 269
	while true do
		RenderFruit();
		wait(1);
	end
end);
