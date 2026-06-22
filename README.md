# AI-103 study kit

Claude Code-driven kit na přípravu na cert **AI-103: Developing AI Apps and Agents on Azure**
(*Azure AI Apps and Agents Developer Associate*). Projdeš 30 modulů kurzu + oficiální laby,
postup i poznámky držíš v jednom trackeru a před zkouškou se drilluješ scénářovými otázkami —
všechno na **svém** Azure a **svém** termínu.

## Co je uvnitř
- **`learn/`** — offline kopie 30 modulů kurzu AI-103T00 (4 learning paths) + diagramy.
- **`labs/`** — oficiální MicrosoftLearning laby jako git submoduly (5 sad).
- **`.claude/skills/`** — průchozí skilly (`/setup`, `/next-module`, `/done`, `/quiz-me`, …).
- **`AI-103_progress-tracker.md`** — jediný zdroj pravdy o postupu (status + confidence + plán).
- **`_notes/`** — knowledge base (šablona) + tahák *Python pro C# vývojáře*.
- **`CLAUDE.md`** — kontext projektu (domény, váhy, konvence).

## 1. Naklonuj (vč. labů jako submodulů)
```bash
git clone --recurse-submodules https://github.com/otrlifaj/AI-103-study-kit.git
cd AI-103-study-kit
```

## 2. Předpoklady
- **Python 3.13** (laby na 3.14 nejedou — chybí wheels). Ověř na Windows: `py -0p`.
- **Azure CLI** (`az`) + Azure subscription s přístupem k **Azure AI Foundry**.
- **Claude Code**.
- *(volitelně .NET SDK, jen když chceš laby psát v C#)*

## 3. Bootstrap
```powershell
./setup.ps1          # .venv (py 3.13) + závislosti + init submodulů
```
> ⚠️ `setup.ps1` je PowerShell (psané na Windows). Na **Macu/Linuxu** udělej kroky ručně:
> ```bash
> python3.13 -m venv .venv && source .venv/bin/activate
> pip install -r requirements.txt
> git submodule update --init --recursive
> ```

## 4. V Claude Code
```
/setup          # zeptá se na termín zkoušky + hodin/den + Azure → vyplní azure-config.md a vygeneruje datovaný studijní plán
az login        # keyless přihlášení (DefaultAzureCredential)
/next-module    # první studijní session
```

## Denní smyčka
- `/next-module` — otevře další modul + lab, zkontroluje Azure zdroje, nabídne `/scaffold-lab` a `/provision-ahead`.
- `/scaffold-lab` — připraví lab **v místě** (keyless `.env` + balíčky + smoke test), pak doplníš jen TODO v jeho starter souboru.
- `/done M0X` nebo `/update-status` — zapíše postup do trackeru (+ poznámku do `_notes/`).
- `/check-progress` — jestli stíháš plán.
- `/quiz-me` — scénářové zkouškové otázky vážené dle vah domén a slabých míst.

## Auth = keyless
Žádné API klíče. Vše přes `DefaultAzureCredential` (`az login` lokálně / managed identity v Azure).
V `.env` labů jen endpointy + názvy deploymentů. `azure-config.md` (tvé Azure IDs) je v `.gitignore`.
Detaily v [CLAUDE.md](CLAUDE.md).
