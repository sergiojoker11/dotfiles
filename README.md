# dotfiles

Personal configuration and plugins for Claude Code.

## Plugins

| Plugin | Description |
|---|---|
| [git](./plugins/git) | Git workflow shortcuts and automations |

## Installation

### On this machine (local path)

```
/plugin install /Users/sj11/Documents/gitrepos/sj11/dotfiles
```

### On a new machine (once a remote is configured)

```
/plugin marketplace add <git-remote-url>
/plugin install git@sj11
```

## Claude preferences setup

On a new machine, create `~/.claude/CLAUDE.md` with a single line:

```
@~/Documents/gitrepos/sj11/dotfiles/claude/CLAUDE.md
```

## Structure

```
.claude-plugin/marketplace.json   ← marketplace catalog
plugins/
  git/                            ← git shortcuts and automations
    skills/gitsquash/SKILL.md
claude/
  CLAUDE.md                       ← preferences entry point
  preferences.md                  ← personal coding style
```
