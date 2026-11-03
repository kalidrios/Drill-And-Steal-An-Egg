# Decisão Arquitetural: Pipeline ReplicatedFirst & Protocolo Fail-Fast Anti-Silent Errors

- **Data**: 2026-10-30
- **Status**: Aprovado e Implementado
- **Contexto**: A inicialização do cliente precisava ser idêntica à do Pet Simulator X (`ref_PSX`), garantindo uma transição fluida com barra de carregamento, pré-carregamento de assets e confirmação de save pelo servidor. Simultaneamente, erros e deleções acidentais de UIs durante o desenvolvimento causavam travamentos em tela preta sem qualquer diagnóstico (erros engolidos em silêncio).

---

## 1. Decisão Adotada
1. **ReplicatedFirst Loading Framework**:
   - Implementado em `src/ReplicatedFirst/Intro.local.luau` seguindo as 5 fases do `ref_PSX`:
     1. `game:IsLoaded()` com timeout defensivo de 1s.
     2. Verificação de `LocalPlayer.Character` e `Humanoid`.
     3. Preload de assets com botão "Pular" (Skip) após 3.5s.
     4. Handshake do servidor via `workspace.__THINGS.__REMOTES.intro`.
     5. Carregamento da biblioteca central (`_L.Loaded`) e auditoria de integridade de UIs.
2. **Protocolo Fail-Fast Anti-Silent Errors**:
   - Nenhum bloco de código pode utilizar `pcall` que descarte erros silenciosamente.
   - Qualquer elemento de UI ou script essencial que falhar ao carregar ou for deletado acidentalmente dispara:
     - Avisos em destaque no console (`warn`).
     - Modal visual estilizado na tela alertando imediatamente o desenvolvedor.
     - Fallback de emergência caso a própria UI de erro tenha sido removida.
3. **Doc-Sync Invariant**:
   - Toda alteração arquitetural, de rede ou dados obriga a atualização imediata da pasta `docs/`.

---

## 2. Alternativas Rejeitadas
- **Loading na StarterPlayerScripts**: Rejeitado porque os scripts de `StarterPlayerScripts` só inicializam após o download de grande parte do jogo, impedindo que a tela de carregamento cubra o carregamento visual inicial.
- **Engolir erros com pcall silencioso**: Rejeitado veementemente, pois impedia o desenvolvedor de descobrir o motivo pelo qual o jogo não funcionava ao deletar UIs por engano.
