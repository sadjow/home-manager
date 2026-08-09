---
name: clear-pr-review-comments
description: Verify, prioritize, draft, rewrite, and safely post GitHub pull-request review comments with explicit requiredness, concrete impact, actionable outcomes, duplicate suppression, exact-wording approval, current-head checks, and posting confirmation. Use for inline PR feedback, one-at-a-time review, review summaries, blocker/question/suggestion/nit/praise comments, or requests to post, leave, or publish review comments.
---

# Clear PR Review Comments

Produce the smallest complete comment that tells the author what needs attention, why it matters, and what should happen next. Keep the user in control of every GitHub write.

## Select the mode

- **Prioritize:** Rank verified findings without drafting every comment.
- **Draft:** Write exact proposed comment text without posting.
- **Rewrite:** Improve supplied wording without changing its meaning or requiredness.
- **Post:** Publish only wording that the user explicitly approved.
- **Summarize:** Group posted or unresolved findings without repeating each inline comment.

Default to draft mode when the requested external action is unclear.

## Enforce posting safeguards

- Never infer permission to post from permission to review, prioritize, draft, or rewrite.
- Never post a comment, reaction, review, approval, or change request without explicit approval for the exact action and exact wording.
- Treat every wording, file, line, side, or commit change as a new draft that needs new approval.
- Interpret `post` as approval only when exactly one draft is pending and its target is unambiguous.
- Ask what the user means when phrases such as `leave it` can mean either post or skip.
- Present one draft at a time when the user requests one-at-a-time review.
- Never submit an overall approval or change-request review unless the user approves that separate action.
- Do not modify the pull-request branch while reviewing unless the user separately asks for implementation.

Track each candidate as `draft`, `approved`, `posted`, or `skipped`. Never describe an approved comment as posted.

## Follow the workflow

### 1. Establish current state

Inspect the repository instructions, working tree, PR metadata, current head SHA, complete diff, relevant surrounding code, tests, and existing review comments. For a specification or documentation PR, compare claims with the runtime code and authoritative product documentation.

Record whether the user requested prioritization, drafting, one-at-a-time approval, batch approval, or posting.

### 2. Verify each finding

Trace a concrete actor, input, state, request, or interleaving. Confirm that the PR introduces, exposes, or materially changes the concern.

Keep these categories separate:

- Observed fact
- Supported inference
- Unresolved question
- Product decision
- Optional preference

Do not publish raw speculation. Preserve uncertainty when evidence is incomplete.

### 3. Prioritize before drafting

Rank findings by demonstrated impact, confidence, affected scope, and proximity to the promised flow:

- **P0:** Immediate catastrophic production or critical-data impact.
- **P1:** Approval blocker involving security, authorization, data integrity, or a core promised flow that can fail.
- **P2:** Important correctness, compatibility, maintainability, or usability gap to resolve before implementation or merge.
- **P3:** Optional improvement, polish, or preference.

Put higher-impact and better-supported findings first. Downgrade a severe but conditional concern when the triggering path is not established. Prefer one strong comment over several weak comments.

Show priority outside the exact inline body unless the repository already uses inline labels or the user requests them. If labels are appropriate, use one consistent set such as `Blocking:`, `Question:`, `Suggestion:`, `Nit:`, and `Praise:`.

### 4. Draft one complete concern

Use this sequence when each part adds value:

1. State the finding or required outcome first.
2. Give one minimal failure path or reason.
3. Request the observable contract or decision.
4. Name the test or evidence that proves resolution.

Do not force four sentences. A local edit can need one sentence; a concurrency or security finding can need a short paragraph.

Apply these rules:

- Keep one primary concern per inline comment.
- Name exact identifiers, states, inputs, versions, and outcomes.
- Comment on code and behavior, never the author.
- Use active voice and explicit cause-and-effect connectors.
- Remove throat-clearing, filler, repetition, and background visible beside the diff.
- Request observable behavior before prescribing an implementation.
- Offer a mechanism only as an example when several valid designs exist.
- Do not use `just`, `simply`, `obviously`, or `clearly` to minimize work.
- Use one polite request; do not hide required work under excessive hedging.
- Link authoritative evidence when the finding depends on a surprising external fact.

Preserve all semantic constraints during a rewrite. Never add, remove, strengthen, or weaken:

- Certainty or probability
- Conditions or exceptions
- Negation
- Scope or actor
- Order or timing
- Quantities or limits
- Requiredness

If the source is too ambiguous to preserve these constraints, ask one focused question instead of guessing.

### 5. Present the exact draft

Show:

- Priority and classification outside the body
- File and narrowest changed line
- Exact proposed body
- `post / revise / skip` choices

Do not present the next draft until the current draft is posted or skipped during one-at-a-time review.

### 6. Revalidate before posting

Immediately before posting:

1. Fetch the current PR head.
2. Confirm that the approved commit SHA is still current.
3. Confirm that the target path and line still belong to the diff.
4. Re-read existing comments and suppress duplicates.
5. Confirm that the body exactly matches the approved text.

Use an available GitHub connector when it returns a durable comment ID or URL and preserves the exact body. Otherwise, use `scripts/post_inline_comment.py`:

1. Save the exact body in a temporary file.
2. Run the script without `--execute` to perform a read-only preflight and obtain the approval digest.
3. Show the exact target, body, and digest to the user.
4. After explicit approval, run the same command with `--execute --approval-digest <digest>`.

Never reuse a digest after any target or body change.

### 7. Confirm the external result

Treat the comment as posted only when GitHub returns a comment ID or URL. Share that URL. If the command stops or returns an uncertain result, inspect existing comments before retrying.

## Write review summaries

State the outcome first. Group required findings, questions, and optional feedback. Do not duplicate the full inline bodies.

Example:

```markdown
Two findings block merge:

1. Prevent duplicate jobs after webhook redelivery.
2. Preserve revocation work across a process crash.

The remaining compatibility notes are non-blocking.
```

## Run the final check

Before presenting or posting a comment, confirm:

- The finding is current, verified, and relevant to this PR.
- The priority matches the demonstrated impact and confidence.
- The comment contains one concern.
- The main point appears first.
- The failure path and impact are concrete when needed.
- The requested outcome is observable.
- Important uncertainty remains visible.
- No fact, condition, or requirement changed during rewriting.
- The author can understand the comment and choose the next action after one reading.
- Posting authority exists for this exact target and wording.

## Load references only when needed

- Read [references/examples.md](references/examples.md) when examples or label selection would help.
- Read [references/research-basis.md](references/research-basis.md) when evaluating or revising the skill's rationale. Do not load it for routine drafting.
- Run `python3 scripts/post_inline_comment.py --help` before the first CLI-based post in a session.
