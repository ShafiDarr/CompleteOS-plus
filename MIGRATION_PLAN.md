# MIGRATION_PLAN.md

## Purpose

This is the phased plan for closing the gap between the frozen domain model (`DOMAIN_MODEL.md`) and the live database/application code, based entirely on facts verified directly against the live Supabase project on 2026-07-24 — not on assumptions carried forward from `schema.sql` (confirmed stale) or from documentation written before that verification.

**Status:** Planning complete, approved to exist as a plan. Individual phases below are gated per their own approval requirement — this document does not itself authorize any schema change, destructive migration, or security change. Do not begin implementation from this document alone; get the specific phase's sign-off first where one is marked required.

**Updated 2026-07-25:** Phase 2 restructured following ADR review — ADR-002, ADR-003, ADR-004, and (as of a second review pass the same day) ADR-001 are all Approved (Phase 2A, ready to implement, no further decision needed). Reminder's fields (`reminder_level`/`acknowledged_at`) are resolved by ADR-001 and no longer part of Phase 2B's vestigial-column question, which now covers only the calendar-sync/verification columns (Phase 2B.1) and Recurring Templates scope (Phase 2B.2). Phase 4.1 also corrected the same day to reflect a Start/End implementation regression reported by the Product Architect — see that section for detail. **None of Phase 2A has been implemented yet** — "Approved" describes the decision, not the live schema.

**Ground truth this plan is built on:** `PROJECT_STATUS.md`'s Audit Record and Blockers section (2026-07-24 entries), `DOMAIN_MODEL.md`, and `ARCHITECTURE_DECISIONS.md` (ADR statuses as of 2026-07-25).

---

## How to read this plan

Each phase lists:

- **What** — the concrete change(s).
- **Why** — the verified finding driving it.
- **Risk** — Low / Medium / High, based on blast radius and reversibility.
- **Depends on** — which earlier phase(s) must land first.
- **Affected files** — Supabase migrations, `schema.sql`, specific `lib/` paths, or documentation.
- **Approval** — whether the Product Architect must sign off before implementation starts, and why.

Legend for Approval:

- 🔴 **Required, blocking** — do not start implementation without explicit sign-off.
- 🟡 **Required, lightweight** — a real schema/security change, needs a yes, but low ambiguity/risk.
- 🟢 **Not required** — either purely mechanical (no behavior/security change) or already-confirmed architecture being implemented as designed.

---

## Dependency Graph

```text
Phase 1 (RLS + FKs + schema.sql + linter fixes)
   │
   ├──► Phase 5 (Projects CRUD acceptance testing)          [only needs 1.1's `projects` policy]
   │
   ├──► Phase 4 (Universal Task Model completion)
   │        │
   │        └──► Phase 6 (Schedules: Day Blocks / Daily Plans)
   │
   └──► Phase 2 (Domain data-integrity decisions)             [independent of Phase 4/5/6 timing,
            │                                                   Phase 2A ready to implement now; Phase 2B.2 blocks part of Phase 6]
            └──► (implementation of whichever decisions land)

Phase 3 (scoped UNIQUE constraints) — independent, can run any time after Phase 1
```

---

## Phase 1 — Data-Layer Foundation Fixes

**This phase blocks nearly everything else and should run first.**

### 1.1 Add RLS policies to the 11 unprotected tables

**What:** Add `SELECT`/`INSERT`/`UPDATE`/`DELETE` policies to `profiles`, `projects`, `recurring_templates`, `habit_logs`, `day_blocks`, `block_items`, `daily_status`, `routine_step_logs`, `routine_steps`, `daily_plans`, `daily_plan_blocks`. Mirror the existing, working `areas`/`tasks` pattern (`auth.uid() = user_id`) for the 9 tables that have a direct `user_id` column. `profiles` uses `auth.uid() = id` instead (per DATABASE.md's own documented RLS requirement — this was already the intended design, just never applied). `routine_steps` has **no `user_id` column** and needs a subquery policy through its parent: `EXISTS (SELECT 1 FROM tasks WHERE tasks.id = routine_steps.task_id AND tasks.user_id = auth.uid())`.

**Why:** Verified live 2026-07-24 — these 11 tables have RLS enabled (an event trigger auto-enables it on every new table) but zero policies, which is Postgres default-deny. The app's real `anon`/`authenticated` client cannot read or write any of them today. This is not a data-leak risk; it is total lockout, and it currently blocks the in-flight Projects CRUD sprint outright.

**Risk:** High if done wrong (a mis-scoped policy could leak data across users), but the *change itself* is corrective, not destructive — it only grants access that's currently completely absent. The subquery-based `routine_steps` policy is the one non-mechanical piece and deserves its own review, not a copy-paste.

**Depends on:** nothing — this is the root of the dependency graph.

**Affected files:** a new Supabase migration (SQL), applied directly to the live project. No `lib/` changes required by this item alone.

**Approval:** 🔴 Required, blocking. This is exactly the kind of live, security-relevant database change CLAUDE.md's Database Rules and BUILD_RULES.md's Change Process require sign-off for, even though the direction (add missing policies) is uncontroversial. The Product Architect should confirm the policy shape per table before it's applied to production, particularly `routine_steps`' subquery pattern and whether `recurring_templates`/`profiles` should be scoped identically to the rest or need something more specific.

### 1.2 Add missing foreign keys

**What:** `daily_plans.user_id → auth.users.id`; `daily_plan_blocks.daily_plan_id → daily_plans.id`, `daily_plan_blocks.user_id → auth.users.id`, `daily_plan_blocks.area_id → areas.id`. Already flagged as gaps in DATABASE.md.

**Why:** Referential integrity gap on tables that are about to get RLS policies for the first time (1.1) — worth fixing in the same migration since both tables currently hold 0 rows, so there is zero data to reconcile.

**Risk:** Low — additive constraints on empty tables.

**Depends on:** bundle with 1.1 (same migration, same tables).

**Affected files:** same Supabase migration as 1.1.

**Approval:** 🟡 Required, lightweight — schema change, but zero data risk given empty tables.

### 1.3 Refresh `schema.sql`

**What:** Regenerate `schema.sql` from the live project (via Supabase CLI/`pg_dump`, not hand-edited) so it includes `tasks.priority_rank`, the `current_action_candidates` view, and every column DATABASE.md now documents as live but the dump is missing.

**Why:** Confirmed stale 2026-07-24 — direct query proved both exist live and neither appears in the file.

**Risk:** Low — documentation/reference artifact only, not a live schema change.

**Depends on:** run after 1.1/1.2 land, so the refreshed dump reflects the new policies/FKs too and doesn't need doing twice.

**Affected files:** `schema.sql` only.

**Approval:** 🟢 Not required — mechanical, no behavior change.

### 1.4 Security linter fixes

**What:** Add an explicit `SET search_path` to `handle_new_user()` (currently mutable — a hijacking risk for a `SECURITY DEFINER` function); enable Supabase Auth's leaked-password-protection setting (currently disabled).

**Why:** Both flagged by the Supabase security advisor, verified live 2026-07-24.

**Risk:** Low — the search_path fix doesn't change the function's behavior, just hardens it; the auth setting is a platform toggle.

**Depends on:** nothing, can run independently, bundled here for convenience since it was found in the same audit pass.

**Affected files:** same Supabase migration as 1.1 (function fix); Supabase Auth dashboard/config (password protection toggle).

**Approval:** 🟡 Required, lightweight — still a live-project change to shared infrastructure, but mechanical and uncontroversial.

---

## Phase 2 — Domain Data-Integrity Changes

**Updated 2026-07-25.** This phase now splits into 2A (four items Approved via `ARCHITECTURE_DECISIONS.md` — ready to implement, no further decision needed) and 2B (items still awaiting a Product Architect decision — do not implement). None of 2A has been implemented yet; "Approved" describes the decision, not the live schema, which is unchanged until each migration actually runs.

### Phase 2A — Approved, Ready to Implement

#### 2A.1 `tasks.completed` removal (ADR-004, Approved 2026-07-25)

**What:** Drop the `completed` column. `status = 'Completed'` becomes the sole source of truth.

**Why:** Verified live 2026-07-24 — 12 of 24 rows already disagreed (`completed = false` while `status = 'Completed'`). Confirmed via code search that `completed` is never read or written outside the generated Supabase accessor — dropping it carries zero application-code risk.

**Risk:** Medium — schema change (column drop, irreversible without backup), but zero verified code dependency and no information loss (`status` already captures completion correctly for all 24 live rows).

**Depends on:** nothing technically; should land before Phase 4 work touches task completion logic, to avoid building new code against a field about to disappear.

**Affected files:** Supabase migration (`ALTER TABLE tasks DROP COLUMN completed`), `schema.sql` refresh, `DATABASE.md`/`DOMAIN_MODEL.md` (already updated to "approved for removal," need a final "removed" pass once implemented).

**Approval:** 🟢 Decision already made (ADR-004) — implementation itself still needs a normal review/merge, not a fresh architecture sign-off.

#### 2A.2 Event removed from `task_type` (ADR-002, Approved 2026-07-25)

**What:** Drop `'Event'` from the `tasks.task_type` check constraint/enum. No merge target and no data reassignment — anything scheduled that isn't a genuine Appointment (another party/external obligation) is simply a `Task` (or another type) using the universal scheduling fields.

**Why:** Event had no unique lifecycle distinct from a plain scheduled Task; Appointment was kept because it does have one (external accountability). See ARCHITECTURE_DECISIONS.md ADR-002 for full reasoning.

**Risk:** Low — **zero live data** (0 of 24 tasks use `task_type = 'Event'`), so this is the lowest-risk item in the whole plan.

**Depends on:** nothing technically. Should land before/alongside Phase 4.1's type-selector work, so that work isn't built to include a branch that's about to be removed.

**Affected files:** Supabase migration (check constraint), `lib/` (remove the `Event` branch from the type selector and any per-type list filters — no distinct Event-only code path exists to rewire), `DATABASE.md`/`DOMAIN_MODEL.md`/`GLOSSARY.md`/`V1_PRODUCT.md`/`ROADMAP.md` (already updated to reflect target architecture; need a final pass removing the "live/unmigrated" caveats once implemented).

**Approval:** 🟢 Decision already made (ADR-002).

#### 2A.3 `tasks.lifecycle_state` supersedes `tasks.is_active` (ADR-003, Approved 2026-07-25, with modification)

**What:** Add `tasks.lifecycle_state` (`Active` / `Paused` / `Archived`), backfill all existing rows (`is_active = true` → `lifecycle_state = 'Active'`), then supersede `is_active` on `tasks` through this migration. **Phase 1 of Lifecycle adoption is scoped to `tasks` only** — `projects.is_active`/`day_blocks.is_active` are unaffected and stay boolean; other entities may adopt Lifecycle in a later phase if a real need is demonstrated, per the ADR's approved modification.

**Why:** A boolean can't distinguish "temporarily paused" from "permanently archived" for Habit/Routine definitions. See ARCHITECTURE_DECISIONS.md ADR-003.

**Risk:** Low-Medium — schema change plus a full inventory of `lib/` call sites reading/writing `tasks.is_active` (not yet enumerated; first implementation step). Zero live rows are currently `is_active = false`, so there's no "off" data to reconcile, but all 24 `true` rows need an unambiguous backfill.

**Depends on:** nothing technically; independent of the other 2A items, though bundling into the same migration pass as 2A.1/2A.2 is reasonable since all three touch `tasks`.

**Affected files:** Supabase migration (new column + backfill), `lib/` (inventory + update every `tasks.is_active` call site), `DATABASE.md`/`DOMAIN_MODEL.md` (already updated to "approved for supersession," need a final pass once implemented).

**Approval:** 🟢 Decision already made (ADR-003) — note the approved modification (Phase 1 = `tasks` only; "supersedes through migration," not an instant swap) if implementation ever drifts toward a broader or instantaneous version.

#### 2A.4 Reminder as a capability (ADR-001, Approved 2026-07-25)

**What:** Remove `Reminder` from `task_type`. Add `tasks.reminder_enabled` (boolean, default `false`) as a universal capability usable on any `task_type`. Drop `reminder_level` and `acknowledged_at` entirely — both are superseded, not renamed or repurposed. Migrate the 4 live `task_type = 'Reminder'` rows to `task_type = 'Task'`, `reminder_enabled = true` (their `due_at`/`status`/`priority` carry over unchanged; `reminder_level`/`acknowledged_at` are already `NULL` on all 4, so nothing is lost). See ARCHITECTURE_DECISIONS.md ADR-001 for the full approved design, including its final revisions: Reminder anchors to the commitment's *primary scheduling field* (`due_at` today; extends to `start_at` automatically once Start/End scheduling is restored, no further domain-model change needed), and `acknowledged_at` is removed outright rather than folded into `status` (progress and acknowledgment are kept as separate concepts).

**Why:** Reminder was defined by *when it surfaces*, not *what kind of thing it is* — a cross-cutting timing concern, not a distinct kind of work. Modeling it as a 7th mutually-exclusive `task_type` blocked any other type (e.g. a Bill) from also being remindable, conflicting with SYSTEM_PRINCIPLES.md P022. `reminder_level` and `acknowledged_at` were both confirmed unused by application code, and the one real usage of the feature (4 live rows, all one recurring real-world commitment) never populated either field.

**Risk:** Medium — 4 live rows (`task_type = 'Reminder'`) need migrating, unlike Event's zero-row case, but the migration itself is unambiguous (single UPDATE, no data loss, confirmed by live-data audit).

**Depends on:** nothing technically; can be sequenced together with 2A.2's `task_type` migration since both touch the same check constraint. Blocks Phase 4.4's Reminder-specific UI work (the "Remind me" toggle, Current Action bell badge, Systems Control Panel filter) until it lands.

**Affected files:** Supabase migration (add `reminder_enabled`; 4-row `UPDATE`; drop `'Reminder'` from the `task_type` check constraint; drop `reminder_level`/`acknowledged_at` columns), `schema.sql` refresh, `lib/` (TaskForm type selector — remove `Reminder`, add a "Remind me" toggle near the Deadline field; Systems Control Panel's "Reminders" list filter — `task_type = 'Reminder'` → `reminder_enabled = true`; Current Action's icon condition — `task_type == 'Reminder'` → a secondary bell badge shown alongside the type icon when `reminder_enabled == true`, never replacing it), `DATABASE.md`/`DOMAIN_MODEL.md`/`GLOSSARY.md`/`V1_PRODUCT.md` (already updated to reflect target architecture; need a final pass removing the "live/unmigrated" caveats once implemented).

**Approval:** 🟢 Decision already made (ADR-001) — final design terms: field name `reminder_enabled` (not `is_remindable`); Current Action keeps the commitment-type icon as primary, with the bell as a secondary badge only; no ordering boost for `reminder_enabled = true` (Current Action ordering is unchanged by this ADR); `reminder_level`/`acknowledged_at` both removed via migration, not deprecated in place.

### Phase 2B — Still Open, Decision Required

**Nothing in this section should be implemented until the Product Architect decides.** Implementing ahead of a decision here is exactly the "guess instead of ask" failure mode SYSTEM_PRINCIPLES.md P021 exists to prevent.

#### 2B.1 Vestigial verification/calendar-sync column set

**What:** Decide the fate of `calendar_sync`, `calendar_event_id`, `calendar_synced_at`, `completion_synced` (out-of-scope, undecided) and `requires_verification`, `verification_status` (open questions per V1_PRODUCT.md) — remove, or define real V1 behavior and build against them. **No longer overlaps with Reminder** — `reminder_level`/`acknowledged_at` were resolved by ADR-001 and moved to Phase 2A.4; this bucket now covers only the calendar-sync/verification columns listed here.

**Why:** Confirmed 100% unused in application code.

**Risk:** High if columns are dropped and any of them turn out to matter for a decision not yet made. Low if the decision is "keep the columns, don't build on them yet."

**Depends on:** nothing technically.

**Affected files:** none until decided; then a Supabase migration and `tasks.dart`/related Dart if columns are wired or removed.

**Approval:** 🔴 Required, blocking — explicitly named in V1_PRODUCT.md as a Product Architect decision, not an implementation one.

#### 2B.2 Recurring Templates scope

**What:** Decide whether V1 needs the full Recurring Templates engine (the `recurring_templates` table as currently designed — schedule types, week patterns, day-of-month rules) or a simpler frequency-based repeat on Habit/Routine/Bill, and whether a minimal recurring-instance-generation mechanism is required V1 infrastructure either way.

**Why:** V1_PRODUCT.md's own open question — and, as of the Product Architect's own note, **the only remaining product decision considered legitimately open** at the same review that approved ADR-002/003/004. Verified live 2026-07-24 that the table is not dead data — 46 real rows exist, and 10 live tasks reference one — but none of it is reachable by the app regardless of this decision, since it's also one of the 11 tables blocked in Phase 1.

**Risk:** Medium — the table already has real data; a decision to simplify or repurpose it needs a data-migration sub-plan of its own once made, not just a schema change.

**Depends on:** Phase 1.1 (RLS) should land first regardless of which way this is decided, since the table needs to be reachable either way.

**Affected files:** TBD based on decision; blocks part of Phase 6 (any Daily Plan generation logic that would read from Recurring Templates).

**Approval:** 🔴 Required, blocking.

---

## Phase 3 — Schema Hygiene

### 3.1 Scope global `UNIQUE` constraints per user/parent

**What:** `projects.name`, `recurring_templates.name`, `day_blocks.name`, `day_blocks.sort_order`, `block_items.title`, `block_items.sort_order`, `routine_steps.name` are all currently globally unique. Rescope to `UNIQUE (user_id, lower(name))` (or the appropriate parent scope) per DATABASE.md's own recommendations.

**Why:** Already documented as a real multi-user conflict risk in DATABASE.md's "Current Schema Risks To Audit Before V1" — two different users cannot currently use the same project/template/block name, which will surface as a confusing error the first time it happens in practice.

**Risk:** Low-Medium — loosening a constraint from global to scoped cannot break any row that currently satisfies the stricter version, so no existing data is at risk. Still a live schema change.

**Depends on:** nothing; can run any time after Phase 1's migration exists (bundling into the same migration file is reasonable but not required).

**Affected files:** Supabase migration.

**Approval:** 🟡 Required, lightweight — corrective, low ambiguity, but still a schema change to production.

---

## Phase 4 — Universal Task Model Completion

**This is already-confirmed architecture (ARCHITECTURE.md, 2026-07-22) being implemented, not a new decision.** No new approval is required for the *direction*; each item is still gated on Phase 1 landing for the specific tables it touches.

### 4.1 Restore Start/End Date & Time wiring, then generalize to all task types; demote `due_at` to Deadline; update `current_action_candidates`

**What:** **Corrected 2026-07-25 — this is now a two-part item, not a one-part extension.** Part A: restore the `start_at`/`end_at` wiring (form → EditorHost → Supabase → Systems Control Panel) that previously existed for Appointment/Event as of commit `1c08b68`, but was subsequently removed during unrelated EditorHost debugging — only the Due Date implementation was restored afterward. Part B: once restored and verified, generalize that wiring to every `task_type`, relabel `due_at` as an optional Deadline field, and update the `current_action_candidates` view's filter (currently `WHERE due_at IS NULL OR due_at < CURRENT_DATE + 1 day`) and the Dart-side ordering (`execution_page_widget.dart:198`) to use `start_at` instead of `due_at` — together, not one without the other, or the two will disagree about which tasks are eligible. **`due_at` remains the current production scheduling field, for every task type, until Part A and B are both done and verified — do not build or assume any dependency on `start_at` before then.**

**Why:** Confirmed architecture decision (unchanged); confirmed live 2026-07-24 that the view was never updated and zero live tasks have `start_at` populated. **Additionally confirmed by the Product Architect 2026-07-25: there is currently zero Start/End wiring in the app at all, for any type — not merely "ungeneralized."** The regression happened after the 2026-07-24 audit and after `MIGRATION_PLAN.md`'s original draft, so the original wording ("extend the already-proven pattern") described a baseline that no longer exists.

**Risk:** Low-Medium, **revised from the original estimate** — this now includes a full restoration of previously-working functionality before any generalization work starts, not just a view/ordering change on top of existing wiring. The view change itself still alters what surfaces as the Current Action, a real behavior change for the end user.

**Depends on:** Phase 1 (this only touches `tasks`, which already has working RLS — no hard dependency, but sequenced after Phase 1 as a matter of course).

**Affected files:** `lib/` (TaskForm, EditorHost, per-type sections — restoration first, then generalization), Supabase migration (view definition), `execution_page_widget.dart`.

**Approval:** 🟢 Not required for direction (target architecture already confirmed and unaffected by this correction); 🟡 the `current_action_candidates` view edit specifically is worth a heads-up since it changes live user-facing behavior, not a full re-approval. **Verification requirement added 2026-07-25: restoration (Part A) must be independently verified against the live app — not just re-reading a diff — before Part B (generalization) begins, given the previous wiring was verified once already and regressed without anyone intending it to.**

### 4.2 Habit fields + `habit_logs` write path

**What:** Wire `target_value`/`unit`/`frequency`/`tracking_type` into TaskForm for `task_type = 'Habit'`; implement the check-in write path against `habit_logs`.

**Depends on:** Phase 1.1 (`habit_logs` has zero RLS policies today — this cannot function end-to-end until that lands, a dependency the previous audit couldn't see before RLS was verified).

**Risk:** Low. **Approval:** 🟢 Not required — already-confirmed architecture, named explicitly in ROADMAP.md's V1 Definition of Done.

### 4.3 Routine steps sub-flow

**What:** Build the `routine_steps` CRUD + `routine_step_logs` completion flow, replacing the "Routine steps go here" placeholder.

**Depends on:** Phase 1.1 (`routine_steps`/`routine_step_logs` RLS — note `routine_steps`' non-standard subquery policy from 1.1 specifically).

**Risk:** Low-Medium (largest remaining chunk of Phase 4, per PROJECT_STATUS.md). **Approval:** 🟢 Not required.

### 4.4 Bill fields / Reminder capability

**What:** Type-specific fields and flow for Bill (`amount`/`payee`/`login_url`), plus the universal Reminder capability UI: a "Remind me" toggle in TaskForm (near the Deadline field, available on every `task_type`), the Systems Control Panel "Reminders" list filtered on `reminder_enabled = true`, and Current Action's secondary bell badge shown alongside the type icon when `reminder_enabled = true`.

**Depends on:** Phase 2A.4 (ADR-001, Approved) must land first — `reminder_enabled` needs to exist and the 4 live `Reminder` rows need to be migrated before this UI work is wired against it. Bill has no such blocker.

**Risk:** Low. **Approval:** 🟢 Not required for Bill or Reminder — both now have an approved design (ADR-001 for Reminder); this is implementation work, not a fresh decision.

---

## Phase 5 — Projects CRUD

**What:** Complete the in-flight sprint (`ProjectFormModel`/`Widget`, EditorHost `'project'` branch, delete dialog branch, list content, "+" wiring) per PROJECT_STATUS.md's Current Sprint.

**Depends on:** Phase 1.1's `projects` policy specifically — not the rest of Phase 1. The Dart-side work can be written in parallel with Phase 1, but the sprint's own acceptance criteria ("confirm a second user cannot see the first user's projects") cannot be verified against the live project until that policy exists.

**Risk:** Low. **Approval:** 🟢 Not required — already-approved, already in flight.

---

## Phase 6 — Schedules (Day Blocks / Daily Plans / Block Items)

**What:** Full UI for the block-first internal / calendar-first user-facing scheduling system.

**Depends on:** Phase 1 (all four schedule tables need RLS/FKs) and Phase 4 (per ARCHITECTURE.md/ROADMAP.md's explicit sequencing — this starts only after the Universal Task Model is functionally complete). Daily Plan generation logic additionally depends on Phase 2B.2's Recurring Templates decision if generation is meant to read from templates.

**Risk:** Medium — the largest remaining greenfield UI surface. **Approval:** 🟢 Not required for direction (already-confirmed architecture); the implementation plan itself should get a lightweight review when it's actually scoped, same as any other sprint kickoff.

---

## Approval Summary

| Phase | Item | Approval | Blocking? |
|---|---|---|---|
| 1.1 | RLS policies, 11 tables | 🔴 Required | Yes — blocks Phase 4, 5, 6 |
| 1.2 | Missing FKs | 🟡 Required | Bundled with 1.1 |
| 1.3 | `schema.sql` refresh | 🟢 None | No |
| 1.4 | Linter/auth security fixes | 🟡 Required | No |
| 2A.1 | `completed`/`status` consolidation (ADR-004) | 🟢 Decision made — ready to implement | No |
| 2A.2 | Event removed from `task_type` (ADR-002) | 🟢 Decision made — ready to implement | No — sequence before/alongside Phase 4.1's type selector work |
| 2A.3 | `lifecycle_state` supersedes `is_active` on `tasks` (ADR-003) | 🟢 Decision made — ready to implement | No |
| 2A.4 | Reminder as a capability (ADR-001) | 🟢 Decision made — ready to implement | No — sequence before/alongside Phase 4.4's Reminder UI work |
| 2B.1 | Vestigial calendar-sync/verification column set | 🔴 Required | No longer blocks Reminder (resolved by ADR-001/2A.4) |
| 2B.2 | Recurring Templates scope | 🔴 Required | Blocks part of Phase 6 |
| 3.1 | Scoped UNIQUE constraints | 🟡 Required | No |
| 4.1–4.3 | Start/End (restore + generalize, see 2026-07-25 correction), Habit, Routine | 🟢 None (direction already approved) | Each gated on Phase 1 landing |
| 4.4 | Bill fields / Reminder capability UI | 🟢 None (both approved) | Reminder gated on 2A.4 landing, Bill not |
| 5 | Projects CRUD | 🟢 None | Gated on 1.1's `projects` policy only |
| 6 | Schedules | 🟢 None (direction already approved) | Gated on Phase 1 + Phase 4 |

---

## Explicitly out of scope for this plan

Per direct instruction: no further expansion of `PROJECT_STATUS.md` and no additional live-database audits beyond what's already verified, unless a blocking contradiction surfaces during implementation of one of the phases above. This plan is built entirely from the 2026-07-24 audit findings already on record; it does not open any new investigation.
