-- https://github.com/kalidrios

local table1 = {
	Color3.fromRGB(255, 49, 49),
	Color3.fromRGB(255, 179, 55),
	Color3.fromRGB(255, 255, 53),
	Color3.fromRGB(105, 255, 79),
	Color3.fromRGB(70, 252, 255),
	Color3.fromRGB(193, 85, 255),
	Color3.fromRGB(255, 169, 225)
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local t_Achievements = m_Library.Assets.Particles.Achievements;
function GetRandomInPart(p1) -- Line: 25
	local Random_new_ret2 = Random.new();
	local NextNumber_ret = Random_new_ret2:NextNumber(-p1.Size.X / 2, p1.Size.X / 2);
	local NextNumber_ret2 = Random_new_ret2:NextNumber(-p1.Size.Y / 2, p1.Size.Y / 2);
	local NextNumber_ret3 = Random_new_ret2:NextNumber(-p1.Size.Z / 2, p1.Size.Z / 2);
	return p1.CFrame * CFrame.new(NextNumber_ret, NextNumber_ret2, NextNumber_ret3);
end
function Firework(p2, p3, p4, p5) -- Line: 35
	--[[
		Upvalues:
			[1] = table1
			[2] = Random_new_ret
			[3] = m_Library
			[4] = t_Achievements
	--]]
	if not p3 then
		p3 = 1;
	end
	if not p4 then
		p4 = 1;
	end
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 42
		--[[
			Upvalues:
				[1] = table1
				[2] = Random_new_ret
				[3] = p2
				[4] = m_Library
				[5] = p5
				[6] = t_Achievements
				[7] = p3
				[8] = p4
		--]]
		local v2 = table1[Random_new_ret:NextInteger(1, #table1)];
		local firework = Instance.new("Part");
		firework.CanCollide = false;
		firework.Anchored = true;
		firework.CFrame = p2;
		firework.Size = Vector3.new();
		firework.Name = "firework";
		firework.Parent = m_Library.Debris;
		if p5 and math.random() < 0.1 then
			m_Library.Audio.Play("rbxassetid://111951469482472", firework, 1, 1.2, 100);
		end
		local Clone_ret = t_Achievements:FindFirstChild("Firework-Trail"):Clone();
		Clone_ret.Parent = firework;
		local NextNumber_ret4 = Random_new_ret:NextNumber(8, 11);
		m_Library.Functions.Tween(firework, {CFrame = p2 + Vector3.new(0, NextNumber_ret4, 0)}, {
			NextNumber_ret4 / 10,
			"Linear"
		}).Completed:Wait();
		Clone_ret.Enabled = false;
		local Clone_ret2 = t_Achievements:FindFirstChild("Firework"):Clone();
		Clone_ret2.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, v2),
			ColorSequenceKeypoint.new(1, v2)
		});
		Clone_ret2.Parent = firework;
		Clone_ret2.Speed = NumberRange.new(Clone_ret2.Speed.Min * p3);
		Clone_ret2.Drag = Clone_ret2.Drag * p4;
		Clone_ret2:Emit(25);
		m_Library.Functions.AddDebris(firework, 4);
	end);
	coroutine_wrap_ret();
end
function PlayFireworks(p6) -- Line: 77
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret
	--]]
	local v1 = m_Library.Player.UpperTorso(p6);
	if not v1 then return end
	m_Library.Audio.Play("rbxassetid://111951469482472", v1, 1, 1.2, 250);
	for index1 = 1, Random_new_ret:NextInteger(8, 10) do
		if v1 then
			Firework(v1.CFrame + Vector3.new(Random_new_ret:NextNumber(-4, 4), -2, Random_new_ret:NextNumber(-4, 4)));
		end
		m_Library.Functions.Wait(0.25, 0.5);
	end
end
m_Library.Signal.Fired("Play Fireworks"):Connect(Firework);
m_Library.Network.Fired("Play Fireworks"):Connect(Firework);
local Random_new_ret3 = Random.new();
m_Library.Network.Fired("Start Dance Party Fireworks"):Connect(function(p7) -- Line: 101
	--[[
		Upvalues:
			[1] = m_Library
			[2] = Random_new_ret3
	--]]
	local u1 = p7 or 18000;
	task.spawn(function() -- Line: 103
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
				[3] = Random_new_ret3
		--]]
		for index2 = 1, u1 do
			local Map = m_Library.WorldCmds.GetMap();
			local Interactive = Map:FindFirstChild("Interactive");
			if Interactive then
				local FireworkZone = Interactive:FindFirstChild("FireworkZone");
				if FireworkZone then
					local RandomInPart = GetRandomInPart(FireworkZone);
					Firework(RandomInPart, Random_new_ret3:NextNumber(1, 4), Random_new_ret3:NextNumber(0.5, 1), true);
					m_Library.Functions.Wait(0.01);
				end
			end
		end
	end);
end);
m_Library.Network.Fired("Fireworks Animation"):Connect(function(p8) -- Line: 119
	PlayFireworks(p8);
end);
m_Library.Signal.Fired("Fireworks Animation"):Connect(function(p9) -- Line: 123
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	p9 = p9 or m_Library.LocalPlayer;
	PlayFireworks(p9);
end);
