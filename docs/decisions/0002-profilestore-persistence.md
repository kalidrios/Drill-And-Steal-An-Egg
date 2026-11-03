# Decisão Arquitetural: Persistência com ProfileStore Encapsulado no Padrão Velvet/PSX

- **Data**: 2026-10-30
- **Status**: Aprovado e Implementado
- **Contexto**: O jogo armazenava o estado do jogador (`Strength`, `Cash`, `EquippedPets`, etc.) exclusivamente em memória volátil (`activeProfiles` em [PlayerDataServer.luau](file:///c:/Users/Reitora%2002/Desktop/ViralProject/src/ServerScriptService/Library/PlayerDataServer.luau)), acarretando perda total de dados ao sair ou reiniciar o servidor. Além disso, valores iniciais estavam hardcoded violando o Invariante 4 do Velvet Framework.

---

## 1. Decisão Adotada

Adotou-se o framework de terceiros de alta maturidade **ProfileStore** (loleris, MIT), encapsulado estritamente atrás do módulo mestre de serviço [ServerScriptService.Library.Saving](file:///c:/Users/Reitora%2002/Desktop/ViralProject/src/ServerScriptService/Library/Saving.luau):

1. **Isolamento de Biblioteca de Terceiros**:
   - O código do jogo (módulos de negócio, gameplay e redes) **nunca** faz `require()` direto no ProfileStore.
   - Todo o acesso ao estado e persistência é feito através da interface padronizada `Saving.Get(player)`, `Saving.IsLoaded(player)` e `Saving.Release(player)`.

2. **Session Locking Real entre Servidores**:
   - Substituição do mecanismo frágil do PSX (`PlayingSession = true` em JSON) pelo session locking distribuído do ProfileStore (via `MessagingService` e aquisição atômica).
   - Elimina riscos de duplicação de itens/pets caso o jogador transite rapidamente entre servidores.

3. **Parametrização Centralizada (`Zero Hardcoded Data`)**:
   - O template inicial, versionamento de schema (`StatsVersion = "PlayerData_v1"`), blacklist de rede e limites de inventário residem exclusivamente em [__DIRECTORY/Saving/DefaultStats.luau](file:///c:/Users/Reitora%2002/Desktop/ViralProject/src/ReplicatedStorage/__DIRECTORY/Saving/DefaultStats.luau).

4. **Sincronização com Handshake de ReplicatedFirst**:
   - O remote de handshake `workspace.__THINGS.__REMOTES.intro` consulta diretamente `Saving.IsLoaded(player)`. O jogador só avança para a gameplay quando os dados persistidos forem completamente confirmados.

5. **Ganhos Offline Defensivos (Offline Earnings)**:
   - Ao logar, o sistema calcula o tempo decorrido desde o último `LastOfflineSync`, respeitando um teto máximo de 12 horas (`MaxOfflineSeconds = 43200`) e creditando moedas geradas pelos pets no cercado.

---

## 2. Alternativas Rejeitadas

- **Port Manual do Saving.luau do PSX**: Rejeitado porque o session locking do PSX apenas gravava um booleano `PlayingSession = true` no DataStore. Em caso de crash de servidor ou timeout, o perfil ficava bloqueado e o sistema do PSX simplesmente ignorava o lock com um warn, abrindo brechas graves de duplicação.
- **DataStore2**: Rejeitado pela dependência de ordered backups desnecessários em comparação com as sessões modernas do ProfileStore.
