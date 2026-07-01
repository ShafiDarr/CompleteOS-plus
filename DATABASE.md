# DATABASE.md

# CompleteOS+ Database Architecture

This document describes the database architecture for CompleteOS+.

The database is built on Supabase (PostgreSQL) and is designed around user-owned data with Row Level Security.

Every user-owned record belongs to a single authenticated user.

---

# Database Philosophy

The database supports the CompleteOS+ architecture.

The Repository layer is the application's source of truth.

Business logic should consume data through the Repository rather than accessing tables directly.

Relationships should be preserved through foreign keys.

Data integrity is preferred over convenience.

---

# Authentication

Authentication is handled by Supabase Auth.

Primary user table:

- auth.users

User profile information is stored in:

- profiles

Every user-owned table references:

```text
user_id → auth.users.id
```

---

# Core Tables

## profiles

Purpose

Stores user profile and application preferences.

Contains

- display_name
- timezone
- wake_time
- sleep_time

---

## areas

Purpose

High-level life categories.

Examples

- Health
- Career
- Finance
- Family

Relationships

- Projects
- Tasks
- Habits
- Routines
- Daily Plan Blocks

---

## projects

Purpose

Large outcomes that belong to an Area.

Relationships

Belongs to

- User
- Area

Contains

- Tasks
- Habits
- Routines
- Templates

---

## tasks

Purpose

Individual actionable work.

Relationships

Belongs to

- User
- Area
- Project
- Recurring Template

Supports

- Calendar Sync
- Due Dates
- Completion
- Verification
- Priorities

---

## recurring_templates

Purpose

Blueprints for automatically generating recurring work.

Supports

- Daily
- Weekly
- Monthly
- Pattern
- After Completion

Can generate

- Tasks
- Habits
- Routines

---

## routines

Purpose

Multi-step workflows.

Examples

Morning Routine

Shutdown Routine

Weekly Review

Relationships

Belongs to

- Area
- Project
- Template

Contains

- Routine Steps

---

## routine_steps

Purpose

Individual steps within a Routine.

Relationships

Belongs to

- Routine

Produces

- Routine Step Logs

---

## routine_step_logs

Purpose

Historical completion records for Routine Steps.

Used for

Progress

Analytics

History

---

## habits

Purpose

Repeated behaviors tracked over time.

Supports

Boolean tracking

Numeric tracking

Relationships

Belongs to

- User
- Area
- Project
- Template

Produces

Habit Logs

---

## habit_logs

Purpose

Stores completion history for Habits.

Contains

Completion status

Notes

Completion timestamps

---

## day_blocks

Purpose

Reusable schedule blocks.

Examples

Morning

Work

Recovery

Growth

Evening

Relationships

Contains

Block Items

---

## block_items

Purpose

Individual items assigned to Day Blocks.

May reference

- Habit
- Task
- Routine

Supports

Ordering

Target times

Deadlines

Offsets

Requirements

---

## daily_status

Purpose

Stores the user's daily operating status.

Contains

Wake status

Sleep status

Alignment score

Daily state

---

## daily_plans

Purpose

Generated execution plan for a specific day.

Contains

Planning metadata

Status

Template information

Relationships

Contains

Daily Plan Blocks

---

## daily_plan_blocks

Purpose

Runtime schedule for a day's execution.

Generated from

Day Blocks

Contains

Area

Start time

End time

Execution status

---

# Relationship Overview

```text
User
│
├── Profile
├── Areas
│      │
│      ├── Projects
│      │      │
│      │      ├── Tasks
│      │      ├── Habits
│      │      ├── Routines
│      │      └── Templates
│      │
│      ├── Habits
│      ├── Tasks
│      └── Routines
│
├── Day Blocks
│      │
│      └── Block Items
│
├── Daily Plans
│      │
│      └── Daily Plan Blocks
│
└── Daily Status
```

---

# Design Principles

Every user-owned table contains user_id.

Foreign keys maintain relational integrity.

Soft state should be represented with status fields.

Generated data should reference its originating template whenever possible.

Historical logs should never overwrite source records.

---

# Current Database Status

## Implemented

- Authentication
- Profiles
- Areas
- Projects
- Tasks
- Habits
- Habit Logs
- Routines
- Routine Steps
- Routine Step Logs
- Templates
- Day Blocks
- Block Items
- Daily Plans
- Daily Plan Blocks
- Daily Status

---

# Future Database Goals

- Strengthen Row Level Security across every table.
- Replace global UNIQUE constraints with composite uniqueness where appropriate (for example, `(user_id, name)`).
- Add indexes for high-frequency queries.
- Document all RLS policies.
- Add migration history.
- Add database functions and triggers where appropriate.
