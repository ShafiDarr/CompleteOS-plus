# DATABASE.md

# CompleteOS+ Database Architecture

This document describes the current Supabase/PostgreSQL database for CompleteOS+.

The database currently contains **15 public tables**.

CompleteOS+ uses Supabase Auth for identity. Most application tables are user-owned and should be protected by Row Level Security.

---

# Database Philosophy

CompleteOS+ is built around user-owned execution data.

The database should support:

- Personal execution
- Areas of life
- Projects
- Tasks
- Habits
- Routines
- Day blocks
- Daily plans
- Daily status
- Recurring templates

Core rule:

Every user-owned table should reference the authenticated user through `user_id`.

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

The current schema contains these 15 tables:

1. `areas`
2. `projects`
3. `tasks`
4. `recurring_templates`
5. `routines`
6. `habit_logs`
7. `day_blocks`
8. `block_items`
9. `daily_status`
10. `habits`
11. `routine_step_logs`
12. `routine_steps`
13. `profiles`
14. `daily_plans`
15. `daily_plan_blocks`

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
- `routines.area_id`
- `habits.area_id`

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

Represents larger outcomes or goals that may contain tasks, habits, routines, and templates.

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

## Relationships

```text
projects.user_id → auth.users.id
projects.area_id → areas.id
```

Referenced by:

- `tasks.project_id`
- `recurring_templates.project_id`
- `routines.project_id`
- `habits.project_id`

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

Tasks are the core execution unit of CompleteOS+.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `project_id` | uuid | Optional parent project |
| `area_id` | uuid | Optional parent area |
| `template_id` | uuid | Optional recurring template |
| `name` | text | Task title |
| `status` | text | Task status |
| `priority` | text | Task priority |
| `due_at` | timestamptz | Due date/time |
| `completed_at` | timestamptz | Completion timestamp |
| `completed` | boolean | Completion flag |
| `task_type` | text | Task/Bill/Appointment/etc. |
| `calendar_sync` | boolean | Whether to sync to calendar |
| `requires_verification` | boolean | Whether completion needs confirmation |
| `verification_status` | text | Verification state |

## Relationships

```text
tasks.user_id → auth.users.id
tasks.project_id → projects.id
tasks.area_id → areas.id
tasks.template_id → recurring_templates.id
```

Referenced by:

- `block_items.task_id`

## V1 Notes

Tasks should always insert the authenticated user's `user_id`.

Execution dashboard queries should filter tasks by current user.

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
- `routines.template_id`
- `habits.template_id`

## Current Risk

`name` is globally unique.

Recommended future constraint:

```sql
UNIQUE (user_id, lower(name))
```

---

# 5. routines

## Purpose

Represents multi-step workflows.

Examples:

- Morning Routine
- Shutdown Routine
- Weekly Review

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `name` | text | Routine name |
| `status` | text | Routine status |
| `area_id` | uuid | Related area |
| `project_id` | uuid | Related project |
| `template_id` | uuid | Related recurring template |

## Relationships

```text
routines.user_id → auth.users.id
routines.area_id → areas.id
routines.project_id → projects.id
routines.template_id → recurring_templates.id
```

Referenced by:

- `routine_steps.routine_id`
- `block_items.routine_id`

## Current Risk

`name` is globally unique.

Recommended future constraint:

```sql
UNIQUE (user_id, lower(name))
```

---

# 6. habit_logs

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

## Relationships

```text
habit_logs.user_id → auth.users.id
```

## Current Gap

There is currently no `habit_id` foreign key in `habit_logs`.

Recommended future relationship:

```text
habit_logs.habit_id → habits.id
```

Without `habit_id`, logs cannot be reliably tied to a specific habit.

---

# 7. day_blocks

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

# 8. block_items

## Purpose

Represents items assigned inside a day block.

A block item can reference a task, habit, or routine.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `day_block_id` | uuid | Parent day block |
| `item_type` | text | Task / Habit / Routine |
| `routine_id` | uuid | Optional routine |
| `habit_id` | uuid | Optional habit |
| `task_id` | uuid | Optional task |
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
block_items.routine_id → routines.id
block_items.habit_id → habits.id
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

# 9. daily_status

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

# 10. habits

## Purpose

Represents repeated behaviors tracked over time.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Owner user |
| `name` | text | Habit name |
| `target_value` | numeric | Target amount |
| `unit` | text | Unit |
| `frequency` | text | Frequency |
| `is_active` | boolean | Active flag |
| `template_id` | uuid | Related recurring template |
| `area_id` | uuid | Related area |
| `project_id` | uuid | Related project |
| `tracking_type` | text | Boolean/numeric tracking |

## Relationships

```text
habits.user_id → auth.users.id
habits.template_id → recurring_templates.id
habits.area_id → areas.id
habits.project_id → projects.id
```

Referenced by:

- `block_items.habit_id`

## Current Risk

`name` is globally unique.

Recommended future constraint:

```sql
UNIQUE (user_id, lower(name))
```

---

# 11. routine_step_logs

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

# 12. routine_steps

## Purpose

Represents individual steps inside a routine.

## Key Columns

| Column | Type | Purpose |
|---|---|---|
| `id` | uuid | Primary key |
| `routine_id` | uuid | Parent routine |
| `name` | text | Step name |
| `step_order` | integer | Step order |
| `is_required` | boolean | Required flag |
| `created_at` | timestamptz | Created timestamp |

## Relationships

```text
routine_steps.routine_id → routines.id
```

Referenced by:

- `routine_step_logs.routine_step_id`

## Current Risk

`name` is globally unique, but routine steps should only need to be unique inside a routine.

Recommended future constraint:

```sql
UNIQUE (routine_id, step_order)
```

Optional:

```sql
UNIQUE (routine_id, lower(name))
```

---

# 13. profiles

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

# 14. daily_plans

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

# 15. daily_plan_blocks

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
│   │   ├── tasks
│   │   ├── habits
│   │   ├── routines
│   │   └── recurring_templates
│   │
│   ├── tasks
│   ├── habits
│   ├── routines
│   └── recurring_templates
│
├── tasks
│   └── block_items
│
├── recurring_templates
│   ├── tasks
│   ├── habits
│   └── routines
│
├── routines
│   ├── routine_steps
│   │   └── routine_step_logs
│   └── block_items
│
├── habits
│   ├── habit_logs
│   └── block_items
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
| `routines` | `name` | Different users may not be able to use the same routine name |
| `day_blocks` | `name` | Different users may not be able to use the same block name |
| `day_blocks` | `sort_order` | Different users may not be able to use the same block order |
| `block_items` | `title` | Different users may not be able to use the same item title |
| `block_items` | `sort_order` | Different users may not be able to use the same item order |
| `habits` | `name` | Different users may not be able to use the same habit name |
| `routine_steps` | `name` | Different routines may not be able to use the same step name |

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

Examples:

```text
habit_logs.habit_id → habits.id
routine_step_logs.routine_step_id → routine_steps.id
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

Future versions of this repository may include a raw `schema.sql` export from Supabase.

Until then, this document serves as the authoritative reference for the current database architecture.

This document is the human-readable database architecture guide.
