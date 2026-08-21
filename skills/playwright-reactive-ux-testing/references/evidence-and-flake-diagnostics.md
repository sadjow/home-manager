# Evidence and flake diagnostics

## Prefer observable conditions

Use locators with auto-waiting and async web-first assertions. For computed
geometry or application counters, use `expect.poll` or another bounded retry
around the meaningful value. Keep non-retrying assertions for stable data
already captured after an observable boundary.

Do not use `networkidle` as a universal readiness signal for real-time apps.
Wait for the task's explicit ready state, required data, image decode, map idle,
or other owned condition.

## Diagnose before adding retries

When a test flakes, inspect the Playwright trace, actionability log, console,
network, DOM snapshots, and application evidence. Classify the race:

- fixture/data leakage;
- ambiguous locator;
- missing application ready/terminal state;
- stale callback or competing state owner;
- animation/geometry dependency;
- external dependency or resource saturation;
- true cross-browser event difference.

Retries may collect evidence in CI, but they do not repair an ambiguous
contract.

## Temporal evidence

Use a trace for action/event/DOM chronology. Use video or a sampled frame sheet
for a visible flash, duplicated controls, motion, image decode, or geometry
transition. Instrument a stable parent with `MutationObserver`,
`ResizeObserver`, or animation-frame samples when exact overlap or movement is
the contract.

For screenshots:

- wait for explicit stable state, fonts, and relevant images;
- disable animation only when animation is not the behavior under test;
- mask genuinely non-contractual dynamic data;
- prefer component snapshots to full pages when the component is the contract;
- generate baselines in the same rendering environment as CI.

Report the failed phase and evidence. Avoid claiming that a final screenshot
proves intermediate frames were correct.
