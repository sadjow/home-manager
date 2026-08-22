# Role and context method

Use this method before choosing page content or layout. It prevents an
authorization label from becoming an invented persona and makes uncertainty
visible.

## Separate three dimensions

| Dimension | Question | Design effect | Must not become |
| --- | --- | --- | --- |
| Authorization role | What may this person see or do at this scope? | visibility, actions, data scope, confirmation | a claim about goals, expertise, or preference |
| Behavioral segment | Which goals, tasks, habits, expertise, and frequencies change the experience? | hierarchy, shortcuts, guidance, terminology | a fictional biography or demographic stereotype |
| Context of use | What triggered this visit, and under what conditions is the task happening? | timing, state, device, recovery, density, access support | a device-only breakpoint or happy-path scenario |

Model authority as the intersection of the signed-in identity, tenant or
resource membership, active scope, delegated capability, object state, and
operation. Model behavior and context separately even when they correlate with
a role.

## Write the screen contract

Record:

```text
Surface and scope:
Entry points and trigger:
Dominant actor/context:
Dominant question:
Desired outcome:
Completion or handoff:
Cadence:
Urgency and cost of error:
Known evidence:
Hypotheses and unknowns:
```

Write each user need without prescribing the solution:

```text
When <trigger/context>,
<actor> needs to <outcome>,
so that <goal>,
while able to decide or act on <authorized scope>.
```

Keep the business outcome and constraints next to the user need, but do not
rename them as the user's need.

## Build the role-context matrix

Use one row for each materially different combination, not one row for every
database role.

| Actor and authority | Trigger and journey state | Frequency and experience | Job and question | Signal required | Decision or action | Scope and horizon | Constraints and risk | Evidence level |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  |

Consider:

- first use, returning use, expert repeated use, and support-assisted use;
- solo work, delegated work, handoffs, and centralized teams;
- mobile, desktop, constrained devices, interruption, time pressure, and
  degraded connectivity;
- language, literacy, motor, visual, auditory, cognitive, and assistive-
  technology needs across each meaningful role;
- the consequence of omission, false emphasis, stale data, or a wrong action.

Rank tasks separately for each group by frequency, importance to the person,
importance to the service, urgency, error cost, feasibility, and vulnerability
to usability problems. A low-frequency destructive task can outrank a frequent
harmless task because its risk is higher.

## Resolve multiple roles on one surface

Prefer these structures in order:

1. **Shared core:** common identity, orientation, and safe actions.
2. **Contextual slot:** an authorized, role-relevant exception or next action
   replaces generic filler without changing the whole page.
3. **Explicit scope or mode:** the person chooses which legitimate working
   context is active, and the interface keeps that scope visible.
4. **Focused route:** use a separate view when dominant questions, data scopes,
   or workflows conflict.

Do not build entirely separate dashboards from role names alone. Do not merge
roles when the combined view exposes unauthorized data or produces competing
primary actions. A person with multiple roles must be able to understand which
scope and authority are active.

When the shared core is itself being inspected or previewed, keep contextual
chrome outside the measured content and layout being evaluated. If an overlay,
banner, or editing affordance changes wrapping, viewport behavior, semantics,
or interaction enough to make the preview unfaithful, use an explicit mode or
focused route instead.

## Use AI carefully

AI can enumerate plausible actors, situations, missing questions, and research
risks. It cannot observe users or convert plausibility into evidence. Label its
output as hypothesis. Never invent a person's name, age, personality, family,
income, disability, technical ability, or preferred channel unless reliable
evidence shows that characteristic changes the design.

## Transfer example

A map can serve a visitor trying to discover something nearby and an operator
checking how a managed resource appears. Their authorization may overlap, but
their questions differ. Preserve the map's dominant public discovery job and
offer a clearly scoped operator path or contextual overlay. Do not show every
merchant control to every viewer or fork the entire map before evidence shows
the tasks cannot coexist.
