-- its june and i making a game instead study for my entrance exame
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Modules")
local Pets = require(Modules.Pets)
local DefaultStats = require(Modules.DefaultStats)
local PetOrderInv = require(script.Parent.PetOrderInv)
return function(p1, p2, p3)
	table.sort(p2, function(p4, p5)
		return 0 > PetOrderInv(p1, p4, p5, p3)
	end)
	return p2
end
