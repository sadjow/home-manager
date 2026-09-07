# Gesture and connection testing

## Pointer and touch

For a selectable surface inside a scrollable region:

1. Start a press on an unselected target and hold it long enough for any
   pending reactive patch to occur.
2. Release without movement and assert exactly one selection.
3. Repeat from another unselected target, move beyond the gesture threshold,
   and continue a real pan/scroll.
4. Assert no selection was committed and the region actually scrolled.
5. Cover cancellation or release outside when the implementation handles it.

Use a touch-capable browser profile for touch events. Also test the narrow
layout with a non-touch desktop profile when the component must work with mouse
and keyboard at that width. Playwright's `touchscreen` API is limited to touch-
enabled contexts: <https://playwright.dev/docs/api/class-touchscreen>.

## Keyboard activation near reactive fields

Exercise Enter from a single-line field and Space on an explicit button while a
debounced change is pending. Verify browser constraint validation and submitter
intent, not only the resulting URL. Include Back/review actions when they can
patch the same form.

Fill valid synthetic data before testing a successful native submit; separately
prove invalid input blocks the request and permits correction. A dispatched
`SubmitEvent` only invokes listeners and does not prove constraint validation or
the browser's default action. `form.submit()` bypasses validation, while
`requestSubmit()` applies it. Use synthetic dispatch for an explicit
listener-level contract, not as a substitute for a user gesture. Never change
the product to satisfy a test action that cannot occur through the supported
interface. This is the project-neutral `form-entry-2026-09-06` review revision.

## Cold join, reconnect, and reload

- Cold join: delay or block the reactive connection, load the full page, and
  exercise the first meaningful server-rendered action.
- Reconnect/remount: use the framework/project helper that disconnects and
  rejoins the live client. Assert non-initial wizard steps and client-owned
  state recover.
- Full reload: call `page.reload()` and assert the declared draft/resource
  recovery. Do not treat this as reconnect evidence.
- Replay: repeat or resume the non-idempotent intent with its stable operation
  identity and assert one durable result.

Wait on explicit connection/status markers or observable UI outcomes rather
than fixed sleeps.
