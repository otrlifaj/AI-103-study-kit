---
name: update-status
description: Use when the user finished a module/lab and wants a guided debrief that records progress — asks what they did, then fills both the AI-103 progress tracker and the _notes knowledge base. Triggers - "update status", "zapiš co jsem udělal", "udělal jsem", "hotovo (chci i zapsat poznámku)", end-of-module debrief.
---

# update-status

## Overview

Interaktivní „po-modulový debrief": **zeptá se, co jsi udělal**, a pak to zapíše na **dvě** místa:
1. **Tracker** (status + Conf + dashboard) — deleguje na skill `done`, ať se mechanika editace neduplikuje.
2. **Knowledge base** [_notes/ai103-notes.md](../../../_notes/ai103-notes.md) — vyplní řádek tématu (věta + rozhodovací pravidlo + confidence + odkaz).

> Rozdíl od `done`: `done` je rychlý, argument-driven (`/done M05 read green`) a notes neřeší. `update-status` se ptá a hlavně **zachytí poznámku** (přesně to, na co `done` jen upozorňuje). Když uživatel poznámku nechce, použij rovnou `done`.

## Workflow

### 1. Interview (zeptej se, co je hotové)
Nabídni rozumné defaulty z trackeru (rozdělaný `⏳` / další `⬜` modul). Zjisti:
- **Který modul/y** (M01–M30).
- **Úroveň:** přečteno `📖` / lab `🧪` / zopáknuto `🔁` (klidně víc; default = přečteno+lab).
- **Confidence** po tomhle průchodu: `⬜` / `🟡` / `🟢`.
- **Poznámka (jádro):** 1 věta vlastními slovy, co služba/modul řeší + **rozhodovací pravidlo / gotcha** („kdy X vs. Y"). Když uživatel neví, krátce navrhni návrh z obsahu modulu a nech ho potvrdit.

### 2. Zapiš tracker (přes `done`)
Z odpovědí složil argumenty a **vyvolej skill `done`** (Skill tool), ať provede překlopení status buněk + Conf + přepočet dashboardu jednotně.
- Příklad: přečteno+lab M05, confidence 🟡 → `done M05 read lab yellow`.
- Jen čtení M03, zatím bez labu → `done M03 read`.

### 3. Zapiš poznámku do `_notes/ai103-notes.md`
Soubor je **tabulka-per-doména** s předpřipravenými řádky témat (sloupce: `Téma | Vlastními slovy | Rozhodovací pravidlo / gotcha | Conf | Odkaz / lab`).
- Najdi **odpovídající řádek tématu** ve správné doménové tabulce a vyplň prázdné sloupce (Vlastními slovy, Rozhodovací pravidlo, Conf, Odkaz/lab).
- Když řádek pro téma neexistuje, **přidej nový řádek** do správné doménové tabulky (ne nový blok).
- `Conf` v notes drž v sync s `Conf` v trackeru.
- Odkaz = cesta k modulu/labu v repu (např. `labs/<suite>/Labfiles/.../Python/`, kde jsi lab odjel).

### 4. Potvrď
Vypiš: co se změnilo v trackeru (řádky + nový dashboard z `done`) **a** který řádek notes byl doplněn.

## Common Mistakes
- **Appendovat do notes místo vyplnit řádek** — notes mají hotové řádky témat; doplň je.
- **Duplikovat editaci trackeru** — neřeš glyfy ručně, deleguj na `done`.
- **Zapsat status, zapomenout poznámku** — poznámka je hlavní přidaná hodnota tohohle skillu (scénářové otázky = rozhodovací pravidla).
- **Plést `Conf ⬜` se status `⬜`** — Conf je samostatný sloupec (4. glyf v řádku trackeru).
- **Auto-commit** — necommituj, dokud uživatel neřekne.
