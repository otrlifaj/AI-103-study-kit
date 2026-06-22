---
name: setup
description: Use FIRST when onboarding to this AI-103 study kit — sets up the environment and personalizes it. Triggers - "setup", "nahoď to", "onboarding", "rozjeď repo", "nastav prostředí", "začínám s tímhle repem", first run after clone. Installs deps + submodules, fills azure-config.md, and generates a dated study plan from the user's exam date.
---

# setup

## Overview

Jednorázový **onboarding** tohoto AI-103 study kitu. Dostane nového uživatele z čerstvého
clonu do plně funkčního stavu: nainstalované závislosti + laby, vyplněný Azure config a
**datovaný studijní plán šitý na jeho termín zkoušky**. Po `/setup` jedou všechny ostatní
skilly (`/next-module`, `/done`, `/quiz-me`, `/check-progress`, …) stejně jako u autora kitu.

Zapisuje: `azure-config.md` (z `azure-config.example.md`) + studijní plán a reset do
[AI-103_progress-tracker.md](../../../AI-103_progress-tracker.md).

## Workflow

### 1. Závislosti + submoduly (skript)
Pokud ještě neproběhlo (`.venv` chybí nebo laby prázdné), **po potvrzení** spusť bootstrap:
```powershell
./setup.ps1
```
Vytvoří root `.venv` (Python 3.13), nainstaluje `requirements.txt`, `git submodule update --init --recursive`.
Když `setup.ps1` hlásí chybějící Python 3.13 → navęď uživatele nainstalovat ho z python.org (laby nejedou na 3.14).

### 2. Interview (zeptej se, ulož odpovědi)
Použij `AskUserQuestion` / přímé dotazy. Zjisti:
- **Termín zkoušky** (datum) a jestli má pevný čas (dopo/odpo).
- **Začátek studia** (datum, default = dnes z `Get-Date`).
- **Hodin denně** (kolik reálně zvládne) + **off-days** (dny volna v okně).
- **Azure** (na keyless): subscription ID, tenant, resource group, region, Foundry resource (kind `AIServices`),
  název projektu, chat deployment (a embeddings deployment, jestli už je). Endpointy **odvoď** ze jména
  resource + projektu (viz `azure-config.example.md`). Když uživatel ještě Azure nemá, napiš mu, co založit
  (Foundry resource + projekt) a config nech s placeholdery k pozdějšímu doplnění.

### 3. Zapiš `azure-config.md`
Zkopíruj `azure-config.example.md` → `azure-config.md` a vyplň tabulku z odpovědí
(endpointy poskládej dle vzoru). Soubor je v `.gitignore` — necommituje se. Skilly ho čtou.

### 4. Vygeneruj datovaný studijní plán do trackeru
Cíl: každý z 30 modulů má **konkrétní datum**, vážené dle domén (P1+P2 = ~60 % zkoušky → napřed a do hloubky).

1. **Spočti studijní dny:** od začátku do termínu, mínus off-days. Označ je Den 1..N.
2. **Rozlož 30 modulů přes dny** (výchozí pořadí modulů = pořadí v master tabulce, tj. P1→P2→P3→P4):
   - moduly/den ≈ `ceil(30 / N)`, ale **front-loaduj P1+P2** (klidně méně modulů/den u P1+P2, víc u P3+P4),
   - poslední 1–2 dny nech na **konsolidaci** (žádné nové moduly — sandbox, slabá místa, quiz).
   - Když je dní málo, aplikuj **Triage** (viz tracker): P3+P4 laby jen „přečti kód".
3. **Přepiš v trackeru:**
   - **Header:** dnešní datum, termín, počet dní/studijních dní (nahraď placeholdery).
   - **Sloupec `Den`** v master tabulce: přiřaď Den N každému modulu dle rozložení.
   - **Reset stavů:** všechny `📖/🧪/🔁/Conf` na `⬜`, dashboard `0 / 30` a per-path `0 / N`
     (pokud už uživatel něco needělal — typicky čerstvý kit už je vynulovaný).
   - **Vlož/aktualizuj blok `## 🗓️ Studijní plán`** s dvěma tabulkami, které čte `check-progress`:
     - **Datum ↔ Den** (kalendář studijních dní),
     - **Kumulativní cíl k konci dne** (`Den N → X modulů ✅`, „přibylo M..").

### 5. Shrnutí + navigace
Vypiš: co se nainstalovalo, kam se uložil Azure config, jak vypadá plán (Den 1 = která data/moduly,
termín, kolik modulů/den). Pak naveď:
```
az login            # pokud ještě ne
/next-module        # první session
```

## Common Mistakes
- **Spustit `setup.ps1` bez potvrzení** — instaluje balíčky a stahuje submoduly; nejdřív se zeptej.
- **Dát Azure secrets do `azure-config.md`** — keyless! Jen endpointy, jména resource/deploymentů, IDs. Žádné klíče.
- **Commitnout `azure-config.md`** — je v `.gitignore`, nech to tak (obsahuje uživatelovy IDs).
- **Napevno data ve skillech** — datovaný plán patří do trackeru (blok `## 🗓️ Studijní plán`), ne do skill textů.
- **Ignorovat váhy při rozložení** — P1+P2 napřed a do hloubky; P3+P4 do šířky.
