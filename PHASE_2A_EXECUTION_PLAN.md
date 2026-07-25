# PHASE_2A_EXECUTION_PLAN.md

## Purpose

This is the detailed execution plan for implementing `MIGRATION_PLAN.md` Phase 2A — the four Approved ADRs (ADR-001 through ADR-004) from `ARCHITECTURE_DECISIONS.md`. It exists to be reviewed and approved by the Product Architect **before any schema or application code changes begin.**

**Status: Planning only. Nothing in this document has been executed.** No migration has run, no `lib/` file has been edited, no FlutterFlow export has been requested. This document itself makes no architecture decisions — all four ADRs are already Approved and frozen; this is execution sequencing only, per the instruction to stop designing/expanding architecture and shift to implementation.

**Scope:** Phase 2A only (`tasks.completed` removal, `Event` removal, `lifecycle_state`, Reminder capability). Phase 2B (vestigial calendar-sync/verification columns, Recurring Templates scope) is explicitly deferred and not addressed here, per instruction — it re-enters scope only if it becomes an implementation blocker.

---

## Grounding: Verified Live 2026-07-25, During This Planning Pass

Before writing this plan, the live Supabase project (`cdhijuhtrvtnjlxyucvk`) and the actual `lib/` source were re-checked directly, rather than trusting `MIGRATION_PLAN.md`/`ARCHITECTURE_DECISIONS.md` prose alone. Two things came out different from what those documents assumed — both are corrected here, and both make the plan **simpler and lower-risk**, not harder:

### Correction 1 — `tasks.task_type` has no CHECK constraint, live or otherwise

`ARCHITECTURE_DECISIONS.md` (ADR-001, ADR-002) and `MIGRATION_PLAN.md` repeatedly describe "dropping `'Event'`/`'Reminder'` from the `task_type` check constraint." **No such constraint exists.** Queried directly against `pg_constraint` for `public.tasks`: the only constraints are the primary key, four foreign keys (`area_id`, `project_id`, `template_id`, `user_id`), and a `UNIQUE (template_id, due_at)` constraint. `task_type` is a plain `text` column with no CHECK, no enum type, no constraint of any kind. `schema.sql` doesn't show one either — this was a documentation assumption, not a verified fact, and it should have been marked as such.

**Practical effect:** removing `Event` and `Reminder` as valid `task_type` values is **purely an application-layer/FlutterFlow change** (the dropdown no longer offers them), not a schema change. There is no `ALTER TABLE ... DROP CONSTRAINT` / `ADD CONSTRAINT` step for either item. This removes a whole migration step from 2A.2 and simplifies 2A.4's schema work to just the `reminder_enabled` column plus the `reminder_level`/`acknowledged_at` drops.

*(A follow-up doc correction to `ARCHITECTURE_DECISIONS.md`/`MIGRATION_PLAN.md`/`DATABASE.md` removing the "check constraint" language is worth doing at some point, since it's now a known inaccuracy — flagged here rather than fixed unilaterally, since you asked to hold non-blocking doc work. Happy to fold it into this same execution pass if you'd like, since it's a one-line factual correction, not a design change.)*

### Correction 2 — All prior audit numbers reconfirmed unchanged

Live-queried fresh, not assumed from the 2026-07-24 audit:

| Check | Result | Matches prior docs? |
|---|---|---|
| Total `tasks` rows | 24 | Yes |
| `task_type = 'Reminder'` rows, all fields | 4 rows, all `status='Completed'`, `due_at` set, `reminder_level`/`acknowledged_at` both NULL on all 4 | Yes |
| `completed = false` while `status = 'Completed'` | 12 of 24 | Yes |
| `reminder_level IS NOT NULL` | 10 of 24 (none of which are the 4 Reminder rows — confirms the seed-data theory) | Yes |
| `is_active = false` | 0 of 24 | Yes |
| `task_type = 'Bill'` / `'Appointment'` / `'Event'` | 0 rows each | Yes |
| RLS on `tasks` | Enabled, with full SELECT/INSERT/UPDATE/DELETE policies scoped to `auth.uid() = user_id` | New confirmation — `tasks` is **not** one of the RLS-gapped tables from Phase 1, so Phase 2A has no dependency on Phase 1 landing first |

Nothing here changes any ADR's decision. It confirms the migration is exactly as low-risk as documented, and removes one open unknown (RLS readiness on `tasks`).

### Correction 3 — FlutterFlow ownership of the affected UI files

Per `CLAUDE.md`'s FlutterFlow Rules ("FlutterFlow is the source of truth... avoid modifying generated Flutter code... only recommend Custom Code when FlutterFlow cannot accomplish the requirement") and this project's own Git Workflow (FlutterFlow → `flutterflow` branch → merge into `develop` → Claude Code development), every `lib/` file this plan touches is FlutterFlow-generated or FlutterFlow-synced:

- `lib/components/task_form/task_form_widget.dart` — the `task_type` dropdown (confirmed at line 216-229: a `FlutterFlowDropDown<String>` with a literal `options: ['Task', 'Habit', 'Routine', 'Appointment', 'Bill', 'Reminder', 'Event']` list).
- `lib/components/current_action/current_action_widget.dart` — the per-type icon `if/else if` chain (confirmed at line 96-144, branching on a `widget!.actionType` string parameter).
- `lib/components/systems_control_panel/systems_control_panel_widget.dart` — the "Reminders" list section, filtered on `task_type = 'Reminder'` (confirmed at line 2316-2482).
- `lib/components/editor_host/editor_host_widget.dart` — the save flow, both `TasksTable().insert({...})` (create) and `TasksTable().update(data: {...})` (edit) paths, which write plain field maps including `'is_active': _model.taskFormModel.switchValue` (confirmed at line 275, 338) — this is the exact pattern any new `reminder_enabled`/`lifecycle_state` field would need to follow.
- `lib/backend/supabase/database/tables/tasks.dart` — a generated 1:1 column accessor file (confirmed: every getter/setter maps directly to a live column name) that regenerates from FlutterFlow's Supabase schema sync — not hand-edited.

**This reshapes the plan structurally.** Supabase schema changes can be executed directly (I can run them via the Supabase MCP tools once approved). But the UI and save-flow changes in the four `lib/` files above should be made **in the FlutterFlow editor** by the Product Architect and exported through the normal `flutterflow` → `develop` pipeline — not hand-patched here. Each per-ADR section below separates "Supabase changes" (I execute) from "FlutterFlow changes" (a work order for you to perform in FlutterFlow), with a "Post-export verification" step for what I check once the export lands.

### Correction 4 — No automated test coverage exists

`test/widget_test.dart` contains only the default Flutter counter-app smoke test — it doesn't exercise `MyApp`'s real routes or any task/reminder/lifecycle behavior. There is no regression suite to run. "Verification/testing steps" below are therefore **manual**: SQL diffing before/after each migration step, and a manual app walkthrough of the affected flows (create/edit a Task, check Current Action, check Systems Control Panel) once each FlutterFlow export lands. This isn't a gap introduced by this plan — it's the actual state of the project, named so expectations are accurate.

---

## Global Execution Strategy

**One combined Supabase migration, not four separate ones.** All four items touch the same table (`tasks`), all are low-risk (verified above), and `MIGRATION_PLAN.md` already recommended sequencing 2A.1/2A.2 together and 2A.4 alongside 2A.2. Running them as a single transaction means one maintenance window, one rollback point, and one verification pass instead of four.

**Order within that migration matters** — additions and backfills must happen before removals, so nothing reads a column that's already gone mid-migration:

1. **Add** new columns (`reminder_enabled`, `lifecycle_state`) — additive, zero risk, nothing depends on them yet.
2. **Backfill/migrate data** — the 4 `Reminder` rows, the `lifecycle_state` backfill from `is_active`. Still fully reversible; old columns (`task_type='Reminder'`, `completed`, `is_active`, `reminder_level`, `acknowledged_at`) are all still present and correct at this point.
3. **Remove** columns (`completed`, `reminder_level`, `acknowledged_at`) — irreversible without a backup. Done last, and only after the FlutterFlow export removing all `lib/` reads of these columns has landed and been verified (see each item's Dependencies).

`is_active` is a partial exception — see 2A.3 below for why it's *not* dropped in this same pass.

**Two-phase rollout, not one big-bang:** Supabase schema additions (step 1-2 above) can land immediately once approved — they're purely additive and don't require any FlutterFlow/`lib/` change first. The FlutterFlow work (new toggle, dropdown edit, icon logic, save-flow field additions) happens next, exported and merged to `develop`. Only after that export is verified working does the destructive step 3 (column drops) execute. This means the plan has a **natural pause point** for FlutterFlow work between the additive and destructive halves of the same logical migration — not four separate migrations, but two clearly separated execution sessions.

---

## 2A.1 — `tasks.completed` Removal (ADR-004)

**What:** Drop the `completed` column. `status = 'Completed'` becomes the sole source of truth for completion.

### Files to modify
- None in `lib/`. Confirmed (repeated from the original audit, not re-verified line-by-line here since it was already grep-confirmed with zero hits beyond the generated accessor): `completed` is referenced only by `lib/backend/supabase/database/tables/tasks.dart`'s generated getter/setter, which will simply stop compiling that accessor once the column is gone and FlutterFlow re-syncs its schema.
- `schema.sql` — regenerated, not hand-edited (see Supabase changes below).

### Database changes
```sql
-- Step 3 (destructive, last): 
ALTER TABLE public.tasks DROP COLUMN completed;
```
No backfill needed — `status` already independently carries the correct value for all 24 live rows (confirmed: even the 12 drifted rows have `status = 'Completed'` correctly set; `completed` was simply never kept in sync).

### Migration order
Destructive step (group 3) in the combined migration — no ordering dependency relative to 2A.2/2A.3/2A.4's own steps, but must run after its own pre-migration backup (see Rollback).

### FlutterFlow changes
None required. `completed` was never bound to any widget, switch, or action step — confirmed zero non-generated references. FlutterFlow's schema sync will drop the corresponding field from its Data Source automatically once the column no longer exists.

### Supabase changes
- The `ALTER TABLE ... DROP COLUMN` itself (via `apply_migration`, not raw `execute_sql`, so it's tracked as a proper migration).
- `schema.sql` refresh afterward (regenerate from live schema, replacing the file — not a hand-edit).
- No RLS policy changes — none of the four `tasks` policies reference `completed`.

### Rollback considerations
- **Before dropping:** snapshot `SELECT id, completed FROM public.tasks;` (24 rows) so exact prior values could be restored if needed, even though `status` already makes this data redundant.
- **To roll back:** `ALTER TABLE public.tasks ADD COLUMN completed boolean DEFAULT false;` restores the column shape but not the data unless the snapshot above is replayed via `UPDATE`. Given `completed` is provably redundant with `status` for every live row, a rollback would realistically just re-derive it (`completed = (status = 'Completed')`) rather than replay the snapshot — noted so it's a deliberate choice, not an oversight, if rollback is ever needed.
- Low blast radius: confirmed zero `lib/` reads, so a rollback (if ever needed) has no application-code side to also revert.

### Verification/testing steps
1. Pre-migration: run the snapshot query above; confirm row count (24) and drift count (12) match this document's Grounding section.
2. Post-migration: `SELECT column_name FROM information_schema.columns WHERE table_name='tasks' AND column_name='completed';` returns zero rows.
3. Manual app check: open Systems Control Panel and Current Action, confirm task completion status still displays correctly (driven by `status`, unaffected by this change) — this is a smoke check, not expected to surface anything, since `completed` was never read.

### Dependencies
None — independent of the other three items. Can execute standalone if you want to land it before the others.

---

## 2A.2 — `Event` Removed from `task_type` (ADR-002)

**What:** `Event` stops being an offered `task_type` value. Per Correction 1 above, there is **no schema-level enum/constraint to change** — this is entirely a FlutterFlow dropdown edit plus an icon-logic cleanup.

### Files to modify
- `lib/components/task_form/task_form_widget.dart` (line 221-229: dropdown `options` list) — FlutterFlow-generated, edited via FlutterFlow.
- `lib/components/current_action/current_action_widget.dart` (line 132-137: the `'Event'` icon branch) — FlutterFlow-generated, edited via FlutterFlow. Safe to remove since 0 live rows use `Event` and the dropdown will no longer produce new ones.

### Database changes
**None.** No CHECK constraint exists to drop (Correction 1). No data migration needed — 0 live rows use `task_type = 'Event'`.

### Migration order
No Supabase step exists for this item. Purely sequenced against the FlutterFlow work order (see below) — no ordering relative to 2A.1/2A.3/2A.4's *database* steps, since there are none here.

### FlutterFlow changes (work order)
1. In TaskForm's `task_type` dropdown widget: remove `'Event'` from the options list (leaves `Task`, `Habit`, `Routine`, `Appointment`, `Bill`, plus whatever ADR-001's work does to `Reminder` — see 2A.4, likely landing in the same FlutterFlow session since both touch this same dropdown).
2. In the Current Action component: remove the `Event` branch from the per-type icon logic (the `Icons.celebration_outlined` case). No replacement needed — nothing will ever match it again once step 1 lands, since it's dropdown-driven.

### Supabase changes
None.

### Rollback considerations
Trivial — this is a UI-only change with no data or schema impact. Rolling back means re-adding `'Event'` to the FlutterFlow dropdown and re-exporting; no database state to restore, since nothing was ever migrated or dropped.

### Verification/testing steps
1. Post-export: confirm the TaskForm dropdown no longer offers "Event" as an option.
2. Confirm Current Action still renders correctly for all remaining types (Task/Habit/Routine/Bill/Appointment) — the removed branch's `else` fallback (`Icons.category_outlined`) was never reachable for real data anyway (0 Event rows), so this is a smoke check.
3. Confirm no existing row anywhere has `task_type = 'Event'` post-export (`SELECT count(*) FROM tasks WHERE task_type = 'Event';` → 0) — expected to already be true and to stay true.

### Dependencies
None technically. Practically sequenced together with 2A.4 since both edit the same TaskForm dropdown and Current Action icon logic — doing them in the same FlutterFlow session avoids two separate export/merge cycles for the same two files.

---

## 2A.3 — `lifecycle_state` Supersedes `is_active` on `tasks` (ADR-003)

**What:** Add `tasks.lifecycle_state` (`Active`/`Paused`/`Archived`), backfill from `is_active`, migrate every `lib/` call site to read/write `lifecycle_state` instead. **Phase 1 scope: `tasks` only** — `projects.is_active`/`day_blocks.is_active` are untouched.

### Files to modify
- `lib/components/task_form/task_form_widget.dart` — wherever the `is_active` boolean is currently exposed as a form control (a `Switch`, per `_model.taskFormModel.switchValue`'s naming) needs to become a `lifecycle_state` selector. **Needs a UI-shape decision** (see Open Implementation Question below) before the FlutterFlow work order can be fully specified.
- `lib/components/editor_host/editor_host_widget.dart` — both the `TasksTable().insert({...})` and `TasksTable().update(data: {...})` blocks currently write `'is_active': _model.taskFormModel.switchValue` (confirmed at lines 275 and 338); both need a `'lifecycle_state': ...` entry instead once the new field/control exists in the form model.
- Any other `lib/` call site reading `tasks.is_active` for display/filtering — **not yet fully enumerated**, per ADR-003's own Migration Impact note that this inventory is first implementation work, not something the ADR itself completed. A `grep -rn "is_active" lib/` pass restricted to task-related widgets should be the first concrete step when this item starts, before touching FlutterFlow.
- `lib/backend/supabase/database/tables/tasks.dart` — regenerates automatically once the column exists and FlutterFlow re-syncs; not hand-edited.

### Database changes
```sql
-- Step 1 (additive, first):
ALTER TABLE public.tasks ADD COLUMN lifecycle_state text DEFAULT 'Active';
-- Nullable with a default, matching this table's existing style for status/priority/task_type/frequency/tracking_type/verification_status (all nullable text, several with defaults) rather than introducing a NOT NULL constraint pattern not used elsewhere in this table.

-- Step 2 (backfill, second):
UPDATE public.tasks SET lifecycle_state = CASE WHEN is_active THEN 'Active' ELSE 'Paused' END;
```

**Open implementation question, not a new architecture decision:** ADR-003 only specifies the backfill rule for `is_active = true` → `'Active'` (all 24 live rows). It doesn't specify what `is_active = false` should map to, because zero live rows currently need that branch. The `CASE` statement above still needs *some* rule to be well-defined and safe against any row that becomes `is_active = false` between now and migration time. I've defaulted to `'Paused'` (the more reversible/temporary reading) rather than `'Archived'` (more final) as the safer default — flagging this as a one-line implementation choice worth a quick confirm, not something requiring a fresh ADR, since it affects zero current rows either way.

**`is_active` itself is *not* dropped in this migration.** ADR-003's approved language is "supersedes `is_active` through migration," explicitly corrected away from "an instantaneous swap" — and the column-drop pattern used for `completed`/`reminder_level`/`acknowledged_at` isn't mirrored in ADR-003's Migration Impact section the way it explicitly is for those three fields. Recommendation: keep `tasks.is_active` in place (unused going forward, but present) after this migration, and drop it only in a fast-follow migration once the full `lib/` call-site inventory is confirmed empty of references. This is the safer reading of "not an instant swap" and avoids a second irreversible action bundled into an already-multi-part migration.

### Migration order
Additive step (group 1) and backfill step (group 2) in the combined migration. No destructive step for this item in this pass (see above) — `is_active` removal is explicitly deferred to a later, separate fast-follow migration, gated on the `lib/` inventory being complete and verified.

### FlutterFlow changes (work order)
1. Inventory every `lib/` widget currently reading or writing `tasks.is_active` (starting point: the `Switch` bound to `_model.taskFormModel.switchValue` in TaskForm, and the two `EditorHost` save-flow maps) — first step, before any FlutterFlow editing begins.
2. Replace the TaskForm `is_active` Switch with a `lifecycle_state` control. **Needs your input on shape**: a 3-option dropdown/segmented control (`Active`/`Paused`/`Archived`) is the direct mapping, but given `is_active` today is described as "mainly meaningful for Habit/Routine" and defaults `true`/no-defined-meaning for other types, you may want this control shown conditionally (only for Habit/Routine) rather than universally — that's a product call, not something I should assume in this execution plan.
3. Update both `EditorHost` save-flow action blocks (`insert` and `update`) to write `'lifecycle_state'` instead of `'is_active'`.
4. Update any list/filter view that currently branches on `is_active` (not yet enumerated — see Files to modify) to branch on `lifecycle_state` instead.

### Supabase changes
- The `ALTER TABLE ... ADD COLUMN` and backfill `UPDATE`, via `apply_migration`.
- `schema.sql` refresh.
- No RLS changes — none of the four `tasks` policies reference `is_active` or would need to reference `lifecycle_state`.

### Rollback considerations
- Additive + backfill steps are fully reversible on their own: `ALTER TABLE public.tasks DROP COLUMN lifecycle_state;` cleanly undoes both, since `is_active` is untouched throughout this pass.
- Because `is_active` is deliberately *not* dropped in this migration, rollback has no data-loss exposure at all for this item — the old boolean stays live and correct the entire time, which is the main reason this plan recommends *not* bundling the `is_active` drop into the same pass as the other three columns' removals.
- The eventual fast-follow `is_active` drop (once scheduled) should follow the same snapshot discipline as 2A.1 (`SELECT id, is_active FROM tasks` before dropping).

### Verification/testing steps
1. Pre-migration: confirm 0 rows have `is_active = false` (already reconfirmed in Grounding — expected unchanged).
2. Post-backfill: `SELECT lifecycle_state, count(*) FROM tasks GROUP BY lifecycle_state;` → expect all 24 rows as `Active`.
3. Post-FlutterFlow-export: manually create a new Task, Habit, and Routine through the app; confirm `lifecycle_state` is written correctly on insert and update via `EditorHost`, and that the old `is_active` field is no longer being written to (query the row directly and confirm `is_active` stayed at its pre-migration value, unchanged by new saves).
4. Confirm whatever list/filter previously used `is_active` still filters correctly using `lifecycle_state`.

### Dependencies
Independent of 2A.1/2A.2/2A.4's database steps. The `lib/` call-site inventory (step 1 of the FlutterFlow work order) should happen before any FlutterFlow editing starts, and is this item's longest-lead-time piece — start it early even if the schema step lands last among the four.

---

## 2A.4 — Reminder as a Capability (ADR-001)

**What:** Remove `Reminder` from `task_type` (application-layer only, per Correction 1). Add `tasks.reminder_enabled` (boolean, default `false`), usable on any `task_type`. Drop `reminder_level`/`acknowledged_at`. Migrate the 4 live `Reminder` rows.

### Files to modify
- `lib/components/task_form/task_form_widget.dart` — remove `'Reminder'` from the `task_type` dropdown (same edit location as 2A.2's `Event` removal, line 221-229); add a new "Remind me" toggle control near the Deadline field, available regardless of selected type.
- `lib/components/editor_host/editor_host_widget.dart` — both `TasksTable().insert({...})` and `TasksTable().update(data: {...})` blocks need a new `'reminder_enabled': ...` entry, following the exact same pattern as the existing `'is_active': _model.taskFormModel.switchValue` line.
- `lib/components/systems_control_panel/systems_control_panel_widget.dart` — the "Reminders" list section's filter (currently `task_type = 'Reminder'`, confirmed at line 2371-2482) changes to `reminder_enabled = true`; ordering by `due_at` stays unchanged.
- `lib/components/current_action/current_action_widget.dart` — the icon logic (line 96-144) needs restructuring: remove the `'Reminder'` branch entirely (it replaced the whole icon), and instead wrap the existing per-type icon in a `Stack`/`Badge` that adds a small secondary bell indicator when a new `reminderEnabled` component parameter is `true`. This is a bigger structural change than 2A.2's icon edit — it needs a new component parameter threaded from wherever `CurrentActionWidget` is instantiated, not just an `if/else` edit.
- `lib/backend/supabase/database/tables/tasks.dart` — regenerates automatically; not hand-edited.

### Database changes
```sql
-- Step 1 (additive, first):
ALTER TABLE public.tasks ADD COLUMN reminder_enabled boolean DEFAULT false;
-- Matches this table's existing boolean convention (calendar_sync, completion_synced, requires_verification are all nullable boolean with a default) rather than introducing NOT NULL.

-- Step 2 (backfill/migrate, second):
UPDATE public.tasks
SET task_type = 'Task', reminder_enabled = true
WHERE task_type = 'Reminder';
-- due_at, status, priority, priority_rank all carry over untouched (not part of this UPDATE's SET clause).
-- reminder_level/acknowledged_at are already NULL on all 4 affected rows (reconfirmed in Grounding) — nothing to null out explicitly.

-- Step 3 (destructive, last):
ALTER TABLE public.tasks DROP COLUMN reminder_level;
ALTER TABLE public.tasks DROP COLUMN acknowledged_at;
```

### Migration order
Additive (group 1), backfill (group 2), and destructive (group 3) steps as shown — the backfill *must* run before the destructive drops, and both must run after the additive step. Relative to 2A.1's `completed` drop: order between the two destructive drops doesn't matter (independent columns), so they can be combined into a single `ALTER TABLE ... DROP COLUMN completed, DROP COLUMN reminder_level, DROP COLUMN acknowledged_at;` statement in the final destructive step of the combined migration.

### FlutterFlow changes (work order)
1. TaskForm: remove `'Reminder'` from the `task_type` dropdown options (same session as 2A.2). Add a new toggle/switch widget, "Remind me," positioned near the Deadline (`due_at`) field, bound to a new form-model field (e.g. `reminderToggleValue`, mirroring how `switchValue` backs `is_active` today). Available regardless of which `task_type` is selected.
2. EditorHost: add `'reminder_enabled': _model.taskFormModel.reminderToggleValue` to both the `insert` and `update` field maps.
3. Systems Control Panel: change the "Reminders" section's filter condition from `task_type = 'Reminder'` to `reminder_enabled = true`.
4. Current Action: add a `reminderEnabled` boolean parameter to the component; wrap the existing icon `Stack`-style with a small secondary bell badge shown when that parameter is `true`. Confirm with whoever wires `CurrentActionWidget`'s call sites that `reminder_enabled` is threaded through from the underlying task record into this new parameter.

### Supabase changes
- All three SQL steps above, via `apply_migration`.
- `schema.sql` refresh.
- No RLS changes — none of the four `tasks` policies reference any of these three columns.

### Rollback considerations
- Additive + backfill (steps 1-2) are cleanly reversible: `UPDATE tasks SET task_type = 'Reminder', reminder_enabled = false WHERE reminder_enabled = true AND task_type = 'Task';` restores the pre-migration `task_type`, followed by `ALTER TABLE tasks DROP COLUMN reminder_enabled;`. Safe as long as no *new* genuinely-a-Task-with-reminder-enabled row has been created in the meantime that would be wrongly reverted — low risk in the gap between this migration and the FlutterFlow export landing, since the UI to create such a row doesn't exist until that export ships.
- Destructive step (`reminder_level`/`acknowledged_at` drop) needs a pre-drop snapshot for the same reason as 2A.1: `SELECT id, reminder_level, acknowledged_at FROM tasks;` before dropping, even though all 4 affected (former-Reminder) rows are already confirmed NULL on both fields, and the 10 other rows with `reminder_level` set are believed to be seed data, not real usage — the snapshot exists so that belief is provably checkable after the fact, not just asserted.
- Icon/UI rollback (if the FlutterFlow export needs reverting) is a straightforward re-export of the prior FlutterFlow state — no data implications either way, since the DB-side capability flag (`reminder_enabled`) is independent of whether the UI currently exposes it.

### Verification/testing steps
1. Pre-migration: reconfirm the 4-row count and null-field state one more time immediately before running (`SELECT * FROM tasks WHERE task_type = 'Reminder';`), in case anything changed between planning and execution.
2. Post-backfill: `SELECT count(*) FROM tasks WHERE task_type = 'Reminder';` → 0. `SELECT count(*) FROM tasks WHERE reminder_enabled = true;` → 4, all with `task_type = 'Task'`.
3. Post-column-drop: confirm `reminder_level`/`acknowledged_at` no longer appear in `information_schema.columns` for `tasks`.
4. Post-FlutterFlow-export: manually create a new Task with "Remind me" enabled; confirm it saves with `reminder_enabled = true` via `EditorHost`. Confirm it appears in Systems Control Panel's "Reminders" list. Confirm Current Action shows the Task icon with a bell badge, not a bell replacing the icon. Repeat with a Bill or Habit to confirm the capability genuinely works across types, not just `Task` (this is the actual point of ADR-001 — worth explicitly testing, not just the migrated rows).

### Dependencies
Database steps: additive step has no dependency; backfill depends on the additive step landing first; destructive step depends on the FlutterFlow export (removing all `lib/` reads of `reminder_level`/`acknowledged_at`, which is trivial since none currently exist — but also depends on the "Remind me" toggle UI actually landing, so there's a working replacement before the old signal is fully gone). Practically sequenced with 2A.2 for the shared TaskForm dropdown and Current Action edits (same FlutterFlow session).

---

## Cross-Cutting Sequencing

### Step-by-step estimated implementation order

1. **Supabase additive migration** (combined, single transaction): `reminder_enabled`, `lifecycle_state` columns added; `lifecycle_state` backfilled. *(2A.3, 2A.4 — additive/backfill portions only. No FlutterFlow dependency, can start immediately once approved.)*
2. **`lib/` call-site inventory for `is_active`** (grep-and-document pass, no edits yet) — start in parallel with step 1, since it's investigation, not implementation, and doesn't touch the database. *(2A.3 prep.)*
3. **FlutterFlow session 1** — all UI/save-flow work in one editing pass, since it all touches the same handful of files: remove `Event` and `Reminder` from the TaskForm dropdown; add the "Remind me" toggle; replace the `is_active` Switch with a `lifecycle_state` control; update both `EditorHost` save blocks (`reminder_enabled`, `lifecycle_state`); update Systems Control Panel's Reminders filter; restructure Current Action's icon logic (remove `Event`/`Reminder` branches, add the bell-badge overlay driven by `reminderEnabled`). *(2A.2, 2A.3, 2A.4 UI portions.)*
4. **Export FlutterFlow → `flutterflow` branch → merge into `develop`.**
5. **Post-export verification** (manual app walkthrough): create/edit a Task with Remind-me on; create/edit a Habit with a lifecycle state set; confirm Current Action and Systems Control Panel render correctly; confirm no `Event`/`Reminder` option remains in the dropdown.
6. **Supabase destructive migration** (combined, single transaction, only after step 5 passes): pre-drop snapshots of `completed`, `reminder_level`, `acknowledged_at`; then `DROP COLUMN completed, reminder_level, acknowledged_at`. *(2A.1, 2A.4 destructive portions.)*
7. **`schema.sql` refresh** to match final live state.
8. **Fast-follow, separately scheduled:** once the `is_active` inventory (step 2) is fully confirmed clear of remaining reads, a second small migration drops `tasks.is_active`. *(2A.3 completion — deliberately decoupled from step 6, see 2A.3's Database changes section for why.)*

### Dependency graph

```text
[Supabase additive migration] ──► [FlutterFlow session 1] ──► [export + merge] ──► [verification]
        │                                                                                │
        │                                                                                ▼
        │                                                                 [Supabase destructive migration]
        │                                                                                │
        └──────────────────────────────────────────────────────────────────────────────►│
                                                                                            ▼
                                                                          [schema.sql refresh]

[lib/ is_active inventory] ──(informs)──► [FlutterFlow session 1, step: lifecycle_state control shape]
                                                                                            │
                                                                                            ▼
                                                            [fast-follow: drop tasks.is_active] (separate, later)
```

---

## Sign-off Checklist

Before step 1 (Supabase additive migration) begins, confirm:

- [ ] The "check constraint" correction (Correction 1) is acknowledged — no schema-level enum change needed for `Event`/`Reminder` removal.
- [ ] `is_active = false` → `'Paused'` backfill default (2A.3) is acceptable, or specify a different default.
- [ ] `lifecycle_state` UI shape for TaskForm (2A.3, FlutterFlow work order item 2) — universal 3-option control, or conditional/Habit-Routine-only — needs your call before that part of FlutterFlow session 1 can be fully specified.
- [ ] `tasks.is_active` staying live (not dropped) through this pass, with its removal deliberately deferred to a fast-follow migration, is the intended sequencing.
- [ ] Combining all four items' Supabase work into two migrations (one additive+backfill, one destructive) rather than four separate ones is acceptable.
- [ ] Manual verification (no automated test suite exists) is an acceptable testing approach for this pass.

Once confirmed, execution proceeds per the numbered sequencing above, starting with the additive Supabase migration.
