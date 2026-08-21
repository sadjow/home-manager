# Editing and formatting

## Preserve logical intent

Formatting inserts or removes characters the person did not type. Track the
caret and selection relative to semantic tokens or digits, not raw string
offsets, then restore them after rewriting.

Handle these operations explicitly:

- insertion at start, middle, and end;
- Backspace/Delete immediately beside a separator;
- range replacement and select-all;
- paste with compatible or incompatible separators;
- undo/redo;
- autofill and programmatic value restoration;
- IME `compositionstart`, updates, and `compositionend`;
- reactive DOM patches and reconnect.

Do not format during active composition. Avoid moving the caret to the end after
every input.

## Keep incomplete drafts neutral

A sign, decimal marker, partial country prefix, short postal code, or partially
typed date may be incomplete rather than invalid. Define the state machine for
the actual semantic type. Do not share one generic mask switch between money,
phone, postal, and date inputs merely because each formats text.

Provide immediate feedback for syntax that cannot become valid. Keep server
validation authoritative for availability, range, uniqueness, business rules,
and other facts requiring domain state.

## Choose a normalization boundary

Progressively format while typing only when it materially helps and the caret
contract is proven. Otherwise preserve a natural draft and normalize on blur
or submit. No-JavaScript submission must still reach the same server parser.

Keep the raw browser draft and canonical hidden/submitted representation from
silently diverging. A reactive patch must not overwrite an active draft with a
stale server value.
