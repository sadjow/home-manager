# Phoenix LiveView Component Architecture & DRY Patterns

## 1. Function Components (Phoenix 1.7+)

### core_components.ex

Phoenix 1.7+ generates a `core_components.ex` module containing base UI components (button, modal, table, input, flash). This file is the backbone of `phx.gen.html` and `phx.gen.live` generators. You customize it by replacing function definitions with your own framework/UI-specific implementations.

Components are auto-imported via `use MyAppWeb, :html`, making them available throughout the application without explicit imports.

### Attribute System (attr/3)

Declares component inputs with compile-time validation:

```elixir
attr :name, :string, required: true
attr :age, :integer, default: 0
attr :variant, :string, values: ~w(primary secondary danger)
attr :class, :any, default: nil
attr :rest, :global, include: ~w(href navigate patch disabled)

def button(assigns) do
  ~H"""
  <button class={["btn", variant_class(@variant), @class]} {@rest}>
    {render_slot(@inner_block)}
  </button>
  """
end
```

Key features:
- **`:required`** -- compile-time warning if caller omits it
- **`:default`** -- fallback value when not provided
- **`:values`** -- exhaustive list; compile warning for invalid literals
- **`:global`** -- captures undeclared HTML attributes (class, phx-click, etc.)
- **`:doc`** -- generates documentation; `doc: false` hides from docs

### Slot System (slot/3)

Slots pass blocks of HEEx content into components:

```elixir
slot :inner_block, required: true

def card(assigns) do
  ~H"""
  <div class="card">
    {render_slot(@inner_block)}
  </div>
  """
end
```

Named slots with attributes enable flexible composition:

```elixir
slot :column, required: true do
  attr :label, :string, required: true
end

attr :rows, :list, default: []

def table(assigns) do
  ~H"""
  <table>
    <tr>
      <th :for={col <- @column}>{col.label}</th>
    </tr>
    <tr :for={row <- @rows}>
      <td :for={col <- @column}>{render_slot(col, row)}</td>
    </tr>
  </table>
  """
end
```

Usage with `:let` binding:

```elixir
<.table rows={@users}>
  <:column :let={user} label="Name">{user.name}</:column>
  <:column :let={user} label="Age">{user.age}</:column>
</.table>
```

### Function Components vs Live Components

**Default to function components.** The official recommendation from Jose Valim and the Phoenix docs:

> "Generally speaking, you should prefer functional components over live components, as they are a simpler abstraction, with a smaller surface area."

**Function components** (stateless, pure rendering):
- Reusable UI elements (buttons, inputs, cards, modals)
- Display-only components
- Layout wrappers
- Any UI that derives entirely from assigns

**Live components** (stateful, with lifecycle):
- Complex self-contained UI (calendar with day/week/month views, internal navigation)
- Components needing PubSub subscriptions (`handle_info`)
- Optimization when diff payloads become large
- Components requiring their own event handling that would bloat the parent

Rule of thumb: if a component needs **both** internal state management **and** event handling, consider a live component. Otherwise, use a function component and handle events in the parent LiveView.

### embed_templates/1

Separate HEEx files from module code:

```elixir
defmodule MyAppWeb.Components.Cards do
  use Phoenix.Component

  embed_templates "cards/*"

  # Declarations without body -- template loaded from file
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  def pricing_card(assigns)
end
```

## 2. DRY/SSOT Component Patterns

### Spacing: Parent Responsibility

Components should NOT have built-in external margins. The parent controls spacing between its children.

**Why:** A button with hardcoded margin will break layouts where different spacing is needed. Components become context-dependent and less reusable.

```elixir
# Anti-pattern: margin baked into component
def card(assigns) do
  ~H"""
  <div class="card p-4 mb-6"> <!-- mb-6 is problematic -->
    {render_slot(@inner_block)}
  </div>
  """
end

# Correct: parent controls spacing
def card(assigns) do
  ~H"""
  <div class={["card p-4", @class]} {@rest}>
    {render_slot(@inner_block)}
  </div>
  """
end

# Parent handles layout spacing
~H"""
<div class="space-y-6">
  <.card>First</.card>
  <.card>Second</.card>
</div>
"""
```

**Guidelines:**
- **Padding** (internal spacing) belongs to the component itself
- **Margin** (external spacing) belongs to the parent/container
- Use Tailwind's `space-y-*`, `gap-*`, or flex/grid for parent-managed spacing
- Accept a `class` attr so parents can add layout classes when needed

### Sharing Styles: Variant Pattern

Map variant names to CSS class sets using Elixir maps:

```elixir
attr :variant, :string, values: ~w(primary secondary danger), default: "primary"
attr :size, :string, values: ~w(sm md lg), default: "md"

def button(assigns) do
  variants = %{
    "primary" => "bg-indigo-600 text-white hover:bg-indigo-500",
    "secondary" => "bg-white text-gray-900 ring-1 ring-gray-300 hover:bg-gray-50",
    "danger" => "bg-red-600 text-white hover:bg-red-500"
  }

  sizes = %{
    "sm" => "px-2.5 py-1.5 text-xs",
    "md" => "px-3 py-2 text-sm",
    "lg" => "px-4 py-2.5 text-base"
  }

  assigns = assign(assigns, :variant_classes, variants[@variant])
  assigns = assign(assigns, :size_classes, sizes[@size])

  ~H"""
  <button class={["rounded font-semibold", @variant_classes, @size_classes, @class]} {@rest}>
    {render_slot(@inner_block)}
  </button>
  """
end
```

### Merging Custom Classes

Use list syntax in the `class` attribute to merge defaults with caller customizations:

```elixir
attr :class, :string, default: nil
attr :rest, :global

def avatar(assigns) do
  ~H"""
  <img class={["rounded-full object-cover", @class]} {@rest} />
  """
end

# Caller adds size without overriding shape
<.avatar src={@user.avatar_url} class="w-10 h-10" />
# Result: class="rounded-full object-cover w-10 h-10"
```

**Warning:** Using `:global` with a default class means caller-provided `class` **overrides** the default entirely. Prefer the explicit `attr :class` + list merge pattern.

### Tailwind Variants for LiveView States

Configure custom Tailwind variants for Phoenix-specific loading states:

```javascript
// tailwind.config.js
const plugin = require('tailwindcss/plugin')

module.exports = {
  plugins: [
    plugin(({addVariant}) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({addVariant}) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({addVariant}) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({addVariant}) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &']))
  ]
}
```

Usage:

```elixir
<button phx-click="save" class="bg-indigo-600 phx-click-loading:animate-pulse phx-click-loading:opacity-75">
  Save
</button>
```

## 3. Component Structure & Organization

### Recommended Directory Structure

```
lib/my_app_web/
  components/
    core_components.ex          # Generated base components (button, input, table, modal)
    layouts.ex                  # Layout components (app, root)
    layouts/
      app.html.heex
      root.html.heex
  live/
    feature_name/
      index_live.ex
      show_live.ex
      components/
        item_component.ex       # LiveComponents colocated with feature
        item_component.html.heex
```

### Module Organization Strategies

**Strategy 1: Topical Modules (recommended for growing projects)**

```elixir
defmodule MyAppWeb.Components.Buttons do
  use Phoenix.Component

  def button(assigns), do: ...
  def icon_button(assigns), do: ...
  def link_button(assigns), do: ...
end

defmodule MyAppWeb.Components.Forms do
  use Phoenix.Component

  def input(assigns), do: ...
  def select(assigns), do: ...
  def checkbox(assigns), do: ...
end
```

**Strategy 2: Umbrella Import Module**

```elixir
defmodule MyAppWeb.Components do
  defmacro __using__(_) do
    quote do
      import MyAppWeb.Components.Buttons
      import MyAppWeb.Components.Forms
      import MyAppWeb.Components.Feedback
      import MyAppWeb.Components.Navigation
    end
  end
end

# In live_view helper:
def live_view do
  quote do
    use MyAppWeb.Components
    # ...
  end
end
```

**Strategy 3: Keep core_components.ex for generators + extend with new modules**

Keep the generator-used components in `core_components.ex` and add new modules for feature/domain components. This preserves generator compatibility while scaling.

### Naming Conventions

- **Function component modules:** `MyAppWeb.Components.Buttons`, `MyAppWeb.Components.Forms`
- **LiveView modules:** suffix with `Live` -- `ShowLive`, `IndexLive`
- **LiveComponent modules:** suffix with `Component` -- `ItemComponent`, `FilterComponent`
- **Component functions:** snake_case, descriptive -- `button/1`, `data_table/1`, `flash_group/1`

### Component Hierarchy (Atomic Design adapted)

1. **Primitives/Atoms:** Button, Input, Badge, Avatar, Icon
2. **Molecules:** FormField (label + input + error), Card (header + body + footer)
3. **Organisms:** Navbar, Sidebar, DataTable, Modal with form
4. **Page-specific:** Components used in only one LiveView, colocated with that LiveView

### Reusable vs Page-Specific

- **Reusable components** go in `lib/my_app_web/components/` -- imported globally
- **Page-specific components** go in `lib/my_app_web/live/feature/components/` -- imported locally
- If a "page-specific" component is used in 2+ places, promote it to the shared components directory

## 4. Anti-Patterns to Avoid

### Never Modify assigns with Map Functions

```elixir
# WRONG: breaks change tracking
def my_component(assigns) do
  assigns = Map.put(assigns, :full_name, "#{assigns.first} #{assigns.last}")
  ~H"<span>{@full_name}</span>"
end

# CORRECT: use assign/2
def my_component(assigns) do
  assigns = assign(assigns, :full_name, "#{assigns.first} #{assigns.last}")
  ~H"<span>{@full_name}</span>"
end
```

### Never Define Variables at Top of render/1

```elixir
# WRONG: LiveView cannot track these for diffing
def render(assigns) do
  total = assigns.price * assigns.quantity
  ~H"<span>Total: {total}</span>"
end

# CORRECT: compute in assign
def mount(_params, _session, socket) do
  {:ok, assign(socket, total: price * quantity)}
end
```

### Never Pass Full Socket Assigns to Templates

```elixir
# WRONG: sends all assigns over wire even if unused
render(assigns)

# CORRECT: pass only needed assigns
~H"<.component name={@name} age={@age} />"
```

### Avoid LiveComponents for Simple UI

Do not use `live_component` for stateless rendering or as "mini-controllers." Use function components instead and handle events in the parent LiveView.

### Avoid Baking External Margins into Components

Components with hardcoded margins are inflexible. Let the parent control spacing.

### Avoid Monolithic core_components.ex

As the project grows, split into topical modules. A single file with 50+ components becomes hard to navigate and maintain.

### Avoid Duplicating Style Knowledge

```elixir
# WRONG: same color repeated across components
def success_badge(assigns), do: ~H"<span class='bg-green-100 text-green-800'>...</span>"
def success_alert(assigns), do: ~H"<div class='bg-green-100 text-green-800'>...</div>"

# BETTER: extract shared color tokens
@success_colors "bg-green-100 text-green-800"
def success_badge(assigns), do: ~H"<span class={@success_colors}>...</span>"
```

Or use variant maps as the single source of truth.

## 5. Key Patterns Summary

| Pattern | When to Use |
|---------|-------------|
| Function component | Default for all UI components |
| Live component | Only when needing internal state + event handling |
| Variant maps | Mapping named variants to CSS class sets |
| Class list merging | `class={["defaults", @class]}` for customizable components |
| Named slots with attrs | Flexible content areas (table columns, modal sections) |
| `:let` bindings | Passing component data back to slot content |
| `:global` attrs | Accepting arbitrary HTML attributes |
| `embed_templates` | Separating large HEEx from module code |
| Parent-managed spacing | Margins via parent containers, not child components |
| Topical modules | Organizing components by domain/purpose |

## Sources Consulted

- [Components and HEEx - Phoenix v1.8.3 Official Docs](https://hexdocs.pm/phoenix/components.html)
- [Phoenix.Component - Phoenix LiveView v1.1.22](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html)
- [Reuse markup with function components and slots - The Phoenix Files (Fly.io)](https://fly.io/phoenix-files/function-components/)
- [Custom styling with LiveView function component attributes - The Phoenix Files](https://fly.io/phoenix-files/customizable-classes-lv-component/)
- [Phoenix LiveView Tailwind Variants - The Phoenix Files](https://fly.io/phoenix-files/phoenix-liveview-tailwind-variants/)
- [Phoenix core_components.ex template - GitHub](https://github.com/phoenixframework/phoenix/blob/main/installer/templates/phx_web/components/core_components.ex)
- [Building Scalable UI Systems in Phoenix LiveView - DEV Community](https://dev.to/hexshift/building-scalable-ui-systems-in-phoenix-liveview-with-reusable-heex-components-1m3j)
- [When to use a live component, instead of a functional component? - Elixir Forum](https://elixirforum.com/t/when-to-use-a-live-component-instead-of-a-functional-component/58775)
- [How do you organize your components with Phoenix 1.7? - Elixir Forum](https://elixirforum.com/t/how-do-you-organize-your-components-with-phoenix-1-7/53901)
- [LiveView Design Patterns - LiveComponent and SRP - Elixir School](https://elixirschool.com/blog/live-view-live-component)
- [Phoenix Development Code Conventions - Nimble](https://nimblehq.co/compass/development/code-conventions/elixir/phoenix/)
- [Phoenix Components: Reusable Web Application Building Blocks - Curiosum](https://www.curiosum.com/blog/phoenix-component)
- [How to write reusable components in Phoenix LiveView - LogRocket](https://blog.logrocket.com/write-reusable-components-phoenix-liveview/)
- [Handling spacing in a UI component library - FED or Dead](https://medium.com/fed-or-dead/handling-spacing-in-a-ui-component-library-70f3b22ec89)
- [Phoenix 1.7.0 released - Phoenix Blog](https://phoenixframework.org/blog/phoenix-1.7-final-released)
