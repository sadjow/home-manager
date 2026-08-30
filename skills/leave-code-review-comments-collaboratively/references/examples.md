# Collaborative Code Review Comment Examples

Use these examples as patterns, not fixed templates. Preserve the evidence, uncertainty, and repository conventions of the current review.

## Verified blocker

```text
issue (blocking): Validate `redirect_url` against the allowlist before calling `redirect_to`. Otherwise, an attacker can send users to an external domain through this endpoint.
```

## Genuine question

```text
question: Should an expired token return `401` or `403` here? The other authentication paths return `401`, so I want to confirm whether this difference is intentional.
```

## Conditional concern

```text
question: Can `account` be `nil` here? If so, `account.id` raises before the fallback runs.
```

Do not rewrite the conditional claim as a certain crash unless the call path proves that `account` can be `nil`.

## Outcome before implementation

```text
issue (blocking): Payment retries can charge the customer twice. Please make capture idempotent across repeated requests; a service object is one possible implementation.
```

## Concurrency finding

```text
issue (blocking): Make job creation idempotent across repeated webhook delivery.

Two workers can pass the existence check before either inserts the row, which can enqueue the same charge twice.

Please enforce uniqueness at the database boundary and treat the conflict as an already-processed event.
```

## Optional improvement

```text
suggestion (non-blocking): Consider extracting this condition into `eligible_for_discount?`. The name would make the business rule easier to scan and test.
```

## Nitpick

```text
nitpick (non-blocking): Rename `usr` to `user` to match the surrounding code.
```

## Specific praise

```text
praise: Moving the filtering rule into `AvailableEventsQuery` keeps the resolver thin and makes the rule easier to test and reuse.
```

## Repeated root cause

Leave one comment at the most representative location:

```text
issue (blocking): Use parameterized queries for these filters so user input is not interpolated into SQL. The same pattern appears in `by_email`, `by_name`, and `by_company`; please update all three paths.
```

Do not copy the full comment to all three locations.

## Review summary

```markdown
Two findings block merge:

1. Prevent duplicate jobs when the webhook is retried.
2. Add coverage for a Redis timeout during lock acquisition.

The remaining naming comments are optional.
```
