# ARCHITECTURE_DECISIONS.md

## Purpose

This document records architectural decisions as they are proposed and made — an ADR (Architecture Decision Record) log, not a status report. It exists so decisions have a durable, honest history: what was proposed, why, what it costs, and when it was actually approved — instead of the canonical documents (`DOMAIN_MODEL.md`, `DATABASE.md`, `MIGRATION_PLAN.md`) silently changing shape with no record of why.

**Every entry below is newly proposed in this session (2026-07-24/25) — none of it reflects a prior decision.** `DOMAIN_MODEL.md` and `DATABASE.md` continue to describe the currently-approved repository architecture and are **not** updated by this document. They will be updated once the relevant ADR's Status changes to Approved, and only then.

### Status values

- **Proposed** — drafted for review, not yet acted on. Canonical docs must not be changed to match a Proposed ADR.
- **Approved** — the Product Architect has signed off. Canonical docs and `MIGRATION_PLAN.md` should be updated to match, and the corresponding "decision" phase in `MIGRATION_PLAN.md` becomes an implementation phase.
- **Rejected** — considered and declined. Kept for history; canonical docs are unaffected.
- **Superseded** — replaced by a later ADR, which should be linked.

---

## ADR-001: Reminder as a Capability Instead of a Commitment Identity

**Status: Proposed**

### Current Implementation

`Reminder` is one of the seven `task_type` values in the Universal Task Model (`DATABASE.md`, `DOMAIN_MODEL.md`). A Reminder is a full `tasks` row with `task_type = 'Reminder'`. Unlike Habit (`target_value`/`unit`/`frequency`/`tracking_type`) or Bill (`amount`/`payee`/`login_url`), Reminder has no dedicated type-specific columns of its own — its only plausible fields are the universal-but-unused `reminder_level`/`acknowledged_at`, which are confirmed 100% unreferenced in application code. Live-verified 2026-07-24: 4 of 24 `tasks` rows have `task_type = 'Reminder'` (second most common type after `Task`), with zero dedicated create/edit fields, zero distinct display metadata, and zero distinct execution behavior built.

### Problem

V1_PRODUCT.md defines Reminder by *when it surfaces*, not *what kind of thing it is*: "a commitment whose primary purpose is to be surfaced at the right time, rather than executed as work." That's a cross-cutting behavior, not a distinct kind of work — a Bill or an Appointment can just as easily need "remind me about this" as a standalone Task can. Modeling it as a 7th, mutually-exclusive `task_type` forces a false choice: nothing can be both `Bill` and `Reminder` today. This conflicts directly with SYSTEM_PRINCIPLES.md P022 ("Prefer Generic Solutions Over Type-Specific Ones").

### Proposed Decision

Remove `Reminder` from the `task_type` enum. Add a universal capability (working name: `is_remindable`, boolean) alongside the existing `reminder_level`/`acknowledged_at` fields, made meaningful on **any** `task_type` rather than gated behind one. Any task — regardless of its type — can carry a reminder.

*This ADR proposes the structural change only. It does not resolve what `reminder_level`/`acknowledged_at` should actually do — that remains a separate open question (see `V1_PRODUCT.md` Open Questions and `MIGRATION_PLAN.md` Phase 2.2), unchanged by this ADR.*

### Benefits

- Removes a false mutual-exclusivity — any commitment can be remindable, not just ones typed as `Reminder`.
- Aligns with P022 (generic over type-specific).
- No UI sunk cost to preserve: Reminder currently has zero dedicated fields or behavior built, per the V1 audit.
- Matches V1_PRODUCT.md's own definition of Reminder as a *timing* concern, not an *identity*.

### Tradeoffs

- Reminder stops being a first-class, independently listable "kind" of commitment. Anywhere the product wants "show me my Reminders" as a distinct view, that becomes "tasks where the reminder capability is set" instead of a `task_type` filter — a real filtering/UX change, not just a rename.
- Requires deciding the exact mechanism (a single boolean vs. something richer) — proposed here as a boolean for simplicity; open to revision.
- 4 live rows need migrating from `task_type = 'Reminder'` to some other type (proposed: `Task`, with the new capability flag set) — low risk (small row count, verified non-orphaned), but not zero-risk like ADR-002 below.

### Migration Impact

- `tasks.task_type` check constraint/enum: drop `'Reminder'`.
- Add `tasks.is_remindable` (or equivalent) boolean column.
- Data migration: the 4 live `task_type = 'Reminder'` rows → `task_type = 'Task'`, `is_remindable = true`.
- `lib/`: every place `task_type` values are enumerated or branched on (task type selector, per-type list filters, `task_type_section_widget.dart`) needs the `Reminder` branch removed and a capability-based UI element added instead — not yet scoped in detail, since no such UI exists to modify today.
- Docs once Approved: `DOMAIN_MODEL.md` (Task entity, Commitment Type table), `DATABASE.md` (`task_type` field, Universal fields table), `GLOSSARY.md` (Reminder, Commitment Type entries), `V1_PRODUCT.md` ("seven Commitment Types" becomes six — see ADR-002 for the further reduction to five).

---

## ADR-002: Removal of Event as a Commitment Identity

**Status: Proposed**

### Current Implementation

`Event` is one of the seven `task_type` values, sharing an identical field set with `Appointment` (`start_at`, `end_at`, `location`) — DATABASE.md documents them together as "Appointment/Event-specific" fields, and the most recent FlutterFlow export wired `start_at`/`end_at` for both identically and simultaneously (per `PROJECT_STATUS.md`: "Appointment/Event `start_at`/`end_at` fields now have real end-to-end wiring"). Live-verified 2026-07-24: **zero rows exist for `task_type = 'Event'`** (and zero for `Appointment` too — neither type has ever been exercised with real data).

### Problem

Event and Appointment are functionally indistinguishable in the current schema and implementation: identical fields, identical wiring, identical (absent) execution behavior. V1_PRODUCT.md's own definitions barely differ — "Appointment: a scheduled meeting or commitment at a specific time, often at a specific place" vs. "Event: a scheduled occurrence similar to an Appointment." Carrying two `task_type` values with zero behavioral or structural difference violates SYSTEM_PRINCIPLES.md P007 (One Source of Truth) and P022 (generic over type-specific), and doubles the type-selector, list-filtering, and future execution-behavior work for a distinction that doesn't exist in the schema today.

### Proposed Decision

Remove `Event` from the `task_type` enum. Anything that would have been an Event becomes `task_type = 'Appointment'`.

### Benefits

- Eliminates a genuinely redundant type with zero behavioral distinction from Appointment.
- Reduces the Universal Task Model from seven types toward five (combined with ADR-001) with no loss of real capability — there is nothing Event-specific to lose.
- Simplifies the still-unbuilt type selector and execution-behavior work for this pair.
- **Zero live data — zero migration risk.** This is the lowest-risk change of the four in this document.

### Tradeoffs

- If a real distinction between "Event" and "Appointment" exists in the Product Architect's intent but was never reflected in the schema (e.g., attended-vs-scheduled-with-someone), that distinction is lost here and would need to be reintroduced later as a field (e.g. `appointment_kind`), not a type.
- Every place V1_PRODUCT.md, DOMAIN_MODEL.md, DATABASE.md, and GLOSSARY.md state "seven Commitment Types" needs updating once this and ADR-001 are both decided.

### Migration Impact

- `tasks.task_type` check constraint/enum: drop `'Event'`.
- No data migration required (0 live rows).
- `lib/`: remove the `Event` branch from the type selector and any per-type list filters; no distinct Event-only code path exists to rewire, per the current audit.
- Docs once Approved: same set as ADR-001.

---

## ADR-003: Lifecycle State Replacing `is_active`

**Status: Proposed**

### Current Implementation

`is_active` (or `active`) is a boolean on `tasks`, `projects`, `day_blocks`, and `recurring_templates`. Per `DATABASE.md`/`DOMAIN_MODEL.md`: for Habit/Routine tasks it means "is the recurring definition still enabled"; for every other `task_type` it defaults `true` and carries no defined meaning; for `projects`/`day_blocks`/`recurring_templates` it's a simple on/off toggle. Live-verified 2026-07-24: **all 24 live `tasks` rows have `is_active = true`** — the "off" state has never been exercised with real data on this table.

### Problem

A boolean collapses several genuinely different situations into one "off" state — most concretely, a paused Habit (temporarily not being tracked, but still meaningful and expected to resume) is indistinguishable from an abandoned one (done with permanently) once both are just `is_active = false`. There's also no draft/not-yet-started state distinct from "actively running." *(Framing note: this problem statement and the state set below are this session's proposal, not a restatement of something you specified — flag any state name or scope change you want in review, this is exactly what Proposed status is for.)*

### Proposed Decision

Replace the boolean `is_active` with a small enumerated `lifecycle_state` field, proposed states: **`Active` / `Paused` / `Archived`** — the smallest change that adds a genuinely useful middle state (temporarily off vs. permanently done) beyond today's binary, without inventing a larger state machine with no evidence of need.

**Proposed scope:** apply this only to `tasks`, where `is_active` currently carries real meaning (Habit/Routine). Leave `projects.is_active` and `day_blocks.is_active` as plain booleans for now — nothing in the current audit indicates they need more than active/inactive, and extending the richer model to them can be a later, separately-justified decision rather than a blanket rollout.

### Benefits

- Distinguishes "temporarily off" from "permanently done" for Habit/Routine, which a boolean cannot.
- Matches realistic usage (pausing a habit during travel/illness vs. abandoning it).
- Scoped to where the audit found actual meaning (`tasks`) rather than speculatively touching three other tables with no evidence they need it — consistent with SYSTEM_PRINCIPLES.md P023 (defer non-blocking technical debt, don't build ahead of a demonstrated need).

### Tradeoffs

- A 3-state field is more code to branch on than a boolean everywhere it's read — every `lib/` call site touching `tasks.is_active` needs updating to check `lifecycle_state` instead (call sites not yet enumerated — that inventory is implementation work, not part of this ADR).
- Zero live rows are currently `is_active = false`, so there's no real "off" data to reconcile, but the migration still has to map all 24 existing `true` rows to `Active` unambiguously.
- Leaves `projects`/`day_blocks`/`recurring_templates` on the old boolean model — the platform temporarily has two different "is this on" patterns side by side, which is an intentional scope limit, not an oversight, but is worth naming as a tradeoff.

### Migration Impact

- `tasks.is_active` (boolean) → new `tasks.lifecycle_state` (text/enum) column.
- Backfill: all 24 existing rows (`is_active = true`) → `lifecycle_state = 'Active'`.
- `lib/`: inventory and update every call site reading/writing `tasks.is_active` (not yet done — first step of implementation once Approved).
- Docs once Approved: `DOMAIN_MODEL.md`'s `is_active` state-machine section, `DATABASE.md`'s Universal fields table.

---

## ADR-004: `completed` Boolean Consolidation with `status`

**Status: Proposed**

### Current Implementation

`tasks` carries both `status` (text, frozen 3-value: `Pending`/`In Progress`/`Completed`) and `completed` (boolean). `DATABASE.md` documents `completed` as a "completion flag." Verified via code search 2026-07-24: `completed` is referenced **nowhere** in application logic — only in the generated Supabase accessor (`tasks.dart`, `current_action_candidates.dart`), which is auto-generated and calls nothing itself.

### Problem

Two fields represent the same fact — whether a task is done — with no mechanism keeping them in sync, and live data proves they've already diverged: **12 of 24 rows have `completed = false` while `status = 'Completed'`** (zero rows show the reverse mismatch, confirmed 2026-07-24). This is a direct violation of SYSTEM_PRINCIPLES.md P007 (One Source of Truth) and an active correctness trap: any future code, report, or migration that reads `completed` expecting it to reflect reality will silently get the wrong answer for half of today's completed tasks.

### Proposed Decision

Drop the `completed` column. `status = 'Completed'` becomes the sole source of truth for task completion.

### Benefits

- Removes an already-drifted, redundant field with **zero current application-code dependency** — verified, not assumed.
- Restores a single source of truth for completion state, per P007.
- Removes a trap for any future feature that might read `completed` and get a wrong answer.
- This is the lowest-ambiguity ADR of the four — it resolves a data-integrity bug already found live, not a new design question.

### Tradeoffs

- Destructive schema change (column drop) — irreversible without a backup/restore, though no information is actually lost: `status` already correctly captures completion for all 24 live rows.
- Any future external tool, report, or integration that might expect a `completed` boolean (none identified today) would need to derive it from `status = 'Completed'` instead.

### Migration Impact

- Supabase migration: `ALTER TABLE tasks DROP COLUMN completed`.
- `schema.sql` refresh to match.
- `lib/`: no changes required — verified zero call sites beyond the generated accessor, which regenerates automatically once the column no longer exists.
- Docs once Approved: `DOMAIN_MODEL.md` and `DATABASE.md`'s `completed` entries change from "deprecated" to "removed."

---

## Review and Next Steps

None of the four ADRs above are reflected in `DOMAIN_MODEL.md`, `DATABASE.md`, or `MIGRATION_PLAN.md` yet — those documents still describe the currently-approved architecture (`Reminder`/`Event` as live `task_type` values, `is_active` as a boolean, `completed` as deprecated-but-present) and should be treated as authoritative until this document says otherwise.

For each ADR, review and choose: **Approve as proposed**, **approve with changes** (note the change directly in this document, updating the relevant section), or **reject**. Once an ADR's Status changes to Approved:

1. `DOMAIN_MODEL.md` and `DATABASE.md` get updated to match, with a note pointing back to this ADR.
2. The corresponding item in `MIGRATION_PLAN.md`'s Phase 2 (Domain Data-Integrity Decisions) moves out of "decision required" and into a scoped implementation phase, using this ADR's Migration Impact section as the starting checklist.
3. Implementation proceeds per the normal phase-by-phase approval process already in place.
