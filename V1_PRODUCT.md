# V1_PRODUCT.md

## Purpose

This document is the canonical definition of CompleteOS+ V1 — what it is, who it is for, and what it must do. It exists so every future implementation decision can be evaluated against a single, stable definition instead of being re-derived from conversation each time.

This document defines **product scope**, not implementation. For how the system is built, see ARCHITECTURE.md. For what data objects exist and how they relate, see DOMAIN_ARCHITECTURE.md and DATABASE.md. For current build status, see PROJECT_STATUS.md and V1_CHECKLIST.md.

Where this document conflicts with VISION.md, ROADMAP.md, DOMAIN_ARCHITECTURE.md, DATABASE.md, or any other existing document, **this document is authoritative for V1 scope** until those documents are updated to match.

---

## V1 Mission

CompleteOS+ V1 is being built for its owner personally, first. It is not yet the public or business version of CompleteOS+ described in VISION.md's long-term ambition.

V1 succeeds when its owner can rely on it every day to:

1. Capture everything.
2. Organize it.
3. Plan today.
4. Execute the next action.
5. Review the day.
6. Repeat.

Every implementation decision in V1 should be evaluated against one question: **does this materially improve one of those six steps, for daily personal use, right now?** If not, it belongs in V2+.

---

## V1 Commitment Types

A **Commitment Type** is a category of real-world commitment that must be captured, organized, planned, executed, and reviewed as part of daily life.

CompleteOS+ V1 manages seven Commitment Types:

- **Task** — a piece of actionable work with no fixed occurrence pattern.
- **Habit** — a repeated behavior tracked for consistency rather than one-time completion.
- **Routine** — a reusable, ordered sequence of steps performed together.
- **Bill** — a recurring or one-time payment obligation.
- **Appointment** — a scheduled meeting or commitment at a specific time, often at a specific place.
- **Event** — a scheduled occurrence similar to an Appointment.
- **Reminder** — a commitment whose primary purpose is to be surfaced at the right time, rather than executed as work.

**These are commitment types, not milestones.** They are not phases of work and not a list to build one at a time. All seven are implemented as `task_type` values within the Universal Task Model (see DATABASE.md) — they are the same underlying object, differentiated by type, not seven separate systems (see SYSTEM_PRINCIPLES.md P009 and P022).

Every Commitment Type moves through the same five-stage lifecycle below. None of the seven is more or less "V1" than another — a feature that serves only Tasks while leaving Bills, Appointments, Events, Reminders, Habits, or Routines behind is incomplete, not done.

---

## The V1 Lifecycle

CompleteOS+ V1's entire operating loop is five stages, applied uniformly to every Commitment Type above.

### Milestone 1 — Capture

**Goal:** Never lose anything, regardless of commitment type.

Every Commitment Type must be quickly and reliably capturable — its defining fields (a Bill's amount and payee, an Appointment's time and location, a Habit's frequency, and so on) must exist and work at creation time, not just the fields common to a generic Task.

**Success criterion:** The owner can get every thought, responsibility, idea, commitment, and task out of their head and into CompleteOS+, regardless of what type of commitment it is.

### Milestone 2 — Organize

**Goal:** Everything has a home, regardless of commitment type.

**Success criterion:** The owner can quickly understand where any commitment belongs and find it again in seconds — whether it's a Task, Habit, Routine, Bill, Appointment, Event, or Reminder.

### Milestone 3 — Plan Today

**Goal:** Decide today's commitments, regardless of type.

**Success criterion:** Every morning, the owner knows exactly what today looks like and what they intend to complete — across every commitment type due or scheduled that day, not just Tasks.

### Milestone 4 — Execute

**Goal:** Stay in execution mode, regardless of commitment type.

Executing a commitment means something different per type — completing a Task, paying a Bill, attending an Appointment or Event, following a Routine's steps, completing a Habit's check-in, acting on a Reminder — but moving through the day should feel the same regardless of which type is currently in front of the owner.

**Success criterion:** The owner spends the day doing the work instead of repeatedly deciding what to do, for every commitment type.

### Milestone 5 — Review

**Goal:** Learn, reset, and prepare, regardless of commitment type.

**Success criterion:** Every night, the owner understands what happened across every commitment type — completed, missed, paid, attended, maintained — what needs adjustment, and tomorrow is prepared.

---

## What Is Explicitly Not a V1 Commitment Type

Some domain concepts described elsewhere in the documentation are not Commitment Types and are not required for V1, for reasons distinct from simply "not listed":

- **Goal** (DOMAIN_ARCHITECTURE.md) is a direction-setting outcome, not something captured/organized/planned/executed/reviewed day to day the way a commitment is. It is a longer-term planning concept, not a V1 requirement.
- **Automation** as a general-purpose, user-configurable workflow/rule-building system (DOMAIN_ARCHITECTURE.md, ROADMAP.md's Future Roadmap) is not required for V1. A minimal, built-in mechanism for generating the next occurrence of a repeating commitment (a Habit, Routine, or recurring Bill) is a different, smaller thing that may be required to make "Repeat" work at all — see Open Questions below.

This is a judgment distinction, not a final ruling. If either belongs in V1 after all, it should be added here explicitly, not inferred from silence — the same mistake this document exists to prevent.

---

## Open Questions (Not Yet Decided)

The following are intentionally left undecided rather than assumed:

- What should `reminder_level` and `acknowledged_at` actually do for the Reminder commitment type in daily personal use?
- Is `requires_verification` / `verification_status` a personal completion-honesty feature, or vestigial multi-person-accountability scope that doesn't belong in V1 at all?
- Does V1 need the fully configurable Recurring Templates engine (multiple schedule types, week patterns, day-of-month rules), or does a simple frequency-based repeat on Habit/Routine/Bill satisfy "Repeat" for V1?
- Whether a minimal recurring-instance-generation mechanism (see "Automation" above) is itself V1-required infrastructure, or part of the Recurring Templates question above.

These should be resolved by the Product Architect before the corresponding implementation work begins, not assumed by whoever implements it.

---

## Relationship to Other Documents

- **VISION.md** describes the long-term, unbounded ambition (individuals through enterprises). It is not scoped to V1 and should not be used to justify V1 feature decisions.
- **ROADMAP.md** sequences work and tracks milestone status; it references this document's Commitment Types and Lifecycle rather than redefining them.
- **DOMAIN_ARCHITECTURE.md** and **DATABASE.md** define how Commitment Types map onto domain objects and schema (the Universal Task Model, `task_type` values).
- **DOMAIN_MODEL.md** is the frozen, live-verified implementation of this document's scope decisions — the canonical entity/field/state definitions, including which of DOMAIN_ARCHITECTURE.md's long-term concepts are actually in V1.
- **ARCHITECTURE.md** defines the Start/End/Deadline scheduling model and block-first/calendar-first architecture that apply across every Commitment Type.
- **MIGRATION_PLAN.md** sequences the work to close the gap between this scope and the live database/app code, and identifies which changes need Product Architect approval before implementation.
- **PROJECT_STATUS.md** and **V1_CHECKLIST.md** track actual implementation progress against this definition.
