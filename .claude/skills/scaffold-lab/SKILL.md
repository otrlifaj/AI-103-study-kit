---
name: scaffold-lab
description: Use when the user wants an AI-103 lab made runnable in place so only the SDK call body remains. Triggers - "scaffold lab", "připrav lab", "nachystej lab", "rozjeď lab", "kostra labu", before starting to code a lab exercise.
---

# scaffold-lab

## Overview

Připraví **konkrétní AI-103 lab tak, aby šel rovnou spustit** — **přímo v jeho vlastní
složce** (`labs/<suite>/Labfiles/.../Python/`), ne v odděleném `src/`. Tj. keyless `.env`
z `azure-config.md`, venv + balíčky z `requirements.txt` labu, a **ověří, že to nastartuje**
(auth + deployment + import). Cíl: sednout k labu a jen doplnit **TODO** v jeho starter
souboru, ne řešit setup. Oficiální laby svůj starter kód s TODO sekcemi **už mají** — scaffold
ho nepřepisuje, jen kolem něj připraví prostředí.

**Jazyk: Python** (sedí na oficiální labs i na čtení zkouškových snippetů). Most C#→Python:
[_notes/python-pro-csharp-azure-ai.md](../../../_notes/python-pro-csharp-azure-ai.md).

> Pozn.: `src/` projekt je až **volitelný** — jen když chceš experiment **od nuly** mimo
> strukturu labu. Pro průchod kurzem edituj lab v místě (tahle cesta).

## Workflow

### 1. Urči cílový lab + jeho code složku
- Z argumentu (`scaffold-lab 03-foundry-sdk`), jinak current/next modul z
  [AI-103_progress-tracker.md](../../../AI-103_progress-tracker.md) (řádek s `📖 ⏳`/`✅` ale `🧪 ⬜`).
- Najdi lab `.md` v `labs/<suite>/Instructions/Exercises/` a z něj **přesnou cestu ke kódu**
  — typicky `labs/<suite>/Labfiles/<exercise>/Python/<app>/`. **Pozor:** struktura se mezi
  sadami liší (`Labfiles` vs `labfiles`, `Python` vs `python`, někdy víc pod-aplikací) —
  vyčti reálnou cestu z labu / `ls`, nehádej.

### 2. Přečti lab a urči SDK + endpoint + model
Read lab `.md` (`## Prerequisites` / `## Deploy` / kódové bloky) + **`requirements.txt`
ve složce labu**. Zjisti potřebné endpointy/env a balíčky:
| V labu | pip balíček | endpoint | env proměnná |
|---|---|---|---|
| OpenAI SDK + Responses API (chat) | `openai` | Azure OpenAI | `AZURE_OPENAI_ENDPOINT`, `MODEL_DEPLOYMENT` |
| Foundry projekt / Agents | `azure-ai-projects`, `azure-ai-agents` | project | `PROJECT_ENDPOINT` |
| embeddings / RAG | `openai` + `azure-search-documents` | Azure OpenAI + Search | `+ SEARCH_ENDPOINT` |
| Document Intelligence | `azure-ai-documentintelligence` | DI resource | `DOCINT_ENDPOINT` |
| Speech (STT/TTS) | `azure-cognitiveservices-speech` | Speech resource | `SPEECH_ENDPOINT`/region |
| Vision / image | `azure-ai-vision-imageanalysis` / `openai` | dle labu | dle labu |

Balíčky ber z `requirements.txt` labu (je autoritativní); `azure-identity` + `python-dotenv` bývají taky.

### 3. Připrav prostředí v místě labu (NEgeneruj `src/`)
Pracuj uvnitř code složky labu z kroku 1:
- **`.env`** — vytvoř z `.env` placeholderu labu (často tam je prázdný/`.env.example`).
  Vyplň **jen endpointy + názvy deploymentů** z [azure-config.md](../../../azure-config.md) —
  **keyless, žádné klíče**. Klíčuj přesně dle proměnných, které čte starter kód labu
  (otevři ho a podívej se na `os.environ[...]` / `load_dotenv`).
  ```
  PROJECT_ENDPOINT=https://<foundry-resource>.services.ai.azure.com/api/projects/<project-name>
  AZURE_OPENAI_ENDPOINT=https://<foundry-resource>.cognitiveservices.azure.com/
  MODEL_DEPLOYMENT=<chat-deployment>
  ```
- **Závislosti** — instaluj `requirements.txt` labu. Buď do **root `.venv`** (už má base SDK
  z `/setup`), nebo per-lab venv dle instrukcí labu. Cíl **Python 3.13** (labs nejedou na 3.14):
  ```powershell
  # root .venv (z /setup):           # nebo per-lab dle labu:
  & ..\..\..\.venv\Scripts\python.exe -m pip install -r requirements.txt
  # py -3.13 -m venv .venv; .venv\Scripts\Activate.ps1; pip install -r requirements.txt
  ```
- **Starter kód NEPŘEPISUJ.** Otevři lab `.py` (má TODO sekce) a uživateli ukaž, **kde přesně**
  má doplnit SDK volání (čísla řádků / názvy funkcí + odkaz na unit v lab `.md`).

### 4. Ověř, že to nastartuje (smysl skillu)
- `az account show` → přihlášen? Jinak řekni `az login`.
- Deployment existuje? `az cognitiveservices account deployment list --name <foundry-resource> --resource-group <resource-group> -o table` (jména z [azure-config.md](../../../azure-config.md)) — je tam `MODEL_DEPLOYMENT` / potřebná služba?
- Smoke: po instalaci zkus `python -c "import openai, azure.identity"` (+ další balíčky labu). Případně spusť lab `.py` — má spadnout až na TODO, ne na importu/auth/configu.
- **Report:** co je ready ✅ / co chybí ⚠️ + cesta k souboru a TODO sekcím. Když chybí zdroj → nabídni `/provision-ahead`.

## Common Mistakes
- **Generovat `src/` projekt nebo přepisovat starter** — laby se editují **v místě**; scaffold jen připraví okolí (env + deps + smoke).
- **Hádat cestu ke kódu** — vyčti ji z labu/`ls`; struktura se mezi sadami liší.
- **Dát do `.env` klíče** — auth je keyless; `.env` má jen endpointy + deployment name. (`.env` je gitignorovaný.)
- **Špatné názvy env proměnných** — klíčuj přesně podle toho, co čte starter kód labu, ne podle vzoru výše.
- **Cílit Python 3.14** — labs jedou na 3.13.
- **Scaffold bez ověření** — vždy doběhni krok 4, jinak skill ztrácí smysl.
