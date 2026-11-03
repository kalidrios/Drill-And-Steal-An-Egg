---
name: velvet-audit
description: Audita arquivos Luau em busca de violações do Framework Velvet/PSX, Clean Room Engineering (IDs proprietários de assets), variáveis ofuscadas (v1/m3), AI slop, dados hardcoded e brechas de rede.
---

# Workflow: Auditoria Hostil Velvet & Clean Code (`/velvet-audit`)

Atue como um auditor implacável ("evidence over narrative"). Inspecione os arquivos criados ou modificados em `src/` procurando cada uma das violações abaixo e gere uma tabela de conformidade antes de aprovar:

1. **Checklist de Clean Room Engineering & Nomenclatura**:
   - [ ] **Zero IDs Copiados de `ref_*`**: Algum ID de asset (som, animação, malha, textura, badge, gamepass) foi copiado diretamente de `ref_*` em vez de ser mantido como placeholder e perguntado ao desenvolvedor? (Bloqueador)
   - [ ] **Zero Variáveis de Decompilação**: Existem variáveis com nomes como `v1`, `v2`, `m3`, `p1`, `table1`, `bool1` em vez de identificadores semânticos e legíveis por humanos? (Bloqueador)
   - [ ] **Comentários Equilibrados**: O código evita comentários óbvios em excesso, mantendo apenas seções e justificativas defensivas (*WHY*) no padrão `ref_PSX`?

2. **Checklist de Conformidade do Framework Velvet**:
   - [ ] **Escopo `src/`**: Todo código novo reside exclusivamente dentro de `src/` e nenhuma modificação foi feita em `ref_*`? (Bloqueador)
   - [ ] **Acesso Unificado**: Algum script fez `require()` direto em módulos de `ServerScriptService.Library` ou `ReplicatedStorage.Libray.Client` em vez de usar `require(ReplicatedStorage.Framework.Library)`? (Bloqueador)
   - [ ] **Boot Assíncrono**: Todos os scripts de ciclo de vida possuem `while not Library.Loaded do RunService.Heartbeat:Wait() end` antes de acessar módulos da `Library`? (Bloqueador)
   - [ ] **Zero Remotes Diretos**: Há alguma referência direta a `RemoteEvent`, `RemoteFunction`, `:FireServer()`, `:InvokeServer()` ou `.OnServerEvent` fora da implementação interna de `Library.Network`? (Bloqueador)
   - [ ] **Zero Hardcoded Balance Data**: Há tabelas de status, preços, probabilidades, cooldowns ou multiplicadores hardcoded em `ServerScriptService` ou `StarterPlayerScripts` em vez de `src/ReplicatedStorage/__DIRECTORY/`? (Bloqueador)

3. **Checklist de Segurança e Programação Defensiva**:
   - [ ] **Validação de Payload no Servidor**: Todo `Library.Network.Fired` e `Library.Network.Invoked` no servidor valida `type()` de cada argumento, checa `x ~= x` (NaN), verifica limites (`> 0`, `math.floor`) e valida posse/saldo no servidor?
   - [ ] **Checagem de Yields**: Há validação de `player.Parent == Players` após yields assíncronos (`task.wait`, `DataStore`) para evitar dupe de desconexão?
   - [ ] **Guarda de Estado na UI**: Os scripts em `StarterPlayerScripts/Scripts/GUIs/*.local.luau` checam flags de ocupação em `Library.Variables` antes de abrir janelas ou disparar ações?
   - [ ] **Fail-Fast (Zero Erros Engolidos)**: Nenhum `pcall` descarta erros em silêncio? Há validação defensiva contra UIs ou scripts deletados acidentalmente com avisos ruidosos no console e tela?

4. **Checklist de Documentação & ReplicatedFirst**:
   - [ ] **Sincronização com `docs/`**: Todas as mudanças arquiteturais, remotes, novas features ou dados foram documentadas nos arquivos Markdown de `docs/`?
   - [ ] **Pipeline ReplicatedFirst**: A tela de loading segue os 5 estágios do padrão `ref_PSX` e possui fallback visual contra assets faltantes?

5. **Checklist Clean Code para Agentes (Akita)**:
   - [ ] **Tamanho e Complexidade**: Algum arquivo passou de 400 linhas ou alguma função passou de 25 linhas / 2 níveis de indentação?
   - [ ] **Nomes Greppable**: Existem variáveis ou funções com nomes vagos (`data`, `handler`, `process`, `temp`)?
   - [ ] **Tipagem e Proveniência**: Todos os arquivos iniciam com `--!strict` e preservam os comentários `-- WHY:`?

