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

Edit `group_vars/all.yml` before running. These are the only values you need to update on each new machine:

```yaml
git_user_name: "Sergio Martín Sánchez"       # your full name
git_user_email: "you@aircall.io"              # work email (used in all repos by default)
git_personal_email: "you@gmail.com"           # personal email (used only in git_personal_repos_dir)
git_signing_key: "9406F486C19216C3"           # see below how to find this
git_personal_repos_dir: "~/Documents/gitrepos/sj11/"  # repos under this path use personal email
```

### Finding your GPG key ID

```bash
gpg --list-secret-keys --keyid-format LONG
```

Output looks like:
```
sec   ed25519/9406F486C19216C3 2024-01-01 [SC]
                ^^^^^^^^^^^^^^^^
                this is your git_signing_key
```

Copy the 16-character hex string after the `/` and paste it as `git_signing_key`.

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
# 1. SSH key — generate and add to GitHub/GitLab manually
ssh-keygen -t ed25519 -C "your@email.com"
# Then add ~/.ssh/id_ed25519.pub to GitHub → Settings → SSH Keys
#                              and GitLab → Preferences → SSH Keys

# 2. GPG key — see section below

# 3. GitLab CLI — select SSH + auth via Web
glab auth login --hostname gitlab.com

# 4. GitHub CLI
gh auth login

# 5. MCP OAuth — run inside Claude Code, then authenticate each server in the browser
/mcp   # → select GitLab, atlassian, datadog-mcp → OAuth
```

## Aircall MDM pre-installed apps

MDM (Mobile Device Management) is the system IT uses to manage company devices centrally — installing apps, enforcing security policies, and remotely wiping a device if lost. Aircall uses **Jamf** as its MDM; JamfProtect is the agent running on every company Mac.

Aircall MacBooks come with these apps already installed via Jamf. **Do not add them to the Homebrew role** — they won't be in `brew list --cask` and running `brew install --cask` on top of an MDM-managed app can cause conflicts.

| App | Purpose |
|---|---|
| 1Password | Corporate password manager |
| Aircall, Aircall Workspace, AirServices | Aircall products |
| Google Chrome | Browser (part of Google Workspace) |
| Google Drive, Docs, Sheets, Slides | Google Workspace |
| JamfProtect | MDM security agent |
| Okta Verify | SSO / MFA |
| Slack | Corporate communication |
| Zoom | Video calls |

If you're running this playbook on a **non-Aircall machine**, install these manually or add them to the Homebrew role temporarily.

## GPG key: setup and migration guide

GPG (GNU Privacy Guard) is used to **sign git commits**, proving they actually came from you. GitHub and GitLab show a "Verified" badge on signed commits.

### First time: create a key

```bash
gpg --full-generate-key
```

- Key type: `ECC (sign and certify)` → curve `Curve 25519`
- Expiry: your choice (1–2 years recommended)
- Name and email: must match your git `user.email`

Once created, find your key ID:

```bash
gpg --list-secret-keys --keyid-format LONG
```

Output looks like:
```
sec   ed25519/9406F486C19216C3 2024-01-01 [SC]
```

The part after the `/` is your key ID. Put it in `group_vars/all.yml` as `git_signing_key`.

Add the public key to GitHub and GitLab so they can verify your commits:

```bash
gpg --armor --export 9406F486C19216C3
# Copy the output and paste it into:
# GitHub  → Settings → SSH and GPG keys → New GPG key
# GitLab  → Preferences → GPG Keys → Add key
```

### New machine: import your existing key

**On the old machine** — export and back up your key securely (e.g. 1Password, encrypted USB):

```bash
# Export secret key
gpg --armor --export-secret-keys 9406F486C19216C3 > gpg-private-key.asc

# Export trust database
gpg --export-ownertrust > gpg-ownertrust.txt
```

**On the new machine** — after running the Ansible playbook:

```bash
# Import the key
gpg --import gpg-private-key.asc

# Restore trust level (marks your own key as "ultimately trusted")
gpg --import-ownertrust gpg-ownertrust.txt

# Verify it's there
gpg --list-secret-keys --keyid-format LONG
```

Delete the exported `.asc` file once imported — it contains your private key.
