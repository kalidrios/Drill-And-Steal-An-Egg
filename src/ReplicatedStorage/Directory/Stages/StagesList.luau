--!strict
--[[
	Directory/Stages/StagesList.luau
	Tabela pura de configuração estática dos Estágios/Paredes da mina.
	Clean Room Engineering baseado no ref_MinePerClick/StagesList.
	Sem IDs proprietários de ProductId (mantidos como 0 para Clean Room).
]]

export type WallData = {
	WallId: number,
	MaxHealth: number,
}

export type StageData = {
	StageId: number,
	Name: string,
	ProductId: number,
	Luck: number,
	Walls: { WallData },
}

local StagesList: { [number]: StageData } = {
	[1] = {
		StageId = 1,
		Name = "Stage 1",
		ProductId = 0, -- Clean Room placeholder
		Luck = 1,
		Walls = {
			{ WallId = 1, MaxHealth = 1 },
			{ WallId = 2, MaxHealth = 5 },
			{ WallId = 3, MaxHealth = 15 },
		},
	},
	[2] = {
		StageId = 2,
		Name = "Stage 2",
		ProductId = 0,
		Luck = 2,
		Walls = {
			{ WallId = 1, MaxHealth = 50 },
			{ WallId = 2, MaxHealth = 200 },
			{ WallId = 3, MaxHealth = 500 },
		},
	},
	[3] = {
		StageId = 3,
		Name = "Stage 3",
		ProductId = 0,
		Luck = 3,
		Walls = {
			{ WallId = 1, MaxHealth = 500 },
			{ WallId = 2, MaxHealth = 2500 },
			{ WallId = 3, MaxHealth = 5000 },
		},
	},
	[4] = {
		StageId = 4,
		Name = "Stage 4",
		ProductId = 0,
		Luck = 4,
		Walls = {
			{ WallId = 1, MaxHealth = 10000 },
			{ WallId = 2, MaxHealth = 25000 },
			{ WallId = 3, MaxHealth = 50000 },
		},
	},
	[5] = {
		StageId = 5,
		Name = "Stage 5",
		ProductId = 0,
		Luck = 5,
		Walls = {
			{ WallId = 1, MaxHealth = 100000 },
			{ WallId = 2, MaxHealth = 300000 },
			{ WallId = 3, MaxHealth = 500000 },
		},
	},
	[6] = {
		StageId = 6,
		Name = "Stage 6",
		ProductId = 0,
		Luck = 7,
		Walls = {
			{ WallId = 1, MaxHealth = 1500000 },
			{ WallId = 2, MaxHealth = 3500000 },
			{ WallId = 3, MaxHealth = 5000000 },
		},
	},
	[7] = {
		StageId = 7,
		Name = "Stage 7",
		ProductId = 0,
		Luck = 8,
		Walls = {
			{ WallId = 1, MaxHealth = 10000000 },
			{ WallId = 2, MaxHealth = 25000000 },
			{ WallId = 3, MaxHealth = 50000000 },
		},
	},
	[8] = {
		StageId = 8,
		Name = "Stage 8",
		ProductId = 0,
		Luck = 10,
		Walls = {
			{ WallId = 1, MaxHealth = 100000000 },
			{ WallId = 2, MaxHealth = 250000000 },
			{ WallId = 3, MaxHealth = 500000000 },
		},
	},
	[9] = {
		StageId = 9,
		Name = "Stage 9",
		ProductId = 0,
		Luck = 12,
		Walls = {
			{ WallId = 1, MaxHealth = 1000000000 },
			{ WallId = 2, MaxHealth = 2500000000 },
			{ WallId = 3, MaxHealth = 5000000000 },
		},
	},
	[10] = {
		StageId = 10,
		Name = "Stage 10",
		ProductId = 0,
		Luck = 15,
		Walls = {
			{ WallId = 1, MaxHealth = 10000000000 },
			{ WallId = 2, MaxHealth = 25000000000 },
			{ WallId = 3, MaxHealth = 50000000000 },
		},
	},
	[11] = {
		StageId = 11,
		Name = "Stage 11",
		ProductId = 0,
		Luck = 18,
		Walls = {
			{ WallId = 1, MaxHealth = 100000000000 },
			{ WallId = 2, MaxHealth = 250000000000 },
			{ WallId = 3, MaxHealth = 500000000000 },
		},
	},
	[12] = {
		StageId = 12,
		Name = "Stage 12",
		ProductId = 0,
		Luck = 22,
		Walls = {
			{ WallId = 1, MaxHealth = 1000000000000 },
			{ WallId = 2, MaxHealth = 2500000000000 },
			{ WallId = 3, MaxHealth = 5000000000000 },
		},
	},
	[13] = {
		StageId = 13,
		Name = "Stage 13",
		ProductId = 0,
		Luck = 26,
		Walls = {
			{ WallId = 1, MaxHealth = 10000000000000 },
			{ WallId = 2, MaxHealth = 25000000000000 },
			{ WallId = 3, MaxHealth = 50000000000000 },
		},
	},
	[14] = {
		StageId = 14,
		Name = "Stage 14",
		ProductId = 0,
		Luck = 30,
		Walls = {
			{ WallId = 1, MaxHealth = 100000000000000 },
			{ WallId = 2, MaxHealth = 250000000000000 },
			{ WallId = 3, MaxHealth = 500000000000000 },
		},
	},
	[15] = {
		StageId = 15,
		Name = "Stage 15",
		ProductId = 0,
		Luck = 35,
		Walls = {
			{ WallId = 1, MaxHealth = 1000000000000000 },
			{ WallId = 2, MaxHealth = 2500000000000000 },
			{ WallId = 3, MaxHealth = 5000000000000000 },
		},
	},
	[16] = {
		StageId = 16,
		Name = "Stage 16",
		ProductId = 0,
		Luck = 40,
		Walls = {
			{ WallId = 1, MaxHealth = 10000000000000000 },
			{ WallId = 2, MaxHealth = 25000000000000000 },
			{ WallId = 3, MaxHealth = 50000000000000000 },
		},
	},
	[17] = {
		StageId = 17,
		Name = "Stage 17",
		ProductId = 0,
		Luck = 45,
		Walls = {
			{ WallId = 1, MaxHealth = 100000000000000000 },
			{ WallId = 2, MaxHealth = 250000000000000000 },
			{ WallId = 3, MaxHealth = 500000000000000000 },
		},
	},
	[18] = {
		StageId = 18,
		Name = "Stage 18",
		ProductId = 0,
		Luck = 50,
		Walls = {
			{ WallId = 1, MaxHealth = 1000000000000000000 },
			{ WallId = 2, MaxHealth = 2500000000000000000 },
			{ WallId = 3, MaxHealth = 5000000000000000000 },
		},
	},
	[19] = {
		StageId = 19,
		Name = "Stage 19",
		ProductId = 0,
		Luck = 60,
		Walls = {
			{ WallId = 1, MaxHealth = 1e19 },
			{ WallId = 2, MaxHealth = 2.5e19 },
			{ WallId = 3, MaxHealth = 5e19 },
		},
	},
	[20] = {
		StageId = 20,
		Name = "Stage 20",
		ProductId = 0,
		Luck = 70,
		Walls = {
			{ WallId = 1, MaxHealth = 1e20 },
			{ WallId = 2, MaxHealth = 2.5e20 },
			{ WallId = 3, MaxHealth = 5e20 },
		},
	},
	[21] = {
		StageId = 21,
		Name = "Stage 21",
		ProductId = 0,
		Luck = 85,
		Walls = {
			{ WallId = 1, MaxHealth = 1e21 },
			{ WallId = 2, MaxHealth = 2.5e21 },
			{ WallId = 3, MaxHealth = 5e21 },
		},
	},
	[22] = {
		StageId = 22,
		Name = "Stage 22",
		ProductId = 0,
		Luck = 100,
		Walls = {
			{ WallId = 1, MaxHealth = 1e22 },
			{ WallId = 2, MaxHealth = 2.5e22 },
			{ WallId = 3, MaxHealth = 5e22 },
		},
	},
}

return StagesList
