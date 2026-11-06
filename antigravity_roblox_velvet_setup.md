# Guia e Arquivos de Configuração Antigravity IDE: Arquitetura Roblox (Padrão Velvet / PSX) + Engenharia de Agentes (Fabio Akita)

Este documento reúne a estrutura de diretórios e o conteúdo integral dos arquivos Markdown de **Rules**, **Workflows** e **Skills** para o Google Antigravity IDE, combinando as diretrizes de engenharia de agentes do Fabio Akita ([Clean Code para Agentes de IA](https://www.akitaonrails.com/2026/04/20/clean-code-para-agentes-de-ia/), [Falando um pouco sobre minhas Skills de IA](https://akitaonrails.com/2026/09/17/falando-um-pouco-sobre-minhas-skills-de-ia/) e [Flow Podcast #663](https://www.youtube.com/watch?v=N3eU-2VIByQ)) com o **Framework Velvet / ref_PSX** em Luau, incluindo as regras de **Clean Room Engineering**, proibição de variáveis ofuscadas (`v1`, `m3`) e arte ASCII/Zalgo nos arquivos estruturais.

## Mapa da Árvore de Arquivos (Global + Workspace)

| Escopo | Caminho do Arquivo | Gatilho (`trigger`) | Papel na Arquitetura |
| :--- | :--- | :--- | :--- |
| **Global (Rule)** | `~/.gemini/GEMINI.md` | Sempre ativo (sem frontmatter) | Princípios universais de Clean Code para Agentes (Akita), protocolo "Eu não sei o que não sei" (exposição proativa de pontos cegos e trade-offs) e proibição de AI slop. |
| **Workspace (Raiz)** | `AGENTS.md` | Sempre ativo (sem frontmatter) | Mapa arquitetural da árvore Roblox/Rojo (`src/` como raiz ativa, `ref_*` como referência de engenharia reversa), contrato de inicialização Velvet (`_L`), Clean Room Engineering e padrão de arte Zalgo. |
| **Workspace Rule 1** | `.agents/rules/01-velvet-core-and-network.md` | `always_on` | Regras pétreas do Framework Velvet: escopo `src/`, Clean Room de IDs, nomes legíveis sem `v1/m3`, acesso via `Library`, boot assíncrono (`Library.Loaded`), camada `Library.Network` e guarda defensiva. |
| **Workspace Rule 2** | `.agents/rules/02-server-authority.md` | `glob` (`"src/ServerScriptService/**/*.luau, ServerScriptService/**/*.luau"`) | Carregada apenas ao editar o Servidor: autoridade, validação de tipos/payloads de rede, anti-exploit, locks de concorrência, checagem pós-yield (`player.Parent == Players`), persistência e testes headless. |
| **Workspace Rule 3** | `.agents/rules/03-client-and-gui.md` | `glob` (`"src/ReplicatedStorage/Libray/Client/**/*.luau, src/StarterPlayerScripts/**/*.luau, ReplicatedStorage/Libray/Client/**/*.luau, StarterPlayerScripts/**/*.luau"`) | Carregada apenas ao editar Cliente/GUI: isolamento de cada janela `.local.luau`, flags de busy em `Library.Variables`, limpeza de `RBXScriptConnection` e predição visual sem regra de negócio. |
| **Workspace Rule 4** | `.agents/rules/04-directory-data.md` | `glob` (`"src/ReplicatedStorage/__DIRECTORY/**/*.luau, ReplicatedStorage/__DIRECTORY/**/*.luau"`) | Carregada apenas ao editar dados estáticos: proibição de lógica em tabelas de balanceamento e consumo estrito via `Library.Directory`. |
| **Workflow / Skill 1** | `.agents/workflows/new-feature.md` (e `.agents/skills/new-feature/SKILL.md`) | Slash Command `/new-feature` | Passo a passo determinístico para criar uma nova feature em `src/` com engenharia reversa em `ref_*` (`__DIRECTORY` → `Server` → `Client` → `GUI` → Teste + Relatório de Pontos Cegos). |
| **Workflow / Skill 2** | `.agents/workflows/bugfix-regression.md` (e `.agents/skills/bugfix-regression/SKILL.md`) | Slash Command `/bugfix-regression` | Fluxo inspirado no [Flow #663](https://www.youtube.com/watch?v=-UA_Rmowx6c): reproduzir estado do bug em teste headless antes de corrigir para impedir regressões. |
| **Workflow / Skill 3** | `.agents/workflows/velvet-audit.md` (e `.agents/skills/velvet-audit/SKILL.md`) | Slash Command `/velvet-audit` | Auditoria hostil inspirada no `pr-audit` do Akita: caça cópia de IDs de `ref_*`, variáveis ofuscadas (`v1`, `m3`), `RemoteEvent` direto, `require` fora da `Library` e brechas de servidor. |
| **Workflow / Skill 4** | `.agents/workflows/blind-spots.md` (e `.agents/skills/blind-spots/SKILL.md`) | Slash Command `/blind-spots` | Modo Mentor ("O que eu não sei que não sei?"): força a IA a revelar o que você não pediu, mas que pode quebrar em produção (race conditions, dupes, memory leaks e trade-offs). |
| **Workflow / Skill 5** | `.agents/workflows/persona-tests.md` (e `.agents/skills/persona-tests/SKILL.md`) | Slash Command `/persona-tests` | Geração de Testes via Personas ([Flow #663](https://www.youtube.com/watch?v=Z8lYUV5aDYo)): simula jogadores (Exploiter, Spammer, Endgame Min-Maxer) para gerar a suíte de testes de estado sem rodar o jogo inteiro. |

---

## 1. Regra Global: `~/.gemini/GEMINI.md`

Salve este conteúdo em `~/.gemini/GEMINI.md` (ou crie pelo botão **Rules -> + Global** no Antigravity IDE).

```markdown
# Global Engineering Rules (Clean Code for AI Agents)

## 1. Code Size & Cognitive Load
- Keep functions between 5 and 25 lines. Do ONE thing per function.
- Keep files under 400 lines (ideally 150-300 lines) so the entire file fits in a single agent read call without line truncation.
- Max 2 levels of indentation. Use guard clauses and early returns (`if not cond then return end`) instead of nested `if/else` pyramids.
- Slop is a defect: never create speculative abstractions, premature base classes, `TODO` placeholders, or drive-by refactors outside the requested scope.

## 2. Greppable & Specific Naming
- Grep is your primary navigation API. Never use generic or decompiled names like `data`, `info`, `handler`, `v1`, `v2`, `m3`, `p1`, `table1`, `bool2`.
- Use distinctive, domain-specific names (e.g., `PetEquipPayloadValidator`, `ZoneUnlockCostCalculator`) that return fewer than 5 hits across the repository when searched via `rg`.

## 3. Explicit Types
- Always enable strict typing (`--!strict` in Luau) at the top of every file.
- Annotate all function parameters, return types, and table/dictionary schemas explicitly. Never use untyped `any` unless wrapping raw external I/O before validation.

## 4. Provenance Comments (WHY, Never WHAT)
- Never write obvious comments describing syntax (e.g., `-- increment i`).
- Always preserve existing comments explaining business rules, edge cases, bug workarounds, or architectural constraints during refactors.
- Add brief provenance comments (`-- WHY: ...`) whenever implementing non-obvious order of operations, network guards, or state fallbacks.

## 5. Defensive Programming & Error Context
- Never trust external or client inputs. Validate types, ranges, NaN, and state flags at the entry boundary.
- Error and `assert` messages must include the offending value and expected shape: `assert(type(petId) == "string", string.format("Invalid petId: got %s (%s), expected string", tostring(petId), type(petId)))`.

## 6. Proactive Mentor Protocol ("Unknown Unknowns" & Trade-Offs)
- Do NOT implement only the naive "happy path" and stay silent about unrequested operational risks. The user cannot ask for safeguards they do not know exist.
- Whenever a prompt is vague or touches game balance, networking, persistence, or concurrency, DO NOT guess silently or throw every possible abstraction into the code ("all ingredients in the pan").
- At the end of every feature or architectural change, explicitly report:
  1. **Unrequested Blind Spots ("What You Didn't Ask For")**: Security, anti-exploit, memory-leak, race-condition, or data-loss edge cases that were either added defensively or require a decision.
  2. **Engineering Trade-Offs (Security vs. Performance vs. Usability vs. Maintainability)**: Explain what trade-off was chosen and ask if the balance matches the project's current phase.

## 7. Headless Testing & Memory Discipline
- Every bug fix must include a deterministic regression test reproducing the exact failure state before applying the fix.
- Document architectural decisions, rejected alternatives, and discovered gotchas in `docs/decisions/` so session compaction never erases project knowledge.
```

---

## 2. Mapa Arquitetural na Raiz do Projeto: `AGENTS.md`

Salve este arquivo na raiz do seu repositório Roblox (`<workspace-root>/AGENTS.md`).

```markdown
# Roblox Project Architecture (Velvet / ref_PSX Pattern)

## Active Development Root: `src/`
- Todo código ativo, novos módulos, interfaces e regras de negócio do jogo são implementados exclusivamente dentro do diretório `src/`.
- As pastas `ref_*` (`ref_PSX`, `ref_BreakAndStealAnEgg`, `ref_MinePerClick`, `ref_StealAnEgg`) são **estritamente referências de leitura para engenharia reversa**. NUNCA modifique ou crie código dentro das pastas `ref_*`.

## Directory Structure Map (dentro de `src/`)
- `src/ReplicatedStorage/Framework/Library.luau`: Unified service/module locator (`_L`) using `__index` metatables.
- `src/ReplicatedStorage/__DIRECTORY/<Category>/<Item>.luau`: Pure static data and balancing tables (Pets, Zones, Upgrades, Quests, Items). Accessed via `Library.Directory.<Category>`.
- `src/ReplicatedStorage/Libray/Client/<FeatureCmds>.luau`: Client-side command modules, visual helpers, UI communication, and client prediction. (Note: preserve exact folder spelling `Libray` used by the framework).
- `src/ServerScriptService/Library/<Feature>.luau`: Server-authoritative business logic, persistence, anti-exploit validation, and state mutation.
- `src/StarterPlayerScripts/Scripts/GUIs/<Feature>.local.luau`: Self-contained GUI lifecycle scripts. Each window/panel manages its own local state and consumes `Library`.
- `tests/`: Headless unit and state-simulation test suites for game rules and network validators.
- `docs/decisions/`: Persistent architectural memory (why a pattern or balance formula was chosen and what alternatives were rejected).

## Golden Architectural Invariants
1. **Active Code in `src/` & Reverse Engineering in `ref_*`**:
   - Desenvolva apenas em `src/`. Consulte `ref_*` para extrair padrões funcionais comprovados, mecânicas e balanceamentos reais de produção sem precisar reinventar a roda.
2. **Unified Access**: Always require the framework via `local Library = require(ReplicatedStorage.Framework.Library)`. Never `require()` sibling modules directly across `ServerScriptService` or `ReplicatedStorage`.
3. **Defensive Boot**: Every lifecycle script (`*.local.luau` or `*.server.luau`) must wait for framework readiness before running logic:
   `while not Library.Loaded do RunService.Heartbeat:Wait() end`
4. **Zero Hardcoded Data**: Numbers, prices, multipliers, cooldowns, and pet/zone stats belong exclusively in `ReplicatedStorage/__DIRECTORY/`.
5. **Abstracted Networking**: Never reference `RemoteEvent` or `RemoteFunction` instances directly. Use `Library.Network.Fire`, `Library.Network.Fired`, `Library.Network.Invoke`, and `Library.Network.Invoked`.
6. **Anti-Toxic DRY**: Keep features isolated. Never merge two GUI scripts or two feature modules into a shared "God Class" just to save a few lines of UI setup code.
7. **Clean Room Engineering & Asset IDs Protocol**:
   - NUNCA copie ou reutilize IDs proprietários das pastas `ref_*` (como IDs de animação, áudio, malhas, textures, badges, gamepasses ou devproducts).
   - Ao portar ou criar um sistema que dependa de IDs de assets, deixe o campo como placeholder sem ID (`""` ou `0`), informe no chat qual era o ID original de referência e pergunte explicitamente ao usuário por qual ID próprio dele deve substituir.
8. **Legibilidade Humana & Proibição de Variáveis Ofuscadas**:
   - É terminantemente proibido utilizar variáveis de decompilação/ofuscação como `v1`, `v2`, `m3`, `p1`, `table1`, `bool2`.
   - Utilize sempre nomes claros, semânticos e legíveis por humanos (ex: `targetPlayer`, `petData`, `zoneConfig`, `isProcessing`).
   - Mantenha comentários comedidos e objetivos no padrão do `ref_PSX`: não exagere explicando o óbvio da sintaxe, documente apenas o raciocínio (*WHY*), constantes e divisórias essenciais.
9. **Arte ASCII / Banner Zalgo nos Arquivos Principais**:
   - Em arquivos estruturais centrais (como os `init.luau` de Library, Network e módulos centrais), preserve o cabeçalho clássico em arte Braille/Zalgo do Velvet Framework:
```luau
--[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⡇⠀⠀⢀⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⡇⠀⠀⢸⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣧⠀⠀⠘⣿⣿⣿⣷⣤⣀⣀⠀⠀⣀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⡄⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣷⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⡆⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⠀⠀⠀⠀⠀⠀⠈⠉⠛⠻⠿⠿⠿⠟⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	Velvet Groups rbx.lua Framework
	-+-+-+- SPECIFICS -+-+-+-
	_L
	===========
]]
```
10. **No Silent Happy-Path Only (Mentor Protocol)**: Always flag unrequested edge cases (player disconnecting mid-transaction, parallel remote spam, UI state lockups, memory leaks) instead of waiting for the developer to discover them in production.
```
