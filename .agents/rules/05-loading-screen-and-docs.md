---
trigger: glob
globs: "src/ReplicatedFirst/**/*.luau, src/StarterPlayerScripts/**/*.luau, docs/**/*.md, ReplicatedFirst/**/*.luau"
description: "Regras para o Framework de Loading Screen em ReplicatedFirst, verificação Fail-Fast contra deleção acidental de UIs/scripts e sincronização contínua de documentação."
---

# Diretrizes de ReplicatedFirst, Fail-Fast de UI e Documentação Contínua

## 1. Sincronização Obrigatória de Documentação (Doc-Sync Rule)
Toda mudança importante no projeto DEVE ser imediatamente documentada em `docs/`:
- **Novas Features & Lógica de Jogo**: Atualizar `docs/game_design/core_loop.md` e criar a decisão em `docs/decisions/`.
- **Arquitetura & Networking**: Atualizar `docs/ARCHITECTURE.md` sempre que remotes, serviços ou módulos forem adicionados ou modificados.
- **Estruturas de Dados**: Documentar campos novos ou modificados em `Directory`.
- **Nenhum Código Sem Documentação**: É terminantemente proibido finalizar uma tarefa sem sincronizar a documentação correspondente.

## 2. Core Loop de Carregamento em ReplicatedFirst (Padrão Fiel `ref_PSX`)
Todo o ciclo de entrada do jogador roda em `src/ReplicatedFirst/Intro/Intro.local.luau` e obedece estritamente ao Core Loop do `ref_PSX`: **carrega apenas o essencial sem fazer o jogador mofar, mas nunca engole erros de assets ausentes**.

- **Carregamento Estritamente Seletivo (Sem Esperas Desnecessárias)**:
  1. **Stage 1 (IsLoaded)**: Aguarda `game:IsLoaded()` com teto de até **1.0 segundo**.
  2. **Stage 2 (Character)**: Aguarda unicamente `LocalPlayer.Character` e seu `Humanoid`.
  3. **Stage 3 (Preload Seletivo com Skip)**: Preload leve apenas de instâncias raízes (`Workspace.Things` / `Workspace.Stages`). Aos **3.5 segundos** faz surgir o botão de **Skip** para conexões lentas (limite máximo de 10s).
  4. **Stage 4 (Handshake de Save & Ban)**: Ping no servidor via remote de intro (`workspace.Things.Remotes.intro:InvokeServer(true)`) para validar save do `ProfileStore` e bans.
  5. **Stage 5 (Framework Boot & Revert)**: Restaura CoreGui (`SetCoreGuiEnabled("All", true)`), aguarda `ReplicatedStorage.Framework.Library` (`_L.Loaded == true`, timeout de 15s) e executa `Revert()` para liberar o jogo.

## 3. Integridade Rígida: Proibição de Mascarar Falhas e Detecção de UI Deletada
- **Zero Silent Errors & Zero Fallbacks Artificiais**:
  - NUNCA capture erros em blocos `pcall` vazios para contornar falhas de estrutura.
  - NUNCA crie UIs de fallback geradas dinamicamente para mascarar a ausência de UIs essenciais do projeto (como `IntroGui`, `Frame`, `Logo`, `Notice`, `Main`, `Template`).
- **Comportamento Rígido ao Deletar UI/Script Essencial**:
  - Se o desenvolvedor deletar acidentalmente uma ScreenGui ou elemento essencial, o sistema **NÃO DEVE avançar nem carregar o jogo em falso**.
  - O código deve travar e acusar imediatamente no console do Studio via avisos explícitos e `WaitForChild` (`Infinite yield possible on '...'`), deixando claro no Output qual elemento foi removido para correção imediata pelo desenvolvedor.
- **Protocolo de Autonomia da IA (Sem Necessidade de Lembretes)**:
  - Conforme o jogo vai sendo construído, a IA DEVE aplicar essa integridade estrutural em cada novo script e UI de forma 100% autônoma.
  - Toda nova implementação deve manter o `docs/` sincronizado automaticamente (`docs/ARCHITECTURE.md`, `docs/game_design/core_loop.md` e `docs/decisions/`), sem depender de solicitações repetidas do usuário.
