-- its june and i making a game instead study for my entrance exame
local v6 = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local v12 = require(v6.Directory)
local v15 = require(v6:WaitForChild("Modules").Pets)
local v20 = require(script.Parent.CanAuctionPetDir)
return function(p1)
	local v23 = v12.Pets
	local v24 = v23[p1.id]
	if not v24 then
		v23 = false
		return v23
	end
	assert(v24)
	return v20(v24)
end
