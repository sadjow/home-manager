---
name: ui-ux-design
description: Design, implement, or review clear, attractive, accessible, responsive web interfaces and design systems. Use for visual hierarchy, information architecture, layout, typography, color, component states, landing-page composition, internal task efficiency, responsive behavior, motion, or evidence-based UI critique; do not let visual polish override domain truth or task completion.
---

# UI and UX Design

Lead with the user's task and the interface outcome. Inspect the existing
product, screenshots, design tokens, components, content, responsive behavior,
and accessibility contract before proposing a new visual language.

## Establish hierarchy and purpose

Identify the primary job, primary action, supporting context, trust needs, and
failure/recovery path. Group related information, remove competing emphasis,
and use typography, space, color, and position to make the reading order clear.

Make the ordinary path understandable from the title, current state,
persistent labels, controls, and sequence. Assume people scan before they read,
but retain copy that prevents a likely error, explains a non-obvious
consequence, format, unit, scope, or recovery path, or supplies necessary
safety, legal, or trust context.

Acquisition pages may use persuasive full-width bands, visual storytelling,
proof, and a strong primary action. Internal operational pages should favor
compact task completion, stable navigation, and high information utility.

Read [information hierarchy and layout](references/information-hierarchy-and-layout.md)
for task comprehension, justified copy, composition, density, implementation
boundaries, landing/task distinctions, and design tokens.

## Make responsive interaction coherent

Start at the narrowest supported width, then add complexity where the content
requires it. Keep touch, mouse, and keyboard paths available; do not rely on
hover or gesture alone. Use motion to explain change and acknowledge input,
not to conceal latency or decorate every state.

Read [responsive behavior and motion](references/responsive-and-motion.md) for
breakpoints, reflow, stable geometry, interaction states, and reduced motion.

## Review with evidence

Separate usability/accessibility defects from aesthetic preferences. Prioritize
task blockers, missing feedback, error recovery, hierarchy, responsive
failures, and inconsistency before decorative effects. Validate in the real
interface rather than judging static markup alone.

Read [review and evidence](references/review-and-evidence.md) for the audit
sequence and acceptance evidence.

Use modern CSS only when the supported browser matrix and fallback contract
justify it. Do not copy browser-support percentages, trend-driven effects, dark
mode, or a new token pipeline without current evidence and product need.
