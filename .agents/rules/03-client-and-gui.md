---
trigger: glob
globs: "src/ReplicatedStorage/Library/Client/**/*.luau, src/StarterPlayerScripts/**/*.luau, ReplicatedStorage/Library/Client/**/*.luau, StarterPlayerScripts/**/*.luau"
description: "Regras para organização de pastas de cliente, módulos utilitários (Client), scripts de Core, Game e GUIs (.local.luau)."
---

# Regras de Cliente e Interface (`Client` & `GUIs`)

## 1. Organização Estrutural de Pastas no Cliente
- **`ReplicatedStorage/Library/Client/<FeatureCmds>.luau`**: Módulos utilitários de cliente (ex: `StageClientCmds.luau`, `ImportantWindow.luau`).
- **`StarterPlayerScripts/Scripts/Core/<Script>.local.luau`**: Scripts essenciais do cliente (ex: `CoreGui.local.luau`).
- **`StarterPlayerScripts/Scripts/GUIs/<Feature>.local.luau`**: Scripts de interface autônomos (ex: `Toolbar.local.luau`, `WindowController.local.luau`).
- **`StarterPlayerScripts/Scripts/Game/<Feature>.local.luau`**: Scripts de mecânicas e gameplay do cliente.
- **Proibição Absoluta**: NUNCA coloque scripts `.local.luau` soltos na raiz de `StarterPlayerScripts/Scripts/`.

## 2. Separação Estrita: `<FeatureCmds>.luau` vs `<Feature>.local.luau`
- **`ReplicatedStorage/Libray/Client/<FeatureCmds>.luau`**: Expõe funções utilitárias de cliente, leitura formatada de estado local, predição visual e wrappers de chamada `Library.Network.Invoke(...)`. Não deve manipular elementos de `ScreenGui` diretamente se isso acoplar o módulo a uma janela específica.
- **`StarterPlayerScripts/Scripts/GUIs/<Feature>.local.luau`**: Gerencia exclusivamente o ciclo de vida, conexões de botões, animações e atualização visual de um único painel/janela. Cada janela é autônoma.
- **Engenharia Reversa**: Antes de criar fluxos de UI do zero, inspecione `ref_PSX/StarterPlayerScripts/Scripts/GUIs/` para reutilizar padrões testados de debounce, transições visuais e gerenciamento de estado.

## 2. Programação Defensiva de UI e Flags de Estado (`Library.Variables`)
- Antes de abrir modais, iniciar transições de câmera, disparar animações de hatch/teleport ou enviar chamadas de rede por clique de botão, verifique sempre as flags de ocupação em `Library.Variables`:
  ```luau
  if Library.Variables.Busy or Library.Variables.Teleporting or Library.Variables.PromptOpen then
      return
  end
  ```
- Sempre utilize `xpcall` / `pcall` com limpeza garantida ao alterar flags temporárias de UI (`Library.Variables.Busy = true` ou `isProcessingClick = true`), garantindo que um erro ou timeout de rede nunca trave a interface do jogador permanentemente.
- Desconecte conexões dinâmicas (`RBXScriptConnection`) ou limpe instâncias visuais temporárias quando os elementos de UI ou modelos forem destruídos, evitando *memory leaks* em sessões longas.
