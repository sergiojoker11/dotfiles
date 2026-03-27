# dotfiles

Personal configuration and plugins for Claude Code.

## Plugins

| Plugin | Description |
|---|---|
| [git](./plugins/git) | Git workflow shortcuts and automations |

## Installation

### On a new machine

1. Clone this repo to `~/Documents/gitrepos/sj11/dotfiles`

2. Create `~/.claude/CLAUDE.md` with a single line (loads personal preferences):
   ```
   @~/Documents/gitrepos/sj11/dotfiles/claude/CLAUDE.md
   ```

3. Add the marketplace and enable plugins in `~/.claude/settings.json`:
   ```json
   "extraKnownMarketplaces": {
     "sj11": {
       "source": { "source": "git", "url": "git@github.com:sergiojoker11/dotfiles.git" },
       "autoUpdate": true
     }
   },
   "enabledPlugins": {
     "git@sj11": true
   }
   ```

> **Note:** Claude Code has no "enable all plugins from marketplace" feature — each plugin must be listed explicitly in `enabledPlugins`. When adding a new plugin to this repo, remember to also add `"plugin-name@sj11": true` to `~/.claude/settings.json`. This is a current limitation of the platform.

## Adding a new plugin

1. Create `plugins/<tool-name>/` following the existing `git` plugin structure
2. Add the plugin to `.claude-plugin/marketplace.json`
3. Push to GitHub
4. Add `"<tool-name>@sj11": true` to `~/.claude/settings.json`
5. Restart Claude Code

## Structure

```
.claude-plugin/marketplace.json   ← marketplace catalog
plugins/
  git/                            ← git shortcuts and automations
    .claude-plugin/plugin.json
    skills/gitsquash/SKILL.md
    README.md
claude/
  CLAUDE.md                       ← preferences entry point
  preferences.md                  ← personal coding style
```
