# V1_CHECKLIST.md

Permanent source of truth for CompleteOS+ V1 completion. Update this file as work lands — do not let it drift from reality; re-verify against actual code, not intentions, before checking anything off.

Last audited: 2026-07-15, commit `f69cabc` (scoring corrections from product owner re: Task-type completion and Current Action icon; no code changed). **Overall: 52%.**

---

## Foundation and architecture — weight 8, **75%**

- [x] Repository/navigation/EditorHost/Systems Panel/Execution page structurally exist and function for their implemented paths
- [x] Core documentation set exists (VISION, SYSTEM_PRINCIPLES, DOMAIN_ARCHITECTURE, DATABASE, ROADMAP, BUILD_RULES, GLOSSARY)
- [ ] ARCHITECTURE.md is complete (currently cuts off mid-"Authentication" section; missing Navigation/Repository/EditorHost/Systems Panel/Execution sections its own diagram promises)
- [ ] Router has more than 3 routes if/when more standalone pages are needed

## Authentication and multi-user isolation — weight 8, **75%**

- [x] Email/password sign in — real, wired
- [x] Email/password sign up — real, wired, with client-side validation
- [x] Session persistence/restoration across app restarts
- [x] Every real data query in the app is scoped by `user_id` (verified at 25 call sites)
- [ ] "Forgot password" UI (backend method exists, `resetPassword`, but no button/link anywhere calls it)
- [ ] Route-level auth guard (`requireAuth` flag exists in router, never set `true` on any route)
- [ ] `profiles` row creation on signup verified (no client-side insert exists; depends on an unverified server-side trigger)
- [ ] Auth flow type reviewed (currently `implicit`; Supabase recommends PKCE for reset/confirmation links)

## Database and Supabase — weight 8, **50%**

- [x] 13 tables defined with FK relationships to `auth.users` for owner columns
- [x] 9 of 13 generated Dart table models match `schema.sql` column-for-column
- [ ] RLS policies confirmed enabled on the live project (zero policy statements exist in `schema.sql`; cannot be verified from this repo)
- [ ] `schema.sql` refreshed to include `tasks.priority_rank` and the `current_action_candidates` relation (both actively used by the app, absent from the dump)
- [ ] Orphaned `areas.icon`/`color`/`sort_order` fields in generated model reconciled (either drop from generated code or confirm they exist live)

## Areas CRUD — weight 6, **75%**

- [x] Create
- [x] Edit
- [x] Delete
- [x] List, correctly scoped
- [ ] Real per-category (Goals/Projects/Tasks) activity counts on Area cards (currently all hardcoded to the same `0`)

## Goals CRUD — weight 1, **0%**

- [ ] Not required for V1 per ROADMAP.md's Definition of Done
- [ ] Currently a dead nav tab (blank panel, non-functional "+" button) — **recommend hiding, not building, for V1**

## Projects CRUD — weight 6, **25%**

- [x] `projects` table + backend wrapper exist
- [x] Read-only dropdown to attach a task to a project (`task_form_widget.dart`)
- [ ] Create UI
- [ ] Edit UI
- [ ] Delete UI
- [ ] List/browse tab content in Systems Control Panel
- [ ] EditorHost support (`editorType == 'project'`)

## Tasks CRUD (base/common fields only — task_type='Task') — weight 10, **100%**

**Scope note:** this row covers only the shared/common fields (name, due date, priority, status, area/project assignment, active flag) on the generic `task_type='Task'` path. It does NOT represent overall Task CRUD across all 7 types — see the per-type breakdown below, which is tracked and scored separately and is explicitly NOT complete.

- [x] Create
- [x] Edit
- [x] Delete
- [x] List
- [x] Status transitions (Pending/In Progress/Completed/Skipped/Postponed)
- [x] Priority
- [x] Area/Project assignment
- [x] Active/inactive toggle
- [x] Correctly scoped by `user_id`

## Task-type support (Habit/Routine/Bill/Appointment/Reminder/Event) — weight 10, **25%**

**Scoring rule:** a type is NOT credited for completion merely because it appears in the `task_type` dropdown or has its own list section. Each type is scored on: required form fields, database mappings, create flow, edit flow, display metadata, and execution behavior — all six of which must actually work.

| Type | Form fields | DB mappings verified | Create flow | Edit flow | Display metadata | Execution behavior | Completion |
|---|---|---|---|---|---|---|---|
| Habit | ✗ | Not verified | ✗ | ✗ | Partial (real `frequency`; streak hardcoded `'0'`) | ✗ (no `habit_logs` write) | 25% |
| Routine | ✗ | Not verified | ✗ | ✗ | ✗ (steps count hardcoded `'0'`) | ✗ ("Routine steps go here" placeholder) | 25% |
| Bill | ✗ | Not verified | ✗ | ✗ | ✗ | ✗ | 25% |
| Appointment | ✗ | Not verified | ✗ | ✗ | ✗ | ✗ | 25% |
| Reminder | ✗ | Not verified | ✗ | ✗ | ✗ | ✗ | 25% |
| Event | ✗ | Not verified | ✗ | ✗ | ✗ | ✗ | 25% |

- [x] Type selector on Task form (all 7 `task_type` values) — structure only, not a completion signal per scoring rule above
- [x] Separately-filtered, correctly-scoped lists per type (7 real queries) — structure only, same caveat
- [ ] Required additional fields defined for every type (Habit, Routine, Bill, Appointment, Reminder, Event)
- [ ] Fields added to TaskForm with conditional visibility by `task_type` (form is currently one generic set of fields regardless of type)
- [ ] Required columns/related tables verified to exist in the live Supabase project (not just `schema.sql`, which is already known to be stale in at least one place)
- [ ] Create and edit mappings wired for every type-specific field (currently zero type-specific fields are read or written on save)
- [ ] Task-type list subtitles updated to show correct metadata per type (currently Habit/Routine show hardcoded placeholder counts; Bill/Appointment/Reminder/Event show none)
- [ ] Habit check-in logging UI (`habit_logs` table exists, generated wrapper never called)
- [ ] Routine steps checklist UI (`routine_steps`/`routine_step_logs` tables exist, generated wrappers never called)
- [ ] Each type tested end to end (create → edit → list display → Current Action behavior → completion)
- [ ] De-duplicate `task_type_section_widget.dart`'s ~7x repeated per-type block into one parameterized component

## Schedules (Day Blocks / Daily Plans / Block Items) — weight 8, **25%**

- [x] `day_blocks`, `block_items`, `daily_plans`, `daily_plan_blocks` tables + generated wrappers exist
- [ ] Any UI at all (Schedules tab currently renders a bare empty `Container()`)
- [ ] Day Block create/edit/list
- [ ] Daily Plan generation and "follow today's plan" execution flow

## Automations — weight 2, **0%**

- [ ] Not required for V1 per ROADMAP.md's Definition of Done
- [ ] No `automations` table exists in schema at all
- [ ] Currently a dead nav tab (empty `Container()`) — **recommend hiding, not building, for V1**

## Systems Control Panel — weight 6, **50%**

- [x] Areas tab — real
- [x] Tasks tab — real
- [ ] Goals tab — no content branch at all
- [ ] Projects tab — no content branch at all
- [ ] Schedules tab — empty container
- [ ] Automation tab — empty container

## EditorHost — weight 6, **50%**

- [x] Create/edit/save/delete for Area
- [x] Create/edit/save/delete for Task
- [ ] Support for Project
- [ ] Support for Schedule/Day Block
- [ ] Archive/Duplicate actions (action menu currently only has Delete/Cancel)

## Execution Dashboard — weight 6, **50%**

- [x] Real "what's next" query and display
- [x] Mark-complete write-back
- [ ] Action Option Sheet functional (Not Now / Skip Today / Postpone / View Details currently have no `onTap` at all)
- [ ] Real step-count display (currently hardcoded `'0/0'`)
- [ ] Task-type icon on the Current Action card is dynamic (icon exists but is currently static — does not change based on the active task record's `task_type`)

## Current Action and prioritization — weight 8, **75%**

- [x] Server-side prioritized query (`current_action_candidates`, ordered by `priority_rank`/`due_at`)
- [x] Correctly scoped, excludes completed/skipped
- [x] Mark-complete works
- [ ] Real routine-step content (currently placeholder text)
- [ ] Task-type icon dynamic per active task's `task_type` (newly added, currently static — tracked here as its own item per explicit correction, not folded into other gaps)

## Testing and bug fixing — weight 4, **0%**

- [ ] Any real test beyond the default FlutterFlow boilerplate widget test
- [ ] Auth flow tests
- [ ] Areas/Tasks CRUD tests
- [ ] Multi-user isolation tests
- [ ] Current Action tests

## Deployment readiness — weight 3, **25%**

- [x] App builds and runs via standard FlutterFlow export conventions
- [ ] Flutter/Dart SDK versions pinned (currently wide-open `>=3.0.0 <4.0.0`, no `flutter:` version key)
- [ ] `dropdown_button2` git-commit-pinned fork dependency reviewed/replaced with a pub.dev version
- [ ] Production Supabase RLS + config verified
- [ ] CI pipeline exists

---

## Overall: 52% — recompute this number only by re-scoring the items above, never by intuition.
