---
name: persona-tests
description: Cria agentes/personas especializados nas regras do jogo (Exploiter, Spammer/Laggy Player, Endgame Min-Maxer e Casual Player) para gerar automaticamente casos de teste de estado em código Luau sem precisar jogar manualmente.
---

# Workflow: Geração de Suíte de Testes com Personas (`/persona-tests`)

Em vez de testar manualmente jogando do zero até chegar ao estado de um bug, simule as 4 personas abaixo contra as regras de `src/ReplicatedStorage/__DIRECTORY` e os módulos de `src/ServerScriptService/Library`, gerando casos de teste determinísticos em `tests/`:

1. **Persona 1 — O Exploiter de Rede (Protocol Fuzzer)**:
   - Sabendo como `Library.Network.Fire` e `Invoke` funcionam, tenta enviar payloads maliciosos: `nil`, `NaN` (`0/0`), `math.huge`, números negativos, floats onde deveriam ser inteiros (`1.5` pets), strings gigantes, IDs de itens inexistentes em `Library.Directory` ou IDs de pets que pertencem a outro jogador.
   - **Meta**: Garantir que todos os handlers do servidor rejeitem a chamada sem gerar erro não tratado no console.

2. **Persona 2 — O Jogador com Lag / Auto-Clicker (Race Condition Tester)**:
   - Simula cliques simultâneos e chamadas paralelas antes da resposta da primeira requisição terminar (ex: tentar comprar um upgrade ou equipar/deletar o mesmo pet duas vezes no mesmo tick).
   - **Meta**: Verificar se o lock por `Player.UserId` no servidor e a flag `Library.Variables.Busy` no cliente impedem cobrança dupla ou duplicação de recompensas.

3. **Persona 3 — O Min-Maxer de Endgame (Boundary & Overflow Tester)**:
   - Monta diretamente estados de fim de jogo (banca na casa dos quatrilhões/quintilhões, todos os multiplicadores e pets lendários combinados no limite máximo de `Library.Directory`).
   - **Meta**: Testar diretamente as funções de cálculo para detectar perda de precisão numérica, *overflow*, divisões por zero ou modificadores que perdem efeito quando acumulados.

4. **Persona 4 — O Jogador de Borda de Regra (Rule-Book Validator)**:
   - Transforma cada regra de negócio da feature em uma asserção de código ("Se o jogador tem estado X e executa ação Y com item Z do `Directory`, o estado final deve ser exatamente W").
   - **Saída Obrigatória**: Grave todos os cenários descobertos pelas 4 personas em um arquivo `tests/<Feature>.spec.luau` executável de forma instantânea (*headless*).
