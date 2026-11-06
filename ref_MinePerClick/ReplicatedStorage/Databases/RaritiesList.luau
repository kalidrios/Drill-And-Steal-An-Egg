-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Gradients = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Gradients")

return {
	Common = {
		Name = "Common",
		Order = 1,
		Spawnchance = 70,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Common")
	},
	Uncommon = {
		Name = "Uncommon",
		Order = 2,
		Spawnchance = 20,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Uncommon")
	},
	Rare = {
		Name = "Rare",
		Order = 3,
		Spawnchance = 6,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Rare")
	},
	Epic = {
		Name = "Epic",
		Order = 4,
		Spawnchance = 2.75,
		HoldDuration = 1,
		Gradient = Gradients:WaitForChild("Epic")
	},
	Legendary = {
		Name = "Legendary",
		Order = 5,
		Spawnchance = 0.8,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Legendary")
	},
	Mythic = {
		Name = "Mythic",
		Order = 6,
		Spawnchance = 0.125,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Mythic")
	},
	Secret = {
		Name = "Secret",
		Order = 7,
		Spawnchance = 0.02,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Secret")
	},
	Godly = {
		Name = "Godly",
		Order = 8,
		Spawnchance = 0.0013,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Godly")
	},
	Divine = {
		Name = "Divine",
		Order = 9,
		Spawnchance = 0.00002,
		HoldDuration = 0.25,
		Gradient = Gradients:WaitForChild("Divine")
	}
}