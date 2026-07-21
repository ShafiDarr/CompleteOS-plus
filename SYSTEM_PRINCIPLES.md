# SYSTEM_PRINCIPLES.md

# CompleteOS+ System Principles

## Purpose

This document defines the engineering principles that guide every architectural, design, and implementation decision within CompleteOS+.

When multiple valid solutions exist, these principles take precedence.

These principles are intended to keep the platform consistent as it grows.

---

# P001 — Build Systems, Not Features

CompleteOS+ is built from systems.

Features exist as capabilities within systems.

Avoid creating isolated functionality.

Design reusable systems that can evolve over time.

---

# P002 — One Responsibility Per System

Every system owns one responsibility.

Examples:

- Repository owns data access.
- EditorHost owns editing.
- Navigation owns navigation.
- Execution owns execution.
- Authentication owns identity.

Responsibilities should never overlap.

---

# P003 — Separation of Concerns

Separate:

- Business Logic
- Presentation
- Persistence
- Navigation
- State

Each layer should have a clearly defined responsibility.

Avoid mixing responsibilities within the same component.

---

# P004 — Controllers Coordinate Behavior

Controllers manage application behavior.

Controllers may coordinate:

- validation
- orchestration
- save flows
- delete flows
- lifecycle
- business rules
- state transitions

Controllers should never exist simply to display UI.

Examples:

- EditorHost
- Systems Control Panel

---

# P005 — Components Own Presentation

Components display information.

Components collect user input.

Components should contain minimal business logic.

Components should remain reusable.

---

# P006 — Repository Is The Data Access Layer

The Repository provides a unified interface for accessing application data.

Responsibilities include:

- querying
- creating
- updating
- deleting
- synchronizing

Business systems should communicate through the Repository rather than directly with Supabase.

---

# P007 — One Source of Truth

Every important piece of information should exist in exactly one authoritative location.

Avoid:

- duplicated data
- duplicated state
- duplicated business logic

If two systems contain the same information, the architecture should be reconsidered.

---

# P008 — Reuse Before Rebuild

Before creating something new:

1. Search the existing implementation.
2. Determine whether it already exists.
3. Extend existing systems whenever practical.

Consistency is more valuable than novelty.

---

# P009 — Tasks Are The Universal Execution Object

Tasks are the fundamental execution object within CompleteOS+.

Whenever possible:

- Bills
- Appointments
- Habits
- Routines
- Reminders
- Activities

should begin as specialized task types rather than completely separate systems.

Separate entities should exist only when their behavior fundamentally differs from Tasks.

---

# P010 — Execution Over Organization

Organization exists to support execution.

CompleteOS+ should never become a database of forgotten information.

Every feature should increase the user's ability to execute meaningful work.

---

# P011 — Data Drives The Interface

The interface should react to application state.

Avoid manually synchronizing the UI whenever it can be derived directly from the underlying data.

The UI should always reflect reality.

---

# P012 — Progressive Disclosure

Do not overwhelm users.

Display only the information required for the current decision.

Reveal additional complexity only when necessary.

Simple interactions should remain simple.

---

# P013 — Apple-Level User Experience

Every interaction should feel:

- obvious
- intentional
- calm
- responsive
- polished

Reduce cognitive load.

Reduce unnecessary decisions.

Reduce visual clutter.

---

# P014 — Components Before Duplication

Whenever similar interfaces exist:

Create reusable components.

Avoid copying layouts across pages.

Maintain visual consistency throughout the application.

---

# P015 — FlutterFlow Is The Source of Truth

FlutterFlow is the authoritative application project.

Generated Flutter code supports deployment.

Avoid modifying generated Flutter code unless absolutely necessary.

Prefer FlutterFlow-native implementations whenever possible.

---

# P016 — Maintainability Is A Feature

Readable architecture is more valuable than clever implementation.

Future development should become easier with every feature that is added.

Technical debt should be reduced rather than accumulated.

---

# P017 — Build Incrementally

Large systems should be delivered in small, complete increments.

Finish one end-to-end workflow before beginning another.

Avoid partially implementing multiple systems simultaneously.

Examples:

✔ Tasks CRUD

↓

✔ Current Action

↓

✔ Execution Dashboard

↓

✔ Daily Planning

Not:

Tasks 40%

Projects 30%

Habits 25%

Routines 15%

---

# P018 — Long-Term Thinking

Every implementation should improve the platform's ability to evolve.

Choose solutions that remain understandable six months from now.

Avoid shortcuts that create unnecessary architectural debt.

---

# P019 — Foundations Before Polish

Do not prioritize UI polish, visual improvements, or minor features while core systems remain incomplete.

Finish the foundation first.

---

# P020 — Minimize Future Rework

When multiple valid next steps exist, prefer the one that reduces future rework and strengthens the foundation.

Do not choose the fastest or smallest option in isolation if it creates rework later.

---

# P021 — Ask Before Assuming

Do not assume the codebase reflects every architectural decision.

When the code and the architecture diverge, ask for clarification rather than guessing.

Confirm scope before recommending a build order when a decision's implementation is ambiguous.

---

# P022 — Prefer Generic Solutions Over Type-Specific Ones

Whenever possible, design systems to be generic rather than type-specific.

If a capability can be implemented once in the Universal Task Model instead of separately for Tasks, Habits, Routines, Bills, Appointments, and Events, prefer the generic solution.

Avoid duplicating logic across task types unless there is a compelling reason that the behavior truly differs.

---

# P023 — Defer Non-Blocking Technical Debt

When architectural violations or technical debt are discovered during implementation, do not immediately recommend refactoring.

1. Determine whether the issue blocks the current objective.
2. If it does not block the objective, record it as future technical debt and continue with the current objective.
3. Only recommend immediate refactoring when leaving the issue in place would cause significant future rework, incorrect architecture, or data integrity problems.

Favor shipping V1 over achieving architectural perfection.

---

# Engineering Decision Framework

Before implementing any change, ask:

1. Does this belong to an existing system?

2. Does it duplicate an existing responsibility?

3. Can an existing component be reused?

4. Does it improve execution?

5. Does it reduce complexity?

6. Does it strengthen the architecture?

7. Will future development become easier?

If the answer to any of these questions is "No," reconsider the implementation before writing code.

---

# Final Principle

CompleteOS+ is not being built as another productivity application.

It is being built as a long-term operating system for execution.

Every engineering decision should move the platform closer to becoming the single trusted system that helps people and organizations consistently know what matters, what should happen next, and how to execute it.
