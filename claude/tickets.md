# Ticket writing

How to write tickets (Jira or equivalent).

- **Lead with the problem.** It is the most important part — describe what is wrong or missing and why it matters, in abstract terms. Do not name who requested it, or internal systems / Slack threads, unless essential to understanding the problem.
- **Potential solutions stay high-level.** Outline the approach, never implementation details: no step-by-step file edits, no code snippets prescribing the change. The implementer decides the *how*.
- **Reference existing code with permalinks pinned to a commit SHA** (GitLab `…/-/blob/<sha>/<path>#Lx-y`, or whatever host applies), never relative paths or branch links — they rot as code moves.
- Suggested structure: **Problem → Potential solution (high-level) → Acceptance criteria**.

## Gotcha

Jira's markdown→ADF conversion drops links that wrap inline-code spans. Put the link on plain-text labels, not on `code`.
