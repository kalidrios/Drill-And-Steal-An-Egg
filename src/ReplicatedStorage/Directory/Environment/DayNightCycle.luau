--!strict
--[[
    Tabela de Configuracao do Ciclo de Dia e Noite
    Controla duracao dos ciclos, iluminacao e buffs de risco/recompensa.
]]

export type DayNightConfigType = {
	DayDurationSeconds: number,
	NightDurationSeconds: number,
	NightLootMultiplier: number, -- Multiplicador de spawn de ovos raros a noite
	NightMonsterSpeedBuff: number,
	LightingPresets: {
		DayTimeOfDay: string,
		NightTimeOfDay: string,
		DayAmbient: Color3,
		NightAmbient: Color3,
		DayBrightness: number,
		NightBrightness: number,
	},
}

local DayNightCycle: DayNightConfigType = {
	DayDurationSeconds = 300, -- 5 minutos de dia
	NightDurationSeconds = 180, -- 3 minutos de terror noturno
	NightLootMultiplier = 2.5, -- 2.5x mais chance de achar ovos raros/lendarios no escuro
	NightMonsterSpeedBuff = 1.4,
	LightingPresets = {
		DayTimeOfDay = "14:00:00",
		NightTimeOfDay = "00:00:00",
		DayAmbient = Color3.fromRGB(120, 120, 120),
		NightAmbient = Color3.fromRGB(12, 12, 18),
		DayBrightness = 2.0,
		NightBrightness = 0.2,
	},
}

return DayNightCycle
