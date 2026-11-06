-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_IsHardcore = m_Library.Shared.IsHardcore;
local table1 = {
	Areas = {},
	Eggs = {},
	Upgrades = {}
};
function SendNotification(p1, p2) -- Line: 27
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	table.insert(table1[p2], p1);
	local v1 = nil;
	local Color3_fromRGB_ret = Color3.fromRGB(103, 255, 80);
	if p2 == "Eggs" then
		v1 = "You can afford to buy the " .. m_Library.Directory.Eggs[p1].displayName .. "!";
	elseif p2 == "Areas" then
		v1 = "You can afford to unlock the " .. m_Library.Directory.Areas[p1].name .. " area!";
	elseif p2 == "Upgrades" then
		v1 = "You can afford to buy the " .. m_Library.Directory.Upgrades[p1].title .. " Upgrade!";
	end
	m_Library.Signal.Fire("Notification", v1, {
		color = Color3_fromRGB_ret,
		time = 4
	});
	m_Library.Network.Fire("Sent Progress Notification", p1, p2);
end
function AttemptNotification(p3, p4) -- Line: 49
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
			[3] = table1
	--]]
	local v2 = m_Library.Save.Get();
	if not v2 then return end
	local v3 = t_IsHardcore and v2.Hardcore.ProgressNotifications or v2.ProgressNotifications;
	if not m_Library.Functions.SearchArray(table1[p4], p3) and not m_Library.Functions.SearchArray(v3[p4], p3) then
		SendNotification(p3, p4);
	end
end
function CheckForNotifications() -- Line: 62
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v4 = m_Library.Save.Get();
	if not v4 then return end
	local AllEggs = m_Library.WorldCmds.GetAllEggs();
	for _, val1 in ipairs(AllEggs) do
		local Attribute = val1:GetAttribute("ID");
		local Attribute2 = val1:GetAttribute("Unlocked");
		if Attribute == "Cracked Egg" then continue end
		local v5 = m_Library.Directory.Eggs[Attribute];
		local v6 = v4[v5.currency];
		if t_IsHardcore and v5.currency ~= "Diamonds" then
			v6 = v4.HardcoreCurrency[v5.currency];
		end
		if not Attribute2 or not v6 or v5.cost > v6 then continue end
		AttemptNotification(Attribute, "Eggs");
	end
	local AllGates = m_Library.WorldCmds.GetAllGates();
	for _, val2 in ipairs(AllGates) do
		local t_Name = val2.Name;
		local v7 = m_Library.Directory.Areas[t_Name];
		if not v7 then
			warn("Missing area:", t_Name);
			continue;
		end
		if not v7.gate then return end
		local t_currency = v7.gate.currency;
		local v8 = v4[t_currency];
		if t_IsHardcore and t_currency ~= "Diamonds" then
			v8 = v4.HardcoreCurrency[t_currency];
		end
		if not v7.gate or not v8 or v7.gate.cost > v8 then continue end
		AttemptNotification(t_Name, "Areas");
	end
end
m_Library.Signal.Fired("Stat Changed"):Connect(function(p5) -- Line: 129
	if string.find(p5, "Coins") or p5 == "Diamonds" or p5 == "AreasUnlocked" or p5 == "Hardcore" then
		CheckForNotifications();
	end
end);
m_Library.Network.Fired("Upgrade Bought"):Connect(function(p6) -- Line: 136
	--[[
		Upvalues:
			[1] = table1
	--]]
	for key3, val3 in ipairs(table1.Upgrades) do
		if val3 ~= p6 then continue end
		table.remove(table1.Upgrades, key3);
		return;
	end
end);
