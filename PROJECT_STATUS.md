# PROJECT_STATUS.md

## Audit Record

- **Date/time of audit:** 2026-07-14 05:10 UTC
- **Audited commit:** `f69cabc5a1df25f8891388ea77e48d9b8aec9413`
- **Audited branch:** `claude/completeos-audit-v1-path-hfpb6c` (identical to `develop` at audit time; `flutterflow` fully merged in, 0 commits ahead)
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
| Tasks CRUD (base) | 10 | 100% | 10.00 | None |
| Task-type support (Habit/Routine/Bill/Appointment/Reminder/Event) | 10 | 25% | 2.50 | Dynamic form fields; wire habit_logs / routine_steps / routine_step_logs |
| Schedules (Day Blocks/Daily Plans/Block Items) | 8 | 25% | 2.00 | Build UI end-to-end (schema + generated wrappers only today) |
| Automations | 2 | 0% | 0.00 | Not required for V1 — hide the dead tab; no `automations` table exists |
| Systems Control Panel | 6 | 50% | 3.00 | Wire Projects/Schedules tab bodies; hide Goals/Automation |
| EditorHost | 6 | 50% | 3.00 | Add Project support (currently Area + Task only) |
| Execution Dashboard | 6 | 50% | 3.00 | Wire Action Option Sheet (Skip/Postpone/Not Now/View Details — currently no onTap at all) |
| Current Action and prioritization | 8 | 75% | 6.00 | Real routine step counts (currently hardcoded '0/0') |
| Testing and bug fixing | 4 | 0% | 0.00 | Only default FlutterFlow boilerplate test exists |
| Deployment readiness | 3 | 25% | 0.75 | Pin Flutter/Dart SDK; resolve git-pinned dependency; verify prod RLS |
| **Total** | **100** | — | **≈52%** | |

---

## Completed Work (Verified)

- Email/password auth: sign in, sign up, session persistence/restoration, error handling — fully wired to Supabase.
- Areas CRUD: create/edit/delete/list, correctly scoped by `user_id`.
- Tasks CRUD (base object): create/edit/delete/list/status/priority/area+project assignment/active toggle — fully wired, correctly scoped.
- Current Action prioritization: real server-side view (`current_action_candidates`), ordered by `priority_rank`/`due_at`, filtered by user and status; "mark complete" writes back correctly.
- Application-level multi-user query isolation: all 25 real query call-sites in the app include a `user_id` filter — no gaps found in the code itself (server-side RLS is unverified, see risks).
- `flutterflow` → `develop` merge pipeline: functioning as documented, 0 unmerged FlutterFlow work outstanding.

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

## Next Actions

1. **Immediate:** Confirm RLS + `profiles` trigger status on the live Supabase project.
2. Approve and begin the Projects CRUD sprint described above.
3. After Projects: Habit/Routine dynamic fields + logging UI (largest remaining V1 gap).
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
