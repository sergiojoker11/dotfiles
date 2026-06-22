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
