-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local table1 = {};
local table2 = {};
local tick_ret = tick();
local u1 = nil;
local function weldBalloons() -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = table2
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	local Balloons = Map:FindFirstChild("Interactive"):FindFirstChild("Balloons");
	if not Balloons then return end
	for _, child1 in ipairs(Balloons:GetChildren()) do
		local WeldConstraint = Instance.new("WeldConstraint");
		WeldConstraint.Part0 = child1.Balloon;
		WeldConstraint.Part1 = child1.Part;
		WeldConstraint.Parent = child1.Balloon;
		table1[child1] = child1.Balloon.CFrame;
		table2[child1] = {
			XZ = math.random() * 2 * math.pi,
			Y = math.random() * 2 * math.pi
		};
		child1.Balloon.Anchored = false;
	end
end
function Animations() -- Line: 42
	--[[
		Upvalues:
			[1] = weldBalloons
			[2] = u1
			[3] = m_Library
			[4] = tick_ret
			[5] = table1
			[6] = table2
	--]]
	weldBalloons();
	local UserGameSettings = UserSettings():GetService("UserGameSettings");
	u1 = m_Library.Services.RunService.RenderStepped:Connect(function() -- Line: 46
		--[[
			Upvalues:
				[1] = UserGameSettings
				[2] = tick_ret
				[3] = table1
				[4] = table2
		--]]
		local t_SavedQualityLevel = UserGameSettings.SavedQualityLevel;
		if t_SavedQualityLevel ~= Enum.SavedQualitySetting.QualityLevel10 and t_SavedQualityLevel ~= Enum.SavedQualitySetting.QualityLevel9 and t_SavedQualityLevel ~= Enum.SavedQualitySetting.QualityLevel8 then return end
		local v1 = tick() - tick_ret;
		local _ = {};
		local _ = {};
		for key2, val2 in pairs(table1) do
			local v2 = val2 * CFrame.new(math.sin(v1 + table2[key2].XZ) * 1, math.sin(v1 + table2[key2].Y) * 0.5, math.cos(v1 + table2[key2].XZ) * 1);
			if not key2:FindFirstChild("Balloon") then continue end
			key2.Balloon.CFrame = v2;
		end
	end);
end
function Clean() -- Line: 72
	--[[
		Upvalues:
			[1] = table2
			[2] = table1
			[3] = u1
	--]]
	table2 = {};
	table1 = {};
	if u1 then
		u1:Disconnect();
		u1 = nil;
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 82
	Clean();
	if p1 == "Spawn" then
		Animations();
	end
end);
