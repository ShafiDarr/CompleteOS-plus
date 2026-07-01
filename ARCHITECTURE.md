# ARCHITECTURE.md

# CompleteOS+ Architecture

## Purpose

CompleteOS+ is a systems-driven personal operating system.

The application is organized around independent systems that each have a single responsibility and work together through clearly defined boundaries.

The architecture prioritizes:

- Simplicity
- Maintainability
- Reusability
- Scalability
- FlutterFlow compatibility

---

# Architecture Overview

```
User
    │
    ▼
Authentication
    │
    ▼
Navigation
    │
    ▼
Execution Dashboard
    │
    ▼
Repository
    │
    ├── Areas
    ├── Projects
    ├── Tasks
    ├── Habits
    ├── Routines
    ├── Templates
    ├── Day Blocks
    ├── Daily Plans
    └── Settings
```

The Repository is the application's central data layer.

All systems consume data through the Repository.

---

# Core Systems

## Authentication

Responsible for:

- Login
- Logout
- Registration
- Session management
- User identity

Technology

- Supabase Auth

---

## Repository

Purpose

The Repository is the application's source of truth.

Responsibilities

- Read data
- Create records
- Update records
- Delete records
- Filter user-owned data
- Coordinate Supabase access

The Repository owns data.

No other system should own persistence.

---

## Navigation

Purpose

Controls application navigation.

Responsibilities

- Sidebar
- Mobile navigation
- Route management
- Selected page
- Navigation state

Navigation does not own business logic.

---

## Execution

Purpose

The heart of CompleteOS+.

Responsibilities

Display the user's current execution state.

Includes:

- Alerts
- Today
- Habits
- Routines
- Bills
- Appointments
- Projects
- Daily Plan

Execution consumes data from the Repository.

Execution never owns data.

---

## EditorHost

Purpose

Universal editing controller.

Responsibilities

- Create records
- Edit records
- Validate
- Save
- Delete
- Archive
- Cancel
- Reset editor state

Every editable object should use EditorHost.

---

# Domain Systems

The Repository manages these domains:

## Areas

High-level life categories.

Examples

- Health
- Finance
- Career

---

## Projects

Large outcomes.

Contain work.

---

## Tasks

Individual actionable items.

May belong to:

- Area
- Project
- Template

---

## Habits

Repeated behaviors.

Support:

- Boolean tracking
- Numeric tracking

---

## Routines

Multi-step workflows.

Contain Routine Steps.

---

## Recurring Templates

Blueprints for recurring work.

Generate:

- Tasks
- Habits
- Routines

---

## Day Blocks

Reusable schedule blocks.

Contain Block Items.

---

## Daily Plans

Generated execution schedule for a day.

Derived from Day Blocks.

---

## Daily Status

Represents today's operating state.

Includes:

- Wake state
- Sleep state
- Alignment score

---

# UI Architecture

Pages are composed primarily of reusable components.

Preferred hierarchy:

```
Page

    ↓

Section

    ↓

Component

    ↓

Widget
```

Business logic should remain outside UI widgets whenever possible.

---

# Data Flow

```
User Action

      ↓

EditorHost

      ↓

Repository

      ↓

Supabase

      ↓

Repository

      ↓

UI Refresh
```

The UI should react to Repository state rather than directly manipulating data.

---

# Technology Stack

Frontend

- FlutterFlow

Backend

- Supabase

Authentication

- Supabase Auth

Database

- PostgreSQL

Version Control

- GitHub

Development

- Claude Code

---

# Architectural Principles

- FlutterFlow is the source of truth.
- One responsibility per system.
- Repository owns data.
- EditorHost owns editing.
- Execution is the application's primary experience.
- Reuse components before creating new ones.
- Avoid duplicate business logic.
- Prefer composition over duplication.
- Every user-owned record belongs to exactly one authenticated user.

---

# V1 Scope

The architecture is currently focused on delivering a stable V1.

Future enhancements should extend existing systems rather than introducing parallel architectures.
