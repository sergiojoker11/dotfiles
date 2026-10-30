# Aircall work setup. Sourced from ~/.zshrc. Credentials live in ~/.aircall.env, never here.
[[ -r "$HOME/.aircall.env" ]] && source "$HOME/.aircall.env"

# --- Aircall internal-api -------------------------------------------------

# Generic. $1=username $2=password $3=cognito app client id $4=region
_internalapi_token() {
  local token
  token=$(aws cognito-idp initiate-auth \
    --region "$4" \
    --auth-flow USER_PASSWORD_AUTH \
    --client-id "$3" \
    --auth-parameters "USERNAME=$1,PASSWORD=$2" \
    --query 'AuthenticationResult.IdToken' \
    --output text 2>/dev/null)

  if [[ -z "$token" || "$token" == "None" ]]; then
    echo "internalapi-token: no ID token returned — wrong password, or MFA on the account" >&2
    return 1
  fi

  print -r -- "$token"
}

# Generic, via refresh token, for environments without a password (SSO).
# The endpoint rotates the token on every call, so it has to be rewritten.
# $1=state file holding the refresh token  $2=refresh endpoint URL
_internalapi_token_refresh() {
  local state="$1" url="$2" refresh response id_token new_refresh

  if [[ ! -s "$state" ]]; then
    echo "internalapi-token: $state is missing — copy the ac-auth.refresh-token cookie into it" >&2
    return 1
  fi
  refresh=$(tr -d '[:space:]' < "$state")

  if ! response=$(curl -sf "$url" \
    -H "Authorization: Bearer $refresh" \
    -H 'Aircall-Platform: dashboard-v4'); then
    echo "internalapi-token: refresh rejected — copy the ac-auth.refresh-token cookie again" >&2
    return 1
  fi

  id_token=$(print -r -- "$response" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("idToken",""))')
  new_refresh=$(print -r -- "$response" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("refreshToken",""))')

  if [[ -z "$id_token" ]]; then
    echo "internalapi-token: the response has no idToken" >&2
    return 1
  fi
  [[ -n "$new_refresh" ]] && print -rn -- "$new_refresh" > "$state"

  print -r -- "$id_token"
}

_internalapi_token_staging() {
  _internalapi_token \
    "$AIRCALL_IA_STAGING_USER" \
    "$AIRCALL_IA_STAGING_PASSWORD" \
    "$AIRCALL_IA_STAGING_CLIENT_ID" \
    us-west-2
}

# Production uses SSO: there is no password, and the debug role cannot reset one.
# The token is issued by production-pdx-default-web-client on pool us-west-2_hZkGBmIsz.
_internalapi_token_prod() {
  _internalapi_token_refresh \
    "$HOME/.ia-prod-refresh" \
    https://id.aircall.io/auth/v1/tokens/refresh
}

internalapi-token() {
  case "$1" in
    staging) _internalapi_token_staging ;;
    prod)    _internalapi_token_prod ;;
    *)       echo "usage: internalapi-token [staging|prod]" >&2; return 1 ;;
  esac
}
# ---------------------------------------------------------------------------

# --- OpenCode launcher ------------------------------------------------------
# --no-omo: OMO's orchestrator ignores the global OpenCode instructions and permissions.
# GITHUB_MCP_TOKEN: the GitHub MCP has no OAuth registration; OpenCode sends this as a Bearer header.
oc() {
  GITHUB_MCP_TOKEN="$(gh auth token 2>/dev/null)" aircode --no-omo "$@"
}
