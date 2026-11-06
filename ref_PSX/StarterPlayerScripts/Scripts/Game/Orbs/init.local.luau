-- https://github.com/kalidrios

local table1 = {
	"rbxassetid://6980747874",
	"rbxassetid://6980747719",
	"rbxassetid://6980747831",
	"rbxassetid://6980747761"
};
local table2 = {
	"rbxassetid://6422183746",
	"rbxassetid://6422183796",
	"rbxassetid://6422183836",
	"rbxassetid://6422183697"
};
local table3 = {
	"rbxassetid://7139322725",
	"rbxassetid://116895973336007",
	"rbxassetid://7139322637",
	"rbxassetid://7139322684"
};
local table4 = {
	"rbxassetid://6980747924",
	"rbxassetid://6980747977"
};
local table5 = {
	"rbxassetid://7805996163",
	"rbxassetid://7805996068"
};
local table6 = {
	"rbxassetid://7805995973",
	"rbxassetid://7805996231"
};
local table7 = {
	"rbxassetid://8269454300",
	"rbxassetid://8269454300"
};
local table8 = {
	"rbxassetid://8269454228",
	"rbxassetid://8269454359"
};
local table9 = {
	"rbxassetid://8269454300",
	"rbxassetid://8269454300"
};
local table10 = {
	"rbxassetid://8269454228",
	"rbxassetid://8269454359"
};
local table11 = {
	"rbxassetid://8269454300",
	"rbxassetid://8269454300"
};
local table12 = {
	"rbxassetid://8269454228",
	"rbxassetid://8269454359"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Orbs = m_Library.Things:FindFirstChild("Orbs");
local _ = game:GetService("Debris");
local Random_new_ret = Random.new();
local u1 = 12;
local table13 = {};
local table14 = {};
local u2 = 0;
local table15 = {};
local u3 = 0;
local u4 = false;
game:GetService("RunService").Heartbeat:Connect(function(p1) -- Line: 66
	--[[
		Upvalues:
			[1] = table15
			[2] = u3
			[3] = m_Library
	--]]
	if #table15 > 0 then
		u3 = u3 + p1;
		if u3 >= 0.25 then
			u3 = 0;
			local v16 = table15;
			table15 = {};
			m_Library.Network.Fire("Claim Orbs", v16);
		end
	end
end);
function Collect(p2) -- Line: 79
	--[[
		Upvalues:
			[1] = table13
			[2] = m_Library
			[3] = table15
	--]]
	debug.profilebegin("Orbs.Collect");
	local v1 = table13[p2];
	local t_type = v1.type;
	local t_amount = v1.amount;
	RemoveOrb(p2);
	m_Library.WorldFX.AddCurrency(m_Library.Player.UpperTorso().CFrame.p, t_amount, t_type, true);
	QueueOrbSound(t_type);
	for _, val1 in ipairs(v1.ids) do
		table.insert(table15, val1);
	end
	debug.profileend();
end
function AddOrb(p3, p4) -- Line: 101
	--[[
		Upvalues:
			[1] = Orbs
			[2] = u4
			[3] = u2
			[4] = table13
			[5] = m_Library
			[6] = Random_new_ret
			[7] = table1
	--]]
	debug.profilebegin("Orbs.AddOrb.task");
	local t_type2 = p4.type;
	local t_am = p4.am;
	local t_pos = p4.pos;
	local t_extra = p4.extra;
	if Orbs:FindFirstChild(p3) then
		debug.profileend();
		return;
	end
	local Part = Instance.new("Part");
	Part.Transparency = 1;
	Part.Size = Vector3.new(0.5, 0.5, 0.5);
	Part.CFrame = CFrame.new(t_pos);
	Part.Anchored = false;
	Part.Name = p3;
	Part.CanQuery = false;
	Part.CanTouch = false;
	if u4 then
		Part.CanCollide = false;
	else
		Part.CanCollide = true;
		Part.CollisionGroup = "Orbs";
	end
	local table16 = {
		type = t_type2,
		amount = t_am,
		ids = {p3},
		spawnTick = u2,
		lastCheck = u2,
		lastActivity = u2,
		lastCombineCheck = nil
	};
	if t_extra and t_extra.PickupDistance then
		table16.pickupDistance = t_extra.PickupDistance;
	end
	table13[Part] = table16;
	local Clone_ret = m_Library.Assets.Billboards.Orb:Clone();
	Clone_ret.Item.Image = m_Library.Directory.Currency[t_type2].ImageTiny;
	Clone_ret.Parent = Part;
	debug.profileend();
	task.delay(math.random() * 0.25, function() -- Line: 149
		--[[
			Upvalues:
				[1] = t_extra
				[2] = Part
				[3] = Random_new_ret
				[4] = m_Library
				[5] = table1
				[6] = Orbs
		--]]
		debug.profilebegin("Orbs.AddOrb.finish");
		local v15 = t_extra and (t_extra.BlastRadius or 1) or 1;
		Part.Velocity = Vector3.new(Random_new_ret:NextNumber(-20, 20) * v15, 50, Random_new_ret:NextNumber(-20, 20) * v15);
		Part.RotVelocity = Vector3.new(Random_new_ret:NextNumber(-20, 20) * v15, Random_new_ret:NextNumber(-20, 20) * v15, Random_new_ret:NextNumber(-20, 20) * v15);
		task.spawn(function() -- Line: 160
			--[[
				Upvalues:
					[1] = m_Library
					[2] = table1
					[3] = Part
					[4] = Random_new_ret
			--]]
			m_Library.Audio.Play(table1, Part, Random_new_ret:NextNumber(0.95, 1.05), 0.4, 125);
		end);
		local BodyPosition = Instance.new("BodyPosition");
		BodyPosition.D = 50;
		BodyPosition.P = 0;
		BodyPosition.MaxForce = Vector3.new();
		BodyPosition.Parent = Part;
		Part.Parent = Orbs;
		debug.profileend();
	end);
end
function RemoveOrb(p5) -- Line: 177
	--[[
		Upvalues:
			[1] = Orbs
			[2] = table13
			[3] = m_Library
	--]]
	debug.profilebegin("Orbs.RemoveOrb");
	local v2 = typeof(p5) == "Instance" and p5 or Orbs:FindFirstChild(p5);
	if v2 and table13[v2] then
		table13[v2] = nil;
		m_Library.Functions.AddDebris(v2, 0);
	end
	debug.profileend();
end
function QueueOrbSound(p6) -- Line: 198
	--[[
		Upvalues:
			[1] = table14
	--]]
	if not table14[p6] then
		table14[p6] = 1;
		return;
	end
	local v3 = table14;
	v3[p6] = v3[p6] + 1;
end
function PlaySounds() -- Line: 207
	--[[
		Upvalues:
			[1] = table14
			[2] = m_Library
			[3] = table6
			[4] = Random_new_ret
			[5] = table8
			[6] = table10
			[7] = table12
			[8] = table3
			[9] = table4
			[10] = table5
			[11] = table7
			[12] = table9
			[13] = table11
			[14] = table2
	--]]
	for key2, val2 in pairs(table14) do
		if val2 >= 8 then
			if key2 == "Halloween Candy" then
				m_Library.Audio.Play(table6, script, Random_new_ret:NextNumber(0.95, 1.05), 0.45);
				continue;
			end
			if key2 == "Gingerbread" then
				m_Library.Audio.Play(table8, script, Random_new_ret:NextNumber(1.3, 1.4), 0.325);
				continue;
			end
			if key2 == "Valentine Hearts" then
				m_Library.Audio.Play(table10, script, Random_new_ret:NextNumber(1.8, 2), 0.325);
				continue;
			end
			if key2 == "Clover Coins" then
				m_Library.Audio.Play(table12, script, Random_new_ret:NextNumber(1.8, 2), 0.325);
				continue;
			end
			m_Library.Audio.Play(table3, script, Random_new_ret:NextNumber(0.95, 1.05), 0.45);
			continue;
		end
		if key2 == "Diamonds" then
			m_Library.Audio.Play(table4, script, Random_new_ret:NextNumber(0.95, 1.05), 0.45);
			continue;
		end
		if key2 == "Halloween Candy" then
			m_Library.Audio.Play(table5, script, Random_new_ret:NextNumber(0.95, 1.05), 0.45);
			continue;
		end
		if key2 == "Gingerbread" then
			m_Library.Audio.Play(table7, script, Random_new_ret:NextNumber(1.3, 1.4), 0.325);
			continue;
		end
		if key2 == "Valentine Hearts" then
			m_Library.Audio.Play(table9, script, Random_new_ret:NextNumber(1.8, 2), 0.325);
			continue;
		end
		if key2 == "Clover Coins" then
			m_Library.Audio.Play(table11, script, Random_new_ret:NextNumber(1.8, 2), 0.325);
			continue;
		end
		m_Library.Audio.Play(table2, script, Random_new_ret:NextNumber(0.95, 1.05), 0.4);
	end
	table14 = {};
end
local u5 = 0;
game:GetService("RunService").Heartbeat:Connect(function(p7) -- Line: 242
	--[[
		Upvalues:
			[1] = u5
	--]]
	u5 = u5 + p7;
	if u5 < 1 / 30 then return end
	u5 = 0;
	PlaySounds();
end);
function Combine(p8, p9) -- Line: 255
	--[[
		Upvalues:
			[1] = table13
	--]]
	debug.profilebegin("Orbs.Combine");
	local v4 = table13[p8];
	local v5 = table13[p9];
	v5.amount = v5.amount + v4.amount;
	for _, val3 in pairs(v4.ids) do
		table.insert(v5.ids, val3);
	end
	RemoveOrb(p8);
	debug.profileend();
end
function TryToCombine(p10) -- Line: 273
	--[[
		Upvalues:
			[1] = table13
			[2] = Orbs
	--]]
	debug.profilebegin("Orbs.TryToCombine");
	if p10 then
		local v12 = table13[p10];
		if v12 then
			local t_Position = p10.CFrame.Position;
			local Children = Orbs:GetChildren();
			for _, val6 in ipairs(Children) do
				local v17 = table13[val6];
				if not v17 or val6 == p10 or v12.type ~= v17.type or (val6.CFrame.p - t_Position).Magnitude > 5 then continue end
				Combine(p10, val6);
				break;
			end
		end
	end
	debug.profileend();
end
function GetClosestEntity(p11, p12) -- Line: 301
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	debug.profilebegin("Orbs.GetClosestEntity");
	local v6 = m_Library.Player.PrimaryPart();
	local v7 = m_Library.LocalPlayer:DistanceFromCharacter(p11 + Vector3.new(0, 2, 0));
	local v8 = v6;
	for _, val4 in ipairs(p12) do
		if not m_Library.Shared.HasPower(val4, "Magnet") then continue end
		local t_uid = val4.uid;
		local FindFirstChild_ret = m_Library.Things.Pets:FindFirstChild(t_uid);
		if not FindFirstChild_ret then continue end
		local t_Magnitude = (FindFirstChild_ret.CFrame.p - p11).Magnitude;
		if t_Magnitude >= v7 then continue end
		v7 = t_Magnitude;
		v8 = FindFirstChild_ret;
	end
	debug.profileend();
	return v7, v8;
end
function OrbLoop(p13) -- Line: 326
	--[[
		Upvalues:
			[1] = u2
			[2] = m_Library
			[3] = Orbs
			[4] = table13
			[5] = u1
			[6] = Random_new_ret
	--]]
	debug.profilebegin("Orbs.OrbLoop");
	u2 = u2 + p13;
	local _ = m_Library.LocalPlayer;
	local v9 = m_Library.Player.PrimaryPart();
	if not v9 then
		debug.profileend();
		return;
	end
	local Equipped = m_Library.PetCmds.GetEquipped();
	local Children2 = Orbs:GetChildren();
	local v10 = #Children2;
	for _, val5 in ipairs(Children2) do
		if not val5 then continue end
		local v13 = table13[val5];
		if not v13 or u2 - v13.lastCheck < 0.33 then continue end
		local BodyPosition2 = val5:FindFirstChildOfClass("BodyPosition");
		if not BodyPosition2 then continue end
		local GetClosestEntity_ret1, GetClosestEntity_ret2 = GetClosestEntity(val5.CFrame.Position, Equipped);
		if not GetClosestEntity_ret2 then continue end
		v13.lastActivity = u2;
		local v14 = v13.pickupDistance and v13.pickupDistance or u1;
		BodyPosition2.P = 1250 - math.clamp(GetClosestEntity_ret1 / v14, 0, 1) * 1250;
		BodyPosition2.MaxForce = Vector3.new(BodyPosition2.P, BodyPosition2.P, BodyPosition2.P);
		BodyPosition2.Position = GetClosestEntity_ret2.Position + GetClosestEntity_ret2.CFrame.LookVector - Vector3.new(0, 2, 0);
		if v14 + 5 > GetClosestEntity_ret1 then
			if GetClosestEntity_ret1 > 4 then continue end
			Collect(val5);
			continue;
		end
		v13.lastCheck = u2;
		if Random_new_ret:NextNumber() < 0.03 then
			val5.Velocity = val5.Velocity + Vector3.new(0, 30, 0);
		end
		if u2 - v13.spawnTick < 1.5 or v10 < 150 or v13.lastCombineCheck and u2 - v13.lastCombineCheck < 5 then continue end
		v13.lastCombineCheck = u2;
		TryToCombine(val5);
	end
	debug.profileend();
end
game:GetService("RunService").Stepped:Connect(function(p14, p15) -- Line: 409
	OrbLoop(p15);
end);
function UpdatePickupDistance() -- Line: 417
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u4
			[3] = u1
	--]]
	debug.profilebegin("Orbs.UpdatePickupDistance");
	local v11 = m_Library.Save.Get();
	if v11 then
		u4 = m_Library.Gamepasses.Owns(m_Library.Directory.Gamepasses.Magnet.ID);
		if u4 then
			u1 = math.huge;
		else
			u1 = (v11.Upgrades["Orb Pickup Distance"] or 0) * 10 + 12;
		end
	end
	debug.profileend();
end
m_Library.Signal.Fired("Stat Changed"):Connect(function(p16) -- Line: 433
	if p16 == "Upgrades" or p16 == "Gamepasses" then
		UpdatePickupDistance();
	end
end);
UpdatePickupDistance();
m_Library.Network.Fired("Orb Added"):Connect(function(p17, p18) -- Line: 446
	AddOrb(p17, p18);
end);
m_Library.Network.Fired("Orb Removed"):Connect(function(p19) -- Line: 451
	RemoveOrb(p19);
end);
