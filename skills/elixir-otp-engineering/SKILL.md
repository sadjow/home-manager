---
name: elixir-otp-engineering
description: Design, implement, diagnose, or review Elixir and OTP systems, including process ownership, supervision, concurrency, Ecto transactions, durable jobs, idempotency, tests, and public documentation. Use for BEAM-specific architecture or production behavior; do not activate for unrelated languages or purely visual Phoenix work.
---

# Elixir and OTP Engineering

Build with the versions and conventions actually pinned by the repository.
Inspect `mix.exs`, `mix.lock`, the supervision tree, nearby contexts, tests, and
runtime topology before prescribing an abstraction.

## Choose ownership before machinery

1. Model the operation as plain functions and immutable data first.
2. Introduce a process only when something owns a lifecycle, resource,
   serialized protocol, mailbox, or restart boundary.
3. Use a `Task` for bounded concurrent work tied to its caller, a supervised
   task when failure ownership must be explicit, and a durable job system when
   work must survive requests, processes, nodes, retries, or deploys.
4. Bound concurrency, queue growth, timeouts, retries, and memory. Supervision
   restarts processes; it does not restore lost business intent.
5. Keep domain idempotency independent from transport or queue deduplication.

Read [process and work ownership](references/process-and-work-ownership.md)
when selecting a process, supervisor, task, or job boundary.

## Protect data and effects

- Keep trusted domain commands separate from transport and presentation.
- Back race-sensitive validation with database constraints and locks at the
  aggregate that owns the invariant.
- Keep external calls out of database transactions. Emit messages, enqueue
  dependent work, or notify other systems only after the outermost commit, or
  use a transactional outbox when the effect must be durable.
- Treat every job and external callback as retryable. Persist an idempotency
  identity that reflects the business operation, not a process PID or attempt.

Read [Ecto and side effects](references/ecto-and-side-effects.md) for
transactions, constraints, locks, and job insertion decisions.

## Verify the contract

Test public outcomes, failure semantics, restart/retry behavior, concurrency
races, and resource cleanup. Prefer a focused failing regression before a safe
bug fix. Document the public contract and non-obvious lifecycle; do not force
doctests or exhaustive docs onto internal code where they reduce clarity.

Read [testing and documentation](references/testing-and-documentation.md) when
adding ExUnit coverage, specs, moduledocs, docs, or doctests.

Run the repository's focused checks first, then its declared full quality
command. Report measured behavior separately from architectural inference.
