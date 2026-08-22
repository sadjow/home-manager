# Operational information and metrics

Use this reference to decide what earns space on a recurring screen.

## Select the page archetype

| Archetype | Dominant question | Include | Avoid |
| --- | --- | --- | --- |
| Acquisition | Why should I begin, and what happens next? | value, trust, proof, one next step | operational density and internal terminology |
| Focused task | How do I complete this outcome safely? | required context, inputs, validation, recovery | unrelated navigation and analytics |
| Entity index | Which object do I need, and where do I continue? | identity, differentiator, exceptional signal, primary route | repeated dashboards and global facts per row |
| Worklist | What must I process first? | priority, age, owner, deadline, state, direct action | decorative totals and completed work competing with open work |
| Role overview | What changed or requires attention across sources? | a small set of role-specific signals and micro-actions | using cards only to launch pages or fill space |
| Analytical investigation | What caused this outcome, and what should change? | comparison, filtering, trends, drilldown, transactional follow-through | charts when no investigation is required |
| Object detail | What is true about this object, and what can I do? | homogeneous object context and scoped actions | unrelated cross-domain overview content |
| Settings | Which durable preference or policy am I changing? | current value, consequence, focused save and recovery | daily work queues and unrelated forms |

An overview is justified only when one role needs information from several
sources to compare, monitor, filter, or react. A launch-only page is an index.
A small queue is a worklist. One entity is a detail page. Choose the job before
choosing cards, charts, or grids.

## Apply the viewport earning test

For each candidate item, answer:

1. Is it authorized for this person and scope?
2. Is it relevant in the current state and usage moment?
3. Which decision or action does it improve?
4. Is its scope and time horizon explicit?
5. Is it fresh, complete, and trustworthy enough for that decision?
6. Is it interpretable without a paragraph of explanation?
7. Does it lead to a meaningful destination or action when one is needed?
8. Is it more valuable than the mobile viewport space and attention it costs?

Keep an item that passes. Emphasize it only when urgency or frequency warrants
emphasis. Move reference or analytical depth to a focused route. Remove filler.
Investigate when a plausible need lacks evidence.

## Prioritize operational awareness

Recurring operational pages normally prioritize:

1. exceptions that need action now;
2. new or changed work since the last meaningful visit;
3. due, aging, blocked, unassigned, or capacity-risk work;
4. the next likely action;
5. current context needed to act correctly;
6. retrospective analysis on a focused insights surface.

Do not show a permanent positive state merely to occupy the row. A completed
state can confirm a just-finished action, then become visually quiet or absent.
When nothing needs attention, a compact entity and its primary route can be the
complete design.

## Treat alerts as interruption recovery

An alert center helps a person notice a consequential change and recover the
canonical task after an interruption. It is not a duplicate worklist, message
archive, or permanent floating layer.

- Persist an in-product source of truth before depending on an external push,
  email, SMS, or chat transport.
- Deduplicate one logical event across roles, devices, memberships, and
  transports; reading the alert must not silently resolve the underlying work.
- Show the minimum authorized context needed to judge urgency and one direct
  route to the canonical object or filtered worklist. Keep private detail in
  that authorized destination.
- Prefer an existing global navigation badge plus contextual, non-focus-
  stealing status over a second permanent control. Add a floating affordance
  only when it owns a distinct, frequent, time-critical action and its viewport
  and interruption cost are justified.
- Group bursts, label stale state, and demote or remove obsolete alerts so the
  center does not compete with current work.
- Keep notification-channel configuration secondary to actionable alerts on
  compact screens.

Test duplicate delivery, inactive tabs, reconnect, role or scope changes,
resolved work, failed external transports, narrow viewports, 200% text,
keyboard use, and assistive technology. Measure first relevant action and
recovery, not notification taps alone.

## Require a metric contract

A visible metric or KPI needs:

```text
User goal and decision:
Authorized role and scope:
Definition and source:
Value, unit, and denominator:
Time window and freshness:
Target, baseline, or valid comparison:
Interpretation and direction:
Destination or available action:
Coverage, uncertainty, and permission limits:
Expiry or review condition:
```

Do not imply performance from a raw total without a denominator, period,
comparison, or decision. Do not aggregate across entities unless the actor is
authorized for the whole scope. Put a cross-entity metric once at page scope;
repeat per-entity signals only when they help the person triage that entity.

Useful operational hypotheses often include awaiting response, overdue work,
new work today or since the last visit, blocked fulfillment, assignment gaps,
or capacity risk. Revenue, views, lifetime totals, and completion percentages
are not automatically useful. They need the same contract and often belong on
an insights route.

Remove or demote a metric when it is stale, nearly always zero or healthy,
ignored, unactionable, too expensive to load, or no longer connected to a user
decision. Instrument use without logging private content or treating clicks as
proof of value.

## Handle decision load precisely

Choice overload is contextual, not a universal law that yields a maximum
number of options. Reduce decision cost by:

- removing irrelevant or unavailable options;
- grouping comparable choices and naming their differences;
- choosing a reviewed default when reversal is safe;
- keeping one visually dominant action for the current task;
- placing frequent contextual actions near their object;
- moving rare or advanced actions behind a well-named route or menu;
- preserving an explicit alternative when the default does not fit;
- keeping essential work visible instead of hiding it in disclosure.

Measure whether the structure improves first correct action, completion,
errors, backtracking, abandonment, and recovery. More useful choices can be
better than fewer choices.

## Keep visual space purposeful

At the first compact viewport, answer:

- Where am I and which scope is active?
- What changed or needs attention?
- What is the next useful action?

Use wider viewports for comparison, stable columns, or a list-detail
relationship when the job benefits. Do not stretch prose or multiply cards to
fill width. White space can separate priorities; it is not missing content.
