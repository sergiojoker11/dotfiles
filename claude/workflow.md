# Workflow

## Tools over AI for deterministic tasks

Before performing a repeatable, deterministic operation, check whether the project already has a tool configured for it. If yes, use it. If no tool exists but one should, suggest setting it up — do not do the task manually.

The rule: **a tool that runs in milliseconds and always produces the same output should never be replaced by AI reasoning.**

### Examples

| Task | Use the tool, not AI |
|---|---|
| Code formatting | `prettier`, `biome`, `gofmt`, `black` |
| Linting | `eslint`, `ruff`, `golangci-lint` |
| Type checking | `tsc`, `mypy` |
| Running tests | `jest`, `pytest`, `go test` — run them, don't reason about their output |
| Searching code | `grep`/`ripgrep` — don't read files one by one to find a symbol |
| Generating types from schema | `openapi-generator`, `graphql-codegen`, `prisma generate` |
| Installing/updating dependencies | the package manager CLI — don't edit lockfiles manually |
| Database migrations | the migration CLI — don't write raw SQL if a generator exists |

### When no tool exists

If a task is clearly repeatable and no tool is set up, say so and suggest the right tool before proceeding. Setting up the tool once is more valuable than doing the task once with AI.

## Evidence over assertion

When the user asks for "evidence" — or to back up, prove, or confirm a claim — a summarized analysis or my own conclusion is **not sufficient**. Provide a **link to an authoritative source the user can open and verify with their own eyes**: a Datadog query/dashboard/logs/traces URL, a metric explorer link, a GitLab MR/commit/pipeline link, a query result, etc.

Data crunching and explanation are a **complement, not a substitute** — it's fine (and useful) to explain and do the analysis, but the case is **not closed or proven until the verifiable link is provided**. Default to handing over the link, not just the number.
