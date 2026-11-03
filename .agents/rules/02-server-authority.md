---
trigger: glob
globs: "src/ServerScriptService/**/*.luau, ServerScriptService/**/*.luau"
description: "Regras de autoridade de servidor, validação anti-exploit, programação defensiva e persistência em ServerScriptService/Library."
---

# Regras de Servidor (`ServerScriptService/Library` e `ServerScriptService/Scripts`)

## 1. Organização Estrutural de Pastas (Padrão Estrito Velvet / PSX / PS99)
- **`ServerScriptService/Library/<Feature>.luau`**: Módulos puros de serviço (`ModuleScript`). NUNCA coloque scripts executáveis (`.server.luau`) soltos na raiz ou dentro de `Library`.
- **`ServerScriptService/Scripts/Core/<Script>.server.luau`**: Scripts de ciclo de vida central do servidor (ex: `GameInit.server.luau` para inicialização da `Library`, boot de serviços e remotes).
- **`ServerScriptService/Scripts/Game/<Feature>.server.luau`**: Scripts de gameplay específicos do servidor.
- **`ServerScriptService/Packages/<Package>/`**: Pacotes e bibliotecas de terceiros (ex: `ProfileStore`).
- **Proibição Absoluta**: NUNCA coloque scripts `.server.luau` ou `.legacy.luau` soltos na raiz de `ServerScriptService/`.

## 2. Autoridade Absoluta do Servidor
- O Servidor detém 100% da autoridade sobre moedas, inventário, pets, upgrades, quests, zonas e recompensas.
- Nunca confie em valores calculados pelo cliente (preços, dano, multiplicadores, timestamps ou IDs não verificados). O cliente envia apenas a **intenção** (ex: `petUID` ou `zoneId`); o servidor consulta `Library.Directory` e o estado salvo do jogador para validar e calcular o resultado.
- **Engenharia Reversa**: Consulte as implementações em `ref_PSX/ServerScriptService/Library` e outros projetos `ref_*` para ver como lógicas similares já foram resolvidas e balanceadas no servidor.

## 2. Guards Explícitos em `Library.Network.Invoked` e `Fired`
- Todo handler de rede no servidor deve iniciar com validação defensiva de tipos e limites antes de qualquer lógica de negócio:
  ```luau
  -- WHY: Validacao rigorosa de payload de rede (evita NaN, tabelas maliciosas e tipos invalidos)
  if type(zoneId) ~= "string" or #zoneId == 0 or #zoneId > 64 then
      return false, "Invalid zoneId parameter"
  end
  if type(amount) ~= "number" or amount ~= amount or amount <= 0 or math.floor(amount) ~= amount then
      return false, "Invalid integer amount"
  end
  ```
- Implemente *rate limiting* / *cooldown lock* por `Player.UserId` em ações sensíveis (compra, equip, trade, hatch, rebirth) usando flags de lock no servidor (e limpando no `Players.PlayerRemoving`) para impedir exploração por *race condition* (spam de pacotes paralelos).
- Antes de concluir qualquer operação assíncrona (como `DataStore` ou `task.wait`), revalide se `player.Parent == Players` para evitar mutação de sessão encerrada (*dupe exploit*).

## 3. Isolamento e Testabilidade Headless
- Separe funções puras de cálculo/regra (ex: `CalculateUpgradeCost(level, directoryEntry)`) dos efeitos colaterais de estado/rede. Isso permite que os agentes executem testes automatizados de regressão diretamente sobre as regras matemáticas e de negócio sem precisar subir uma sessão gráfica inteira do Roblox Studio.
