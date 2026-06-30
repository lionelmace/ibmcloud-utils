#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-enterprise-child-accounts.csv}"

command -v jq >/dev/null || {
  echo "jq is required"
  exit 1
}

GROUPS_FILE="$(mktemp)"
ACCOUNTS_FILE="$(mktemp)"
trap 'rm -f "$GROUPS_FILE" "$ACCOUNTS_FILE"' EXIT

ibmcloud enterprise account-groups --recursive --output JSON > "$GROUPS_FILE"
ibmcloud enterprise accounts --recursive --output JSON > "$ACCOUNTS_FILE"

echo "name,id,parent_group_id,parent_group_name,state,owner_email,created_at" > "$OUT"

jq -r \
  --slurpfile groups "$GROUPS_FILE" '
  # Build group ID -> name lookup safely
  ($groups[0]
    | if type == "array" then . else [] end
    | map(select(type == "object" and (.id? != null)))
    | map({key: (.id | tostring), value: (.name // "")})
    | from_entries
  ) as $group_map |

  .[] |
  (
    (.parent // "")
    | tostring
    | capture("account-group:(?<id>[^:]+)$")?
    | .id // ""
  ) as $gid |

  [
    (.name // ""),
    (.id // ""),
    $gid,
    ($group_map[$gid] // ""),
    (.state // ""),
    (.owner_email // ""),
    (.created_at // "")
  ] | @csv
' "$ACCOUNTS_FILE" >> "$OUT"

echo "Exported to $OUT"