-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Main = m_Library.GUI.Main;
local _ = m_Library.Shared.IsTradingPlaza;
local table1 = {
	"Triple Damage",
	"Super Lucky",
	"Triple Coins"
};
function Render() -- Line: 19
	--[[
		Upvalues:
			[1] = t_Main
			[2] = m_Library
			[3] = table1
	--]]
	local u1 = t_Main.Boosts or t_Main.ServerBoosts;
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	t_Main.ServerBoosts.Visible = false;
	if not m_Library.Variables.ImportantWindowOpened then
		u1.Visible = v1.Settings.ShowBoosts == 1;
	else
		u1.Visible = false;
	end
    local ActiveBoosts = m_Library.ServerBoosts.GetActiveBoosts();
	for _, child1 in pairs(u1:GetChildren()) do
		if child1.ClassName ~= "Frame" or not child1:GetAttribute("Timed") or not child1:GetAttribute("ServerBoost") then continue end
		local v3 = ActiveBoosts[string.gsub(child1.Name, "Server ", "")];
		if v3 and v3.totalTimeLeft > 0 then continue end
		child1:Destroy();
	end
	local function AddBoost(p2, p3) -- Line: 47
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
		--]]
		local v5 = u1:FindFirstChild("Server " .. p2);
		if not v5 then
			local v6 = m_Library.Shared.ServerBoostsInfo[p2].tripleIcon and m_Library.Assets.UI.Main.TripleServerBoost:Clone() or m_Library.Assets.UI.Main.ServerBoost:Clone();
			v5 = v6;
			v6.TimeLeft.Text = "";
			for _, child3 in pairs(v5:GetChildren()) do
				if child3.Name ~= "Icon" then continue end
				child3.Image = m_Library.Shared.ServerBoostsInfo[p2].icon;
			end
			v5.Name = "Server " .. p2;
			v5.LayoutOrder = 4;
			v5.Parent = u1;
			if p3 then
				v5:SetAttribute("Timed", true);
			end
			local t_desc = m_Library.Shared.ServerBoostsInfo[p2].desc;
			m_Library.GUIFX.Tooltip(v5, t_desc);
		end
		return v5;
	end
	local function RemoveBoost(p4) -- Line: 72
		--[[
			Upvalues:
				[1] = u1
		--]]
		local FindFirstChild_ret = u1:FindFirstChild("Server " .. p4);
		if FindFirstChild_ret then
			FindFirstChild_ret:Destroy();
		end
	end
	for key2, val2 in pairs(ActiveBoosts) do
		if not m_Library.Functions.SearchArray(table1, key2) then continue end
		local t_totalTimeLeft = val2.totalTimeLeft;
		local v4 = AddBoost(key2, true);
		if t_totalTimeLeft >= 86400 then
			v4.TimeLeft.Text = m_Library.Functions.TimeString(t_totalTimeLeft);
			continue;
		end
		v4.TimeLeft.Text = os.date("!%X", t_totalTimeLeft);
	end
end
function Scaling() -- Line: 97
end
Render();
Scaling();
m_Library.Signal.Fired("Server Boosts Changed"):Connect(function() -- Line: 120
	Render();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p1) -- Line: 125
	if p1 == "Boosts" or p1 == "Gamepasses" or p1 == "IsFollowingOnTwitter" or p1 == "Settings" or p1 == "FriendsBoost" then
		Render();
	end
end);
m_Library.Signal.Fired("Important Window Toggled"):Connect(function() -- Line: 132
	Render();
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 137
	Scaling();
end);
