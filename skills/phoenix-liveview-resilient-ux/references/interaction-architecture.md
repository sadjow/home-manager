# Interaction architecture

## Acknowledge locally, reconcile explicitly

For any network-backed interaction:

1. Acknowledge the input by the next paint.
2. Make competing actions single-flight in the browser.
3. Push one explicit intent to the server.
4. Guard or deduplicate the mutation on the server.
5. Reconcile accepted, rejected, timeout, and disconnected outcomes.
6. Ignore stale callbacks whose request token no longer matches.

Do not interpret silence as success. Client `disabled` state is not a domain
lock; queued events, programmatic dispatch, reconnect, or another client can
bypass it.

## Render stable shells immediately

Open a modal, sheet, drawer, or overlay locally and move focus into a stable
shell before fetching enrichment. Replace loading content inside the same
panel. Keep one backdrop and make the background inert for every active state,
including loading and closing.

Reserve the final geometry. Remove outgoing interactivity immediately and
animate routine feedback with `opacity` and `transform`; never leave old and new
controls clickable together. Coordinate an exit animation with an explicit
completion callback and ensure reduced motion completes the lifecycle without
waiting for a transition.

## Preserve the first action near reactive fields

A focused or debounced input may still have a browser draft when pointerdown or
keyboard activation begins. If a patch can replace the target before click or
submit, preserve/submit the current browser draft before that boundary while
retaining constraint validation, submitter intent, single-flight behavior,
native semantics, and no-JavaScript submission.

Do not prove this only with an already blurred field. Exercise a held first
press, Enter from a single-line input, and Space on an explicit submitter under
latency.

## Distinguish focus from the software keyboard

DOM focus, a visible caret, and presentation of the mobile software keyboard
are separate outcomes. On iOS, `autofocus` or a focus command that runs after an
asynchronous navigation or patch can focus a text field without opening the
keyboard because it is no longer inside the direct user gesture. Do not use a
focused-element assertion as evidence that the keyboard opened.

Keep the intended field as an obvious direct touch target. Only promise
keyboard continuity when physical-device evidence shows that the same
user-activated editing session survives the transition. Do not use a hidden
proxy input, synthesize a click, or expose an unconfirmed success state merely
to force a keyboard. WebKit documents the user-gesture boundary at
<https://bugs.webkit.org/show_bug.cgi?id=195884>.

## Separate tap from pan

On a surface that can scroll, pan, or drag, never commit selection on
pointerdown. Preserve any draft needed to survive a patch, then commit only
after a gesture-qualified pointerup. Cancel on meaningful movement,
`pointercancel`, release outside, disconnect, or destruction. Keep native
keyboard activation.

## Put step-up authentication at the sensitive boundary

Do not require a fresh credential merely to open an authenticated settings
surface when it also contains low-risk preferences. Gate credential,
authentication-method, and account-merge controls before the user starts a
draft, then reuse one bounded recent-authentication window for related changes.
Every mutation handler must recheck that window because an already-rendered
page can outlive it.

Present the already-selected account identity as text rather than as a
`readonly` control that appears broken. Keep its canonical value outside the
editable draft, preserve a safe return to the exact task section, and focus the
credential the person can actually enter. A page whose entire purpose is a
sensitive operation can still require step-up authentication at entry.

## Assign one visual state owner

Tabs, scrollspy, disclosures, and client-mutated ARIA state must not alternate
between a hook and server patches. Ignore only exact client-owned attributes.
Use `phx-update="ignore"` only when the client owns and reconciles the complete
subtree.

LiveView's current client/server state guidance:
<https://hexdocs.pm/phoenix_live_view/syncing-changes.html>.

## Contain global LiveView messages

A layout-level `:handle_info` hook that subscribes every connected LiveView to
PubSub owns those internal messages. After updating shared assigns, return
`:halt` so an unrelated LiveView without a matching callback does not crash.
Let a specialized page opt into `:cont` explicitly when it also needs the raw
event for page content. Do not require catch-all callbacks across the entire
application to compensate for a global subscription.
