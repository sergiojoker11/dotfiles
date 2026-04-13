# AWS Account Setup

## Concepts

### SSO Session
A single connection to Aircall's IAM Identity Center (one start URL + region).
One session gives access to multiple AWS accounts and roles.
Configured once with `aws configure sso` and reused across all profiles.

### AWS Profile
A named local configuration in `~/.aws/config` that maps to a specific
AWS account + permission set. You can have as many profiles as you need.

### Permission Set / Role
The level of access granted to you in a specific account (e.g. `AdminAccess`,
`ReadOnly`). Defined by the company — you select it during profile setup.

---

## Adding a new profile

```bash
aws configure sso --profile <profile-name>
```

Follow the interactive guide:
1. Reuse the existing SSO session when prompted
2. A browser window opens — authenticate if needed
3. Select the AWS account and role
4. The profile is saved to `~/.aws/config`

---

## Switching profiles

Use `assume` (provided by [granted](https://github.com/fwdcloudsec/granted))
for interactive profile switching with fuzzy search:

```bash
assume
```

This exports `AWS_PROFILE` (and optionally `AWS_REGION`) to the current shell.

---

## Connecting to EKS

```bash
ekslogin [profile]
```

Custom shell function (defined in `ansible/zsh/functions.zsh`).
Lists all EKS clusters across all regions interactively.
If no profile is passed, uses `$AWS_PROFILE` from the current shell.
