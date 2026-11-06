-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local u1 = false;
function Setup()
	if u1 then
		return;
	end;
	u1 = true;
end;
local u2 = nil;
local u3 = 0;
function UseAnimation(p1)
	if u2 then
		if not u2.PrimaryPart then
			return;
		end;
	else
		return;
	end;
	v1.Audio.Play(12371276046, u2:GetPrimaryPartCFrame().p, 1, 0.75, 400);
	local v2, v3 = v1.Functions.CreateParticleHost(u2:GetPrimaryPartCFrame().p);
	for v4, v5 in ipairs((v1.Assets.Particles:FindFirstChild("Evolve Machine"):GetChildren())) do
		local v7 = v5:Clone();
		v7.Parent = v3;
		v7:Emit(50);	
	end;
	v1.Functions.AddDebris(v2, 4);
	local l__Pumps__8 = u2:FindFirstChild("Pumps");
	if l__Pumps__8 then
		u3 = u3 + 1;
		for v12, v13 in pairs(l__Pumps__8:GetChildren()) do
			local l__Smoke__14 = v13:FindFirstChild("Attachment"):FindFirstChild("Smoke");
			l__Smoke__14.Speed = NumberRange.new(15, 20);
			l__Smoke__14.Rate = 10;		
		end;
		task.delay(2, function()
			u3 = u3 - 1;
			if u3 <= 0 then
				for v18, v19 in pairs(l__Pumps__8:GetChildren()) do
					local l__Smoke__20 = v19:FindFirstChild("Attachment"):FindFirstChild("Smoke");
					l__Smoke__20.Speed = NumberRange.new(3, 5);
					l__Smoke__20.Rate = 3;				
				end;
			end;
		end);
	end;
end;
function Check()
	local v21 = v1.WorldCmds.GetMap();
	if v21:FindFirstChild("Interactive") then
		u2 = v21.Interactive:FindFirstChild("Evolve Machine");
		if u2 then

		else
			return;
		end;
	else
		return;
	end;
	Setup();
end;
v1.Signal.Fired("World Changed"):Connect(function()
	u1 = false;
	u2 = nil;
	Check();
end);
v1.Network.Fired("Using Evolve Machine"):Connect(function(p2, p3)
	UseAnimation(p3);
end);
