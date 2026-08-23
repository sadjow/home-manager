---
name: playwright-reactive-ux-testing
description: Create, diagnose, or review focused Playwright tests for reactive interfaces where timing and state ownership affect local acknowledgement, rapid input, gesture cancellation, debounced forms, DOM replacement, disconnect/reconnect, reload recovery, focus, responsive geometry, reduced motion, and temporal evidence. Use as a specialization for reactive UX; ordinary Playwright setup or broad browser testing may use a general Playwright workflow alone.
---

# Playwright Reactive UX Testing

Use Playwright to prove behavior that a server/component test cannot observe.
Keep domain logic at its owning test layer and write the smallest browser
regression that preserves the timing or gesture mechanism.

## Reproduce before repairing

When safe and deterministic, add the focused regression against unfixed
behavior and confirm it fails for the intended reason. Record whether failure
occurs before local paint, during the request, during DOM replacement, or after
layout/focus settles.

Prefer user-facing locators, isolated state, and web-first assertions. Do not
replace an observable condition with `waitForTimeout`. The official Playwright
guidance is the baseline: <https://playwright.dev/docs/best-practices>.

Read [reactive state matrix](references/reactive-state-matrix.md) to choose
client, server, and recovery assertions.

## Exercise real activation and connection boundaries

A synthetic click does not prove touch-pan cancellation. A delayed response
does not prove reconnect. A reconnect does not prove reload. Use the browser
and application helpers that trigger the real boundary, and verify both the
immediate and terminal state.

Read [gesture and connection testing](references/gesture-and-connection-testing.md)
for held presses, pans, keyboard activation, cold join, reconnect, and reload.

## Capture temporal evidence proportionally

Use traces, videos, frame sheets, mutation/resize observation, or performance
marks only when the final DOM cannot reveal a flash, duplicate frame, stale
reply, or geometry jump. Keep screenshots deterministic and reserve visual
baselines for stable visual contracts.

Read [evidence and flake diagnostics](references/evidence-and-flake-diagnostics.md)
before adding waits, retries, screenshots, or traces.

## Choose execution scope and data ownership

Do not make a broad browser matrix an automatic gate merely because Playwright
coverage exists. Keep fast domain and component tests broad, then select local,
manual-CI, scheduled, or release browser evidence according to the user-visible
risk and measured signal-to-cost ratio.

Read [execution topology and data isolation](references/execution-topology-and-data-isolation.md)
before resetting a database, increasing workers, sharding a suite, or adding a
Playwright workflow to CI.
