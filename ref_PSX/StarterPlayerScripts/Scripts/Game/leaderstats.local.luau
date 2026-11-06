-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage.Library);
m_Library.Load();
function updateLeaderstats(p1) -- Line: 6
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get(p1);
	local v2 = p1:FindFirstChild("leaderstats");
	if not v2 then
		local leaderstats = Instance.new("Folder");
		leaderstats.Name = "leaderstats";
		leaderstats.Parent = p1;
		v2 = leaderstats;
	end
	assert(v2);
	if m_Library.FFlags.Get(m_Library.FFlags.Keys.RAP) or m_Library.FFlags.CanBypass(m_Library.LocalPlayer) then
		local v4 = v2:FindFirstChild("RAP");
		if not v4 then
			local RAP2 = Instance.new("IntValue");
			RAP2.Name = "RAP";
			RAP2.Value = 0;
			RAP2.Parent = v2;
			v4 = RAP2;
		end
		assert(v4);
		if v1 then
			v4.Value = v1.RAP or 0;
		end
	else
		local RAP = v2:FindFirstChild("RAP");
		if RAP then
			RAP:Destroy();
		end
	end
	local v3 = v2:FindFirstChild("Diamonds");
	if not v3 then
		local Diamonds = Instance.new("IntValue");
		Diamonds.Name = "Diamonds";
		Diamonds.Value = 0;
		Diamonds.Parent = v2;
		v3 = Diamonds;
	end
	assert(v3);
	if v1 then
		v3.Value = v1.Diamonds or 0;
	end
end
function updateAllLeaderstats() -- Line: 54
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	for _, val1 in ipairs(m_Library.Players:GetPlayers()) do
		updateLeaderstats(val1);
	end
end
task.spawn(function() -- Line: 60
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	while true do
		m_Library.Functions.wcall(updateAllLeaderstats);
		task.wait(math.random() * 10 + 5);
	end
end);
m_Library.Signal.Fired("Loaded Stats"):Connect(function() -- Line: 67
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	updateLeaderstats(m_Library.Players.LocalPlayer);
end);
m_Library.Signal.Fired("Loaded Other Stats"):Connect(function(p2) -- Line: 71
	updateLeaderstats(p2);
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 75
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if p3 == "Diamonds" or p3 == "RAP" then
		updateLeaderstats(m_Library.Players.LocalPlayer);
	end
end);
m_Library.Signal.Fired("Other Stat Changed"):Connect(function(p4, p5) -- Line: 81
	if p5 == "Diamonds" or p5 == "RAP" then
		updateLeaderstats(p4);
	end
end);
