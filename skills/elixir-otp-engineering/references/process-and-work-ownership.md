# Process and work ownership

## Select by semantics

| Need | Prefer | Boundary |
| --- | --- | --- |
| Pure transformation or orchestration | Plain function/module | No process is justified |
| Short work whose result belongs to the caller | `Task` or `Task.async_stream/3` | Caller failure and timeout semantics are intentional |
| Short work that needs a supervised failure boundary | `Task.Supervisor` | The caller still owns reconciliation |
| Serialized state or an owned runtime resource | `GenServer` or a purpose-built OTP behaviour | The process owns a protocol and lifecycle, not merely a map |
| Simple process state with no richer protocol | `Agent` | Keep callbacks small and free of hidden domain orchestration |
| Restartable or delayed business work | A durable job system | Persist intent, retries, idempotency, and observability |

Do not choose a process for namespace, code organization, or imagined scale.
Processes make ownership and failure explicit; they do not make CPU or I/O work
free.

## Bound concurrency

Use `Task.async_stream/3` when mapping a bounded collection concurrently. Set
`max_concurrency`, `timeout`, ordering, and failure behavior from the actual
contract. An infinite timeout is appropriate only when the caller is allowed to
wait indefinitely and cancellation is handled elsewhere.

For services and queues, define:

- maximum concurrent work per dependency;
- maximum accepted backlog and overload response;
- deadlines for calls and external operations;
- retry classes, delay, and terminal failure handling;
- telemetry for queue time, execution time, outcome, and saturation.

## Design supervision from failure domains

Group children that should start, stop, or restart together. Name processes
only when callers need stable discovery or inspection. Avoid global names when
a registry, explicit PID, or dependency injection keeps scope clearer.

`let it crash` means unexpected process failure is isolated and supervised. It
does not mean discarding validation errors, swallowing partial effects, or
replaying non-idempotent work without reconciliation.

## Durable jobs

Persist only stable identifiers and bounded arguments. Load current domain
state inside the worker, authorize again where needed, and make each attempt
safe to repeat.

Queue uniqueness normally controls insertion, not execution concurrency or the
domain's exactly-once contract. For Oban, inspect the pinned documentation:
<https://oban.hexdocs.pm/unique_jobs.html>. Configure a uniqueness period and
states deliberately, inspect `conflict?` when it matters, and still enforce the
business invariant with durable state or a database constraint.
