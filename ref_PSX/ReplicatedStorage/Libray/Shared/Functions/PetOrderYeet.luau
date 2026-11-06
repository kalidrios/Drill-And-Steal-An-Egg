-- its june and i making a game instead study for my entrance exame
local v6 = require(script.Parent.Parent.Variables)
local v9 = (game:GetService("ReplicatedStorage")):WaitForChild("Library")
local v12 = v9:WaitForChild("Modules")
local v15 = require(v9.Directory)
local v18 = require(v12.Pets)
local v21 = require(v12.DefaultStats)
local v26 = require(script.Parent.HasPetEquipped)
local v29 = require(script.Parent.PetOrderBest)
local v32 = require(script.Parent.GetYeetPower)
return function(p1, p2, p3, p4, p5, p6, p7, p8)
	local v43 = v15.Pets[p2.id].yeetPower ~= nil
	if v43 ~= v15.Pets[p3.id].yeetPower ~= nil then
		if v43 then
			return -1
		end
		return 1
	end
	return v32(p3) - v32(p2)
end
