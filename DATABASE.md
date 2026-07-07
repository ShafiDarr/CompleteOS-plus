# DATABASE.md

# CompleteOS+ Database Architecture

This document describes the current Supabase/PostgreSQL database for CompleteOS+.

The database currently contains **13 public tables**.

CompleteOS+ uses Supabase Auth for identity. Most application tables are user-owned and should be protected by Row Level Security.

---

# Database Philosophy

CompleteOS+ is built around user-owned execution data.

The database should support:

- Personal execution
- Areas of life
- Projects
- Tasks (including Habits, Routines, Bills, and Appointments as specialized task types)
- Day blocks
- Daily plans
- Daily status
- Recurring templates

Core rule:

Every user-owned table should reference the authenticated user through `user_id`.

---

# Universal Task Model

Habits and Routines are **not** separate tables. They are represented as rows in `tasks`, differentiated by `task_type`.

This directly implements SYSTEM_PRINCIPLES.md's P009 ("Tasks Are The Universal Execution Object") and DOMAIN_ARCHITECTURE.md's Task section.

`task_type` values in use or planned:

- `Task` — default, ordinary actionable work
- `Habit` — repeated behavior, uses `target_value`, `unit`, `frequency`, `tracking_type`
- `Routine` — multi-step workflow, whose steps live in `routine_steps` referencing `tasks.id`
- `Bill` — uses `amount`, `payee`, `login_url`
- `Appointment`/`Event` — uses `start_at`, `end_at`, `location`

Fields not relevant to a given `task_type` are simply left null on that row.

`status` is universal across all task types: `Pending` / `In Progress` / `Completed` / `Skipped` / `Postponed`.

`is_active` is a separate, universal boolean (not part of `status`) — for Habits/Routines it represents whether the recurring definition is still enabled; for other task types it defaults `true` and is largely unused.

---

# Authentication Model

Supabase Auth owns the actual user account.

Primary auth table:

```text
auth.users
```

Application profile table:

```text
public.profiles
```

Common relationship:

```text
user_id → auth.users.id
```

For `profiles`, the primary key `id` also references `auth.users.id`.

---

# Table Index

The current schema contains these 13 tables:

1. `areas`
2. `projects`
3. `tasks`
4. `recurring_templates`
5. `habit_logs`
6. `day_blocks`
7. `block_items`
8. `daily_status`
9. `routine_step_logs`
10. `routine_steps`
11. `profiles`
12. `daily_plans`
13. `daily_plan_blocks`

---

# 1. areas

## Purpose

Represents major life categories.

Examples:

- Health
- Finance
- Family
- Career
- Growth

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `name` | text | Area name |
| `description` | text | Optional description |
| `created_at` | timestamptz | Created timestamp |
| `active` | boolean | Whether area is active |

## Relationships

```text
areas.user_id → auth.users.id
```

Referenced by:

- `projects.area_id`
- `tasks.area_id`
- `recurring_templates.area_id`

## V1 Rule

Different users must be able to create the same area name.

The same user should not accidentally create duplicate area names.

Recommended future constraint:

```sql
UNIQUE (user_id, lower(name))
```

---

# 2. projects

## Purpose

Represents larger outcomes or goals that may contain tasks.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `area_id` | uuid | Parent area |
| `name` | text | Project name |
| `status` | text | Project status |
| `priority` | text | Project priority |
| `started_at` | timestamptz | Start date |
| `target_date` | timestamptz | Target date |
| `completed_at` | timestamptz | Completion timestamp |
| `is_active` | boolean | Whether project is active |

## Relationships

```text
projects.user_id → auth.users.id
projects.area_id → areas.id
```

Referenced by:

- `tasks.project_id`
- `recurring_templates.project_id`

## Current Risk

`name` is globally unique.

That means two different users may not be able to create the same project name.

Recommended future constraint:

```sql
UNIQUE (user_id, lower(name))
```

---

# 3. tasks

## Purpose

Represents actionable work.

Tasks are the **universal execution object** of CompleteOS+ — see "Universal Task Model" above. Every Task, Habit, Routine, Bill, and Appointment/Event is a row in this table, differentiated by `task_type`.

## Key Columns

### Universal (apply to every task_type)

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `created_at` | timestamptz | Created timestamp |
| `user_id` | uuid | Owner user |
| `project_id` | uuid | Optional parent project |
| `area_id` | uuid | Optional parent area |
| `template_id` | uuid | Optional recurring template |
| `name` | text | Title |
| `status` | text | Pending / In Progress / Completed / Skipped / Postponed |
| `priority` | text | Critical / High / Medium / Low |
| `due_at` | timestamptz | Due date/time |
| `completed_at` | timestamptz | Completion timestamp |
| `completed` | boolean | Completion flag |
| `task_type` | text | Task / Habit / Routine / Bill / Appointment / Event |
| `is_active` | boolean | Whether this record is enabled (mainly meaningful for Habit/Routine) |
| `calendar_sync` | boolean | Whether to sync to calendar |
| `requires_verification` | boolean | Whether completion needs confirmation |
| `verification_status` | text | Verification state |
| `reminder_level` | text | Reminder intensity |
| `acknowledged_at` | timestamptz | When a reminder/verification was acknowledged |
| `completion_synced` | boolean | Whether completion has synced externally |
| `calendar_event_id` | text | External calendar event reference |
| `calendar_synced_at` | timestamptz | Last calendar sync timestamp |

### Habit-specific (`task_type = 'Habit'`)

| Column | Type | Purpose |
|---|---|---|
| `target_value` | numeric | Target amount |
| `unit` | text | Unit of measure |
| `frequency` | text | How often the habit repeats |
| `tracking_type` | text | Boolean or numeric tracking |

### Appointment/Event-specific (`task_type = 'Appointment'`/`'Event'`)

| Column | Type | Purpose |
|---|---|---|
| `start_at` | timestamptz | Start time |
| `end_at` | timestamptz | End time |
| `location` | text | Location |

### Bill-specific (`task_type = 'Bill'`)

| Column | Type | Purpose |
|---|---|---|
| `amount` | numeric | Bill amount |
| `payee` | text | Who the bill is paid to |
| `login_url` | text | Payment portal URL |

## Relationships

```text
tasks.user_id → auth.users.id
tasks.project_id → projects.id
tasks.area_id → areas.id
tasks.template_id → recurring_templates.id
```

Referenced by:

- `block_items.task_id`
- `habit_logs.task_id`
- `routine_steps.task_id`

## V1 Notes

Tasks should always insert the authenticated user's `user_id`.

Execution dashboard queries should filter tasks by current user.

For Habit/Routine rows, `status` and `is_active` are independent: `status` still tracks per-instance progress where meaningful, while `is_active` tracks whether the recurring definition itself is still enabled.

---

# 4. recurring_templates

## Purpose

Represents recurring task/habit/routine blueprints.

Used to generate repeated execution items.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `name` | text | Template name |
| `default_task_type` | text | Default generated item type |
| `active` | boolean | Whether template is active |
| `default_status` | text | Default status |
| `default_priority` | text | Default priority |
| `schedule_type` | text | Calendar / pattern / after completion |
| `pattern_week` | text | Week A / Week B pattern |
| `frequency` | text | Daily / weekly / monthly etc. |
| `interval` | numeric | Repeat interval |
| `days_of_week` | text | Weekly selected days |
| `time_of_day` | time | Scheduled time |
| `day_of_month` | numeric | Monthly day |
| `area_id` | uuid | Related area |
| `project_id` | uuid | Related project |
| `last_completed_at` | timestamptz | Last completion |
| `next_run_at` | timestamptz | Next scheduled run |
| `last_generated_at` | timestamptz | Last generated item |

## Relationships

```text
recurring_templates.user_id → auth.users.id
recurring_templates.area_id → areas.id
recurring_templates.project_id → projects.id
```

Referenced by:

- `tasks.template_id`

## Current Risk

`name` is globally unique.

Recommended future constraint:

```sql
UNIQUE (user_id, lower(name))
```

---

# 5. habit_logs

## Purpose

Stores habit completion history.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `status` | text | Log status |
| `log_date` | timestamptz | Logged date |
| `completed_at` | timestamptz | Completion timestamp |
| `notes` | text | Optional notes |
| `task_id` | uuid | Related task (task_type = 'Habit') |

## Relationships

```text
habit_logs.user_id → auth.users.id
habit_logs.task_id → tasks.id
```

## Historical Data Note

`task_id` was added as part of the Universal Task Model migration. Pre-migration log rows have no way to be tied back to a specific habit — that linkage was never captured before this column existed, and could not be backfilled. Historical rows may have `task_id = NULL`; all logs going forward populate it.

---

# 6. day_blocks

## Purpose

Represents reusable time blocks or execution blocks.

Examples:

- Work
- Recovery
- Growth
- Operations
- Family

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `name` | text | Block name |
| `is_active` | boolean | Active flag |
| `start_time` | time | Optional start time |
| `end_time` | time | Optional end time |
| `sort_order` | smallint | Display order |

## Relationships

```text
day_blocks.user_id → auth.users.id
```

Referenced by:

- `block_items.day_block_id`
- `daily_plan_blocks.source_day_block_id`

## Current Risk

`name` and `sort_order` are globally unique.

Recommended future constraints:

```sql
UNIQUE (user_id, lower(name))
UNIQUE (user_id, sort_order)
```

---

# 7. block_items

## Purpose

Represents items assigned inside a day block.

A block item references a task — since Habits and Routines are task types, this single reference now covers what previously required three separate optional columns.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `day_block_id` | uuid | Parent day block |
| `item_type` | text | Task / Habit / Routine |
| `task_id` | uuid | Referenced task (of any task_type) |
| `title` | text | Display title |
| `target_amount` | numeric | Optional target amount |
| `unit` | text | Unit of measure |
| `target_time` | time | Target time |
| `deadline_time` | time | Deadline time |
| `grace_minutes` | smallint | Grace window |
| `sort_order` | smallint | Display order |
| `is_required` | boolean | Required flag |
| `target_offset_minutes` | integer | Offset from block start |
| `deadline_offset_minutes` | integer | Deadline offset |

## Relationships

```text
block_items.user_id → auth.users.id
block_items.day_block_id → day_blocks.id
block_items.task_id → tasks.id
```

## Current Risk

`title` and `sort_order` are globally unique.

Recommended future constraints:

```sql
UNIQUE (user_id, day_block_id, lower(title))
UNIQUE (user_id, day_block_id, sort_order)
```

---

# 8. daily_status

## Purpose

Stores daily check-in/check-out and operating state.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `status_date` | date | Date of status |
| `day_state` | text | Current daily state |
| `check_in_time` | timestamptz | Check-in time |
| `check_out_time` | timestamptz | Check-out time |
| `wake_status` | text | Wake status |
| `wake_message` | text | Wake message |
| `sleep_status` | text | Sleep status |
| `sleep_message` | text | Sleep message |
| `alignment_score` | numeric | Daily alignment score |
| `created_at` | timestamptz | Created timestamp |
| `updated_at` | timestamptz | Updated timestamp |

## Relationships

```text
daily_status.user_id → auth.users.id
```

## Recommended Constraint

One daily status record per user per date:

```sql
UNIQUE (user_id, status_date)
```

---

# 9. routine_step_logs

## Purpose

Stores completion history for individual routine steps.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `routine_step_id` | uuid | Related routine step |
| `log_date` | date | Log date |
| `completed_at` | timestamptz | Completion timestamp |
| `created_at` | timestamptz | Created timestamp |

## Relationships

```text
routine_step_logs.user_id → auth.users.id
routine_step_logs.routine_step_id → routine_steps.id
```

## Recommended Constraint

One log per user per routine step per date:

```sql
UNIQUE (user_id, routine_step_id, log_date)
```

---

# 10. routine_steps

## Purpose

Represents individual steps inside a Routine.

Since Routines are now `tasks` rows (`task_type = 'Routine'`), a routine step's parent is a task, not a separate `routines` table.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `task_id` | uuid | Parent task (task_type = 'Routine') |
| `name` | text | Step name |
| `step_order` | integer | Step order |
| `is_required` | boolean | Required flag |
| `created_at` | timestamptz | Created timestamp |

## Relationships

```text
routine_steps.task_id → tasks.id
```

Referenced by:

- `routine_step_logs.routine_step_id`

## Current Risk

`name` is globally unique, but routine steps should only need to be unique inside a routine.

Recommended future constraint:

```sql
UNIQUE (task_id, step_order)
```

Optional:

```sql
UNIQUE (task_id, lower(name))
```

---

# 11. profiles

## Purpose

Stores user profile and app preference information.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key and user id |
| `display_name` | text | Display name |
| `timezone` | text | User timezone |
| `wake_time` | time | Default wake time |
| `sleep_time` | time | Default sleep time |
| `created_at` | timestamptz | Created timestamp |
| `updated_at` | timestamptz | Updated timestamp |

## Relationships

```text
profiles.id → auth.users.id
```

---

# 12. daily_plans

## Purpose

Represents a generated or manually created execution plan for a specific day.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `plan_date` | date | Date of plan |
| `template_id` | uuid | Optional template source |
| `plan_type` | text | Template/manual type |
| `status` | text | Planned/active/complete |
| `source` | text | Manual/generated source |
| `created_at` | timestamptz | Created timestamp |
| `updated_at` | timestamptz | Updated timestamp |

## Current Gap

No foreign key is currently defined for `user_id`.

Recommended relationship:

```text
daily_plans.user_id → auth.users.id
```

## Recommended Constraint

One daily plan per user per date:

```sql
UNIQUE (user_id, plan_date)
```

---

# 13. daily_plan_blocks

## Purpose

Represents scheduled blocks inside a specific daily plan.

These are runtime/execution blocks generated from reusable `day_blocks`.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `daily_plan_id` | uuid | Parent daily plan |
| `user_id` | uuid | Owner user |
| `area_id` | uuid | Related area |
| `block_name` | text | Runtime block name |
| `start_time` | time | Start time |
| `end_time` | time | End time |
| `sort_order` | smallint | Display order |
| `status` | text | Pending/active/complete |
| `source_day_block_id` | uuid | Source reusable day block |
| `created_at` | timestamptz | Created timestamp |
| `updated_at` | timestamptz | Updated timestamp |

## Relationships

```text
daily_plan_blocks.source_day_block_id → day_blocks.id
```

## Current Gaps

No foreign key is currently defined for:

```text
daily_plan_blocks.daily_plan_id → daily_plans.id
daily_plan_blocks.user_id → auth.users.id
daily_plan_blocks.area_id → areas.id
```

Recommended constraints:

```sql
UNIQUE (daily_plan_id, sort_order)
```

---

# High-Level Relationship Map

```text
auth.users
│
├── profiles
├── areas
│   ├── projects
│   │   └── tasks
│   ├── tasks
│   └── recurring_templates
│
├── projects
│   └── tasks
│
├── tasks (task_type: Task / Habit / Routine / Bill / Appointment / Event)
│   ├── block_items
│   ├── habit_logs        (task_type = 'Habit')
│   └── routine_steps     (task_type = 'Routine')
│           └── routine_step_logs
│
├── recurring_templates
│   └── tasks
│
├── day_blocks
│   ├── block_items
│   └── daily_plan_blocks
│
├── daily_status
├── daily_plans
│   └── daily_plan_blocks
└── daily_plan_blocks
```

---

# Current Schema Risks To Audit Before V1

The current schema contains multiple global `UNIQUE` constraints that may cause multi-user conflicts.

These should be reviewed before V1.

## Global Unique Constraints Found

| Table | Column | Risk |
|---|---|---|
| `projects` | `name` | Different users may not be able to use the same project name |
| `recurring_templates` | `name` | Different users may not be able to use the same template name |
| `day_blocks` | `name` | Different users may not be able to use the same block name |
| `day_blocks` | `sort_order` | Different users may not be able to use the same block order |
| `block_items` | `title` | Different users may not be able to use the same item title |
| `block_items` | `sort_order` | Different users may not be able to use the same item order |
| `routine_steps` | `name` | Different tasks may not be able to use the same step name |

---

# Recommended V1 Database Rules

## User Ownership

All user-owned records should have:

```text
user_id NOT NULL
```

and a foreign key:

```text
user_id → auth.users.id
```

## Multi-User Naming

Avoid global uniqueness on names.

Prefer:

```sql
UNIQUE (user_id, lower(name))
```

or for child records:

```sql
UNIQUE (parent_id, lower(name))
```

## Ordering

Avoid global uniqueness on `sort_order`.

Prefer ordering unique within the parent scope:

```sql
UNIQUE (user_id, parent_id, sort_order)
```

## Logs

Logs should reference the entity they are logging.

```text
habit_logs.task_id → tasks.id            (implemented)
routine_step_logs.routine_step_id → routine_steps.id   (implemented)
```

## Daily Records

Daily records should usually be unique per user per day.

Examples:

```sql
UNIQUE (user_id, status_date)
UNIQUE (user_id, plan_date)
```

---

# RLS Requirements

Every user-owned table should have Row Level Security enabled.

Users should only be able to:

- Select their own records
- Insert records with their own `user_id`
- Update their own records
- Delete their own records

Standard policy pattern:

```sql
auth.uid() = user_id
```

For `profiles`, the policy should use:

```sql
auth.uid() = id
```

---

# Raw Schema Reference

The raw SQL schema exported from Supabase is stored at `schema.sql` in the repository root.

This document is the human-readable database architecture guide; `schema.sql` is the authoritative structural reference.
