-- https://github.com/kalidrios

local _ = require(script.Parent.Parent.Variables);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
local _ = require(Modules.Pets);
local _ = require(Modules.DefaultStats);
local m_HasPetEquipped = require(script.Parent.HasPetEquipped);
local m_PetOrderBest = require(script.Parent.PetOrderBest);
return function(p1, p2, p3, p4, p5, p6, p7, p8)  
	local v1 = m_Directory.Pets[p2.id];
	local v2 = m_Directory.Pets[p3.id];
	local v3 = v1.titanic == true;
	if v2.titanic == true ~= v3 then
		if v3 then
			return -1;
		end
		return 1;
	end
	if p1 and not p4 then
		local v5 = m_HasPetEquipped(p1, p2);
		if m_HasPetEquipped(p1, p3) ~= v5 then
			if v5 then
				return -1;
			end
			return 1;
		end
	end
	local v4 = v1.isGift == true;
	if v2.isGift == true ~= v4 then
		if v4 then
			return -1;
		end
		return 1;
	end
	if p5 == nil then
		p5 = true
	end
	return m_PetOrderBest(p2, p3, p5, p6, p7, p8);
end;
