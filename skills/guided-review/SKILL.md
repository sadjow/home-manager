---
name: guided-review
description: "Guide a human through a pull request or branch diff by building a high-level mental model, grouping related changes into an adaptive review order, and walking through one meaningful part at a time. Use when the user wants to understand, inspect, or manually review a change collaboratively. This is comprehension-first: do not turn it into autonomous finding generation, comment drafting, or GitHub posting."
---

# Guided Review

Help the human reviewer understand the change well enough to form their own judgment. Act as a guide through the evidence, not as an autonomous reviewer delivering a findings report.

## Keep the phase boundary clear

- Treat the session as read-only unless the user separately authorizes a local checkout or another mutation.
- Do not modify the branch, submit a review, or post comments.
- Do not make defect hunting, severity ranking, or merge approval the default objective.
- If a question or possible concern appears naturally, distinguish it from a verified finding and let the user choose whether to investigate it now or park it.
- When the user wants to turn selected notes into pull-request feedback, use `$leave-code-review-comments-collaboratively` if it is available.

## Establish the review snapshot

1. Read the repository instructions and inspect the working tree before any checkout.
2. Identify the comparison the user intends:
   - for a pull request, record its base, head SHA, description, linked context, commits, and current diff;
   - for a branch, determine the intended base from repository or upstream evidence and use the merge base;
   - for working-tree changes, keep staged and unstaged changes distinct.
3. Never assume the base branch is named `master` or `main`. State an inferred base explicitly.
4. Record enough immutable identity to notice drift: base revision, head revision, diff range, or working-tree state.
5. Inspect the complete change inventory, including renames, deletions, migrations, tests, generated files, dependency metadata, and documentation. Separate CI status from local validation.

If the head changes during a long session, identify which reviewed parts became stale and refresh those parts before continuing.

## Orient before reading line by line

Give the reviewer a compact opening model:

- the user-visible or operational outcome;
- the motivation and previous limitation;
- the central mechanism that changes the behavior;
- the affected system boundaries;
- the evidence available in tests, migration steps, observability, or documentation.

Keep author claims, code evidence, supported inference, and unresolved uncertainty visibly distinct. If the pull-request description is missing or misleading, say what the diff supports instead of silently repairing the narrative.

## Build a semantic review map

Group the change into coherent parts by related behavior and responsibility, not alphabetical file order, equal line counts, or arbitrary chunk sizes.

Useful grouping signals include:

- an end-to-end user or data flow;
- a contract and the implementations that depend on it;
- domain behavior, integration boundaries, and entry points;
- state, schema, configuration, migration, or rollout changes;
- tests and documentation that express the same behavioral promise;
- mechanical, generated, vendored, or lockfile changes that deserve separate treatment.

Choose an order that reduces prerequisite gaps:

- start with the core change when it gives the smaller pieces meaning, then follow its data or execution flow;
- establish a contract or state model before reviewing dependent adapters;
- start with tests when they are the clearest statement of intended behavior;
- defer mechanical and generated material unless it changes risk or meaning.

Use the order that best fits this diff. Do not claim one order is universally optimal.

Before starting the walkthrough, show a compact roadmap containing each part's purpose, main files or symbols, why it comes at that point, and review status. Account for every changed file or hunk in one primary part, and call out genuinely cross-cutting changes.

## Walk through one part at a time

For the current part:

1. State why the part exists and how it contributes to the overall outcome.
2. Reconstruct the relevant previous behavior before explaining the new path.
3. Trace one representative request, event, value, or state transition through the changed code.
4. Open the surrounding implementation needed to understand the diff instead of relying only on hunk context.
5. Identify the contracts, invariants, tradeoffs, and tests that give the part meaning.
6. Point the human to the few lines, symbols, or decisions that deserve direct inspection.
7. End with one useful checkpoint, question, or invitation to inspect more deeply, then wait for the human before moving to the next part.

Adapt the depth to the reviewer. Compress familiar infrastructure and spend more time on unfamiliar, central, or high-consequence behavior. Update the map when new evidence changes the apparent structure.

Use a diagram only when it materially clarifies a data flow, state transition, timing relationship, or ownership boundary. Keep file and line references clickable when the interface supports them.

## Maintain a review notebook

Keep a lightweight session record so the reviewer does not have to hold the whole diff in working memory:

- part status: `not started`, `current`, `reviewed`, or `revisit`;
- files and important hunks covered by each part;
- confirmed behavior and supporting evidence;
- open questions and assumptions;
- parked observations or possible concerns;
- validation already inspected or run.

Use these evidence labels consistently:

- `observed`: directly shown by code, metadata, or a check;
- `inferred`: strongly suggested but not directly established;
- `question`: missing product or implementation context;
- `possible concern`: a plausible issue that has not been verified;
- `verified finding`: a concrete failure or contract violation supported by evidence.

Do not silently promote one label into another.

## Close with an integrated model

At the end, summarize:

- the outcome, previous behavior, and new mechanism;
- the end-to-end execution or data path;
- the parts reviewed and any stale or intentionally skipped material;
- important contracts, tests, rollout details, and tradeoffs;
- unresolved questions and parked observations, preserving their evidence labels.

Do not manufacture a findings list or approval recommendation to make the session feel complete. If the user asks to draft feedback, hand off only the selected evidence packet: observation, target path and line, concrete impact, desired outcome, requiredness, and remaining uncertainty.

## Research basis

Read [references/research-basis.md](references/research-basis.md) when revising this workflow or evaluating why its structure is effective. It is not required during an ordinary guided review.
