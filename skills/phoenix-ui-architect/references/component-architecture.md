# Component architecture

## Build a meaningful hierarchy

| Boundary | Use when | Avoid when |
| --- | --- | --- |
| Private render helper | One module needs a small presentation fragment | Callers need attrs, slots, or reuse |
| Function component | Markup, semantics, variants, attrs, or slots form a cohesive presentation or interaction contract | The component must own state or perform hidden data access |
| LiveComponent | A stable component instance owns state plus event/update behavior | Splitting a long template is the only goal |
| LiveView | The surface owns routing, connection, subscriptions, or a complete task | It would create a nested route/process only for markup reuse |
| JavaScript hook | Browser API, third-party widget, or client state needs lifecycle reconciliation | CSS or `Phoenix.LiveView.JS` expresses the behavior |

Function components declare meaningful `attr` and `slot` contracts, accept
global attributes when the caller needs them, and merge a caller class with
defaults deliberately. Do not assume a generated input component merges custom
classes; inspect its implementation.

Compose a page from meaningfully named components. Small design-system
primitives, buttons, controls, rows, panels, sections, and complete task areas
are all valid boundaries when they name a recognizable UI responsibility.
Promote a page-specific component when a cohesive task or domain section,
semantic consistency, testing, or a stable design-system invariant justifies
the new API. Reuse is a benefit, not a prerequisite. A fixed number of call
sites and a file's line count are signals, not universal thresholds.

Group related function components in one colocated module. Introduce another
module/file when it names a distinct task, domain section, interaction
contract, or shared design-system responsibility that a reader can understand
independently. Do not create one module per function by default, and do not
preserve a monolith merely to minimize the number of files.

The route template should remain readable as an outline of the user journey.
The LiveView owns authorization, routing, subscriptions, orchestration, and
domain commands. A plain module can own cohesive normalization or form
serialization. A function component owns explicit presentation inputs and a
semantic interaction contract. This division lets a reader understand the
page without loading one giant template while preserving the real owners of
state and business rules.

Favor a clear component hierarchy over a monolith. The problem is not the
number or physical size of components. Avoid opaque boundaries that merely
rename incidental markup, require most of the parent's assigns, query hidden
data, duplicate domain logic, or force a reader to chase wrappers without
learning the page structure. A small component with an obvious semantic name
and narrow API can improve the assembly; a large component can still be the
right boundary when its choices must be understood together. Test stable
rendered contracts rather than private helper structure.

Function components run as ordinary render functions inside the owning
LiveView. They do not add a server process or a client round trip. LiveView can
retain granular HEEx change tracking across component boundaries when callers
pass explicit attrs and slots. Do not pass `{assigns}` wholesale to child HEEx
components: it disables the intended per-assign tracking and makes the API
opaque. Do not perform queries or expensive repeated work while rendering.

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
- Phoenix 1.6 component conventions, including grouping related functions:
  <https://www.phoenixframework.org/blog/phoenix-1.6-released>
- Phoenix 1.7 rendering and colocation conventions:
  <https://phoenixframework.org/blog/phoenix-1.7-final-released>
- JavaScript interoperability: <https://hexdocs.pm/phoenix_live_view/js-interop.html>
