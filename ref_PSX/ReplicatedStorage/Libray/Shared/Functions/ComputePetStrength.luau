-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").Pets);
local m_Variables = require(script.Parent.Parent.Variables);
return function(p1) -- Line: 12
	--[[
		Upvalues:
			[1] = m_Variables
	--]]
	local v1 = p1.s or 0;
	if p1.hc then
		if m_Variables.IsHardcore then
			v1 = v1 * m_Variables.HardcorePetMult;
		else
			local v3 = v1 * m_Variables.HardcorePetMultNormal;
			v1 = math.max(v3, m_Variables.HardcorePetMinPowerNormal);
		end
	end
	local math_round_ret = math.round(v1);
	local v2 = math.max(math_round_ret, 0);
	if v2 ~= v2 or v2 == math.huge then
		v2 = 0;
	end
	return v2;
end;
