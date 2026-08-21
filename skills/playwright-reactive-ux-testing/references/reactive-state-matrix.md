# Reactive state matrix

## Assert both phases

For each network-backed interaction, identify:

| Phase | Browser evidence | Server/domain evidence |
| --- | --- | --- |
| Input accepted | Pressed/open/busy state appears before reply | Event intent is valid |
| Pending | One initiating state, competitors unavailable as intended | At most one in-flight/accepted mutation |
| Success | Correct terminal UI, stable geometry, useful focus | Committed outcome and effects |
| Rejection | Busy clears, error is visible/announced, retry works | No invalid mutation |
| Timeout/disconnect | UI remains recoverable; stale reply is ignored | Retry/idempotency contract holds |

Use a server/component test for validation, authorization, locks, and durable
idempotency. Use Playwright for paint timing, actionability, event ordering,
DOM restoration, focus, geometry, and connection behavior.

## High-risk reactive cases

- first action while a focused/debounced field has an unsubmitted draft;
- rapid repeated actions under latency;
- old and new controls replacing the same slot;
- async autocomplete versus deliberate Search/submit;
- overlay open/close while loading or receiving a broadcast;
- state restored after patch, remount, and reload;
- reduced-motion callbacks;
- translated labels at the layout breakpoint.

Use a deliberate latency that makes the round trip observable without turning
the test into a timeout benchmark. A project may standardize a value such as
750 ms for regression probes; follow its contract rather than hard-coding a
universal number.

Keep tests isolated. Reuse fixtures and setup APIs, but avoid a page object that
hides the action sequence or temporal assertion.
