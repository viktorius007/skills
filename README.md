<div align="center">
  <img src="header.jpg" alt="Agent workflows for high-quality software testing, test strategy, and test-suite reliability" width="100%">
</div>

# Better tests, not more tests

Most AI-written tests optimize for coverage. They assert implementation details, mock away the real risk, and pass even when the product breaks.

WIO is one testing workflow skill with four commands: `$wio scan`, `$wio test`, `$wio review`, and `$wio doctor`.

## Structure

WIO follows the same basic shape as Impeccable: one skill, command routing inside `SKILL.md`, and one shared reference tree.

```text
skills/wio/
  SKILL.md
  adapters/
    subagents/
      wio-candidate-scout.md
      wio-strategy-critic.md
      wio-test-reviewer.md
    codex-agents/
      wio-candidate-scout.toml
      wio-strategy-critic.toml
      wio-test-reviewer.toml
    hooks/
      test-review-reminder.py
      test-review-reminder.hooks.json
  scripts/
    activate-adapters.sh
  reference/
    index.md
    <topic>/
      overview.md
      tools.md
```

There are no separate `scan`, `test`, `review`, or `doctor` skills. There is no plugin wrapper. There are no copied reference trees.

## Activation Links

The skill content lives in `skills/wio`. Host discovery paths are links or thin adapters:

| Host | Discovery path | Source |
| --- | --- | --- |
| Agent skills | `.agents/skills/wio` | Symlink to `skills/wio`. |
| Claude Code subagents | `.claude/agents/wio-*.md` | Symlinks to `skills/wio/adapters/subagents/wio-*.md`. |
| Claude Code hooks | `.claude/settings.json` | Symlink to `skills/wio/adapters/hooks/test-review-reminder.hooks.json`. |
| Codex subagents | `.codex/agents/wio-*.toml` | Symlinks to thin TOML adapters in `skills/wio/adapters/codex-agents/`. |
| Codex hooks | `.codex/hooks.json` | Symlink to `skills/wio/adapters/hooks/test-review-reminder.hooks.json`. |

Codex needs TOML custom-agent files, while Claude Code needs Markdown files with YAML frontmatter. The Codex TOML files are adapters only: they point back to the canonical Markdown specs and do not duplicate testing guidance.

`npx skills add` installs the skill folder into `.agents/skills/wio`. It installs the canonical skill, adapters, script, hook file, and references, but it does not automatically register Claude or Codex subagents/hooks in host discovery paths. To activate those adapters in a project after install, run:

```sh
./.agents/skills/wio/scripts/activate-adapters.sh
```

## Commands

| Command | What it does |
| --- | --- |
| `$wio scan [target]` | Maps product behavior, existing tests, CI, and risk areas to find the highest-value tests to add next. |
| `$wio test [target]` | Runs the full loop: discover candidate, pick strategy, write test, validate, review, then keep only if valuable. |
| `$wio review [target]` | Reviews a test for customer value, developer-flow value, signal quality, maintainability, and false confidence. |
| `$wio doctor [target]` | Audits test-suite health: weak assertions, flakes, excessive mocks, broad snapshots, slow feedback, skipped tests, and missing critical behavior coverage. |

## Subagents

WIO includes bundled subagent specs under `skills/wio/adapters/subagents/`:

| Subagent | Role |
| --- | --- |
| `wio-candidate-scout` | Read-only discovery of high-value test candidates before implementation. |
| `wio-strategy-critic` | Read-only challenge of the selected strategy before editing tests. |
| `wio-test-reviewer` | Read-only post-write review that returns `KEEP`, `REDO`, or `REMOVE`. |

The main agent still writes the test. Subagents gather evidence, challenge the strategy, and review value. They do not duplicate reference content and they do not own the workflow.

Claude Code project subagents are linked into `.claude/agents/`. Codex project subagents are linked into `.codex/agents/` as TOML adapters, because Codex discovers custom agents from `.codex/agents/*.toml`.

## Hooks

WIO hooks are optional host adapters. They should only remind the active agent to validate test changes and apply the WIO value gate. The hook JSON lives in `skills/wio/adapters/hooks/`; do not put WIO doctrine into hook bodies.

## References

Detailed testing guidance lives only in `skills/wio/reference/`.

Reference topics include:

| Area | Covers |
| --- | --- |
| Behavior mapping | Turning product behavior, workflows, APIs, and incidents into test candidates. |
| Risk-based testing | Prioritizing tests by customer impact, likelihood, confidence gap, and cost. |
| Test level selection | Choosing unit, component, integration, contract, E2E, monitoring, or specialized checks. |
| Oracles and assertions | Designing assertions that fail for real regressions and explain what broke. |
| Test data and fixtures | Setup, isolation, factories, seeds, cleanup, and state management. |
| Mocking and doubles | Preserving fidelity while keeping tests deterministic and fast. |
| Suite health | Finding flakes, weak signal, slow feedback, skipped tests, and CI blind spots. |
| Advanced strategies | Static analysis, security testing, fuzzing, property-based testing, mutation testing, performance testing, resilience testing, and regression selection. |

## Usage

```text
$wio scan checkout
$wio test billing eligibility regression
$wio review tests/billing_eligibility_test.py
$wio doctor API test suite
```

Use `scan` when you do not yet know what to test. Use `test` when you want the whole candidate-strategy-write-review loop. Use `review` when a test already exists or has just been written. Use `doctor` when an existing suite is hard to trust.

## What Good Means

A generated or recommended test should answer:

- What user, operator, customer, or API consumer failure does this prevent?
- What production, release, support, debugging, or review risk does it reduce?
- Would it fail for the regression that matters?
- Is the assertion specific enough to diagnose the broken behavior?
- Does the setup preserve the important dependency, state, permission, timing, or data risk?
- Does this belong in local development, PR CI, nightly, release, or production monitoring?

If those answers are weak, the test should be redesigned or removed.

## Contributing

Keep the public surface area small: one skill, `wio`, with command modes `scan`, `test`, `review`, and `doctor`.

Detailed testing guidance belongs in `skills/wio/reference/`, not duplicated inside workflow files, plugin files, command adapters, cloud folders, subagents, hooks, or extra skill trees. When adding a reference topic, add both `overview.md` and `tools.md`, then link it from `skills/wio/reference/index.md`.

Host-specific adapters must stay generated or documented from this source:

- Claude Code subagents: project files live in `.claude/agents/` per the official Claude Code subagents docs.
- Claude Code hooks: project hook configuration lives in `.claude/settings.json` per the official Claude Code hooks docs.
- Codex subagents: project custom agents live in `.codex/agents/*.toml` per the official Codex subagents docs.
- Codex hooks: project hooks can live in `.codex/hooks.json` per the official Codex hooks docs.

References:

- Claude Code subagents: https://code.claude.com/docs/en/sub-agents
- Claude Code hooks: https://code.claude.com/docs/en/hooks
- Codex subagents: https://developers.openai.com/codex/subagents
- Codex hooks: https://developers.openai.com/codex/hooks

The quality bar is simple: do not accept tests for coverage alone. A test should reduce real user risk, production risk, support load, debugging time, review time, or release risk.

## License

[MIT](LICENSE)
