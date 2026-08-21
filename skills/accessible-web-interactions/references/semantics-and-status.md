# Semantics and status

## Start with native structure

Use headings that describe the content hierarchy and one appropriate set of
landmarks. Label repeated navigation or regions distinctly. Use a real button
for an action, a link for navigation, native form controls for input, and a
table for tabular relationships.

ARIA changes accessibility semantics, not browser behavior. If a custom widget
is necessary, implement its complete keyboard, focus, state, and naming model
from an established pattern.

## Forms

- Associate every control with a persistent accessible label.
- Associate format help and errors with `aria-describedby` or the native
  equivalent. A placeholder is not a label or durable instruction.
- Use native required and invalid semantics where they match the contract.
- Place errors near the field and provide a summary/focus strategy for long
  forms when it helps recovery.
- Preserve autocomplete and input-purpose metadata. Do not block paste or
  password managers.

## Dynamic status

Keep a live-region container present before injecting content. Prefer
`role="status"` or polite announcements for ordinary progress and success;
reserve alerts/assertive announcements for urgent interruptions.

Announce the useful outcome once. Do not announce every animation frame,
loading tick, or duplicated global/local message. Keep visible text and the
programmatic message consistent.

Errors explain what happened and how to recover. Success messages do not claim
that an email, SMS, payment, or other external effect occurred unless the
system has evidence for that claim.

Primary references:

- WCAG 2.2: <https://www.w3.org/TR/WCAG22/>
- ARIA APG patterns: <https://www.w3.org/WAI/ARIA/apg/patterns/>
