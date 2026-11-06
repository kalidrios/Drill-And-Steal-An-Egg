-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local m_Daycare = require(Library:WaitForChild("Modules").Daycare);
return function(p1) -- Line: 10
	--[[
		Upvalues:
			[1] = m_Daycare
	--]]
	local v1 = m_Daycare.SLOTS_FREE;
	for index1 = 1, p1 do
		v1 = v1 + m_Daycare.SLOT_TIERS[index1].Amount;
	end
	return v1;
end;
