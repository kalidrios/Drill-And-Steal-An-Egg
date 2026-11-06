-- https://github.com/kalidrios

local m_Variables = require(script.Parent.Parent.Variables);
local RunService = game:GetService("RunService");
local m_Saving = nil;
if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService");
	local Library = ServerScriptService:WaitForChild("Library");
	local _ = require(Library.FFlags);
	m_Saving = require(Library.Saving);
end
return function(p1, p2, p3) -- Line: 17
	--[[
		Upvalues:
			[1] = m_Saving
			[2] = m_Variables
	--]]
	assert(typeof(p1) == "Instance" and p1:IsA("Player") or false);
	assert(typeof(p3) == "function");
	assert(p2 == nil and true or typeof(p2) == "number");
	local t_Character = p1.Character;
	if not t_Character then
		return false;
	end
	assert(t_Character);
	if not t_Character.PrimaryPart then
		return false;
	end
	local t_Position = t_Character:GetPivot().Position;
	local Safe = m_Saving.Get(p1) --m_Saving.GetSafe(p1);
	if not Safe then
		return false;
	end
	assert(Safe);
	local v1 = m_Variables.IsHardcore and Safe.Hardcore.World or Safe.World;
	if not v1 then
		return false;
	end
	local __WORLDS = game.ServerStorage:WaitForChild("__WORLDS");
	if not __WORLDS then
		return false;
	end
	local FindFirstChild_ret = __WORLDS:FindFirstChild(v1);
	if not FindFirstChild_ret then
		return false;
	end
	local MAP = FindFirstChild_ret:FindFirstChild("MAP");
	if not MAP then
		return false;
	end
	local v2 = p3(MAP);
	if not v2 then
		return false;
	end
	assert(v2);
	local t_Position2;
	if v2:IsA("Model") then
		if not v2.PrimaryPart then
			warn("[ValidateDistanceGeneric] No PrimaryPart on ", v1, v2.Name);
			return false;
		end
		t_Position2 = v2:GetPivot().Position;
	else
		if not v2:IsA("BasePart") then
			return false;
		end
		t_Position2 = v2:GetPivot().Position;
	end
	if (p2 or 100) < (t_Position - t_Position2).Magnitude then
		return false;
	end
	return true;
end;
