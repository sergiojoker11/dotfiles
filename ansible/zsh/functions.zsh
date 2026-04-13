ctx() { grep -C "${2:-5}" --color=always "$1" | sed 's/^--$/\n─────────────────────────/'; }

ekslogin() {
  setopt local_options no_monitor
  local profile="${1:-$AWS_PROFILE}"
  [[ -z "$profile" ]] && { echo "No AWS profile active. Pass one as argument or export AWS_PROFILE." >&2; return 1; }

  echo "Searching for clusters..." >&2

  local tmpdir
  tmpdir=$(mktemp -d)

  local regions
  regions=$(aws ec2 describe-regions \
    --profile "$profile" \
    --query 'Regions[].RegionName' \
    --output text 2>/dev/null | tr '\t' '\n')

  while IFS= read -r region; do
    (
      aws eks list-clusters \
        --profile "$profile" \
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

  local selection
  selection=$(cat "$tmpdir"/* 2>/dev/null \
    | column -t \
    | fzf --prompt='Cluster: ')
  rm -rf "$tmpdir"

  [[ -z "$selection" ]] && return 1

  local region cluster
  region=$(echo "$selection" | awk '{print $1}')
  cluster=$(echo "$selection" | awk '{print $2}')

  aws eks update-kubeconfig \
    --profile "$profile" \
    --region "$region" \
    --name "$cluster"

  echo "Kubeconfig updated: $cluster ($region)" >&2
}
