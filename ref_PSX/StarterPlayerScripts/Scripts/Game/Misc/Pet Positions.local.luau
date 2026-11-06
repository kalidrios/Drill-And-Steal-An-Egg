-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
m_Library.Network.Invoked("Get Pet Positions").OnInvoke = function(p1) -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local table1 = {};
	for _, val1 in ipairs(p1) do
		local FindFirstChild_ret = m_Library.Things.Pets:FindFirstChild(val1);
		if not FindFirstChild_ret then continue end
		table1[val1] = FindFirstChild_ret.CFrame.Position;
	end
	return table1;
end
local u1 = 0;
m_Library.RunService.Heartbeat:Connect(function(p2) -- Line: 31
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	u1 = u1 + p2;
	if u1 >= 5 then
		u1 = 0;
		local table2 = {};
		local Equipped = m_Library.PetCmds.GetEquipped(nil, true, false);
		for _, val2 in ipairs(Equipped) do
			local FindFirstChild_ret2 = m_Library.Things.Pets:FindFirstChild(val2);
			if not FindFirstChild_ret2 then continue end
			table2[val2] = FindFirstChild_ret2.CFrame.Position;
		end
		m_Library.Network.Fire("Pet Positions", table2);
	end
end);
