---
name: new-feature
description: Cria uma nova feature completa seguindo estritamente o Framework Velvet/PSX em src/ com engenharia reversa em ref_* (__DIRECTORY, Server Library, Client Cmds, GUI local script, testes e análise de pontos cegos). Use ao implementar qualquer novo sistema de jogo.
---

# Workflow: Nova Feature no Padrão Velvet (`/new-feature`)

Todo código novo deve ser criado exclusivamente dentro de `src/`. Consulte as pastas `ref_*` para extrair padrões e referências de engenharia reversa.

Siga rigorosamente estas 6 etapas em ordem sequencial:

1. **Etapa 1 — Engenharia Reversa e Modelagem de Dados (`src/ReplicatedStorage/__DIRECTORY/`)**:
   - Inspecione as pastas `ref_*` relevantes para ver se a feature ou mecânica similar já foi resolvida (tabelas de status, preços, balanceamento, metadados).
   - Se o pedido tiver ambiguidades de balanceamento ou de mecânica, aponte os trade-offs primeiro.
   - Crie ou atualize os arquivos em `src/ReplicatedStorage/__DIRECTORY/<Categoria>/<Nome>.luau` com `--!strict` e tipos exportados.
   - Nenhum número mágico deve ficar hardcoded nos scripts de controle.

2. **Etapa 2 — Autoridade de Servidor (`src/ServerScriptService/Library/<Feature>.luau`)**:
   - Crie o módulo de servidor consumindo `local Library = require(ReplicatedStorage.Framework.Library)`.
   - Bloqueie a inicialização com `while not Library.Loaded do RunService.Heartbeat:Wait() end`.
   - Implemente as funções puras de validação e cálculo lendo de `Library.Directory.<Categoria>`.
   - Registre endpoints via `Library.Network.Invoked("<Feature>_<Action>").OnInvoke` ou `Library.Network.Fired("<Feature>_<Event>"):Connect(...)`.
   - Adicione guards defensivos no topo: validação de tipo (`type(x)`), rejeição de `NaN` (`x ~= x`), limites e trava de concorrência por `Player.UserId`. Após yields assíncronos (`task.wait` ou `DataStore`), valide `player.Parent == Players`.

3. **Etapa 3 — Módulo de Comandos Cliente (`src/ReplicatedStorage/Libray/Client/<Feature>Cmds.luau`)**:
   - Crie o módulo cliente com `--!strict` e acesso via `Library`.
   - Exponha funções claras e *greppable* (ex: `<Feature>Cmds.RequestUnlock(...)`, `<Feature>Cmds.GetPlayerState()`) que encapsulam `Library.Network.Invoke` e `Library.Network.Fired`.

4. **Etapa 4 — Script Isolado de Interface (`src/StarterPlayerScripts/Scripts/GUIs/<Feature>.local.luau`)**:
   - Inicie com a guarda de boot: `while not Library.Loaded do RunService.Heartbeat:Wait() end`.
   - Antes de processar inputs ou abrir janelas, verifique `Library.Variables` (ex: `if Library.Variables.Busy then return end`).
   - Adicione debounce local em cliques de botão e garanta restauração de flags mesmo em caso de falha de rede. Desconecte `RBXScriptConnection` ao fechar/destruir.

5. **Etapa 5 — Teste Automatizado de Estado**:
   - Crie um teste automatizado em `tests/<Feature>.spec.luau` simulando entradas válidas, tentativas de exploit (valores negativos, `nil`, `NaN`, tipos trocados, saldo insuficiente) e verificando a consistência do estado resultante.

6. **Etapa 6 — Relatório "O Que Você Não Pediu" (Blind Spots & Trade-offs)**:
   - Ao finalizar, liste explicitamente quais proteções foram adicionadas por conta própria e quais pontos cegos de produção (migração de dados salvos, comportamento em queda de conexão, custo de rede no multiplayer) precisam da sua decisão.
