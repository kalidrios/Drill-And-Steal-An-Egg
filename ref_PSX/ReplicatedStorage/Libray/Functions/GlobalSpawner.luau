-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Library = ReplicatedStorage:WaitForChild("Library");
local m_Random = require(Library:WaitForChild("Modules").Random);
local m_wcall = require(script.Parent.wcall);
local _ = {};
return function(p1, p2, p3) -- Line: 15
	--[[
		Upvalues:
			[1] = m_Random
			[2] = Players
			[3] = m_wcall
	--]]
	assert(p1 > 0);
	p2 = math.max(p2, 1);
	local u1 = 1;
	if p1 < u1 then
		u1 = p1;
		p1 = u1;
	end
	local u2 = 1 / p1;
	local ServerTimeNow = workspace:GetServerTimeNow();
	local u3 = math.floor(ServerTimeNow / u1);
	task.defer(function() -- Line: 35
		--[[
			Upvalues:
				[1] = u3
				[2] = u3
				[3] = m_Random
				[4] = u2
				[5] = Players
				[6] = p2
				[7] = m_wcall
				[8] = p3
				[9] = u1
				[10] = ServerTimeNow
		--]]
		while true do
			if u3 > u3 then
				local math_max_ret = math.max(0, math.max(u3, u3 + 1) * u1 - ServerTimeNow);
				task.wait(math_max_ret);
				ServerTimeNow = workspace:GetServerTimeNow();
				u3 = math.floor(ServerTimeNow / u1);
				continue;
			end
			if m_Random.new(u3).number() < u2 and #Players:GetPlayers() / p2 > math.random() then
				m_wcall(p3);
			end
			u3 = u3 + 1;
		end
	end);
end;
