# Component Architecture

## Function Components (Default Choice)

### Attribute System

```elixir
attr :name, :string, required: true
attr :variant, :string, values: ~w(primary secondary danger), default: "primary"
attr :class, :string, default: nil
attr :rest, :global, include: ~w(href navigate patch disabled)

def button(assigns) do
  ~H"""
  <button class={["btn", variant_class(@variant), @class]} {@rest}>
    {render_slot(@inner_block)}
  </button>
  """
end
```

- `:required` — compile-time warning if omitted
- `:values` — exhaustive list, compile warning for invalid literals
- `:global` — captures undeclared HTML attributes (class, phx-click, data-*)
- `:doc` — generates documentation; `doc: false` hides from docs

### Slot System

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

`:let` bindings pass data back to slot content:

```elixir
<.table rows={@users}>
  <:column :let={user} label="Name">{user.name}</:column>
  <:column :let={user} label="Age">{user.age}</:column>
</.table>
```

### embed_templates for Separated HEEx

```elixir
defmodule MyAppWeb.Components.Cards do
  use Phoenix.Component
  embed_templates "cards/*"

  attr :title, :string, required: true
  def pricing_card(assigns)
end
```

## When to Use LiveComponents

**Function component** (default):
- Reusable UI (buttons, inputs, cards, modals)
- Display-only, derives entirely from assigns
- Layout wrappers

**LiveComponent** (only when needed):
- Complex self-contained UI (calendar, rich editor)
- Needs PubSub subscriptions (`handle_info`)
- Needs encapsulated state + event handling
- Optimization when diff payloads are large

Rule: if it doesn't need **both** internal state **and** event handling, use a function component.

## Variant Pattern (SSOT for Styles)

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

def button(assigns) do
  assigns =
    assigns
    |> assign(:variant_classes, @variants[assigns.variant])
    |> assign(:size_classes, @sizes[assigns.size])

  ~H"""
  <button class={["rounded font-semibold transition-all duration-150", @variant_classes, @size_classes, @class]} {@rest}>
    {render_slot(@inner_block)}
  </button>
  """
end
```

## Spacing: Parent Owns External Spacing

```elixir
def card(assigns) do
  ~H"""
  <div class={["rounded-xl border border-border bg-surface-raised p-4", @class]} {@rest}>
    {render_slot(@inner_block)}
  </div>
  """
end
```

Parent controls layout:

```heex
<div class="space-y-6">
  <.card>First</.card>
  <.card>Second</.card>
</div>
```

Guidelines:
- **Padding** — component's responsibility
- **Margin** — parent's responsibility
- Use `space-y-*`, `gap-*`, flex/grid for parent-managed spacing
- Accept `class` + `@rest` for customization

## Class Merging

```elixir
attr :class, :string, default: nil
attr :rest, :global

def avatar(assigns) do
  ~H"""
  <img class={["rounded-full object-cover", @class]} {@rest} />
  """
end
```

Caller adds size without overriding shape:

```heex
<.avatar src={@user.avatar_url} class="w-10 h-10" />
```

Warning: `:global` with a default `class` means caller `class` **overrides** entirely. Prefer explicit `attr :class` + list merge.

## Component Library Organization

### Strategy: Topical Modules

```elixir
defmodule MyAppWeb.Components.Buttons do
  use Phoenix.Component
  def button(assigns), do: ...
  def icon_button(assigns), do: ...
end

defmodule MyAppWeb.Components.Forms do
  use Phoenix.Component
  def input(assigns), do: ...
  def select(assigns), do: ...
end
```

### Umbrella Import

```elixir
defmodule MyAppWeb.Components do
  defmacro __using__(_) do
    quote do
      import MyAppWeb.Components.Buttons
      import MyAppWeb.Components.Forms
      import MyAppWeb.Components.Navigation
    end
  end
end
```

### Directory Structure

```
lib/my_app_web/
  components/
    core_components.ex          # Generator-compatible base
    layouts.ex
    layouts/
      root.html.heex
  live/
    feature_name/
      index_live.ex
      show_live.ex
      components/               # Feature-specific components
        item_form.ex
```

### Component Hierarchy (Atomic Design)

1. **Primitives**: Button, Input, Badge, Avatar, Icon
2. **Molecules**: FormField (label + input + error), Card (header + body + footer)
3. **Organisms**: Navbar, Sidebar, DataTable, Modal with form
4. **Page-specific**: Components used in only one LiveView — colocate with that LiveView

Promote page-specific components to shared when used in 2+ places.

## Tailwind Variants for LiveView States

```javascript
// tailwind.config.js (v3) or @custom-variant (v4)
@custom-variant phx-click-loading (.phx-click-loading&, .phx-click-loading &);
@custom-variant phx-submit-loading (.phx-submit-loading&, .phx-submit-loading &);
@custom-variant phx-change-loading (.phx-change-loading&, .phx-change-loading &);
```

```heex
<button phx-click="save" class="bg-primary phx-click-loading:animate-pulse phx-click-loading:opacity-75">
  Save
</button>
```

## Critical Anti-Patterns

### Never modify assigns with Map functions

```elixir
assigns = Map.put(assigns, :name, "val")  # BREAKS change tracking
assigns = assign(assigns, :name, "val")    # correct
```

### Never define variables at top of render/1

```elixir
def render(assigns) do
  total = assigns.price * assigns.quantity  # LiveView can't track this
  ~H"<span>{total}</span>"
end
```

Compute in `assign` during `mount`/`handle_*`.

### Never use LiveComponents for simple UI

Function components have zero lifecycle overhead. LiveComponents are for encapsulated state + events only.

### Never duplicate style knowledge

```elixir
@success_colors "bg-success/10 text-success"

def success_badge(assigns), do: ~H"<span class={@success_colors}>...</span>"
def success_alert(assigns), do: ~H"<div class={@success_colors}>...</div>"
```

Use variant maps or module attributes as SSOT.
