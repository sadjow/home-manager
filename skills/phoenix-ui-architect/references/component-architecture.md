# Component architecture

## Choose the smallest boundary

| Boundary | Use when | Avoid when |
| --- | --- | --- |
| Private render helper | One module needs a small presentation fragment | Callers need attrs, slots, or reuse |
| Function component | Markup, semantics, variants, attrs, or slots form a reusable contract | The component must own events and state |
| LiveComponent | A stable component instance owns state plus event/update behavior | Splitting a long template is the only goal |
| LiveView | The surface owns routing, connection, subscriptions, or a complete task | It would create a nested route/process only for markup reuse |
| JavaScript hook | Browser API, third-party widget, or client state needs lifecycle reconciliation | CSS or `Phoenix.LiveView.JS` expresses the behavior |

Function components declare meaningful `attr` and `slot` contracts, accept
global attributes when the caller needs them, and merge a caller class with
defaults deliberately. Do not assume a generated input component merges custom
classes; inspect its implementation.

Promote a page-specific component when reuse, semantic consistency, testing,
or a stable design-system invariant justifies the new API. A fixed number of
call sites is evidence, not a universal threshold.

## Preserve patch ownership

A hook must have a stable unique ID and clean up listeners, observers, timers,
and external objects in lifecycle callbacks. `beforeUpdate` is synchronous.

Use `JS.ignore_attributes/1` for exact attributes the browser owns. Use
`phx-update="ignore"` only when the client owns the complete ignored subtree and
can reconcile server inputs independently. It is not a repair for flicker or a
state-ownership dispute.

## Keep assigns and collections intentional

Compute derived values before rendering when that improves change tracking.
Use streams when their update and memory semantics match a changing collection,
not as a blanket rule for every list. Track counts and empty states separately
when the stream API requires it. Use `update_many/1` or parent preloads to avoid
per-component query fan-out.

Keep DOM IDs stable across patches. Test the rendered component contract rather
than its private helper structure.

Primary references:

- Phoenix components: <https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html>
- LiveComponent: <https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html>
- JavaScript interoperability: <https://hexdocs.pm/phoenix_live_view/js-interop.html>
