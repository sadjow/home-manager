# Promotion Matrix

Read this reference when feedback could plausibly map to more than one harness layer or when it is unclear whether the project should retain the learning.

## Apply the promotion gate

Ask these questions in order:

1. Is the observation supported by a reproducible case, repeated history, or a high-consequence risk?
2. Is the underlying cause a project-harness gap rather than a product bug, model limitation, transient environment failure, or personal preference?
3. Is the knowledge specific enough to change future behavior?
4. Is it non-obvious from the code, configuration, or existing canonical documentation?
5. Can a future agent act on it at the right moment?
6. Can the project verify that the chosen control works?

If several answers are no, keep the feedback task-local or make no harness change. High-consequence safety findings may justify promotion without recurrence, but still require evidence and an enforceable response.

## Diagnose before selecting a layer

| Signal | Verify | Likely response |
| --- | --- | --- |
| Agents repeatedly miss a stable project fact | Confirm the fact is absent or undiscoverable | Add it to canonical documentation and route to it concisely |
| A workflow is followed only after detailed coaching | Identify the reusable decisions and inputs | Create or refine an on-demand skill |
| Reviewers repeatedly correct a deterministic pattern | Confirm a machine can identify it reliably | Configure a formatter, linter, test, hook, or CI check |
| Agents repeatedly mistype or reorder commands | Check whether an existing runner can express the sequence | Add or improve a script or task-runner target |
| Agents cannot inspect runtime behavior | Reproduce the visibility gap | Expose logs, traces, screenshots, fixtures, or browser tooling |
| Work is lost across sessions | Confirm current plans or state are missing or stale | Use a versioned progress or decision artifact |
| Safe work requires broad credentials or permissions | Identify the minimum needed capability | Narrow the tool, sandbox, allowlist, or add a human gate |
| A reviewer offers a subjective preference once | Compare it with existing conventions and recurrence | Discuss locally or make no change |
| Guidance exists but agents ignore it | Confirm whether it was loaded and whether it is actionable | Repair discovery, scope, conflict, or enforcement rather than duplicate it |
| A new model no longer needs old scaffolding | Remove one mechanism in a controlled comparison | Prune it if outcomes stay protected |

## Prefer stronger control surfaces

Use advisory prose only for facts and judgment that cannot be enforced mechanically. Move deterministic knowledge into executable controls.

Prefer this progression when the semantics remain correct:

```text
task-local note
      ↓ recurring and project-specific
canonical documentation or skill
      ↓ deterministic and machine-checkable
script, linter, test, hook, or CI
      ↓ authority or blast-radius concern
permission boundary, sandbox, or human gate
```

Do not interpret the progression as a requirement to use every layer. Select one authoritative layer and add only the routing needed to make it discoverable.

## Test nearby alternatives

Before promoting feedback, consider the closest competing explanation:

- The rule exists but conflicts with a more local rule.
- The command is correct but the environment is stale.
- The test failure is flaky or unrelated to the patch.
- The model lacks a capability the repository cannot reasonably supply.
- The feedback asks for a business or architecture decision rather than a reusable control.
- The reviewer is reacting to style while the project already has a different canonical convention.

Escalate a genuine product, business, or architecture decision to its owner. Do not conceal it inside agent instructions.

## Preserve reversibility

Keep a harness change narrow enough to remove independently. Record the source feedback, diagnosed gap, and validation evidence in the existing project mechanism when future maintainers would otherwise be unable to judge whether the control is still needed.
