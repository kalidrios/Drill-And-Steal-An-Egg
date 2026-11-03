# Drill and Steal an Egg

Sistema de jogo para Roblox desenvolvido em Luau, combinando progressão por mineração vertical em camadas e mecânica de extração e transporte de ovos até zonas seguras.

Construído sob a arquitetura modular Velvet Framework com separação estrita de responsabilidades, autoridade total do servidor e persistência transacional com ProfileStore.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Arquitetura de Software](#arquitetura-de-software)
- [Estrutura do Repositório](#estrutura-do-repositório)
- [Mecânicas Principais](#mecânicas-principais)
- [Padrões de Engenharia](#padrões-de-engenharia)
- [Configuração do Ambiente](#configuração-do-ambiente)

---

## Visão Geral

O projeto implementa uma experiência competitiva e progressiva onde os jogadores utilizam ferramentas de mineração para perfurar camadas de profundidade crescente. Cada camada requer e concede estatísticas escaláveis (Força, Velocidade e Moedas). Em pontos específicos de profundidade, ovos raros ficam disponíveis para coleta manual, exigindo que o jogador retorne fisicamente à sua base para chocá-los e desbloquear novos multiplicadores.

---

## Arquitetura de Software

A estrutura de código adota o **Velvet Framework**, separando o fluxo de dados em camadas desacopladas:

1. **Camada de Dados Estáticos (Directory)**: Módulos puros em `ReplicatedStorage.Directory` definindo configurações de ovos, pets, picaretas, camadas e raridades.
2. **Camada de Rede Abstrata (Network)**: Encapsulamento de RemoteEvents e RemoteFunctions com verificação de integridade e contratos tipados.
3. **Serviços de Servidor (ServerScriptService)**: Autoridade completa sobre validação de danos, transações financeiras, progressão de estágios e ciclo de vida de dados via ProfileStore.
4. **Controladores de Cliente (StarterPlayerScripts / PlayerGui)**: Gerenciamento unificado de janelas e interfaces via TweenService, interpolação de status e efeitos visuais locais, sem tomada de decisão lógica sobre estados do jogo.

---

## Estrutura do Repositório

```text
├── .agents/
│   ├── rules/                 Regras de conformidade, arquitetura e segurança
│   ├── skills/                Habilidades operacionais de desenvolvimento
│   └── workflows/             Fluxos padronizados de auditoria e implementação
│
├── docs/
│   ├── architecture/          Diagramas e contratos de rede
│   ├── decisions/             Registros de decisão arquitetural (ADRs)
│   └── game_design/           Especificações de balanceamento, economia e loops
│
├── src/
│   ├── ReplicatedFirst/       Sequência de inicialização e fail-fast
│   ├── ReplicatedStorage/
│   │   ├── Directory/         Tabelas e metadados declarativos de gameplay
│   │   ├── Framework/         Módulos centrais (Library, Network, Signals)
│   │   └── Libray/Client/     Controladores visuais e helpers de interface
│   │
│   ├── ServerScriptService/
│   │   ├── Library/           Serviços de autoridade (Saving, Pickaxes, Stages)
│   │   ├── Packages/          Dependências externas de servidor (ProfileStore)
│   │   └── Scripts/Core/      Inicializador do servidor (GameInit)
│   │
│   └── StarterPlayerScripts/
│       └── Scripts/
│           ├── Game/          Clientes de gameplay e replicação local
│           └── GUIs/          Controladores de HUD, barras e modais
│
└── README.md
```

---

## Mecânicas Principais

### Loop de Gameplay
- **Perfuração Vertical**: Validação de distância e velocidade de ataque de picaretas executada no servidor.
- **Extração de Ovos**: Mecânica de risco e recompensa onde itens pesados exigem movimentação até uma área de segurança.
- **Multiplicadores e Pets**: Sistema de acúmulo de estatísticas com bônus percentuais calculados centralmente no servidor.
- **Interface Centralizada**: Gerenciamento de modais via controlador unificado (`ImportantWindow`), com animações coordenadas de câmera, desfoque e tweening de janelas.

---

## Padrões de Engenharia

- **Autoridade Estrita do Servidor**: Nenhum cálculo econômico, concessão de recompensas ou alteração de atributos confia no cliente.
- **Persistência Confiável**: Integração com ProfileStore para prevenção de perda de dados e duplicação em saídas forçadas ou migrações de servidores.
- **Isolamento de Ativos e Código**: Repositório contendo exclusivamente código Luau, regras de governança e documentação técnica.

---

## Configuração do Ambiente

1. Clone o repositório em uma estação de trabalho local:
   ```bash
   git clone https://github.com/kalidrios/Drill-And-Steal-An-Egg.git
   ```
2. Abra o projeto no Roblox Studio.
3. Configure a ferramenta de sincronização de scripts de sua preferência apontando o diretório raiz para a pasta `src/`.
4. Garanta que o acesso às APIs de DataStore esteja habilitado nas configurações de segurança do jogo (*Game Settings > Security > Enable Studio Access to API Services*).
