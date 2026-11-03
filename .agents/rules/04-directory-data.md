---
trigger: glob
globs: "src/ReplicatedStorage/Directory/**/*.luau, ReplicatedStorage/Directory/**/*.luau"
description: "Regras para arquitetura orientada a dados em ReplicatedStorage/Directory."
---

# Regras de Dados Estáticos (`ReplicatedStorage/Directory/<Categoria>/<Nome>.luau`)

## 1. Dados Puros e Imutáveis
- Arquivos dentro de `src/ReplicatedStorage/Directory/` devem conter **exclusivamente** tabelas de configuração, metadados visuais e parâmetros de balanceamento (Pets, Zonas, Upgrades, Quests, Itens).
- **Proibido**: Nunca inclua chamadas de rede (`Library.Network`), mutação de estado de jogador, `Instance.new`, loops de `RunService` ou regras de negócio imperativas dentro de `Directory`.
- Exporte sempre tipos explícitos para o schema da categoria e retorne uma tabela limpa indexada pelo identificador canônico do item.
- Qualquer módulo de servidor ou cliente deve ler esses dados via `Library.Directory.<Categoria>[id]`, nunca fazendo `require()` manual nos arquivos de `Directory`.
- **Engenharia Reversa**: Utilize as pastas `ref_PSX/ReplicatedStorage/__DIRECTORY` para inspecionar curvas reais de balanceamento, formatação de raridades e esquemas de dados.
