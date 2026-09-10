---
name: gitsquash
description: Use this skill to squash all commits on the current branch into a single commit on top of the base branch
---

Squash all commits on the current branch into a single commit.

## Resolving the base

**Never use the local `main`.** It is frequently stale, and resetting onto it silently swallows
upstream commits authored by other people into the squashed commit.

Resolve the base once, and reuse that value in every later step:

```sh
git fetch origin --quiet
DEFAULT=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)
BASE=$(git merge-base HEAD "$DEFAULT")
```

Use the **merge-base**, not the remote tip. If the remote has moved ahead since the branch was
created, resetting onto its tip produces a commit whose tree lacks those newer upstream changes —
which reverts them.

## Steps

1. Stop if `git status --porcelain` prints anything. `git reset --soft` leaves staged changes in the
   index, so uncommitted work would be absorbed into the squashed commit. Ask the user to commit or
   stash first.
2. `git log --oneline "$BASE"..HEAD` — show the user which commits will be squashed.
3. Use `$ARGUMENTS` as the commit message when provided. Otherwise ask the user for one. If the
   branch has an open MR/PR, its title is normally the right message, since the branch is squashed
   on merge and that title is the canonical record.
4. Record the current tip, then squash:
   ```sh
   OLD=$(git rev-parse HEAD)
   git reset --soft "$BASE"
   git commit -m "<message>"
   ```
5. Verify nothing was lost: `git diff "$OLD" HEAD --stat` must print nothing. If it prints anything,
   stop and report it — the squash changed the tree, which it must never do.
6. `git log --oneline "$BASE"..HEAD` — confirm a single commit.

## After squashing

If the branch was already pushed, the remote now diverges and only a force-push will update it.
Do not push unless the user asks for it. When they do, use `git push --force-with-lease`, never
plain `--force`, so a concurrent push by someone else is rejected instead of overwritten.
