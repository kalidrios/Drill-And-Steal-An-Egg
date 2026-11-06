--[[
	CodesList: База данных промокодов
	Каждый код содержит:
	- Rewards: таблица наград (Cash, Strength)
	- ExpiresAt: время истечения (os.time, 0 = бессрочно)
	- MaxUses: максимальное количество использований глобально (0 = без лимита)
	- Uses: текущее количество использований (обновляется сервером)
]]

return {
	-- Стартовые коды (можно удалить или изменить)
	["RELEASE"] = {
		Rewards = {
			Cash = 5000,
			Strength = 1000,
		},
		ExpiresAt = 0, -- бессрочно
		MaxUses = 0, -- без лимита
		Uses = 0,
	},
	["LUCKY777"] = {
		Rewards = {
			Cash = 50000,
		},
		ExpiresAt = 0,
		MaxUses = 0,
		Uses = 0,
	},
	["STRENGTH"] = {
		Rewards = {
			Strength = 100000,
		},
		ExpiresAt = 0,
		MaxUses = 0,
		Uses = 0,
	},
}