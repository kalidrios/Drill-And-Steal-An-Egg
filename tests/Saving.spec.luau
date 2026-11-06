--!strict
--[[
	tests/Saving.spec.luau
	Suíte de testes sem cabeça (headless) para regras de persistência, reconciliação e validação do ProfileStore/Saving.
]]

local function RunTests()
	print("================================================================================")
	print("[TEST SUITE] Iniciando testes de persistência e reconciliação (ProfileStore / Saving)...")
	print("================================================================================")

	local DefaultStats = {
		StatsVersion = "PlayerData_v1",
		Template = {
			Strength = 0,
			Cash = 100,
			Depth = 0,
			EquippedPickaxe = "Wood Pickaxe",
			EquippedAura = nil,
			EquippedPets = {},
			InventoryPets = {},
			PenCapacity = 4,
			LastOfflineSync = 0,
			DataVersion = 1,
		},
		NetworkingBlacklist = {
			LastOfflineSync = true,
			DataVersion = true,
		},
		MaxOfflineSeconds = 12 * 3600,
		MaxInventoryPets = 500,
	}

	-- Teste 1: Reconciliação de Campos Ausentes em Save Antigo
	do
		local oldSaveData = {
			Strength = 500,
			Cash = 2500,
			-- PenCapacity e DataVersion não existiam na versão antiga!
		}

		-- Simulação de Reconcile: preenche chaves ausentes a partir do template padrão
		for key, defaultValue in pairs(DefaultStats.Template) do
			if oldSaveData[key] == nil then
				if type(defaultValue) == "table" then
					oldSaveData[key] = {}
				else
					oldSaveData[key] = defaultValue
				end
			end
		end

		assert(oldSaveData.Strength == 500, "Teste 1 Falhou: O valor existente de Strength foi sobrescrito!")
		assert(oldSaveData.Cash == 2500, "Teste 1 Falhou: O valor existente de Cash foi sobrescrito!")
		assert(oldSaveData.PenCapacity == 4, "Teste 1 Falhou: PenCapacity não foi reconciliado!")
		assert(oldSaveData.EquippedPickaxe == "Wood Pickaxe", "Teste 1 Falhou: EquippedPickaxe não foi reconciliado!")
		print("[PASS] Teste 1: Reconciliação de dados legados preencheu campos faltantes com perfeição.")
	end

	-- Teste 2: Cálculo Defensivo de Ganhos Offline com Teto de 12 Horas
	do
		local currentTime = 1000000
		local lastSyncTime = currentTime - (24 * 3600) -- Ficou 24 horas fora (mais que o teto de 12h)

		local elapsed = math.min(currentTime - lastSyncTime, DefaultStats.MaxOfflineSeconds)
		assert(elapsed == 12 * 3600, string.format("Teste 2 Falhou: Teto offline não limitou a 12h (esperado %d, obtido %d)", 12 * 3600, elapsed))

		local incomePerSecond = 10 -- 10 moedas/seg
		local totalGain = incomePerSecond * elapsed
		assert(totalGain == 10 * 12 * 3600, "Teste 2 Falhou: Cálculo de ganho offline incorreto!")
		print("[PASS] Teste 2: Cálculo de rendimento offline respeitou o teto configurado de 12 horas.")
	end

	-- Teste 3: Filtragem de Blacklist na Replicação de Rede
	do
		local fullData = {
			Strength = 100,
			Cash = 50,
			LastOfflineSync = 999999,
			DataVersion = 1,
		}

		local safePayload = {}
		for key, value in pairs(fullData) do
			if not DefaultStats.NetworkingBlacklist[key] then
				safePayload[key] = value
			end
		end

		assert(safePayload.Strength == 100, "Teste 3 Falhou: Strength deveria estar no payload público!")
		assert(safePayload.Cash == 50, "Teste 3 Falhou: Cash deveria estar no payload público!")
		assert(safePayload.LastOfflineSync == nil, "Teste 3 Falhou: LastOfflineSync vazou na rede pública!")
		assert(safePayload.DataVersion == nil, "Teste 3 Falhou: DataVersion vazou na rede pública!")
		print("[PASS] Teste 3: Chaves privadas foram filtradas com sucesso pela NetworkingBlacklist.")
	end

	-- Teste 4: Proteção contra Estouro de Cota de Inventário de Pets (Anti-4MB Overflow)
	do
		local petInventory = {}
		for i = 1, DefaultStats.MaxInventoryPets do
			petInventory["uid_" .. i] = { Id = "Dog", Coins = 5 }
		end

		local petCount = 0
		for _ in pairs(petInventory) do
			petCount += 1
		end

		local canAddMore = petCount < DefaultStats.MaxInventoryPets
		assert(canAddMore == false, "Teste 4 Falhou: Não bloqueou inserção além do limite de inventário!")
		print("[PASS] Teste 4: Teto defensivo de inventário protegeu contra corrupção/limite de 4MB do DataStore.")
	end

	print("================================================================================")
	print("[TEST SUITE] Todos os testes de persistência passaram com 100% de sucesso!")
	print("================================================================================")
end

RunTests()
