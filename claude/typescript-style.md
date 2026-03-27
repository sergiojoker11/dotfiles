# TypeScript style

The [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) is the baseline for all TypeScript code. The rules below override or extend it. Where a rule here conflicts with Google's guide, this file takes precedence.

## Overrides to Google's guide

### Types over interfaces

Use `type` instead of `interface`. Interfaces can be re-declared and extended from outside the module; types cannot — they are closed by construction.

### No classes for domain logic

Do not use classes for domain logic. Export individual pure functions. The only acceptable use of classes is for Error subtypes with a `_tag` discriminator:

```ts
class ParseError extends Error {
  readonly _tag = 'ParseError'
}
```

### Immutability is universal

Mark all fields `readonly` by default. Prefer returning new values over mutating existing ones. No `.push()`, `.splice()`, or direct property assignment on data structures.

### No enums

Do not use enums. Prefer `as const` objects or discriminated union literals:

```ts
const Direction = { Up: 'Up', Down: 'Down' } as const
type Direction = typeof Direction[keyof typeof Direction]
```

### Error handling without throw

Do not `throw` in domain logic. Return an explicit result type:

```ts
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E }
```

`try/catch` belongs only at the edges (handlers, adapters, use cases).

## Extensions

Rules not covered by Google's guide.

### Branded types

Use branded types for primitives with distinct semantics to prevent accidental mixing:

```ts
declare const brand: unique symbol
type Brand<T, B extends string> = T & { [brand]: B }
type UserId = Brand<string, 'UserId'>
```

### Discriminated unions

Use a literal `_tag` field for discriminated unions to enable exhaustive pattern matching.

### Generator functions

Use generator functions (`function*`) for lazy iteration over potentially large sequences. Avoid materialising full arrays when only one item is needed at a time.

### Runtime validation

Use Zod (or equivalent) for all external data: API responses, env vars, user input. Keep schema and type separate — the schema validates, the type describes.

### Module organisation

- Barrel exports (`index.ts`) expose the public API; internals are not re-exported.
- Explicit `.js` extensions in ESM imports.
- Organise by concern: `types.ts`, `utils.ts`, `[feature].ts`.

## Sources

- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
- [Matt Pocock — total-typescript-monorepo](https://github.com/mattpocock/total-typescript-monorepo)
