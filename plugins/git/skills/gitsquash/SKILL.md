---
name: gitsquash
description: Use this skill to squash all commits on the current branch into a single commit on top of main
---

Squash all commits on the current branch onto main into a single commit.

Steps:
1. Run `git log --oneline main..HEAD` to show the user which commits will be squashed
2. If $ARGUMENTS is provided, use it as the commit message. Otherwise, ask the user for a commit message.
3. Run `git reset --soft main`
4. Run `git commit -m "<message>"`
5. Run `git log --oneline main..HEAD` to confirm the single squashed commit
