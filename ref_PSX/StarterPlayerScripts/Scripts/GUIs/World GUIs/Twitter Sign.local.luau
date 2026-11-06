-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Player.PlayerGui();
local bool1 = false;
local table1 = {};
function UpdateSign(p1) -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	local t_IsFollowingOnTwitter = v1.IsFollowingOnTwitter;
	p1.Verified.Visible = t_IsFollowingOnTwitter;
	p1.Verify.Visible = not t_IsFollowingOnTwitter;
end
function LoadSign(p2) -- Line: 31
	--[[
		Upvalues:
			[1] = u1
			[2] = table1
			[3] = m_Library
			[4] = bool1
	--]]
	local t_PrimaryPart = p2.PrimaryPart;
	if not t_PrimaryPart then return end
	local SurfaceGui = t_PrimaryPart:FindFirstChildOfClass("SurfaceGui");
	if not SurfaceGui then return end
	SurfaceGui.Parent = u1;
	SurfaceGui.Adornee = t_PrimaryPart;
	table.insert(table1, SurfaceGui);
	UpdateSign(SurfaceGui);
	m_Library.GUIFX.ButtonFX(SurfaceGui.Verify);
	SurfaceGui.Verify.Activated:Connect(function() -- Line: 48
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
		--]]
		if not bool1 then
			bool1 = true;
			m_Library.GUI.VerifyTwitter.Gui.Enabled = true;
			bool1 = false;
		end
	end);
end
function LoadWorld() -- Line: 58
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	for _, val1 in ipairs(table1) do
		val1:Destroy();
	end
	table1 = {};
	local Map = m_Library.WorldCmds.GetMap();
	local Interactive = Map:FindFirstChild("Interactive");
	if Interactive then
		for _, child2 in ipairs(Interactive:GetChildren()) do
			if child2.Name ~= "Twitter Sign" then continue end
			LoadSign(child2);
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 79
	LoadWorld();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 84
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p3 == "IsFollowingOnTwitter" then
		for _, val3 in ipairs(table1) do
			UpdateSign(val3);
		end
	end
end);
