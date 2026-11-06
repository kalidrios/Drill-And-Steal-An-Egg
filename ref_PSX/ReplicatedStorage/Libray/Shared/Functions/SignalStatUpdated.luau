-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local m_Signal = require(ReplicatedStorage:WaitForChild("Library").Signal);

if RunService:IsServer() then
	return function(p3, p4) -- Line: 12
		m_Signal.Fire("Stat Changed", p3, p4);
		m_Signal.Fire("Stats Changed", p3);
	end;
end

return function(p1, p2) -- Line: 18
	local v1 = p1 == Players.LocalPlayer;
	if v1 then
		m_Signal.Fire("Stat Changed", p2);
	else
		m_Signal.Fire("Other Stat Changed", p1, p2);
	end
	if v1 then
		m_Signal.Fire("Stats Changed");
		return;
	end
	m_Signal.Fire("Other Stats Changed", p1);
end;
