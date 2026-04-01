# dotfiles

Personal configuration and plugins for Claude Code.

## Machine provisioning

The [`ansible/`](./ansible/) directory contains an idempotent Ansible playbook that sets up a new macOS workstation: Homebrew packages, git config, zsh functions, and Claude Code MCP servers.

See **[ansible/README.md](./ansible/README.md)** for setup instructions.

## Plugins

| Plugin | Description |
|---|---|
| [git](./plugins/git) | Git workflow shortcuts and automations |

## Claude Code setup

### On a new machine

1. Clone this repo anywhere (the Ansible playbook handles the rest of the paths automatically).

2. Run the provisioning playbook — it will write `~/.claude/CLAUDE.md` pointing to this repo:
   ```bash
   cd ansible
   ansible-galaxy collection install -r requirements.yml
   ansible-playbook -i inventory.ini playbook.yml
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
ansible/                          ← machine provisioning
  playbook.yml
  group_vars/all.yml              ← variables to customise per machine
  roles/{homebrew,git,zsh,ssh,gh,gnupg,claude}/
  git/ignore                      ← global gitignore
  zsh/rc.zsh                      ← shell init (PATH, fnm, oh-my-posh)
  zsh/functions.zsh               ← custom shell functions (ctx, ...)
  ssh/config                      ← SSH host config for github/gitlab
  gh/config.yml                   ← gh CLI preferences (no tokens)
  gnupg/common.conf               ← GPG config
.claude-plugin/marketplace.json   ← marketplace catalog
plugins/
  git/                            ← git shortcuts and automations
claude/
  CLAUDE.md                       ← preferences entry point
  code-style.md
  typescript-style.md
```
