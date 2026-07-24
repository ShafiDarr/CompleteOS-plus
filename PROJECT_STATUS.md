# PROJECT_STATUS.md

This file tracks implementation status and progress only. Product scope (mission, V1 Commitment Types, and the Capture/Organize/Plan Today/Execute/Review lifecycle) lives in V1_PRODUCT.md. Architecture decisions live in ARCHITECTURE.md — see its "Confirmed Architecture Decisions" section for the Universal Task Model priority, the Start/End/Deadline scheduling model, and the block-first/calendar-first scheduling approach, all of which inform the priorities below.

## Audit Record

- **Date/time of audit:** 2026-07-14 05:10 UTC (scoring corrections applied 2026-07-15 02:08 UTC — product owner clarified Task-type completion criteria and flagged the Current Action icon gap; self-challenge pass applied 2026-07-15 21:56 UTC — found a hardcoded fake score widget live on the dashboard and confirmed an entire unused verification/calendar-sync column set; **new FlutterFlow export verified merged 2026-07-21 21:39 UTC (commit `1c08b68`, merged into `develop` via PR #14) — re-verified against actual merged code, not just diffs, on 2026-07-21**; **live Supabase project queried directly 2026-07-24 — RLS, `profiles` trigger, `priority_rank`/`current_action_candidates`, and actual row data all verified server-side for the first time, see updated Blockers and Audit Confidence below**)
- **Audited commit:** `6c3d02e` (merge of PR #14, includes the audit docs from PR #13 and the new FlutterFlow export)
- **Audited branch:** `claude/completeos-audit-v1-path-hfpb6c`, restarted from `origin/develop` after its own PR (#13) merged — no unmerged local work exists; branch is currently identical to `develop`
- **Overall V1 completion: ≈52%** (down from ≈53% — see Database and Supabase row: live RLS audit found 11 of 13 tables have zero policies, which is worse than the "unverified" assumption the previous score was based on)
- **Audit confidence: Medium-High** — high confidence on anything verifiable from source (code, git history, actual query call-sites), now also high confidence on the live Supabase project itself (RLS policies, `profiles` auto-creation trigger, and `tasks.priority_rank` / `current_action_candidates` all directly queried 2026-07-24). Remaining gap: no way to test the *actual app* against the live project from this environment, so behavior (as opposed to schema/policy state) is still inferred, not observed.

---

## Weighted Scoring Table

| System | Weight | Completion | Weighted contribution | Remaining work |
|---|---:|---:|---:|---|
| Foundation and architecture | 8 | 75% | 6.00 | Finish ARCHITECTURE.md (cuts off mid-section); document Repository pattern honestly |
| Authentication and multi-user isolation | 8 | 75% | 6.00 | Add "Forgot password" UI; enable `requireAuth`; verify/insert `profiles` on signup |
| Database and Supabase | 8 | 35% | 2.80 | **Live-verified 2026-07-24 (lowered from 50%, was previously an optimistic assumption):** 11 of 13 tables (`profiles`, `projects`, `recurring_templates`, `habit_logs`, `day_blocks`, `block_items`, `daily_status`, `routine_step_logs`, `routine_steps`, `daily_plans`, `daily_plan_blocks`) have RLS enabled but zero policies — default-deny, so the app's `anon`/`authenticated` client cannot read or write any of them today. Only `areas` and `tasks` have real policies. Add per-table RLS policies (straightforward `auth.uid() = user_id` for 9 of the 11; `profiles` needs `auth.uid() = id`; `routine_steps` has no `user_id` column at all and needs a subquery policy through its parent `tasks.user_id`). Also refresh `schema.sql` (confirmed still missing `priority_rank` and `current_action_candidates`, both of which exist live) and fix `handle_new_user()`'s mutable `search_path` (linter WARN) |
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
| **Total** | **100** | — | **≈52%** (down from ≈53% — Database and Supabase dropped 50%→35% after live RLS audit found 11 of 13 tables have no policies at all; previous score assumed RLS was probably fine pending verification) | |

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

**Objective:** Complete Projects CRUD end-to-end (reusing the proven Area/EditorHost pattern).

**Blocking prerequisite (found 2026-07-24, see Blocker #1): `public.projects` has RLS enabled with zero policies.** Nothing in this sprint's Tasks 2-7 can pass its own acceptance criteria (or even the existing read-only dropdown) against the live project until a policy like `areas`'/`tasks`' four (`auth.uid() = user_id`, one each for `SELECT`/`INSERT`/`UPDATE`/`DELETE`) is added to `projects`. Add that policy first — this is a database change and needs the Product Architect's sign-off same as any other schema change per CLAUDE.md, not something to slip in silently while building the Dart side.

Tasks:
1. ~~Verify RLS policies + `profiles` auto-creation trigger on the live Supabase project~~ — **done 2026-07-24, see Blocker #1**: `profiles` trigger confirmed working; RLS confirmed enabled-but-policyless on `projects` (and 10 other tables) — add the `projects` RLS policy before continuing this sprint.
2. Add `ProjectFormModel`/`ProjectFormWidget` mirroring `area_form`.
3. Wire `EditorHostModel`/`EditorHostWidget` with a `'project'` editorType branch (create + edit + save).
4. Add a `'project'` branch to `ConfirmDeleteDialogWidget`.
5. Add real list content to the Projects tab in `systems_control_panel_widget.dart`.
6. Wire the "+" button on the Projects tab to open EditorHost in new-project mode.
7. Manual test: create/edit/delete a project, and confirm a second user cannot see the first user's projects.

**Acceptance criteria:** A user can create, view, edit, and delete Projects entirely from the Systems Control Panel with the same correctness already proven for Areas.

**Do not touch during this sprint:** Task-type dynamic fields, Habit/Routine logging, Goals/Automation tabs, Day Blocks/Daily Plans, EditorHost's action menu, or FlutterFlow-generated files outside the ones listed above.

## Blockers

1. **[VERIFIED LIVE 2026-07-24, updated from "unverifiable"]** `profiles` auto-provisioning works as documented — `auth.users` has an `on_auth_user_created` trigger firing a `SECURITY DEFINER` function `handle_new_user()` that inserts a `profiles` row on signup. **But RLS itself is a live, confirmed blocker, not a theoretical risk:** every table in `public` gets RLS auto-enabled by an event trigger (`rls_auto_enable()`, fires on `CREATE TABLE`) — this explains why `rls_enabled` is `true` everywhere — but that trigger only flips the RLS switch, it never creates a policy. Someone then hand-wrote policies for `areas` and `tasks` only (4 each: `SELECT`/`INSERT`/`UPDATE`/`DELETE`, all `auth.uid() = user_id`). The other **11 tables have RLS enabled with zero policies**, which is Postgres default-deny: `profiles`, `projects`, `recurring_templates`, `habit_logs`, `day_blocks`, `block_items`, `daily_status`, `routine_step_logs`, `routine_steps`, `daily_plans`, `daily_plan_blocks` are all completely inaccessible to the app's real `anon`/`authenticated` client — not a data-leak risk, the opposite: total lockout. Concretely this means: the "read-only Projects dropdown" this audit previously called 25% done is almost certainly rendering empty for every real signed-in user right now (the 9 `projects` rows found in the live DB could only have been inserted via a privileged/service-role connection, not through the app), and the current sprint's Projects CRUD objective cannot pass its own acceptance criteria until a `projects` policy exists. Every unbuilt table this audit has been treating as "just needs UI wiring" (`habit_logs`, `routine_steps`, `day_blocks`, `daily_plans`, etc.) also needs an RLS policy added before that wiring can work at all — this is now a prerequisite step for every remaining Next Action, not just Projects. `routine_steps` has no `user_id` column, so its policy can't copy the `areas`/`tasks` pattern — it needs a subquery through `tasks.user_id` via `task_id`. Also flagged by the linter: `handle_new_user()` has a mutable `search_path` (hijacking risk for a `SECURITY DEFINER` function, WARN level), and Auth's leaked-password-protection setting is disabled (WARN, one-toggle fix).
2. **[VERIFIED LIVE 2026-07-24, confirmed accurate]** `schema.sql` is stale relative to the live database: confirmed via direct query that `tasks.priority_rank` (`smallint`) and the `current_action_candidates` view both exist live and neither appears anywhere in `schema.sql`. The view's definition also only filters on `due_at` (`WHERE due_at IS NULL OR due_at < CURRENT_DATE + 1 day`) — it was never updated for the Start/End scheduling architecture, and no live task has `start_at` populated yet (0 of 24 rows), so Next Action #2 below ("update ordering to `priority_rank`/`start_at`") should also update this view's filter, not just the Dart query, or the two will disagree about which tasks are eligible.
3. No automated test coverage exists at all (only the default FlutterFlow boilerplate widget test).
4. **`ScoreWidget` (`lib/components/score/score_widget.dart:56-57`) renders a hardcoded `'88'` and is live on the Execution Page** (`execution_page_widget.dart:146`) — every user sees a permanent fake score on the main dashboard. Found in a second, adversarial audit pass; **re-verified still present after the 2026-07-21 FlutterFlow export/merge — untouched.** Should be wired to the unused `daily_status.alignment_score` column or removed before any release.
5. An entire "verification / reminder / calendar-sync" subsystem implied by DATABASE.md (`calendar_sync`, `calendar_event_id`, `calendar_synced_at`, `completion_synced`, `requires_verification`, `verification_status`, `reminder_level`, `acknowledged_at` on `tasks`) is confirmed 100% unused in application code — not partially built, entirely vestigial.
6. Habit, Routine, Bill, and Reminder task types remain completely unwired for type-specific fields (only Appointment/Event got `start_at`/`end_at` in the latest export) — Habit and Routine are the two types actually required by the V1 Definition of Done, and neither was touched.
7. **[NEW, live data 2026-07-24]** `tasks.completed` (boolean) and `tasks.status` (text) are redundant and actively out of sync in production: 12 of the 24 live rows have `completed = false` while `status = 'Completed'` (zero rows show the opposite mismatch). The 3-value `status` field is clearly the one the UI actually reads/writes (consistent with the already-verified `Pending`/`In Progress`/`Completed` dropdown); `completed` looks like an orphaned FlutterFlow default nothing keeps updated. Not urgent by itself, but anything that ever reads `completed` (a filter, a metric, a future migration) will silently get the wrong answer for half the completed tasks in the DB today. Worth consolidating onto `status` alone when the schema is next touched, same treatment as the `calendar_sync`/verification column set in item 5.

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

**Resolved 2026-07-24:** RLS + `profiles` trigger status confirmed on the live Supabase project — `profiles` trigger works, but RLS turned out to have zero policies on 11 of 13 tables. See Blocker #1. New outstanding item this raises: add RLS policies for those 11 tables (product-owner sign-off needed on policy shape per CLAUDE.md's database rules, even though the pattern is mechanical for 10 of them).

## Branch Strategy

- `flutterflow` — receives FlutterFlow exports only, never developed on directly.
- `develop` — primary integration branch; merge `flutterflow` in via PR, merge feature/audit branches in via PR.
- Feature/session branches (e.g. this audit's `claude/completeos-audit-v1-path-hfpb6c`) — cut from `develop`, PR back into it.
- Added checklist item: after every `flutterflow` → `develop` merge, confirm root `.md` docs and `schema.sql` survived (they have been accidentally wiped by prior merges and manually restored — see git history around commits `e775dda`, `9478f9e`, `4059470`, `e5aa1bd`, `69f28f9`, `ab55000`, `30d7457`).

## Audit Confidence & Unverified Items

**Confidence: Medium-High** (raised from Medium 2026-07-24 — the live Supabase project itself is no longer a blind spot, see below).

**Verified directly against the live Supabase project, 2026-07-24** (previously listed below as unverifiable):
- RLS is enabled on all 13 tables, but only `areas` and `tasks` have actual policies — the other 11 have RLS-enabled-with-no-policy, i.e. total lockout for the app's real client. See Blocker #1.
- The `on_auth_user_created` → `handle_new_user()` signup trigger does auto-create `profiles` rows, exactly as documented.
- `tasks.priority_rank` (`smallint`) and the `current_action_candidates` view both genuinely exist server-side; `schema.sql` is confirmed stale (missing both, plus every column the view selects). See Blocker #2.
- Live row counts as of 2026-07-24 (ground truth, not estimates — see methodology note below): `tasks` 24 (`Task` 16 [4 Completed/1 In Progress/11 Pending], `Reminder` 4, `Habit` 2, `Routine` 2 — **zero** `Bill`/`Appointment`/`Event` rows exist despite those types having form fields), `recurring_templates` 46 (10 tasks reference one via `template_id`, all valid/non-orphaned — this table is quietly non-trivial, not dead, but is one of the 11 tables the app can't currently reach), `routine_steps` 15, `areas` 9, `projects` 9, `profiles` 3, everything else (`habit_logs`, `day_blocks`, `block_items`, `daily_status`, `routine_step_logs`, `daily_plans`, `daily_plan_blocks`) 0.
- No row currently has `start_at` or `end_at` set (0 of 24) despite the Start/End scheduling architecture being "confirmed" — the schema and form support it, but no real data has ever exercised it yet.

**Methodology note:** the Supabase table-listing tool's row counts are Postgres planner estimates (`pg_class.reltuples`), not live counts, and were caught stale for both `recurring_templates` (reported 0, actually 46) and `projects` (reported 0, actually 9) during this audit. Any future row-count claim in this doc should be a direct `count(*)`, not a table-listing estimate.

Still cannot be verified from this repository or this environment:
- Whether the anon key embedded in `lib/backend/supabase/supabase.dart` corresponds to *this* project (it should, but was not cross-checked byte-for-byte against the live project's API settings).
- Actual app behavior against the live project — schema/policy state was queried directly, but no build of the app was run against it, so e.g. "does the Projects dropdown actually render empty" is a strong inference from the RLS state, not an observed screenshot.

Assumptions made in this audit:
- `schema.sql`'s header ("for context only... may not be valid for execution") was taken at face value — it's treated as a possibly-stale reference, not the authoritative live schema.
- No backlog/issue-tracking files exist in the repo (confirmed via search) — the ROADMAP.md and this audit are the only prioritization sources available.
