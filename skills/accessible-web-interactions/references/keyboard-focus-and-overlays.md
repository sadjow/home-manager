# Keyboard, focus, and overlays

## Keyboard model

Native controls already implement expected activation. Preserve Enter/Space,
Tab order, form submission, and Escape behavior before adding custom handlers.
Avoid positive `tabindex`.

For composite widgets, keep one Tab stop into the component and use the
established arrow-key model inside it. Focus and selection are different; do
not automatically couple them when doing so triggers expensive or irreversible
work.

Every drag, swipe, or pan action needs a button, direct selection, or other
single-pointer alternative. A surface that scrolls must cancel activation when
movement changes the gesture from tap to pan.

## Visible indicators and modality

Keyboard focus must always have a visible indicator. `:focus-visible` is the
usual baseline because browsers retain strong focus treatment for keyboard and
script-driven focus without necessarily drawing it after every pointer click.
That behavior is a heuristic, not a reason to remove the browser outline.

A product may deliberately keep a visible `:focus` indicator after pointer
activation. This can help people with low vision, attention limitations, short
term memory limitations, or an interrupted task remember which control still
owns focus. Record this as an inclusive product preference rather than calling
it a universal WCAG 2.2 AA requirement. At minimum, keep pointer focus visible
for inputs, editable controls, focused status or error regions, dialog
containers, scroll regions, and controls whose next keyboard action depends on
the retained focus.

Focus, hover, pressed, selected, current, invalid, and disabled are different
states. Do not reuse one subtle color change to communicate all of them. Never
use `outline: none`, `outline: 0`, or an outline-removing utility unless an
equal or stronger indicator is present in the same state.

Prefer a shared focus token and an outline that does not change layout. A
two-color indicator is robust across mixed light and dark surfaces. For a
custom indicator, measure at least 3:1 contrast against its adjacent colors;
using the WCAG 2.4.13 two-CSS-pixel perimeter as a stronger design target makes
it easier to see even though that success criterion is Level AAA. Preserve the
user-agent outline as a fallback and verify `forced-colors`, because
`box-shadow` focus rings can disappear in high-contrast modes.

## Focus placement

Focus follows the task:

- after navigation, move it only when the new context would otherwise be
  unclear;
- after validation, focus the summary or first actionable invalid field;
- after insertion/deletion, choose the next logical control or new content;
- after closing an overlay, return to the launcher unless it disappeared or a
  more logical workflow target is documented.

Ensure sticky headers, footers, banners, and virtual keyboards do not entirely
obscure the focused control. `scroll-margin`/`scroll-padding` can help but must
match actual geometry.

When focus moves by script, the destination needs a programmatic focus target
and a useful visible location cue. A temporary status panel may use
`tabindex="-1"`; do not add it to the sequential Tab order. Avoid unexpected
scrolling, and preserve the reading position with `preventScroll` when the
person can already perceive the result.

If a focused trigger disappears after a mutation, choose a nearby stable
region or the next logical action instead of allowing focus to fall onto the
document body. When a copy action fails, move focus to the selectable value and
give a concrete keyboard recovery path. During an uncertain or pending
destructive action, keep focus inside the open dialog until the outcome is
known.

## Modal dialogs

When a modal opens, background content is inert, focus moves inside, Tab and
Shift+Tab remain inside, Escape closes when dismissal is allowed, and a visible
close/cancel control exists. Name the dialog from its visible title. Use a
description only when it is concise enough to announce as one string.

Set initial focus according to content and risk: a static title for long
structured content, the least destructive choice for irreversible actions, or
the likely primary action for a simple informational dialog.

Primary references:

- Focus visible: <https://www.w3.org/WAI/WCAG22/Understanding/focus-visible>
- Focus appearance: <https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance>
- Non-text contrast: <https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html>
- Forced colors: <https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/forced-colors>
- Modal dialog pattern: <https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/>
- Keyboard interface: <https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/>
