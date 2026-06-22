---
name: next-module
description: Use when the user wants to start or continue the next AI-103 study module / study session. Triggers - "next module", "další modul", "co dál", "pokračovat v kurzu", "začněme", začátek studijní session. Opens the module + lab, checks Azure provisioning, and offers to chain scaffold-lab / provision-ahead.
---

# next-module

## Overview

Spouštěč studijní session pro AI-103. Najde v trackeru další nepřečtený modul, otevře ho (MS Learn v prohlížeči + `.md` ve VS Code), zkontroluje, jestli máš nasazené Azure zdroje pro jeho lab (ať nečekáš na provisioning), a na konci nabídne rovnou připravit teren — `provision-ahead` (chybí-li zdroj) a `scaffold-lab` (připraví lab v místě: `.env` + balíčky + smoke).

**Zdroj pravdy o pozici:** [AI-103_progress-tracker.md](../../../AI-103_progress-tracker.md) (master tabulka).
Status model: `⬜ nezačato` → `⏳ rozpracováno` → `✅ hotovo`.

## Workflow

### 1. Najdi další modul
- Read `AI-103_progress-tracker.md`, master tabulka (řádky `| # | Modul | Doména | Den | 📖 | 🧪 | 🔁 | Conf | Lab | ~čas |`).
- **Další modul** = řádek s nejnižším `#`, kde sloupec `📖 = ⬜`.
- **Nejdřív zkontroluj rozdělané:** pokud existuje řádek s `⏳` (typicky `📖 ✅`, ale `🧪 ⬜/⏳`), nabídni nejdřív **dokončit ten** (resume labu) místo skoku na nový modul.
- Z řádku vytáhni: cestu k modulu (`learn/...md`), cestu(y) k labu (`labs/.../Exercises/*.md`), Den, doménu+váhu, odhad času.
- Pokud žádný `📖 ⬜` není → kurz dočten: pogratuluj a nabídni `/quiz-me` nebo opakování slabých míst (`Conf ⬜`/`🟡`).

### 2. Otevři modul a lab
- Read modul `.md`, vytáhni řádek `**Source:** https://learn.microsoft.com/...` (kolem 4. řádku).
- Otevři v prohlížeči a ve VS Code (PowerShell, cwd = repo root):
  ```powershell
  Start-Process "<source-url>"          # MS Learn modul v prohlížeči
  code "<cesta\k\modulu.md>"            # learning .md ve VS Code
  code "<cesta\k\labu.md>"              # lab(y) — i víc, pokud řádek má 2 odkazy
  ```

### 3. Zjisti, co lab potřebuje za Azure zdroje
- Read lab `.md`. Projdi sekce `## Prerequisites`, `## Create a ... resource`, `## Deploy a model` a názvy modelů.
- Zmapuj na typ zdroje (rychlá heuristika):
  | V labu se objeví | Potřebný zdroj | Provisioning |
  |---|---|---|
  | deploy `gpt-4o` / `gpt-4.1` / chat model | model deployment ve Foundry | rychlé |
  | `text-embedding-3-*` / embeddings / "own data" / RAG | **embeddings deployment** | rychlé |
  | "Azure AI Search" / index / knowledge mining | **AI Search service** (+ Storage) | **pomalé (min.)** |
  | "Document Intelligence" | **Document Intelligence resource** | pomalé |
  | "Speech" / STT / TTS / voice | **Speech / Foundry Tools resource** | středně |
  | image/video generation (dall-e, sora) | image/video model deployment | rychlé |

### 4. Provisioning check (read-only `az`)
Azure kontext načti z [azure-config.md](../../../azure-config.md) (vyplnil `/setup`): Foundry resource, projekt, RG, subscription, region. Auth keyless (`az login`). Dosaď je do příkazů níž (`<foundry-resource>`, `<resource-group>`).

```powershell
# nasazené modely (chat, embeddings, image, ...)
az cognitiveservices account deployment list --name <foundry-resource> --resource-group <resource-group> -o table
# standalone služby (jen když je lab potřebuje)
az search service list -o table
az cognitiveservices account list -o table   # filtruj dle Kind: DocumentIntelligence / SpeechServices / ...
```
Porovnej **potřeba vs. nasazeno**. Co chybí pro nejbližší lab → nabídni `/provision-ahead`.

### 5. Briefing
Vypiš stručně:
- **Modul** (název, M#) · doména + váha (🔴/🟠) · Den · odhad času.
- Co je otevřené (Source URL + soubory).
- **Zdroje:** `✅ máš (gpt-4o)` / `⚠️ CHYBÍ (embeddings, AI Search)` — a jestli je něco pomalé na provisioning.

### 6. Orchestrace na konci (zeptej se, nespouštěj tiše)
Použij `AskUserQuestion` (víc voleb), pak po potvrzení zřetěz přes `Skill` tool:
- **Pokud chybí zdroj** → nabídni spustit teď `provision-ahead` (ať se pomalé zdroje provisionují, než k labu dojdeš).
- **Nabídni `scaffold-lab`** → připravit lab **v místě** (keyless `.env` + balíčky + ověřit start; jen TODO zbude) — default ano.
- Když uživatel odmítne, jen mu napiš přesné příkazy `/provision-ahead` a `/scaffold-lab`, ať si je spustí sám.

> Proč ptát: provisioning stojí peníze a scaffold tvoří soubory — neudělej to potichu.

## Common Mistakes
- **Skok na nový modul přes rozdělaný** — nejdřív nabídni dokončit řádek s `⏳`.
- **Otevření jen modulu, ne labu** — otevři obojí; některé řádky mají 2 laby (05a/05b, 04a+04b).
- **Spuštění provisioning/scaffold bez zeptání** — vždy přes potvrzení.
- **Špatná detekce „další"** — řiď se sloupcem `📖`, ne `🧪`/`🔁`.
