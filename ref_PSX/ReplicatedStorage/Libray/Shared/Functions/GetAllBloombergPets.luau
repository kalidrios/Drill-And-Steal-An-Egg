--[[
    @ Velvet Group's - localkalidrios
--]]

-- | top | --
local BloombergPets = {}

-- | load library | --
local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")

-- | shared modules | --
local Directory = require(Library.Directory)

return function()
	if BloombergPets then
		return BloombergPets
	end
	
	for petId, petData in pairs(Directory.Pets) do
		--[[if not petData.hidden then
			if not petData.huge then
				if not petData.titanic then
					if petData.companionEnchantLevel then
						if 0 < petData.companionEnchantLevel then
						end
					end
				end
			end
		end]]--
		
		if not petData.hidden then
			table.insert(BloombergPets, {petId = petId, id = petId, uid = "id00000000000000000000000000000000", idt = 0, s = 0})
		end	
	end
	
	return BloombergPets
end