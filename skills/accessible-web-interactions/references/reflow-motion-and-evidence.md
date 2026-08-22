# Reflow, motion, and evidence

## Responsive accessibility

Verify at 320 CSS px and at 200% zoom or the project's equivalent reflow
contract. Content and controls must remain readable, reachable, and operable
without two-dimensional scrolling except where the content inherently requires
it. Test long translated labels and large platform text, not only default copy.

Use measured contrast for text, meaningful graphics, component boundaries, and
focus indicators. Test each supported theme and state, including operating
system forced-colors or high-contrast settings where supported. Do not infer
contrast from token names. An indicator implemented only with `box-shadow` is
not sufficient evidence because forced-colors can suppress the shadow.

WCAG 2.2 target size minimum is 24 by 24 CSS px with documented exceptions.
Prefer roughly 44 px for primary touch actions and crowded mobile workflows
when the product can support it. Inline text links and tightly constrained
controls require case-specific evaluation.

## Motion

Respect `prefers-reduced-motion`. Remove large movement, parallax, pulsing, and
smooth scrolling while retaining immediate state feedback, focus placement,
and lifecycle completion. Avoid flashing content. Test the reduced-motion path
because callbacks must not depend on a transition that no longer runs.

## Evidence ladder

1. Static semantic inspection and automated audit.
2. Keyboard-only task completion and visible focus inspection.
3. Touch/pointer journey, including gesture cancellation.
4. Reflow, zoom, large text, translated labels, contrast, and reduced motion.
5. Forced-colors or high-contrast mode for focus, boundaries, and status.
6. Screen-reader journey for the relevant platform/browser pair.

Automation cannot reliably judge useful alt text, logical focus, announcement
quality, error recovery, gesture alternatives, or cognitive clarity.

Classify a defect as release-blocking when a required supported task cannot be
perceived, understood, or completed. Report aesthetic preferences and optional
polish separately.

Primary references:

- WCAG 2.2 target size: <https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html>
- Focus not obscured: <https://www.w3.org/WAI/WCAG22/Understanding/focus-not-obscured-minimum>
