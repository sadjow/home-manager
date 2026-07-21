---
name: explain-clearly
description: Explain, teach, simplify, or walk through something so the user forms an accurate mental model and can apply it. Use for code, pull requests, architecture, bugs, technical or nontechnical concepts, decisions, documents, processes, comparisons, and requests to learn, study, remember, or understand how or why something works. Calibrate depth and interaction to the user's goal. Use retrieval and spaced practice only when durable learning is requested. Do not trigger for a bare factual lookup that needs only a direct answer.
---

# Explain Clearly

Help the user build an accurate, usable mental model. Use the least instructional structure that accomplishes that goal. A clear explanation should feel like an answer, not a lesson plan imposed on every request.

## Choose the mode

Infer the mode from the request. Ask at most one calibration question, and only when the answer would materially change the explanation. Otherwise, state a brief assumption and begin.

| Mode | Use when | Behavior |
| --- | --- | --- |
| Quick explanation | The user wants an answer, summary, or orientation | Give a concise, standalone explanation. Do not force a quiz or follow-up. |
| Guided understanding | The user wants to understand, compare, or work through something | Layer the explanation and use one aligned check when it would reveal a meaningful gap. |
| Learning or coaching | The user explicitly wants to learn, practice, study, or remember | Work in small exchanges. Prompt one meaningful attempt, give feedback, then continue. |

Match vocabulary and depth to the user's demonstrated knowledge, not a guessed identity or preferred learning style. Give novices more scaffolding and concrete cases. Give experts more compression, precision, edge cases, and tradeoffs.

## Follow the core workflow

### 1. Establish ground truth

Inspect the actual artifact before explaining code, a pull request, a document, logs, or a system. Verify unstable, niche, or high-stakes facts with authoritative sources when tools are available.

Keep these distinct:

- what the source explicitly shows
- the compact model used to make it understandable
- an analogy used for intuition
- an inference or unresolved uncertainty

Never simplify past the point of being materially false.

### 2. Orient

Lead with the user's goal and a one-sentence mental model:

1. What is this for?
2. What is the central idea?
3. Why does it matter in this situation?

Name prerequisites only when they block the explanation. Signpost the few relationships the user must track.

### 3. Build the model

Use this default progression, omitting steps that add no value:

1. Start with one representative concrete case.
2. Explain the causal mechanism or decision path.
3. Introduce the precise term once the idea has a referent.
4. Contrast it with the most tempting misconception or nearby alternative.
5. Apply the model to the user's actual case.

Choose representations deliberately:

- Use an example when the idea is abstract.
- Use an example and non-example when a boundary is easy to confuse.
- Use an analogy only when the source domain is likely familiar. Map the correspondence and state where it breaks.
- Use a diagram only when spatial, temporal, causal, hierarchical, or comparative structure is easier to see than read.
- Use a worked example for a procedure or multistep problem. Fade steps as demonstrated competence increases.

Do not force every technique into one explanation. Avoid decorative stories, duplicate prose and diagrams, arbitrary chunk counts, and jargon before meaning.

### 4. Verify when useful

Do not use “Does that make sense?” as the main check. Choose a check aligned to the goal:

- prediction for a causal model
- application to a fresh case for transfer
- comparison for conceptual boundaries
- explain-back for an integrated mental model
- execution or diagnosis for a procedure

In learning or coaching mode, ask one check at a time and wait for the user's response. In a quick explanation, usually finish with a compact summary instead.

Treat confidence and fluent wording as weak evidence. Judge the reasoning or application itself.

### 5. Repair a gap

When the user's attempt is incomplete or wrong:

1. Preserve what is correct.
2. Identify the smallest consequential gap.
3. Explain why it changes the result.
4. Switch representation or use a contrasting case instead of repeating the same wording.
5. Check the repaired point with a fresh example when the mode calls for interaction.

Keep correction specific and respectful. Do not make the user persist in an unproductive failure state.

### 6. Reinforce only when requested

For deliberate learning or durable retention:

- Ask for retrieval before restating, but provide a cue when recall is failing.
- Give corrective feedback after the attempt and revisit the idea later.
- Space later checks according to performance and available time. Do not present one interval schedule as universally optimal.
- Interleave related, confusable categories after the user has a basic model. Do not mix material indiscriminately.
- Use mnemonics for arbitrary associations or ordered information, not as a substitute for understanding.

Read [learning and retention](references/learning-and-retention.md) before designing a study sequence.

## Explain software changes

For code, pull requests, architecture, and bugs, lead with behavior rather than a file inventory:

1. User-visible purpose or operational outcome
2. Previous behavior or failure mode
3. New mental model and execution path
4. Important files, functions, data, or boundaries
5. Risks, invariants, tradeoffs, and tests

Trace one representative input through the system when control flow or data flow is central. Separate observed behavior from suspected causes during diagnosis.

Read [explanation patterns](references/explanation-patterns.md) for artifact-specific templates and difficult explanations.

## Evidence boundaries

Avoid claims that exceed the evidence:

- Do not classify users by a visual, auditory, or kinesthetic learning style.
- Do not call effort, confusion, or struggle beneficial by itself.
- Do not claim that explaining something simply proves complete understanding.
- Do not treat one branded framework as a validated universal sequence.
- Do not imply that more detail, more modalities, or more interaction always improves learning.

Read [evidence and boundaries](references/evidence-and-boundaries.md) when evaluating teaching claims, refining this skill, or explaining why a method was chosen.

## Write for comprehension

- Put the answer before background.
- Keep one main idea per paragraph.
- Define unavoidable terms at first use.
- Use headings only when they expose real structure.
- Prefer concrete verbs and explicit relationships.
- End a standalone explanation with the smallest useful synthesis.
- Make uncertainty and assumptions visible without burying the answer.
