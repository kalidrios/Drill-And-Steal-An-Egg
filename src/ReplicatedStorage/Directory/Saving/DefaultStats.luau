--!strict
--[[
	Directory/Saving/DefaultStats.luau
	Template de dados iniciais do jogador, versionamento de schema e regras de rede.
	Fusão de ref_StealAnEgg (Speed, Money, Eggs/Pets) + ref_MinePerClick (Strength, Pickaxes, Depth/Stages).
]]

export type PlayerDataTemplate = {
	Speed: number,
	Strength: number,
	Money: number,
	Cash: number,
	Rebirths: number,
	Depth: number,
	EquippedPickaxe: string,
	EquippedAura: string?,
	EquippedPets: { string },
	InventoryPets: { [string]: any },
	EggInventory: { [string]: any },
	PenCapacity: number,
	LastOfflineSync: number,
	DataVersion: number,
}

local DefaultStats = {
	-- Chave do DataStore principal. Incrementar a versão permite wipes controlados entre temporadas/testes.
	StatsVersion = "PlayerData_v1",

	-- Template padrão inserido em novos perfis ou reconciliado em perfis antigos
	Template = {
		Speed = 16, -- Velocidade inicial do jogador (Humanoid.WalkSpeed / Speed stat)
		Strength = 0, -- Força inicial para quebrar blocos/stages
		Money = 0, -- Dinheiro principal do jogador
		Cash = 0, -- Espelho sincronizado com Money para retrocompatibilidade
		Rebirths = 0,
		Depth = 0,
		EquippedPickaxe = "Wood Pickaxe",
		EquippedAura = nil :: string?,
		EquippedPets = {} :: { string },
		InventoryPets = {} :: { [string]: any },
		EggInventory = {} :: { [string]: any },
		PenCapacity = 4,
		LastOfflineSync = 0,
		DataVersion = 1,
	} :: PlayerDataTemplate,

	-- Chaves privadas que não devem ser replicadas diretamente para o cliente via rede pública
	NetworkingBlacklist = {
		LastOfflineSync = true,
		DataVersion = true,
	} :: { [string]: boolean },

	-- Teto máximo de horas de acumulação offline (12 horas = 43200 segundos)
	MaxOfflineHours = 12,
	MaxOfflineSeconds = 12 * 3600,

	-- Limite máximo defensivo de pets no inventário para evitar exceder o limite de 4MB por chave do DataStore
	MaxInventoryPets = 500,
}

return DefaultStats
