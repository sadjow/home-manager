# Recovery and async work

## Cold join

A primary task link in server-rendered HTML should work before the LiveView
socket joins; use a real `href` when full navigation is acceptable, especially
for entry into a substantial bookmarkable task. Reserve `patch` for navigation
within an already connected task when preserving the LiveView is valuable.
Exercise the real entry before the join settles so a test cannot hide a first
click lost to the initial patch. A stateful form rendered before join must not
accept input that the initial join patch can erase. Gate it briefly with one
connecting status only when that draft cannot otherwise be preserved. A
document-owned native POST with proven draft preservation remains usable before
join and without JavaScript; sharing a reactive page does not justify gating it.

## Reconnect versus reload

| Boundary | Typical protection |
| --- | --- |
| Temporary disconnect with the same LiveView | Client state plus explicit disconnected/reconnected cleanup |
| LiveView remount | Stable form ID, recovery event, current step and prior draft fields, server validation |
| Full reload | Versioned expiring browser or server draft when the work is valuable |
| Browser/device change | Server draft or persisted resource with authenticated capability |
| Replayed non-idempotent submit | Browser-persisted operation ID plus server idempotency |

Do not confuse latency simulation with reconnect, or reconnect with reload.
Test each mechanism directly.

When a security or privacy boundary requires a full-document navigation, a
late acknowledgement must not interrupt an open composer or another valuable
browser-owned draft. Persist only the bounded recovery bootstrap, defer the
document handoff until the person explicitly exits the task, and cancel it on
terminal submission. Backgrounding or suspending the document is not an exit
and must not discard the draft on resume. Do not weaken the boundary by placing
a bearer secret into the current analytics-enabled URL. Prove both the
uninterrupted draft and the later protected destination in a browser test.

Assign private root metadata, cache and referrer policy, and analytics
exclusion before resolving a bearer capability or selecting an authentication
redirect. Invalid, expired, and unauthenticated first responses need the same
protection as a successful render. When login is required, seal the sensitive
return path in an opaque, bounded continuation instead of copying the raw
capability into an authentication query, analytics surface, notification, log,
or failing test output.

Persist drafts proportionally. Scope them to actor and resource, whitelist
fields, restore visibly, and clear only after terminal success or explicit
discard. Avoid generic browser storage for passwords, payment data, private
contact/address data, uploads, or anonymous sensitive acquisition. Tiny forms
do not need autosave.

## Async enrichment

Every async lookup has a bounded deadline, cancellation or obsolescence token,
stale-reply rejection, and an actionable terminal state. A deliberate submit or
Search supersedes background autocomplete; background work must not consume or
silently discard it.

For locally authored values echoed by server patches, capture the draft at
input/change time. A parent hook's `beforeUpdate` may run after queued child
patches have already changed the DOM. Retain pending values until a matching
generation and value acknowledgement; refresh focus separately so restoring
values cannot undo a newer Tab or click. Distinguish obsolete enrichment from
an explicit selection that begins a new draft. These project-neutral decisions
are retained as the `form-entry-2026-09-06` review revision.

## Uploads and durable processing

Keep native `File` objects browser-owned until upload preflight succeeds. Avoid
form-wide change patches that can race unrelated authored fields or replace the
input.

An upload consumption callback should stage data and return. Processing that
may outlive a socket needs persistent intent, one canonical submission ID,
idempotent stages, bounded resources, progress, reconnect recovery, and cleanup
or reconciliation for partial object/database failure.

Reset request tokens, timers, observers, and callbacks on disconnect,
reconnect, reset, and destroy so old work cannot reopen or overwrite a newer UI.
