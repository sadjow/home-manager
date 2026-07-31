---
name: review-pr-collaboratively
description: Review GitHub pull requests locally with evidence-backed findings, end-to-end use of the explain-clearly skill, and guarded inline-comment posting. Use when asked to check out or review a PR, validate a specification against existing code, understand or explain a change, discuss findings before commenting, draft clear professional review comments, propose comments one at a time for approval, post only approved comments, visualize complex behavior, or prepare a concise team handoff.
---

# Review PR Collaboratively

Read this file completely before taking review action. All PR-review guidance is contained here; `$explain-clearly` remains a required companion skill and must also be read completely.

Review the change deeply, update conclusions when product context changes, and keep the user in control of every external write.

## Load the required companion skill

Before taking any review action, load and read `$explain-clearly` completely from the available skills catalog. Announce that both skills are being used. Apply `$explain-clearly` throughout the entire review, not only when presenting the final findings.

Use it to:

- understand the PR from its user-visible purpose before inspecting implementation trivia;
- reconstruct the previous behavior, intended behavior, mechanism, risks, and tests;
- investigate every suspected issue through a concrete request, input, state transition, or interleaving;
- explain findings to the user in small pieces and incorporate their product context;
- write comments that another reviewer can understand without the surrounding chat;
- prepare concise review summaries and team handoffs.

Apply the companion skill's current workflow: establish ground truth, orient, build the model, verify when useful, repair gaps, and reinforce only when requested. If `$explain-clearly` is unavailable, say so briefly and apply those steps manually.

## Enforce non-negotiable safeguards

- Treat a review request as read-only except for an explicitly requested local checkout.
- Never infer permission to post from permission to review. Respect requests such as “do not leave comments.”
- Never post an inline comment, review, reaction, approval, or change request without explicit approval for that exact action and wording.
- When the user requests one-at-a-time review, present exactly one draft, wait for `post`, `revise`, or `skip`, then continue.
- Treat any wording revision as invalidating prior approval.
- Clarify ambiguous external-action phrases such as “leave it” when they could mean either post or skip.
- Preserve tracked and untracked local work. Inspect status before checkout and avoid overwriting unrelated changes.
- Do not modify the PR branch while reviewing unless the user separately asks for implementation.

## Track comment state explicitly

Maintain each candidate as one of:

1. `draft` — discussed but not approved
2. `approved` — exact wording approved but not yet confirmed posted
3. `posted` — the GitHub response returned a comment ID or URL
4. `skipped` — the user chose not to post it

Never describe an approved comment as posted. If a posting command is interrupted or returns an uncertain result, inspect existing PR comments before retrying so a duplicate is not created.

## Follow the review workflow

### 1. Establish scope and authority

- Capture the requested behavior: local review only, draft comments, one-by-one approval, batch review, or team summary.
- Record explicit prohibitions and later changes to them.
- Default to review-only when posting authority is unclear.

### 2. Prepare the local review

- Read repository instructions and applicable language, framework, testing, security, or schema skills.
- Inspect `git status`, current branch, remotes, and PR metadata before checkout.
- Fetch the current base and head. Check out the PR branch only when requested or clearly authorized.
- State the user-visible purpose in one sentence, then build a `Before / After / Mechanism / Risks / Tests` mental model as evidence is gathered.
- Inspect the complete diff plus existing code that the change depends on. For documentation-only or specification PRs, verify claims against runtime code rather than reviewing prose in isolation.
- Run focused validation proportional to risk. Report CI state separately from local checks.

### 3. Build evidence-backed findings

- Reproduce a concrete failure path or inconsistency before labeling it a defect.
- Start each candidate from a realistic example or timeline, then name the general problem.
- Distinguish among:
  - correctness, security, data-loss, or concurrency defects;
  - unresolved product decisions;
  - missing but necessary workflow pieces;
  - optional enhancements or preferences.
- Reassess findings when the user supplies product context. Downgrade, rewrite, or remove a finding that a clear product decision resolves.
- Apply only the relevant **Review lenses** below and convert them into concrete evidence, not slogans.

### 4. Explain every finding before drafting

Use `$explain-clearly` for every candidate finding in this order:

1. desired outcome;
2. concrete sequence or example;
3. why current behavior can violate it;
4. smallest useful contract or implementation change;
5. test that proves the outcome.

Use a small Mermaid diagram when timing, state transitions, ownership, or multiple actors are materially clearer visually. Keep diagrams compact enough for a PR comment.

### 5. Draft a professional inline comment

Anchor the comment to the narrowest relevant changed line. Use this shape:

```text
Observation or concrete scenario.
Why it matters to the user or system.
Polite, actionable request.
Optional test or acceptance rule.
```

- Prefer plain, professional language such as “It would be helpful to…” or “Could we make this explicit…”.
- Make the comment self-contained: include enough of the concrete scenario for the author to understand the concern without reading the review conversation.
- Avoid accusation, canned praise, excessive hedging, severity labels in the body, and references to AI unless the user requests them.
- Request observable behavior before prescribing an implementation. Offer locking, atomic consumption, or similar mechanisms as examples when useful.
- Show the file and line, the exact proposed text, and `post / revise / skip` choices.
- Do not present the next comment until the current one is posted or skipped when working one at a time.

### 6. Post only the approved draft

- Re-fetch the PR head immediately before posting.
- Confirm the target path and line still belong to the current diff. Re-anchor or ask before posting if the PR changed.
- Use an available GitHub connector or `gh` CLI. Post the exact approved body; do not silently polish it during submission.
- Treat a returned comment ID or URL as confirmation, share the link, then present the next draft.
- Never submit an overall approval or change-request review unless the user explicitly asks for that separate action.

### 7. Close the review

Summarize:

- posted comment links;
- skipped or unresolved candidates;
- validation performed and its outcome;
- checked-out branch and working-tree state;
- remaining blockers versus optional follow-ups.

When asked for a Slack or team message, produce a concise paste-ready note that states the review outcome, major themes, and whether AI assisted the review only if the user wants that disclosed.

## Apply review lenses selectively

### Pragmatic Programmer lenses

- **Easy to Change:** Prefer contracts and boundaries that can evolve without rewriting unrelated areas.
- **DRY:** Keep each business rule in one authoritative place. Watch for status or permission checks duplicated inconsistently across UI, domain, and authentication paths.
- **Orthogonality:** Separate concerns that change for different reasons, while avoiding artificial splits that make one user workflow incomplete.
- **Reversibility:** Preserve extension points around uncertain future choices. Do not hardcode a future role model before it is designed.
- **Tracer Bullets:** Favor a thin, working end-to-end slice that proves the architecture and user workflow.
- **Design by Contract:** State preconditions, transitions, outcomes, and failure behavior explicitly.
- **Shared state requires coordination:** A transaction makes one operation atomic; it does not automatically serialize competing operations. Identify the row, token, or resource on which contenders coordinate.
- **Avoid programming by coincidence:** Challenge assumptions such as “this existing login path will probably respect the new status” or “validation inside a transaction prevents the race.”
- **Test to the contract:** Ask for tests that prove observable guarantees, especially negative paths and meaningful interleavings.
- **Delight users:** Ensure the feature has an entry point and a usable management path, not only correct backend functions.

### Specification-review checklist

For OpenSpec, ADR, RFC, or design-document PRs, compare the proposal with current code and ask:

1. What user-visible entry point starts the workflow?
2. Are all states and allowed transitions defined?
3. Do existing password, token, session, API, and background-job paths honor the new state?
4. Are submitted fields validated and actually persisted?
5. Do web responsibilities and domain responsibilities remain separated?
6. Can concurrent operations both report success when only one should win?
7. Are failure, retry, delivery, and stale-link outcomes defined?
8. Do tasks and tests cover every normative requirement?
9. Is a stated open question actually a blocking product decision?
10. Can the first release be used without manually constructing URLs or editing data?

### Severity calibration

- **P0:** Immediate catastrophic impact across production or critical data.
- **P1:** Approval blocker involving security, authorization, data integrity, or a core promised flow that can fail.
- **P2:** Important correctness, maintainability, or usability gap that should be addressed before implementation or merge.
- **P3:** Optional improvement, polish, or preference; do not frame it as a blocker.

State severity in the review summary when useful. Keep inline comment bodies centered on the scenario, consequence, and requested outcome.

### Concurrency explanation pattern

Use a minimal interleaving:

```text
Operation A reads valid state.
Operation B changes that state and commits.
Operation A writes based on its earlier read and commits.
Both report success, violating the contract.
```

Then define the serial outcome:

- B first means A fails.
- A first means B fails or observes the new state.
- Both must never report success.

Mention row locking, conditional updates with checked row counts, or atomic consumption only as candidate mechanisms unless the design must mandate one.

## Scope AI-assisted delivery coherently

Treat AI as reducing implementation cost, not correctness cost. Ambiguity, integration mistakes, security gaps, and review load remain expensive.

- Split work by conceptual cohesion and independent acceptance, not developer hours, typing effort, or estimated coding time alone.
- Prefer a complete vertical slice when the concepts belong together and can be accepted independently.
- Include a basic supporting surface when it completes the user journey and remains coherent with the change.
- Defer independently valuable polish such as advanced filtering, pagination, permissions, or design-system work.
- Do not call correctness scope creep. Authentication coverage, data persistence, idempotency, and race handling belong with the behavior they protect.
- Keep genuinely different decisions—such as a future authorization model—decoupled when combining them would increase ambiguity or risk.
