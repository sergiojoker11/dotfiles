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
