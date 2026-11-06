-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Player.PlayerGui();
local bool1 = false;
local table1 = {};
function LoadSign(p1) -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = table1
			[4] = bool1
	--]]
	local u2 = p1:GetAttribute("ProductID") ~= nil;
	local u3 = u2 and m_Library.Directory.Products[p1:GetAttribute("ProductID")].ID or m_Library.Directory.Gamepasses[p1:GetAttribute("GamepassID")].ID;
	local t_PrimaryPart = p1.PrimaryPart;
	if not t_PrimaryPart then return end
	local SurfaceGui = t_PrimaryPart:FindFirstChildOfClass("SurfaceGui");
	if not SurfaceGui or not SurfaceGui:FindFirstChild("Buy") or not SurfaceGui:FindFirstChild("Buy"):FindFirstChild("Cost") then return end
	SurfaceGui.Parent = u1;
	SurfaceGui.Adornee = t_PrimaryPart;
	table.insert(table1, SurfaceGui);
	local v1, v2 = m_Library.Functions.GetPrice(u3, u2);
	if not SurfaceGui or not SurfaceGui:FindFirstChild("Buy") or not SurfaceGui:FindFirstChild("Buy"):FindFirstChild("Cost") then return end
	SurfaceGui.Buy.Cost.Text = v2 and m_Library.Functions.Commas(v1) or "Offsale";
	m_Library.GUIFX.ButtonFX(SurfaceGui.Buy);
	SurfaceGui.Buy.Activated:Connect(function() -- Line: 43
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = u3
				[4] = u2
		--]]
		if not bool1 then
			bool1 = true;
			m_Library.Shared.PromptPurchase(u3, u2);
			bool1 = false;
		end
	end);
end
function LoadWorld() -- Line: 53
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
			if not child2:GetAttribute("GamepassID") and not child2:GetAttribute("ProductID") or child2.Name ~= "Sign" then continue end
			LoadSign(child2);
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 71
	LoadWorld();
end);
