-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Modules = Library:WaitForChild("Modules");
local m_Directory = require(Library.Directory);
local _ = require(Modules.Pets);
local m_PetTypeIndex = require(script.Parent.PetTypeIndex);
local m_ComputePetStrength = require(script.Parent.ComputePetStrength);
return function(p1, p2) -- Line: 15
	--[[
		Upvalues:
			[1] = m_Directory
			[2] = m_ComputePetStrength
			[3] = m_PetTypeIndex
	--]]
	local t_id = p1.id;
	local t_id2 = p2.id;
	local v1 = m_Directory.Pets[t_id];
	local v2 = m_Directory.Pets[t_id2];
	local v3 = v1.titanic == true;
	if v2.titanic == true ~= v3 then
		if v3 then
			return -1;
		end
		return 1;
	end
	local v4 = v1.huge == true;
	if v2.huge == true ~= v4 then
		if v4 then
			return 1;
		end
		return -1;
	end
	local v5 = v1.companionEnchantLevel or 0;
	local v6 = v2.companionEnchantLevel or 0;
	if v5 ~= v6 then
		return v6 - v5;
	end
	if not v3 and not v4 and v5 == 0 then
		local v9 = m_ComputePetStrength(p1);
		local v10 = m_ComputePetStrength(p2);
		if v9 ~= v10 then
			return v10 - v9;
		end
	end
	local v7 = m_PetTypeIndex(p1);
	local v8 = m_PetTypeIndex(p2);
	if v7 ~= v8 then
		return v8 - v7;
	end
	if t_id ~= t_id2 then
		if t_id2 < t_id then
			return -1;
		end
		return 1;
	end
	return (p1.idt or 0) - (p2.idt or 0);
end;
