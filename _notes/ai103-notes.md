# AI-103 — živá knowledge base

> Po **každém modulu / labu** sem zapiš 4 věci. Pak opakuj jen `⬜`/`🟡` (spaced repetition), `🟢` ignoruj.
> Tenhle soubor je zároveň ideální jediný zdroj do NotebookLM.

**Confidence legenda:** `⬜ neumím` → `🟡 chápu, ale neudělám sám` → `🟢 udělám z hlavy`

**Co zapsat u každého řádku:**
1. **Jednou větou vlastními slovy**, co modul/služba řeší (ne copy-paste z Learnu).
2. **Rozhodovací pravidlo / gotcha** — „kdy použít X vs. Y" (přesně na tohle se ptají scénáře).
3. **Confidence** `⬜ / 🟡 / 🟢`.
4. **Odkaz** na unit (+ případně SDK volání, které sis vyzkoušel / cesta k labu v repu).

---

## Doména 1 — Generative AI & agentic (30–35 %) 🔴

| Téma | Vlastními slovy | Rozhodovací pravidlo / gotcha | Conf | Odkaz / lab |
|---|---|---|---|---|
| Plan & prepare AI solution |  |  | ⬜ |  |
| Model catalog — výběr modelu |  | LLM vs. small vs. code vs. multimodal; benchmark vs. cena | ⬜ |  |
| Foundry SDK — chat completions |  | temperature vs. top-p; system prompt; streaming | ⬜ |  |
| Prompt engineering / prompt flow |  | few-shot vs. zero-shot; šablony | ⬜ |  |
| RAG — retrieval-augmented generation |  | kdy grounding/AI Search/index/citace | ⬜ |  |
| Evaluace modelů a appek |  | manuál vs. auto eval; fabrication/relevance/safety | ⬜ |  |

## Doména 2 — Plan & manage (25–30 %) 🔴 průřezová

| Téma | Vlastními slovy | Rozhodovací pravidlo / gotcha | Conf | Odkaz / lab |
|---|---|---|---|---|
| Security — keyless / managed identity |  | kdy MI vs. klíč; který RBAC role pro data-plane (Cognitive Services OpenAI User / Azure AI Developer) | ⬜ |  |
| Private networking |  |  | ⬜ |  |
| Responsible AI / content safety |  | safety filters, guardrails, risk detection | ⬜ |  |
| Monitoring & tracing |  | trace logging, provenance, evaluators | ⬜ |  |

## Doména — Agenti (součást 30–35 %) 🔴

| Téma | Vlastními slovy | Rozhodovací pravidlo / gotcha | Conf | Odkaz / lab |
|---|---|---|---|---|
| Foundry Agent Service — vytvořit agenta |  | portál vs. VS Code vs. SDK | ⬜ |  |
| Built-in tools |  | knowledge / code interpreter / search — co kdy | ⬜ |  |
| Custom tools / function calling |  | kdy function call vs. built-in tool | ⬜ |  |
| Knowledge & memory |  |  | ⬜ |  |
| Workflows & multistep |  | tool-augmented flow; multi-agent | ⬜ |  |
| Govern agent behavior |  | oversight modes, constraints, tool-access | ⬜ |  |

## Doména — Text analysis / NLP (10–15 %) 🟠

| Téma | Vlastními slovy | Rozhodovací pravidlo / gotcha | Conf | Odkaz / lab |
|---|---|---|---|---|
| Azure AI Language — sentiment/entities/PII |  | prebuilt vs. custom | ⬜ |  |
| Custom text classification / NER |  |  | ⬜ |  |
| Question answering / CLU |  | QA vs. CLU — kdy co | ⬜ |  |
| Speech — STT / TTS / custom |  |  | ⬜ |  |
| Translation |  |  | ⬜ |  |

## Doména — Computer vision (10–15 %) 🟠

| Téma | Vlastními slovy | Rozhodovací pravidlo / gotcha | Conf | Odkaz / lab |
|---|---|---|---|---|
| Image analysis (AI Vision) |  | tagy/popis/objekty | ⬜ |  |
| Object detection / facial |  |  | ⬜ |  |
| OCR / read |  | kdy AI Vision OCR vs. Document Intelligence | ⬜ |  |
| Video Indexer |  |  | ⬜ |  |

## Doména — Information extraction (10–15 %) 🟠

| Téma | Vlastními slovy | Rozhodovací pravidlo / gotcha | Conf | Odkaz / lab |
|---|---|---|---|---|
| Document Intelligence |  | prebuilt vs. custom model; layout vs. field extraction | ⬜ |  |
| Azure AI Search pro extrakci |  | skillset; integrace s RAG | ⬜ |  |

---

## Rozhodovací filtry (trénovat na scénáře)

- **Foundry hranice:** project setup / deployment / prompt flow / evaluation / agent config / monitoring / integration?
- **Grounding:** je potřeba retrieval / AI Search / index / citace?
- **Agent workflow:** konverzace / tool calling / function call / memory / permissions / human review?
- **Modalita:** generative / vision / speech / text / translation / information extraction?
- **Model selection:** kvalita vs. cena vs. latence; GlobalStandard vs. Standard vs. DataZone; reasoning (o-series) vs. gpt-4o?
