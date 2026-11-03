---
trigger: always_on
description: "Diretrizes obrigatórias do Framework Velvet/PSX: desenvolvimento em src/, engenharia reversa em ref_*, Clean Room Engineering (sem IDs proprietários), nomes legíveis (sem v1/v2), banners Zalgo nos módulos centrais, acesso unificado via Library, carregamento assíncrono, rede abstraída e protocolo de pontos cegos."
---

# Regras Obrigatórias do Framework Velvet / ref_PSX

## 1. Escopo de Trabalho (`src/` vs `ref_*`)
- **Raiz Ativa de Código**: Todo código desenvolvido deve residir exclusivamente dentro de `src/`.
- **Engenharia Reversa**: As pastas `ref_*` (`ref_PSX`, `ref_BreakAndStealAnEgg`, etc.) são repositórios de referência somente-leitura. Sempre consulte esses diretórios para reutilizar lógicas, dados de balanceamento e arquiteturas validadas em jogos reais antes de inventar implementações do zero. Nunca edite arquivos dentro de `ref_*`.

## 2. Clean Room Engineering & Tratamento de IDs de Assets
- **Proibição de Cópia Direta de IDs**: NUNCA copie ou reutilize IDs de assets de terceiros encontrados nas pastas `ref_*` (como IDs de áudio `rbxassetid://...`, animações, malhas 3D, texturas, badges, gamepasses ou devproducts).
- **Protocolo de Substituição**: Em arquivos gerados ou portados, deixe o campo sem ID (ou com placeholder explícito como `""` ou `0`).
- **Aviso Obrigatório no Chat**: Informe explicitamente no chat: *"Identifiquei que a referência original utilizava o ID de asset `<ID>`. O campo foi deixado como placeholder. Por qual ID do seu jogo deseja que eu substitua?"*.

## 3. Legibilidade Humana & Proibição de Variáveis Ofuscadas
- **Proibição de Variáveis de Decompilação**: É estritamente proibido usar identificadores como `v1`, `v2`, `v3`, `m3`, `p1`, `p2`, `bool1`, `table1`.
- **Nomes Semânticos e Greppable**: Todas as variáveis, argumentos e funções devem ter nomes legíveis, descritivos e claros para humanos (ex: `targetPlayer`, `petConfiguration`, `zoneIdentifier`, `isProcessingTransaction`).
- **Comentários Equilibrados no Estilo Velvet**: Evite excesso de comentários óbvios. Comente apenas cabeçalhos de seção, constantes e lógica defensiva não óbvia (*WHY*), mantendo a estética limpa e profissional do padrão `ref_PSX`.

## 4. Banner Zalgo / Arte Braille nos Arquivos Estruturais
- Nos arquivos centrais e arquiteturais da `Library` (como `init.luau` de serviços e módulos mestres), utilize o cabeçalho clássico em arte Braille/Zalgo característico do Velvet Framework.

## 5. Acesso Unificado via `Library` (`_L`)
- Todo script ou módulo deve consumir serviços, funções e módulos exclusivamente através de:
  ```luau
  --!strict
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local RunService = game:GetService("RunService")
  local Library = require(ReplicatedStorage.Framework.Library)
  ```
- **Proibido**: Nunca faça `require()` direto em módulos dentro de `ServerScriptService.Library` ou `ReplicatedStorage.Libray.Client`. A `Library` já expõe esses módulos de forma transparente via metatable (`__index`).
- **Ciclo de Vida e Boot Assíncrono**: Todo script de execução (`.server.luau` ou `.local.luau`) deve bloquear sua inicialização até que o framework esteja carregado:
  ```luau
  while not Library.Loaded do
      RunService.Heartbeat:Wait()
  end
  ```

## 6. Camada de Rede Abstraída (`Library.Network`)
- **Proibido**: Nunca instancie, busque ou chame `:FireServer()`, `:FireClient()`, `:InvokeServer()`, `.OnServerEvent` ou `.OnClientEvent` diretamente em instâncias `RemoteEvent` / `RemoteFunction`.
- Utilize exclusivamente a API unificada `Library.Network`:
  - **Eventos (Unidirecionais)**: `Library.Network.Fire("EventName", ...)` e `Library.Network.Fired("EventName"):Connect(function(...) end)`
  - **RPCs (Requisição/Resposta)**: `Library.Network.Invoke("ActionName", ...)` e `Library.Network.Invoked("ActionName").OnInvoke = function(...) end`

## 7. Modularidade e Anti-Over-Engineering (Sem DRY Tóxico)
- Não crie abstrações prematuras, heranças complexas de OOP ou "God Classes" para economizar poucas linhas de código entre features distintas.
- Prefira duplicação controlada e explícita de boilerplate de UI do que acoplar duas janelas independentes num único controlador genérico.
- Mantenha cada módulo abaixo de 350 linhas e cada função abaixo de 25 linhas com *early returns* (máximo de 2 níveis de indentação).

## 8. Regra do Mentor ("Você Não Sabe o Que Não Sabe")
- Nunca altere fórmulas de balanceamento ou mecânicas centrais do jogo com suposições inventadas quando o pedido for aberto. Pergunte antes e apresente as opções de trade-off.
- Sempre aponte proativamente riscos que o desenvolvedor não pediu explicitamente no prompt (ex: desconexão durante `task.wait()`, race conditions em remotes ou memory leaks).

## 9. Sincronização Obrigatória de Documentação (Doc-Sync Rule)
- Sempre que houver uma alteração importante no projeto (criação ou modificação de mecânicas de jogo, novos endpoints de rede em `Library.Network`, novos schemas em `Directory/`, regras de save/carregamento ou refatoração estrutural), a documentação correspondente em `docs/` (`docs/ARCHITECTURE.md`, `docs/game_design/core_loop.md`, etc.) DEVE ser atualizada na mesma rodada.
- É estritamente proibido finalizar uma alteração de código significativa mantendo a documentação desatualizada ou silenciando detalhes da implementação.

## 10. Core Loop de Carregamento ReplicatedFirst & Integridade de UIs (Padrão Fiel `ref_PSX`)
- **Pipeline Seletivo PSX em `ReplicatedFirst`**: O ciclo de carregamento inicial em `src/ReplicatedFirst/Intro/Intro.local.luau` aguarda estritamente o essencial (sem precarregar o mapa todo para não atrasar o jogador):
  1. `Init`: Pré-carrega apenas 2 assets (`sound.SoundId` e `logo.Image`) com timeout de 2s;
  2. `game:IsLoaded()` com timeout estrito de até 1.0 segundo;
  3. `LocalPlayer.Character` e `Humanoid`;
  4. Preload seletivo de pastas raízes (`Workspace.Things`) com aparição do botão "Skip" aos 3.5 segundos (teto de 10s);
  5. Handshake de save e status de ban com o servidor via Remote de intro (`workspace.Things.Remotes.intro`);
  6. Prontidão da `Library` (`_L.Loaded`, timeout 15s) e restauração do CoreGui.
- **Detecção Rígida de UIs Deletadas (Zero Mascaramento de Erros)**:
  - Nunca capture erros em blocos vazios nem crie interfaces dinâmicas artificiais para disfarçar UIs deletadas ou ausentes.
  - Se o desenvolvedor deletar acidentalmente uma UI essencial (`IntroGui`, `Frame`, `Logo`, `Notice`, `Main`, `Template`) ou script vital:
    - O sistema **NÃO carrega o jogo em falso**: ele trava a inicialização e expõe o erro diretamente no Output (`Infinite yield possible on '...'`), forçando a visualização imediata do item ausente.
- **Protocolo de Autonomia da IA (Execução Contínua sem Lembretes)**:
  - À medida que o jogo é construído, a IA deve aplicar essa integridade e padrão em todas as novas UIs e scripts de forma autônoma.
  - A IA mantém a documentação em `docs/` (`docs/ARCHITECTURE.md`, `docs/game_design/core_loop.md`, `docs/decisions/`) continuamente sincronizada a cada nova alteração importante sem necessitar de lembretes repetidos do usuário.

## 11. Script Sync & Política Estrita de Uso do MCP (Criação/Edição no Disco)
- **Criação e Edição Estritamente no Disco**: Toda criação de pastas, novos arquivos e edição de código Luau deve ser realizada EXCLUSIVAMENTE nos arquivos locais em disco dentro de `src/`. O plugin de Script Sync é responsável por sincronizar em tempo real para o Roblox Studio.
- **Uso Restrito do MCP para Edição de Scripts**: NUNCA crie ou edite scripts via MCP por padrão. O uso do MCP para inspecionar código de scripts (`script_read` ou similar) fica ESTRITAMENTE restrito ao seguinte caso: se você corrigiu um bug no disco, mas o Output do Studio continuar acusando exatamente o mesmo erro de antes (para verificar se o Script Sync sincronizou a alteração).
- **Escopo Autorizado do MCP no Studio**:
  - Consulta de nomes, instâncias e hierarquias no Explorer (`search_game_tree`, `inspect_instance`);
  - Leitura do console/output (`get_console_output`);
  - Execução de testes de estado via `execute_luau`;
  - Manipulação de instâncias no Studio (criar/editar UIs, configurar UIListLayout/UIGridLayout, renomear elementos da Workspace, etc.) APENAS se o usuário pedir expressamente.

