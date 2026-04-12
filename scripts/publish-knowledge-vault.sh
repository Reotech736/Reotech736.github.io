#!/usr/bin/env bash
set -euo pipefail

KNOWLEDGE_ROOT="${KNOWLEDGE_ROOT:-/home/relion911/git-repositories/knowledge-vault-work}"
BLOG_ROOT="${BLOG_ROOT:-/home/relion911/git-repositories/Reotech736.github.io}"
KNOWLEDGE_REMOTE="${KNOWLEDGE_REMOTE:-origin}"
KNOWLEDGE_BRANCH="${KNOWLEDGE_BRANCH:-main}"
BLOG_REMOTE="${BLOG_REMOTE:-origin}"
BLOG_BRANCH="${BLOG_BRANCH:-main}"
LOCK_FILE="${LOCK_FILE:-/tmp/knowledge-vault-publish.lock}"
COMMIT_MESSAGE="${COMMIT_MESSAGE:-chore: sync published notes from knowledge vault}"

log() {
  printf '[publish] %s\n' "$*"
}

ensure_clean_worktree() {
  local repo_path="$1"
  if [[ -n "$(git -C "$repo_path" status --porcelain)" ]]; then
    log "worktree is dirty: $repo_path"
    git -C "$repo_path" status --short
    exit 1
  fi
}

checkout_branch() {
  local repo_path="$1"
  local branch="$2"
  local current_branch

  current_branch="$(git -C "$repo_path" branch --show-current)"
  if [[ "$current_branch" != "$branch" ]]; then
    log "checkout $branch in $repo_path"
    git -C "$repo_path" checkout "$branch"
  fi
}

sync_branch() {
  local repo_path="$1"
  local remote_name="$2"
  local branch="$3"

  checkout_branch "$repo_path" "$branch"
  log "fetch $remote_name/$branch in $repo_path"
  git -C "$repo_path" fetch "$remote_name" "$branch"
  log "pull --rebase $remote_name/$branch in $repo_path"
  git -C "$repo_path" pull --rebase "$remote_name" "$branch"
}

sync_branch_hard() {
  local repo_path="$1"
  local remote_name="$2"
  local branch="$3"

  checkout_branch "$repo_path" "$branch"
  log "fetch $remote_name/$branch in $repo_path"
  git -C "$repo_path" fetch "$remote_name" "$branch"
  log "reset --hard $remote_name/$branch in $repo_path"
  git -C "$repo_path" reset --hard "$remote_name/$branch"
}

main() {
  exec 9>"$LOCK_FILE"
  if ! flock -n 9; then
    log "another publish job is already running"
    exit 0
  fi

  log "start"
  ensure_clean_worktree "$KNOWLEDGE_ROOT"
  ensure_clean_worktree "$BLOG_ROOT"

  sync_branch "$KNOWLEDGE_ROOT" "$KNOWLEDGE_REMOTE" "$KNOWLEDGE_BRANCH"
  sync_branch_hard "$BLOG_ROOT" "$BLOG_REMOTE" "$BLOG_BRANCH"

  log "import study logs"
  (cd "$BLOG_ROOT" && ruby scripts/import-study-logs.rb)

  log "import terms"
  (cd "$BLOG_ROOT" && ruby scripts/import-terms.rb)

  log "build site"
  (cd "$BLOG_ROOT" && JEKYLL_ENV=production bundle exec jekyll build)

  if [[ -n "$(git -C "$BLOG_ROOT" status --porcelain -- _study_logs _terms)" ]]; then
    log "commit generated markdown"
    git -C "$BLOG_ROOT" add -A -- _study_logs _terms
    git -C "$BLOG_ROOT" commit -m "$COMMIT_MESSAGE"
    log "push $BLOG_REMOTE/$BLOG_BRANCH"
    git -C "$BLOG_ROOT" push "$BLOG_REMOTE" "$BLOG_BRANCH"
  else
    log "no generated markdown changes"
  fi

  log "done"
}

main "$@"
