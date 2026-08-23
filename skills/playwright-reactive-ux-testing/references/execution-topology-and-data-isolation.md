# Execution topology and data isolation

## Put each contract at the cheapest reliable layer

Use unit, domain, server-rendered, or component tests for rules they can prove
directly. Use a real browser for browser-owned behavior such as actionability,
focus, gesture classification, history, responsive geometry, DOM replacement,
reconnect, reload, or a multi-role journey.

Choose browser scope proportionally:

- run the affected spec and primary project during ordinary development;
- add the breakpoints whose composition changes;
- add another engine only for an engine-sensitive boundary;
- reserve broad matrices for high-risk changes, release evidence, or a measured
  regression pattern that smaller selections miss.

Automatic CI, manual CI, scheduled runs, and release checks are different
policies. Estimate setup multiplicity, runner minutes, flake rate, diagnostic
value, and deployment delay before choosing one. A retry can collect a trace;
it does not turn an unstable contract into a passing one.

## Isolate external-browser data deliberately

Never reset a development, shared test, staging, or production database from a
browser harness. For a simple external-browser topology, give the suite a
dedicated disposable database, guard its exact name, recreate it once per run,
and keep one application server as the owner of that run.

One worker is the safe default when tests share application-global state or a
single database. Serial execution is not a substitute for isolated test data,
but it prevents hidden concurrency until ownership is explicit.

For true parallelism, use one of two complete topologies:

1. Give each shard its own application process, port, database, and artifacts.
2. Use the framework's transactional acceptance-test bridge so each browser
   receives its own database ownership metadata across HTTP, WebSockets, and
   background processes.

Do not partially combine these designs. A database sandbox without metadata on
the WebSocket or an additional process produces ownership failures; multiple
workers against one mutable application can race even when rows are unique.

Keep browser artifacts private and short-lived when URLs, cookies, authored
content, capabilities, or test identities can appear in traces and videos.

Official references:

- [Playwright continuous integration](https://playwright.dev/docs/ci)
- [Playwright best practices](https://playwright.dev/docs/best-practices)
- [Phoenix Ecto SQL Sandbox](https://hexdocs.pm/phoenix_ecto/Phoenix.Ecto.SQL.Sandbox.html)
- [Ecto SQL Sandbox](https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html)
