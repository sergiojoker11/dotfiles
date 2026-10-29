# Code style

- Prefer deterministic, functional, and immutable code.
- Avoid mutation; prefer returning new values over modifying existing ones.
- Pure functions over functions with side effects. Side effects belong at the edges (use cases, handlers), not in domain logic or validators.
- Validators are pure: they only return errors, never log or mutate state.
- Avoid comments in code. A comment is usually a sign that the code can be made clearer through better naming or extraction into a well-named function. Replace comments with encapsulation.
  The only acceptable exceptions are code whose complexity is inherent and cannot be reduced — e.g. a performance-critical hot path or a non-trivial mathematical formula. In all other cases, prefer readable code over explained code.
- Never reference merge requests, pull requests or tickets in code comments. The git history already links code to the change that introduced it.

## Conflicts and trade-offs

When a proposed change conflicts with existing code or introduces a naming collision, flag it explicitly and present the options — do not silently pick one side.

## Consistency over style guide

File-level consistency takes precedence over style guide rules. If a file follows a consistent pattern — even one that differs from the style guide — new code in that file must follow the same pattern. Introducing a style-guide-compliant inconsistency is worse than continuing an established pattern.

If the file itself is already inconsistent, evaluate case by case whether to align with the majority pattern or flag it for a dedicated cleanup. Never mix styles within a single change.

In any controversial case — where following the style guide would introduce inconsistency, or where two valid conventions conflict — always surface the trade-off explicitly and let the user decide. Do not silently pick one side.

## Languages

- TypeScript: @typescript-style.md

## Reuse a shared type before inventing one

Before adding a type to a shared contract (an exception, an error code, a union member), check whether an
existing standard type already carries that meaning, and reuse it even when the ticket asks for a new
one. The question is not "are these two cases different?" but "does the client have to act differently,
and is there already a type that says so?". A duplicate costs a union member every client must learn and
a registry code, and buys nothing. Propose the smaller surface and flag that the ticket needs amending.

## Variants are data

When behaviour varies by environment, provider or tenant, write one generic function that takes the
varying values as parameters, one thin wrapper per variant that supplies only those values, and a
dispatcher on top. Never write a single function with a `case` that assigns every variant's values inline
and then falls through to shared logic. This applies to shell, TypeScript and config builders alike;
propose the split by default.

## Derived constants are relative to their base

Write `BASE_TIMEOUT + 5`, not `65`. The literal silently diverges when the base changes. If the syntax
forbids cross-references (enum members, for example), extract an intermediate constant that both use.

## Annotations sit next to what they describe

A log field or metadata that describes a specific value sits right next to that literal and reads it from
the same object (`assignedStatus: agent.status` right after the line that sets it), so changing the
literal cannot leave a stale annotation behind.

## Do not restyle code outside the change

Do not convert existing code to match a style preference (enums to `as const`, classes to functions) when
that code is not the target of the change. New code follows the style guide; untouched code stays as it
is. If a preference would require touching out-of-scope code, flag it and present the options.
