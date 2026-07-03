# CompleteOS+ Engineering Rules

These rules apply to every implementation.

---

# Philosophy

CompleteOS+ is a systems application.

Every feature must fit into the existing architecture.

The architecture is more important than individual screens.

---

# General Rules

Never redesign existing systems unless requested.

Always inspect existing code before creating new code.

Reuse existing components whenever possible.

Avoid duplicate logic.

Keep business logic centralized.

Prefer maintainability over cleverness.

---

# FlutterFlow Rules

FlutterFlow is the source of truth.

Do not introduce changes that conflict with FlutterFlow.

Prefer FlutterFlow actions over custom code.

Only use custom code when FlutterFlow cannot accomplish the task.

---

# Database Rules

Every user-owned table must contain user_id.

Always respect Row Level Security.

Never expose another user's data.

Maintain relational integrity.

---

# UI Rules

Maintain visual consistency.

Reuse components.

Avoid duplicated widgets.

Keep layouts responsive.

Desktop and mobile should share architecture whenever practical.

---

# Architecture Rules

Repository is the central data layer.

EditorHost manages all editing.

Navigation controls application movement.

Controllers coordinate behavior.

Views display information.

Business logic should not live inside UI widgets.

---

# Engineering Process

Before making changes:

1. Read the relevant files.
2. Understand the existing implementation.
3. Explain the current behavior.
4. Identify the smallest required change.
5. Implement.
6. Verify.
7. Test.

---

# Response Expectations

When asked to implement something:

Always explain:

- Existing implementation
- Required changes
- Files affected
- FlutterFlow changes
- Supabase changes
- Testing steps

Do not redesign unless specifically requested.

When uncertain, ask before changing architecture.
