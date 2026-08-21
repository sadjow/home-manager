---
name: semantic-web-inputs
description: Design, implement, diagnose, or test locale-aware web inputs such as money, phone, postal, date, quantity, and identifiers. Use for masks, progressive formatting, local syntax feedback, explicit locale or domain context, caret and selection behavior, paste, autofill, IME composition, reactive patches, normalization, and server validation; do not use one generic mask abstraction for unrelated semantics.
---

# Semantic Web Inputs

Treat an input as an editing model, not a string decoration. Preserve what the
person intended while keeping the server authoritative for domain validity.

## Establish authority

Identify the field's owning domain context, stored representation, display
format, authoring locale, normalization boundary, and no-JavaScript behavior.
Browser, operating-system, IP, or device region may suggest a blank value but
must not override explicit user or business context.

Read [context and authority](references/context-and-authority.md) before
choosing locale, currency, country, units, or a regional default.

## Design the editing state machine

Separate:

- incomplete drafts that could become valid;
- impossible syntax that can be rejected locally;
- syntactically complete values that still need domain validation;
- normalized/submitted representation.

Keep deterministic syntax feedback browser-local and latency-independent. If
progressive formatting rewrites the value, preserve logical caret, selection,
paste, deletion, autofill, undo, and IME composition. Normalize at blur or
submit when per-keystroke rewriting would harm editing.

Read [editing and formatting](references/editing-and-formatting.md) before
writing input event code or a reactive hook.

## Verify more than the final value

Test incremental keystrokes, mid-string edits, both sides of separators,
selection replacement, paste, autofill, composition, blur, submission,
reactive patches, reconnect, and no-JavaScript fallback. Deliberately mismatch
browser locale and explicit authoring context.

Read [validation matrix](references/validation-matrix.md) for the minimum
browser and server evidence.

Keep format help visible and associated with the field. A placeholder is not a
label, default, or persistent instruction.
