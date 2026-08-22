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

## Preserve verification-code AutoFill

Use one native verification-code input with an explicit label,
`autocomplete="one-time-code"`, the system keyboard, full-code paste, and an
explicit submit action. Visual slots may be decorative, but must not fragment
the value into independent fields or replace native caret, selection, and
accessibility behavior.

Treat AutoFill as a contract between the field, operating system, message, and
delivery channel. Keep the code contiguous and near a localized code/passcode
keyword. Name the field and its submitted namespace for a verification code so
the application contract is clear, but do not claim that a field name alone
controls a proprietary platform detector without evidence. Match the system
keyboard to the challenge alphabet, and disable capitalization, correction,
and spellcheck when they cannot help.

Use a platform's domain-bound syntax only on the transport for which it is
documented. Do not promise that a third-party messaging app will trigger
AutoFill merely because its message contains a recognizable code; preserve a
clear copy-and-type fallback. For domain-bound SMS, activate WebOTP only on the
SMS transport, abort it with the form lifecycle, never overwrite authored
input, announce that the field was populated, and keep submission explicit.
Arm the browser request before provider delivery and keep a bounded
no-JavaScript delivery fallback. When real-device recognition regresses after a
copy, line-break, or markup change, replay the complete last-known-working
message and field first. Change only one variable at a time, retain the smallest
empirically compatible grammar, and require another physical-device check
before changing it again.
