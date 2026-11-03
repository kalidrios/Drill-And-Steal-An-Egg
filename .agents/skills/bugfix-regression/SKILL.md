---
name: bugfix-regression
description: Corrige bugs reproduzindo primeiro o estado exato da falha em um teste automatizado de regressão (metodologia Fabio Akita / Flow #663) e validando as diretrizes do Framework Velvet.
---

# Workflow: Bugfix com Teste de Regressão (`/bugfix-regression`)

Nunca aplique um "chute" direto no código. Execute este procedimento determinístico:

1. **Isolamento do Estado da Falha**:
   - Identifique os dados exatos de entrada e o estado do jogo (`Library.Variables`, dados do `Directory` e estado do jogador) no momento em que o bug ocorre.
   - Não rode o jogo inteiro do zero manualmente: isole a função ou handler onde a transição de estado falha.

2. **Teste de Regressão (Red Phase)**:
   - Escreva ou adicione um caso de teste em `tests/` que injeta exatamente o estado problemático e demonstra a falha atual.
   - Se o bug envolver comunicação Cliente-Servidor (`Library.Network`), inclua o payload exato que disparou o erro.

3. **Correção Mínima e Defensiva (Green Phase)**:
   - Corrija a lógica respeitando os limites do Framework Velvet:
     - Nunca mova regra de negócio do Servidor para o Cliente.
     - Nunca adicione números mágicos fora de `ReplicatedStorage/__DIRECTORY/`.
     - Adicione um comentário de proveniência (`-- WHY: ...`) explicando qual bug motivou aquela guarda para que futuras sessões de IA não removam a proteção em refatorações.

4. **Verificação de Efeitos Colaterais**:
   - Garanta que todas as flags de `Library.Variables` (como `Busy`) são restauradas em todos os caminhos de retorno (*early returns*) e que os testes passam sem regressão.
