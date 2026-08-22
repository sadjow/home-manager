# Validation matrix

## Browser editing cases

For each supported semantic mode, cover:

1. one character at a time through a complete value;
2. each meaningful incomplete state;
3. an impossible character or separator sequence;
4. insertion and deletion at every separator boundary;
5. range replacement, select-all, and paste;
6. autofill or restored value;
7. IME composition without mid-composition rewriting;
8. logical caret/selection after formatting;
9. blur normalization and refocus;
10. reactive patch, reconnect, and full submit.

Exercise the supported mobile and desktop browser profiles when `beforeinput`,
selection, composition, or virtual-keyboard ordering can differ.

## Context cases

- Browser locale differs from explicit authoring locale.
- Device/IP country differs from the authored entity's country.
- A reviewed explicit value survives rerender/reconnect.
- Unknown or unsupported locale/country falls back without corrupting input.
- Currency/unit with a non-default exponent or precision.
- Phone/address modes that legitimately have different lengths or no postal
  code/number.
- Same-semantic precedence across an explicit selection, reload, coarse edge
  hint, time-zone/locale fallback, and an explicit international `+` value.

## Layout cases

- At the narrowest supported viewport and 200% text, compare each critical
  field and task panel with its nearest clipping ancestor.
- Check document-level horizontal overflow separately. A passing `scrollWidth`
  assertion does not reveal content clipped inside an `overflow-hidden`
  component.
- Exercise the longest localized country name, calling code, guidance, and
  validation message without using the flag as the only recognizable label.

## Server cases

- No-JavaScript form reaches the same parser and validation.
- Canonical normalization is idempotent.
- Tampered hidden/canonical fields are rejected or recomputed.
- Range, ownership, uniqueness, and business rules remain server-authoritative.
- Error responses preserve the authored draft and associate useful help.

Do not test only the value after blur; that misses the editing failures users
experience while typing.
