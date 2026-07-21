# PROJECT_STATUS.md

## Architectural Decisions (Source of Truth — Product Architect, 2026-07-22)

These are confirmed product/architecture decisions, treated as authoritative going forward regardless of current code/doc state. Where they conflict with DATABASE.md/ROADMAP.md as written, these decisions win until those docs are updated.

1. **The Universal Task Model is the foundation of CompleteOS+.** Finish it before expanding other systems.
2. **Tasks are moving away from a simple `due_at` model.** The scheduling model going forward is Start Date & Time + End Date & Time, with Deadline reserved as a possible future addition only if needed later. This scheduling model applies throughout the system, not just to one task type — exact scope across task types is being clarified (see Open Questions below).
3. **Scheduling is block-first internally but calendar-first for the user.** Users visually build days/weeks/months; underneath, the system runs on Day Blocks and Daily Plans (existing schema, zero UI today).
4. **Foundations before polish.** Do not recommend UI polish, visual fixes, or minor features while core systems (Universal Task Model, scheduling) are incomplete. This explicitly deprioritizes items previously flagged as "Milestone 5 polish" (dead Finance button, decorative search fields, theme toggle UI, etc.) until foundations are done.
5. **When recommending work, prioritize what reduces future rework and strengthens the foundation** — not what's fastest or smallest in isolation.
6. **Do not assume the codebase reflects every architectural decision.** Ask before recommending a build order when a decision's implementation scope is ambiguous.

### Clarified scope (resolved 2026-07-22 — supersedes DATABASE.md's current `due_at`-only model)

- **Start Date & Time + End Date & Time are the primary scheduling fields for tasks, used throughout the system** — not limited to Appointment/Event as today. Applies broadly across task types, not just duration-based ones.
- **`due_at` is repurposed as an optional "Deadline" field** — not removed from the schema, but no longer "the" scheduling field. Populated only when a task actually requires a hard deadline distinct from its start/end window.
- **Current Action's ordering should move from `due_at` to `start_at`** as the tiebreaker after `priority_rank` (currently `execution_page_widget.dart:198` orders by `due_at` — this is targeted for change, not yet implemented).
- **Projects CRUD is NOT blocked by decision #1** — it can proceed in parallel with Universal Task Model completion since it doesn't touch task scheduling and reuses the already-proven Area/EditorHost pattern.

**Status: none of the above exists in code yet.** `due_at` is still the sole scheduling field used everywhere in `task_form_widget.dart`/`editor_host_widget.dart` except the already-wired Appointment/Event `start_at`/`end_at`, and Current Action still orders by `due_at`. This section records target architecture agreed with the Product Architect, to guide the next round of TaskForm/scheduling work — implementation has not started.

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

## Next Actions

1. **Immediate:** Confirm RLS + `profiles` trigger status on the live Supabase project.
2. Approve and begin the Projects CRUD sprint described above.
3. After Projects — complete type-specific Task behavior for all 6 non-base types (largest remaining V1 gap), in this order:
   a. Define the required additional fields for every task type (Habit, Routine, Bill, Appointment, Reminder, Event).
   b. Add the fields to TaskForm using conditional visibility by `task_type`.
   c. Verify the required columns/related tables exist in the live Supabase project (not just `schema.sql`, already known to be stale in at least one place).
   d. Wire create and edit mappings for every type-specific field.
   e. Update the task-type list subtitles to show correct metadata per type.
   f. Make the Current Action icon dynamic based on the active task's `task_type`.
   g. Test each task type end to end.
4. Then: Action Option Sheet wiring (closes out Milestone 2).
5. Then: Recurring Templates → Day Blocks/Daily Plans (Milestone 3/4, both required by the V1 Definition of Done).
6. Hide Goals and Automation tabs — not required for V1, currently shipped as broken UX.

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
