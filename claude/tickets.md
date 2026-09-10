# Ticket and documentation writing

How to write tickets (Jira or equivalent) and technical documentation (Confluence or equivalent).

## Permalinks are mandatory, everywhere

Every reference to code — a file, a symbol, a behaviour, and **especially a quoted line or snippet** —
carries its own permalink pinned to a commit SHA, placed **at the point of the claim**, not collected
in a table at the bottom. A bare line of code in a platform of this size is completely
decontextualised: the reader cannot tell where it came from or whether it was invented.

An index of links at the end does not satisfy this. One link per claim, inline.

- **Lead with the problem.** It is the most important part — describe what is wrong or missing and why it matters, in abstract terms. Do not name who requested it, or internal systems / Slack threads, unless essential to understanding the problem.
- **Potential solutions stay high-level.** Outline the approach, never implementation details: no step-by-step file edits, no code snippets prescribing the change. The implementer decides the *how*.
- **Reference existing code with permalinks pinned to a commit SHA** (GitLab `…/-/blob/<sha>/<path>#Lx-y`, or whatever host applies), never relative paths or branch links — they rot as code moves.
- Suggested structure: **Problem → Potential solution (high-level) → Acceptance criteria**.

## Gotcha

Atlassian's markdown→ADF conversion **silently drops** links whose label is, or begins with, an
inline-code span. This affects **Jira and Confluence alike**. Put the link on a plain-text label,
never on `code`.

Failure mode seen in practice: `[\`@some.field\` returns 0 results](url)` and a table cell
`[\`abc1234\`](url)` both publish as plain text with the link gone, and nothing in the API response
signals it. After any markdown write to Jira or Confluence, **re-fetch the content and confirm the
links are still there** — that is the only reliable check.
