# CLAUDE.md conventions

- Never paste content inline into CLAUDE.md. Create a separate file and reference it with `@filename.md`.
- Never modify `~/.claude/CLAUDE.md` — it only references dotfiles and must stay as-is.
- For any personal preference or behavioral feedback worth persisting: write it to the appropriate file in dotfiles (create a new categorized file if none fits), then remind the user to commit and push.
