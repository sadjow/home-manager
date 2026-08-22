# Research foundations

This reference records the evidence used to create the method. It is not a
substitute for product-specific user research. Sources were reviewed on
2026-08-22.

## Human-centered context

- [ISO 9241-210:2019](https://www.iso.org/standard/77520.html) defines a
  lifecycle of human-centered design activities. The method therefore begins
  with explicit users, tasks, environments, requirements, evaluation, and
  iteration rather than visual preference.
- [NIST Human-Centered Design](https://www.nist.gov/itl/iad/human-centered-technologies/human-factors-human-centered-design)
  summarizes the need to understand users, tasks, and environments and to
  evaluate designs throughout development.
- [NIST RBAC](https://csrc.nist.gov/glossary/term/role_based_access_control)
  defines roles as access authorizations for organizational functions. The
  method consequently keeps authorization separate from goals and behavior.

## User needs and real work

- [GOV.UK: Learning about users and their needs](https://www.gov.uk/service-manual/user-research/start-by-learning-user-needs)
  requires evidence-based needs expressed as outcomes rather than imagined
  solutions, and treats unsupported opinions as assumptions.
- [GOV.UK: Contextual research and observation](https://www.gov.uk/service-manual/user-research/contextual-research-and-observation)
  recommends observing real activities with usual tools, data, surroundings,
  distractions, barriers, and workarounds.
- [GOV.UK: Services for government users](https://www.gov.uk/service-manual/design/services-for-government-users)
  shows why internal and repeated work can need quick switching, complete
  decision context, and tests across experience and team structures instead of
  blindly applying one-content-item-per-page.

## Role-based operational surfaces

- [SAP Fiori design principles](https://experience.sap.com/fiori-design-web/design-principles/)
  emphasize role-based, adaptive, simple experiences with relevant information
  at the right time.
- [SAP Fiori overview page](https://experience.sap.com/fiori-design-web/overview-page/)
  distinguishes a role-specific, multi-source overview from launch pages and
  single-object detail. It supports using dashboards only for a real
  role-specific monitoring and reaction job.
- [SAP Fiori worklist](https://experience.sap.com/fiori-design-web/work-list/)
  centers a queue of items the user must prioritize and process.
- [SAP Fiori list](https://experience.sap.com/fiori-design-web/list-overview/)
  limits each row to the crucial information needed to decide which item to
  handle, moving full detail to the object view.

## Status, dashboards, and metrics

- [GOV.UK: Complete multiple tasks](https://design-system.service.gov.uk/patterns/complete-multiple-tasks/)
  recommends few status types and visually quiet completed work so incomplete
  work receives attention. This supports demoting completion after it has
  served its immediate feedback purpose.
- [Microsoft: Power BI dashboard design](https://learn.microsoft.com/power-bi/create-reports/service-dashboards-design-tips)
  asks which metrics help the audience make decisions, removes nonessential
  detail, and reduces tiles on smaller displays.
- [Google HEART](https://research.google/pubs/measuring-the-user-experience-on-a-large-scale-user-centered-metrics-for-web-applications/)
  provides the goal, signal, metric chain used by the validation method.
- [Google Looker visualization guide](https://docs.cloud.google.com/looker/docs/visualization-guide)
  requires the visualization to fit both the analytic objective and the
  audience's perspective, knowledge, and job function.

## Progressive disclosure and decision load

- [Apple disclosure controls](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls)
  supports keeping likely actions visible while making advanced functionality
  available when relevant.
- [Choice-overload meta-analysis](https://doi.org/10.1086/651235) found a mean
  effect near zero across 63 conditions with substantial variation. The method
  therefore rejects arbitrary choice caps and instead removes irrelevant,
  weakly differentiated, or poorly structured choices while validating the
  actual task outcome.

## Accessibility evidence

- [W3C: Involving users in accessibility evaluation](https://www.w3.org/WAI/test-evaluate/involving-users/)
  recommends involving disabled people while warning that individual users do
  not represent every disability or replace standards-based evaluation.

Refresh this evidence when a source changes the decision rule, not merely to
accumulate more links. Preserve product-specific research, permissions, roles,
and metrics in the product's own harness.
