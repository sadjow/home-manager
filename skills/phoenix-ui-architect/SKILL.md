---
name: phoenix-ui-architect
description: Design, implement, or review Phoenix UI architecture with HEEx, function components, LiveComponents, forms, layouts, navigation, hooks, Tailwind, and design tokens. Use for Phoenix-specific presentation structure; use a resilient LiveView skill when timing, reconnect, or browser/server state ownership is the main problem.
---

# Phoenix UI Architect

Inspect the pinned Phoenix, LiveView, and Tailwind versions plus the project's
web module, core components, layouts, router, and nearby patterns before
choosing an API. Generator guidance and local components outrank generic
recipes.

## Structure by ownership

- Use function components for reusable presentation and semantic invariants.
- Use a LiveComponent only when it owns a meaningful state/event boundary or
  isolated update lifecycle. It shares the parent LiveView process; it is not a
  supervision or PubSub boundary.
- Keep business rules in contexts or domain modules. LiveViews coordinate
  presentation, URL state, and user events.
- Use hooks only for browser capabilities or state that Phoenix commands cannot
  express clearly. Give every client-mutated attribute one explicit owner.

Read [component architecture](references/component-architecture.md) before
creating or splitting components.

## Preserve native form and navigation behavior

Use `to_form/2`, project form/input components, stable IDs, verified routes,
and semantic HTML. Keep no-JavaScript submission, constraint validation,
submitter intent, and accessible labels. Make URL-owned state bookmarkable and
use full navigation when persistent root-layout metadata must change without an
explicit LiveView head-update mechanism.

Read [forms and navigation](references/forms-and-navigation.md) for forms,
layouts, route sessions, metadata, and focus boundaries.

## Keep styling maintainable

Reuse the repository's tokens and component variants. The parent owns external
layout and the component owns its internal spacing. Use mobile-first layouts,
content-driven breakpoints, readable line lengths, and stable geometry. Do not
add dark mode, animation, a new component layer, or advanced CSS merely because
the platform supports it.

Read [Tailwind and layout](references/tailwind-and-layout.md) when changing
tokens, themes, responsive composition, or component styling.

Verify rendered semantics, keyboard behavior, translation wrapping, 320 px
reflow, desktop composition, and the project quality command. Load a dedicated
accessibility skill for high-risk widgets and a resilient LiveView skill for
latency, patches, reconnects, or client-owned state.
