# Diagnostics and validation

## Measure the failure phase

When the local version exposes them, use LiveView debug, profiling, and latency
simulation to separate:

1. input to next paint;
2. event push to server reply;
3. reply to DOM patch completion;
4. patch to stable layout/paint;
5. transition start to lifecycle completion.

Use performance marks, `requestAnimationFrame`, mutation/resize observation,
computed state, and the Playwright trace. Inspect the same stable node before,
during, and after pending state. Do not label a visual freeze as network delay
without evidence.

## Split tests by responsibility

- LiveView/ExUnit: accepted/rejected state, validation, authorization, locks,
  idempotency, and broadcasts.
- Browser: local acknowledgement, pointer/keyboard order, DOM restoration,
  focus, transition lifecycle, reconnect/reload, and viewport geometry.

Use web-first assertions for eventual UI state. Avoid fixed sleeps. A temporal
bug may require a trace, video, frame sheet, or instrumentation because a final
DOM assertion can pass after a visible flash.

## Minimum high-risk matrix

- first action under normal and slow latency;
- rapid repeats produce one accepted mutation;
- rejection and timeout restore a usable control;
- stale reply/timer/broadcast cannot overwrite newer state;
- held pointer press and actual pan from an unselected target;
- Enter and Space while a debounced field is pending;
- cold join, disconnect/reconnect, and full reload as separate cases;
- Escape, focus containment/return, and background inertness;
- 320 px and desktop geometry, long translated labels, no horizontal overflow;
- reduced motion lifecycle.

Current primary references:

- LiveView state syncing: <https://hexdocs.pm/phoenix_live_view/syncing-changes.html>
- LiveView JavaScript commands: <https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html>
