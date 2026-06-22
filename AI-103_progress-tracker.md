# AI-103 — Progress tracker & průchod kurzem

> **Jediný zdroj pravdy pro denní postup.** Mapuje 30 reálných modulů kurzu (`learn/`) + laby (`labs/`) na den-po-dni rozpis do zkoušky.
> Znalostní zápisky drží [_notes/ai103-notes.md](_notes/ai103-notes.md).
> **Status v tabulce udržuje Claude** (řekni mu „hotovo M0X" / „přečteno M0X") — ručně nic neklikáš ani nepřepisuješ.

**Zkouška:** AI-103 — Developing AI Apps and Agents on Azure (beta) · **passing 700** · ~40–60 otázek / 120 min · proctored · interaktivní komponenty
**Termín & rozvrh:** vyplní [`/setup`](.claude/skills/setup/SKILL.md) z tvého data zkoušky + hodin/den → viz blok **🗓️ Studijní plán** níž.
⚠️ Na zkoušku se přihlas účtem, na kterém máš certifikační profil (může být jiný než tvůj Azure / pracovní účet).

---

## 📊 Dashboard (aktualizuje Claude po každém modulu)

| Metrika | Stav |
|---|---|
| 📖 Modulů přečteno | **0 / 30** |
| 🧪 Labů hotových | **0 / 30** |
| 🔁 Zopáknuto | **0 / 30** |

| Path | Hotovo | Váha domény |
|---|---|---|
| P1 — Generative AI apps | 0 / 6 | gen AI 30–35 % 🔴 + plan & manage 25–30 % 🔴 |
| P2 — AI agents | 0 / 9 | agentic (součást gen AI 30–35 %) 🔴 |
| P3 — Natural language | 0 / 7 | text analysis 10–15 % 🟠 |
| P4 — Visual data insights | 0 / 8 | computer vision 10–15 % 🟠 + info extraction 10–15 % 🟠 |

**Kam dávat energii:** P1 + P2 ≈ 60 % zkoušky → tam hands-on a hloubka. P3 + P4 do šířky (poznat správnou službu pro scénář).

---

## 🔑 Legenda & pravidla

- **Status columns** `📖` / `🧪` / `🔁`: `⬜ nezačato` → `⏳ rozpracováno` → `✅ hotovo`. Překlápí **Claude / skilly** — neklikáš, nepřepisuješ ručně.
  - `📖` = modul přečtený · `🧪` = lab odjetý (nebo přečtený kód — viz triage) · `🔁` = zopáknuto (spaced repetition).
- **Confidence** (`Conf`): `⬜ neumím` → `🟡 chápu, neudělám sám` → `🟢 udělám z hlavy`. *(Pozor: `⬜` ve sloupci `Conf` = „neumím"; `⬜` ve status sloupcích = „nezačato" — význam dle sloupce.)* Drž v sync s [_notes/ai103-notes.md](_notes/ai103-notes.md).
- **Spaced repetition:** opakuj jen moduly, které nejsou `🔁 ✅` (tj. `⬜`/`⏳`), nebo mají `Conf ⬜`/`🟡`. `🟢` ignoruj.
- **🔺 Triage „když zaostávám":** denní nálož s plnými laby je reálně **4,5–6 h** (přes plánované 4 h). Když den přeteče:
  1. přednost mají laby **P1 + P2** (největší váha) — ty odjeď celé;
  2. u **P3 + P4** lab klidně jen **přečti kód** (`🧪` = přečteno), nespouštěj;
  3. nikdy neškrtej *čtení modulu* a *zápis do notes* — to je jádro přípravy na scénářové otázky.

---

## 🗂️ Master tabulka — 30 modulů

Sloupce: **#** · modul (odkaz do `learn/`) · doména•váha · den · 📖 · 🧪 · 🔁 · Conf · lab (odkaz do `labs/`) · ~čas

### Path 1 — Develop generative AI apps `[gen AI 30–35 % + plan & manage 25–30 %]` 🔴

| # | Modul | Doména | Den | 📖 | 🧪 | 🔁 | Conf | Lab | ~čas |
|---|---|---|---|---|---|---|---|---|---|
| 1 | [Plan & prepare to develop AI solutions](learn/01-generative-ai-apps/01-prepare-azure-ai-development.md) | plan & manage | 1 | ⬜ | ⬜ | ⬜ | ⬜ | [01-Explore-ai-studio](labs/mslearn-ai-studio/Instructions/Exercises/01-Explore-ai-studio.md) | 1.5h |
| 2 | [Select, deploy & evaluate Foundry models](learn/01-generative-ai-apps/02-model-catalog-evaluate.md) | gen AI / model selection | 1 | ⬜ | ⬜ | ⬜ | ⬜ | [02-model-catalog-evaluation](labs/mslearn-ai-studio/Instructions/Exercises/02-model-catalog-evaluation.md) | 1.5h |
| 3 | [Develop a gen AI chat app with Foundry](learn/01-generative-ai-apps/03-foundry-sdk.md) | gen AI | 2 | ⬜ | ⬜ | ⬜ | ⬜ | [03-foundry-sdk](labs/mslearn-ai-studio/Instructions/Exercises/03-foundry-sdk.md) | 2h |
| 4 | [Develop gen AI apps that use tools](learn/01-generative-ai-apps/04-use-generative-ai-tools.md) | gen AI | 2 | ⬜ | ⬜ | ⬜ | ⬜ | [04a-use-own-data](labs/mslearn-ai-studio/Instructions/Exercises/04a-use-own-data.md) | 2h |
| 5 | [Optimize gen AI model performance (RAG, fine-tune)](learn/01-generative-ai-apps/05-optimize-generative-ai-model-performance.md) | gen AI (RAG/grounding) | 3 | ⬜ | ⬜ | ⬜ | ⬜ | [04a-use-own-data](labs/mslearn-ai-studio/Instructions/Exercises/04a-use-own-data.md) + [04b-finetune-model](labs/mslearn-ai-studio/Instructions/Exercises/04b-finetune-model.md) | 3h |
| 6 | [Implement a responsible gen AI solution](learn/01-generative-ai-apps/06-responsible-ai-studio.md) | plan & manage (responsible AI) | 3 | ⬜ | ⬜ | ⬜ | ⬜ | [06-Explore-content-filters](labs/mslearn-ai-studio/Instructions/Exercises/06-Explore-content-filters.md) | 1.5h |

> Pozn.: kurz balí téma *tools + RAG + fine-tune* do exercises `04a`/`04b` — proto je moduly 4 a 5 sdílejí.

### Path 2 — Develop AI agents `[agentic — součást gen AI 30–35 %]` 🔴

| # | Modul | Doména | Den | 📖 | 🧪 | 🔁 | Conf | Lab | ~čas |
|---|---|---|---|---|---|---|---|---|---|
| 7 | [Develop AI agents with Foundry & VS Code](learn/02-ai-agents/01-develop-ai-agents-azure-vs-code.md) | agentic | 4 | ⬜ | ⬜ | ⬜ | ⬜ | [01-build-agent-portal-and-vscode](labs/mslearn-ai-agents/Instructions/Exercises/01-build-agent-portal-and-vscode.md) | 1.5h |
| 8 | [Integrate custom tools into your agent](learn/02-ai-agents/02-build-agent-with-custom-tools.md) | agentic (function calling) | 4 | ⬜ | ⬜ | ⬜ | ⬜ | [02-agent-custom-tools](labs/mslearn-ai-agents/Instructions/Exercises/02-agent-custom-tools.md) | 1.5h |
| 9 | [Integrate MCP Tools with Azure AI Agents](learn/02-ai-agents/03-connect-agent-to-mcp-tools.md) | agentic (MCP) | 4 | ⬜ | ⬜ | ⬜ | ⬜ | [03-mcp-integration](labs/mslearn-ai-agents/Instructions/Exercises/03-mcp-integration.md) | 1.5h |
| 10 | [Build knowledge-enhanced agents with Foundry IQ](learn/02-ai-agents/04-introduction-foundry-iq.md) | agentic (knowledge/memory) | 5 | ⬜ | ⬜ | ⬜ | ⬜ | [04-integrate-agent-with-foundry-iq](labs/mslearn-ai-agents/Instructions/Exercises/04-integrate-agent-with-foundry-iq.md) | 1.5h |
| 11 | [Integrate your agent with Microsoft 365](learn/02-ai-agents/05-integrate-foundry-agent-with-m365.md) | agentic | 5 | ⬜ | ⬜ | ⬜ | ⬜ | [05a-m365-teams](labs/mslearn-ai-agents/Instructions/Exercises/05a-m365-teams-integration.md) · [05b-work-iq](labs/mslearn-ai-agents/Instructions/Exercises/05b-work-iq-integration.md) | 1.5h |
| 12 | [Build agent-driven workflows with Foundry](learn/02-ai-agents/06-build-agent-workflows-microsoft-foundry.md) | agentic (workflows/governance) | 5 | ⬜ | ⬜ | ⬜ | ⬜ | [06-build-workflow-ms-foundry](labs/mslearn-ai-agents/Instructions/Exercises/06-build-workflow-ms-foundry.md) | 1.5h |
| 13 | [Develop an AI agent with Microsoft Agent Framework](learn/02-ai-agents/07-develop-ai-agent-with-semantic-kernel.md) | agentic | 6 | ⬜ | ⬜ | ⬜ | ⬜ | [07-agent-framework](labs/mslearn-ai-agents/Instructions/Exercises/07-agent-framework.md) | 1.5h |
| 14 | [Orchestrate a multi-agent solution (Agent Framework)](learn/02-ai-agents/08-orchestrate-semantic-kernel-multi-agent-solution.md) | agentic (multi-agent) | 6 | ⬜ | ⬜ | ⬜ | ⬜ | [08-agent-framework-multi-agents](labs/mslearn-ai-agents/Instructions/Exercises/08-agent-framework-multi-agents.md) | 1.5h |
| 15 | [Discover Azure AI Agents with A2A](learn/02-ai-agents/09-discover-agents-with-a2a.md) | agentic (A2A) | 6 | ⬜ | ⬜ | ⬜ | ⬜ | [09-multi-remote-agents-with-a2a](labs/mslearn-ai-agents/Instructions/Exercises/09-multi-remote-agents-with-a2a.md) | 1.5h |

### Path 3 — Develop natural language solutions `[text analysis 10–15 %]` 🟠

| # | Modul | Doména | Den | 📖 | 🧪 | 🔁 | Conf | Lab | ~čas |
|---|---|---|---|---|---|---|---|---|---|
| 16 | [Analyze text with Azure Language](learn/03-natural-language/01-analyze-text-ai-language.md) | text | 7 | ⬜ | ⬜ | ⬜ | ⬜ | [01-analyze-text](labs/mslearn-ai-language/Instructions/Exercises/01-analyze-text.md) | 1.5h |
| 17 | [Text analysis agent with Azure Language MCP](learn/03-natural-language/02-develop-text-analysis-agent-language-mcp.md) | text / agentic | 7 | ⬜ | ⬜ | ⬜ | ⬜ | [02-language-agent](labs/mslearn-ai-language/Instructions/Exercises/02-language-agent.md) | 1h |
| 18 | [Translate text & speech with Foundry Tools](learn/03-natural-language/07-translate-text-speech.md) | text (translation) | 7 | ⬜ | ⬜ | ⬜ | ⬜ | [07-translation](labs/mslearn-ai-language/Instructions/Exercises/07-translation.md) | 1h |
| 19 | [Develop a speech-capable gen AI app](learn/03-natural-language/03-develop-generative-ai-audio-apps.md) | text / speech | 7 | ⬜ | ⬜ | ⬜ | ⬜ | [03-gen-ai-speech](labs/mslearn-ai-language/Instructions/Exercises/03-gen-ai-speech.md) | 1.5h |
| 20 | [Create speech-enabled apps with Azure Speech (STT/TTS)](learn/03-natural-language/04-create-speech-enabled-apps.md) | text / speech | 8 | ⬜ | ⬜ | ⬜ | ⬜ | [04-azure-speech](labs/mslearn-ai-language/Instructions/Exercises/04-azure-speech.md) | 1.5h |
| 21 | [Develop a speech agent with Azure Speech MCP](learn/03-natural-language/05-develop-speech-agent-speech-mcp.md) | text / speech / agentic | 8 | ⬜ | ⬜ | ⬜ | ⬜ | [05-azure-speech-mcp](labs/mslearn-ai-language/Instructions/Exercises/05-azure-speech-mcp.md) | 1h |
| 22 | [Develop an Azure Speech Voice Live Agent](learn/03-natural-language/06-develop-voice-live-agent.md) | text / speech | 8 | ⬜ | ⬜ | ⬜ | ⬜ | [06-voice-live-agent](labs/mslearn-ai-language/Instructions/Exercises/06-voice-live-agent.md) | 1h |

### Path 4 — Extract insights from visual data `[computer vision 10–15 % + info extraction 10–15 %]` 🟠

| # | Modul | Doména | Den | 📖 | 🧪 | 🔁 | Conf | Lab | ~čas |
|---|---|---|---|---|---|---|---|---|---|
| 23 | [Develop a vision-enabled gen AI app](learn/04-visual-data-insights/01-develop-generative-ai-vision-apps.md) | vision | 8 | ⬜ | ⬜ | ⬜ | ⬜ | [01-gen-ai-vision](labs/mslearn-ai-vision/Instructions/Exercises/01-gen-ai-vision.md) | 1.5h |
| 24 | [Generate images with AI](learn/04-visual-data-insights/02-generate-images-azure-openai.md) | vision | 9 | ⬜ | ⬜ | ⬜ | ⬜ | [02-generate-image](labs/mslearn-ai-vision/Instructions/Exercises/02-generate-image.md) | 1h |
| 25 | [Generate videos with Microsoft Foundry](learn/04-visual-data-insights/03-generate-video-with-foundry.md) | vision | 9 | ⬜ | ⬜ | ⬜ | ⬜ | [03-generate-video](labs/mslearn-ai-vision/Instructions/Exercises/03-generate-video.md) | 1h |
| 26 | [Analyze images with Content Understanding](learn/04-visual-data-insights/04-analyze-images-with-content-understanding.md) | vision / info-ext | 9 | ⬜ | ⬜ | ⬜ | ⬜ | [04-content-understanding](labs/mslearn-ai-vision/Instructions/Exercises/04-content-understanding.md) | 1.5h |
| 27 | [Multimodal analysis with Content Understanding](learn/04-visual-data-insights/05-analyze-content-ai.md) | info extraction | 9 | ⬜ | ⬜ | ⬜ | ⬜ | [01-content-understanding](labs/mslearn-ai-information-extraction/Instructions/Exercises/01-content-understanding.md) | 1.5h |
| 28 | [Content Understanding client application](learn/04-visual-data-insights/06-analyze-content-ai-api.md) | info extraction | 10 | ⬜ | ⬜ | ⬜ | ⬜ | [02-content-understanding-api](labs/mslearn-ai-information-extraction/Instructions/Exercises/02-content-understanding-api.md) | 1h |
| 29 | [Extract data with Azure Document Intelligence](learn/04-visual-data-insights/07-extract-data-with-document-intelligence.md) | info extraction | 10 | ⬜ | ⬜ | ⬜ | ⬜ | [03-document-intelligence](labs/mslearn-ai-information-extraction/Instructions/Exercises/03-document-intelligence.md) | 1.5h |
| 30 | [Knowledge mining with Azure AI Search](learn/04-visual-data-insights/08-ai-knowldge-mining.md) | info extraction | 10 | ⬜ | ⬜ | ⬜ | ⬜ | [04-knowledge-mining](labs/mslearn-ai-information-extraction/Instructions/Exercises/04-knowledge-mining.md) | 1.5h |

> Bonus (když zbude čas): [05-rag-pipeline](labs/mslearn-ai-information-extraction/Instructions/Exercises/05-rag-pipeline.md) — spojuje Document Intelligence + AI Search + grounding do jednoho RAG flow.

---

## 📅 Výchozí rozpis (relativní) — `/setup` přemapuje na tvá data

> Doporučené pořadí a hustota podle vah domén (P1+P2 ≈ 60 % zkoušky → napřed a do hloubky).
> „M#" = řádek v master tabulce výše. **Konkrétní data** ti k těmto dnům přiřadí `/setup`
> (dle tvého termínu a hodin/den) a zapíše je do bloku **🗓️ Studijní plán** níž.

| Den | Path | Náplň |
|---|---|---|
| 1 | P1 | **M1** Plan & prepare + lab 01 · **M2** Model catalog/evaluate + lab 02. |
| 2 | P1 | **M3** Foundry SDK chat (teplota/top-p/system prompt/streaming) + lab 03 · **M4** Apps that use tools + lab 04a. |
| 3 | P1 + **P&M** | **M5** Optimize perf — RAG/chunking/embeddings/grounding + lab 04a & skim 04b (**A/B grounding vs. bez**) · **M6** Responsible AI + lab 06. **+ blok Plan & manage** (keyless/MI, RBAC, networking, monitoring, content safety). |
| 4 | P2 | **M7** agents VS Code +01 · **M8** custom tools/function calling +02 · **M9** MCP tools +03. |
| 5 | P2 | **M10** Foundry IQ (knowledge/memory) +04 · **M11** M365 +05a/05b · **M12** agent workflows +06. |
| 6 | P2 | **M13** Agent Framework +07 · **M14** multi-agent orchestrace +08 · **M15** A2A +09. |
| 7 | P3 | **M16** Analyze text +01 · **M17** text-analysis agent (Language MCP) +02 · **M18** Translate +07 · **M19** speech gen AI +03. |
| 8 | P3→P4 | **M20** speech-enabled apps (STT/TTS) +04 · **M21** speech MCP agent +05 · **M22** Voice Live +06 · **M23** vision gen AI +01. *(STT→model→TTS řetězec: změř latenci + token náklady.)* |
| 9 | P4 | **M24** generate images +02 · **M25** generate video +03 · **M26** Content Understanding images +04 · **M27** multimodal CU +01. |
| 10 | P4 | **M28** CU client API +02 · **M29** Document Intelligence +03 · **M30** knowledge mining AI Search +04. |
| +1 | konsolidace | Bonus [05-rag-pipeline](labs/mslearn-ai-information-extraction/Instructions/Exercises/05-rag-pipeline.md) · dotáhnout `⬜`/`⏳` · slabá místa (`Conf ⬜`/`🟡`) · Plan & manage decision trees. |
| +2 | opáčko | Exam sandbox · practice otázky · drill rozhodovacích filtrů · **personal index** (20–30 klíčových stránek). · **den zkoušky:** jen lehké opáčko (`🟡` + index), žádné nové téma. |

**Realita all-labs:** dny s ~3 moduly + plnými laby (P2–P4) můžou přetéct. P1+P2 odjeď celé;
na P3+P4 drž **🔺 Triage** (lab jen číst) jako pojistku, ne default. Poslední 1–2 dny =
konsolidace + opáčko (žádné nové téma). Když máš jiný počet dní, `/setup` rozpis přepočítá.

---

## 🗓️ Studijní plán (vyplní `/setup`)

> `/setup` sem vygeneruje **konkrétní data** z tvého termínu zkoušky a hodin/den.
> `check-progress` čte tyhle dvě tabulky. Dokud jsou prázdné, spusť **`/setup`**.

**Datum ↔ Den** *(zatím prázdné — spusť `/setup`)*

| Datum | Den | ~h | Off-day? |
|---|---|---|---|
| _vyplní `/setup`_ |  |  |  |

**Kumulativní cíl (k konci dne)** *(zatím prázdné — spusť `/setup`)*

| Konec dne | Cíl modulů ✅ (📖+🧪) | Přibylo |
|---|---|---|
| _vyplní `/setup`_ |  |  |

---

## 🛡️ Cross-cutting „Plan & manage" (25–30 %, průřezová doména)

> Není to samostatný modul — řeš ho **u každého labu** a sepiš do [_notes/ai103-notes.md](_notes/ai103-notes.md). Hlavní soustředění den 3.

| Téma | Stav |
|---|---|
| **Keyless auth** — managed identity / `DefaultAzureCredential`; kdy MI vs. API klíč | ⬜ |
| **RBAC data-plane role** — `Cognitive Services OpenAI User`, `Azure AI Developer`; která role na co | ⬜ |
| **Private networking** — private endpoints, VNet, disable public access | ⬜ |
| **Monitoring & tracing** — trace logging, provenance metadata, evaluators, Azure Monitor / App Insights | ⬜ |
| **Responsible AI / content safety** — safety filters, guardrails, risk detection, blocklists | ⬜ |
| **Model selection decision tree** — kvalita vs. cena vs. latence; GlobalStandard vs. Standard vs. DataZone; reasoning (o-series) vs. gpt-4o; LLM vs. small vs. multimodal | ⬜ |
| **Regiony & kvóty** — dostupnost modelu v regionu, TPM kvóty (ověř kvóty ve svém regionu, viz [azure-config.md](azure-config.md)) | ⬜ |

---

## 🔁 Workflow po každém modulu

1. Přečíst modul v `learn/…`.
2. Odjet lab z `labs/…` (snippety čti dle [_notes/python-pro-csharp-azure-ai.md](_notes/python-pro-csharp-azure-ai.md)).
3. Zapsat řádek do [_notes/ai103-notes.md](_notes/ai103-notes.md): 1 věta vlastními slovy + rozhodovací pravidlo/gotcha + confidence + odkaz.
4. Říct Claudovi „hotovo M0X" → posune `⬜`→`⏳`→`✅` ve sloupcích 📖/🧪/🔁, doplní `Conf` a přepočítá **Dashboard**.

## 🎯 Rozhodovací filtry (trénovat na scénáře — den 11)

- **Foundry hranice:** project setup / deployment / prompt flow / evaluation / agent config / monitoring / integration?
- **Grounding:** je potřeba retrieval / AI Search / index / citace?
- **Agent workflow:** konverzace / tool calling / function call / memory / permissions / human review?
- **Modalita:** generative / vision / speech / text / translation / information extraction?
- **Model selection:** kvalita vs. cena vs. latence; GlobalStandard vs. Standard vs. DataZone; reasoning vs. gpt-4o?
