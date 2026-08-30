---
name: role-aware-product-ux
description: Analyze, design, or review a product screen from the perspective of each authorized user role, behavioral segment, journey state, and context of use. Use when deciding what a page, map, list, worklist, alert center, dashboard, or settings surface should show; which status, action, or metric is relevant; how first-time and returning experiences should differ; or when clutter, filler statistics, permanent success messages, and competing choices suggest that the interface reflects the system instead of the user's current job.
---

# Role-Aware Product UX

Design from evidence about people and their work, not from imagined role-play.
Make the interface answer the right question for the current person, moment,
scope, and authority before choosing components or filling space.

## Separate the user dimensions

Do not use one label such as `owner`, `staff`, or `customer` as a complete
persona. Separate:

- **authorization role:** what the person may see or do at the active scope;
- **behavioral segment:** goals, habits, expertise, frequency, and concerns
  that change the design;
- **context of use:** trigger, journey state, device, environment, urgency,
  interruptions, connectivity, and access needs.

One person can change role or context. Two people with the same permissions can
need different hierarchy. Enforce authorization independently from visual
personalization.

Read [role and context method](references/role-context-method.md) before
analyzing a multi-role surface or defining a new page.

## Establish the screen contract

Before styling or adding data, identify:

1. the page scope and the object or activity it owns;
2. who can reach it and the active authority intersection;
3. the trigger and primary outcome for each material user context;
4. the question the person needs answered now;
5. usage cadence, urgency, expertise, and cost of a wrong decision;
6. the completion, handoff, recovery, or return path;
7. what is observed, inferred, hypothesized, or unknown.

Express the dominant contract as:

> When [trigger and context], [actor] needs to [outcome] so that [goal], and
> can decide or act on [scope].

If substantially different roles cannot share one dominant contract without
competing hierarchy, use a common orientation layer plus role-specific views,
or separate focused routes. Do not solve a permission difference with CSS.

## Make information earn the viewport

For every visible status, metric, message, control, or explanation, complete:

> Because [actor] sees [signal], they can [decide or act] within [time horizon]
> at [scope].

Remove, demote, or move the item when the decision, action, horizon, scope,
authority, freshness, or evidence cannot be named. White space is preferable
to decorative metrics or permanent reassurance.

Treat each visible control as a promise of an implemented path. Map every
button, link, filter, or menu item to a real route or event and exercise the
outcome before release. Remove capability-shaped placeholders instead of
leaving controls that no-op, reset state, or imply unsupported work.

Rank information in this order unless evidence supports another order:

1. blocking, risky, overdue, or otherwise actionable exceptions;
2. relevant change since the last meaningful visit;
3. the next frequent decision or action;
4. current or trend context required to make that decision;
5. stable identity and orientation;
6. reference, history, and advanced administration on a focused route.

A completion message can be important at the moment work completes. On a
recurring operational surface, let completed or healthy states recede or
disappear so they do not compete forever with real work.

Progressive disclosure must remain discoverable. When an index or worklist can
grow without a fixed bound, do not place the only route to secondary settings
after its content. Keep a compact, state-aware entry in a stable header or
before the list, and move detailed controls to a focused route. This preserves
access without promoting administration above the primary work or inserting a
full settings panel before the first actionable item. A bounded detail or form
that already exposes its settings does not need a duplicate shortcut.

Read [operational information and metrics](references/operational-information-and-metrics.md)
before adding KPIs, charts, status summaries, repeated-entity content, or a
dashboard.

## Choose the page archetype from the job

Decide whether the surface is acquisition, a focused task, entity index,
worklist, role overview, analytical investigation, object detail, or settings.
Do not turn every home page into a dashboard or every entity list into cards.

- An **index** helps people find, distinguish, and open entities.
- A **worklist** helps people prioritize and process bounded work.
- An **overview** combines several sources only when one role must compare,
  monitor, filter, or react across them.
- An **analytical surface** exists only when investigation, comparison, or
  root-cause drilldown is part of the job.
- A **detail** surface explains or edits one object.

Use the archetype to decide density and navigation. Use the narrowest supported
viewport to test priority, not to justify hiding essential daily work.

## Adapt to state and frequency

Distinguish first use, incomplete setup, ordinary operation, actionable
exception, true zero, filtered no result, temporary unavailability,
permission-limited state, and degraded connectivity. Do not reuse one empty or
success treatment for all of them.

Guide a novice through the next outcome. Give returning operators direct
access to changes, exceptions, and repeated actions. Add accelerators, filters,
batch actions, or personalization only when the task and evidence justify
them.

Do not invoke “decision fatigue” as an arbitrary maximum number of choices.
Reduce irrelevant, weakly differentiated, or poorly structured choices while
preserving useful control and explicit escape hatches. Validate task success,
time, errors, backtracking, and abandonment.

## Preserve truth, inclusion, and authority

- Treat stakeholder requests and AI-generated personas as hypotheses until
  supported by research or operational evidence.
- Do not infer demographics, personality, competence, intent, or preference
  from an authorization role.
- Do not expose data, actions, comparisons, or aggregate scopes the current
  person is not authorized to use.
- Include accessibility needs across relevant roles and experience levels;
  never create one token “disabled persona.”
- Do not let visual personalization become an authorization boundary.
- Label stale, partial, estimated, or permission-limited data truthfully.
- Preserve the user's explicit product decision; surface unsupported
  assumptions instead of silently replacing it.

When explicit product direction lacks a validated user or metric contract,
record it both as a delivery constraint and as an unproven product hypothesis.
Implement a safe, reversible version when authorized, with an owner and review
condition. Do not let direction override authorization, privacy, accessibility,
legal, safety, or truthful-representation boundaries. Surface an unresolved
conflict to the authority that can decide it instead of silently obeying or
silently substituting another design.

## Produce a decision package

Return or record:

1. the screen contract and primary question;
2. the role, behavior, and context matrix;
3. task ranking by frequency, importance, urgency, and error cost;
4. a `keep | emphasize | move | remove | investigate` content audit;
5. the decision-to-information-to-action map for every proposed metric;
6. first-use, recurring, exceptional, empty, and degraded variants;
7. authorization, privacy, accessibility, and scope guardrails;
8. explicit evidence, inferences, hypotheses, and unknowns;
9. a validation and instrumentation plan.

Read [validation and evidence](references/validation-and-evidence.md) before
claiming that the design serves a role or that a metric is useful. Read
[research foundations](references/research-foundations.md) only when refining
this method, checking provenance, or resolving a disputed principle. Read
[maintainer forward tests](references/forward-tests.md) only when creating or
materially revising this skill; it contains evaluation probes and expected
boundaries that must not influence ordinary product analysis.

This skill decides what deserves attention and why. Apply the relevant domain,
visual-design, accessibility, and implementation capabilities after that
decision; it does not replace them.
