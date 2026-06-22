---
name: check-progress
description: Use when the user wants to know if they are on track or behind schedule for the AI-103 exam. Triggers - "check progress", "jak na tom jsem", "jak teču", "stíhám to", "jsem pozadu", "behind schedule", pacing / time check against the study plan.
---

# check-progress

## Overview

Spočítá, jak časově stojíš proti svému plánu do zkoušky AI-103. Porovná **co bys měl mít
hotové dnes** (dle datovaného rozpisu, který vygeneroval `/setup`) s **realitou v trackeru**
a řekne, o kolik modulů / dní teču napřed nebo pozadu, vč. konkrétního catch-up doporučení.

**Read-only** — nic nezapisuje (na zápis je `update-status`).
Zdroj: [AI-103_progress-tracker.md](../../../AI-103_progress-tracker.md) — master tabulka
**i blok `## 🗓️ Studijní plán`** (datum↔Den + kumulativní cíle), který vyplnil `/setup`.
Status model `⬜ → ⏳ → ✅`.

> Pokud blok `## 🗓️ Studijní plán` v trackeru chybí (plán ještě nevygenerovaný),
> řekni uživateli ať spustí **`/setup`** — bez datovaného rozpisu nejde pacing počítat.

## Workflow

### 1. Zjisti dnešní datum a Den N
```powershell
Get-Date -Format "yyyy-MM-dd dddd"
```
Najdi dnešní datum v tabulce **Datum ↔ Den** v bloku `## 🗓️ Studijní plán`. Z ní vyčti
**Den N**, počet zbývajících dní a počet zbývajících **studijních** dní do termínu.
Když dnešek není studijní den (off-day) → řekni to, žádný skluz se za ten den nepočítá.
Po termínu zkoušky / mimo okno: napiš to a jen spočítej dní do data zkoušky.

### 2. Spočti realitu z trackeru
Read master tabulku a sečti **`✅`** ve sloupcích `📖` a `🧪` — celkem i per Path (P1/P2/P3/P4).
`⏳` = rozpracováno (počítej zvlášť), `⬜` = nezačato. Vezmi i Dashboard pro kontrolu.

### 3. Kolik bys měl mít hotové (kumulativní cíl k *konci* daného dne)
Vyčti z tabulky **Kumulativní cíl** v bloku `## 🗓️ Studijní plán` (řádek pro Den N):
kolik modulů `✅` (📖+🧪) bys měl mít a které M# k němu patří.

### 4. Výstup
- `Dnes <datum> = Den N. Do zkoušky zbývá <X> dní (<Y> studijních).`
- `Cíl k dnešku: ~<cíl> modulů. Máš: <📖✅> přečteno / <🧪✅> labů (+<⏳> rozpracováno).`
- **Verdikt:** `Teču +P modulů napřed` / `Teču −P modulů pozadu ≈ Q dní skluzu`
  (Q ≈ P / průměr modulů na studijní den z plánu).
- Per-path breakdown (kde to vázne).

### 5. Doporučení
- **Pozadu:** aplikuj **🔺 Triage** z trackeru — P1+P2 laby dělej celé, u P3+P4 lab jen
  *přečti kód* (`🧪 = přečteno`); nikdy neškrtej čtení modulu + zápis do notes. Slabá místa
  (`Conf ⬜`/`🟡`) první. Vyjmenuj konkrétní M#, které dnes dohnat.
- **Napřed:** nabídni spaced repetition (`🔁` u `Conf ⬜`/`🟡`) nebo `/quiz-me`.
- **Konsolidační dny** (poslední 1–2 dny v plánu) = žádné nové moduly, jen sandbox /
  slabá místa / quiz — pojistka na přetečený obsah.

## Common Mistakes
- **Počítat `⏳`/`⬜` jako hotové** — hotovo je jen `✅`.
- **Počítat skluz za off-day** — dny volna jsou v plánu označené; necountuj je jako skluz.
- **Plošné doporučení** — vždy jmenuj konkrétní M# a respektuj váhy domén (P1+P2 přednost).
- **Hádat data** — všechno ber z bloku `## 🗓️ Studijní plán`; když chybí, pošli na `/setup`.
