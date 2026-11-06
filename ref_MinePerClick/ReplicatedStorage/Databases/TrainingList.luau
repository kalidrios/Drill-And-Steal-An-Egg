-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ReplicatedStorage"):WaitForChild("Assets")

local v1 = game.Workspace:WaitForChild("Map"):WaitForChild("Training Areas")

return {
	Coal = {
		MinimumRebirths = 0,
		Multiplier = 1.5,
		Folder = v1:WaitForChild("Coal Ore")
	},
	Iron = {
		MinimumRebirths = 2,
		Multiplier = 2,
		Folder = v1:WaitForChild("Iron Ore")
	},
	Gold = {
		MinimumRebirths = 5,
		Multiplier = 4,
		Folder = v1:WaitForChild("Gold Ore")
	},
	Quartz = {
		MinimumRebirths = 9,
		Multiplier = 6,
		Folder = v1:WaitForChild("Quartz Ore")
	},
	Diamond = {
		MinimumRebirths = 12,
		Multiplier = 8,
		Folder = v1:WaitForChild("Diamond Ore")
	},
	Demonite = {
		MinimumRebirths = 15,
		Multiplier = 10,
		Folder = v1:WaitForChild("Demonite")
	},
	Amethyst = {
		MinimumRebirths = 0,
		Multiplier = 15,
		GamepassId = 1856088312,
		Folder = v1:WaitForChild("Amethyst")
	},
	Emerald = {
		MinimumRebirths = 0,
		Multiplier = 25,
		GamepassId = 1852840225,
		Folder = v1:WaitForChild("Emerald")
	},
	Azurite = {
		MinimumRebirths = 0,
		Multiplier = 100,
		GamepassId = 1860029064,
		Folder = v1:WaitForChild("Azurite")
	}
}