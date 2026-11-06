-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
local m_FFlags = nil;
if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService");
	m_FFlags = require(ServerScriptService:WaitForChild("Library").FFlags);
end
local m_ValidateDistanceGeneric = require(script.Parent.ValidateDistanceGeneric);
return function(p1, p2, p3) -- Line: 15
	--[[
		Upvalues:
			[1] = m_FFlags
			[2] = m_ValidateDistanceGeneric
	--]]
	if not m_FFlags.Get(m_FFlags.Keys.DistanceChecksEgg) then
		return true;
	end
	return m_ValidateDistanceGeneric(p1, p3, function(p4) -- Line: 21
		--[[
			Upvalues:
				[1] = p2
		--]]
		local Eggs = p4:FindFirstChild("Eggs");
		if not Eggs then
			return nil;
		end
		for _, child1 in ipairs(Eggs:GetChildren()) do
			local Eggs2 = child1:FindFirstChild("Eggs");
			if not Eggs2 then continue end
			for _, child2 in ipairs(Eggs2:GetChildren()) do
				if child2:GetAttribute("ID") ~= p2 or not child2:IsA("PVInstance") then continue end
				return child2;
			end
		end
		return nil;
	end);
end;
