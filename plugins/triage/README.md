# triage plugin

Ticket triage — ownership verdicts, handoffs and impact assessments backed by evidence.

## Skills

| Skill | Description |
|---|---|
| `/investigate` | Investigate a ticket, decide whether it is ours, and draft a handoff or an impact assessment |

## Usage

```
/investigate PROJ-1234
/investigate https://example.atlassian.net/browse/PROJ-1234
```

The skill is organisation-agnostic. Put organisation specifics — the team, how to resolve service
ownership, observability tools, architecture docs, known pitfalls — in `.claude/investigate.md` at the
root of the project you run it from. The skill reads that file first if it exists.

Diagrams depend on the `lens` plugin.
