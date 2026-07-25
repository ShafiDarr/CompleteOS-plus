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

**Status: Proposed** — full design below, per the Product Architect's request 2026-07-25, revised 2026-07-25 per review feedback (timing model reframed as "primary scheduling field," `acknowledged_at` removed outright rather than folded into `status`). **Keep this ADR in Proposed status until the design itself is approved. Nothing in this section authorizes implementation or a canonical-doc update.**

### Current Implementation

`Reminder` is one of the seven `task_type` values in the Universal Task Model (`DATABASE.md`, `DOMAIN_MODEL.md`). A Reminder is a full `tasks` row with `task_type = 'Reminder'`. Unlike Habit (`target_value`/`unit`/`frequency`/`tracking_type`) or Bill (`amount`/`payee`/`login_url`), Reminder has no dedicated type-specific columns of its own — its only plausible fields are the universal-but-unused `reminder_level`/`acknowledged_at`.

**Evidence gathered 2026-07-25 to ground this design** (repo code + live data, not assumption):

- No notification-delivery infrastructure exists anywhere in the codebase. `pubspec.yaml` has zero notification packages (no `flutter_local_notifications`, `firebase_messaging`, or equivalent). There is no mechanism today by which CompleteOS+ could fire a push/local alert at a scheduled moment, for any feature. This is a hard constraint on what "reminder" can mean in V1, not a detail — see Recommended Design below.
- `Reminder`'s only UI presence in `lib/` is: an entry in the `task_type` selector dropdown (`task_form_widget.dart:227`), a `task_type = 'Reminder'` filter in a "Reminders" list section ordered by `due_at` (`systems_control_panel_widget.dart`), and a `notifications_active_rounded` bell icon shown when `task_type == 'Reminder'` (`current_action_widget.dart:126-130`). No dedicated fields, no dedicated create/edit flow, no distinct execution behavior.
- **The 4 live `task_type = 'Reminder'` rows are all the same real commitment ("traffic court") captured as 4 separate rows with different dates, spaced roughly monthly (2026-04-29 through 2026-07-01).** All 4: `status = 'Completed'`, `due_at` set, **`start_at`/`end_at` both null, `reminder_level` both null, `acknowledged_at` both null.** This is the single most useful piece of evidence available: the one real usage of this feature never touched `reminder_level` or `acknowledged_at` at all, and consistently anchored on `due_at` as "when this matters." Real usage already validates `due_at`/Deadline as the natural reminder anchor, and gives no signal that reminder-intensity or an acknowledgment state were ever needed.

### Problem

V1_PRODUCT.md defines Reminder by *when it surfaces*, not *what kind of thing it is*: "a commitment whose primary purpose is to be surfaced at the right time, rather than executed as work." That's a cross-cutting behavior, not a distinct kind of work — a Bill or an Appointment can just as easily need "remind me about this" as a standalone Task can. Modeling it as a 7th, mutually-exclusive `task_type` forces a false choice: nothing can be both `Bill` and `Reminder` today. This conflicts directly with SYSTEM_PRINCIPLES.md P022 ("Prefer Generic Solutions Over Type-Specific Ones").

**What problem Reminder actually solves in V1 (item 1):** not notification delivery — V1 has no infrastructure for that, and V1_PRODUCT.md never mentions push/local notifications as in scope. The real problem is narrower and matches the mission in V1_PRODUCT.md (Capture → Organize → Plan Today → Execute → Review): making sure a commitment whose main risk is *being forgotten* — not being executed wrong, just forgotten entirely — reliably resurfaces through the surfacing mechanisms CompleteOS+ already has (Current Action, Plan Today), rather than silently sitting unflagged among ordinary tasks. Reminder is an attention signal on top of the existing execution engine, not a delivery channel.

### Recommended V1 Design

**A single boolean capability on `tasks`, anchored to whichever scheduling field is currently the commitment's primary one, with no new timing field and no acknowledgment state of any kind (including inside `status`).**

1. **Problem solved (see above):** surfacing risk, not execution or delivery.
2. **Minimum V1 behaviors required (item 2):**
   - Any task, of any type, can be flagged as needing to be remembered.
   - It surfaces through the *existing* Current Action / Plan Today mechanisms — no new surfacing engine. For V1, this can be as minimal as: no special ordering treatment at all (a remindable task competes on the same `priority_rank`/due-or-start ordering as everything else) — see Open Questions for whether that's sufficient or whether remindable items should get a ordering boost.
   - V1 does not track reminder acknowledgment at all — see item 7. There is nothing to acknowledge without a delivery mechanism (no push/local notification exists), so this isn't a gap, it's a direct consequence of scope.
   - No push/local notification is required for V1 — see Current Implementation's infrastructure note. If real-world need for actual OS-level alerts emerges, that is a distinct, larger feature (notification delivery infrastructure) to design separately, not something to half-build into this schema now.
3. **Storage shape (item 3):** **fields directly on `tasks`**, not a child table, not a hybrid. A child `reminders` table would only pay for itself if V1 needed multiple independent reminder points per commitment, arbitrary per-reminder offsets, or delivery-channel metadata — none of which V1 needs today (see item 4 and Current Implementation's evidence). Building that structure now, with nothing to populate it meaningfully, would repeat the exact mistake that produced the vestigial `calendar_sync`/verification column set this whole ADR effort exists to clean up. A boolean-plus-existing-field design is the smallest thing that actually serves the stated problem.
4. **Multiple reminders per commitment (item 4):** **No, not in V1.** No evidence of this need exists — the 4 live rows read as 4 distinct commitments (separate court dates), not one commitment needing several staged nudges, though the evidence is not fully conclusive either way (see Alternatives). If a genuine need for multiple reminder points per single commitment emerges later, that is the trigger for revisiting the child-table alternative below — not something to speculatively support now.
5. **Timing model (item 5) — revised per review:** **Reminder anchors to the primary scheduling field currently available for the commitment, not permanently to `due_at`.** Today that primary field is `due_at`, because Start/End scheduling (`start_at`/`end_at`) is not currently implemented (see ADR-003) — so for V1, in practice, a remindable task's "when" is its `due_at`, matching the live evidence exactly. This is described as a *current fact about which field is primary*, not a permanent anchor decision: when Start Date scheduling is restored, Reminder may anchor to `start_at` where appropriate (e.g., an Appointment's start rather than an arbitrary deadline) without requiring a domain-model change here — Reminder simply continues pointing at "the commitment's primary scheduling field," whatever that resolves to at the time. No new timing field is added now regardless — an explicit relative/offset field (e.g., "3 days before") is still out of scope for V1, since nothing exists to consume it (see item 6 rationale and Alternatives C). Reminder does not get its own timing field at all; it always reads whichever scheduling field the commitment already exposes.
6. **`reminder_level` (item 6):** **Remove.** Zero code references it; the one real user of this feature never populated it, even though they clearly wanted reminder behavior. It was speculative infrastructure for a notification-intensity concept that has no meaning without a delivery mechanism to route through. Removing it is the same judgment already applied to `completed` in ADR-004: an unused field that real usage never needed.
7. **`acknowledged_at` (item 7) — revised per review:** **Remove entirely. Do not fold acknowledgment into `status`.** Per review feedback: `status` represents commitment *progress* (Pending/In Progress/Completed); acknowledgment would represent *notification interaction* (did the user see/dismiss an alert) — these are different concepts, and collapsing them into one field would make `status` do two jobs, recreating exactly the kind of overloaded-field problem ADR-004 just resolved for `completed` vs. `status`. Since V1 has no notification delivery mechanism, there is nothing to acknowledge, so V1 requires no acknowledgment behavior at all — the correct move is removing `acknowledged_at` outright, not relocating what it represented into `status`. If a real acknowledgment concept becomes necessary later (once actual notification delivery exists), it should get its own field again at that point, separate from `status`.
8. **How this differs from adjacent concepts (item 8):**
   - **Due Date / Deadline (`due_at`):** a *field* every task already has, and currently the commitment's primary scheduling field (see item 5). Reminder is a *capability* (a flag) that says this particular commitment's primary scheduling field matters enough to be surfaced proactively — it doesn't add a new date, it flags whichever one already exists.
   - **Start Date (`start_at`):** not currently implemented (ADR-003), so not usable as an anchor today. Once restored, it becomes a legitimate reminder anchor for commitments where "start" is the meaningful moment (e.g., an Appointment) — Reminder's design already accommodates this without change, since it always follows "the primary scheduling field," not `due_at` specifically.
   - **Alerts / push notifications:** a *delivery mechanism* that doesn't exist in this codebase. Reminder-as-capability is a data signal describing intent ("surface this proactively"); it is deliberately decoupled from any specific delivery technology so V1 doesn't have to build one to ship the capability.
   - **Current Action:** the prioritization *engine* that decides what's next across every commitment. A remindable task is just one more input into that engine — it does not compete with or duplicate Current Action; at most it's a signal that engine could someday weight differently (see Open Questions).
   - **Recurring occurrences:** explicitly out of scope for this ADR per instruction. Worth flagging directly: the 4-duplicate-row pattern in the live data looks like exactly the kind of manual workaround a real Recurring Templates/repeat decision (Phase 2B.3) might eventually remove — but that connection is noted here only, not resolved.
9. **Migration of the 4 live rows (item 9):** `task_type` changes from `'Reminder'` to `'Task'` for all 4 rows (nothing else distinguishes them from an ordinary task once the type is gone); set the new capability flag `true` on all 4 (preserves original intent); `due_at`, `status`, `priority` all carry over unchanged; `reminder_level`/`acknowledged_at` are already `NULL` on all 4, so their removal loses no data. Zero ambiguity, zero data loss — a straightforward 4-row `UPDATE`.
10. **Smallest V1 implementation (item 10):**
    - **Schema:** one new boolean column on `tasks` (working name `is_remindable`, default `false`); drop `'Reminder'` from the `task_type` check constraint; drop `reminder_level` and `acknowledged_at` columns entirely.
    - **FlutterFlow/`lib/`:** remove the `Reminder` entry from the `task_type` selector (can ride the same change as ADR-002's `Event` removal, since both touch the same dropdown); add a single toggle/checkbox ("Remind me") near the Deadline field in TaskForm, wired through EditorHost's existing save path exactly like any other boolean field (e.g. `is_active`) — no new save-flow branch needed; change the Systems Control Panel "Reminders" list filter from `task_type = 'Reminder'` to `is_remindable = true` (ordering by `due_at` unchanged); change Current Action's bell-icon condition from `task_type == 'Reminder'` to `is_remindable == true` (see Open Questions for how this interacts with the per-type icon).

### Alternatives Considered

- **A. Separate `reminders` child table** (one or more rows per task, arbitrary offsets, delivery-channel metadata). Rejected for V1: no evidence of a multi-reminder-per-task need, and no notification mechanism exists to justify the added complexity. Revisit if/when real push-notification infrastructure becomes a V1+ goal and multiple staged alerts per commitment become a real, requested behavior.
- **B. Keep `Reminder` as its own `task_type`** (status quo). Rejected — this is the premise ADR-001 already has agreement to change; included only for contrast.
- **C. Offset-based timing** (`remind_offset_minutes` relative to the commitment's primary scheduling field). Rejected for V1 — nothing can consume it without a scheduler, and the one real usage never needed anything beyond the exact scheduling field's own value.
- **E. Fold acknowledgment into `status`** (e.g., an implicit "acknowledged" reading of `Completed`, or a new status value). Rejected per review — `status` represents commitment progress; acknowledgment represents notification interaction; conflating them recreates the overloaded-field problem ADR-004 already resolved for `completed`/`status`. Since V1 has no notification mechanism to acknowledge anything from, the correct answer is removing `acknowledged_at`, not relocating its meaning.
- **D. Richer `reminder_level` enum** (e.g., gentle/urgent, mapped to future notification channels/sounds). Rejected — same no-infrastructure, no-evidence reasoning as C; the field already existed and was never used even once.

### Tradeoffs

- Reminder stops being a first-class, independently listable "kind" of commitment. Anywhere the product wants "show me my Reminders," that becomes "tasks where `is_remindable` is set" instead of a `task_type` filter — a real filtering/UX change, not just a rename (scoped in item 10 above).
- No dedicated relative/offset timing (e.g., "3 days before") for either `due_at` or `start_at` — a plausible, genuinely useful future capability, deliberately deferred because it requires both a new field *and* real delivery infrastructure to mean anything; building either alone would recreate a dead column. Anchoring to "whichever scheduling field is primary" (item 5) avoids a due_at-only lock-in, but it's still an exact-moment anchor, not a lead-time one.
- No support for multiple reminder touchpoints per commitment — if the traffic-court-style pattern actually reflects "one obligation needing several staged nudges" rather than "several distinct obligations," this design doesn't serve that within a single task row; the same manual-duplication workaround the live user already uses would remain the only option, unless a future Recurring Templates decision addresses it instead.
- Removing `reminder_level`/`acknowledged_at` is destructive (column drop) — irreversible without a backup, though zero data is actually lost (both are `NULL` on every live row that would be affected).
- A single boolean can't express "remind me, but gently" — that nuance is dropped entirely rather than preserved in simplified form; acceptable because nothing today demonstrates a real need for it, but worth naming as a real capability reduction, not just a cleanup.
- V1 has zero acknowledgment tracking of any kind (not even folded into `status`) — if a future notification mechanism is built, "was this reminder actually seen" will need a new field at that point; this design doesn't preserve any placeholder for it, by design, per review feedback to avoid speculative fields.

### Proposed Schema Changes

- `tasks.is_remindable` — new boolean column, default `false`.
- `tasks.task_type` — drop `'Reminder'` from the check constraint (5 remaining values, pending this ADR's approval, down from 6 after ADR-002).
- `tasks.reminder_level` — drop column.
- `tasks.acknowledged_at` — drop column.
- No new tables.

### Migration Impact

- Supabase migration: add `is_remindable`; 4-row `UPDATE` (`task_type = 'Reminder'` → `'Task'`, `is_remindable = true`); drop `task_type` constraint's `'Reminder'` value; drop `reminder_level`/`acknowledged_at` columns. Can be sequenced together with ADR-002's Event-removal migration since both touch `task_type` and are low-risk/low-row-count.
- `schema.sql` refresh to match.
- `lib/`: TaskForm type selector, Systems Control Panel "Reminders" list filter, Current Action's bell-icon condition — all scoped in item 10 above. No Repository-layer redesign needed; this is additive-boolean-field work, not a new data-access pattern.
- Docs to update once Approved (not now): `DOMAIN_MODEL.md`, `DATABASE.md`, `GLOSSARY.md`, `V1_PRODUCT.md` (Commitment Types drop from six to five), `MIGRATION_PLAN.md` (Phase 2B.1 moves to Phase 2A as a ready-to-implement item; **Phase 2B.2's vestigial-column-set scope narrows** — `reminder_level`/`acknowledged_at` are resolved by this ADR and should be removed from that still-open bucket, leaving only the calendar-sync/verification columns there, which remain untouched by this ADR per instruction).

### UI Impact

- TaskForm: `Reminder` removed from the type dropdown; a new "Remind me" toggle appears near the Deadline field, available on every task type.
- Systems Control Panel: "Reminders" section becomes a capability-filtered list (`is_remindable = true`) instead of a type-filtered one; visually unchanged otherwise.
- Current Action: the bell icon's trigger condition changes from a type check to a capability check — see Open Questions for whether it should coexist with the per-type icon or replace it when both apply.
- No new screens, dialogs, or navigation — this is a field-level change within existing surfaces, consistent with "smallest V1 implementation" above.

### Open Questions Requiring Your Approval

1. **Field name:** `is_remindable` is a working name used throughout this proposal — confirm or rename before implementation.
2. **Icon treatment in Current Action:** today, `task_type == 'Reminder'` fully replaces the task-type icon with a bell. Once Reminder is a capability layered on any type, does a remindable Bill show the Bill icon, the bell icon, or both (e.g., a small badge)? This wasn't resolvable from existing evidence — it's a real UI call.
3. **Current Action ordering:** should `is_remindable = true` give a task any priority boost or special treatment in Current Action's ordering, or does it compete purely on the same `priority_rank`/due-or-start basis as everything else? This design assumes "no special treatment" as the minimum viable behavior (item 2) — confirm that's sufficient for V1.
4. **Destructive column drops:** confirm `reminder_level` and `acknowledged_at` should be fully removed (not deprecated-in-place, and not folded into `status`) — both are empty on every live row, but this is the same category of irreversible decision as ADR-004's `completed` removal and deserves the same explicit sign-off. *(Addressed in review: confirmed — remove outright, do not overload `status`.)*
5. **Scope boundary with Phase 2B.2:** confirm that resolving `reminder_level`/`acknowledged_at` here (as part of Reminder's own design) rather than lumping them with the still-open calendar-sync/verification column set is the intended split — this ADR narrows that other bucket as a side effect, and I want that narrowing itself confirmed, not assumed.

---

## ADR-002: Removal of Event as a Commitment Identity

**Status: Approved (2026-07-25)**

**Revised, then approved, 2026-07-25:** the original version of this ADR proposed merging Event into Appointment. That proposal was withdrawn — Appointment and Event are not equivalent, and folding one into the other would have diluted Appointment's actual meaning. The revision below (Event removed for lacking a unique lifecycle; Appointment kept as a distinct type representing commitments involving another party or external obligation) is the version that was approved.

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
- **Resolved by this ADR's approval:** V1_PRODUCT.md, DOMAIN_MODEL.md, DATABASE.md, and GLOSSARY.md now state six Commitment Types (updated 2026-07-25). They would drop to five if ADR-001 is also approved.

### Migration Impact

- `tasks.task_type` check constraint/enum: drop `'Event'`. No data reassignment to Appointment or anywhere else — no data migration required at all (0 live rows).
- `Appointment`'s field set (`start_at`/`end_at`/`location`) is unchanged structurally; only its documented definition sharpens to "involves another party or external obligation."
- `lib/`: remove the `Event` branch from the type selector and any per-type list filters; no distinct Event-only code path exists to rewire, per the current audit.
- Docs updated 2026-07-25 now that this ADR is Approved: `DOMAIN_MODEL.md`, `DATABASE.md`, `GLOSSARY.md`, `V1_PRODUCT.md`, `ARCHITECTURE.md`, `ROADMAP.md` — Event removed (no merge note), Appointment's definition sharpened to its distinguishing trait. **The live database and app code are not yet migrated** — `task_type = 'Event'` remains a valid live value until the Supabase migration and `lib/` type-selector change described above are actually implemented; canonical docs now describe target architecture, with implementation tracked separately in `MIGRATION_PLAN.md`.

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

**Review round 1 (2026-07-25):** ADR-002, ADR-003, and ADR-004 are **Approved** (ADR-002 and ADR-003 each with the revisions/modifications noted in their entries). **ADR-001 remains Proposed** — this is the only ADR still open.

**ADR-001 design drafted 2026-07-25 (still Proposed, not approved):** a full evidence-based design was produced at the Product Architect's request, addressing problem statement, minimum V1 behaviors, storage shape, timing model, `reminder_level`/`acknowledged_at` disposition, differentiation from adjacent concepts, migration of the 4 live rows, alternatives considered, tradeoffs, proposed schema changes, UI impact, and five specific open questions requiring approval — see ADR-001's entry above in full. Recurring Templates (Phase 2B.3) and the remaining calendar-sync/verification column set (Phase 2B.2, narrowed by this design to exclude `reminder_level`/`acknowledged_at`) were deliberately not addressed, per instruction — those stay separate, still-open items.

**ADR-001 revised 2026-07-25, second pass (still Proposed):** Product Architect agreed with the overall direction and requested two changes, both incorporated above: (1) the timing model no longer permanently anchors Reminder to `due_at` — it now anchors to "the commitment's primary scheduling field," which is `due_at` today only because Start/End scheduling isn't implemented yet (ADR-003), and will extend to `start_at` automatically once that's restored, with no domain-model change needed; (2) `acknowledged_at` is removed outright rather than folded into `status` — `status` (progress) and acknowledgment (notification interaction) are confirmed as separate concepts that should not share a field, and since V1 has no notification mechanism, there is nothing for V1 to acknowledge. The one-reminder-per-commitment, no-child-table, `reminder_level`-removal, and no-scheduling-engine points were confirmed as-is. Remaining open items: field naming, Current Action icon treatment, Current Action ordering treatment, and the Phase 2B.2 scope-boundary confirmation.

**Canonical docs updated 2026-07-25 to match the three Approved ADRs:** `DOMAIN_MODEL.md`, `DATABASE.md`, `ARCHITECTURE.md`, `V1_PRODUCT.md`, `GLOSSARY.md`, `ROADMAP.md`, and `MIGRATION_PLAN.md` now describe Event as removed, `completed` as approved-for-removal, and `is_active` as approved-for-supersession-by-`lifecycle_state` (`tasks` only, Phase 1) — each clearly marked as **approved target architecture, not yet implemented**, per the same current-vs-target discipline established for the Start/End regression. The live database and app code are unchanged; `task_type = 'Event'`, `tasks.completed`, and `tasks.is_active` all still exist and function exactly as before until the corresponding `MIGRATION_PLAN.md` phases are actually executed. `Reminder` remains untouched everywhere, including as a live `task_type`, since ADR-001 has not been approved.

Once ADR-001 also reaches a final status:

1. Any remaining canonical-doc gap closes in the same pass (primarily: the Commitment Type count, currently six, and the Reminder entity's shape).
2. Its Migration Impact section becomes a scoped `MIGRATION_PLAN.md` implementation phase, same as the other three.
3. Implementation proceeds per the normal phase-by-phase approval process already in place — the summary of what's still open versus ready to implement is maintained in `MIGRATION_PLAN.md`.
