---
name: quiz-me
description: Use when the user wants exam-style scenario practice questions for AI-103. Triggers - "quiz me", "vyzkoušej mě", "otázky", "procvič", "practice questions", "dej mi scénář", drill before the exam. Generates scenario questions grounded in read modules, weighted by domain weight and weak confidence.
---

# quiz-me

## Overview

Generuje **scénářové** zkouškové otázky ve stylu AI-103 („jak bys to postavil"), ne faktografické kvízy. Vychází z reálného obsahu přečtených modulů + rozhodovacích pravidel v notes (negeneruje z hlavy). Váží otázky dle **váhy domény** a tvé **confidence** — drilluje slabá místa.

**Read-only** — nic nezapisuje; na konci jen *doporučí* úpravu confidence (přes `update-status` / `done`).
Zdroje: [AI-103_progress-tracker.md](../../../AI-103_progress-tracker.md), `learn/**`, [_notes/ai103-notes.md](../../../_notes/ai103-notes.md).

## Workflow

### 1. Urči rozsah a váhy
- Z argumentu (`quiz-me P2` / `quiz-me M05` / `quiz-me agents`), jinak **default**:
  - jen moduly s `📖 ✅` (co už znáš), aby otázky stály na probrané látce;
  - **váž dle domény:** P1 + P2 (gen AI + agentic, 🔴 ~60 %) nejvíc otázek; P3 + P4 (🟠) do šířky;
  - **přednost slabým:** moduly s `Conf ⬜`/`🟡` první; `🟢` přeskoč (spaced repetition).
- Když ještě nic není `📖 ✅`, nabídni quiz z modulů dne 0 nebo cross-cutting Plan & manage.

### 2. Grounding
Read relevantní `learn/...md` + odpovídající řádky notes (rozhodovací pravidla). Otázky stav na faktech odtud, ať nejsou vymyšlené.

### 3. Polož otázky (interaktivně, jedna po druhé)
- Formát jako zkouška: **scénář** + best-answer / single nebo multiple choice (4–5 možností), občas „seřaď kroky" / „doplň službu".
- **Jedna otázka → počkej na odpověď → teprve pak** odhal: správně/špatně, **proč**, jaké **rozhodovací pravidlo** to testuje, odkaz na unit/Source.
- Promíchej průřezové **Plan & manage** (keyless/MI, RBAC role, model selection GS vs. Standard vs. DataZone, content safety, monitoring) — je to 25–30 % a průřezové.
- Default sada ~5 otázek; pokračuj, dokud uživatel chce.

### 4. Shrnutí + doporučení
- Vypiš skóre + **slabá místa** (témata, kde chyboval).
- Navrhni konkrétní úpravu confidence v trackeru (např. „M07 spíš `🟡` než `🟢`") → ať si pustí `update-status` / `done`.
- Případně odkaz na modul k zopákování.

## Common Mistakes
- **Faktografické otázky místo scénářů** — zkouška testuje „kdy co použít", ne definice.
- **Odhalit odpověď hned** — vždy nech uživatele odpovědět první.
- **Kvízovat nepřečtené moduly** — default jen `📖 ✅` (jinak se to jen tipuje).
- **Ignorovat váhy** — víc otázek do P1+P2 a do slabé confidence.
- **Zapisovat do trackeru** — quiz-me jen doporučuje; zápis dělá `update-status`/`done`.
