# CLAUDE.md

This repository packages the `wio` testing workflow skill.

## Canonical Paths

- Skill: `skills/wio/SKILL.md`
- Host adapters: `skills/wio/adapters/`
- Activation script: `skills/wio/scripts/activate-adapters.sh`
- References: `skills/wio/reference/`
- Skill activation link: `.agents/skills/wio -> ../../skills/wio`
- Claude activation links: `.claude/agents/` and `.claude/settings.json`
- Codex activation links: `.codex/agents/`, `.codex/hooks.json`, and `.codex/config.toml`

## Maintenance Rules

- Keep detailed testing content in references, not in `SKILL.md`.
- Do not remove existing reference context.
- Keep `skills/wio` as the source of truth; repo-local activation paths must be symlinks or thin adapters that point back to it.
- Keep the reviewer focused on user value and team time saved.
- Any test that does not materially reduce user-visible errors, production risk, support load, debugging time, review time, or release risk should be marked `REDO` or `REMOVE`.
- When adding a reference topic, add both `overview.md` and `tools.md`, then link it from the WIO reference index.
- Do not create separate `scan`, `test`, `review`, or `doctor` skills. They are command modes inside the single `wio` skill.
- Do not duplicate references under plugin, cloud, Claude, command, hook, or subagent folders.
- Subagents may inspect, challenge, and review, but the main agent writes tests and applies the final `KEEP`, `REDO`, or `REMOVE` decision.
- Claude Code discovers Markdown subagents from `.claude/agents/`; Codex discovers TOML custom agents from `.codex/agents/`. Keep both wired to `skills/wio/adapters/`.
