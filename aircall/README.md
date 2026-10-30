# Aircall work setup

Everything here is specific to the Aircall job. No credentials live in this folder: secrets stay in
untracked files on the machine (`~/.aircall.env`, `~/.aircode/config.json`, OAuth tokens under
`~/.local/share/opencode`).

| File | What it is | Installed to |
| --- | --- | --- |
| `aircall.zsh` | `oc` launcher, internal-api token helpers | Sourced from `~/.zshrc` |
| `opencode-mcp.json` | Work MCP servers for OpenCode | Merged into `~/.config/opencode/opencode.jsonc` |
| `opencode-project.jsonc` | Project config for the Aircall workspace | Copied to `~/Documents/gitrepos/aircall/opencode.jsonc` |

The personal OpenCode setup (rules, skills, permissions) is not here. The Ansible `opencode` role
provisions it.

## Rebuild on a new machine

1. Run the Ansible playbook. It installs `opencode-v2` and writes the personal OpenCode config.
2. Install aircode with `brew install aircall/aircall/aircode`, then set the LLMGateway key with
   `aircode harness set-api-key llmgateway`. The key comes from the LLMGateway dashboard.
3. Source the shell setup by adding this line to `~/.zshrc`:

   ```sh
   source "$HOME/Documents/gitrepos/sj11/dotfiles/aircall/aircall.zsh"
   ```

4. Create `~/.aircall.env` with mode `0600`. It exports `AIRCALL_IA_STAGING_USER`,
   `AIRCALL_IA_STAGING_PASSWORD` and `AIRCALL_IA_STAGING_CLIENT_ID`.
5. Merge the MCP servers into the global OpenCode config:

   ```sh
   C=~/.config/opencode/opencode.jsonc
   jq -s '.[0] * .[1]' "$C" ~/Documents/gitrepos/sj11/dotfiles/aircall/opencode-mcp.json > "$C.new" \
     && [ -s "$C.new" ] && mv "$C.new" "$C"
   ```

6. Copy the project config:

   ```sh
   cp ~/Documents/gitrepos/sj11/dotfiles/aircall/opencode-project.jsonc ~/Documents/gitrepos/aircall/opencode.jsonc
   ```

7. Log in to GitHub with `gh auth login -h github.com`, then authenticate each OAuth server:

   ```sh
   for s in atlassian gitlab datadog cpaas-proxy slack; do opencode mcp auth "$s"; done
   ```

8. Open a new terminal, run `oc`, then `/mcps`. Every server should show as Connected.

## MCP servers

| Server | Auth | Why it is configured this way |
| --- | --- | --- |
| atlassian, gitlab, datadog | OAuth with dynamic client registration | No client settings needed. |
| cpaas-proxy | Okta, pre-registered client | Okta has no dynamic registration. It reuses the client ID, scopes and `localhost:8765/callback` redirect that Claude Code uses; OpenCode's default redirect is rejected. |
| slack | Slack internal app, pre-registered client | Slack only accepts approved apps. Client ID and redirect come from Confluence [Connect Slack MCP to OpenCode](https://aircall-product.atlassian.net/wiki/spaces/OT/pages/5290655880). Use its "1.x" snippet: the "2.x" one has no client ID and fails. |
| github | Bearer token, `oauth: false` | GitHub has no dynamic registration. `oc` exports `GITHUB_MCP_TOKEN` from `gh auth token`. |

## Gotchas

- **Launch with `oc`, not plain `opencode`.** Plain `opencode` has no LLMGateway providers. `oc` runs
  `aircode --no-omo`, because oh-my-opencode's orchestrator ignores the global instructions and
  permissions.
- **aircode overrides the global MCP config.** It injects the servers from `~/.aircode/config.json`
  through `OPENCODE_CONFIG_CONTENT`, which wins over `~/.config/opencode/opencode.jsonc`. An entry
  there with `enabled: false`, or without the headers, breaks the global definition. `github` is
  therefore left out of the aircode config.
- **Use `opencode mcp auth`, not `aircode mcp auth`.** aircode 0.1.105's `mcp auth` reports
  "MCP server not found" with OpenCode 2.2.1. The tokens are shared, so authenticating with
  `opencode` is enough.
- **OpenCode does not follow `@` imports in markdown.** Rules are loaded through `instructions` globs
  instead.
- **Keep `~/.aircode/config.json` at mode `0600`.** It holds the LLMGateway key, and `jq` rewrites can
  reset the mode.
