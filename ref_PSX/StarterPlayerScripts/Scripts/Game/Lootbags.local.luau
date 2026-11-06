-- https://github.com/kalidrios

local table1 = {
	"rbxassetid://87569523388454",
	"rbxassetid://8049260930"
};
local table2 = {"rbxassetid://8049260324"};
local table3 = {
	"rbxassetid://8049260443",
	"rbxassetid://8049260584",
	"rbxassetid://8049260694"
};
local table4 = {
	"rbxassetid://8068357028",
	"rbxassetid://8068356928",
	"rbxassetid://8068357072"
};
local _ = {"rbxassetid://8068356980"};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Lootbags = m_Library.Assets.Models.Lootbags;
local t_Lootbags2 = m_Library.Things.Lootbags;
local Random_new_ret = Random.new();
local FindFirstChild_ret = m_Library.Assets.Particles:FindFirstChild("Lootbag Pickup");
function Add(p1, p2) -- Line: 79
	--[[
		Upvalues:
			[1] = t_Lootbags2
			[2] = m_Library
			[3] = t_Lootbags
			[4] = Random_new_ret
			[5] = table1
			[6] = table2
			[7] = table3
	--]]
	if t_Lootbags2:FindFirstChild(p1) then
		return m_Library.Print("Lootbag '" .. p1 .. "' already exists in world", true);
	end
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	if m_Library.WorldCmds.Get() ~= p2.world then
		return m_Library.Print("Lootbag '" .. p1 .. "' is in another world", true);
	end
	local v2 = m_Library.Directory.Lootbags[p2.type];
	local Clone_ret = t_Lootbags:FindFirstChild(v2.model):Clone();
	Clone_ret.CollisionGroup = "Lootbags";
	Clone_ret.Anchored = false;
	Clone_ret.CanCollide = true;
	Clone_ret.CFrame = CFrame.new(p2.position) + Vector3.new(0, 5, 0);
	Clone_ret.Name = p1;
	Clone_ret:SetAttribute("ID", p1);
	Clone_ret:SetAttribute("Collected", false);
	Clone_ret:SetAttribute("ReadyForCollection", false);
	if p2.disableMagnet then
		Clone_ret:SetAttribute("DisableMagnet", true);
	elseif p2.freeMagnet then
		Clone_ret:SetAttribute("FreeMagnet", true);
	end
	if p2.reward[1] == "Boost" then
		local v7 = p2.reward[2];
		local v8 = p2.reward[3];
		Clone_ret:SetAttribute("IsBoost", true);
		Clone_ret:SetAttribute("BoostAmount", v7);
		Clone_ret:SetAttribute("BoostType", v8);
	end
	local BodyGyro = Instance.new("BodyGyro");
	BodyGyro.Parent = Clone_ret;
	Clone_ret.Parent = t_Lootbags2;
	local v3 = p2.blastRadius or 1;
	Clone_ret.Velocity = Vector3.new(Random_new_ret:NextNumber(-30, 30) * v3, 90, Random_new_ret:NextNumber(-30, 30) * v3);
	m_Library.Audio.Play(table1, Clone_ret, Random_new_ret:NextNumber(0.95, 1.05), 1, 300);
	if v2.isRare then
		m_Library.Audio.Play(table2, Clone_ret, 1, 1.45, 350);
	end
	if p2.diamondBagMaster then
		m_Library.Audio.Play(table2, Clone_ret, Random_new_ret:NextNumber(1.5, 1.6), 0.8, 350);
		local Attachment = Instance.new("Attachment");
		for _, child3 in ipairs(m_Library.Assets:WaitForChild("Particles"):WaitForChild("Diamond Bag Upgrade"):GetChildren()) do
			child3:Clone().Parent = Attachment;
		end
		Attachment.Parent = Clone_ret;
	end
	m_Library.WorldFX.QuestGlow(Clone_ret, 1, 0.8);
	local Trail = Clone_ret:FindFirstChildOfClass("Trail");
	local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 146
		--[[
			Upvalues:
				[1] = m_Library
				[2] = Trail
		--]]
		m_Library.Functions.Wait(0.5);
		Trail.Enabled = false;
	end);
	coroutine_wrap_ret();
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 152
		--[[
			Upvalues:
				[1] = m_Library
				[2] = Clone_ret
				[3] = table3
				[4] = Random_new_ret
		--]]
		local function HitGround() -- Line: 153
			--[[
				Upvalues:
					[1] = m_Library
					[2] = Clone_ret
			--]]
			local Map = m_Library.WorldCmds.GetMap();
			local RaycastParams_new_ret = RaycastParams.new();
			RaycastParams_new_ret.FilterDescendantsInstances = {Map:FindFirstChild("Areas")};
			RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Whitelist;
			local Raycast_ret = game.Workspace:Raycast(Clone_ret.CFrame.Position, Vector3.new(0, -(Clone_ret.Size.Y / 2 + 1), 0), RaycastParams_new_ret);
			if Raycast_ret and Raycast_ret.Instance then
				return true;
			end
			return false;
		end
		local v10 = false;
		local os_clock_ret = os.clock();
		while Clone_ret and Clone_ret.Parent and not v10 do
			v10 = HitGround();
			if v10 or os.clock() - os_clock_ret >= 4 then
				v10 = true;
				m_Library.Audio.Play(table3, Clone_ret.CFrame.Position, Random_new_ret:NextNumber(0.95, 1.05), 0.4, 125);
				local BodyPosition = Instance.new("BodyPosition");
				BodyPosition.D = 50;
				BodyPosition.P = 0;
				BodyPosition.MaxForce = Vector3.new();
				BodyPosition.Parent = Clone_ret;
				Clone_ret:SetAttribute("ReadyForCollection", true);
			end
			m_Library.RenderStepped();
		end
	end);
	coroutine_wrap_ret2();
end
function Remove(p3) -- Line: 185
	--[[
		Upvalues:
			[1] = t_Lootbags2
	--]]
	local FindFirstChild_ret2 = t_Lootbags2:FindFirstChild(p3);
	if FindFirstChild_ret2 then
		FindFirstChild_ret2:Destroy();
	end
end
function Collect(p4) -- Line: 196
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table4
			[3] = Random_new_ret
			[4] = FindFirstChild_ret
	--]]
	p4:SetAttribute("Collected", true);
	local Attribute = p4:GetAttribute("ID");
	local Attribute2 = p4:GetAttribute("IsBoost");
	local t_p = p4.CFrame.p;
	m_Library.Audio.Play(table4, p4.CFrame.Position, Random_new_ret:NextNumber(0.95, 1.05), 0.8, 250);
	local v4, v5 = m_Library.Functions.CreateParticleHost(t_p);
	for _, child1 in ipairs(FindFirstChild_ret:GetChildren()) do
		local Clone_ret2 = child1:Clone();
		Clone_ret2.Parent = v5;
		Clone_ret2:Emit(5);
	end
	m_Library.Functions.AddDebris(v4, 3);
	if Attribute2 then
		m_Library.Audio.Play("rbxassetid://8167299784", script, 1, 1);
		local Attribute3 = p4:GetAttribute("BoostType");
		local Attribute4 = p4:GetAttribute("BoostAmount");
		m_Library.Signal.Fire("Rewards Redeemed", {{
			Attribute3,
			Attribute4
		}});
	end
	m_Library.Network.Fire("Collect Lootbag", Attribute, t_p);
	p4:Destroy();
end
function ScanForCollection() -- Line: 227
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Lootbags2
	--]]
	local v6 = m_Library.Player.Humanoid();
	local u1 = m_Library.Player.UpperTorso();
	if not u1 or not v6 then return end
	local t_HipHeight = v6.HipHeight;
	local u2 = m_Library.Gamepasses.Owns(m_Library.Directory.Gamepasses.Magnet.ID);
	for key2, child2 in ipairs(t_Lootbags2:GetChildren()) do
		pcall(function() -- Line: 237
			--[[
				Upvalues:
					[1] = key2
					[2] = m_Library
					[3] = child2
					[4] = t_HipHeight
					[5] = u1
					[6] = u2
			--]]
			if key2 % 25 == 0 then
				m_Library.RenderStepped();
			end
			if child2:GetAttribute("ReadyForCollection") and not child2:GetAttribute("Collected") then
				local DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(child2.CFrame.p);
				local v11 = (child2.Size.X + child2.Size.Z) / 2;
				if DistanceFromCharacter_ret <= v11 + t_HipHeight + 1 then
					Collect(child2);
					return;
				end
				local BodyPosition2 = child2:FindFirstChildOfClass("BodyPosition");
				if BodyPosition2 then
					BodyPosition2.MaxForce = Vector3.new(BodyPosition2.P, BodyPosition2.P, BodyPosition2.P);
					BodyPosition2.Position = u1.Position + u1.CFrame.LookVector - Vector3.new(0, t_HipHeight, 0);
					local v12 = u2;
					if not v12 and child2:GetAttribute("FreeMagnet") then
						v12 = true;
					end
					if v12 and not child2:GetAttribute("DisableMagnet") then
						BodyPosition2.P = 17500;
						return;
					end
					BodyPosition2.P = 3500 - math.clamp(DistanceFromCharacter_ret / (v11 + 18), 0, 1) * 3500;
				end
			end
		end);
	end
end
local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 272
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	while true do
		ScanForCollection();
		m_Library.Heartbeat();
	end
end);
coroutine_wrap_ret3();
m_Library.Network.Fired("Spawn Lootbag"):Connect(function(p5, p6) -- Line: 283
	Add(p5, p6);
end);
m_Library.Network.Fired("Remove Lootbag"):Connect(function(p7) -- Line: 288
	Remove(p7);
end);
