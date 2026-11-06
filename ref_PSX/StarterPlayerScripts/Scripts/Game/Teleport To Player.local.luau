-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Players = game:GetService("Players");
local TeleportService = game:GetService("TeleportService");
function TeleporToPlayer(p1) -- Line: 10
	--[[
		Upvalues:
			[1] = Players
			[2] = m_Library
	--]]
	assert(typeof(p1) == "Instance" and p1:IsA("Player") or false);
	local t_LocalPlayer = Players.LocalPlayer;
	if not m_Library.WorldCmds.CanDoAction() then
		return false, "Cannot perform actions right now";
	end
	if not t_LocalPlayer or not t_LocalPlayer.Parent then
		return false, "Source player is not valid";
	end
	if not p1 or not p1.Parent then
		return false, "Destination player is not valid";
	end
	if t_LocalPlayer == p1 then
		return false, "Source and Destination player cannot be the same";
	end
	local v1 = m_Library.WorldCmds.Get(t_LocalPlayer);
	if not v1 then
		return false, "Source player was not in a world";
	end
	local v2 = m_Library.WorldCmds.Get(p1);
	if not v2 then
		return false, "Destination player was not in a world";
	end
	if not m_Library.WorldCmds.HasAccess(v2) then
		return false, "Source player does not have access to the Destination players' world";
	end
	local function teleport() -- Line: 37
		--[[
			Upvalues:
				[1] = m_Library
				[2] = t_LocalPlayer
				[3] = p1
		--]]
		if not m_Library.WorldCmds.CanDoAction() then
			return false, "Cannot perform actions right now";
		end
		if not t_LocalPlayer or not t_LocalPlayer.Parent then
			return false, "Source player is not valid";
		end
		if not p1 or not p1.Parent then
			return false, "Destination player is not valid";
		end
		local v4 = m_Library.WorldCmds.Get(t_LocalPlayer);
		if not v4 then
			return false, "Source player was not in a world";
		end
		local v5 = m_Library.WorldCmds.Get(p1);
		if not v5 then
			return false, "Destination player was not in a world";
		end
		if v4 ~= v5 then
			return false, "Source ande Destination player are not in the same world";
		end
		if not m_Library.WorldCmds.HasAccess(v5) then
			return false, "Source player does not have access to the Destination players' world";
		end
		local t_Character = t_LocalPlayer.Character;
		if not t_Character then
			return false, "Source player has no Character";
		end
		local t_PrimaryPart = t_Character.PrimaryPart;
		if not t_PrimaryPart then
			return false, "Source player has no PrimaryPart";
		end
		local Humanoid = t_Character:FindFirstChildOfClass("Humanoid");
		if not Humanoid then
			return false, "Source player has no Humanoid";
		end
		local t_Character2 = p1.Character;
		if not t_Character2 then
			return false, "Destination player has no Character";
		end
		local t_PrimaryPart2 = t_Character2.PrimaryPart;
		if not t_PrimaryPart2 then
			return false, "Destination player has no PrimaryPart";
		end
		local Humanoid2 = t_Character2:FindFirstChildOfClass("Humanoid");
		if not Humanoid2 then
			return false, "Destination player has no Humanoid";
		end
		local t_CFrame = t_PrimaryPart2.CFrame;
		local v6 = t_CFrame - t_CFrame.UpVector * (t_PrimaryPart2.Size.Y / 2 + Humanoid2.HipHeight);
		t_Character:PivotTo(v6 + v6.UpVector * (t_PrimaryPart.Size.Y / 2 + Humanoid.HipHeight));
		return true;
	end
	if v1 ~= v2 then
		m_Library.WorldCmds.Load(v2);
	end
	return teleport();
end
task.spawn(function() -- Line: 99
	--[[
		Upvalues:
			[1] = TeleportService
			[2] = Players
			[3] = m_Library
	--]]
	local LocalPlayerTeleportData = TeleportService:GetLocalPlayerTeleportData();
	if typeof(LocalPlayerTeleportData) == "table" then
		local t_TeleportToPlayer = LocalPlayerTeleportData.TeleportToPlayer;
		if typeof(t_TeleportToPlayer) == "number" then
			local PlayerByUserId = Players:GetPlayerByUserId(t_TeleportToPlayer);
			if PlayerByUserId then
				while not m_Library.WorldCmds.CanDoAction() do
					wait(0.1);
				end
				local TeleporToPlayer_ret1, TeleporToPlayer_ret2 = TeleporToPlayer(PlayerByUserId);
				if not TeleporToPlayer_ret1 then
					warn(string.format("Failed to teleport to player: %s", tostring(TeleporToPlayer_ret2)));
				end
			end
		end
	end
end);
m_Library.Network.Invoked("Teleport To Player").OnInvoke = TeleporToPlayer;
m_Library.Signal.Invoked("Teleport To Player").OnInvoke = TeleporToPlayer;
