-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local bool1 = false;
local table1 = {};
function Animation(p1, p2) -- Line: 18
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Part = Instance.new("Part");
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.Transparency = 1;
	Part.Size = p1;
	Part.CFrame = p2;
	Part.Parent = m_Library.Debris;
	m_Library.Audio.Play("rbxassetid://6980742890", Part, 1, 1.25, 500);
	local Clone_ret = m_Library.Assets.Particles:FindFirstChild("Gate Unlock"):Clone();
	Clone_ret.Parent = Part;
	Clone_ret:Emit(100);
	m_Library.Functions.AddDebris(Part, 10);
end
function BuyGate(p3) -- Line: 37
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_Name = p3.Name;
	local v1 = m_Library.Directory.Areas[t_Name];
	local v2 = m_Library.Message.New("Are you sure you want to buy this area for " .. m_Library.Functions.Commas(v1.gate.cost) .. " " .. v1.gate.currency .. "?", true);
	if not v2 then return end
	local BasePart = p3:FindFirstChildWhichIsA("BasePart");
	local t_Size = BasePart.Size;
	local t_CFrame = BasePart.CFrame;
	local v3, v4 = m_Library.Network.Invoke("Buy Area", t_Name);
	if not v3 then
		m_Library.Message.New(v4 or "Error");
		return;
	end
	Animation(t_Size, t_CFrame);
end
function SetupGate(p4) -- Line: 58
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = bool1
	--]]
	local v5 = m_Library.Directory.Areas[p4.Name];
	local BasePart2 = p4:FindFirstChildWhichIsA("BasePart");
	local u1 = v5 and not v5.hideGatePurchase and v5.gate;
	local u2 = nil;
	if u1 then
		local Clone_ret2 = m_Library.Assets.Billboards.GateHUD:Clone();
		if v5.gate.cost >= 1000000 then
			Clone_ret2.Req.Cost.Text = m_Library.Functions.NumberShorten(v5.gate.cost, false);
		else
			Clone_ret2.Req.Cost.Text = m_Library.Functions.Commas(v5.gate.cost);
		end
		local Dir = m_Library.WorldCmds.GetDir();
		if Dir and Dir.display == "Doodle World" then
			Clone_ret2.TextLabel.Font = Enum.Font.IndieFlower;
		end
		local v6 = m_Library.Directory.Currency[v5.gate.currency];
		Clone_ret2.Req.Currency.Image = v6.ImageOutline;
		v6.Gradient:Clone().Parent = Clone_ret2.Req.Cost;
		Clone_ret2.Parent = BasePart2;
		local v7 = nil;
		v7, u2 = m_Library.Interact.Add(BasePart2.CFrame.p - Vector3.new(0, BasePart2.Size.Y / 3, 0), {
			label = "Buy Area",
			dist = 40
		});
		table.insert(table1, u2);
		v7:Connect(function() -- Line: 89
			--[[
				Upvalues:
					[1] = bool1
					[2] = p4
			--]]
			if not bool1 then
				bool1 = true;
				BuyGate(p4);
				bool1 = false;
			end
		end);
	end
	local Connect_ret = nil;
	local function UpdateGate() -- Line: 99
		--[[
			Upvalues:
				[1] = p4
				[2] = Connect_ret
				[3] = u1
				[4] = u2
		--]]
		if GateUnlocked(p4) then
			Connect_ret:Disconnect();
			if u1 then
				u2();
			end
			RemoveGate(p4);
		end
	end
	Connect_ret = m_Library.Signal.Fired("Stat Changed"):Connect(function(p7) -- Line: 109
		--[[
			Upvalues:
				[1] = p4
				[2] = Connect_ret
				[3] = u1
				[4] = u2
		--]]
		if (p7 == "AreasUnlocked" or p7 == "Hardcore") and GateUnlocked(p4) then
			Connect_ret:Disconnect();
			if u1 then
				u2();
			end
			RemoveGate(p4);
		end
	end);
	if GateUnlocked(p4) then
		Connect_ret:Disconnect();
		if u1 then
			u2();
		end
		RemoveGate(p4);
	end
end
function RemoveGate(p5) -- Line: 119
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if p5.Name == "Cat Throne Room" or p5.Name == "Doodle Barn" or p5.Name == "Cozy Cove" or p5.Name == "Dog Club" then return end
	p5:Destroy();
	m_Library.Signal.Fire("Gate Unlocked", p5.Name);
end
function GateUnlocked(p6) -- Line: 129
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	return m_Library.WorldCmds.HasArea(p6.Name);
end
function LoadWorld() -- Line: 134
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
	--]]
	for _, val1 in ipairs(table1) do
		val1();
	end
	table1 = {};
	local Map = m_Library.WorldCmds.GetMap();
	local Gates = Map:WaitForChild("Gates");
	for _, child2 in ipairs(Gates:GetChildren()) do
		SetupGate(child2);
	end
	Gates.ChildAdded:Connect(function(child) -- Line: 145
		SetupGate(child);
	end);
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 155
	LoadWorld();
end);
m_Library.Signal.Fired("Attempt Buy Gate"):Connect(BuyGate);
