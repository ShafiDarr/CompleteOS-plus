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

**Reviewed 2026-07-25:** direction agreed (Reminder should become a capability), but not approved — remains Proposed until the actual Reminder behavior/mechanism is designed. Do not implement or update canonical docs from this ADR yet.

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

**Revised 2026-07-25:** the original version of this ADR proposed merging Event into Appointment. That proposal is withdrawn — Appointment and Event are not equivalent, and folding one into the other would have diluted Appointment's actual meaning. The revision below reflects the corrected reasoning: Event is removed because it has no unique lifecycle, not because it's a duplicate of Appointment.

### Current Implementation

`Event` is one of the seven `task_type` values, sharing the same scheduling field set as `Appointment` (`start_at`, `end_at`, `location`) — DATABASE.md documents them together as "Appointment/Event-specific" fields, and the most recent FlutterFlow export wired `start_at`/`end_at` for both identically and simultaneously (per `PROJECT_STATUS.md`: "Appointment/Event `start_at`/`end_at` fields now have real end-to-end wiring"). Live-verified 2026-07-24: **zero rows exist for `task_type = 'Event'`** (and zero for `Appointment` too — neither type has ever been exercised with real data).

### Problem

Sharing scheduling fields with Appointment is not, on its own, evidence Event and Appointment are the same thing — plenty of distinct commitment types could legitimately share `start_at`/`end_at`. The actual problem is narrower: **Event has no unique lifecycle or behavior of its own.** Anything with a start and end time is already expressible as any commitment type — most naturally `Task` — using the universal Start/End scheduling fields that are part of every `task_type` per the confirmed Scheduling Model (ARCHITECTURE.md, 2026-07-22). "Having a start/end time" is a scheduling attribute available to everything, not a distinguishing trait that earns its own commitment identity. Per SYSTEM_PRINCIPLES.md P009, "separate entities should exist only when their behavior fundamentally differs from Tasks" — Event fails that test on its own terms, independent of whatever Appointment is.

Appointment, by contrast, does have a distinguishing trait: it represents a commitment **involving another party or an external obligation** — a real behavioral/accountability difference from a plain scheduled Task (you can't unilaterally reschedule it the way you can a personal task; someone or something outside the system is depending on it). That's what justifies Appointment remaining its own `task_type` under the same P009 test that Event fails.

### Proposed Decision

Remove `Event` from the `task_type` enum, with **no merge target**. Scheduled work that would previously have been called an "Event" is simply modeled as whatever commitment type it naturally is — most commonly `Task` — using the universal `start_at`/`end_at` scheduling fields already available to every type. `Appointment` remains untouched and unmerged, and its definition is sharpened: it is specifically for commitments involving another party or an external obligation, not "anything with a location and a time."

### Benefits

- Removes a type with no unique lifecycle without diluting a type (Appointment) that does have one — a merge would have lumped purely personal scheduled work in with genuine external commitments.
- Gives Appointment a real semantic hook for future execution-behavior work (e.g., different reminder cadence, confirmation before marking complete) that a catch-all "scheduled thing" category wouldn't support.
- Matches SYSTEM_PRINCIPLES.md P009 precisely, applied independently to both Event (fails the test, removed) and Appointment (passes the test, kept).
- **Zero live data — zero migration risk**, same as the original proposal.

### Tradeoffs

- No obvious catch-all label remains for "something scheduled" in the type selector — a user who thinks "I have an event" now needs to recognize that's a `Task` (or another type) with a start/end time, or an `Appointment` if another party is genuinely involved. This is a real UX/labeling design question for whoever builds the type-selection UI, not resolved by this ADR.
- Appointment's defining criterion ("involves another party or external obligation") is a judgment call at data-entry time — the schema cannot structurally enforce or validate it, so mis-categorization is possible and not preventable at the database level.
- Every place V1_PRODUCT.md, DOMAIN_MODEL.md, DATABASE.md, and GLOSSARY.md state "seven Commitment Types" needs updating once this and ADR-001 are both decided.

### Migration Impact

- `tasks.task_type` check constraint/enum: drop `'Event'`. No data reassignment to Appointment or anywhere else — no data migration required at all (0 live rows).
- `Appointment`'s field set (`start_at`/`end_at`/`location`) is unchanged structurally; only its documented definition sharpens to "involves another party or external obligation."
- `lib/`: remove the `Event` branch from the type selector and any per-type list filters; no distinct Event-only code path exists to rewire, per the current audit.
- Docs once Approved: `DOMAIN_MODEL.md`/`DATABASE.md`/`GLOSSARY.md`/`V1_PRODUCT.md` need Event removed (no merge note) and Appointment's definition sharpened to its distinguishing trait, not just its field set.

---

## ADR-003: Lifecycle State Superseding `is_active`

**Status: Approved (2026-07-25), with modification**

**Approved with changes:** the original wording described Lifecycle as "replacing" `is_active`. Corrected below to "supersedes `is_active` through migration" — the state field is introduced via a migration step that backfills existing rows, not an instantaneous swap. Also clarified: this is Phase 1 of Lifecycle adoption, scoped to `tasks` only; other entities may adopt it in later phases if a need is demonstrated, not ruled out permanently.

### Current Implementation

`is_active` (or `active`) is a boolean on `tasks`, `projects`, `day_blocks`, and `recurring_templates`. Per `DATABASE.md`/`DOMAIN_MODEL.md`: for Habit/Routine tasks it means "is the recurring definition still enabled"; for every other `task_type` it defaults `true` and carries no defined meaning; for `projects`/`day_blocks`/`recurring_templates` it's a simple on/off toggle. Live-verified 2026-07-24: **all 24 live `tasks` rows have `is_active = true`** — the "off" state has never been exercised with real data on this table.

### Problem

A boolean collapses several genuinely different situations into one "off" state — most concretely, a paused Habit (temporarily not being tracked, but still meaningful and expected to resume) is indistinguishable from an abandoned one (done with permanently) once both are just `is_active = false`. There's also no draft/not-yet-started state distinct from "actively running." *(Framing note: this problem statement and the state set below are this session's proposal, not a restatement of something you specified — flag any state name or scope change you want in review, this is exactly what Proposed status is for.)*

### Proposed Decision

A small enumerated `lifecycle_state` field **supersedes the boolean `is_active` through migration** — introduced by a migration step that backfills existing rows into the new states, not an instantaneous field swap. Proposed states: **`Active` / `Paused` / `Archived`** — the smallest change that adds a genuinely useful middle state (temporarily off vs. permanently done) beyond today's binary, without inventing a larger state machine with no evidence of need.

**Phase 1 scope:** this phase applies Lifecycle only to `tasks`, where `is_active` currently carries real meaning (Habit/Routine). `projects.is_active` and `day_blocks.is_active` remain plain booleans in this phase — nothing in the current audit indicates they need more than active/inactive today. Other entities may adopt the Lifecycle model in a future phase if a real need is demonstrated; this is a sequencing decision, not a permanent exclusion.

### Benefits

- Distinguishes "temporarily off" from "permanently done" for Habit/Routine, which a boolean cannot.
- Matches realistic usage (pausing a habit during travel/illness vs. abandoning it).
- Scoped to where the audit found actual meaning (`tasks`) rather than speculatively touching three other tables with no evidence they need it — consistent with SYSTEM_PRINCIPLES.md P023 (defer non-blocking technical debt, don't build ahead of a demonstrated need).

### Tradeoffs

- A 3-state field is more code to branch on than a boolean everywhere it's read — every `lib/` call site touching `tasks.is_active` needs updating to check `lifecycle_state` instead (call sites not yet enumerated — that inventory is implementation work, not part of this ADR).
- Zero live rows are currently `is_active = false`, so there's no real "off" data to reconcile, but the migration still has to map all 24 existing `true` rows to `Active` unambiguously.
- Leaves `projects`/`day_blocks`/`recurring_templates` on the old boolean model for this phase — the platform temporarily has two different "is this on" patterns side by side, an intentional Phase 1 scope limit rather than an oversight, and worth naming as a tradeoff regardless.

### Migration Impact

- `tasks.is_active` (boolean) → new `tasks.lifecycle_state` (text/enum) column, added via migration.
- Backfill: all 24 existing rows (`is_active = true`) → `lifecycle_state = 'Active'`.
- `lib/`: inventory and update every call site reading/writing `tasks.is_active` — first implementation step, tracked as the corresponding phase in `MIGRATION_PLAN.md`.
- Docs to update now that this ADR is Approved: `DOMAIN_MODEL.md`'s `is_active` state-machine section, `DATABASE.md`'s Universal fields table — **held per the instruction to wait until all four ADRs are finalized before touching canonical docs.**

---

## ADR-004: `completed` Boolean Consolidation with `status`

**Status: Approved (2026-07-25)**

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
- Docs to update now that this ADR is Approved: `DOMAIN_MODEL.md` and `DATABASE.md`'s `completed` entries change from "deprecated" to "removed" — **held per the instruction to wait until all four ADRs are finalized before touching canonical docs.**

---

## Review and Next Steps

**Review round 1 (2026-07-25):** ADR-003 and ADR-004 are Approved (ADR-003 with the modifications noted in its entry). ADR-001 remains Proposed pending a Reminder-behavior design. ADR-002 was substantively revised (no merge into Appointment; Event removed for lacking a unique lifecycle, Appointment kept for representing another-party/external-obligation commitments) and remains Proposed pending review of that revision.

**None of the four ADRs are reflected in `DOMAIN_MODEL.md`, `DATABASE.md`, or `MIGRATION_PLAN.md` yet — including the two now Approved.** Per explicit instruction, canonical-document updates are held until *all four* ADRs reach a final status (Approved/Rejected), not applied piecemeal as each one clears review. Those documents still describe the currently-approved architecture (`Reminder`/`Event` as live `task_type` values, `is_active` as a boolean, `completed` as deprecated-but-present) and remain authoritative until this document says otherwise.

For each remaining ADR, review and choose: **Approve as proposed**, **approve with changes** (note the change directly in this document, updating the relevant section), or **reject**. Once all four ADRs have a final status:

1. `DOMAIN_MODEL.md` and `DATABASE.md` get updated to match every Approved ADR in one pass, each with a note pointing back to its ADR.
2. The corresponding items in `MIGRATION_PLAN.md`'s Phase 2 (Domain Data-Integrity Decisions) move out of "decision required" and into scoped implementation phases, using each ADR's Migration Impact section as the starting checklist. Any Rejected ADR's item is removed from Phase 2 instead.
3. Implementation proceeds per the normal phase-by-phase approval process already in place.
