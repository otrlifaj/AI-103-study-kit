# CLAUDE.md — AI-103 study kit (kontext projektu)

> Trvalá paměť tohoto repa: **self-study kit na certifikaci AI-103**. Cílem je projít
> 4 learning paths kurzu a u každého tématu mít hands-on lab, který zároveň trénuje
> scénářové zkouškové otázky. Průchod řídí Claude Code skilly (viz níž) + progress tracker.

## Profil, na který je kit stavěný
- Vývojář se zázemím v **C# / Azure**, který **Python čte, ale nepíše plynně** — u zkoušky
  stačí Python SDK snippety *číst a chápat*. Most C#→Python: [_notes/python-pro-csharp-azure-ai.md](_notes/python-pro-csharp-azure-ai.md).
- Laby lze řešit v C# (oficiální .NET AI app templates) i v Pythonu; `scaffold-lab` generuje **Python**
  (sedí na oficiální Labfiles + čtení zkouškových snippetů).
- Pokud jsi v Pythonu doma a C# tě nezajímá, prostě C# poznámky ignoruj.

## Cíl
Složit **AI-103: Developing AI Apps and Agents on Azure** — cert *Azure AI Apps and Agents
Developer Associate*. Passing score **700**, ~40–60 otázek, 120 min, proctored.
Zkouška testuje **scénáře** („jak bys to postavil"), ne memorování — kdo staví, odpovídá rychleji.

## Domény a váhy (kam dávat energii)
1. **Implement generative AI and agentic solutions — 30–35 %** 🔴 nejvyšší
2. **Plan and manage an Azure AI solution — 25–30 %** 🔴 vysoká, průřezová (security, model selection, responsible AI, monitoring)
3. Implement computer vision solutions — 10–15 %
4. Implement text analysis solutions — 10–15 %
5. Implement information extraction solutions — 10–15 %

P1 + P2 (gen AI + agentic) ≈ 60 % zkoušky → tam hands-on a hloubka. P3 + P4 do šířky
(poznat správnou službu pro scénář).

## Časový plán
Termín a den-po-dni rozpis si vygeneruješ přes **`/setup`** (z data zkoušky + hodin/den).
Výchozí relativní rozpis (pořadí modulů dle vah) je v [AI-103_progress-tracker.md](AI-103_progress-tracker.md).
Mapování na 4 learning paths kurzu AI-103T00:
- Path 1: Generative AI apps (+ plan & manage)
- Path 2: AI agents
- Path 3: NLP / text + speech
- Path 4: Computer vision + information extraction

## Tematické oblasti labů (8 okruhů → mapují se na `labs/` sady)
> Laby se **editují v místě** v jejich `labs/<suite>/Labfiles/.../Python/` (scaffold-lab to
> připraví). Tahle osmička je jen myšlenková mapa okruhů; `src/<NN-slug>/` zakládej jen
> volitelně pro experiment od nuly mimo strukturu labu.
```
/01-genai-app        # chat completions přes Foundry SDK, parametry, streaming
/02-rag              # chunking, embeddings, vector search, grounding, citace; A/B s groundingem vs. bez
/03-agent            # Foundry Agent Service: agent + custom tool (function calling) + paměť
/04-agent-workflow   # multistep workflow, tool-augmented flow, governance + content safety + trace logging
/05-nlp              # Azure AI Language: sentiment/entities/PII; + STT→model→TTS řetězec
/06-vision           # image analysis, object detection, OCR
/07-doc-extraction   # Document Intelligence: layout + field extraction → JSON → napojit na /03-agent
/08-search           # Azure AI Search: index nestrukturovaných dat, skillset, integrace s RAG
```

## Klíčové konvence pro laby
- **Auth bez klíčů:** preferovat managed identity / keyless credentials (`DefaultAzureCredential`) —
  časté téma „plan & manage". V `.env` jen endpointy + názvy deploymentů, nikdy klíče.
- Lab odjeď **v místě** (jeho starter `.py` + keyless `.env`); zkouškové snippety čti dle
  [_notes/python-pro-csharp-azure-ai.md](_notes/python-pro-csharp-azure-ai.md) (C#→Python).
- Po dokončení labu zapsat řádek do `_notes/ai103-notes.md`: 1 věta + **rozhodovací pravidlo
  služby** („kdy tuhle vs. jinou") + confidence + odkaz na lab (`/update-status`).
- Průřezově do každého labu: managed identity (keyless), RBAC role, monitoring.

## Skilly pro průchod kurzem (Claude Code, repo-scoped v `.claude/skills/`)
Invokuj přes `/<name>`. Status v trackeru drží 3-stav `⬜ nezačato → ⏳ rozpracováno → ✅ hotovo` (Conf zvlášť `⬜🟡🟢`).

| Skill | K čemu | Zápis |
|---|---|---|
| `/setup` | **Spusť první.** Nainstaluje deps + submoduly, vyplní `azure-config.md`, vygeneruje datovaný studijní plán | config + tracker |
| `/next-module` | Spouštěč session: najde další modul (`📖 ⬜`), otevře MS Learn + `.md`, zkontroluje provisioning, nabídne zřetězit `provision-ahead` + `scaffold-lab` | — |
| `/check-progress` | Jak časově teču proti plánu (Den N, ✅ vs. cíl, catch-up dle Triage) | — |
| `/update-status` | Interaktivní debrief: zeptá se co je hotové, zapíše **notes** + překlopí tracker (deleguje na `done`) | notes + tracker |
| `/done` | Rychlé argument-driven značení (`/done M05 read green`) + přepočet dashboardu | tracker |
| `/scaffold-lab` | Připraví lab **v místě** (jeho `Labfiles/.../Python/`): keyless `.env` + balíčky + ověří, že nastartuje (jen TODO zbývá) | `.env` v labu |
| `/provision-ahead` | Přednasadí Azure zdroje pro nadcházející laby (embeddings, AI Search, …) — **po potvrzení** | Azure |
| `/quiz-me` | Scénářové zkouškové otázky vážené dle domén + slabé confidence | — |

## Azure prostředí
Keyless přes **Azure AI Foundry** (project-based, kind `AIServices`). Konkrétní hodnoty
(resource, projekt, RG, subscription, region, endpointy, deploymenty) drží
**[azure-config.md](azure-config.md)** — vyplní ho `/setup` (šablona: `azure-config.example.md`).
Skilly `next-module`, `scaffold-lab`, `provision-ahead` čtou Azure kontext odtud.

## Toolchain
- **Python 3.13** (laby `mslearn-ai-*` na 3.14 nejedou — chybí wheels). Použití: `py -3.13 -m venv .venv`.
- **az CLI** (keyless přes `az login`), volitelně **.NET SDK** (pokud chceš laby v C#).
- **Claude Code** (skilly v `.claude/skills/`).
- Bootstrap: `./setup.ps1` → `/setup`. Laby jsou git submoduly v `labs/` (oficiální MicrosoftLearning repa).

## Zdroje
- Study guide: https://aka.ms/AI103-StudyGuide
- Kurz: https://learn.microsoft.com/en-us/training/courses/ai-103t00
- Cert: https://learn.microsoft.com/en-us/credentials/certifications/azure-ai-apps-and-agents-developer-associate/
- .NET AI app templates (laby v C#): „AI App Template gallery" + .NET sekce v Azure AI learning resources
- Tip: k libovolné MS Learn stránce přidat `?accept=text/markdown` → čistý markdown (pro poznámky / NotebookLM)
- ⚠️ Dostupnost modelů (`gpt-4.1`, `gpt-4o`, real-time vs. Batch) se **liší dle regionu** — ověř kvóty ve svém regionu před nasazením.
