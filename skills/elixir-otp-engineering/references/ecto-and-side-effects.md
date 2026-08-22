# Ecto and side effects

## Keep invariants at the owning boundary

- Cast only fields the caller is authorized to author. Set actor, tenant, and
  ownership fields explicitly.
- Use changeset validation for useful feedback and database constraints for
  race-safe enforcement.
- Preload associations before a template, serializer, or policy reads them.
  Measure query shape before adding caches or denormalized columns.
- Lock the aggregate or rows whose topology or invariant is changing. Locking a
  convenient child is insufficient when another command can modify the parent.

## Compose transactions deliberately

Use ordinary control flow inside `Repo.transact/2` when the sequence is simple.
Use `Ecto.Multi` when named operations, composition, inspection, or dynamic
steps materially clarify the transaction. Current Ecto guidance notes that
regular transactional control flow is often simpler for fixed operations:
<https://ecto.hexdocs.pm/Ecto.Multi.html>.

Return explicit domain errors. Remember that a database error may abort the
transaction, so do not continue issuing queries after a constraint failure
unless the API handles it through a changeset or rollback boundary.

## Delay external effects

A database rollback cannot undo an email, PubSub broadcast, HTTP call, object
write, or message already delivered. Prefer this sequence:

1. Validate and lock the owning data.
2. Persist the state transition and any outbox/job intent in one transaction.
3. Commit.
4. Publish or execute the effect from committed intent.

When a nested context suppresses its usual broadcast, the outer owner must
emit the equivalent effect immediately after the successful outer commit.

Use an outbox or durable job when losing the process between commit and effect
would violate the contract. Make consumers idempotent because delivery may be
at least once.

Anchor recipient work to a durable domain or outbox row instead of freezing a
mutable account identifier in every queued job. Resolve current ownership and
authorization at execution so account consolidation and access revocation do
not strand or misroute work. Keep the request transaction at constant or
bounded enqueue cost, then expand large recipient sets through paged fan-out
jobs. Run each provider call inside its durable delivery job; starting an
asynchronous task does not prove delivery. Queue uniqueness controls duplicate
insertion, not exactly-once provider acceptance.

When recipient identity can merge, use a unique durable recipient-event row as
the fan-out cursor and repeatedly query the bounded set still missing that row.
A cursor made from a mutable account identifier can skip a survivor. Follow one
global lock order across merge and materialization commands, and scope in-app
list, count, open, and broadcast paths to current authorization. Rechecking only
the external provider job does not prevent stale internal disclosure.

When a cursor pages child resources owned by an account that can merge, carry
the owner identity or generation with the cursor. If ownership changes between
pages, restart from the beginning and let idempotent child jobs absorb replay.
Applying a cursor from one owner generation to another can silently skip
children that sort before the old cursor.

## Handle concurrency explicitly

For counters, inventories, quotas, account links, and other contested state,
choose among atomic updates, optimistic revisions, unique/exclusion
constraints, or row/advisory locks according to the invariant. A prior read
followed by an unguarded write is not a concurrency strategy.
