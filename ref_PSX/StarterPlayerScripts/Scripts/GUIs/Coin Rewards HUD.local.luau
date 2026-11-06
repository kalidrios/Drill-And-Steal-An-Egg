-- https://github.com/kalidrios

local table1 = {
	"rbxassetid://80504175052458",
	"rbxassetid://117085053950566",
	"rbxassetid://122445134826007",
	"rbxassetid://115718520111515"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
function CoinBonusAnimation(p1) -- Line: 23
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = Random_new_ret
	--]]
	debug.profilebegin("Coin Rewards HUD.CoinBonusAnimation");
	local v1, u1 = m_Library.Functions.CreateParticleHost(p1 + Vector3.new(0, 5, 0));
	m_Library.Audio.Play(table1, p1, 1, 1.65, 350);
	task.delay(0.5, function() -- Line: 30
		--[[
			Upvalues:
				[1] = m_Library
				[2] = u1
		--]]
		local Children = m_Library.Assets.Particles:FindFirstChild("Coin Bonus"):GetChildren();
		for _, val1 in ipairs(Children) do
			local Clone_ret = val1:Clone();
			Clone_ret.Parent = u1;
			Clone_ret:Emit(Clone_ret.Rate);
		end
	end);
	for index1 = 1, 6 do
		local v2 = math.pi / 6 * index1;
		local Clone_ret2 = m_Library.Assets.Other:FindFirstChild("Bonus Particle"):Clone();
		Clone_ret2.CFrame = CFrame.new(p1) * CFrame.Angles(v2, v2, v2);
		Clone_ret2.Velocity = Vector3.new(Random_new_ret:NextNumber(-30, 30), Random_new_ret:NextNumber(80, 85), Random_new_ret:NextNumber(-30, 30));
		Clone_ret2.Parent = m_Library.Debris;
		task.delay(1, function() -- Line: 46
			--[[
				Upvalues:
					[1] = Clone_ret2
			--]]
			if Clone_ret2 and Clone_ret2.Parent then
				Clone_ret2:FindFirstChildOfClass("Trail").Enabled = false;
			end
		end);
		m_Library.Functions.AddDebris(Clone_ret2, 3);
	end
	m_Library.WorldFX.RewardBillboard(p1, nil, "BonusReward");
	m_Library.Functions.AddDebris(v1, 5);
	debug.profileend();
end
m_Library.Network.Fired("Coin Bonus"):Connect(function(p2) -- Line: 61
	CoinBonusAnimation(p2);
end);
