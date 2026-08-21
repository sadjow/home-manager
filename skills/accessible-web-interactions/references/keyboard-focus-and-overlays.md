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

## Modal dialogs

When a modal opens, background content is inert, focus moves inside, Tab and
Shift+Tab remain inside, Escape closes when dismissal is allowed, and a visible
close/cancel control exists. Name the dialog from its visible title. Use a
description only when it is concise enough to announce as one string.

Set initial focus according to content and risk: a static title for long
structured content, the least destructive choice for irreversible actions, or
the likely primary action for a simple informational dialog.

Primary references:

- Modal dialog pattern: <https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/>
- Keyboard interface: <https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/>
