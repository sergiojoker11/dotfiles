# Code style

- Prefer deterministic, functional, and immutable code.
- Avoid mutation; prefer returning new values over modifying existing ones.
- Pure functions over functions with side effects. Side effects belong at the edges (use cases, handlers), not in domain logic or validators.
- Validators are pure: they only return errors, never log or mutate state.
- Avoid comments in code. A comment is usually a sign that the code can be made clearer through better naming or extraction into a well-named function. Replace comments with encapsulation.
  The only acceptable exceptions are code whose complexity is inherent and cannot be reduced — e.g. a performance-critical hot path or a non-trivial mathematical formula. In all other cases, prefer readable code over explained code.

## Conflicts and trade-offs

When a proposed change conflicts with existing code or introduces a naming collision, flag it explicitly and present the options — do not silently pick one side.

## Languages

- TypeScript: @typescript-style.md
