# Balanceamento Completo de Pets e Animais (ViralProject)

> **Documento Gerado com Base em**: `ref_BreakAndStealAnEgg` (`ZoneAnimalsConfig.luau`, `AnimalEggsConfig.luau`, `AnimalRenders.luau`)  
> **Comparações de Estrutura**: `ReplicatedStorage.Directory.Eggs` (139 Egg Meshes) e `ReplicatedStorage.Directory.Animals.Normal` (89 Modelos Standalone + 74 Modelos em Zonas 1 a 9).

---

## 1. Diagnóstico e Comparação de Estrutura

### 1.1 Quantitativo Geral
- **Ovos (`Directory.Eggs`)**: **139 MeshParts de Ovos** no total.  
  - Cada ovo possui formato customizado e mapeia diretamente para a Mesh do ovo do animal correspondente (ex: `AardvarkEgg`, `CatEgg`, `PTERODACTYLEgg`, etc.).
  - 9 Módulos de Ovos de Zona (`Zone 1 Egg` até `Zone 9 Egg`).
  - 2 Módulos Exclusivos (`Exclusive Elemental Egg`, `Limited Egg`).
- **Animais (`Directory.Animals.Normal`)**:
  - **89 Animais Soltos na Raiz** (`Legacy` / Animais disponíveis para ovos temáticos, fusões ou drops secundários).
  - **74 Animais Distribuídos nas Pastas de Zona (`Zone_1` a `Zone_9`)**:
    - `Zone_1` a `Zone_8`: 8 animais cada = 64 animais.
    - `Zone_9`: 10 animais = 10 animais.
    - **Total nas Zonas**: 74 animais.
  - **Total de Animais Únicos Distintos**: **163 animais únicos**.
  - **BreakableEggs (`ReplicatedStorage.Assets.BreakableEggs`)**: **74 modelos de ovos quebráveis** no Workspace/cenário.

---

## 2. Balanceamento por Zona (Zonas 1 a 10)

Os valores de **Cash/s** (renda por segundo no cercado/Plot Pen), **Raridade** e **Chances de Drop no Ovo de Zona** foram extraídos e alinhados diretamente com a economia do `ref_BreakAndStealAnEgg`.

### Zona 1 (Forest / Nível 1)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Chicken** | Common | 46.00% | $1/s |
| **Cat** | Common | 30.00% | $2/s |
| **Bat** | Uncommon | 14.00% | $10/s |
| **Anteater** | Uncommon | 6.50% | $13/s |
| **Badger** | Rare | 2.30% | $35/s |
| **Parrot** | Rare | 0.85% | $45/s |
| **GoldenRetriver** | Epic | 0.30% | $145/s |
| **Bear** | Legendary | 0.05% | $1,800/s |

---

### Zona 2 (Desert / Nível 2)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Snake** | Common | 46.00% | $3/s |
| **Tiger** | Uncommon | 30.00% | $20/s |
| **Lion** | Uncommon | 14.00% | $25/s |
| **Ankylosaurus** | Rare | 6.50% | $90/s |
| **COCKATRICE** | Rare | 2.30% | $110/s |
| **SPHINX** | Epic | 0.85% | $230/s |
| **CHIREMA** | Legendary | 0.30% | $2,800/s |
| **MANTICORE** | Mythic | 0.05% | $12,500/s |

---

### Zona 3 (Plains / Nível 3)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Pigeon** | Uncommon | 46.00% | $40/s |
| **GuiennaPig** | Uncommon | 30.00% | $65/s |
| **Maltese** | Rare | 14.00% | $180/s |
| **Goat** | Rare | 6.50% | $240/s |
| **BichonFrise** | Epic | 2.30% | $650/s |
| **SecretaryBird** | Legendary | 0.85% | $4,500/s |
| **Llama** | Mythic | 0.30% | $18,000/s |
| **Polar Bear** | Divine | 0.05% | $125,000/s |

---

### Zona 4 (Lake / Nível 4)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Bunny** | Uncommon | 46.00% | $84/s |
| **trumpet** | Rare | 30.00% | $224/s |
| **Muscovy Duck** | Rare | 14.00% | $336/s |
| **barracuda** | Epic | 6.50% | $840/s |
| **Moorish idol** | Legendary | 2.30% | $8,400/s |
| **Yak** | Mythic | 0.85% | $46,700/s |
| **Cobra** | Divine | 0.30% | $200,000/s |
| **PREHISTORIC_DRAGONFLY** | Cosmic | 0.05% | $1,500,000/s |

---

### Zona 5 (Ocean Shallow / Nível 5)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Snail** | Rare | 46.00% | $400/s |
| **Goldfish** | Rare | 30.00% | $600/s |
| **Lizard** | Epic | 14.00% | $1,500/s |
| **pufferfish** | Legendary | 6.50% | $15,000/s |
| **Butterflyfish** | Mythic | 2.30% | $83,300/s |
| **stingray** | Divine | 0.85% | $391,000/s |
| **Regal** | Cosmic | 0.30% | $1,340,000/s |
| **PREHISTORIC_MOTH** | Secret | 0.05% | $12,500,000/s |

---

### Zona 6 (Deep Sea / Nível 6)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Cuttlefish** | Rare | 46.00% | $720/s |
| **FangtoothFish** | Epic | 30.00% | $2,700/s |
| **Swordfish** | Legendary | 14.00% | $27,000/s |
| **MantisShrimp** | Mythic | 6.50% | $150,000/s |
| **GoblinShark** | Divine | 2.30% | $703,000/s |
| **LeafySeaDragon** | Cosmic | 0.85% | $2,410,000/s |
| **MEGALODON** | Secret | 0.30% | $16,750,000/s |
| **Amphiptere** | Celestial | 0.05% | $125,000,000/s |

---

### Zona 7 (Prehistoric Volcano / Nível 7)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Jackalope** | Epic | 46.00% | $3,500/s |
| **DIMETRODON** | Legendary | 30.00% | $48,000/s |
| **Brachiosaurus** | Mythic | 14.00% | $267,000/s |
| **Lindworm** | Divine | 6.50% | $1,250,000/s |
| **T-Rex** | Cosmic | 2.30% | $4,290,000/s |
| **Fenrir** | Secret | 0.85% | $24,000,000/s |
| **CERBERUS** | Celestial | 0.30% | $150,000,000/s |
| **Raiju** | Celestial | 0.05% | $180,000,000/s |

---

### Zona 8 (Mystic Forest / Nível 8)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Tanuki** | Legendary | 46.00% | $65,000/s |
| **Surgeonfish** | Mythic | 30.00% | $360,000/s |
| **Mandarinfish** | Divine | 14.00% | $1,800,000/s |
| **DumboOctopus** | Cosmic | 6.50% | $6,500,000/s |
| **Akita** | Secret | 2.30% | $36,000,000/s |
| **Gallimimus** | Celestial | 0.85% | $200,000,000/s |
| **Wolf** | Celestial | 0.30% | $240,000,000/s |
| **SIMURGH** | Celestial | 0.05% | $300,000,000/s |

---

### Zona 9 (Dragons & Dinosaurs / Nível 9)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Crocodile** | Mythic | 46.00% | $500,000/s |
| **Whale** | Divine | 30.00% | $2,500,000/s |
| **Zebra** | Cosmic | 14.00% | $9,000,000/s |
| **THUNDERBIRD** | Secret | 6.50% | $50,000,000/s |
| **ARCHAEOPTERYX** | Secret | 2.30% | $220,000,000/s |
| **WINGED_IMP** | Celestial | 0.85% | $260,000,000/s |
| **CALADRIUS** | Celestial | 0.30% | $330,000,000/s |
| **Velicoraptor** | Inferno | 0.10% | $400,000,000/s |
| **CLASSICDRAGON** | Inferno | 0.05% | $500,000,000/s |
| **QILIN** | Inferno | 0.01% | $750,000,000/s |

---

### Zona 10 (Crystal Void / Nível 10)
| Pet | Raridade | Chance no Ovo | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **Bug** | Divine | 40.00% | $3,000,000/s |
| **CrystalLizard** | Divine | 26.00% | $3,600,000/s |
| **CrystalBeast** | Cosmic | 16.00% | $10,800,000/s |
| **CrystalRaptor** | Secret | 9.00% | $60,000,000/s |
| **CrystalDragon** | Celestial | 5.00% | $312,000,000/s |
| **Mantis** | Celestial | 2.50% | $396,000,000/s |
| **AlienJellyfish** | Inferno | 1.00% | $480,000,000/s |
| **CrystalScorpion** | Inferno | 0.40% | $600,000,000/s |
| **Behemoth** | Inferno | 0.15% | $900,000,000/s |
| **CrystalWolf** | Void | 0.02% | $1,080,000,000/s |
| **CelestialBeast** | Void | 0.01% | $1,296,000,000/s |
| **CelestialSpirit** | Omega | 0.001% | $1,555,200,000/s |

---

## 3. Pets Especiais, Eventos, Bosses e Cercados (Hell & Celestial)

Estes pets não dropam nos ovos normais de zona; pertencem aos ovos do evento Hell, Ovos Celestes e bosses secretos:

### Hell Pets (Ovo Hell / Evento)
| Pet | Raridade | Tier / Zona Relacionada | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **HellCroc** | Secret | Zona 9 | $2,400,000/s |
| **HellAnky** | Secret | Zona 9 | $3,600,000/s |
| **HellTrike** | Secret | Zona 9 | $6,000,000/s |
| **HellDinoRex** | Celestial | Zona 9 | $15,000,000/s |
| **HellMegalodon** | Celestial | Zona 9 | $24,000,000/s |
| **HellTRex** | Celestial | Zona 9 | $42,000,000/s |
| **HellDragon** | Inferno | Zona 9 | $510,000,000/s |
| **HellHydra** | Inferno | Zona 9 | $800,000,000/s |

### Angel / Celestial Pets
| Pet | Raridade | Tier / Zona Relacionada | Renda Base (Cash/s) |
| :--- | :--- | :---: | :---: |
| **AngelCroc** | Secret | Zona 9 | $4,000,000/s |
| **AngelAnky** | Secret | Zona 9 | $6,000,000/s |
| **AngelTrike** | Secret | Zona 9 | $10,000,000/s |
| **AngelMegalodon** | Celestial | Zona 9 | $40,000,000/s |
| **AngelTRex** | Celestial | Zona 9 | $70,000,000/s |
| **AngelDragon** | Inferno | Zona 9 | $850,000,000/s |
| **AngelHydra** | Inferno | Zona 9 | $1,100,000,000/s |
| **CelestialLamb** | Secret | Zona 10 | $220,000,000/s |
| **CelestialSpiritFox** | Celestial | Zona 10 | $360,000,000/s |
| **CelestialFrog** | Inferno | Zona 10 | $600,000,000/s |
| **CelestialAxolotl** | Void | Zona 10 | $950,000,000/s |
| **CelestialGorilla** | Omega | Zona 10 | $1,200,000,000/s |

---

## 4. Tabela dos 89 Animais Legacy (`Directory.Animals.Normal` na raiz)

Estes são os modelos que estão salvos na pasta raiz de `Directory.Animals.Normal` no seu projeto, prontos para uso em ovos temáticos, fusões ou drops:

| # | Nome do Animal | Raridade Oficial (`ref`) | Renda Base Sugerida | Categoria Original |
| :---: | :--- | :--- | :---: | :--- |
| 1 | **Aardvark** | Uncommon | $105/s | Terrestre / Escavador |
| 2 | **Albatross** | Legendary | $4,500/s | Ave Marinha |
| 3 | **Anglerfish** | Rare | $750/s | Aquático Abissal |
| 4 | **ARCHAEOPTERYX** | Secret | $220,000,000/s | Fóssil / Dinossauro |
| 5 | **ARGENTAVIS** | Secret | $180,000,000/s | Ave Pré-Histórica |
| 6 | **Australian Cattle Dog** | Rare | $300/s | Canino |
| 7 | **AZHDARCHID** | Secret | $120,000,000/s | Pterossauro Gigante |
| 8 | **Binturong** | Rare | $50/s | Pequeno Mamífero |
| 9 | **Blobfish** | Legendary | $5,250/s | Criatura Abissal |
| 10 | **Boston Terrier** | Mythic | $42,500/s | Canino |
| 11 | **Boxfish** | Uncommon | $120/s | Aquático |
| 12 | **Bull** | Legendary | $2,500/s | Bovino / Força |
| 13 | **Bunyip** | Secret | $6,000,000/s | Monstro Mitológico |
| 14 | **Capybara** | Cosmic | $825,000/s | Roedor Gigante |
| 15 | **Caracal** | Rare | $175/s | Felino Selvagem |
| 16 | **Cassowary** | Legendary | $15,000/s | Ave Grande |
| 17 | **Cavalier King Charles Spaniel** | Mythic | $50,000/s | Canino |
| 18 | **ChowChow** | Epic | $825/s | Canino |
| 19 | **Chupacabra** | Mythic | $85,000/s | Criptídeo |
| 20 | **CoralGoby** | Uncommon | $80/s | Aquático |
| 21 | **Cow** | Common | $15/s | Fazenda |
| 22 | **Crab** | Common | $8/s | Crustáceo |
| 23 | **Dingo** | Rare | $140/s | Canino Selvagem |
| 24 | **Dullahan** | Celestial | $110,000,000/s | Mitológico Sombrio |
| 25 | **Elephant** | Legendary | $18,000/s | Mamífero Gigante |
| 26 | **Emu** | Uncommon | $70/s | Ave Corredora |
| 27 | **English Bulldog** | Epic | $1,350/s | Canino |
| 28 | **Fossa** | Rare | $60/s | Carnívoro |
| 29 | **Frog** | Rare | $40/s | Anfíbio |
| 30 | **GARGOYLE_BAT** | Cosmic | $12,000,000/s | Quimera Voadora |
| 31 | **GARUDA** | Celestial | $95,000,000/s | Mitológico |
| 32 | **GRIFFIN** | Divine | $540,000/s | Mitológico |
| 33 | **GiantIsopod** | Rare | $280/s | Crustáceo Abissal |
| 34 | **Giraffee** | Epic | $1,200/s | Savana |
| 35 | **Gorilla** | Legendary | $9,500/s | Primata |
| 36 | **Great Dane** | Rare | $400/s | Canino Grande |
| 37 | **HARPY** | Cosmic | $3,200,000/s | Mitológico Voador |
| 38 | **HYDRA** | Secret | $15,000,000/s | Dragão Multi-Cabeças |
| 39 | **Hamster** | Legendary | $7,000/s | Roedor Pequeno |
| 40 | **HoneyBadger** | Uncommon | $35/s | Mustelídeo |
| 41 | **Horse** | Uncommon | $90/s | Montaria |
| 42 | **Hyena** | Legendary | $3,500/s | Carnívoro Savana |
| 43 | **Jackal** | Epic | $355/s | Canino Savana |
| 44 | **Jellyfish** | Uncommon | $95/s | Aquático Invertebrado |
| 45 | **KRAKEN** | Cosmic | $5,250,000/s | Monstro Marinho |
| 46 | **Kangaroo** | Epic | $2,100/s | Marsupial |
| 47 | **Kappa** | Cosmic | $1,350,000/s | Mitológico Aquático |
| 48 | **Kitsune** | Celestial | $45,000,000/s | Raposa Mística 9 Caudas |
| 49 | **Koala** | Legendary | $8,000/s | Marsupial |
| 50 | **Kookaburra** | Uncommon | $110/s | Ave |
| 51 | **LEVIATHAN** | Secret | $40,000,000/s | Serpente Marinha Épica |
| 52 | **Lionfish** | Rare | $450/s | Aquático Venenoso |
| 53 | **MICRORAPTOR** | Mythic | $130,000/s | Dinossauro Voador |
| 54 | **MINOTAUR** | Secret | $22,000,000/s | Besta Mitológica |
| 55 | **MOTHMAN** | Cosmic | $1,500,000/s | Criptídeo |
| 56 | **Mamoth** | Divine | $165,000/s | Fóssil de Gelo |
| 57 | **Mosasaurus** | Cosmic | $8,500,000/s | Réptil Marinho Gigante |
| 58 | **Nautilus** | Rare | $550/s | Molusco Marinho |
| 59 | **Ostrich** | Legendary | $3,000/s | Ave Veloz |
| 60 | **Owl** | Legendary | $1,750/s | Ave Noturna |
| 61 | **PEGASUS** | Cosmic | $2,100,000/s | Cavalo Alado Divino |
| 62 | **PLESIOSAUR** | Mythic | $280,000/s | Réptil Pré-Histórico |
| 63 | **PTERANODON** | Secret | $35,000,000/s | Pterossauro |
| 64 | **PTERODACTYL** | Secret | $48,000,000/s | Pterossauro |
| 65 | **Papillon** | Legendary | $9,000/s | Canino Pequeno |
| 66 | **Pony** | Divine | $275,000/s | Equino Pequeno |
| 67 | **QUETZALCOATLUS** | Celestial | $80,000,000/s | Maior Voador da Terra |
| 68 | **Quokka** | Cosmic | $750,000/s | Marsupial Sorridente |
| 69 | **ROC** | Cosmic | $4,800,000/s | Ave Titânica |
| 70 | **STEGOSAURUS** | Secret | $18,000,000/s | Dinossauro com Placas |
| 71 | **STYMPHALIANBIRD** | Celestial | $75,000,000/s | Ave com Penas de Bronze |
| 72 | **Seahorse** | Epic | $1,200/s | Aquático Pequeno |
| 73 | **Seal** | Mythic | $25,000/s | Mamífero Marinho |
| 74 | **Serval** | Uncommon | $150/s | Felino Veloz |
| 75 | **Shark** | Epic | $1,800/s | Predador Marinho |
| 76 | **Shoebill** | Secret | $5,000,000/s | Ave Pré-Histórica |
| 77 | **Spinosaurus** | Cosmic | $6,000,000/s | Predador Dinossauro |
| 78 | **Triceratops** | Secret | $14,000,000/s | Dinossauro 3 Chifres |
| 79 | **TripleCobra** | Secret | $7,000,000/s | Serpente de 3 Cabeças |
| 80 | **Turtle** | Divine | $330,000/s | Réptil Casco Duro |
| 81 | **Unicorn** | Epic | $1,500/s | Criatura de Chifre Mágico |
| 82 | **WYVERN** | Cosmic | $2,500,000/s | Dragão Bípede Alado |
| 83 | **Wrasse** | Uncommon | $140/s | Aquático Coral |
| 84 | **YI_QI** | Mythic | $95,000/s | Dinossauro Asa de Morcego |
| 85 | **archerfish** | Cosmic | $1,200,000/s | Peixe Caçador de Jato |
| 86 | **cowfish** | Rare | $320/s | Peixe Caixa Chifre |
| 87 | **hawkfish** | Uncommon | $110/s | Peixe Falcão |
| 88 | **sailfish** | Epic | $2,400/s | Peixe Mais Rápido |
| 89 | **wobbegong** | Divine | $375,000/s | Tubarão Tapete Camuflado |

---

## 5. Mapeamento de Ovos no Mundo & Coleta
Na mecânica atual do jogo (**Cavar para Baixo** estilo `MinePerClick` + **Roubar e Carregar** estilo `StealAnEgg`):
1. **O jogador cava os blocos/stages para baixo** usando sua picareta.
2. Em determinadas profundidades/camadas (ou ninhos das profundezas), encontra os **Ovos Roubáveis** gerados diretamente a partir de `ReplicatedStorage.Directory.Eggs`.
3. O jogador pega o ovo, o ovo é equipado/segurado nas mãos ou nas costas, e ele precisa **subir/fugir de volta para a Safe Zone** para depositar no seu cercado (Plot).
4. `Assets.BreakableEggs` foi removido por ser redundante, deixando o jogo 100% limpo e focado no ciclo direto: **Cavar -> Pegar Ovo de `Directory.Eggs` -> Fugir para a Base**.

---

## 6. Multiplicadores de Variante de Pet (Gold & Diamond)

Seguindo o padrão de balanceamento de multiplicador de renda no cercado:
- **Normal**: `1.0x` Renda Base.
- **Gold**: `3.0x` Renda Base (`Directory.Animals.Gold`).
- **Rainbow**: `7.5x` Renda Base.
- **Diamond**: `15.0x` Renda Base (`Directory.Animals.Diamond`).
- **Shiny**: Bônus cumulativo de `+50%` sobre o valor calculado.

