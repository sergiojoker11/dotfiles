---
name: diagram
description: Generate a Mermaid diagram from a description or the current conversation context and return a mermaid.live link to view it
user-invocable: true
argument-hint: "[description or diagram type]"
---

## Overview

Generate one or more Mermaid diagrams and return a clickable mermaid.live link per diagram. Output only the links — never the raw Mermaid code.

The number of diagrams depends on the complexity of the subject. For simple topics, one diagram is enough. For complex systems or bugs, generate multiple diagrams at different levels of zoom (e.g., high-level overview → focused detail). Always prefer clarity over completeness in a single diagram.

## Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Description | No | What to diagram. If omitted, infer from the most recent topic in the conversation. |

## Workflow

### Step 1: Determine the subject and scope

If `$ARGUMENTS` is provided, use it as the subject. Otherwise, infer from the conversation context — e.g., the bug being analyzed, the architecture being discussed, the flow being described.

Then decide **how many diagrams to generate**:

- **1 diagram** — the subject fits in a single view without becoming cluttered
- **2–3 diagrams** — the subject has multiple layers of complexity (e.g., system architecture + internal detail + bug mechanism). Use zoom levels: start broad, then drill into the part that matters most.

When generating multiple diagrams, each one must have a clear, distinct focus. Do not repeat the same information across diagrams.

### Step 2: For each diagram — choose the type

Select the most appropriate Mermaid diagram type:

| Subject | Diagram type |
|---|---|
| Sequence of events, HTTP calls, or async messages between services | `sequenceDiagram` |
| Decision logic, conditionals, or algorithm flow | `flowchart TD` |
| State machine or entity lifecycle | `stateDiagram-v2` |
| Entity relationships or data model | `erDiagram` |
| Timeline of events | `timeline` |

If the user specifies a type (e.g., "flowchart", "sequence", "state diagram"), use that instead.

### Step 3: For each diagram — write the Mermaid code

Write clean, readable Mermaid code. Rules:

**Labelling priority — abstract first, technology second:**
- The primary label on every node and arrow is the **role or interaction**: what the component does, what the communication achieves.
- Technology names (e.g. SQS, DynamoDB, Lambda, Kafka) may appear as secondary annotations in parentheses or as a small note — they serve as orientation within a known platform, not as the point of the diagram.
- Example: prefer `Call state store` over `DynamoDB`, `Async message` over `SQS publish`, `Delayed job` over `SQS delayed queue`. Add the technology in parentheses only if it genuinely helps: `Call state store (DynamoDB)`.

**Communication channels — label the arrow, not just the endpoint:**
- Every arrow must describe the channel or protocol: `sync HTTP`, `async pub/sub`, `delayed job`, `webhook`, `polling`, `WebSocket push`, `DB read/write`, etc.
- For async flows, distinguish fire-and-forget from request/reply.

**General:**
- Use short, clear labels — avoid full sentences
- Each diagram must be independently understandable — add a `title` if needed
- For `sequenceDiagram`: use `->>` / `-->>` for sync request/response, `-)` for async publish; group phases with `rect rgb(...)` blocks
- For `flowchart`: use subgraph blocks to group related steps; color terminal nodes for success/failure paths
- For `stateDiagram-v2`: annotate transitions with the triggering event
- Highlight the key insight or bug if the diagram is for a bug analysis
- Keep each diagram focused on one thing — if it's getting cluttered, split into another diagram

### Step 4: For each diagram — generate the mermaid.live URL

Run this Python 3 script once per diagram (stdlib only, no external dependencies):

```python
import json, zlib, base64

diagram = """DIAGRAM_CODE_HERE"""

state = json.dumps({"code": diagram, "mermaid": {"theme": "default"}})
compressed = zlib.compress(state.encode("utf-8"))
encoded = base64.b64encode(compressed).decode("utf-8").replace("+", "-").replace("/", "_").replace("=", "")
print("https://mermaid.live/view#pako:" + encoded)
```

Run as a single `python3 -c "..."` invocation per diagram. Use `\n` for newlines inside the diagram string.

### Step 5: Output

For each diagram, output a short title (one line) followed by its link. Nothing else — no Mermaid code, no preamble.

Example for two diagrams:

**1. System overview**
[View diagram →](https://mermaid.live/view#pako:...)

**2. The timeout gap (detail)**
[View diagram →](https://mermaid.live/view#pako:...)
