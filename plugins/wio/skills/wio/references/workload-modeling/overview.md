# Workload Modeling

## Purpose

Design workloads that exercise important user sessions, API/client behavior, operator tasks, or background flows with enough realism and variance to expose bugs that simple example tests miss.

## Use When / Avoid When

| Use When | Avoid When |
| --- | --- |
| A user session combines multiple interactions, states, roles, data shapes, or dependencies. | One deterministic rule has a clear narrow unit or integration test. |
| Bugs are likely to appear from sequence, timing, data mix, cache state, retries, permissions, or cross-feature interaction. | No safe environment, oracle, or cleanup strategy exists. |
| Performance, E2E, synthetic monitoring, or stateful/property testing needs a representative scenario. | Variance would make failures unreproducible or mask correctness. |

## Core Principles

- Start with a real task: what the user, API client, operator, or job is trying to accomplish during a session.
- Target bug-prone joins: auth, validation, persistence, cache, queues, external providers, concurrency/time, retries/idempotency, migrations, and UI/API boundaries.
- Preserve replayability. Every variable run needs a seed, generated inputs, branch choices, and enough artifacts to reproduce failure.
- Assert invariants and user-visible outcomes throughout the workload, not only final completion.
- Vary meaningful dimensions: roles, account age, data volume, payload shape, locale/time, optional steps, ordering, dependency responses, and think time.
- Keep destructive or expensive workloads in safe environments with cleanup, rate limits, and explicit blast-radius controls.

## Workload Shapes

| Shape | Best Fit |
| --- | --- |
| Browser journey | Critical UI workflows where routing, auth, accessibility, rendering, and backend wiring combine. |
| API scenario | Client sessions that create, update, query, retry, and verify persisted or emitted state. |
| CLI/session script | Developer or operator tasks with filesystem, config, credentials, or process boundaries. |
| Background-job flow | Queues, schedules, retries, idempotency, fanout, and eventual terminal states. |
| Load profile | Realistic traffic mix, payloads, think time, concurrency, and pass/fail thresholds. |
| Stateful/property sequence | Many valid operation sequences with invariants checked after each step. |
| Synthetic monitor | Production-like smoke path that verifies critical availability and contract outcomes. |

## Variance Rules

- Use bounded ranges and weighted choices, not arbitrary randomness.
- Record seed and generated scenario summary on every run.
- Keep the task goal stable even when inputs and branch choices vary.
- Include known edge classes deliberately; do not rely on randomness to discover obvious boundaries.
- Shrink or capture failing cases into deterministic regression tests when possible.

## Output Guidance For Agents

- Name the actor, session goal, interactions, invariants, variance model, replay mechanism, and safe execution command.
- Explain which bug-prone areas the workload is meant to surface.
- State what belongs in this workload versus lower-level focused tests.
- Report limitations: environment realism, data realism, dependency fidelity, runtime cost, flake risk, and cleanup risk.

## Agent Checklist

- Inspect docs, routes, commands, APIs, existing E2E/performance tests, fixtures, and CI jobs.
- Map the session to important product or operational tasks.
- Choose the smallest workload level that preserves the interaction risk.
- Define assertions before adding variance.
- Make failure replay deterministic.
- Validate in a safe environment and record residual risk.

## Source Anchors

- Playwright, [best practices](https://playwright.dev/docs/best-practices)
- Grafana k6, [scenarios](https://grafana.com/docs/k6/latest/using-k6/scenarios/)
- Locust, [writing a locustfile](https://docs.locust.io/en/stable/writing-a-locustfile.html)
- Hypothesis, [stateful testing](https://hypothesis.readthedocs.io/en/latest/stateful.html)
- Google SRE, [Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)
