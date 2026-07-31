---
name: explain-clearly
description: Explain, teach, simplify, or walk through something so the user forms an accurate mental model and can apply it. Use for code, pull requests, architecture, bugs, technical or nontechnical concepts, decisions, documents, processes, comparisons, and requests to learn, study, remember, or understand how or why something works. Calibrate depth and interaction to the user's goal. Use retrieval and spaced practice only when durable learning is requested. Do not trigger for a bare factual lookup that needs only a direct answer.
---

# Explain Clearly

Read this file completely before responding. It is self-contained: use its later sections selectively, but do not skip reading them.

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

Apply the **Learning and retention** section when designing a study sequence.

## Explain software changes

For code, pull requests, architecture, and bugs, lead with behavior rather than a file inventory:

1. User-visible purpose or operational outcome
2. Previous behavior or failure mode
3. New mental model and execution path
4. Important files, functions, data, or boundaries
5. Risks, invariants, tradeoffs, and tests

Trace one representative input through the system when control flow or data flow is central. Separate observed behavior from suspected causes during diagnosis.

Apply the **Explanation patterns** section for artifact-specific templates and difficult explanations.

## Evidence boundaries

Avoid claims that exceed the evidence:

- Do not classify users by a visual, auditory, or kinesthetic learning style.
- Do not call effort, confusion, or struggle beneficial by itself.
- Do not claim that explaining something simply proves complete understanding.
- Do not treat one branded framework as a validated universal sequence.
- Do not imply that more detail, more modalities, or more interaction always improves learning.

Apply the **Evidence and boundaries** section when evaluating teaching claims, refining this skill, or explaining why a method was chosen.

## Write for comprehension

- Put the answer before background.
- Keep one main idea per paragraph.
- Define unavoidable terms at first use.
- Use headings only when they expose real structure.
- Prefer concrete verbs and explicit relationships.
- End a standalone explanation with the smallest useful synthesis.
- Make uncertainty and assumptions visible without burying the answer.

## Explanation patterns

Use these patterns when the subject needs more than the core workflow, especially for software artifacts, systems, processes, and difficult conceptual boundaries.

### Layer an explanation

Reveal detail in an order that keeps the mental model stable:

1. Purpose: what problem this solves
2. Model: the smallest useful account of how it works
3. Mechanism: the causal or procedural path
4. Detail: names, implementation, exceptions, and constraints
5. Application: what the model predicts or enables

Each layer should refine the previous one rather than contradict it. If a simplified layer omits an important exception, label the simplification and add the exception when it becomes relevant.

### Choose a representation

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

### Use analogies precisely

An analogy has three parts:

1. The familiar source concept
2. The explicit mapping to the target concept
3. The first important place the analogy breaks

Ask whether the source is familiar before relying on a specialized analogy. Never use the analogy as evidence that the target behaves the same way in unmapped respects.

### Use examples and non-examples

Choose examples that expose the governing rule rather than accidental surface details. When a misconception is predictable, pair the example with the nearest non-example and name the one feature that changes the classification or result.

Vary surface details only after the user has the basic rule. This tests whether the user learned the relationship instead of memorizing the first example.

### Teach procedures with worked examples

For a multistep task:

1. Show one complete solution with reasons at decision points.
2. Ask the user to complete a similar case with one or two steps omitted.
3. Remove more support when performance is accurate.
4. Restore guidance when errors show that support was removed too early.

The goal is adaptive fading, not a fixed number of examples.

### Repair common failures

| Failure | Repair |
| --- | --- |
| The user can repeat the definition but cannot use it | Give a fresh application or prediction task. |
| The explanation is accurate but feels abstract | Add one representative case and trace the mechanism through it. |
| An analogy creates a false inference | State the broken mapping and switch to a direct causal model. |
| The user is lost in names and files | Return to purpose, data flow, and one representative path. |
| The user chooses the right answer for the wrong reason | Contrast it with a nearby case where that reason fails. |
| Repetition is not resolving the gap | Change representation, reduce the step size, or expose a missing prerequisite. |
| The explanation overwhelms an expert | Compress known foundations and focus on deltas, constraints, and edge cases. |

### Software templates

#### Code or function

1. Contract: inputs, outputs, side effects, and invariants
2. Purpose in the surrounding system
3. Representative input traced through important branches
4. Failure and boundary behavior
5. Why the implementation uses this shape

#### Pull request

1. Outcome for users or operators
2. Previous behavior and its limitation
3. New behavior and the mechanism enabling it
4. Main changes grouped by responsibility, not file order
5. Compatibility, risk, migration, observability, and tests

#### Architecture

1. System purpose and external boundary
2. Component responsibilities
3. One end-to-end request, event, or data path
4. Ownership of state and failure recovery
5. Tradeoffs and constraints that explain the design

#### Bug

Keep evidence and hypotheses separate:

1. Observed symptom and conditions
2. Expected behavior
3. Earliest known divergence
4. Causal chain from divergence to symptom
5. Fix, why it addresses the cause, and regression coverage

#### Process or decision

1. Desired outcome
2. Inputs and constraints
3. Sequence or decision criteria
4. Exceptions and escalation points
5. Example showing the path in use

### Treat named frameworks as idea inventories

Frameworks such as ADEPT can remind an explainer to consider analogies, diagrams, examples, plain language, and technical detail. Treat those elements as a menu. Select and order them according to the subject, user, and evidence rather than presenting the acronym as a validated universal method.

## Learning and retention

Use this section only when the user wants durable learning, practice, or a study sequence. An ordinary explanation does not need every technique here.

### Separate performance from learning

Fast, fluent performance during an explanation can reflect recent exposure. Durable learning is better indicated by successful retrieval and application after some delay or in a changed context.

State the intended horizon. Preparing for an immediate task, retaining knowledge for months, and building flexible transfer need different practice.

### Retrieval with feedback

Use this loop:

1. Give a cue that requires the target idea, not trivia around it.
2. Let the user make a viable attempt before revealing the answer.
3. If recall stalls, narrow the cue or provide a partial prompt.
4. Give specific corrective feedback.
5. Recheck the corrected idea later with changed surface details.

Retrieval is not a license for prolonged guessing. An unsupported failed attempt can rehearse an error or consume attention without strengthening the target response.

Prefer prompts such as:

- “What would happen next, and why?”
- “Which principle applies to this new case?”
- “Explain the mechanism without using the original example.”
- “What is the decisive difference between these two cases?”

### Self-explanation and teach-back

Ask the user to connect steps, justify a choice, or explain a mechanism in their own words. Then inspect the explanation for missing causal links and false claims.

The act of explaining can expose gaps and improve integration, but simple wording is not proof of mastery. Verify with prediction, application, comparison, or execution.

Use prompts selectively. Too many prompts can interrupt a worked example and add unnecessary load.

### Spacing

Revisit knowledge after some forgetting, then adjust based on performance:

- shorten the next interval after an incorrect or heavily cued response
- lengthen it after accurate, unassisted retrieval
- revisit important weak points sooner than stable ones
- include a delayed application when transfer matters

The best interval depends on the desired retention period, material, prior knowledge, and success on earlier retrievals. Do not claim that one expanding schedule or a fixed sequence of days is universally optimal.

When no scheduling system exists, offer a clearly labeled starting heuristic and invite adjustment from actual recall. Do not present the heuristic as a research-derived optimum.

### Interleaving

Interleave practice when the learner must discriminate among related problem types, categories, or strategies. Establish a workable model first, then mix cases that require choosing the right method.

Do not interleave unrelated material merely to increase difficulty. The benefit depends on the task and can trade short-term fluency for better later discrimination.

### Generation and prediction

Ask for a prediction, next step, or provisional solution before revealing the explanation when the user has enough information to attempt it. Follow immediately with the correct model and why it applies.

Generation is useful when it activates relevant knowledge or makes a contrast visible. It is not useful when the prompt is effectively random guessing.

### Productive difficulty

Add difficulty only when it serves the learning goal and the learner can recover with available support. Useful difficulty often means retrieving, selecting among confusable options, or applying the model in a changed context.

Confusion, time spent, and effort alone are not evidence of learning. Reduce the step, restore a worked example, or give a cue when the current challenge stops producing informative attempts.

### Mnemonics and memory aids

Use acronyms, loci, imagery, or stories for arbitrary associations, ordered lists, terminology, and other recall-heavy material. Keep the mapping unambiguous and test recall in both directions when needed.

Do not let a memory aid replace the causal or conceptual model. A vivid story can improve access to labels while leaving application unchanged.

### Build a compact study sequence

A practical sequence can combine the methods without turning them into rituals:

1. Orient with the purpose and compact model.
2. Study a worked example or representative case.
3. Explain one causal step or predict one outcome.
4. Apply the model to a fresh case and receive feedback.
5. Retrieve it again after a delay.
6. Mix it with a confusable case once basic performance is stable.

Track which retrievals were independent, cued, or incorrect. Use that evidence to decide what comes next.

## Evidence and boundaries

Evidence reviewed on 2026-07-21. This section records the basis and limits for the skill's instructional choices. Keep quantitative claims here rather than turning the main workflow into a literature review.

### Cognitive load and expertise

Modern cognitive load theory distinguishes task-inherent demands from avoidable demands caused by instruction. It treats germane resources as working-memory resources devoted to learning, not as a third independent additive load. The practical implication is to remove irrelevant complexity while preserving the relationships the user must learn.

- [Sweller, van Merriënboer, and Paas, 2019](https://doi.org/10.1007/s10648-019-09465-5)
- [Cowan, 2001](https://doi.org/10.1017/S0140525X01003922)
- [Cowan, 2010](https://doi.org/10.1177/0963721409359277)

Instructional support should change with expertise. Worked examples tend to help novices, while redundant guidance can lose value or interfere as knowledge increases. Do not infer expertise from confidence alone.

- [Najar and Mitrovic, 2025](https://doi.org/10.1016/j.learninstruc.2025.102142)
- [Wang and Adesope, 2023](https://doi.org/10.1007/s10648-023-09745-1)

Boundary: working-memory findings do not justify a universal number of chunks, bullets, steps, or concepts per response.

### Self-explanation and learning by teaching

Self-explanation prompts can improve learning, especially when they elicit causal connections and inference. Effects depend on prompt design, prior knowledge, feedback, and the surrounding instruction. Adding prompts to every worked step is not automatically beneficial.

- [Bisra et al., 2018](https://doi.org/10.1007/s10648-018-9434-x)
- [Digital self-explanation meta-analysis, 2025](https://doi.org/10.1007/s10648-025-10001-x)
- [Digital prompt meta-analysis, 2025](https://doi.org/10.1016/j.edurev.2025.100686)

Preparing to teach and explaining to others can support learning, but the effect is not evidence that any simple explanation proves mastery. Inspect correctness and test application.

- [Kobayashi, 2019](https://doi.org/10.1111/jpr.12221)
- [Learning by teaching meta-analysis, 2024](https://doi.org/10.1007/s10648-024-09871-4)

Boundary: the “Feynman technique” is a useful popular label for explanation and gap detection, not a distinct evidence base that validates a fixed four-step ritual.

### Retrieval, feedback, and transfer

Retrieval practice has robust benefits across classroom settings, but task design, successful retrieval, corrective feedback, and alignment with the later use matter. Transfer beyond the practiced form is positive on average and varies with the distance and nature of transfer.

- [Yang et al., 2021](https://doi.org/10.1037/bul0000309)
- [Agarwal, Nunes, and Blunt, 2021](https://doi.org/10.1007/s10648-021-09595-9)
- [Pan and Rickard, 2018](https://doi.org/10.1037/bul0000151)
- [Wisniewski, Zierer, and Hattie, 2020](https://doi.org/10.3389/fpsyg.2019.03087)

Boundary: retrieval does not mean leaving a learner to struggle indefinitely. Cueing and corrective feedback are part of a sound repair loop.

### Spacing and successive relearning

Distributed practice improves long-term retention relative to massed practice. Effective intervals depend on the retention goal and context. Repeated successful retrieval across spaced sessions, sometimes called successive relearning, is a useful combined pattern.

- [Cepeda et al., 2008](https://doi.org/10.1111/j.1467-9280.2008.02209.x)
- [Latimier et al., 2021](https://doi.org/10.1007/s10648-020-09572-8)
- [Classroom distributed-practice meta-analysis, 2025](https://doi.org/10.3390/bs15060771)

Boundary: no fixed schedule such as 1, 3, 7, and 14 days is universally optimal. Cramming can improve immediate performance while remaining a poor default for durable retention.

### Interleaving

Interleaving is most defensible when practice requires discriminating among categories or selecting among strategies. Effects are heterogeneous and sensitive to material and task design.

- [Brunmair and Richter, 2019](https://doi.org/10.1037/bul0000209)

Boundary: mixing unrelated material or increasing difficulty indiscriminately is not an evidence-based goal.

### Multimedia and signaling

Visuals, signaling, and segmentation can help when they expose relationships and reduce avoidable search. Redundant or decorative material can add load, and accessibility needs may require equivalent text even when duplication is not ideal for learning efficiency.

- [Multimedia learning systematic review, 2022](https://doi.org/10.1186/s40561-022-00200-2)
- [Richter, Scheiter, and Eitel, 2018](https://doi.org/10.1016/j.edurev.2017.11.001)
- [Rey et al., 2019](https://doi.org/10.1007/s10648-018-9456-4)
- [Redundancy-principle review, 2023](https://doi.org/10.3389/fpsyg.2023.1148035)

Boundary: visuals are conditional tools, not mandatory ingredients. Never remove accessible alternatives merely to avoid redundancy.

### Learning styles

Do not classify or teach users as visual, auditory, or kinesthetic learners. A 2024 meta-analysis reported a small aggregate matching effect alongside extreme heterogeneity, possible publication bias, and the required crossover interaction in only a minority of qualifying studies. This does not support using learning-style inventories to prescribe explanation modality.

- [Aslaksen and Lorås, 2024](https://doi.org/10.3389/fpsyg.2024.1428732)

Instead, choose representations based on the structure of the material, the task, accessibility, prior knowledge, and observed performance.

### Generative AI explanations

Structured AI tutoring can improve learning in bounded settings, but evidence for one system, course, or implementation does not validate every generated explanation. Accuracy, sequencing, feedback, and learner activity remain central.

- [Kestin et al., 2025](https://doi.org/10.1038/s41598-025-97652-6)
- [Generative AI learning meta-analysis, 2026](https://doi.org/10.3389/fpsyg.2026.1758670)

Boundary: treat generated content as instruction that still requires source checking and task-aligned evaluation.

### Practitioner frameworks

ADEPT originated as a practitioner checklist of analogy, diagram, example, plain language, and technical detail.

- [BetterExplained ADEPT method](https://betterexplained.com/articles/adept-method/)

Boundary: it is an idea inventory, not a validated universal ordering. Select only the representations that clarify the current subject for the current user.
