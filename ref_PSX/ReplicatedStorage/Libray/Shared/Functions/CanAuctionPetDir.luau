-- its june and i making a game instead study for my entrance exame
local v6 = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local v12 = require(v6.Directory)
local v15 = require(v6:WaitForChild("Modules").Pets)
return function(p1)
	if not p1 then
		return false
	end
	if not p1.tradeable then
		return false
	end
	if p1.canAuction ~= nil then
		return p1.canAuction
	end
	if p1.titanic then
		return true
	end
	if p1.huge then
		return true
	end
	if p1.extremelyRare then
		return true
	end
	if p1.rarity == "Exclusive" then
		return true
	end
	return false
end
