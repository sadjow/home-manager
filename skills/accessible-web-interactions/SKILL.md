---
name: accessible-web-interactions
description: Design, implement, review, or test accessible web interactions using WCAG 2.2 AA as the default baseline. Use for semantics, keyboard and touch operation, focus, overlays, live status, forms, contrast, reflow, zoom, large text, target size, reduced motion, or screen-reader behavior; distinguish conformance defects from visual preferences.
---

# Accessible Web Interactions

Treat accessibility as required behavior throughout design, implementation, and
validation. Prefer native HTML and browser behavior before ARIA. WCAG 2.2 is
normative; the ARIA Authoring Practices Guide is informative implementation
guidance, not a substitute for testing the actual product.

## Build perceivable, operable state

- Give every task a semantic name, structure, label, and status.
- Support keyboard, pointer, and touch. Provide a single-pointer alternative to
  dragging or path-based gestures.
- Keep focus visible, unobscured, predictable, intentionally placed, and
  restored after overlays or task transitions.
- Treat `:focus-visible` as the keyboard baseline and make pointer-focus policy
  explicit. Keep a visible `:focus` state when the control still owns attention
  after a click, when a product deliberately favors modality-independent
  orientation, or when focus was placed by script.
- Announce meaningful progress, success, failure, validation, and result-count
  changes without flooding the live region.
- Never encode meaning only through color, icon, shape, position, sound,
  placeholder, or motion.

Read [semantics and status](references/semantics-and-status.md) for document
structure, forms, errors, and dynamic announcements. Read
[keyboard, focus, and overlays](references/keyboard-focus-and-overlays.md) for
widgets, dialogs, and gesture alternatives.

## Verify beyond automation

Exercise reflow, zoom, large text, contrast, translated labels, practical target
sizes, reduced motion, and persistent chrome. Automated audits, screenshots,
and accessibility-tree inspection are supporting evidence, not proof. Use a
real keyboard journey and a screen reader for high-risk flows.

Read [reflow, motion, and evidence](references/reflow-motion-and-evidence.md)
for the validation matrix and release classification.

When privacy or security requires an indistinguishable response, do not
announce an external effect that may not have happened. State the condition
truthfully and provide a non-disclosing recovery path that works in either
underlying state.
