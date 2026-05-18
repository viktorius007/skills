# AGENTS.md

This repository packages the `wio` testing workflow skill for Codex and other coding agents.

## Canonical Paths

- Skill: `skills/wio/SKILL.md`
- Host adapters: `skills/wio/adapters/`
- Activation script: `skills/wio/scripts/activate-adapters.sh`
- References: `skills/wio/reference/`
- Skill activation link: `.agents/skills/wio -> ../../skills/wio`
- Claude activation links: `.claude/agents/` and `.claude/settings.json`
- Codex activation links: `.codex/agents/`, `.codex/hooks.json`, and `.codex/config.toml`

## Maintenance Rules

- Do not remove existing reference context.
- Keep `skills/wio/SKILL.md` concise and route detailed testing guidance through `skills/wio/reference/index.md`.
- Keep `skills/wio` as the source of truth; repo-local activation paths must be symlinks or thin adapters that point back to it.
- Keep test review strict: low-value tests should be marked `REDO` or `REMOVE`, not accepted for coverage.
- When adding a reference topic, add both `overview.md` and `tools.md`, then link it from the WIO reference index.
- Do not create separate `scan`, `test`, `review`, or `doctor` skills. They are command modes inside the single `wio` skill.
- Do not duplicate references under plugin, cloud, Claude, command, hook, or subagent folders.
- Subagents may inspect, challenge, and review, but the main agent writes tests and applies the final `KEEP`, `REDO`, or `REMOVE` decision.
- Claude Code discovers Markdown subagents from `.claude/agents/`; Codex discovers TOML custom agents from `.codex/agents/`. Keep both wired to `skills/wio/adapters/`.
