-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Icons = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Icons")

return {
	Flame = {
		Name = "Flame",
		Multiplier = 1.25,
		Spawnchance = 60.5,
		Icon = Icons:WaitForChild("Flame")
	},
	Berry = {
		Name = "Berry",
		Multiplier = 1.5,
		Spawnchance = 20,
		Icon = Icons:WaitForChild("Berry")
	},
	Frozen = {
		Name = "Frozen",
		Multiplier = 2,
		Spawnchance = 10,
		Icon = Icons:WaitForChild("Frozen")
	},
	Toxic = {
		Name = "Toxic",
		Multiplier = 3,
		Spawnchance = 5,
		Icon = Icons:WaitForChild("Toxic")
	},
	Cursed = {
		Name = "Cursed",
		Multiplier = 5,
		Spawnchance = 3.5,
		Icon = Icons:WaitForChild("Cursed")
	},
	Lucky = {
		Name = "Lucky",
		Multiplier = 10,
		Spawnchance = 1,
		Icon = Icons:WaitForChild("Lucky")
	}
}