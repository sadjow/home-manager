# Recovery and async work

## Cold join

A primary task link in server-rendered HTML should work before the LiveView
socket joins; use a real `href` when full navigation is acceptable. A stateful
form rendered before join must not accept input that the initial join patch can
erase. Keep it briefly inert, expose one concise connecting status, and remove
the boundary on mount/reconnect.

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
