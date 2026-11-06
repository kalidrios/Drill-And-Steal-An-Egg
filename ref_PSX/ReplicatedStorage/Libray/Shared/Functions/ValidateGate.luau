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
	if not m_FFlags.Get(m_FFlags.Keys.DistanceChecksGate) then
		return true;
	end
	return m_ValidateDistanceGeneric(p1, p3, function(p4) -- Line: 21
		--[[
			Upvalues:
				[1] = p2
		--]]
		local Gates = p4:FindFirstChild("Gates");
		
		if Gates then
			local FindFirstChild_ret2 = Gates:FindFirstChild(p2);
			if FindFirstChild_ret2 then
				if FindFirstChild_ret2:IsA("PVInstance") then
					return FindFirstChild_ret2;
				end
				local Gate = FindFirstChild_ret2:FindFirstChild("Gate");
				if Gate and Gate:IsA("PVInstance") then
					return Gate;
				end
			end
		end
		
		local Interactive = p4:FindFirstChild("Interactive");
		if Interactive then
			local Portals = Interactive:FindFirstChild("Portals");
			if Portals then
				local FindFirstChild_ret = Portals:FindFirstChild(p2);
				if FindFirstChild_ret and FindFirstChild_ret:IsA("PVInstance") then
					return FindFirstChild_ret;
				end
			end
		end
		
		warn("[ValidateGate] Nothing found for:", p2);
		return nil;
	end);
end;
