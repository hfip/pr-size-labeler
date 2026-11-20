#!/usr/bin/env bash
set -euo pipefail

source "$GITHUB_ACTION_PATH/scripts/size.sh"

: "${GH_TOKEN:?a token is required}"
: "${PR_NUMBER:?no pull request number}"
repository="${GITHUB_REPOSITORY:?}"

payload=$(gh api "repos/${repository}/pulls/${PR_NUMBER}" --jq '[.additions, .deletions] | @tsv')
read -r additions deletions <<< "${payload}"
total=$(( additions + deletions ))

label="${LABEL_PREFIX:-size/}$(size_label "${total}")"
color=$(size_color "${label#*/}")
description=$(size_description "${label#*/}")

gh label create "${label}" --color "${color}" --description "${description}" --force >/dev/null 2>&1 || true

# Remove stale size labels, keep the one we are about to add.
current=$(gh api "repos/${repository}/issues/${PR_NUMBER}/labels" --jq '.[].name' || true)
prefix="${LABEL_PREFIX:-size/}"
while IFS= read -r name; do
  [ -z "${name}" ] && continue
  case "${name}" in
    "${prefix}"*)
      if [ "${name}" != "${label}" ]; then
        gh api -X DELETE "repos/${repository}/issues/${PR_NUMBER}/labels/${name}" >/dev/null
      fi
      ;;
  esac
done <<< "${current}"

gh api -X POST "repos/${repository}/issues/${PR_NUMBER}/labels" \
  -f "labels[]=${label}" >/dev/null

echo "PR #${PR_NUMBER}: ${additions} added, ${deletions} removed -> ${label}"
