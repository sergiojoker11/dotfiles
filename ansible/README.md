# Ansible provisioning

Idempotent playbook for setting up a new macOS workstation.

## Prerequisites

1. Install Homebrew: https://brew.sh
2. Install Ansible and the required collection:
   ```bash
   brew install ansible
   ansible-galaxy collection install -r requirements.yml
   ```

## Variables to customise

Edit `group_vars/all.yml` before running. These are the values you need to update on each new machine:

| Variable | Description |
|---|---|
| `git_user_name` | Full name for git commits |
| `git_user_email` | Work email for git |
| `git_personal_email` | Personal email used in `~/.gitconfig-personal` |
| `git_signing_key` | GPG key ID for commit signing (`gpg --list-secret-keys --keyid-format LONG`) |
| `git_personal_repos_dir` | Directory whose repos use the personal git identity |

`dotfiles_dir` is auto-derived from the playbook location — leave it as-is.

## How to run

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

## What each role does

| Role | What it configures |
|---|---|
| `homebrew` | Brew formulae and casks (dev tools, fonts, apps) |
| `git` | Global git config: editor, pager, push, rerere, GPG signing, globalignore, aliases, `includeIf` for personal identity |
| `zsh` | Sources `zsh/rc.zsh` from `~/.zshrc` (PATH, fnm, oh-my-posh, functions) |
| `ssh` | `~/.ssh/config` for github.com and gitlab.com |
| `gh` | `~/.config/gh/config.yml` (aliases, preferences — no auth tokens) |
| `gnupg` | `~/.gnupg/common.conf` |
| `claude` | Writes `~/.claude/CLAUDE.md`, adds MCP servers (GitLab, Atlassian, Datadog) |

## What is NOT automated

These steps require interactive auth or are machine-specific:

```bash
# SSH key — generate and add to GitHub/GitLab manually
ssh-keygen -t ed25519 -C "your@email.com"

# GPG key — import your backed-up key
gpg --import <your-key.asc>

# GitLab CLI — select SSH + auth via Web
glab auth login --hostname gitlab.com

# GitHub CLI
gh auth login

# MCP OAuth — run inside Claude Code, then authenticate each server in the browser
/mcp   # → select GitLab, atlassian, datadog-mcp → OAuth

# Claude Code Aircall plugins — add to ~/.claude/settings.json manually
# (requires access to the Aircall private GitLab repo)
```
