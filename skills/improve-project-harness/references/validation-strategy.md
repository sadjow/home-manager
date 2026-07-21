# Validation Strategy

Read this reference before validating a material, risky, nondeterministic, or token-efficiency harness change.

## Define the claim

Write the improvement claim in observable terms:

```text
For this task class, the changed harness should produce this outcome with fewer failures, interventions, or unnecessary resources, while preserving these invariants.
```

Avoid claims such as “the guidance is clearer” unless a representative task can demonstrate the difference.

## Establish the baseline

Hold the model, task, environment, budget, and acceptance checks stable where practical. Capture:

- current task outcome
- commands and tools used
- human interventions and retries
- context or instruction size
- tokens, latency, and tool calls when available
- policy or invariant violations
- pre-existing failures and environment limitations

Use a clean, resettable environment when hidden state could affect the result.

## Build the smallest representative probe

Prefer a real recent failure. Otherwise create a minimal task that preserves the failure mechanism without encoding the expected solution into the prompt.

Include at least one nearby non-regression case when a change could overfit the original failure. Keep a held-out case for meaningful guidance changes when practical.

For nondeterministic behavior, use repeated paired trials when the decision justifies their cost. Do not draw a strong conclusion from one favorable run.

## Use the validation ladder

Escalate only as needed:

1. Validate syntax, configuration, links, and instruction discovery.
2. Replay the focused failure or task.
3. Run the nearest project checks.
4. Run broader regression or CI-equivalent checks according to risk.
5. Use an independent reviewer for complex correctness, architecture, or security claims.
6. Require a human checkpoint for high-impact, irreversible, or weakly observable outcomes.

Keep CI authoritative even when fast local checks provide the primary iteration loop.

## Evaluate both quality and efficiency

Compare the measures relevant to the claim:

| Dimension | Examples |
| --- | --- |
| Outcome | Task success, acceptance criteria, regression count |
| Behavior | Correct commands, invariant compliance, unnecessary edits |
| Interaction | Retries, loops, invalid actions, human interventions |
| Context | Always-loaded instructions, references opened, duplicated content |
| Cost | Tokens, runtime, tool calls, agent invocations |
| Safety | Permission requests, policy violations, secret or network exposure |

Optimize total verified effort. A smaller prompt that causes retries, broader exploration, or missed requirements is not an efficiency gain.

## Protect evaluator independence

Give a fresh reviewer the task, raw artifact, diff, and acceptance criteria. Do not leak the intended finding or ask the reviewer to manufacture issues. Bound the rubric to correctness, requirements, and material risk so stylistic preferences do not create endless churn.

Calibrate automated or agent reviewers against human judgment before making them blocking controls.

## Decide from evidence

- Keep the change when the target outcome improves and important invariants remain protected.
- Revise it when the mechanism is sound but coverage, discovery, or enforcement is incomplete.
- Revert it when it adds cost, conflict, or regressions without sufficient benefit.
- Make no change when the baseline does not support the original premise.

Report skipped checks and why they were disproportionate, unavailable, or blocked. Never convert an unrun check into an implied pass.
