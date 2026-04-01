# CLAUDE.md conventions

- Never paste content inline into CLAUDE.md. Create a separate file and reference it with `@filename.md`.
- Never modify `~/.claude/CLAUDE.md` — it only references dotfiles and must stay as-is. The goal is that everything lives in version control (this repo), so nothing is lost if the workstation is wiped or replaced. `~/.claude/CLAUDE.md` itself is the only file that lives outside the repo — it is a single-line pointer written automatically by the Ansible playbook (`roles/claude`) on every new machine, and should never be edited by hand.
- For any personal preference or behavioral feedback worth persisting: write it to the appropriate file in dotfiles (create a new categorized file if none fits), then remind the user to commit and push.

## External link failure protocol

When a CLAUDE.md references an external URL (e.g. Confluence, Notion) and the fetch fails:
1. Check whether the relevant MCP server is connected.
2. If not authenticated, ask the user to authenticate with that MCP server.
3. Retry the fetch once authenticated.

Do not silently skip or assume the content is unavailable.

## No symlinks for plugin/skill distribution

Never suggest creating symlinks to `~/.claude/skills/` or `~/.claude/plugins/` as a fix for plugin issues. The correct workflow is to update source files and push to GitLab so the plugin installer picks up the changes.

## Elevating broadly applicable rules

When the user states something categorical (a rule, preference, or constraint) that could apply beyond the current project, suggest moving it up the hierarchy:

**dotfiles > repo CLAUDE.md > project memory**

Only leave in project memory what is truly project-specific. Even if so perhaps it is worth persisting in AGENTS|CLAUDE.md. Project memory only for personal preferences repo/project scoped.
