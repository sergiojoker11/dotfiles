# Merge request review

Before creating a merge request, run a check against me — a safety net in case I tagged the
change on autopilot and got it wrong. The MR is the checkpoint, not the individual commit:
branches get squashed, so the MR title / final commit is the canonical record. No check at
commit time; commit freely.

This applies however the MR is created — by hand or via tooling (e.g. the `create-mr` skill).

The specs are the source of truth — do not restate them here, read and apply them:

- Conventional Commits — the commit type and title format: https://www.conventionalcommits.org
- Semantic Versioning — what counts as a breaking change: https://semver.org

## The check

1. **Type** — does the chosen Conventional Commits type match what the diff actually does?
   Flag any mismatch before creating the MR.

2. **Breaking change** — per SemVer, is this a breaking change that is *not* marked
   (`type!:` / `BREAKING CHANGE:`)? If so, warn me prominently with the reason, then continue.

3. **Critical analysis** — Problem → Solution (high-level) → Context & trade-offs, per
   [tickets.md](tickets.md). Not a restatement of the diff: what it solves, why this approach
   over the alternatives, and what risks remain.

## Keep the MR description in sync

The MR description is the canonical record, so it must keep tracking reality. After a change that
materially alters the **problem or the solution** of an open MR (new approach, dropped/added
component, changed trade-off, a design decision that resulted from review), bring the description
back in sync — don't let it go stale.

- **If the update is unambiguous** — it's clear what changed and how to phrase it — just do it,
  don't ask.
- **If it's unclear** what to write (or whether it's even worth it), ask me a single, specific
  yes/no question, e.g. *"¿Quieres que actualice la MR description para indicar que es X o Y?"* —
  don't rewrite on a guess.

Trivial changes (lint fixes, test tweaks, comment wording, a flaky-test retry) don't warrant a
description update. This is about problem/solution drift, not every commit.
