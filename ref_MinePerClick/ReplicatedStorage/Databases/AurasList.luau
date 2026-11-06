-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Auras = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Auras")

return {
	Flame = {
		Multiplier = 1.2,
		Price = 100000,
		ProductId = 3605604985,
		Aura = Auras:FindFirstChild("Flame")
	},
	["Green Flame"] = {
		Multiplier = 1.4,
		Price = 1000000,
		ProductId = 3605605149,
		Aura = Auras:FindFirstChild("Green Flame")
	},
	["Purple Flame"] = {
		Multiplier = 1.6,
		Price = 50000000,
		ProductId = 3605605175,
		Aura = Auras:FindFirstChild("Purple Flame")
	},
	["Red Flame"] = {
		Multiplier = 1.8,
		Price = 500000000,
		ProductId = 3605605228,
		Aura = Auras:FindFirstChild("Red Flame")
	},
	["Blue Flame"] = {
		Multiplier = 2.5,
		Price = 2000000000,
		ProductId = 3605605251,
		Aura = Auras:FindFirstChild("Blue Flame")
	},
	["Pink Flame"] = {
		Multiplier = 3,
		Price = 8000000000,
		ProductId = 3605605291,
		Aura = Auras:FindFirstChild("Pink Flame")
	},
	["White Flame"] = {
		Multiplier = 3.5,
		Price = 15000000000,
		ProductId = 3606768214,
		Aura = Auras:FindFirstChild("White Flame")
	}
}