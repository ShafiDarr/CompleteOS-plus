# PROJECT_STATUS.md

This file tracks implementation status and progress only. Product scope (mission, V1 Commitment Types, and the Capture/Organize/Plan Today/Execute/Review lifecycle) lives in V1_PRODUCT.md. Architecture decisions live in ARCHITECTURE.md — see its "Confirmed Architecture Decisions" section for the Universal Task Model priority, the Start/End/Deadline scheduling model, and the block-first/calendar-first scheduling approach, all of which inform the priorities below.

## Audit Record

- **Date/time of audit:** 2026-07-14 05:10 UTC (scoring corrections applied 2026-07-15 02:08 UTC — product owner clarified Task-type completion criteria and flagged the Current Action icon gap; self-challenge pass applied 2026-07-15 21:56 UTC — found a hardcoded fake score widget live on the dashboard and confirmed an entire unused verification/calendar-sync column set; **new FlutterFlow export verified merged 2026-07-21 21:39 UTC (commit `1c08b68`, merged into `develop` via PR #14) — re-verified against actual merged code, not just diffs, on 2026-07-21**)
- **Audited commit:** `6c3d02e` (merge of PR #14, includes the audit docs from PR #13 and the new FlutterFlow export)
- **Audited branch:** `claude/completeos-audit-v1-path-hfpb6c`, restarted from `origin/develop` after its own PR (#13) merged — no unmerged local work exists; branch is currently identical to `develop`
- **Overall V1 completion: 52%**
- **Audit confidence: Medium** — high confidence on anything verifiable from source (code, git history, actual query call-sites); low confidence on anything that only exists in the live Supabase project (RLS policies, `profiles` auto-creation trigger, and whether `tasks.priority_rank` / `current_action_candidates` genuinely exist server-side, since `schema.sql` is a stale/partial dump missing both).

---

## Weighted Scoring Table

| System | Weight | Completion | Weighted contribution | Remaining work |
|---|---:|---:|---:|---|
| Foundation and architecture | 8 | 75% | 6.00 | Finish ARCHITECTURE.md (cuts off mid-section); document Repository pattern honestly |
| Authentication and multi-user isolation | 8 | 75% | 6.00 | Add "Forgot password" UI; enable `requireAuth`; verify/insert `profiles` on signup |
| Database and Supabase | 8 | 50% | 4.00 | Refresh `schema.sql`; document `current_action_candidates` view; verify RLS live |
| Areas CRUD | 6 | 75% | 4.50 | Real per-category activity counts (currently hardcoded 0) |
| Goals CRUD | 1 | 0% | 0.00 | Not required for V1 — hide the dead tab instead of building it |
| Projects CRUD | 6 | 25% | 1.50 | Build full CRUD (read-only dropdown only today) |
| Tasks CRUD (base/common fields only, task_type='Task') | 10 | 100% | 10.00 | None — does NOT represent overall Task CRUD across all 7 types |
| Task-type support: Habit | 1.67 | 25% | 0.42 | Fields, DB mappings, create/edit wiring, real streak metadata, habit_logs write, e2e test |
| Task-type support: Routine | 1.67 | 25% | 0.42 | Fields, DB mappings, create/edit wiring, real step metadata, routine_steps/routine_step_logs write, e2e test |
| Task-type support: Bill | 1.67 | 25% | 0.42 | Fields (amount/payee/login_url), DB mappings, create/edit wiring, display metadata, e2e test |
| Task-type support: Appointment | 1.67 | 50% | 0.84 | **Verified fixed in commit 1c08b68:** start_at/end_at now wired end-to-end (TaskForm → EditorHost → Supabase create/update → Systems Control Panel edit callback). Still missing: `location` field (zero references anywhere), list display metadata, distinct execution behavior, e2e test |
| Task-type support: Reminder | 1.67 | 25% | 0.42 | Fields, DB mappings, create/edit wiring, display metadata, e2e test — untouched by the latest FlutterFlow export |
| Task-type support: Event | 1.67 | 50% | 0.84 | **Verified fixed in commit 1c08b68:** start_at/end_at now wired end-to-end, same as Appointment. Still missing: `location` field, list display metadata, distinct execution behavior, e2e test |
| Schedules (Day Blocks/Daily Plans/Block Items) | 8 | 25% | 2.00 | Build UI end-to-end (schema + generated wrappers only today) |
| Automations | 2 | 0% | 0.00 | Not required for V1 — hide the dead tab; no `automations` table exists |
| Systems Control Panel | 6 | 50% | 3.00 | Wire Projects/Schedules tab bodies; hide Goals/Automation |
| EditorHost | 6 | 50% | 3.00 | Add Project support (currently Area + Task only) |
| Execution Dashboard | 6 | 50% | 3.00 | Wire Action Option Sheet (Skip/Postpone/Not Now/View Details — currently no onTap at all); make task-type icon dynamic |
| Current Action and prioritization | 8 | 75% | 6.00 | Real routine step counts (currently hardcoded '0/0'); make task-type icon dynamic per active task's task_type (newly added, currently static) |
| Testing and bug fixing | 4 | 0% | 0.00 | Only default FlutterFlow boilerplate test exists |
| Deployment readiness | 3 | 25% | 0.75 | Pin Flutter/Dart SDK; resolve git-pinned dependency; verify prod RLS |
| **Total** | **100** | — | **≈53%** (up from ≈52% — Appointment/Event task-type support each moved 25%→50% after verifying commit `1c08b68`'s start_at/end_at wiring against the actual merged code) | |

---

## Completed Work (Verified)

- Email/password auth: sign in, sign up, session persistence/restoration, error handling — fully wired to Supabase.
- Areas CRUD: create/edit/delete/list, correctly scoped by `user_id`.
- Tasks CRUD — base/common fields only (task_type='Task'): create/edit/delete/list/status/priority/area+project assignment/active toggle — fully wired, correctly scoped. **Does not cover the other 6 task types — see Task-type support rows above, none of which are complete.**
- Current Action prioritization: real server-side view (`current_action_candidates`), ordered by `priority_rank`/`due_at`, filtered by user and status; "mark complete" writes back correctly.
- Application-level multi-user query isolation: all 25 real query call-sites in the app include a `user_id` filter — no gaps found in the code itself (server-side RLS is unverified, see risks).
- `flutterflow` → `develop` merge pipeline: functioning as documented, 0 unmerged FlutterFlow work outstanding (verified 2026-07-21 after PR #14 merged).
- **Current Action task-type icon is now genuinely dynamic** — verified against merged code: 7 distinct icons keyed on `task_type` (`current_action_widget.dart:96-133`). Previously flagged as static/incomplete; confirmed fixed in commit `1c08b68`.
- **Appointment/Event `start_at`/`end_at` fields now have real end-to-end wiring** — verified: `TaskFormWidget`'s `onStartAtChange`/`onEndAtChange` → `EditorHostModel`/`EditorHostWidget` → real Supabase create/update calls → `SystemsControlPanelWidget`'s `onTaskEdit` callback (all 7 task-type sections) → `ExecutionPageModel` state. Confirmed fixed in commit `1c08b68`.
- **Sidebar title inconsistency fixed** — `mobile_drawer_widget.dart` now reads "CompleteOS+", consistent with `expanded_sidebar_widget.dart`. Confirmed fixed in commit `1c08b68`.

## Current Sprint

**Objective:** Complete Projects CRUD end-to-end (reusing the proven Area/EditorHost pattern), in parallel with a one-time manual check of live Supabase RLS + `profiles` trigger status.

Tasks:
1. Verify RLS policies + `profiles` auto-creation trigger on the live Supabase project (dashboard/CLI check, not code).
2. Add `ProjectFormModel`/`ProjectFormWidget` mirroring `area_form`.
3. Wire `EditorHostModel`/`EditorHostWidget` with a `'project'` editorType branch (create + edit + save).
4. Add a `'project'` branch to `ConfirmDeleteDialogWidget`.
5. Add real list content to the Projects tab in `systems_control_panel_widget.dart`.
6. Wire the "+" button on the Projects tab to open EditorHost in new-project mode.
7. Manual test: create/edit/delete a project, and confirm a second user cannot see the first user's projects.

**Acceptance criteria:** A user can create, view, edit, and delete Projects entirely from the Systems Control Panel with the same correctness already proven for Areas.

**Do not touch during this sprint:** Task-type dynamic fields, Habit/Routine logging, Goals/Automation tabs, Day Blocks/Daily Plans, EditorHost's action menu, or FlutterFlow-generated files outside the ones listed above.

## Blockers

1. RLS enforcement and `profiles` auto-provisioning are unverifiable from this repository — must be checked against the live Supabase project before this audit's risk assessment can be trusted.
2. `schema.sql` is stale relative to the live database: it's missing `tasks.priority_rank` and the entire `current_action_candidates` relation, both of which the Current Action feature depends on.
3. No automated test coverage exists at all (only the default FlutterFlow boilerplate widget test).
4. **`ScoreWidget` (`lib/components/score/score_widget.dart:56-57`) renders a hardcoded `'88'` and is live on the Execution Page** (`execution_page_widget.dart:146`) — every user sees a permanent fake score on the main dashboard. Found in a second, adversarial audit pass; **re-verified still present after the 2026-07-21 FlutterFlow export/merge — untouched.** Should be wired to the unused `daily_status.alignment_score` column or removed before any release.
5. An entire "verification / reminder / calendar-sync" subsystem implied by DATABASE.md (`calendar_sync`, `calendar_event_id`, `calendar_synced_at`, `completion_synced`, `requires_verification`, `verification_status`, `reminder_level`, `acknowledged_at` on `tasks`) is confirmed 100% unused in application code — not partially built, entirely vestigial.
6. Habit, Routine, Bill, and Reminder task types remain completely unwired for type-specific fields (only Appointment/Event got `start_at`/`end_at` in the latest export) — Habit and Routine are the two types actually required by the V1 Definition of Done, and neither was touched.

**Resolved since last update:** the Current Action query's removal of `.neqOrNull('status', 'Skipped')` is **confirmed intentional** by the Product Architect — "Skipped" represents a task that's now overdue and was never completed, so there's no product reason to permanently exclude it from resurfacing as the current action. Not a bug; no further action needed.

**Status options shortened (verified in code):** `task_form_widget.dart:1179-1184` now offers only `Pending` / `In Progress` / `Completed` — `Skipped` and `Postponed` have been removed from the dropdown, and a full-tree grep confirms zero remaining references to either value anywhere in `lib/` (clean removal, no stale code). **DATABASE.md is now out of date** — it still documents `status` as `Pending / In Progress / Completed / Skipped / Postponed` (line ~50) and should be updated to match the 3-value model.

## Next Actions (updated 2026-07-22 to reflect the Start/End scheduling architecture)

1. **Generalize Start/End Date & Time to all task types** (currently Appointment/Event-only), demoting `due_at` to an optional "Deadline" field in the same form. Do this before adding any more type-specific fields — extending the already-proven Appointment/Event pattern now costs less than rebuilding Habit/Routine fields on the old model later.
2. **Update Current Action's ordering** from `priority_rank`/`due_at` to `priority_rank`/`start_at` (`execution_page_widget.dart:198`) — do this right after step 1, since it depends on `start_at` being populated across all types.
3. **Habit fields** (`target_value`, `unit`, `frequency`, `tracking_type`) on top of the now-universal Start/End base.
4. **Habit check-in write path** (`habit_logs` insert) — streak metadata has nothing to read without this.
5. **Routine steps sub-flow** (`routine_steps` CRUD + `routine_step_logs` completion) — replaces the "Routine steps go here" placeholder. Largest remaining chunk.
6. **TaskTypeSection display-metadata pass** across all types, once 1-5 give it real data — do this last, not per-type as each field lands.
7. **Projects CRUD** — can run in parallel with any of the above (confirmed by Product Architect: not blocked by "finish Task Model first," since it doesn't touch scheduling and reuses the proven Area/EditorHost pattern).

**Deferred per decision #4 (foundations before polish) — do not recommend until the Task Model above is done:** Bill/Reminder type-specific fields (not in V1 DoD), `ScoreWidget`'s hardcoded score, dead Finance sidebar button, decorative search fields, theme-mode toggle UI, Goals/Automation tab hiding.

**Flagged, not yet actionable:** the Action Option Sheet's "Skip Today"/"Postpone" buttons were designed around `Skipped`/`Postponed` status values that no longer exist after the 3-value status simplification (`Pending`/`In Progress`/`Completed`). When this gets picked up, it needs a rethink of what those buttons should do now, not a direct wire-up of the original design.

**After the Universal Task Model is functionally complete:** Day Blocks + Daily Plans — the block-first internal engine with a calendar-first UI (decisions #1 and #3), matching ROADMAP.md's own Milestone 3 → Milestone 4 sequencing.

**Still outstanding, no dependency on the above, do whenever convenient:** Confirm RLS + `profiles` trigger status on the live Supabase project.

## Branch Strategy

- `flutterflow` — receives FlutterFlow exports only, never developed on directly.
- `develop` — primary integration branch; merge `flutterflow` in via PR, merge feature/audit branches in via PR.
- Feature/session branches (e.g. this audit's `claude/completeos-audit-v1-path-hfpb6c`) — cut from `develop`, PR back into it.
- Added checklist item: after every `flutterflow` → `develop` merge, confirm root `.md` docs and `schema.sql` survived (they have been accidentally wiped by prior merges and manually restored — see git history around commits `e775dda`, `9478f9e`, `4059470`, `e5aa1bd`, `69f28f9`, `ab55000`, `30d7457`).

## Audit Confidence & Unverified Items

**Confidence: Medium.**

Cannot be verified from this repository (require direct access to the live Supabase project):
- Whether RLS is actually enabled and correctly scoped on all 13 tables.
- Whether a signup trigger auto-creates `profiles` rows.
- Whether `tasks.priority_rank` and `current_action_candidates` genuinely exist server-side (used by the app, absent from `schema.sql`).
- Whether the anon key embedded in `lib/backend/supabase/supabase.dart` corresponds to a project with restrictive RLS (the key itself is a public anon key, not a secret leak, but its safety depends entirely on server-side policy).

Assumptions made in this audit:
- `schema.sql`'s header ("for context only... may not be valid for execution") was taken at face value — it's treated as a possibly-stale reference, not the authoritative live schema.
- No backlog/issue-tracking files exist in the repo (confirmed via search) — the ROADMAP.md and this audit are the only prioritization sources available.
