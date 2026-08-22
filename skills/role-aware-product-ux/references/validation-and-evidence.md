# Validation and evidence

Use evidence to keep empathy from becoming fiction.

## Label confidence

Keep these labels explicit:

- **Observed:** a person, system, or dataset demonstrated the behavior.
- **Inferred:** several observations support a conclusion, with a stated
  reasoning path.
- **Hypothesized:** plausible and testable, but not yet supported.
- **Unknown:** no responsible answer is available yet.

Stakeholder requests, competitor screenshots, agent suggestions, and feature
ideas are inputs. They are not automatically user needs. Keep the observation
separate from the interpretation and proposed solution.

## Collect the right evidence

Prefer a combination of:

- contextual observation using realistic tools, data, interruptions, and
  environments;
- task-based usability sessions with likely users and no solution-leading
  instructions;
- analytics segmented by role, journey state, experience, device, and relevant
  access needs;
- support contacts, search logs, abandonment, error and recovery paths;
- interviews that explain motivations and constraints after behavior is
  observed;
- domain and security review for authority, privacy, and consequence.

Include people who operate or support the service, not only the idealized end
customer. Include disabled users across relevant roles. One participant does
not represent a disability, role, market, or experience level, and qualitative
research does not establish population prevalence by itself.

## Define goals before metrics

Use a goal-to-signal-to-metric chain:

```text
Goal: the user outcome and product outcome that should improve
Signal: observable behavior or result that would indicate progress
Metric: a reliable calculation of that signal
Guardrail: harm, exclusion, cost, or quality that must not worsen
```

Useful task evidence includes first correct action, successful completion,
time to the relevant action, wrong-route taps, backtracking, errors, recovery,
abandonment, comprehension of data scope and period, support need, and the age
or resolution of operational exceptions. Time on page and raw clicks are
ambiguous without the task outcome.

Use both quantitative and qualitative evidence. A rising click rate can mean
better discovery or more confusion. A calm page can be useful even when it
creates fewer interactions.

## Validate the design decision

For each material recommendation, record:

| Candidate | Role/context | Decision supported | Evidence | Recommendation | Success signal | Guardrail | Review date |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  | keep, emphasize, move, remove, or investigate |  |  |  |

Test realistic state transitions, not only the ideal screenshot:

- first use to successful setup;
- return after completion;
- actionable exception and resolution;
- true zero versus filtered no result;
- permission-limited access;
- stale, partial, failed, or unavailable data;
- narrow viewport, zoom, keyboard, touch, assistive technology, interruption,
  disconnect, and recovery where relevant.
