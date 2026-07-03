# BUILD_RULES.md

# CompleteOS+ Engineering Rules

## Purpose

This document defines the engineering rules that govern every implementation within CompleteOS+.

These rules exist to preserve architectural consistency, maintainability, and long-term scalability.

All contributors—including AI engineers—must follow these rules.

---

# Core Philosophy

CompleteOS+ is a systems application.

The architecture is more important than individual features.

Every implementation should strengthen the platform rather than simply add functionality.

When multiple solutions exist, prefer the one that preserves consistency and simplicity.

---

# Engineering Principles

## Preserve The Architecture

Never redesign existing systems unless explicitly requested.

Extend existing systems whenever possible.

Respect the responsibilities defined in:

- SYSTEM_PRINCIPLES.md
- ARCHITECTURE.md
- DOMAIN_ARCHITECTURE.md

---

## Inspect Before Implementing

Before writing code:

1. Read the relevant documentation.
2. Search the existing implementation.
3. Understand the current behavior.
4. Reuse existing architecture whenever possible.

Never assume.

Always verify.

---

## Build Small

Large systems should be built through small, complete increments.

Finish one workflow before beginning another.

Avoid partially implementing multiple systems simultaneously.

Preferred workflow:

```
Analysis

↓

Plan

↓

Implement

↓

Test

↓

Review

↓

Merge
```

---

# FlutterFlow Rules

FlutterFlow is the source of truth.

Always prefer FlutterFlow-native solutions.

Only recommend Custom Code when FlutterFlow cannot reasonably accomplish the requirement.

Avoid modifying generated Flutter code.

If generated code must be modified:

- explain why
- minimize changes
- document the modification

---

# Database Rules

Every user-owned record must belong to an authenticated user.

Every user-owned table should contain:

```
user_id
```

and reference:

```
auth.users.id
```

Always:

- preserve foreign keys
- preserve relational integrity
- preserve data consistency
- respect Row Level Security

Never expose another user's data.

---

# Repository Rules

The Repository is the application's unified data access layer.

Business systems should communicate through the Repository.

Avoid bypassing the Repository whenever practical.

Business logic should not directly communicate with Supabase.

---

# Controller Rules

Controllers coordinate application behavior.

Controllers may own:

- orchestration
- validation
- state transitions
- save flows
- delete flows
- lifecycle

Controllers should not own UI.

---

# Component Rules

Components own presentation.

Components may:

- display information
- collect input
- emit events

Components should remain reusable.

Avoid placing significant business logic inside components.

---

# UI Rules

Maintain visual consistency.

Reuse existing components.

Avoid duplicate layouts.

Prefer composition over duplication.

Desktop and mobile should share the same architecture whenever practical.

---

# Documentation Rules

Document:

- architecture
- systems
- business rules
- reasoning
- decisions

Avoid documenting:

- individual widgets
- rows
- containers
- icons
- visual implementation details

Documentation should explain **why**, not every visual detail.

---

# Code Quality Rules

Prefer:

- readability
- maintainability
- simplicity

Avoid:

- premature optimization
- unnecessary abstractions
- duplicated logic
- clever implementations

Future developers should immediately understand the code.

---

# Testing Rules

Every completed system should be tested.

Testing should verify:

- expected behavior
- edge cases
- user ownership
- multi-user isolation
- error handling

Major systems should not be considered complete until tested.

---

# Change Process

Before implementing a change:

1. Explain the existing implementation.
2. Identify the problem.
3. Explain the proposed solution.
4. List affected files.
5. List FlutterFlow changes.
6. List Supabase changes.
7. Explain testing steps.
8. Wait for approval if the change alters architecture.

---

# Communication Expectations

Implementation responses should include:

## Current State

Explain how the system currently works.

## Problem

Identify the issue.

## Recommendation

Explain the proposed solution.

## Impact

Explain:

- affected files
- affected systems
- FlutterFlow changes
- database changes

## Testing

Describe how the implementation should be verified.

---

# Engineering Priorities

When tradeoffs exist, prioritize in this order:

1. Correctness
2. Simplicity
3. Maintainability
4. Reusability
5. Performance
6. Convenience

Never sacrifice architecture for speed.

---

# Definition of Complete

A feature is complete when:

- Requirements are satisfied.
- Architecture is preserved.
- Existing systems are reused.
- FlutterFlow remains compatible.
- Database integrity is maintained.
- Multi-user behavior is correct.
- Tests have been performed.
- Documentation is updated if architecture changed.

---

# Final Rule

Every implementation should leave CompleteOS+ better than it was before.

The objective is not simply to add features.

The objective is to build a reliable operating system that can continue evolving for many years without accumulating unnecessary complexity or technical debt.
