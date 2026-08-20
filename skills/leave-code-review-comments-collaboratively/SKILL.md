---
name: leave-code-review-comments-collaboratively
description: Collaborate with a human to turn already surfaced pull-request observations or verified findings into clear, prioritized inline or summary comments, then post only the exact approved target and wording. Use when the user wants to draft, refine, approve, or post feedback on a GitHub pull request. Do not use for the initial walkthrough, broad change understanding, or autonomous finding generation; use guided-review for that phase.
---

# Leave Code Review Comments Collaboratively

Help the human decide what feedback to leave and express it precisely. Begin from an observation, question, or finding that already exists. Inspect only enough surrounding code and pull-request state to verify that feedback and anchor it safely.

## Keep the phase boundary clear

- Do not turn a comment request into a new broad review or a search for additional findings.
- Do not modify the pull-request branch or implement the requested change.
- Use `$guided-review` when the human first needs a high-level model or a part-by-part walkthrough.
- Accept notes from a guided review, the human's own review, another reviewer, test evidence, or an already completed analysis.
- Preserve the human's intended requiredness and uncertainty. Do not strengthen a question into a defect or soften required work into a suggestion.

## Select the mode

- **Triage:** Decide which supplied notes warrant comments and in what order.
- **Draft:** Produce exact proposed wording and an anchor without posting.
- **Refine:** Improve supplied wording without changing its meaning.
- **Approve:** Track the human's decision for one exact target and body.
- **Post:** Publish only an approved target and body after a fresh preflight.
- **Summarize:** Group posted, skipped, or unresolved feedback without repeating every inline body.

Default to draft mode when the requested external action is unclear.

## Track authority and state

Maintain each candidate as one of:

1. `draft`: wording or target is still under discussion;
2. `approved`: the human approved the exact target and exact body, but posting is not confirmed;
3. `posted`: GitHub returned a durable comment ID or URL;
4. `skipped`: the human chose not to post it.

Never describe approval as posting. Any change to the body, path, line, side, or commit invalidates approval. If a command is interrupted or the result is uncertain, inspect existing comments before retrying.

When the human requests one-at-a-time review, present exactly one draft and wait for `post`, `revise`, or `skip` before continuing. Interpret `post` as approval only when one pending draft and its target are unambiguous. Clarify phrases such as `leave it` when they could mean either post or skip.

## Build the evidence packet

For each supplied note, establish:

- the pull request and current head SHA;
- the narrowest useful changed path and line or range;
- the observed behavior or unresolved question;
- one concrete actor, input, state transition, request, or interleaving when impact depends on a sequence;
- the expected outcome or decision;
- requiredness and remaining uncertainty;
- relevant test, runtime result, contract, or authoritative source.

Reuse this packet from `$guided-review` when available. If evidence is incomplete, inspect the diff and surrounding implementation only for this candidate. Ask one focused question or keep the uncertainty visible instead of inventing support.

## Verify before drafting

Confirm that the pull request introduces, exposes, or materially changes the concern. Keep these categories separate:

- observed fact;
- supported inference;
- unresolved question;
- product or design decision;
- optional preference.

Do not draft a factual defect claim from raw speculation. When verification disproves the candidate, discard it and explain why. When the issue predates the pull request and the change does not worsen it, avoid an inline blocker; consider a clearly scoped follow-up only if the human wants one.

## Decide whether a comment adds value

Before writing:

- read existing review comments and suppress duplicates;
- consolidate repeated instances of one root cause at the most representative location;
- choose inline feedback for a local, actionable concern and summary feedback for cross-cutting context;
- prefer one strong, well-supported comment over several weak or repetitive comments;
- separate required changes, questions, optional suggestions, nits, and specific praise.

When multiple comments exist, order them by demonstrated impact, confidence, and proximity to the promised flow. Use priority outside the exact body unless repository convention or the human asks for a label:

- **P0:** immediate catastrophic production or critical-data impact;
- **P1:** merge blocker involving security, authorization, data integrity, or a core promised flow;
- **P2:** important correctness, compatibility, maintainability, or usability issue to resolve before merge;
- **P3:** optional improvement, polish, or preference.

## Draft one complete concern

Use only the parts that add value:

1. Put the observation, question, or required outcome first.
2. Give the smallest concrete scenario or reason needed to understand its impact.
3. Request an observable outcome or decision.
4. Name a test or acceptance condition when it would remove ambiguity.

Keep one primary concern per comment. Name exact identifiers, states, inputs, versions, and outcomes. Comment on the code and behavior, never the author. Use active voice and plain cause-and-effect language. Remove filler, canned praise, accusation, and excessive hedging.

Request behavior before prescribing implementation. Offer a mechanism as an example when several designs are valid. Preserve conditions, exceptions, negation, timing, quantities, scope, certainty, and requiredness during every rewrite.

## Present the exact draft

Show:

- priority and classification outside the body;
- path, line or range, diff side, and head SHA;
- the exact proposed body;
- `post / revise / skip` choices.

Do not silently polish the text after approval.

## Revalidate and post safely

Immediately before posting:

1. Fetch the current pull-request metadata.
2. Confirm that the approved head SHA is still current.
3. Confirm that the target still belongs to the current diff.
4. Re-read existing comments and suppress duplicates.
5. Confirm that the exact body still matches the approved text.

Use an available GitHub connector when it preserves the exact body and returns a durable comment ID or URL. Otherwise use `scripts/post_inline_comment.py`:

1. Save the exact body in a temporary file.
2. Run the script without `--execute` for a read-only preflight and approval digest.
3. Show the exact target, body, and digest to the human.
4. After explicit approval, rerun with `--execute --approval-digest <digest>`.

Never reuse a digest after the head, target, or body changes. Never submit an overall approval, request-changes review, reaction, or separate summary comment unless the human explicitly authorizes that distinct action and exact wording.

Treat a comment as posted only when GitHub returns an ID or URL. Share the URL before moving to the next candidate.

## Close the comment session

Summarize the outcome first:

- posted comments with links;
- skipped drafts;
- unresolved or unverified notes;
- any candidate invalidated by new evidence;
- the head SHA against which posting was confirmed.

Do not duplicate the full inline bodies in the summary.

## Load supporting resources only when needed

- Read [references/examples.md](references/examples.md) when examples or label selection would help.
- Read [references/research-basis.md](references/research-basis.md) when evaluating or revising the workflow's rationale.
- Run `python3 scripts/post_inline_comment.py --help` before the first CLI-based post in a session.
