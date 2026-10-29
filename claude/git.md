# Git conventions

## Commit messages

Never add a `Co-Authored-By:` trailer (or any Claude authorship line) to commit messages.

## Force-pushing: pin the expected SHA

Bare `--force-with-lease` compares against the **local remote-tracking ref**, not against the remote.
Any `git fetch` beforehand updates that ref to whatever someone else pushed, so the lease silently
approves overwriting their work. Fetching to "check the remote is current" is exactly what disarms it.

Read the real tip without touching the tracking refs, then pin it:

```sh
REMOTE=$(git ls-remote origin <branch> | cut -f1)   # ls-remote does not update refs/remotes
git push --force-with-lease=<branch>:$REMOTE origin <branch>
```

If the branch moved since that read, the push fails instead of overwriting. The bare form is only
safe when nobody else can push, which is not a thing to assume on a shared branch with an open MR.

## Rebase and reset against the remote base, not the local one

`git rebase main`, `git reset --soft main` and friends use the **local** `main`, which goes stale the
moment it is not pulled. Use `origin/main`.

Checking that local `main` is the branch's merge-base is **not** enough: it stays true even when the
branch has since been rebased onto a newer base by someone else, and resetting onto the stale local
ref then silently undoes their rebase.

Before any history rewrite on a shared branch, compare the local base with `origin/<base>` and the
local branch with its remote counterpart, and say what each one is.

## Commits and pushes are mine

Do not commit or push unless I ask. After making changes, show what changed and stop.

- **Approval covers one change, not the next round.** A go-ahead for "branch, commit and MR" authorises
  that commit. Every later amend or force-push on the same branch needs its own go-ahead; default to
  showing `git diff` and stopping.
- **An explicit "create the MR" on uncommitted work covers the commit and push it needs.** Do it; do not
  hand the git commands back to me.
- Before force-pushing onto a branch I am managing myself (for example, rebasing), confirm first.

## Optional changes go in their own commit

When a change carries a fix plus something the fix does not need (a log, metadata, a cleanup), make two
commits: `fix:` for the fix and `chore:` for the extra, and say so in the MR description. MRs are
squashed, but the split lets reviewers drop the extra. Re-read my earlier messages for commit-structure
requests before committing.
