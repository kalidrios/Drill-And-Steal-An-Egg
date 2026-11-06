-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local bool1 = false;
local u2 = 0;
function Setup() -- Line: 19
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = u1
	--]]
	if bool1 then return end
	bool1 = true;
	local v1 = m_Library.Audio.Play("rbxassetid://106444379350844", u1.PrimaryPart, 1, 0.2, nil, nil, true);
	v1.RollOffMaxDistance = 80;
	v1.RollOffMinDistance = 10;
	local function AnimateRock(p2) -- Line: 30
		--[[
			Upvalues:
				[1] = m_Library
		--]]
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 34
			--[[
				Upvalues:
					[1] = p2
					[2] = m_Library
			--]]
			local PrimaryPartCFrame = p2:GetPrimaryPartCFrame();
			local t_Position = PrimaryPartCFrame.Position;
			while p2 and p2.Parent do
				p2:SetPrimaryPartCFrame(PrimaryPartCFrame - t_Position + (t_Position + Vector3.new(0, math.sin(tick() * math.pi / 2) * 1, 0)));
				m_Library.RenderStepped();
			end
		end);
		coroutine_wrap_ret();
	end
	local Crystal = u1:FindFirstChild("Crystal");
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 34
		--[[
			Upvalues:
				[1] = Crystal
				[2] = m_Library
		--]]
		local PrimaryPartCFrame2 = Crystal:GetPrimaryPartCFrame();
		local t_Position2 = PrimaryPartCFrame2.Position;
		while Crystal and Crystal.Parent do
			Crystal:SetPrimaryPartCFrame(PrimaryPartCFrame2 - t_Position2 + (t_Position2 + Vector3.new(0, math.sin(tick() * math.pi / 2) * 1, 0)));
			m_Library.RenderStepped();
		end
	end);
	coroutine_wrap_ret2();
end
function UseAnimation(_) -- Line: 52
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = u2
	--]]
	if not u1 or not u1.PrimaryPart then return end
	m_Library.Audio.Play(12371276046, u1:GetPrimaryPartCFrame().p, 1, 0.75, 400);
	local v2, v3 = m_Library.Functions.CreateParticleHost(u1:GetPrimaryPartCFrame().p);
	local Children = m_Library.Assets.Particles:FindFirstChild("Huge Machine"):GetChildren();
	for _, val1 in ipairs(Children) do
		local Clone_ret = val1:Clone();
		Clone_ret.Parent = v3;
		Clone_ret:Emit(50);
	end
	m_Library.Functions.AddDebris(v2, 4);
	local Pumps = u1:FindFirstChild("Pumps");
	if Pumps then
		u2 = u2 + 1;
		for _, child2 in pairs(Pumps:GetChildren()) do
			local Attachment2 = child2:FindFirstChild("Attachment");
			local Smoke2 = Attachment2:FindFirstChild("Smoke");
			Smoke2.Speed = NumberRange.new(15, 20);
			Smoke2.Rate = 10;
		end
		task.delay(2, function() -- Line: 84
			--[[
				Upvalues:
					[1] = u2
					[2] = Pumps
			--]]
			u2 = u2 - 1;
			if u2 <= 0 then
				for _, child3 in pairs(Pumps:GetChildren()) do
					local Attachment = child3:FindFirstChild("Attachment");
					local Smoke = Attachment:FindFirstChild("Smoke");
					Smoke.Speed = NumberRange.new(3, 5);
					Smoke.Rate = 3;
				end
			end
		end);
	end
end
function Check() -- Line: 102
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Huge Machine");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 118
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);
m_Library.Network.Fired("Using Huge Machine"):Connect(function(_, p1) -- Line: 126
	UseAnimation(p1);
end);
