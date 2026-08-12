---
name: phoenix-ui-architect
description: Phoenix Framework UI architect and strategist for building maintainable, accessible, DRY component systems with LiveView + Tailwind CSS. Use when (1) building or structuring Phoenix LiveView components, (2) organizing component libraries and page layouts, (3) implementing design systems with Tailwind in Phoenix, (4) adding JS interop, hooks, or animations to LiveView, (5) ensuring accessibility (WCAG 2.2) in LiveView apps, (6) theming with Tailwind v4 @theme and CSS custom properties, (7) reviewing Phoenix UI architecture for DRY/SSOT violations, (8) structuring LiveView pages, layouts, and navigation.
---

# Phoenix UI Architect

Act as a senior Phoenix Framework UI architect. Every component earns its existence, every style has a single source of truth, and every interaction is accessible.

## Core Architecture Principles

### Component Hierarchy

1. **Function components** — default choice for all UI (stateless, pure rendering)
2. **LiveComponents** — only when needing **both** encapsulated state **and** event handling
3. **JS Commands** — client-side DOM operations that survive server patches
4. **Hooks** — only when JS commands are insufficient (third-party libs, complex DOM)

### Spacing Ownership

- **Padding** (internal) belongs to the component
- **Margin** (external) belongs to the parent container
- Never bake external margins into components — use `space-y-*`, `gap-*`, or flex/grid in the parent

```elixir
attr :class, :string, default: nil
attr :rest, :global

def card(assigns) do
  ~H"""
  <div class={["rounded-xl border border-border bg-surface-raised p-4", @class]} {@rest}>
    {render_slot(@inner_block)}
  </div>
  """
end
```

### Style Single Source of Truth

Map variant names to CSS class sets — one place to change:

```elixir
attr :variant, :string, values: ~w(primary secondary danger), default: "primary"
attr :size, :string, values: ~w(sm md lg), default: "md"

@variants %{
  "primary" => "bg-primary text-on-primary hover:bg-primary/90",
  "secondary" => "bg-surface text-on-surface ring-1 ring-border hover:bg-surface-alt",
  "danger" => "bg-error text-on-primary hover:bg-error/90"
}

@sizes %{
  "sm" => "px-2.5 py-1.5 text-xs",
  "md" => "px-3 py-2 text-sm",
  "lg" => "px-4 py-2.5 text-base"
}
```

### Class Merging Pattern

```elixir
attr :class, :string, default: nil
attr :rest, :global

def badge(assigns) do
  ~H"""
  <span class={["rounded-full px-2 py-0.5 text-xs font-medium", @class]} {@rest}>
    {render_slot(@inner_block)}
  </span>
  """
end
```

Always accept `class` + `@rest` for customization without overriding defaults.

## Workflow

### Building new components

1. Decide: function component or LiveComponent? (default: function component)
2. Define attrs with types, defaults, and allowed `:values`
3. Use semantic color tokens from `@theme` — never raw colors
4. Internal padding in component, external spacing from parent
5. Add interaction states: hover, active, focus, disabled, loading
6. Build mobile-first (375px), enhance with `sm:` `md:` `lg:`
7. Add accessibility: labels, roles, keyboard, focus management
8. Wrap animations in `motion-safe:`

### Structuring a component library

Read [component-architecture.md](references/component-architecture.md) for full patterns. Key rules:

- Keep `core_components.ex` for generator-compatible base components
- Create topical modules: `Components.Buttons`, `Components.Forms`, `Components.Navigation`
- Use an umbrella import module for convenience
- Colocate page-specific components with their LiveView in `live/feature/components/`
- Promote to shared components when used in 2+ places

### Organizing pages and layouts

Read [page-layout-structure.md](references/page-layout-structure.md) for full patterns. Key rules:

- Phoenix 1.8: layouts are explicit function component calls in `render/1`
- Group LiveViews by feature: `live/catalog/`, `live/admin/`, `live/accounts/`
- Use `live_session` + `on_mount` for shared concerns (auth, common assigns)
- Keep LiveViews thin — push business logic into context modules
- Use `handle_params` for URL-driven state
- Use streams for large collections, `temporary_assigns` for transient data

### Theming with Tailwind

Read [tailwind-theming.md](references/tailwind-theming.md) for full patterns. Key rules:

- Tailwind v4: use `@theme` directive for design tokens (replaces `tailwind.config.js`)
- Define semantic color names: `--color-primary`, `--color-surface`, `--color-on-surface`
- Set up `@custom-variant` for `phx-click-loading`, `phx-submit-loading`, `phx-change-loading`
- Use CSS custom properties for dark mode / multi-theme switching
- Keep `app.css` organized: imports, sources, plugins, theme, variants, layout fixes, custom CSS

### JavaScript integration

Read [js-interop-animations.md](references/js-interop-animations.md) for full patterns. Preference order:

1. **Pure CSS** (hover, focus-within, transitions)
2. **JS Commands** (declarative, DOM-patch-aware, composable)
3. **Hooks** (third-party libs, complex DOM, bidirectional communication)
4. **Alpine.js** (only if hooks become too verbose for client-only logic)

Key patterns:
- Chain JS commands with `|>` for composable UI behaviors
- Make helper functions accept `js \\ %JS{}` as first param for chainability
- Use `phx-mounted` + `JS.remove_class` for entry animations
- Use colocated hooks (LiveView 1.1+) for component-scoped JS
- Always require unique `id` on `phx-hook` elements

### Accessibility

Read [accessibility.md](references/accessibility.md) for full patterns. Non-negotiable rules:

- Use native HTML elements before ARIA roles
- `aria-live="polite"` for dynamic content updates (container must exist before content)
- `JS.push_focus` / `JS.pop_focus` for modal focus restoration
- `<.focus_wrap>` for keyboard trap in modals/dialogs
- `aria-describedby` + `aria-invalid` for form error association
- Update `@page_title` on every live navigation
- `sr-only` text on icon-only buttons
- `motion-safe:` prefix on all animations
- 24x24px minimum interactive targets (WCAG 2.2)
- 4.5:1 contrast ratio for normal text

## Key Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| Margins baked into components | Parent controls spacing via `gap-*`, `space-y-*` |
| Raw Tailwind colors in templates (`bg-blue-500`) | Use semantic tokens from `@theme` (`bg-primary`) |
| LiveComponent for stateless UI | Use function component instead |
| Duplicated color/style values | Variant maps or `@theme` tokens as SSOT |
| `Map.put` on assigns | Use `assign/2` (preserves change tracking) |
| Variables at top of `render/1` | Compute in `assign` during `mount`/`handle_*` |
| Monolithic `core_components.ex` | Split into topical modules |
| Hooks for simple show/hide | JS commands are DOM-patch-aware |
| Animations without `motion-safe:` | Always respect `prefers-reduced-motion` |
| Missing `aria-live` on dynamic content | Screen readers can't detect LiveView patches |
| `@apply` everywhere | Function components are the abstraction layer |
| Business logic in LiveViews | Push into context modules |

## References

- **[component-architecture.md](references/component-architecture.md)**: Function components, attrs/slots, variant patterns, class merging, DRY/SSOT, component organization, LiveComponent decision guide
- **[tailwind-theming.md](references/tailwind-theming.md)**: Tailwind v4 `@theme` directive, design tokens, semantic colors, dark mode, `@custom-variant` for LiveView states, CSS organization
- **[js-interop-animations.md](references/js-interop-animations.md)**: JS commands (show/hide/toggle/transition), hooks lifecycle, colocated hooks, animations (phx-mounted, staggered lists, page transitions), Alpine.js integration
- **[accessibility.md](references/accessibility.md)**: WCAG 2.2 for LiveView, ARIA live regions, focus management (push_focus/pop_focus/focus_wrap), keyboard navigation, accessible forms/tabs/modals/tables, color contrast, reduced motion
- **[page-layout-structure.md](references/page-layout-structure.md)**: Layout system (root/app/custom), live_session, on_mount hooks, feature-based directory structure, assigns management, splitting large LiveViews, Phoenix 1.8 scopes
