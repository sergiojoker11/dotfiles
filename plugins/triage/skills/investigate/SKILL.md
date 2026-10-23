---
name: investigate
description: >
  Triage a ticket end to end: understand it, find where the causal chain first breaks, decide whether
  it belongs to the user's team, and produce either a handoff message for the owning team or an impact
  assessment. Use when the user passes a ticket key or URL and asks to analyse, investigate or triage
  it, in any language — e.g. "investigate PROJ-1234", "analyze this ticket", "is this ours?".
argument-hint: <TICKET-KEY | ticket URL>
---

# Investigate a ticket

Every ticket gets the same treatment: a quick read, an explanation, an executive summary, the ownership
question, then either a handoff message or an impact assessment. This skill runs that whole loop in one
pass and returns **only the executive result**. Detail is given on request, never by default.

## Organisation context

This skill is organisation-agnostic. Before starting, read `.claude/investigate.md` in the current
project if it exists. It names the team, how to resolve service ownership, the ticket and
observability tools, the architecture docs to read first, and any known pitfalls. Its instructions
take precedence over the generic steps below wherever they are more specific.

If the file does not exist, ask the user which team "ours" refers to before giving a verdict.

## No claim without evidence

This rule overrides every other rule in this skill, including the length cap.

- **Every statement in the output is backed by evidence the reader can open**: a log or trace link, a
  metric query, a permalink to the code at a pinned commit, a query result or the ticket itself. If
  no evidence backs a statement, leave it out.
- **Missing evidence is something to go and find, not a gap to fill.** Search for it. If the existing
  logs, metrics and traces cannot answer the question, the verdict is `unclear`. In that case, name
  the observability change that would answer it (a log field, a span, a metric) and why it is
  needed.
- **Anything not directly verified is labelled where it is stated**, with what it rests on:
  - *verified*: give the link;
  - *inferred from*: name the facts, the number of instances and the time window;
  - *assumed*: say what would confirm or refute it.
- The verdict is no stronger than the weakest unverified step in the chain. If any step is inferred,
  the verdict is an inference and its confidence says so.
- Memories, docs and previous tickets are leads, not evidence. Verify them against the source for the
  case at hand before relying on them.

## Output contract

The default reply fits on one screen: **15 lines at most**, excluding the draft message and the diagram
links. It is written in the user's conversation language, while every draft meant to be shared is in
English. It contains, in this order:

1. **What is reported**: one line covering who reported it, when, which customer/entity is affected,
   and the current status.
2. **Verdict**: `ours`, `not ours`, `split` or `unclear`, with a confidence level. Use `split` when one
   symptom has independent causes in different places, and give one verdict per cause.
3. **Why**: two or three bullets. Each one names a concrete fact and links to evidence the user can open.
4. **Diagram**: one clickable link showing where the chain breaks (see Diagrams).
5. **Branch output**: see below.
6. One closing line offering the detailed walkthrough.

Do not include a narrative of the investigation, a list of everything that was checked, or section
headers beyond what these items need. If you find you need more than 15 lines, the verdict is not clear
yet: say `unclear` instead of padding.

### Branch output

- **Not ours.** Name the owning team and its board, with the source for that claim. Then give a
  handoff draft **in English** that reads like a colleague wrote it: short plain paragraphs, first
  person, no bold headings or "Root cause / Fix" scaffolding. It states what was observed, where the
  chain breaks, and the links (diagram included), and is short enough to paste as a ticket comment.
  Show it only.
- **Ours.** Give an impact assessment:
  - **age**: when the behaviour was introduced. Use `git log -S'<code>' --reverse` to find where the
    code was introduced; `git log -L` only shows what last touched it;
  - **rate**: a per-day breakdown over the available retention, with a link;
  - **measured harm**: what actually went wrong for users, not what could go wrong.

  Name any of the three you did not measure. Then suggest an urgency. A chronic, low-rate defect that
  has been tolerated for a long time gets a normal ticket, not an alarm. If you propose a fix, name
  the concrete change and its consequence; "something looks odd in that service" is not a ticket.
- **Unclear.** Name the single piece of evidence that would decide the verdict, and how to get it: a
  query, a person to ask, or a reproduction.

## Form

These rules apply to the reply, the detailed walkthrough and every draft.

### Diagrams

- Always draw diagrams with the `lens:diagram` skill. Its output is a clickable mermaid.live link per
  diagram. Never paste raw Mermaid code, ASCII art or box-drawing characters.
- The default reply carries **one** diagram: the causal chain, with the first break highlighted.
- The detailed walkthrough adds diagrams at increasing depth, each with a distinct focus:
  1. an overview of the services involved and how information flows between them;
  2. the sequence of calls and events for the affected case, with real timestamps;
  3. where it matters, the timing or the state machine that explains the break.
- In a `split` verdict, highlight each break separately so each owner can see their part.
- Ticket trackers rarely render Mermaid, so drafts carry the mermaid.live link, not the code. In a
  merge request, a fenced `mermaid` block renders natively and is preferred.

### Evidence and links

- Every claim carries a link the reader can open, placed at the point of the claim, not in a list at
  the end.
- Observability links use an **absolute** time range bracketing the event, never a relative one.
- Every reference to code carries a permalink pinned to a commit SHA.
- Every number or table states the window it covers and how fresh each source is. A rate is a per-day
  breakdown, not an average.
- In anything bound for Jira or Confluence, never put a link on an inline-code label: Atlassian drops
  it silently.

### Language

- Spell out every acronym, internal label or counter-intuitive field name before using it, and state
  its real value and owner.
- Times in UTC, with the date.

## Procedure

Do steps 1–6 silently, then write the output.

1. **Read the ticket.** Fetch the issue with its comments, linked issues and remote links. Extract
   every identifier: request/call/session ids, customer and user ids, timestamps (converted to UTC),
   environment and provider.
2. **Check what is already known.** Search memory for the same symptom, service or ticket family, and
   follow the linked tickets. Many tickets repeat a known defect.
3. **Locate the component.** Read the project's architecture docs for the flow involved, then verify
   the relevant parts against the source.
4. **Reconstruct what happened** from logs, traces and metrics, using any specialised debugging skill
   the organisation context names instead of re-deriving it.
5. **Decide ownership by the first break, not by the symptom.** Find the first service whose behaviour
   deviates from its contract. That service's owner owns the ticket, wherever the symptom surfaces.
   Resolve the owner from the authoritative sources the organisation context lists, never from a
   guessed list.

   Before calling anything a one-off, measure the **symptom** across every provider and trigger, not
   only the one seen in the ticket. A single traced instance is not a rate.
6. **Draw the diagram** of the causal chain with `lens:diagram`.

## Follow-ups

- **Detail requested**: walk through the timeline and the code path, with the deeper diagrams.
- **Asked to send or move the ticket**: draft only. Never comment on, transition or edit the ticket,
  and never post anywhere, unless the user explicitly approves that exact action.
- **Verdict or urgency challenged**: re-measure. Do not defend the earlier answer.
