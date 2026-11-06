-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_IsHardcore = m_Library.Shared.IsHardcore;
v10 = game.JobId
local bool1 = false;
local u1 = {};
local table1 = {};
function GetAreaData() -- Line: 20
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	u1 = m_Library.Network.Invoke("Diamond Mine: Get Data");
end
function PromptGate(p1) -- Line: 25
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
	--]]
	local t_Name = p1.Name;
	local v1 = u1[t_Name];
	if v1 then
		if string.find(v1, "Huge Pet") then
			m_Library.Signal.Fire("Open Release Pet", t_Name, p1);
			return;
		end
		m_Library.Message.New(v1);
		return;
	end
	m_Library.Signal.Fire("Attempt Buy Gate", p1);
end
function Setup() -- Line: 42
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
			[3] = table1
			[4] = u1
			[5] = bool1
	--]]
	local v2 = m_Library.Save.Get();
	if not v2 then return end
	local Map = m_Library.WorldCmds.GetMap();
	local Gates = Map:FindFirstChild("Gates");
	local v3 = t_IsHardcore and v2.Hardcore.AreasUnlocked or v2.AreasUnlocked;
	for _, val1 in ipairs(table1) do
		val1();
	end
	table1 = {};
	if Gates then
		for _, child2 in pairs(Gates:GetChildren()) do
			local BasePart = child2:FindFirstChildWhichIsA("BasePart");
			local v6 = BasePart and BasePart:FindFirstChild("DiamondMineHUD");
			local t_Name2 = child2.Name;
			local v7 = m_Library.Directory.Areas[t_Name2];
			local Attribute = child2:GetAttribute("RequiredArea");
			if Attribute and not m_Library.Functions.SearchArray(v3, Attribute) then
				BasePart:FindFirstChild("DiamondMineHUD").Enabled = true;
				v6.Task.Text = "Requires " .. Attribute;
				if not BasePart:FindFirstChild("DiamondMinePurchaseHUD") then continue end
				BasePart:FindFirstChild("DiamondMinePurchaseHUD").Enabled = false;
				continue;
			end
			local v8 = u1[t_Name2];
			if v8 then
				v6.Task.Text = v8;
				BasePart:FindFirstChild("DiamondMineHUD").Enabled = true;
				if BasePart:FindFirstChild("DiamondMinePurchaseHUD") then
					BasePart:FindFirstChild("DiamondMinePurchaseHUD").Enabled = false;
				end
				if not string.find(v8, "Huge Pet") then continue end
			else
				if BasePart:FindFirstChild("DiamondMineHUD") then
					BasePart:FindFirstChild("DiamondMineHUD").Enabled = false;
				end
				if BasePart:FindFirstChild("DiamondMinePurchaseHUD") then
					BasePart:FindFirstChild("DiamondMinePurchaseHUD").Enabled = true;
				end
				if not BasePart:FindFirstChild("DiamondMinePurchaseHUD") then
					local Clone_ret = m_Library.Assets.Billboards.DiamondMinePurchaseHUD:Clone();
					Clone_ret.Req.Cost.Text = m_Library.Functions.NumberShorten(v7.gate.cost, false);
					local v11 = m_Library.Directory.Currency[v7.gate.currency];
					Clone_ret.Req.Currency.Image = v11.ImageOutline;
					v11.Gradient:Clone().Parent = Clone_ret.Req.Cost;
					Clone_ret.Parent = BasePart;
				end
			end
			local v9, v10 = m_Library.Interact.Add(BasePart.CFrame.p - Vector3.new(0, BasePart.Size.Y / 3, 0), {
				label = "Buy Area",
				dist = 40
			});
			v9:Connect(function() -- Line: 110
				--[[
					Upvalues:
						[1] = bool1
						[2] = child2
				--]]
				if not bool1 then
					bool1 = true;
					PromptGate(child2);
					bool1 = false;
				end
			end);
			table.insert(table1, v10);
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p2) -- Line: 127
	if p2 == "Diamond Mine" then
		Setup();
		GetAreaData();
		Setup();
	end
end);
m_Library.Signal.Fired("Gate Unlocked"):Connect(function(_) -- Line: 136
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_IsHardcore
	--]]
	local v4 = m_Library.Save.Get();
	if not v4 then return end
	if t_IsHardcore and v4.Hardcore.World == "Diamond Mine" or v4.World == "Diamond Mine" then
		Setup();
	end
end);
m_Library.Network.Fired("Diamond Mine: Area Data"):Connect(function(p3) -- Line: 148
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = t_IsHardcore
	--]]
	u1 = p3;
	local v5 = m_Library.Save.Get();
	if not v5 then return end
	if t_IsHardcore and v5.Hardcore.World == "Diamond Mine" or v5.World == "Diamond Mine" then
		Setup();
	end
end);
local v187 = 0
m_Library.Network.Fired("Diamond Mine: Kick"):Connect(function()
	if 60 >= workspace:GetServerTimeNow() - v187 then
		return 
	end
	local v196 = m_Library.Save.Get()
	if v196 then
		v196.DiamondMineData.Earned = m_Library.Settings.DiamondMineMaxEarn
	end
	v187 = workspace:GetServerTimeNow()
	task.delay(2, function()
		m_Library.Signal.Fire("Notification", "Diamond Mine has collapsed for the day!", {
			color = Color3.fromRGB(255, 46, 46)
		})
		m_Library.ChatMsg.New("Diamond Mine has collapsed for the day!", Color3.fromRGB(255, 46, 46))
	end)
end)	
m_Library.Signal.Invoked("Get Diamond Mine Collpase Time").OnInvoke = function()
	local v237 = m_Library.Save.Get()
	if not v237 then
		return 
	end
	local v256 = v237.DiamondMineData
	if math.floor((workspace:GetServerTimeNow() - 14400) / 86400) == v256.LastDay then
		if v256.Earned >= m_Library.Settings.DiamondMineMaxEarn then
			local v245 = os.date("!*t", workspace:GetServerTimeNow() - 14400)
			return 86400 - (v245.hour) * 3600 + (v245.min) * 60 + v245.sec
		end
	end
	if v10 ~= v256.JobId then
		local v245 = workspace:GetServerTimeNow() - v256.LastDiamondMineTeleport
		if m_Library.Settings.DiamondMineCooldown >= v245 then
			return m_Library.Settings.DiamondMineCooldown - v245
		end
	end
	return nil
end
GetAreaData();
