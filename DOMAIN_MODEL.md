# DOMAIN_MODEL.md

## Purpose

This document is the canonical, implementation-grounded source for CompleteOS+'s domain language: the exact entities, fields, states, and relationships V1 is built on, as verified against the live Supabase project — not as assumed from `schema.sql` (confirmed stale) or from documentation that predates that verification.

It exists to freeze the domain model so implementation can proceed phase by phase (see `MIGRATION_PLAN.md`) without re-deriving or re-litigating these definitions per task.

**Status: Frozen and approved by the Product Architect, 2026-07-24; amended 2026-07-25 to incorporate ADR-002 (Event removed), ADR-003 (`lifecycle_state` supersedes `is_active` on `tasks`), and ADR-004 (`completed` approved for removal) from `ARCHITECTURE_DECISIONS.md` — all three Approved.** Changing an entity, field, state, or relationship defined here requires the same sign-off as any other architecture change (BUILD_RULES.md's Change Process) — not a silent edit during implementation. **ADR-001 (Reminder as a capability) remains Proposed and is deliberately NOT reflected here yet** — Reminder stays a `task_type` in this document until that ADR is approved. Every field marked "approved for removal/supersession" below describes **target architecture only** — the live database and app code are unmigrated until the corresponding `MIGRATION_PLAN.md` phase is actually implemented; do not assume otherwise.

### Relationship to other documents

| Document | Role |
|---|---|
| VISION.md | Long-term, unbounded ambition. Not scoped to V1; do not use to justify a domain decision here. |
| V1_PRODUCT.md | Authoritative for **V1 product scope** — which Commitment Types and lifecycle stages exist and why. This document implements that scope as concrete entities/fields/states; it does not redefine scope. |
| DOMAIN_ARCHITECTURE.md | The long-term conceptual domain (Workspace/Area/Goal/Project/Task/Schedule/Automation/Document/Person/Asset/Metric) across the platform's full life, V1 and beyond. This document is the V1-scoped, schema-grounded subset of it — see "V1 Scope Markers" below for how the two relate. |
| DATABASE.md | Table-by-table schema reference. This document is entity-first and states the same facts in domain terms; DATABASE.md is column-first and states them in schema terms. They must agree — if they ever don't, DATABASE.md's live-verified facts win until this document is corrected. |
| GLOSSARY.md | A short alphabetical index for quick lookup. This document is the detailed, authoritative definition each glossary entry should point back to — GLOSSARY.md does not independently define terms anymore. |
| MIGRATION_PLAN.md | The phased plan for closing the gap between this document and the live database/app code. |

### V1 Scope Markers

Every entity and field below is marked:

- **IN V1** — required, part of the frozen model.
- **DEFERRED** — a real long-term domain concept (lives in DOMAIN_ARCHITECTURE.md) explicitly excluded from V1 by V1_PRODUCT.md.
- **OUT OF V1 SCOPE (undecided)** — not required for V1, but never explicitly deferred either — V1_PRODUCT.md is silent on it. Silence is not exclusion; this marker exists precisely so nobody infers scope from silence (the mistake V1_PRODUCT.md itself was written to prevent).
- **OPEN QUESTION** — the entity/field exists in the live schema, but its V1 behavior is explicitly undecided per V1_PRODUCT.md's "Open Questions" section. Do not implement against it until the Product Architect resolves it.

---

# Entities

## Area — IN V1

**Definition:** A permanent responsibility domain the user's work is organized under (Health, Finance, Family, Career, Growth, ...).

**Owns:** Projects, Tasks (of any `task_type`), Recurring Templates.

**Canonical fields:** `id`, `user_id`, `name`, `description`, `active` (boolean), `created_at`.

**Verified live:** RLS correctly enforced (`auth.uid() = user_id`, all four operations). 9 live rows.

**Known schema risk:** `name` has no scoping constraint recommendation issue like Project (DATABASE.md recommends `UNIQUE (user_id, lower(name))` as future work, not yet applied) — low priority, not a migration blocker.

---

## Project — IN V1

**Definition:** A structured initiative that organizes related Tasks. Answers "what initiative are we working on?"

**Owned by:** Area (optional parent).

**Owns:** Tasks (via `tasks.project_id`).

**Canonical fields:** `id`, `user_id`, `area_id`, `name`, `status`, `priority`, `started_at`, `target_date`, `completed_at`, `is_active`.

**Verified live:** 9 real rows exist, but **RLS has zero policies — the app's real client cannot read or write this table at all today** (see MIGRATION_PLAN.md Phase 1). The "read-only dropdown" credited in prior status tracking is almost certainly rendering empty for real users right now.

**Known schema risk:** `name` is globally unique (not scoped per user) — flagged in DATABASE.md, real multi-user conflict risk.

---

## Task — IN V1 (the universal execution object)

**Definition:** The single execution object for all real-world commitments. Per SYSTEM_PRINCIPLES.md P009 and P022, and DATABASE.md's "Universal Task Model": Habit, Routine, Bill, Appointment, and Reminder are **not separate tables** — they are rows in `tasks`, differentiated by `task_type`. This is implemented, not aspirational; verified in the live schema and live data.

**Owned by:** Area and/or Project (both optional).

**The six Commitment Types (`task_type` values), per V1_PRODUCT.md as amended by ARCHITECTURE_DECISIONS.md ADR-002 (Approved 2026-07-25):**

| `task_type` | Meaning | Type-specific fields (IN V1) |
|---|---|---|
| `Task` | Ordinary actionable work, no fixed occurrence pattern | none — base fields only |
| `Habit` | Repeated behavior tracked for consistency | `target_value`, `unit`, `frequency`, `tracking_type` |
| `Routine` | Reusable ordered sequence of steps | steps live in `routine_steps`, keyed by `task_id` |
| `Bill` | Recurring or one-time payment obligation | `amount`, `payee`, `login_url` |
| `Appointment` | A commitment involving another party or an external obligation — not merely "anything scheduled" (sharpened by ADR-002; previously defined only by its fields) | `start_at`, `end_at`, `location` |
| `Reminder` | Surfaced at the right time rather than executed as work | **OPEN QUESTION** — see below; also the subject of ADR-001 (Proposed, not yet approved), which would remove this as a `task_type` in favor of a universal capability |

**`Event` is removed** as a commitment identity — ADR-002 (Approved 2026-07-25): Event had no unique lifecycle distinct from a plain scheduled Task, unlike Appointment, which does (accountability to another party). No merge target; anything previously modeled as Event is simply a `Task` (or another type) using the universal Start/End scheduling fields. **Approved target architecture, not yet implemented** — `task_type = 'Event'` remains a valid, unmigrated live value until the `MIGRATION_PLAN.md` Phase 2 item executes; zero live rows exist, so this carries no data-migration risk when it does.

**Verified live (2026-07-24):** of 24 real rows, only `Task` (16), `Reminder` (4), `Habit` (2), and `Routine` (2) actually exist — **zero `Bill`, `Appointment`, or `Event` rows exist in production**, despite Appointment/Event having working `start_at`/`end_at` wiring at the time of that audit (since regressed — see Scheduling Model below). This means Bill and Appointment have never been exercised with real data — migration and testing plans should not assume any real-world data exists for either.

### Universal fields (apply to every `task_type`)

| Field | Type | V1 status | Notes |
|---|---|---|---|
| `id`, `created_at`, `user_id` | — | IN V1 | standard |
| `project_id`, `area_id` | uuid | IN V1 | optional parent references |
| `template_id` | uuid | OPEN QUESTION | references `recurring_templates` — see Recurring Template entity below |
| `name` | text | IN V1 | title |
| `status` | text | IN V1 (frozen) | **Three values only: `Pending` / `In Progress` / `Completed`.** `Skipped`/`Postponed` were removed from the UI and confirmed intentional (see MIGRATION_PLAN.md — the Action Option Sheet's Skip/Postpone buttons need rethinking, not restoring the old values). Any document still showing five values is stale. |
| `priority` | text | IN V1 | Critical / High / Medium / Low |
| `priority_rank` | smallint | IN V1 | drives Current Action ordering; exists live, was missing from `schema.sql` until this migration |
| `due_at` | timestamptz | IN V1 target architecture, repurposed to Deadline — **but currently the sole production scheduling field** | Target: becomes the optional **Deadline** field once Start/End is implemented. **Current implementation baseline (corrected 2026-07-25): `due_at` is the only scheduling field wired end-to-end today, for every `task_type`.** See Scheduling Model below for the current-vs-target split. |
| `start_at`, `end_at` | timestamptz | IN V1 target architecture; **not currently implemented for any task_type** | Target: the primary scheduling fields, universal across all types. **Current implementation baseline (corrected 2026-07-25): zero wiring exists.** These were wired for Appointment/Event as of commit `1c08b68` (verified 2026-07-21), but that wiring was subsequently removed during unrelated EditorHost debugging and never restored — only the Due Date implementation was restored afterward. 0 of 24 live rows have either set. Do not assume any code path (TaskForm, EditorHost, Current Action, `current_action_candidates`) can read or write these fields until this is rebuilt and re-verified. |
| `completed_at` | timestamptz | IN V1 | completion timestamp |
| `completed` | boolean | **APPROVED FOR REMOVAL (ADR-004, Approved 2026-07-25) — not yet migrated** | Redundant with `status`. Live data confirms it had already drifted: 12 of 24 rows have `completed = false` while `status = 'Completed'`. Not read anywhere in application code (verified: only the generated Supabase accessor references it). `status` is the single source of truth going forward, per SYSTEM_PRINCIPLES.md P007. **The column still exists live and in the app's generated code** until the `MIGRATION_PLAN.md` Phase 2 migration (`ALTER TABLE tasks DROP COLUMN completed`) is actually executed. |
| `is_active` | boolean | **APPROVED FOR SUPERSESSION by `lifecycle_state` (ADR-003, Approved 2026-07-25, Phase 1 = `tasks` only) — not yet migrated** | Current: universal boolean; for Habit/Routine it means "is the recurring definition still enabled"; for other types it defaults `true` and carries no meaning yet. **Target:** `lifecycle_state` (`Active`/`Paused`/`Archived`) supersedes this through migration, on `tasks` only for Phase 1 — `projects.is_active`/`day_blocks.is_active` are unaffected and stay boolean unless a later phase extends the model to them. **The `is_active` column and its current boolean semantics remain live and unchanged** until the corresponding migration executes; see ARCHITECTURE_DECISIONS.md ADR-003 for full rationale. |
| `calendar_sync`, `calendar_event_id`, `calendar_synced_at`, `completion_synced` | — | **OUT OF V1 SCOPE (undecided)** | An entire calendar-sync subsystem implied by the schema. Confirmed 100% unused in application code. Not mentioned anywhere in V1_PRODUCT.md — not deferred, simply never scoped in. Do not build against these without a Product Architect decision to bring calendar sync into V1. |
| `requires_verification`, `verification_status` | — | OPEN QUESTION | V1_PRODUCT.md explicitly asks whether this is a personal completion-honesty feature or vestigial multi-person-accountability scope that doesn't belong in V1 at all |
| `reminder_level`, `acknowledged_at` | — | OPEN QUESTION | V1_PRODUCT.md explicitly asks what these should do for the Reminder Commitment Type. **Note:** 10 of 24 live rows have `reminder_level` set despite zero application code ever writing it — this is very likely seed/test data inserted directly, not evidence of real usage; do not treat it as a signal that this field is already working. |

### Scheduling Model

**Target architecture (Confirmed Architecture Decision, ARCHITECTURE.md, 2026-07-22 — unchanged, still approved):**

- **Start Date & Time / End Date & Time** are the primary scheduling fields, used across every `task_type` — not Appointment/Event-only.
- **Deadline** (the `due_at` column, repurposed) is optional, populated only when a task genuinely needs a hard deadline distinct from its start/end window.
- Current Action orders candidates by `priority_rank`, then start time — not due/deadline time.

**Current implementation baseline (corrected 2026-07-25 — this is implementation status, not an architecture change):**

- `due_at` is the only scheduling field currently wired end-to-end, for every `task_type`. Treat it as the current production scheduling field until Start/End is rebuilt.
- `start_at`/`end_at` have **zero current wiring**, for any type. They were wired for Appointment/Event as of commit `1c08b68` (verified 2026-07-21), but that wiring was removed during unrelated EditorHost debugging and never restored. This is a regression to fix, not new ground to break.
- The live `current_action_candidates` view still filters on `due_at` only — this is now the *correct* current-state description, not a stale one. Current Action ordering by `start_at` must not be assumed to work, or built against, until Phase 4.1 (MIGRATION_PLAN.md) both restores the Start/End wiring and updates this view together, and both are verified against real data.

### Relationships

```text
tasks.user_id     → auth.users.id
tasks.project_id  → projects.id
tasks.area_id     → areas.id
tasks.template_id → recurring_templates.id   (OPEN QUESTION, see below)

Referenced by:
block_items.task_id
habit_logs.task_id
routine_steps.task_id
```

---

## Recurring Template — OPEN QUESTION

**Definition (as designed):** A blueprint for generating repeated Task/Habit/Routine/Bill instances — schedule type, pattern, frequency, next-run tracking.

**V1 status is explicitly undecided.** V1_PRODUCT.md asks directly: does V1 need the fully configurable Recurring Templates engine, or does a simple frequency-based repeat on Habit/Routine/Bill satisfy "Repeat" for V1? **Do not build against this table until that's answered** — building UI or generation logic against it would be implementing an entity whose V1 shape isn't frozen.

**Verified live (2026-07-24):** the table is not dead — it holds **46 real rows**, and 10 live `tasks` rows reference one via `template_id` (all valid, none orphaned). But it also has **zero RLS policies**, so none of this is currently reachable by the app's real client either way. Whatever the Product Architect decides about scope, the RLS gap (MIGRATION_PLAN.md Phase 1) must be fixed before any part of this entity — simple or full — can function live.

---

## Schedule primitives — IN V1 (block-first internally, calendar-first for the user)

Per ARCHITECTURE.md's Confirmed Architecture Decision: the system runs internally on Day Blocks and Daily Plans; the user-facing experience should feel like a calendar built on top of that engine.

| Entity | Definition | Canonical fields | Live status |
|---|---|---|---|
| **Day Block** | A reusable time-block template (Morning, Work, Recovery, ...) | `id`, `user_id`, `name`, `is_active`, `start_time`, `end_time`, `sort_order` | 0 rows; RLS has zero policies |
| **Block Item** | An item placed inside a Day Block, referencing a Task of any `task_type` | `id`, `user_id`, `day_block_id`, `task_id`, `item_type`, `title`, `target_amount`, `unit`, `target_time`, `deadline_time`, `sort_order`, `is_required` | 0 rows; RLS has zero policies; `item_type` currently only documents Task/Habit/Routine — whether Bill/Appointment/Reminder are schedulable into a block is unresolved, same open-question status as the Recurring Template question above |
| **Daily Plan** | A generated or manual execution plan for one specific day | `id`, `user_id`, `plan_date`, `template_id`, `plan_type`, `status`, `source` | 0 rows; RLS has zero policies; `user_id` has no FK defined |
| **Daily Plan Block** | A runtime instance of a Day Block inside a Daily Plan — today's actual schedule | `id`, `daily_plan_id`, `user_id`, `area_id`, `block_name`, `start_time`, `end_time`, `sort_order`, `status`, `source_day_block_id` | 0 rows; RLS has zero policies; `daily_plan_id`/`user_id`/`area_id` have no FKs defined |

**Sequencing:** per ARCHITECTURE.md and ROADMAP.md, this entity group is built *after* the Universal Task Model (all Commitment Types — six per ADR-002, or five if ADR-001 is later approved) is functionally complete — not in parallel. Projects CRUD is the sole documented exception to "finish the Task Model first."

---

## Habit Log — IN V1

**Definition:** Completion history for a Habit-type Task.

**Canonical fields:** `id`, `user_id`, `task_id`, `status`, `log_date`, `completed_at`, `notes`.

**Verified live:** 0 rows; RLS has zero policies. `task_id` is the correct join key (added post-migration; pre-migration historical rows, if any existed, would have `task_id = NULL` — moot here since the table is empty).

---

## Routine Step / Routine Step Log — IN V1

**Definition:** `routine_steps` are the ordered steps inside a Routine-type Task; `routine_step_logs` record their completion.

**Canonical fields:** `routine_steps`: `id`, `task_id`, `name`, `step_order`, `is_required`, `created_at`. `routine_step_logs`: `id`, `user_id`, `routine_step_id`, `log_date`, `completed_at`, `created_at`.

**Verified live:** `routine_steps` has **15 real rows** (data exists, likely seeded — no application code writes to this table yet). `routine_step_logs` has 0 rows. Both have zero RLS policies.

**Schema note (relevant to migration risk):** `routine_steps` has **no `user_id` column** — ownership is only reachable through `task_id → tasks.user_id`. Its RLS policy cannot copy the direct-column pattern used everywhere else; it needs a subquery through the parent task. This is called out specifically in MIGRATION_PLAN.md Phase 1 because it is the one table in that phase that isn't mechanical.

---

## Profile — IN V1

**Definition:** User profile/preferences, one row per `auth.users` row.

**Canonical fields:** `id` (= `auth.users.id`), `display_name`, `timezone`, `wake_time`, `sleep_time`, `created_at`, `updated_at`.

**Verified live:** auto-created on signup by the `on_auth_user_created` trigger → `handle_new_user()` `SECURITY DEFINER` function — confirmed working. 3 live rows. **RLS has zero policies** — the trigger's `SECURITY DEFINER` bypass is why creation still works, but the app's real client cannot read its own profile back today.

---

## Current Action — IN V1 (concept, not a table)

**Definition:** The single highest-priority Task the user should execute next, across all Commitment Types. Served by the live `current_action_candidates` view (verified to exist; absent from `schema.sql`).

**Not an entity with its own storage** — it's a query result over `tasks`, ordered by `priority_rank` then `due_at`. This will move to `start_at` per the target Scheduling Model above, but not until Start/End is rebuilt and verified (see the Current Implementation Baseline note above) — do not assume or build against a `start_at`-based ordering as a present-tense fact.

---

# Deferred and Out-of-Scope Entities

These are real concepts in DOMAIN_ARCHITECTURE.md's long-term model. None have any table, row, or code path in the current schema — there is nothing to migrate for any of them. Listed here only so scope is explicit, not silent.

| Entity | Status | Why |
|---|---|---|
| **Goal** | DEFERRED | V1_PRODUCT.md explicitly excludes it — a direction-setting concept, not something captured/organized/planned/executed/reviewed daily like a Commitment Type. |
| **Automation** (general-purpose, user-configurable) | DEFERRED | V1_PRODUCT.md explicitly excludes the general system. A *much* smaller mechanism — generating the next occurrence of a repeating commitment — may be required to make "Repeat" work at all; that smaller mechanism is the same open question as Recurring Template above, not full Automation. |
| **Workspace** | OUT OF V1 SCOPE (undecided) | DOMAIN_ARCHITECTURE.md's top of the ownership hierarchy. V1_PRODUCT.md is single-owner/personal-use only and never mentions Workspace as a concept to build. There is no `workspaces` table. Treat V1 as implicitly a single personal workspace; do not build multi-workspace machinery. |
| **Document, Person, Asset, Metric** | OUT OF V1 SCOPE (undecided) | Part of DOMAIN_ARCHITECTURE.md's four Domain Categories, but **not mentioned anywhere in V1_PRODUCT.md** — not evaluated, not deferred with a reason, simply never brought into V1 scope. No tables exist for any of them. Flagged here so nobody infers "must eventually build this" from DOMAIN_ARCHITECTURE.md's presence without a V1_PRODUCT.md decision first. |

---

# Canonical State Machines

## `tasks.status` (frozen, 3 values)

```text
Pending → In Progress → Completed
```

No `Skipped`/`Postponed` values exist in the UI or should be written by any new code. The Action Option Sheet's Skip/Postpone buttons are known to be designed around the old 5-value model and need a product rethink, not a direct restore — see MIGRATION_PLAN.md.

## `task_type` (target: 6 values; live/unmigrated: 7 values)

**Target (ADR-002, Approved 2026-07-25):** `Task`, `Habit`, `Routine`, `Bill`, `Appointment`, `Reminder` — see the Task entity table above for what's live vs. built. `Reminder` stays a `task_type` for now only because ADR-001 (removing it in favor of a universal capability) is still Proposed, not because it's settled.

**Live/unmigrated:** the database still accepts `Event` as a 7th value until the `MIGRATION_PLAN.md` Phase 2 migration drops it from the check constraint. Zero live rows use it, so this is a documentation-vs-schema gap, not a data risk.

## `is_active` → `lifecycle_state` (target, `tasks` only; live/unmigrated: boolean, universal)

**Target (ADR-003, Approved 2026-07-25, Phase 1 = `tasks` only):** `lifecycle_state` (`Active` / `Paused` / `Archived`) supersedes `is_active` on `tasks` through migration. `projects`/`day_blocks`/`recurring_templates` are out of Phase 1's scope and keep their boolean `is_active`/`active` for now.

**Live/unmigrated:** `tasks.is_active` is still a plain boolean today, independent of `status`. For Habit/Routine: whether the recurring definition is enabled. For all other types: defaults `true`, no defined meaning yet. This remains accurate until the Phase 1 lifecycle migration executes.

---

# Explicitly Open Questions (not resolved by this document)

Carried forward verbatim from V1_PRODUCT.md — this document freezes everything *except* these, which remain the Product Architect's decisions to make before the corresponding MIGRATION_PLAN.md phase can execute:

1. What should `reminder_level` and `acknowledged_at` actually do for the Reminder Commitment Type?
2. Is `requires_verification`/`verification_status` a personal completion-honesty feature, or vestigial multi-person-accountability scope that doesn't belong in V1 at all?
3. Does V1 need the fully configurable Recurring Templates engine, or does a simple frequency-based repeat on Habit/Routine/Bill satisfy "Repeat" for V1?
4. Is a minimal recurring-instance-generation mechanism itself V1-required infrastructure, or part of question 3?

---

# Change Control

This document is frozen as of 2026-07-24. Any change to an entity, field, state, or relationship defined here — including resolving one of the Open Questions above — requires the same approval as any other architecture change (BUILD_RULES.md's Change Process, step 8: "Wait for approval if the change alters architecture"). Implementation should not silently drift from this document; if code and this document diverge, that is a bug in the code or a signal this document needs a Product-Architect-approved update, not a reason to guess.
