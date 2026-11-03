---
name: blind-spots
description: "Atua como um Engenheiro Sênior/Mentor analisando o código ou feature atual para revelar 'o que você não sabe que não sabe' (pontos cegos não pedidos no prompt, falhas de concorrência, memory leaks e trade-offs entre Segurança, Performance, Usabilidade e Manutenabilidade)."
---

# Workflow: Mentor de Pontos Cegos e Trade-offs (`/blind-spots`)

O desenvolvedor não tem como pedir proteções para problemas que ele ainda não sabe que existem, e jogar "todas as técnicas na mesma panela" gera over-engineering. Analise a feature ou módulo alvo em `src/` respondendo objetivamente aos 4 blocos abaixo:

1. **O Que Você Não Pediu, Mas Pode Quebrar em Produção (Unknown Unknowns)**:
   - **Concorrência & Race Conditions**: O que acontece se o jogador disparar `Library.Network.Invoke` ou `Fire` 50 vezes no mesmo frame ou em dois dispositivos?
   - **Desconexão no Meio do Fluxo**: O que acontece se o jogador sair da partida (`PlayerRemoving`) exatamente durante um `task.wait()`, animação de hatch, trade ou salvamento de perfil? Há risco de *dupe* ou perda de item?
   - **Memory Leaks (Sessões Longas)**: Existem conexões (`RunService`, `Network.Fired`, `TweenService`, eventos de instância) ou tabelas indexadas por `Player` no servidor que nunca são limpas da memória?
   - **Travamento de Estado no Cliente**: Se o servidor demorar ou retornar erro, a flag `Library.Variables.Busy` (ou modal aberto) pode ficar presa em `true` para sempre?

2. **Engenharia Reversa Comparativa**:
   - Como os projetos de referência (`ref_PSX`, `ref_BreakAndStealAnEgg`, etc.) resolveram esse problema específico sem quebrar a arquitetura?

3. **Balanço de Trade-offs (A "Receita Agridoce" de Engenharia)**:
   - Avalie como a implementação atual equilibra os 4 eixos que nunca podem ser 100% ao mesmo tempo:
     - **Segurança (Anti-Exploit)** vs. **Performance de Rede/CPU**
     - **Usabilidade/Responsividade Visual (Client Prediction)** vs. **Simplicidade/Manutenabilidade (Anti-DRY Tóxico)**
   - Aponte onde estamos pagando custo desnecessário ou onde estamos expostos demais.

4. **Plano de Ação Priorizado (Teoria das Correntes — O Elo Mais Fraco)**:
   - Liste no máximo os **3 elos mais fracos** atuais em ordem de criticidade, indicando o ajuste exato dentro do Framework Velvet (`src/ReplicatedStorage/__DIRECTORY`, `src/ServerScriptService/Library`, `src/ReplicatedStorage/Libray/Client` ou `src/StarterPlayerScripts/Scripts/GUIs`) sem criar abstrações desnecessárias.
