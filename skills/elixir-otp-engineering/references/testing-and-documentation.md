# Testing and documentation

## Test behavior at the owning layer

- Pure functions: representative values, boundaries, and property-like
  invariants.
- Contexts and Ecto: constraints, authorization, rollback, locks, and
  post-commit effects with the real test database.
- OTP processes: public API, crash/restart semantics, mailbox ordering only
  where contractual, and cleanup of timers/resources.
- Durable jobs: argument validation, retry classification, idempotent replay,
  stale state, and terminal failure handling.
- External adapters: complete recorded request/response or handshake shapes,
  including fields that choose branches. A hand-built subset proves only that
  subset.

Prefer deterministic synchronization to sleeps. Use monitors, messages,
telemetry, sandbox allowances, or eventual assertions tied to an observable
condition.

For a reproducible defect, add the smallest regression and confirm the unfixed
behavior fails for the intended reason. If red-first execution would mutate a
live system, depend on unreliable timing, or require unavailable infrastructure,
state that boundary and add the regression immediately after the fix.

## Use line coverage as a diagnostic

Prefer the coverage engine already provided by the pinned Elixir toolchain
when a project only needs local visibility. Keep instrumentation outside the
ordinary test and quality paths when feedback speed matters; enable it through
an explicit command instead of slowing every run.

Treat coverage as evidence about executed lines, not proof of behavior. It does
not establish branch semantics, authorization, transaction rollback, process
ordering, browser timing, accessibility, or useful assertions. Add tests for
those contracts at their owning layer, then use the HTML or per-module report
to find important code the suite still misses.

A focused test invocation can help while changing one capability, but its
overall percentage can include every compiled module and is not a project-wide
baseline. Compare repository trends only with equivalent full-suite runs. Do
not add a minimum threshold or automatic CI gate unless the project explicitly
chooses that policy and has measured the runtime and baseline impact.

## Document useful contracts

Write `@moduledoc` for public concepts and `@doc` where callers need behavior,
errors, ownership, units, side effects, or examples that names and specs do not
already reveal. Use `@moduledoc false`/`@doc false` for intentionally internal
surfaces when the project convention calls for it.

Add `@spec` when it improves public contracts, Dialyzer value, callback
clarity, or maintenance. Do not add vague `term() -> term()` specs merely to
claim coverage.

Use doctests for deterministic, self-contained examples that are valuable as
both documentation and tests. Avoid doctests for database, time, random,
process, or external-system behavior that needs hidden setup or brittle output.

Keep the first documentation sentence concise, link modules/functions with
ExDoc syntax, and make examples reflect the real public API. Build docs only
when the repository supports that gate.
