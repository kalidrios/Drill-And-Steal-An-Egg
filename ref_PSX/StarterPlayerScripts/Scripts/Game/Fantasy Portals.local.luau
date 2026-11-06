-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local table1 = {};
local u1 = nil;
local bool1 = false;
local bool2 = false;
function Teleport(p1) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Attribute = p1:GetAttribute("Area");
	local _ = m_Library.WorldCmds.GetMap();
	local FindFirstChild_ret = m_Library.WorldCmds.GetMap().Teleports:FindFirstChild(Attribute);
	if FindFirstChild_ret then
		local v4 = m_Library.Player.Character();
		local v5 = m_Library.Player.Humanoid();
		m_Library.GUIFX.Flash(0.25, 0.75, p1.PrimaryPart.Color);
		m_Library.Variables.Teleporting = true;
		m_Library.Signal.Fire("Teleporting");
		m_Library.Functions.Wait(0.25);
		v4:SetPrimaryPartCFrame(FindFirstChild_ret.CFrame + Vector3.new(0, v5.HipHeight + 1, 0));
		m_Library.Audio.Play("rbxassetid://7210953148", script, 1, 1);
		m_Library.Network.Fire("Performed Teleport", Attribute);
		m_Library.Functions.Wait(0.25);
		m_Library.Variables.Teleporting = false;
		return;
	end
	m_Library.Message.New("Something went wrong. Try again!");
end
function UpdatePortal(p2) -- Line: 43
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Attribute2 = p2:GetAttribute("Area");
	local v1 = Attribute2 and m_Library.WorldCmds.HasArea(Attribute2);
	local v2 = p2:GetAttribute("Unlocked") or false;
	p2:SetAttribute("Unlocked", v1);
	local t_PrimaryPart = p2.PrimaryPart;
	local ParticleEmitter = p2.PrimaryPart:FindFirstChildOfClass("ParticleEmitter");
	local SurfaceLight = t_PrimaryPart:FindFirstChildOfClass("SurfaceLight");
	ParticleEmitter.Enabled = v1;
	SurfaceLight.Enabled = v1;
	if v1 then
		if not v2 then
			t_PrimaryPart.Transparency = 1;
			ParticleEmitter:Emit(20);
			m_Library.Functions.Tween(t_PrimaryPart, {Transparency = 0.35}, {
				1,
				"Expo",
				"Out"
			});
			m_Library.Audio.Play("rbxassetid://7210953203", t_PrimaryPart, 1, 1, 325);
			m_Library.Audio.Play("rbxassetid://7210953181", t_PrimaryPart, 1, 0.2, 65, nil, true);
		end
	else
		t_PrimaryPart.Transparency = 1;
	end
end
function Interact(p3) -- Line: 70
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Attribute3 = p3:GetAttribute("Area");
	local v3 = m_Library.Directory.Areas[Attribute3];
	local Attribute4 = p3:GetAttribute("Unlocked");
	if not Attribute4 then
		local v6 = m_Library.Message.New("Buy this area for " .. m_Library.Functions.Commas(v3.gate.cost) .. " " .. v3.gate.currency .. "?", true);
		if v6 then
			local v9, v10 = m_Library.Network.Invoke("Buy Area", Attribute3);
			if not v9 then
				m_Library.Message.New(v10 or "Error");
			end
		end
	else
		Teleport(p3);
	end
end
function Setup(p4) -- Line: 92
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = bool2
	--]]
	for _, val1 in ipairs(p4) do
		local Attribute5 = val1:GetAttribute("Area");
		local bool3 = true;
		if not Attribute5 or Attribute5 == "" then
			bool3 = false;
		end
		UpdatePortal(val1);
		if not bool3 then continue end
		local v7, v8 = m_Library.Interact.Add(val1.PrimaryPart, {dist = 10});
		table.insert(table1, v8);
		v7:Connect(function() -- Line: 106
			--[[
				Upvalues:
					[1] = bool2
					[2] = val1
			--]]
			if not bool2 then
				bool2 = true;
				Interact(val1);
				bool2 = false;
			end
		end);
	end
end
function Check() -- Line: 118
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Portals");
		if u1 then
			Setup(u1:GetChildren());
		end
	end
end
function Clean() -- Line: 130
	--[[
		Upvalues:
			[1] = table1
			[2] = u1
	--]]
	for _, val2 in pairs(table1) do
		val2();
	end
	table1 = {};
	u1 = nil;
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 142
	--[[
		Upvalues:
			[1] = bool1
	--]]
	bool1 = false;
	Clean();
	Check();
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p5) -- Line: 149
	--[[
		Upvalues:
			[1] = u1
	--]]
	if (p5 == "AreasUnlocked" or p5 == "Hardcore") and u1 then
		for _, child3 in ipairs(u1:GetChildren()) do
			UpdatePortal(child3);
		end
	end
end);
