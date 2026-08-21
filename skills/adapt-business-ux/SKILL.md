---
name: adapt-business-ux
description: Analyze business operations and turn flexible domain capabilities into simple, context-aware user experiences. Use for merchant onboarding, catalog authoring, checkout, requests, quotes, bookings, queues, fulfillment, regional settings, or administration across business types; when technical terminology, generic forms, unsafe defaults, or one vertical's assumptions harm the experience; and when deciding field ownership or progressive disclosure without hard-coding the product model.
---

# Adapt Business UX

Convert business complexity into a short novice-friendly path while preserving
a reusable domain model. Treat the task as business analysis, product design,
content design, and implementation planning, not visual styling alone.

## Start from evidence and actors

Inspect the current product, domain model, data, translations, analytics,
tests, and repository guidance. Identify the customer completing a job and the
business owner configuring or operating it. Write each immediate job in plain
language and separate root cause from visual symptoms.

Prefer observed attempts, support questions, repeated requests, and pilot
operation over imagined completeness. State assumptions and validation gaps.

Read [business UX patterns](references/patterns.md) for capability mappings,
field treatments, and evidence levels.

## Classify every decision

Put each field, rule, or option in one bucket:

- invariant required across supported businesses;
- inherited default owned by account, organization, location, or market;
- contextual choice for the current item/request/customer intent;
- optional detail after the essential path;
- advanced configuration or exception;
- business-authored fact the system must not invent.

Ask once at the owning level. Keep price, availability, capacity, trust, legal
readiness, address, and schedule explicitly authored or verified.

## Design the essential path

- Ask only what is needed for the next useful outcome.
- Order decisions by the person's mental model, not the schema.
- Use familiar labels, recognizable choices, reviewed defaults, and contextual
  examples.
- Keep the common path visible; group optional details; move durable policy to
  focused settings; use a page for substantial/returnable work and a modal or
  sheet for a small contextual edit.
- Preserve an explicit escape hatch for unknown, mixed, and future businesses.
- Keep stable codes in the domain and translate them at the interface boundary.
  Placeholders guide input and never become facts.

## Check both sides

For each customer action, define the responsible operating unit, required
information, status, owner correction/rejection/completion path, and behavior
when configuration is incomplete. Compose products, services, reservations,
quotes, queues, delivery, pickup, or on-site capabilities rather than creating
one hard-coded application per vertical.

## Produce and validate a decision package

Record jobs/actors, root cause, decision ownership, recommended flow,
copy/default matrix, domain impact, edge cases, success evidence, and deferred
scope. When implementing, centralize contextual mappings, preserve existing
data, add translations and semantic controls, acknowledge async input locally,
and test narrow mobile, desktop, latency, recovery, reduced motion, and an
unusual business or regional path.

Do not add infrastructure or visible complexity merely because AI makes it
cheap to build. Keep flexible foundations compatible with progressive,
evidence-backed activation.
