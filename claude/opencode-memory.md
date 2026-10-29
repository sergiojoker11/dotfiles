# Project memory

Each project has a persistent memory shared with Claude Code. It lives in
`~/.claude/projects/<dir>/memory/`, where `<dir>` is the absolute path of the directory the session was
started in with every `/` replaced by `-` (for example `/Users/sj11/Documents/gitrepos/aircall` becomes
`-Users-sj11-Documents-gitrepos-aircall`).

- `MEMORY.md` is the index: one line per memory, `- [Title](file.md) — hook`. When it is not already in
  context, read it at the start of the session. Open an individual memory file when its hook is relevant.
- One memory per file, with this frontmatter:

  ```markdown
  ---
  name: <short-kebab-case-slug>
  description: <one-line summary, used to decide relevance>
  metadata:
    type: user | feedback | project | reference
  ---

  <the fact; for feedback/project, follow with **Why:** and **How to apply:** lines>
  ```

- Save a memory when the user corrects how you work, confirms a non-obvious approach, or states a fact
  about ongoing work that the repository does not record. Convert relative dates to absolute ones.
- Before saving, check whether an existing file already covers it and update that one instead.
- After writing the file, add its line to `MEMORY.md`. Never put memory content in the index itself.
- A general rule that applies beyond the project belongs in the dotfiles, not in project memory.
- A recalled memory reflects what was true when it was written. Verify any file, function or flag it
  names before relying on it.
