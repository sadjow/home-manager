# Explanation Patterns

Use this reference when the subject needs more than the core workflow, especially for software artifacts, systems, processes, and difficult conceptual boundaries.

## Layer an explanation

Reveal detail in an order that keeps the mental model stable:

1. Purpose: what problem this solves
2. Model: the smallest useful account of how it works
3. Mechanism: the causal or procedural path
4. Detail: names, implementation, exceptions, and constraints
5. Application: what the model predicts or enables

Each layer should refine the previous one rather than contradict it. If a simplified layer omits an important exception, label the simplification and add the exception when it becomes relevant.

## Choose a representation

| Need | Useful representation | Check |
| --- | --- | --- |
| Make an abstraction concrete | Representative example | Can the user map the example back to the concept? |
| Clarify a boundary | Example plus near non-example | Can the user identify the decisive difference? |
| Show a causal chain | Short flow or annotated trace | Can the user predict the next state? |
| Show hierarchy or ownership | Tree | Can the user locate responsibility? |
| Compare repeated attributes | Table | Can the user choose based on the relevant dimension? |
| Teach a procedure | Worked example with fading | Can the user complete the next step? |
| Build intuition from familiar knowledge | Analogy with explicit mapping | Is the source domain actually familiar? |

Prefer prose when the relationship is already clear in a few sentences.

## Use analogies precisely

An analogy has three parts:

1. The familiar source concept
2. The explicit mapping to the target concept
3. The first important place the analogy breaks

Ask whether the source is familiar before relying on a specialized analogy. Never use the analogy as evidence that the target behaves the same way in unmapped respects.

## Use examples and non-examples

Choose examples that expose the governing rule rather than accidental surface details. When a misconception is predictable, pair the example with the nearest non-example and name the one feature that changes the classification or result.

Vary surface details only after the user has the basic rule. This tests whether the user learned the relationship instead of memorizing the first example.

## Teach procedures with worked examples

For a multistep task:

1. Show one complete solution with reasons at decision points.
2. Ask the user to complete a similar case with one or two steps omitted.
3. Remove more support when performance is accurate.
4. Restore guidance when errors show that support was removed too early.

The goal is adaptive fading, not a fixed number of examples.

## Repair common failures

| Failure | Repair |
| --- | --- |
| The user can repeat the definition but cannot use it | Give a fresh application or prediction task. |
| The explanation is accurate but feels abstract | Add one representative case and trace the mechanism through it. |
| An analogy creates a false inference | State the broken mapping and switch to a direct causal model. |
| The user is lost in names and files | Return to purpose, data flow, and one representative path. |
| The user chooses the right answer for the wrong reason | Contrast it with a nearby case where that reason fails. |
| Repetition is not resolving the gap | Change representation, reduce the step size, or expose a missing prerequisite. |
| The explanation overwhelms an expert | Compress known foundations and focus on deltas, constraints, and edge cases. |

## Software templates

### Code or function

1. Contract: inputs, outputs, side effects, and invariants
2. Purpose in the surrounding system
3. Representative input traced through important branches
4. Failure and boundary behavior
5. Why the implementation uses this shape

### Pull request

1. Outcome for users or operators
2. Previous behavior and its limitation
3. New behavior and the mechanism enabling it
4. Main changes grouped by responsibility, not file order
5. Compatibility, risk, migration, observability, and tests

### Architecture

1. System purpose and external boundary
2. Component responsibilities
3. One end-to-end request, event, or data path
4. Ownership of state and failure recovery
5. Tradeoffs and constraints that explain the design

### Bug

Keep evidence and hypotheses separate:

1. Observed symptom and conditions
2. Expected behavior
3. Earliest known divergence
4. Causal chain from divergence to symptom
5. Fix, why it addresses the cause, and regression coverage

### Process or decision

1. Desired outcome
2. Inputs and constraints
3. Sequence or decision criteria
4. Exceptions and escalation points
5. Example showing the path in use

## Treat named frameworks as idea inventories

Frameworks such as ADEPT can remind an explainer to consider analogies, diagrams, examples, plain language, and technical detail. Treat those elements as a menu. Select and order them according to the subject, user, and evidence rather than presenting the acronym as a validated universal method.
