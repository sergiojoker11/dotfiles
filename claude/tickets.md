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

## Drafts sound like a colleague wrote them

Jira comments and Slack replies that I will post under my name use short plain paragraphs, first person
and a casual tone, with a simple list at most. No bold headings and no "Root cause / Fixes / Scope"
scaffolding. Keep only the facts the reader needs, plus the links.

## Proposals present options, not a recommendation

A proposal, RFC or decision document presents the options neutrally (effort, risk and reach for each),
plus open investigations and questions. Leave out any Recommendation section, any "what I would do
first", and any ordering of options that implies a choice: I add my own opinion. If I ask for an
opinion in chat, give it in chat and keep it out of the document.

## Design doc structure

1. Separate "how it works today" from "what we propose" into distinct sections, never interleaved. A
   reader who cannot tell fact from proposal cannot review the proposal.
2. Open with an overview of both.
3. Write two documents split by depth (an executive one and an implementation one), not by audience, and
   cross-link them.
4. Use many diagrams at increasing depth: first the parts and the information flow, then protocols and
   calls, then frequency and timing. Writing the timing level forces analysis that prose lets you skip.
