# Arquitetura do Projeto ViralProject (Velvet Framework / ref_PSX)

> **Status**: Ativo & Sincronizado  
> **Raiz de Código Ativo**: `src/`  
> **Repositórios de Referência (Read-Only)**: `ref_PSX`, `ref_BreakAndStealAnEgg`, `ref_MinePerClick`, `ref_StealAnEgg`

---

## 1. Visão Geral da Arquitetura

O projeto adota a arquitetura orientada a serviços e módulos puros baseada no **Velvet Groups rbx.lua Framework** (utilizado no Pet Simulator X). O ciclo de vida do jogo é completamente defensivo, autoritativo no servidor e sem acoplamento direto entre módulos.

```
                              [ ReplicatedFirst ]
                           (Tela de Loading 5-Fases)
                                      |
                   +------------------+------------------+
                   |                                     |
           [ Cliente / GUIs ]                   [ Servidor Velvet ]
       (StarterPlayerScripts)                 (ServerScriptService)
                   |                                     |
                   +--------> [ Library.Network ] <------+
                               (Abstração RPC/Events)
                                         |
                               [ Directory/ ]
                              (Static Data & Balanço)
```

---

## 2. Pipeline de Carregamento em `ReplicatedFirst` (Padrão PSX)

O ponto de entrada inicial do cliente reside em `src/ReplicatedFirst/Intro.local.luau` e gerencia a inicialização antes de qualquer script do jogo começar a rodar.

### As 5 Fases do Carregador:
1. **Stage 1 (Game Loaded)**: Aguarda `game:IsLoaded()` com timeout defensivo de até 1.0s. Se ultrapassar, loga `warn("Intro error #1: Time exceeded for IsLoaded()")` e prossegue.
2. **Stage 2 (Character Readiness)**: Aguarda o surgimento do `LocalPlayer.Character` e do seu `Humanoid`.
3. **Stage 3 (Preload de Assets com Skip)**: Inicia `ContentProvider:PreloadAsync`. Se demorar mais que 3.5 segundos, exibe suavemente o botão **Pular (Skip)** para evitar travamento em conexões lentas.
4. **Stage 4 (Handshake do Servidor & Ban Status)**:
   - Invoca a `RemoteFunction` `workspace.Things.Remotes.intro:InvokeServer(true)` de forma assíncrona (`task.spawn`) com timeout estrito de 3 segundos por tentativa, evitando travamento eterno da thread do cliente caso o servidor demore ou o script do servidor não esteja sincronizado.
   - O servidor verifica se o perfil do jogador já foi carregado e se há status de banimento temporário/permanente.
   - Em ambiente Studio, possui salvaguarda (*Studio Safe-Pass*) para não prender o desenvolvedor caso o script do servidor não tenha sido sincronizado via Script Sync.
   - Em caso de falha de conexão persistente em produção, exibe o modal de erro estilizado `Error()` com opção de reconexão.
5. **Stage 5 (Framework Boot & Verificação de UIs)**:
   - Restaura o `CoreGui` do Roblox (`SetCoreGuiEnabled("All", true)`) e desativa explicitamente `Enum.CoreGuiType.Backpack` para utilizar a Toolbar customizada.
   - Define a flag global `_G.IntroDone = true`.
   - Requer `ReplicatedStorage.Framework.Library` e aguarda `_L.Loaded == true`.
   - Executa a verificação preventiva de integridade de interfaces.

---

## 3. Integridade Rígida & Protocolo de Carregamento (Padrão Fiel `ref_PSX`)

### Filosofia Fiel ao `ref_PSX`:
No desenvolvimento diário em Roblox Studio, o objetivo do carregamento em `ReplicatedFirst` é duplo:
1. **Nunca fazer o jogador esperar à toa**: Carrega estritamente o essencial (timeout de 1s para `IsLoaded`, personagem, preload seletivo com botão de Skip aos 3.5s, handshake de save e `_L.Loaded`).
2. **Nunca engolir erros de desenvolvimento em silêncio**: Se o desenvolvedor deletar acidentalmente uma ScreenGui (`IntroGui`, `Main`, etc.) ou componente essencial, o sistema **NÃO avança em falso** nem gera UIs artificiais para disfarçar o erro. Ele trava e acusa imediatamente no console do Studio via `WaitForChild` (`Infinite yield possible on '...'`), forçando a visualização instantânea do que precisa ser restaurado.

### Diretrizes de Integridade:
1. **Zero Silent Errors**: Proibido usar blocos `pcall` vazios para descartar erros ou mascarar instâncias deletadas.
2. **Alertas Ruidosos e Explicitude no Console**: Referências a instâncias estruturais essenciais utilizam `WaitForChild` direto para que qualquer ausência gere o alerta nativo de `Infinite yield` com o caminho exato no Output.
3. **Modal de Erro Autêntico do PSX (`Error()`)**: Se o handshake de save expirar ou a conexão falhar criticamente, o modal nativo `Notice` do próprio `IntroGui` exibe a mensagem de erro com o botão de reconexão.
4. **Sincronização Contínua e Autônoma**: A IA aplica essa integridade em cada novo script e mantém toda a documentação em `docs/` atualizada em tempo real conforme o jogo é construído.
4. **Game UI Integrity Guard**: Ao finalizar a intro, o sistema audita a existência de ScreenGuis essenciais (`MainButtons`, `MoneyeStrength`, `ShopUI`, etc.) e emite avisos caso alguma tenha sido removida acidentalmente.

---

## 4. Estrutura de Diretórios em `src/`

- **`src/ReplicatedFirst/`**:
  - `Intro.local.luau`: Controlador central da tela de carregamento, animações tween, skip e fail-fast.
- **`src/ReplicatedStorage/`**:
  - `Framework/Library.luau`: Localizador de serviços (`_L`) unificado via metatable `__index`.
  - `Framework/Network.luau`: Abstração de Remotes (`Fire`, `Fired`, `Invoke`, `Invoked`).
  - `Directory/`: Tabelas puras de dados estáticos (preços, status, ovos, picaretas, animais).
    - `Rarity/Rarity.luau`: Tabela de raridades unificada (`Common`, `Rare`, `Epic`, `Legendary`, `Mythical`, `Secret`, `Cosmic`, `Eternal`, `Divine`, `Exclusive`).
    - `Eggs/`: Definições modulares de ovos seguindo o padrão PS99 (`Zone Eggs/` e `Exclusive Eggs/`), com carregamento recursivo pela `Library`.
    - `Saving/DefaultStats.luau`: Template do jogador, versionamento de chave (`StatsVersion = "PlayerData_v1"`), tetos offline e blacklist de rede.
  - `Directory/Stages/StagesList.luau`: Tabela de 22 estágios de paredes com balanceamento de vida e multiplicadores.
  - `Libray/Client/StageClientCmds.luau`: Quebra, ocultação local de paredes e VFX de fragmentos (padrão MinePerClick).
- **`src/ServerScriptService/`**:
  - `GameServer.server.luau`: Ponto de entrada do servidor.
  - `Packages/ProfileStore/ProfileStore.luau`: Motor de persistência robusto com session locking de verdade.
  - `Library/init.luau`: Inicializador dos serviços de servidor.
  - `Library/Saving.luau`: Camada unificada de persistência (wrapper Velvet sobre o ProfileStore com fail-fast, auto-reconcile e suporte a mock).
  - `Library/StageServer.luau`: Controle server-authoritative de HP de paredes por jogador, anti-spam e quebra local.
  - `Library/PickaxeServer.luau`: Equipamento e entrega automática de picaretas na mão do jogador ao spawnar (padrão ref_MinePerClick).
  - `Library/PlayerDataServer.luau`: Estado do jogador consumindo `Saving.luau`, renda passiva, lucros offline e handshake `intro`.
  - `Library/TrainingServer.luau`: Mecânica server-authoritative de treino duplo (Força na Rocha e Velocidade na Esteira).
  - `Library/AreaEggServer.luau`: Ciclo de spawn de ovos nos ninhos por distância/raridade (Padrão PSX Worlds).
  - `Library/EggBreakServer.luau`: Mecânica server-authoritative de quebra de ovos.
  - `Library/BossChaseServer.luau`: IA de perseguição do Boss aos ladrões de ovos até o limite da Safe Zone.
  - `Library/CarryServer.luau`: Gestão do estado de carregar ovos nas costas, peso e redutor de velocidade.
- **`src/StarterPlayerScripts/`**:
  - `Scripts/GameClient.local.luau`: Detecção contínua por hitbox nos Stages (`Workspace.Stages`) e disparo automático de mineração e VFX.
  - `Scripts/GUIs/Toolbar.local.luau`: Gestão dinâmica da barra de ferramentas (`Main.Frame.Toolbar`) a partir de `ReplicatedStorage.Assets.UI.ToolBar.Template`, desativando a Backpack nativa do Roblox (`Enum.CoreGuiType.Backpack`), fixando a Picareta obrigatoriamente no Slot 1, exibindo `KeyboardNumber` apenas em PC, renderizando o ícone em `.Frame.Icon` e criando slots adicionais apenas quando o jogador pega um ovo/item.
  - `Scripts/GUIs/*.local.luau`: Scripts isolados de interface do usuário com controle de estado.
- **`tests/`**:
  - `Saving.spec.luau`: Suíte automatizada de reconciliação de dados legados, ganhos offline e limites do DataStore.

---

## 5. Camada de Persistência (ProfileStore Encapsulado)

- **Session Locking Real**: Impede duplicação de itens entre múltiplos servidores através da posse de sessão exclusiva por `JobId`.
- **Zero Vazamento de Abstração**: O restante do jogo interage exclusivamente via `Saving.Get(player)` e `Saving.IsLoaded(player)`.
- **Reconcile Automático**: Campos novos adicionados a `DefaultStats.Template` são injetados automaticamente em perfis antigos sem corromper saves existentes.
- **Fail-Fast no Boot**: Se o DataStore falhar repetidamente ou houver erro irrecuperável, o jogador é desconectado com aviso para evitar que jogue sem save e perca progresso.

---

## 6. Regra de Sincronização Obrigatória de Documentação (Doc-Sync Rule)

- Sempre que qualquer alteração de relevância for introduzida (novos endpoints de rede, esquemas de dados, regras de save ou reformulação de fluxos), a documentação em `docs/` **DEVE** ser atualizada no mesmo commit/etapa.
- Nenhuma feature ou refatoração é considerada concluída sem a documentação técnica correspondente.

