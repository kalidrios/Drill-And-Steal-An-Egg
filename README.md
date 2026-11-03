# Drill and Steal an Egg ⛏️🥚

Um jogo Roblox combinando mecânicas de mineração progressiva por cliques e extração de ovos raros com escolta até a base segura, desenvolvido com a arquitetura modular **Velvet Framework**.

---

## 🎮 Loop Principal (Core Loop)

1. **Minerar para Baixo**: Perfure camadas com picaretas, ganhando Força (*Strength*).
2. **Coletar Ovos**: Encontre e colete ovos nas profundezas.
3. **Fuga para a Safezone**: Retorne à sua base desviando de perigos ou outros jogadores.
4. **Chocar & Evoluir**: Choque pets que fornecem multiplicadores para cavar mais fundo e mais rápido.
5. **Rebirth & Upgrades**: Reinicie para multiplicadores permanentes e novas áreas.

---

## 🏗️ Estrutura do Projeto

O repositório mantém apenas o código-fonte Luau e a documentação técnica:

```
├── .agents/                 # Regras e workflows dos agentes de IA
├── docs/                    # Game design, economia, balanço e decisões de arquitetura
│   ├── architecture/
│   ├── decisions/
│   └── game_design/
├── src/                     # Código sincronizado com o Roblox Studio
│   ├── ReplicatedFirst/     # Loading screen, intro e fail-fast
│   ├── ReplicatedStorage/   # Framework Velvet, Network e Directory (tabelas de dados)
│   ├── ServerScriptService/ # Velvet Server Services, ProfileStore e GameInit
│   └── StarterPlayerScripts/# Velvet Client Controllers e HUDs
└── .gitignore
```

---

## 🛠️ Tecnologias & Padrões

- **Roblox Luau**: Tipagem estrita e scripts otimizados.
- **Velvet Framework**: Organização modular inspirada em jogos de larga escala (*PSX / PS99*).
- **ProfileStore**: Persistência robusta com suporte a sessão e segurança transacional.
- **Autoridade do Servidor**: Verificação de cliques, dano a camadas e compras 100% no servidor.
