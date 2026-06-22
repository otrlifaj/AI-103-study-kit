---
name: done
description: Use when the user marks AI-103 study progress — e.g. "/done M05", "hotovo M03", "přečteno M12", "lab M07 hotový", "M09 green", "zopáknuto M02", "rozpracováno M04" — to update status in the AI-103 progress tracker and recompute its dashboard.
---

# /done — update AI-103 progress tracker

Sets module status in repo-root `AI-103_progress-tracker.md` and recomputes its dashboard. That file is the single source of truth — never track progress anywhere else.

## Status scheme (3-state, per the tracker legend)

`⬜ nezačato` → `⏳ rozpracováno` → `✅ hotovo`. `/done` sets `✅`; `wip` sets `⏳`.
The `Conf` column is separate: `⬜ neumím` → `🟡` → `🟢` (a glyph, not a status).

## Arguments

`/done <module…> [columns…] [state] [conf]`

- **Module:** `M01`–`M30` (case-insensitive; bare `5` = `M05`). Multiple allowed: `/done M03 M04`.
- **Columns** — which status cells to set. **Omit = all three.**
  - `read` / `přečteno` / `📖`  ·  `lab` / `🧪`  ·  `rev` / `review` / `zopáknuto` / `🔁`
- **State** — `done` (default → `✅`) or `wip` / `start` / `rozpracováno` (→ `⏳`).
- **Confidence** (optional): `red`/`⬜`, `yellow`/`🟡`, `green`/`🟢`.

Examples: `/done M03` (all ✅) · `/done M05 read` (📖 only) · `/done M07 read lab green` · `/done M04 wip` (📖🧪🔁 → ⏳) · `/done M03 M04`

## Procedure

1. **Read** `AI-103_progress-tracker.md` to get each target row's *current* status/Conf values.
2. **Edit** the row. A row has four glyph cells in order: `📖 | 🧪 | 🔁 | Conf`. Build the new four-cell segment from current + requested changes, and match a **unique prefix** (domain + day cells) so the edit lands on the right row.

   *Example — `/done M05 read green` when row 5 is fresh (`⬜ ⬜ ⬜ ⬜`):*
   - old: `(RAG/grounding) | 2 | ⬜ | ⬜ | ⬜ | ⬜ |`
   - new: `(RAG/grounding) | 2 | ✅ | ⬜ | ⬜ | 🟢 |`

   Only the requested column(s) change; untouched cells keep their current value.
3. **Recompute the dashboard** by counting `✅` across the 30 master-table rows:
   - `📖 Modulů přečteno` = rows with ✅ in the **📖** (1st) cell → `N / 30`
   - `🧪 Labů hotových` = ✅ in the **🧪** (2nd) cell
   - `🔁 Zopáknuto` = ✅ in the **🔁** (3rd) cell
   - Per-path `Hotovo X / N` = modules in that path with **all three** status cells ✅
     (P1 = rows 1–6, P2 = 7–15, P3 = 16–22, P4 = 23–30)
4. **Report** one line per module (what changed) + the new dashboard totals.

## Rules

- Edit **only** `AI-103_progress-tracker.md`. Don't touch `_notes/`.
- Never invent modules — if `Mxx` isn't in the table, say so and stop.
- Don't confuse the status `⬜` with the `Conf ⬜` (4th cell) — they mean different things.
- Don't auto-commit unless the user asks.
- Reminder (don't block on it): the 1-sentence summary + decision rule belong in the matching row of `_notes/ai103-notes.md`.
