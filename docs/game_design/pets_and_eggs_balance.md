# Balanceamento de Pets e Associação de Ovos
Engenharia reversa extraída diretamente de `ref_BreakAndStealAnEgg` (`ZoneAnimalsConfig.luau`, `EggConfig.luau` e `EggRewards.luau`).

## 1. Visão Geral da Mecânica de Drop & Ovos
- **Cada Zona possui 3 Ovos temáticos** (Tier 1, Tier 2 e Tier 3).
- **Sorte (Luck) do Ovo:**
  - **Tier 1 (Base):** Multiplicador de Sorte `1.0x`
  - **Tier 2 (Médio):** Multiplicador de Sorte `1.1x` (Chance Bias `2.5x` para pets raros)
  - **Tier 3 (Top da Zona):** Multiplicador de Sorte `1.25x` (Chance Bias `6.0x` para pets raros)
- **Variantes Dourada e Diamante:**
  - **Normal:** 1x Moedas/seg | Peso padrão
  - **Gold:** 2x Moedas/seg | Chance de hatch: `1.0%`
  - **Diamond:** 4x Moedas/seg | Chance de hatch: `0.25%`

---
## 2. Tabelas por Zona (Pets, Chances, Renda e Ovos Onde Conseguir)

### Zona 1: Forest
**Ovos que chocam esta Zona:**
- **Forest Egg** (Tier 1) — HP da Parede/Ovo: `5` | Luck Multiplier: `1.0x`
- **Rock Egg** (Tier 2) — HP da Parede/Ovo: `10` | Luck Multiplier: `1.1x`
- **Swamp Egg** (Tier 3) — HP da Parede/Ovo: `15` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Chicken** | Common | 46.0% | 1 | 2 | 4 |
| **Cat** | Common | 30.0% | 2 | 4 | 8 |
| **Bat** | Uncommon | 14.0% | 10 | 20 | 40 |
| **Anteater** | Uncommon | 6.5% | 13 | 26 | 52 |
| **Badger** | Rare | 2.3% | 35 | 70 | 140 |
| **Parrot** | Rare | 0.85% | 45 | 90 | 180 |
| **GoldenRetriver** | Epic | 0.3% | 145 | 290 | 580 |
| **Bear** | Legendary | 0.05% | 1,800 | 3,600 | 7,200 |

---

### Zona 2: Desert
**Ovos que chocam esta Zona:**
- **Cactus Egg** (Tier 1) — HP da Parede/Ovo: `75` | Luck Multiplier: `1.0x`
- **Bones Egg** (Tier 2) — HP da Parede/Ovo: `100` | Luck Multiplier: `1.1x`
- **Scorpion Egg** (Tier 3) — HP da Parede/Ovo: `150` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Snake** | Common | 46.0% | 3 | 6 | 12 |
| **Tiger** | Uncommon | 30.0% | 20 | 40 | 80 |
| **Lion** | Uncommon | 14.0% | 25 | 50 | 100 |
| **Ankylosaurus** | Rare | 6.5% | 90 | 180 | 360 |
| **COCKATRICE** | Rare | 2.3% | 110 | 220 | 440 |
| **SPHINX** | Epic | 0.85% | 230 | 460 | 920 |
| **CHIREMA** | Legendary | 0.3% | 2,800 | 5,600 | 11,200 |
| **MANTICORE** | Mythic | 0.05% | 12,500 | 25,000 | 50,000 |

---

### Zona 3: Snowy
**Ovos que chocam esta Zona:**
- **Frozen Egg** (Tier 1) — HP da Parede/Ovo: `1,000` | Luck Multiplier: `1.0x`
- **Frosty Egg** (Tier 2) — HP da Parede/Ovo: `2,000` | Luck Multiplier: `1.1x`
- **Yeti Egg** (Tier 3) — HP da Parede/Ovo: `3,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Pigeon** | Uncommon | 46.0% | 40 | 80 | 160 |
| **GuiennaPig** | Uncommon | 30.0% | 65 | 130 | 260 |
| **Maltese** | Rare | 14.0% | 180 | 360 | 720 |
| **Goat** | Rare | 6.5% | 240 | 480 | 960 |
| **BichonFrise** | Epic | 2.3% | 650 | 1,300 | 2,600 |
| **SecretaryBird** | Legendary | 0.85% | 4,500 | 9,000 | 18,000 |
| **Llama** | Mythic | 0.3% | 18,000 | 36,000 | 72,000 |
| **Polar Bear** | Divine | 0.05% | 125,000 | 250,000 | 500,000 |

---

### Zona 4: Candy
**Ovos que chocam esta Zona:**
- **Rainbow Egg** (Tier 1) — HP da Parede/Ovo: `20,000` | Luck Multiplier: `1.0x`
- **Easter Bunny Egg** (Tier 2) — HP da Parede/Ovo: `50,000` | Luck Multiplier: `1.1x`
- **Candy Egg** (Tier 3) — HP da Parede/Ovo: `100,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Bunny** | Uncommon | 46.0% | 84 | 168 | 336 |
| **trumpet** | Rare | 30.0% | 224 | 448 | 896 |
| **Muscovy Duck** | Rare | 14.0% | 336 | 672 | 1,344 |
| **barracuda** | Epic | 6.5% | 840 | 1,680 | 3,360 |
| **Moorish idol** | Legendary | 2.3% | 8,400 | 16,800 | 33,600 |
| **Yak** | Mythic | 0.85% | 46,700 | 93,400 | 186,800 |
| **Cobra** | Divine | 0.3% | 200,000 | 400,000 | 800,000 |
| **PREHISTORIC_DRAGONFLY** | Cosmic | 0.05% | 1,500,000 | 3,000,000 | 6,000,000 |

---

### Zona 5: Lake
**Ovos que chocam esta Zona:**
- **Gooey Egg** (Tier 1) — HP da Parede/Ovo: `400,000` | Luck Multiplier: `1.0x`
- **Tree Egg** (Tier 2) — HP da Parede/Ovo: `1,000,000` | Luck Multiplier: `1.1x`
- **Lake Egg** (Tier 3) — HP da Parede/Ovo: `2,000,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Snail** | Rare | 46.0% | 400 | 800 | 1,600 |
| **Goldfish** | Rare | 30.0% | 600 | 1,200 | 2,400 |
| **Lizard** | Epic | 14.0% | 1,500 | 3,000 | 6,000 |
| **pufferfish** | Legendary | 6.5% | 15,000 | 30,000 | 60,000 |
| **Butterflyfish** | Mythic | 2.3% | 83,300 | 166,600 | 333,200 |
| **stingray** | Divine | 0.85% | 391,000 | 782,000 | 1,564,000 |
| **Regal** | Cosmic | 0.3% | 1,340,000 | 2,680,000 | 5,360,000 |
| **PREHISTORIC_MOTH** | Secret | 0.05% | 12,500,000 | 25,000,000 | 50,000,000 |

---

### Zona 6: Under Water
**Ovos que chocam esta Zona:**
- **Sea Stones Egg** (Tier 1) — HP da Parede/Ovo: `10,000,000` | Luck Multiplier: `1.0x`
- **Sea Egg** (Tier 2) — HP da Parede/Ovo: `25,000,000` | Luck Multiplier: `1.1x`
- **Water Egg** (Tier 3) — HP da Parede/Ovo: `50,000,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Cuttlefish** | Rare | 46.0% | 720 | 1,440 | 2,880 |
| **FangtoothFish** | Epic | 30.0% | 2,700 | 5,400 | 10,800 |
| **Swordfish** | Legendary | 14.0% | 27,000 | 54,000 | 108,000 |
| **MantisShrimp** | Mythic | 6.5% | 150,000 | 300,000 | 600,000 |
| **GoblinShark** | Divine | 2.3% | 703,000 | 1,406,000 | 2,812,000 |
| **LeafySeaDragon** | Cosmic | 0.85% | 2,410,000 | 4,820,000 | 9,640,000 |
| **MEGALODON** | Secret | 0.3% | 16,750,000 | 33,500,000 | 67,000,000 |
| **Amphiptere** | Celestial | 0.05% | 125,000,000 | 250,000,000 | 500,000,000 |

---

### Zona 7: Volcano
**Ovos que chocam esta Zona:**
- **Angel Egg** (Tier 1) — HP da Parede/Ovo: `300,000,000` | Luck Multiplier: `1.0x`
- **Fallen Angel Egg** (Tier 2) — HP da Parede/Ovo: `750,000,000` | Luck Multiplier: `1.1x`
- **Volcanic Egg** (Tier 3) — HP da Parede/Ovo: `1,500,000,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Jackalope** | Epic | 46.0% | 3,500 | 7,000 | 14,000 |
| **DIMETRODON** | Legendary | 30.0% | 48,000 | 96,000 | 192,000 |
| **Brachiosaurus** | Mythic | 14.0% | 267,000 | 534,000 | 1,068,000 |
| **Lindworm** | Divine | 6.5% | 1,250,000 | 2,500,000 | 5,000,000 |
| **T-Rex** | Cosmic | 2.3% | 4,290,000 | 8,580,000 | 17,160,000 |
| **Fenrir** | Secret | 0.85% | 24,000,000 | 48,000,000 | 96,000,000 |
| **CERBERUS** | Celestial | 0.3% | 150,000,000 | 300,000,000 | 600,000,000 |
| **Raiju** | Celestial | 0.05% | 180,000,000 | 360,000,000 | 720,000,000 |

---

### Zona 8: Blossom
**Ovos que chocam esta Zona:**
- **Bamboo Egg** (Tier 1) — HP da Parede/Ovo: `3,000,000,000` | Luck Multiplier: `1.0x`
- **Blossom Egg** (Tier 2) — HP da Parede/Ovo: `7,500,000,000` | Luck Multiplier: `1.1x`
- **Fortune Egg** (Tier 3) — HP da Parede/Ovo: `15,000,000,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Tanuki** | Legendary | 46.0% | 65,000 | 130,000 | 260,000 |
| **Surgeonfish** | Mythic | 30.0% | 360,000 | 720,000 | 1,440,000 |
| **Mandarinfish** | Divine | 14.0% | 1,800,000 | 3,600,000 | 7,200,000 |
| **DumboOctopus** | Cosmic | 6.5% | 6,500,000 | 13,000,000 | 26,000,000 |
| **Akita** | Secret | 2.3% | 36,000,000 | 72,000,000 | 144,000,000 |
| **Gallimimus** | Celestial | 0.85% | 200,000,000 | 400,000,000 | 800,000,000 |
| **Wolf** | Celestial | 0.3% | 240,000,000 | 480,000,000 | 960,000,000 |
| **SIMURGH** | Celestial | 0.05% | 300,000,000 | 600,000,000 | 1,200,000,000 |

---

### Zona 9: Galaxy
**Ovos que chocam esta Zona:**
- **Starry Egg** (Tier 1) — HP da Parede/Ovo: `30,000,000,000` | Luck Multiplier: `1.0x`
- **Sun Egg** (Tier 2) — HP da Parede/Ovo: `75,000,000,000` | Luck Multiplier: `1.1x`
- **BlackHole Egg** (Tier 3) — HP da Parede/Ovo: `150,000,000,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Crocodile** | Mythic | 46.0% | 500,000 | 1,000,000 | 2,000,000 |
| **Whale** | Divine | 30.0% | 2,500,000 | 5,000,000 | 10,000,000 |
| **Zebra** | Cosmic | 14.0% | 9,000,000 | 18,000,000 | 36,000,000 |
| **THUNDERBIRD** | Secret | 6.5% | 50,000,000 | 100,000,000 | 200,000,000 |
| **ARCHAEOPTERYX** | Secret | 2.3% | 220,000,000 | 440,000,000 | 880,000,000 |
| **WINGED_IMP** | Celestial | 0.85% | 260,000,000 | 520,000,000 | 1,040,000,000 |
| **CALADRIUS** | Celestial | 0.3% | 330,000,000 | 660,000,000 | 1,320,000,000 |
| **Velicoraptor** | Inferno | 0.1% | 400,000,000 | 800,000,000 | 1,600,000,000 |
| **CLASSICDRAGON** | Inferno | 0.05% | 500,000,000 | 1,000,000,000 | 2,000,000,000 |
| **QILIN** | Inferno | 0.01% | 750,000,000 | 1,500,000,000 | 3,000,000,000 |

---

### Zona 10: Planet X
**Ovos que chocam esta Zona:**
- **Plasma Egg** (Tier 1) — HP da Parede/Ovo: `300,000,000,000` | Luck Multiplier: `1.0x`
- **Nebula Egg** (Tier 2) — HP da Parede/Ovo: `750,000,000,000` | Luck Multiplier: `1.1x`
- **Supernova Egg** (Tier 3) — HP da Parede/Ovo: `1,500,000,000,000` | Luck Multiplier: `1.25x`

| Pet | Raridade | Chance Base | Renda (Moedas/seg) | Renda Gold (2x) | Renda Diamond (4x) |
|-----|----------|-------------|--------------------|-----------------|--------------------|
| **Bug** | Divine | 40.0% | 3,000,000 | 6,000,000 | 12,000,000 |
| **CrystalLizard** | Divine | 26.0% | 3,600,000 | 7,200,000 | 14,400,000 |
| **CrystalBeast** | Cosmic | 16.0% | 10,800,000 | 21,600,000 | 43,200,000 |
| **CrystalRaptor** | Secret | 9.0% | 60,000,000 | 120,000,000 | 240,000,000 |
| **CrystalDragon** | Celestial | 5.0% | 312,000,000 | 624,000,000 | 1,248,000,000 |
| **Mantis** | Celestial | 2.5% | 396,000,000 | 792,000,000 | 1,584,000,000 |
| **AlienJellyfish** | Inferno | 1.0% | 480,000,000 | 960,000,000 | 1,920,000,000 |
| **CrystalScorpion** | Inferno | 0.4% | 600,000,000 | 1,200,000,000 | 2,400,000,000 |
| **Behemoth** | Inferno | 0.15% | 900,000,000 | 1,800,000,000 | 3,600,000,000 |
| **CrystalWolf** | Void | 0.02% | 1,080,000,000 | 2,160,000,000 | 4,320,000,000 |
| **CelestialBeast** | Void | 0.01% | 1,296,000,000 | 2,592,000,000 | 5,184,000,000 |
| **CelestialSpirit** | Omega | 0.001% | 1,555,200,000 | 3,110,400,000 | 6,220,800,000 |

---

## 3. Pets Especiais / Legados (Legacy & Eventos)
Pets que não estão no pool rotativo das Zonas 1 a 10, usados em fusões, ovos individuais e eventos:

| Pet | Raridade | Renda Base (Moedas/seg) |
|-----|----------|-------------------------|
| **Frog** | Rare | 40 |
| **Binturong** | Rare | 50 |
| **Owl** | Legendary | 1,750 |
| **HoneyBadger** | Uncommon | 35 |
| **Fossa** | Rare | 60 |
| **Emu** | Uncommon | 70 |
| **Bull** | Legendary | 2,500 |
| **Aardvark** | Uncommon | 105 |
| **Dingo** | Rare | 140 |
| **Jackal** | Epic | 355 |
| **Ostrich** | Legendary | 3,000 |
| **Serval** | Uncommon | 150 |
| **Caracal** | Rare | 175 |
| **Hyena** | Legendary | 3,500 |
| **Albatross** | Legendary | 4,500 |
| **Seal** | Mythic | 25,000 |
| **ChowChow** | Epic | 825 |
| **Blobfish** | Legendary | 5,250 |
| **Mamoth** | Divine | 165,000 |
| **Seahorse** | Epic | 1,200 |
| **Hamster** | Legendary | 7,000 |
| **Quokka** | Cosmic | 750,000 |
| **Koala** | Legendary | 8,000 |
| **Capybara** | Cosmic | 825,000 |
| **Papillon** | Legendary | 9,000 |
| **Pony** | Divine | 275,000 |
| **Turtle** | Divine | 330,000 |
| **archerfish** | Cosmic | 1,200,000 |
| **Shoebill** | Secret | 5,000,000 |
| **wobbegong** | Divine | 375,000 |
| **Kappa** | Cosmic | 1,350,000 |
| **Bunyip** | Secret | 6,000,000 |
| **Cassowary** | Legendary | 15,000 |
| **Chupacabra** | Mythic | 85,000 |
| **MOTHMAN** | Cosmic | 1,500,000 |
| **TripleCobra** | Secret | 7,000,000 |
| **GRIFFIN** | Divine | 540,000 |
| **PEGASUS** | Cosmic | 2,100,000 |
| **WYVERN** | Cosmic | 2,500,000 |
| **HYDRA** | Secret | 15,000,000 |
| **Kitsune** | Celestial | 45,000,000 |
| **KRAKEN** | Cosmic | 5,250,000 |
| **FIREPHOENIX** | Cosmic | 7,500,000 |
| **LEVIATHAN** | Secret | 40,000,000 |