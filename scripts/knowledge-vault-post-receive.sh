#!/usr/bin/env bash
set -euo pipefail

BLOG_BRANCH="${BLOG_BRANCH:-feature/obsidian}"
LOG_FILE="${LOG_FILE:-/tmp/knowledge-vault-publish.log}"
PUBLISH_SCRIPT="/home/relion911/git-repositories/Reotech736.github.io/scripts/publish-knowledge-vault.sh"

should_run=0

while read -r _oldrev _newrev refname; do
  if [[ "$refname" == "refs/heads/main" ]]; then
    should_run=1
  fi
done

if [[ "$should_run" -ne 1 ]]; then
  exit 0
fi

# Clear git hook environment before touching other repositories.
unset $(git rev-parse --local-env-vars)

{
  printf '=== %s post-receive start ===\n' "$(date -Iseconds)"
  BLOG_BRANCH="$BLOG_BRANCH" "$PUBLISH_SCRIPT"
  printf '=== %s post-receive success ===\n' "$(date -Iseconds)"
} 2>&1 | tee -a "$LOG_FILE"
