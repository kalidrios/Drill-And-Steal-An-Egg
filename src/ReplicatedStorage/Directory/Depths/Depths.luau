--!strict
--[[
    Tabela de Camadas da Mina / Profundidades (Depth Stages)
    Engenharia Reversa baseada em ref_MinePerClick/StagesList
    Clean Room: Sem ProductIds proprietarios.
]]

export type DepthStageEntry = {
	StageId: number,
	Name: string,
	DepthMeters: number,
	RequiredPickaxeDamage: number,
	AvailableEggs: { string },
	ExtractionZoneName: string,
	MonsterSpawnIntervalSeconds: number,
}

local Depths: { [number]: DepthStageEntry } = {
	[1] = {
		StageId = 1,
		Name = "Superficial Caverns",
		DepthMeters = 50,
		RequiredPickaxeDamage = 1,
		AvailableEggs = { "Forest Egg" },
		ExtractionZoneName = "Elevator_Stage1",
		MonsterSpawnIntervalSeconds = 90,
	},
	[2] = {
		StageId = 2,
		Name = "Rocky Depths",
		DepthMeters = 150,
		RequiredPickaxeDamage = 5,
		AvailableEggs = { "Forest Egg", "Stone Egg" },
		ExtractionZoneName = "Elevator_Stage2",
		MonsterSpawnIntervalSeconds = 75,
	},
	[3] = {
		StageId = 3,
		Name = "Crystal Hollows",
		DepthMeters = 400,
		RequiredPickaxeDamage = 25,
		AvailableEggs = { "Stone Egg", "Crystal Egg" },
		ExtractionZoneName = "Elevator_Stage3",
		MonsterSpawnIntervalSeconds = 60,
	},
	[4] = {
		StageId = 4,
		Name = "Magma Trench",
		DepthMeters = 850,
		RequiredPickaxeDamage = 100,
		AvailableEggs = { "Crystal Egg", "Magma Egg" },
		ExtractionZoneName = "Elevator_Stage4",
		MonsterSpawnIntervalSeconds = 45,
	},
	[5] = {
		StageId = 5,
		Name = "The Abyssal Core",
		DepthMeters = 1600,
		RequiredPickaxeDamage = 500,
		AvailableEggs = { "Magma Egg", "Void Egg" },
		ExtractionZoneName = "Elevator_Stage5",
		MonsterSpawnIntervalSeconds = 30,
	},
}

return Depths
