# DOMAIN_ARCHITECTURE.md

# CompleteOS+ Domain Architecture

## Purpose

This document defines the domain model of CompleteOS+.

It establishes the core business objects, ownership hierarchy, relationships, and rules that govern the platform.

This document is the authoritative source for understanding **what CompleteOS+ manages**.

Software architecture, database design, APIs, automation, AI, and user interfaces should all implement this domain model.

---

# Domain Philosophy

CompleteOS+ is an operating system for execution.

The platform exists to organize work, guide execution, automate repetitive processes, preserve knowledge, measure progress, and continuously improve the people and organizations using it.

Rather than managing isolated features, CompleteOS+ manages real-world entities and the relationships between them.

Everything inside the platform should ultimately help answer one question:

> **What should happen next?**

---

# Ownership Hierarchy

Ownership defines where an object permanently belongs.

Ownership is hierarchical.

References are flexible.

```
Workspace
    │
    └── Area
            │
            ├── Goal
            ├── Project
            ├── Task
            ├── Schedule
            ├── Automation
            ├── Document
            ├── Person
            ├── Asset
            └── Metric
```

Ownership should remain stable.

Objects should collaborate through references rather than ownership whenever possible.

---

# Workspace

## Purpose

A Workspace represents an operating environment.

A Workspace defines:

- ownership
- permissions
- configuration
- members
- Areas
- system settings

Examples

Personal

Family

Business

Enterprise

Every object within CompleteOS+ ultimately belongs to a Workspace.

---

# Area

## Purpose

Areas represent permanent responsibility domains.

Areas organize everything that belongs to a particular responsibility.

Examples

Personal

- Health
- Finance
- Family
- Growth
- Recovery

Business

- Operations
- Engineering
- Sales
- Marketing
- Human Resources

Objects should belong to an Area whenever possible.

Objects created without an Area should initially exist in an Inbox until categorized.

---

# Goal

## Purpose

Goals define desired outcomes.

Goals answer:

> Where are we trying to go?

Goals provide direction.

Goals do not own work.

Goals are achieved through Projects and Tasks.

---

# Project

## Purpose

Projects organize related work.

Projects answer:

> What initiative are we working on?

Projects contain or reference Tasks.

Projects may contribute toward one or more Goals.

Projects may span multiple schedules.

---

# Task

## Purpose

Tasks represent executable work.

Tasks answer:

> What should happen next?

Tasks are the universal execution object.

Whenever possible, actionable work should begin as a Task.

Bills

Appointments

Habits

Routines

Reminders

Activities

should extend or specialize Tasks rather than replace them unless fundamentally different behavior is required.

## Implementation Note

This is implemented directly in the database: Habits and Routines are not separate tables. They are rows in the `tasks` table, differentiated by a `task_type` column. See DATABASE.md's "Universal Task Model" section for the schema-level detail.

---

# Schedule

## Purpose

Schedules define time.

Schedules answer:

> When should work occur?

Schedules organize execution.

Schedules never own work.

---

# Automation

## Purpose

Automations perform work.

Automations answer:

> What can the system do automatically?

Automations may:

- create work
- update work
- complete work
- notify users
- synchronize systems
- execute workflows

Automations operate on domain objects.

They do not own them.

---

# Document

## Purpose

Documents preserve knowledge.

Examples

- Notes
- SOPs
- Specifications
- Policies
- Meeting Notes
- Reference Material

Documents support execution by preserving information.

---

# Person

## Purpose

People participate in work.

Examples

Personal

- Self
- Family

Business

- Employee
- Customer
- Vendor
- Contractor

People interact with work rather than owning it.

---

# Asset

## Purpose

Assets represent value.

Assets answer:

> What should become more valuable over time?

Examples

Personal

- Home
- Vehicle
- Investment
- Equipment

Business

- Machinery
- Inventory
- Software
- Intellectual Property

CompleteOS+ should continuously improve asset utilization and value.

---

# Metric

## Purpose

Metrics measure performance.

Metrics answer:

> Are we improving?

Examples

- Revenue
- Profit
- Weight
- Downtime
- Completion Rate
- Alignment Score
- Response Time

Metrics should guide decision making rather than simply reporting history.

---

# Ownership Model

Ownership determines permanence.

Examples

```
Workspace
    │
    └── Area
            │
            └── Project
                    │
                    └── Task
```

Ownership should remain stable.

Changing ownership should be uncommon.

---

# Reference Model

References create relationships without changing ownership.

Examples

```
Goal ─────────────► Project

Project ──────────► Task

Task ─────────────► Schedule

Task ─────────────► Person

Task ─────────────► Asset

Automation ───────► Task

Document ─────────► Project

Metric ───────────► Goal
```

References allow the platform to evolve without restructuring ownership.

---

# Domain Categories

To maintain consistency, every domain object belongs to one of four categories.

## Execution

Responsible for getting work done.

- Goal
- Project
- Task
- Schedule
- Automation

---

## Knowledge

Responsible for preserving information.

- Document

---

## Resources

Responsible for the people and things required to perform work.

- Person
- Asset

---

## Measurement

Responsible for evaluating progress.

- Metric

---

# Architectural Rules

The following rules apply throughout CompleteOS+.

- Every Workspace owns Areas.
- Every operational object should belong to an Area.
- Objects without an Area should remain in an Inbox until categorized.
- Ownership should remain stable.
- Objects collaborate through references.
- Goals define outcomes.
- Projects organize work.
- Tasks execute work.
- Schedules define time.
- Automations perform work.
- Documents preserve knowledge.
- Metrics measure performance.
- Assets represent value.
- People participate in work.

---

# Optimization Model

CompleteOS+ continuously optimizes:

- Organization
- Execution
- Knowledge
- Automation
- Measurement
- Improvement
- Value Creation

Every feature should strengthen one or more of these capabilities.

---

# Guiding Principle

CompleteOS+ is not a collection of productivity tools.

It is an operating system.

Its purpose is to continuously improve both the operator and the work being performed.

Every system should move users from intention to execution while increasing the long-term capability, efficiency, discipline, and value of the people, teams, organizations, and assets it manages.
