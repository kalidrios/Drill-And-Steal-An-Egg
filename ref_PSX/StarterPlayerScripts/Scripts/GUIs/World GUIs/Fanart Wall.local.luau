-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local t_FanArt = m_Library.Shared.FanArt;
local u1 = nil;
local u2 = 0;
function Update() -- Line: 20
	--[[
		Upvalues:
			[1] = u1
			[2] = u2
			[3] = t_FanArt
			[4] = Random_new_ret
	--]]
	if not u1 then return end
	u2 = u2 + 1;
	local v1 = u2;
	local SurfaceGui = u1.Main:FindFirstChildOfClass("SurfaceGui");
	while v1 == u2 and u1 and SurfaceGui and SurfaceGui:FindFirstChild("ImageLabel") and SurfaceGui:FindFirstChild("TextLabel") do
		local v2 = t_FanArt[Random_new_ret:NextInteger(1, #t_FanArt)];
		SurfaceGui.ImageLabel.Image = v2[1];
		SurfaceGui.TextLabel.Text = "\240\159\150\140\239\184\143 @" .. v2[2];
		wait(15);
	end
end
function Check() -- Line: 43
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Fanart");
		if u1 then
			Update();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 59
	--[[
		Upvalues:
			[1] = u1
	--]]
	u1 = nil;
	--setup = false;
	Check();
end);
