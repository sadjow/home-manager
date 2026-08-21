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

## Handle concurrency explicitly

For counters, inventories, quotas, account links, and other contested state,
choose among atomic updates, optimistic revisions, unique/exclusion
constraints, or row/advisory locks according to the invariant. A prior read
followed by an unguarded write is not a concurrency strategy.
