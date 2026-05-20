---
name: wio
description: Testing workflow skill for finding high-value test candidates, writing focused tests, generating realistic workloads, reviewing test value, and diagnosing test-suite health. Use for prompts about what to test next, adding or improving tests, reviewing whether a test is worth keeping, low-signal or flaky tests, workload scenarios, or test-suite trust. Do not use for general QA discussion unless the user wants a concrete testing workflow or artifact.
argument-hint: "[scan|test|workload|review|doctor] [target]"
user-invocable: true
metadata:
  author: workers.io
  version: "0.1.0"
---

# WIO

WIO is one testing workflow skill with five command modes:

- `scan`: find the highest-value test candidates for a codebase, change, or scope.
- `test`: write one focused high-value test for a selected behavior, code path, or regression risk.
- `workload`: generate a realistic, adversarial workload that adds a new failure surface, oracle, sequence, or coverage dimension with controlled variance, replay, and correctness invariants.
- `review`: review a newly written or existing test for customer value, developer value, signal quality, and maintainability.
- `doctor`: diagnose test-suite health problems in a codebase or scope.

Commands are accessed through `$wio`:

| Command | What it does | Default reference |
| --- | --- | --- |
| `$wio scan [target]` | Find the highest-value test candidates for a codebase, change, or scope. | [Behavior To Test Map](references/behavior-to-test-map/overview.md) |
| `$wio test [target]` | Discover a valuable candidate, pick strategy, write one test, validate, review, and keep only if valuable. | [Test Level Selection](references/test-level-selection/overview.md) |
| `$wio workload [target]` | Generate a realistic workload that adds new bug-finding value beyond existing workloads, with important user tasks, adversarial edge cases, assertions, invariants, and controlled variance. | [Workload Modeling](references/workload-modeling/overview.md) |
| `$wio review [target]` | Review a test for meaningful customer or developer value and return `KEEP`, `REDO`, or `REMOVE`. | [Test Oracles And Assertions](references/test-oracles-and-assertions/overview.md) |
| `$wio doctor [target]` | Diagnose test-suite health problems in a codebase or scope. | [Test Suite Health Diagnostics](references/test-suite-health-diagnostics/overview.md) |

Use [references/index.md](references/index.md) to route from code evidence and candidate failure modes to the right strategy references.

## Reference Loading

Do not pick a test strategy from memory or from the nearest existing test alone. First inspect the target code, public behavior, existing tests, fixtures, and test commands. Then identify candidate behaviors or workloads and their likely failure mechanisms. Only after candidates exist, load the references needed to choose the strategy.

For every selected candidate, load at least one strategy reference that matches the failure mechanism before recommending or writing a test:

- Load [Risk-Based Testing](references/risk-based-testing/overview.md) when priorities, customer impact, security/business risk, or limited test capacity decide what comes first.
- Load [User Behavior Testing](references/user-behavior-testing/overview.md) when the behavior is a user journey, product workflow, API consumer flow, or operator task.
- Load [Test Level Selection](references/test-level-selection/overview.md) before choosing unit, component, integration, contract, E2E, workload, synthetic, or monitoring coverage.
- Load [Test Oracles And Assertions](references/test-oracles-and-assertions/overview.md) before writing or reviewing assertions, invariants, snapshots, workload checks, or any test whose failure signal is unclear.
- Load [Test Data And Fixtures](references/test-data-and-fixtures/overview.md) when state setup, seeds, factories, cleanup, permissions, or data realism affect signal.
- Load [Mocking And Test Doubles](references/mocking-and-test-doubles/overview.md) when a mock, fake, stub, emulator, or real dependency decision could change what risk is preserved.
- Load [Test Feedback Loops](references/test-feedback-loops/overview.md) when choosing local, PR CI, nightly, release, canary, synthetic, or production-monitoring placement.
- Load specialized references only when the fault mechanism calls for them: property-based testing for broad deterministic input spaces, fuzzing for parsers/untrusted input, mutation testing for weak assertions, performance testing for latency/saturation, resilience testing for dependency failure, security testing for abuse or tenant/auth risk, static analysis for code/config-shape defects, and regression selection when the full suite is too slow.

For commands and repo signals in a topic, load the sibling `tools.md` after the matching `overview.md` shows that topic is relevant. State which reference files informed the chosen strategy.

## Command Selection

Use `scan` when the user asks what to test next, where coverage would matter, how to prioritize testing work, or which tests would reduce user, production, support, or team risk.

Use `test` when the user asks to add a test, improve a specific test, cover a bug, or validate a change with a meaningful automated test.

Use `workload` when the user asks for a realistic user-session workload, scenario generator, traffic model, load/performance scenario, browser journey mix, synthetic user flow, or varied workload that still preserves a stable task goal.

If the user asks to `generate` a workload, treat existing workloads as evidence and reusable infrastructure, not as the deliverable. A generated workload must add at least one new failure surface, adversarial class, oracle/invariant, state model, dependency fault, user/session path, or coverage dimension. A wrapper, runner, seed sweep, parameter expansion, or documentation-only change around an existing workload is not a generated workload unless the user explicitly asked for a runner or the wrapper adds a new oracle or adversarial model.

Use `review` when the user asks whether a test is worth keeping, asks for test review, or after `$wio test` writes or changes a test.

Use `doctor` when the user asks to audit tests, review suite quality, find flaky or low-value tests, inspect CI test health, or explain why a test suite is slow, noisy, or low-signal.

If the user explicitly names a WIO command, follow that mode. If the command is omitted, infer the mode from the request. If no command or target is provided, show the command table and ask what they want to do. If multiple modes apply, start with `scan` before `test` or `workload`, and use `doctor` only for existing suite health.

## Shared Rules

- Protect meaningful behavior, not coverage numbers.
- Ask what could go wrong before asking what already broke; use that answer to choose tests while the design is still cheap to change.
- Establish product, user, production, support, debugging, review, or release risk before recommending or writing tests.
- Prefer targets where bugs usually occur: boundaries, permissions, state transitions, persistence, external dependencies, concurrency/time, validation/parsing, migrations, configuration, caching, retries/idempotency, UI workflow joins, and recent churn.
- A test is valuable only if it would catch a meaningful regression, save developer time, improve release confidence, or expose a real operational/customer failure mode.
- Before keeping a test or workload, name at least one plausible bug it would catch and the assertion or invariant that would fail.
- Prefer assertions and invariants that encode the mental model of the behavior, including valid cases, invalid cases, and boundary transitions between them.
- Prefer repo-native frameworks, helpers, fixtures, commands, and naming.
- Choose the narrowest test level that preserves the real failure mechanism.
- Read code AND grep the test suite per candidate before choosing strategy; load targeted references after candidate failure modes are known. Production-code inspection alone never proves a gap.
- State gap evidence (search patterns + nearest existing test file:line), risk evidence (named audience + failure mode), commands run, commands not run, and residual risk. Bare "evidence inspected" is invalid output.
- Mark low-value tests `REDO` or `REMOVE`, not `KEEP`. A test whose protected behavior cannot be named concretely is `REMOVE`.

## Gotchas

- Do not write or keep tests just to increase coverage. Covered code with weak assertions is false confidence.
- Do not propose a candidate or accept a "missing coverage" claim based solely on production-code inspection. Grep the test suite for the failure mode by entity + state + verb + failure-mode keywords before declaring a gap — existing tests often live in differently-named files (e.g. `e2e_<topic>.rs`, `<module>_efficacy.rs`) or under non-obvious names. A candidate without an explicit grep-backed gap-proof is invalid output.
- Do not propose a test for a hazard that depends on a future caller constructing an unsafe state. Trace every current callsite first — if no caller can reach the state today, the candidate is `structural-not-regression` and excluded unless the user explicitly asked for forward-looking hazards.
- Do not mock away the boundary, state, permission, timing, data, or dependency behavior that creates the real risk.
- Do not accept broad snapshots unless the reviewed snapshot is the protected contract and the update path is disciplined.
- Do not use a full-suite command when a smaller command validates the changed behavior with the same signal.
- Do not weaken assertions to fix flakes. First look for nondeterminism, shared state, timing, retries, order dependence, or external services.
- Do not treat green CI as proof the test is valuable. The question is whether the test would fail for the meaningful regression.
- Do not accept tests or workloads that only prove completion, truthiness, object existence, status 200, broad snapshot equality, or mock call counts unless that weak signal is explicitly the protected contract.
- Do not present a thin wrapper around an existing workload as `$wio workload generate`. If the change only reruns, parameterizes, documents, or sweeps an existing workload, call it a runner and explain the missing new failure surface.
- Do not let subagents write tests or make the final value decision; the main agent owns edits and the final `KEEP`, `REDO`, or `REMOVE`.

## Available Scripts

- `scripts/test-review-reminder.py`: hook helper that reminds the active agent to validate and apply `$wio review` after test files change.
- `scripts/check-wio-report.py`: optional checker for saved markdown reports. Use `python3 scripts/check-wio-report.py review report.md` when a WIO output is written to a file and you need a quick structure check.

## Subagent Workflow

When the host supports subagents or parallel agents and user/host policy permits them, use the WIO subagent specs from the official host locations to improve quality without duplicating guidance:

- `wio-candidate-scout`: read-only discovery of high-value test candidates and real risk.
- `wio-strategy-critic`: read-only challenge of the chosen test level, oracle, doubles, fixtures, and validation loop before implementation.
- `wio-test-reviewer`: post-implementation review that returns `KEEP`, `REDO`, or `REMOVE`.

Subagents must inspect targeted code and tests before loading targeted WIO references. They return findings to the main agent; they do not write reports or copy reference content. Claude plugin subagents live in `plugins/wio/agents/`; Claude project subagents can live in `.claude/agents/`; Codex custom agents live in `.codex/agents/`. Installing WIO with `skills add` does not create those runtime files.

For `$wio test`, use this sequence:

1. Inspect the repo and target code: public behavior, changed paths, existing tests, fixtures, commands, dependencies, state, side effects, and boundaries.
2. Discover valuable candidates from behavior, risk, bug-prone areas, existing coverage gaps, and code evidence. Use `wio-candidate-scout` if available.
3. Load the references that match the selected candidate's failure mechanism, then pick the strategy: test level, oracle, fixture/data setup, doubles, adversarial edge coverage, and validation command.
4. Use `wio-strategy-critic` to challenge the proposed strategy before editing when available.
5. Write one focused test in the main agent, using repo-native patterns.
6. Validate with the smallest relevant command.
7. Review the written test. Use `wio-test-reviewer` if available.
8. Keep the test only if review returns `KEEP`; otherwise revise (`REDO`) or remove (`REMOVE`).

If subagents are unavailable, perform the same stages in the main agent and explicitly label the review stage.

## scan

Find the best parts to test next, the right strategy for each, and the ROI of testing them. This mode is read-only: inspect the repo and existing tests before loading strategy references; do not edit files.

**Start with code evidence:** inspect product surfaces, target implementation, existing tests, fixtures, and commands. Then use [Behavior To Test Map](references/behavior-to-test-map/overview.md) to organize candidates, [Risk-Based Testing](references/risk-based-testing/overview.md) for ranking tradeoffs, and [Test Level Selection](references/test-level-selection/overview.md) only after candidates exist.

**Workflow:**

1. Establish product/customer context from repo evidence.
2. Inventory existing test frameworks, commands, fixtures, CI, and test layers.
3. Inspect target implementation and nearby tests before choosing a strategy.
4. Map high-value behavior before low-level helpers.
5. Identify bug-prone areas in the scope.
6. Gap-proof every candidate before listing it. Grep the inventoried test suite for tests of comparable scope using the candidate's entity + state + verb + failure-mode keywords. A candidate that "looks uncovered" in production code is not a gap until proven absent in tests — existing tests often live in differently-named files (e.g. `e2e_<topic>.rs`, `<module>_efficacy.rs`) or under non-obvious names. Cite the nearest existing test (file:line) and the explicit difference that leaves this case uncovered. Drop candidates whose gap-proof fails. Classify candidates whose hazard depends on a future caller as `structural-not-regression` and exclude unless forward-looking hazards were explicitly requested.
7. Load the references that match each candidate's failure mechanism, then choose the narrowest strategy that preserves the real user or production risk.
8. Rank candidates by impact, likelihood, confidence gap, and cost.

**Output template:**

```markdown
## Scope And Evidence
target: [...]
files/commands inspected: [...]
tests/CI inventoried (with paths + naming conventions): [...]
grep invocations run for gap-proofing (verbatim): [...]

## Ranked Candidates
1. [behavior]
   - impact: [named audience + named failure mode]
   - risk: [fault mechanism]
   - gap evidence: [search patterns; nearest existing test file:line; explicit difference]
   - references cited: [file path → decision informed]
   - strategy: [level/tool; failure-mechanism reason it cannot move narrower]
   - cost: [small/medium/large with hours estimate]

## Best Next Test
[first investment; the named regression it catches; the assertion/invariant that would fail; why it beats the alternatives]

## Avoid
[coverage-padding or low-signal tests, each named with the reason]

## Open Questions
[only questions whose answers would materially change the ranking]
```

## test

Write tests only when they protect meaningful behavior. A useful test reduces future user errors, production incidents, support work, debugging time, review time, or release risk. Do not jump straight to implementation or strategy selection.

**Start with code evidence:** inspect the target behavior, implementation, existing tests, fixtures, and commands. After selecting a candidate, load [Test Level Selection](references/test-level-selection/overview.md) before choosing the test layer and [Test Oracles And Assertions](references/test-oracles-and-assertions/overview.md) before writing assertions. Add data, doubles, feedback, or specialized references when those decisions affect signal.

**Workflow:**

1. Inspect code, public behavior, existing tests, fixtures, CI, and test commands in the target scope.
2. Discover the highest-value candidate in scope from product risk, bug-prone areas, code shape, existing coverage gaps, and user/developer impact.
3. Gap-proof the selected candidate. Grep the test suite for tests of comparable scope using entity + state + verb + failure-mode keywords; if a test already protects the failure mechanism with comparable oracle quality, halt and report the existing test rather than writing a duplicate. Production-code inspection alone never proves a gap.
4. Load the right strategy references for that candidate's failure mechanism.
5. Pick the strategy from code evidence plus references: test level, oracle, data/fixture setup, doubles, specialized approach, and feedback loop.
6. State the protected behavior, plausible regression it catches, assertion or invariant that would fail, why it matters, references used, and validation command before editing.
7. Write one focused test using repo-native style and existing helpers.
8. Validate with the smallest relevant command. If it is unsafe or unclear, state that instead of guessing.
9. Review the test for value, signal, maintainability, and developer flow impact.
10. Apply the value gate before finalizing: `KEEP`, `REDO`, or `REMOVE`.

**Output template:**

```markdown
## Candidate
behavior/failure mode chosen: [...]
gap evidence: [search patterns run; nearest existing test file:line; explicit difference]
why it beat alternatives: [...]

## Strategy
test level: [...] (failure-mechanism reason it cannot move narrower)
oracle: [assertion or invariant text]
data/fixtures: [...] (the failure mode each preserves)
doubles: [...] (each named, with the failure mode preserved)
feedback loop: [local/PR/nightly/release/canary/synthetic]
references cited: [file path → decision informed]

## Changes
files changed: [...]
implementation summary: [...]

## Validation
command run (verbatim): [...]
result: [...]
(or: command not run; reason: [...])

## Review
Verdict: KEEP | REDO | REMOVE
Protected behavior: [named concretely]
Audience and failure cost: [...]
Signal strengths: [each tied to the failure mechanism it catches]
False-confidence risks: [each named individually]
Falsification check: [named regression; assertion/invariant that would fail]

## Remaining Risk
[failure modes this test does not cover, named individually]
```

## workload

Generate workloads that exercise meaningful user sessions, not one-off happy-path tests or wrappers around existing runners. A workload should cover important tasks a real user, API client, operator, or background process performs during a session, with adversarial but realistic misuse and controlled variance that changes data, ordering, scale, timing, or optional branches while preserving the same core task.

**Start with code evidence:** inspect the user/session entry points, implementation, existing tests, fixtures, commands, and workload/E2E tooling. Existing workloads should reveal gaps, not become the default implementation. After identifying the actor, goal, bug-prone interactions, and existing workload coverage, load [Workload Modeling](references/workload-modeling/overview.md) and [Test Oracles And Assertions](references/test-oracles-and-assertions/overview.md). Add performance, resilience, security, user-behavior, property-based, fuzzing, or data references only when the workload's risk depends on those dimensions.

**Originality gate:** before editing, state what existing workloads already cover and what the new workload adds. The new workload must introduce at least one of: a new failure surface, adversarial class, oracle/invariant, state model, dependency fault, user/session path, data shape, timing/order dimension, or replay artifact. If the best next step is only a wrapper, runner, seed sweep, or parameter expansion, say that plainly and do not call it a generated workload unless the user asked for that.

**Workflow:**

1. Inspect user/session entry points, implementation, existing tests, fixtures, commands, and workload/E2E tooling.
2. Inventory existing workloads and summarize their actor, failure surface, oracle/invariants, variance, and replay behavior.
3. Identify the user/session goal and the bug-prone interactions the new workload should expose.
4. State the coverage gap: what existing workloads miss and why that gap matters.
5. Load the references that match the workload's failure mechanism.
6. Choose workload type: browser journey, API scenario, CLI/session script, background-job flow, load profile, synthetic monitor, or property/stateful sequence.
7. Define stable invariants and assertions for correctness, not only completion, and decide which checks run after every step, at terminal state, or eventually.
8. Add adversarial classes deliberately: invalid transitions, duplicate/replayed actions, stale state, permission/tenant edges, malformed-but-valid data, boundary sizes, dependency faults, timing/order changes, partial failure or recovery, and explicit error-handling paths.
9. Add controlled variance with seeds, parameter ranges, optional branches, data shape changes, and recorded replay details.
10. Implement with repo-native libraries, fixtures, helpers, or workload tooling when useful, but do not reuse an existing workload unchanged as the generated workload.
11. Validate with the smallest safe command and report seed, coverage of interactions, limits, and residual risk.

**Output template:**

```markdown
## Workload
Actor: [named, with system role]
Goal: [named user/operator task]
Shape: [browser/API/CLI/job/load/synthetic/stateful]
References cited: [file path → decision informed]

## Existing Coverage
Existing workloads found (file:line): [...]
What they cover: [named failure modes]
Gap this workload fills: [named failure mode not covered by any existing workload]
Why this is not only a wrapper/runner/seed sweep: [the new failure surface / adversarial class / oracle / state model / dependency fault / user path / data shape / timing dimension / replay artifact this introduces]

## Coverage
Interactions: [named, each tied to a code path]
Bug-prone areas: [named]
New failure surface/adversarial class/oracle: [named]
Invariants/assertions: [each as text, with the failure mode it catches]

## Adversarial Model
Misuse paths: [each named]
Invalid transitions: [each named]
Boundary inputs: [each named with the boundary]
Duplicate/replayed actions: [each named]
Permission/tenant edges: [each named]
Dependency/time/concurrency faults: [each named with the fault injection method]

## Variance And Replay
Seed: [value]
Variable inputs/branches/timing/scale: [each named with the range]
Replay command (verbatim, copy-pasteable): [...]

## Implementation And Validation
Tooling: [named libraries/helpers]
Files changed: [...]
Validation command (verbatim): [...]
Result: [pass/fail with output excerpt]

## Falsification Check
Named regression: [the bug this workload would catch]
Assertion/invariant that fails under it: [exact text]
Manual mutation or fault tried (if any): [named with result]

## Limits
[environment, data, dependency, runtime, cleanup, or flake risks — each named individually]
```

## review

Review a test as a quality gate, not as a rubber stamp. The test must justify its existence through customer value, production value, support/debugging value, review value, or release confidence.

**Start with code evidence:** inspect the test diff and protected production behavior. Then load [Test Oracles And Assertions](references/test-oracles-and-assertions/overview.md). Add data, doubles, feedback-loop, or mutation references only when the test's value depends on those concerns.

**Workflow:**

1. Inspect the test diff and protected production behavior.
2. Name the behavior or failure mode the test claims to protect. Generic descriptions are invalid; if you cannot name it concretely, return `REMOVE`.
3. Check for prior coverage. Grep the test suite for tests of comparable scope to the protected behavior using entity + state + verb + failure-mode keywords. If an existing test already protects the same failure mechanism with comparable oracle quality, return `REMOVE` (duplicate) regardless of standalone value — duplicate coverage is suite bloat, not signal. Cite the subsuming test by file:line and the assertions it overlaps.
4. Load the references needed to judge the test's strategy, oracle, setup, doubles, and feedback loop.
5. Name the audience the behavior matters to (customer, user, operator, API consumer, release, support/debugging, developer workflow) and the failure cost. A test whose audience cannot be named is suite bloat — return `REMOVE`.
6. Name a plausible regression and verify the assertion would fail under it. If you cannot construct a falsifying mutation, return `REDO`.
7. Verify setup, fixtures, mocks, and data preserve the real failure mechanism. Name any abstraction that removes the failure mode and return `REDO`.
8. Verify the validation command is the smallest one that exercises the failure mechanism, and that CI placement matches the chosen feedback loop. Name a smaller command or a different loop if either applies, and return `REDO`.
9. Issue the verdict: `KEEP`, `REDO`, or `REMOVE`. `REDO` and `REMOVE` must name the failing step and the concrete change required.

**Output template:**

```markdown
Verdict: KEEP | REDO | REMOVE

Prior-coverage check:
search patterns run (verbatim): [...]
nearest existing test (file:line): [...]
subsumes this test: yes/no (cite the assertions overlapped if yes)

Protected behavior:
[named concretely — generic descriptions are invalid]

Audience and failure cost:
[named audience: customer/operator/production/support/release/review/developer-flow; named failure cost]

Signal strengths:
[each tied to the failure mechanism it would catch]

False-confidence risks:
[weak assertions, unrealistic setup, over-mocking, snapshots, flake risk, wrong feedback loop — each named individually]

References cited:
[file path → decision informed]

Falsification check:
[named regression; assertion/invariant that would fail under it]

Required action:
[none for KEEP; exact edit for REDO; removal reason citing the subsuming test or absent failure mode for REMOVE]
```

## doctor

Run a read-only test-suite health scan and report likely concerns with evidence. Do not edit, delete, rewrite, quarantine, or disable tests.

**Start with:** [Test Suite Health Diagnostics](references/test-suite-health-diagnostics/overview.md). Add flake, feedback-loop, pyramid, mutation, data, doubles, or oracle references only after the suite evidence points there.

**Workflow:**

1. Identify repository root, language/framework stack, test runners, CI systems, naming conventions, and test layers.
2. Inventory suite shape and test commands.
3. Scan for weak assertions, excessive mocking, flaky timing, shared state, broad snapshots, slow tests, skipped/quarantined tests, and missing critical-risk coverage.
4. Inspect CI and monitoring signals when available.
5. Grade reliability, speed, signal, diagnostic value, maintainability, risk coverage, and monitoring.

**Output template:**

```markdown
## Scope And Evidence
stack: [language + frameworks + test runners]
CI: [providers + job names]
test commands inventoried (verbatim): [...]
files inspected: [...]
tests run / not run (with reason for not-run): [...]

## Overall
Grade: [A-F or Low/Medium/High trust]
Confidence: [low/medium/high with the evidence that grounds it]

## Top Concerns
1. Severity: [P0-P3]
   Concern: [named]
   Evidence (file:line + observed behavior): [...]
   Why it matters (named audience + named failure cost): [...]
   Required action (named change; not "consider X"): [...]

## Rubric
Reliability: [...]
Speed: [...]
Signal: [...]
Diagnostic value: [...]
Maintainability: [...]
Risk coverage: [...]
Monitoring/CI fit: [...]

## Quick Wins And Questions
[small actions and only material follow-up questions]
```
