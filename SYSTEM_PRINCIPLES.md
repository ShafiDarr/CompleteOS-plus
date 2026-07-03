# SYSTEM_PRINCIPLES.md

# Purpose

Defines the engineering principles that guide every architectural, design, and implementation decision in CompleteOS+.

When multiple valid solutions exist, these principles take precedence.

---

# P001 — Build Systems, Not Features

Every feature must belong to a larger system.

Avoid isolated functionality.

Design systems that can grow rather than individual screens.

---

# P002 — One Responsibility Per System

Every system owns one responsibility.

Examples:

- Repository owns data.
- EditorHost owns editing.
- Navigation owns navigation.
- Execution owns daily execution.
- Authentication owns identity.

Do not duplicate responsibilities across systems.

---

# P003 — Controllers Own Logic

Controllers coordinate behavior.

Controllers manage:

- orchestration
- state changes
- save flows
- delete flows
- lifecycle
- validation
- business rules

Controllers should not render UI.

Examples:

- EditorHost
- System Control Panel

---

# P004 — Components Own UI

Components display information.

Components collect user input.

Components should not contain significant business logic.

Examples:

- Sidebar
- Area Form
- Activity Form
- Current Action

---

# P005 — One Source of Truth

Important state should exist in exactly one place.

Avoid duplicate data.

Avoid duplicate state.

Avoid duplicate business logic.

---

# P006 — Reuse Before Rebuild

Search the existing implementation before creating something new.

Prefer extending an existing system over creating another.

Consistency is more valuable than novelty.

---

# P007 — Tasks Are The Universal Action Object

Tasks are the application's fundamental execution object.

Bills

Appointments

Habits

Routines

Reminders

Activities

should all begin as specialized task types unless there is a strong architectural reason to separate them.

---

# P008 — Execution Over Organization

CompleteOS+ exists to improve execution.

Organization only exists to support execution.

Every feature should help the user complete meaningful work.

---

# P009 — Apple-Level UX

The interface should feel:

- calm
- intentional
- clean
- obvious

Reduce cognitive load.

Avoid unnecessary options.

---

# P010 — Document Decisions, Not Widgets

Document architecture.

Document systems.

Document reasoning.

Do not waste time documenting individual containers, rows, icons, or layout widgets.

---

# P011 — Data Drives The Interface

The UI should reflect application state.

Avoid manually synchronizing UI whenever data can determine the presentation automatically.

---

# P012 — FlutterFlow Is The Source Of Truth

FlutterFlow owns the application.

Generated Flutter code supports deployment.

Avoid modifying generated code unless absolutely necessary.

---

# P013 — Increase Value

Every system should increase the long-term value of the entity it manages.

Whether the entity is:

- a person
- a project
- a business
- an asset
- a team

CompleteOS+ should continuously make it more organized, more capable, and more effective.

---

# Engineering Decision Framework

Before implementing anything, ask:

Does it belong to an existing system?

Does it duplicate responsibility?

Can an existing component be reused?

Does it improve execution?

Does it reduce complexity?

Does it follow the architecture?

If not, redesign the implementation before writing code.
