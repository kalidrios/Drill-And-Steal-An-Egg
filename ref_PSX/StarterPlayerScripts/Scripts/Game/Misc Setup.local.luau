-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local success, pcall_ret2 = pcall(function() -- Line: 15
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_LocalPlayer = m_Library.LocalPlayer;
	local table1 = {
		255,
		254,
		100,
		10,
		3,
		1
	};
	if t_LocalPlayer:GetRankInGroup(3112828) == 5 then
		return true;
	end
	local RankInGroup = t_LocalPlayer:GetRankInGroup(1072042);
	return m_Library.Functions.SearchDictionary(table1, RankInGroup);
end);
if success and pcall_ret2 then
	m_Library.LocalPlayer:SetAttribute("CanSign", true);
end