# ARCHITECTURE.md

# CompleteOS+ Software Architecture

## Purpose

This document defines the software architecture of CompleteOS+.

It describes how the application is organized, how systems interact, where responsibilities belong, and how data flows throughout the platform.

This document is the authoritative source for **how CompleteOS+ is built**.

It complements:

- VISION.md (Why the platform exists)
- V1_PRODUCT.md (What V1 specifically must do, for whom, and by when)
- SYSTEM_PRINCIPLES.md (How engineering decisions are made)
- DOMAIN_ARCHITECTURE.md (What the platform manages)
- DATABASE.md (How domain data is stored)

---

# Architectural Philosophy

CompleteOS+ is a systems-driven application.

The platform is composed of independent systems with clearly defined responsibilities.

Each system owns a single responsibility and collaborates through well-defined boundaries.

The architecture prioritizes:

- Simplicity
- Maintainability
- Reusability
- Scalability
- Testability
- FlutterFlow compatibility

---

# High-Level Architecture

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
           Application Shell
                  │
    ┌─────────────┼─────────────┐
    ▼             ▼             ▼
Execution     EditorHost   Systems Panel
    │             │             │
    └─────────────┼─────────────┘
                  ▼
             Repository
                  │
                  ▼
              Supabase
                  │
                  ▼
             PostgreSQL
```

---

# Core Systems

## Authentication

Purpose

Manages user identity.

Responsibilities

- Login
- Logout
- Registration
-

---

# Confirmed Architecture Decisions (Product Architect, 2026-07-22)

These decisions are authoritative for CompleteOS+'s architecture going forward, regardless of current implementation state. Where they conflict with other documents as currently written (DATABASE.md's `due_at`-only description, ROADMAP.md's sequencing), these decisions take precedence until those documents are updated to match.

## Universal Task Model Is The Foundation

The Universal Task Model (see DOMAIN_ARCHITECTURE.md's Task section and DATABASE.md's "Universal Task Model") is the foundation of CompleteOS+. It must be finished — all seven `task_type` values genuinely supported end to end — before other systems are expanded. Projects CRUD is treated as independent of this rule: it does not touch task scheduling and may proceed in parallel.

## Task Scheduling Model: Start/End, Not Due Date

Tasks are moving away from a single `due_at` field as the primary scheduling mechanism. The scheduling model going forward:

- **Start Date & Time** and **End Date & Time** are the primary scheduling fields, used throughout the system across task types — not limited to any single `task_type`.
- **Deadline** (the existing `due_at` column, repurposed) is an optional field, populated only when a task genuinely requires a hard deadline distinct from its start/end window. It is not removed from the schema; its role changes from "the" scheduling field to a secondary, optional one.
- Current Action prioritization orders candidate tasks by priority, then by start time (not due/deadline time).

This supersedes DATABASE.md's current description of `due_at` as the primary scheduling field for tasks generally — DATABASE.md should be updated to match once this model is implemented.

## Scheduling Is Block-First Internally, Calendar-First For The User

Scheduling is architected as block-first internally: the system runs on Day Blocks (reusable time-block templates) and Daily Plans (a specific day's generated/instantiated blocks), per DATABASE.md's existing `day_blocks`/`daily_plans`/`daily_plan_blocks`/`block_items` tables. The user-facing experience should feel like a calendar — users visually build days, weeks, and months — while the underlying system continues to operate on Day Blocks and Daily Plans beneath that view.
