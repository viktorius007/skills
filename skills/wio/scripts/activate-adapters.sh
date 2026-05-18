#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_dir="${1:-$(pwd)}"

link_file() {
  local target="$1"
  local link="$2"
  local dir
  dir="$(dirname "$link")"
  mkdir -p "$dir"

  if [[ -e "$link" && ! -L "$link" ]]; then
    printf 'skip existing file: %s\n' "$link" >&2
    return 0
  fi

  ln -sfn "$target" "$link"
  printf 'linked: %s -> %s\n' "$link" "$target"
}

link_file "$skill_dir/adapters/subagents/wio-candidate-scout.md" "$project_dir/.claude/agents/wio-candidate-scout.md"
link_file "$skill_dir/adapters/subagents/wio-strategy-critic.md" "$project_dir/.claude/agents/wio-strategy-critic.md"
link_file "$skill_dir/adapters/subagents/wio-test-reviewer.md" "$project_dir/.claude/agents/wio-test-reviewer.md"

link_file "$skill_dir/adapters/codex-agents/wio-candidate-scout.toml" "$project_dir/.codex/agents/wio-candidate-scout.toml"
link_file "$skill_dir/adapters/codex-agents/wio-strategy-critic.toml" "$project_dir/.codex/agents/wio-strategy-critic.toml"
link_file "$skill_dir/adapters/codex-agents/wio-test-reviewer.toml" "$project_dir/.codex/agents/wio-test-reviewer.toml"

link_file "$skill_dir/adapters/hooks/test-review-reminder.hooks.json" "$project_dir/.codex/hooks.json"
link_file "$skill_dir/adapters/hooks/test-review-reminder.hooks.json" "$project_dir/.claude/settings.json"

