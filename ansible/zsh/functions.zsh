ctx() { grep -C "${2:-5}" --color=always "$1" | sed 's/^--$/\n─────────────────────────/'; }

ekslogin() {
  setopt local_options no_monitor

  local profile_arg=()
  if [[ -n "$AWS_ACCESS_KEY_ID" ]]; then
    echo "Using credentials from environment (AWS_ACCESS_KEY_ID is set)." >&2
  else
    local profile="${1:-$AWS_PROFILE}"
    [[ -z "$profile" ]] && { echo "No AWS profile active. Pass one as argument or export AWS_PROFILE." >&2; return 1; }
    profile_arg=(--profile "$profile")
  fi

  echo "Searching for clusters..." >&2

  local tmpdir
  tmpdir=$(mktemp -d)

  local regions
  regions=$(aws ec2 describe-regions \
    "${profile_arg[@]}" \
    --query 'Regions[].RegionName' \
    --output text 2>/dev/null | tr '\t' '\n')

  if [[ -z "$regions" ]]; then
    echo "No regions found — check AWS credentials." >&2
    rm -rf "$tmpdir"
    return 1
  fi

  while IFS= read -r region; do
    [[ -z "$region" ]] && continue
    (
      aws eks list-clusters \
        "${profile_arg[@]}" \
        --region "$region" \
        --query 'clusters[]' \
        --output text 2>/dev/null \
        | tr '\t' '\n' \
        | grep -v '^$' \
        | sed "s|^|$region\t|" \
        > "$tmpdir/$region"
    ) &
  done <<< "$regions"
  wait

  local cluster_files=("$tmpdir"/*(N))
  if [[ ${#cluster_files[@]} -eq 0 ]]; then
    echo "No EKS clusters found across all regions." >&2
    rm -rf "$tmpdir"
    return 1
  fi

  local selection
  selection=$(cat "${cluster_files[@]}" \
    | column -t \
    | fzf --prompt='Cluster: ')
  rm -rf "$tmpdir"

  [[ -z "$selection" ]] && return 1

  local region cluster
  region=$(echo "$selection" | awk '{print $1}')
  cluster=$(echo "$selection" | awk '{print $2}')

  aws eks update-kubeconfig \
    "${profile_arg[@]}" \
    --region "$region" \
    --name "$cluster"

  echo "Kubeconfig updated: $cluster ($region)" >&2
}
