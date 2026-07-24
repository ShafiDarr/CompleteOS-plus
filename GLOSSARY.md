# GLOSSARY.md

# CompleteOS+ Glossary

This is a short, alphabetical quick-reference index. **DOMAIN_MODEL.md is the canonical, detailed, live-verified source for domain language** — fields, states, V1 scope, and relationships. Entries below give the one-line meaning; consult DOMAIN_MODEL.md for the authoritative definition of any entity that also appears there.

All documentation, database tables, UI, and code should use these definitions consistently.

---

## Workspace

The highest-level operating environment.

A Workspace owns Areas, users, configuration, and permissions.

Examples:

- Personal
- Family
- Business
- Enterprise

---

## Area

A permanent responsibility domain.

Examples:

- Health
- Finance
- Family
- Operations

Areas organize work.

---

## Goal

A desired outcome.

Goals define direction.

Goals do not execute work.

---

## Project

A structured initiative composed of related work.

Projects organize Tasks.

---

## Task

The universal execution object.

Tasks represent actionable work.

Whenever possible, work should begin as a Task.

---

## Commitment Type

A category of real-world commitment CompleteOS+ manages — Task, Habit, Routine, Bill, Appointment, Event, or Reminder in V1.

All Commitment Types are implemented as `task_type` values within the Universal Task Model, not as separate systems.

See V1_PRODUCT.md.

---

## Bill

A Commitment Type representing a payment obligation, recurring or one-time.

---

## Appointment

A Commitment Type representing a scheduled meeting or commitment at a specific time, often at a specific place.

---

## Event

A Commitment Type representing a scheduled occurrence, similar to an Appointment.

---

## Reminder

A Commitment Type whose primary purpose is to be surfaced at the right time, rather than executed as work.

---

## Habit

A repeated behavior intended to become automatic over time.

Habits measure consistency rather than completion of a one-time objective.

---

## Routine

A reusable sequence of Tasks performed in a defined order.

Examples:

- Morning Routine
- Shutdown Routine
- Weekly Review

---

## Routine Step

An individual action within a Routine.

---

## Schedule

A definition of when work should occur.

Schedules assign time.

They do not own work.

---

## Day Block

A reusable scheduling template.

Examples:

- Morning
- Work
- Recovery
- Growth

Day Blocks define the structure of a day.

---

## Block Item

A reusable item contained within a Day Block.

A Block Item may reference:

- Task
- Habit
- Routine

---

## Daily Plan

A generated execution plan for one specific day.

Daily Plans are created from reusable templates.

---

## Daily Plan Block

A runtime instance of a Day Block within a Daily Plan.

Unlike Day Blocks, Daily Plan Blocks represent today's actual schedule.

---

## Current Action

The single highest-priority piece of work the user should execute next.

Current Action is determined by the Execution Engine.

---

## Execution

The process of completing meaningful work.

Execution is the primary purpose of CompleteOS+.

---

## Repository

The application's unified data access layer.

Business systems access persisted data through the Repository.

---

## EditorHost

The centralized editing system.

EditorHost manages:

- Create
- Edit
- Save
- Delete
- Archive

for supported domain objects.

---

## Execution Dashboard

The primary operating screen.

The Execution Dashboard answers:

"What should I do right now?"

---

## Execution Engine

The collection of systems responsible for determining the user's next action.

The Execution Engine considers:

- Tasks
- Priorities
- Due dates
- Daily Plans
- Day Blocks
- Current Status

to guide execution.

---

## Inbox

A temporary holding area for uncategorized work.

Objects should be assigned to an Area when appropriate.

---

## Repository Pattern

An architectural pattern in which business systems interact with data through a centralized Repository rather than directly accessing the database.

---

## Source of Truth

The single authoritative location for a piece of information.

Every important piece of state should have exactly one Source of Truth.
