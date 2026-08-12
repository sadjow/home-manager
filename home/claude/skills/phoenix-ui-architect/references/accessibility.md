# Accessibility (WCAG 2.2) for Phoenix LiveView

## WCAG 2.2 Key Criteria for LiveView

- **2.4.11 Focus Not Obscured (AA)**: Focused element must not be entirely hidden (sticky headers, modals)
- **2.4.13 Focus Appearance (AAA)**: Focus indicators 2px thick perimeter, 3:1 contrast ratio
- **2.5.7 Dragging Movements (AA)**: All drag operations need single-pointer alternative
- **2.5.8 Target Size (AA)**: Interactive targets at least 24x24 CSS pixels

## ARIA for Dynamic Content

### First Rule: Use Native HTML

```heex
<nav aria-label="Main navigation">...</nav>
<main>...</main>
<button>Save</button>
```

Only add ARIA when native semantics are insufficient.

### ARIA Live Regions

LiveView server-rendered updates don't automatically announce to screen readers:

```heex
<div aria-live="polite" aria-atomic="true">
  <span :if={@search_results_count}>{@search_results_count} results found</span>
</div>

<div aria-live="assertive" role="alert">
  <span :if={@error_message}>{@error_message}</span>
</div>
```

Rules:
- Container with `aria-live` must exist in DOM **before** content is injected
- `polite` — waits for screen reader to finish (most updates)
- `assertive` — interrupts immediately (critical alerts only)
- `aria-atomic="true"` — re-read entire region on any change

### Screen Reader-Only Content

```heex
<th><span class="sr-only">Actions</span></th>

<button aria-label={gettext("Delete item")}>
  <.icon name="hero-trash" />
</button>
```

## Focus Management

### LiveView Focus Primitives

```elixir
# Focus specific element
JS.focus(to: "#search-input")

# Focus first focusable child
JS.focus_first(to: "#modal-content")

# Save/restore focus (for modals)
JS.push_focus()   # save current focus
JS.pop_focus()    # restore saved focus
```

### Modal Focus Pattern

```heex
<button phx-click={show_modal("dialog") |> JS.push_focus()}>
  Open
</button>

<button phx-click={hide_modal("dialog") |> JS.pop_focus()}>
  Close
</button>
```

### Focus During Live Navigation

- Update `@page_title` on every `push_navigate` / `push_patch`
- Screen readers announce page title changes
- Use `handle_params/3` to set title

```elixir
def handle_params(_params, _uri, socket) do
  {:noreply, assign(socket, page_title: "Settings - Profile")}
end
```

## Keyboard Navigation

### Focus Wrapping (Modals/Dialogs)

```heex
<.focus_wrap id="modal-content">
  <div role="dialog" aria-modal="true" aria-labelledby="modal-title">
    <h2 id="modal-title">Confirm Action</h2>
    <p>Are you sure?</p>
    <button phx-click={hide_modal("my-modal") |> JS.pop_focus()}>Cancel</button>
    <button phx-click="confirm">Confirm</button>
  </div>
</.focus_wrap>
```

### Escape Key Handling

```heex
<div id="dropdown-menu"
  phx-keydown={close_dropdown("dropdown")}
  phx-key="escape"
  role="menu">
  <a role="menuitem" href="/profile">Profile</a>
</div>
```

### ARIA Attribute Management

```elixir
def toggle_dropdown(js \\ %JS{}, id) do
  js
  |> JS.toggle(to: "##{id}-menu")
  |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{id}-trigger")
end
```

### Skip Links

```heex
<body>
  <a href="#main-content"
    class="sr-only focus:not-sr-only focus:absolute focus:z-50 focus:p-4 focus:bg-white focus:text-black">
    Skip to main content
  </a>
  <header role="banner">
    <nav aria-label="Main navigation">...</nav>
  </header>
  <main id="main-content" role="main" tabindex="-1">
    {@inner_content}
  </main>
</body>
```

### Tab Order Rules

- Avoid positive `tabindex` values
- `tabindex="0"` — add to natural tab order
- `tabindex="-1"` — focusable programmatically only (not via tab)
- Ensure dynamically added elements appear in logical DOM order

## Accessible Component Patterns

### Forms with Ecto Changesets

```heex
<div>
  <label for="user-email">Email</label>
  <input
    type="email"
    id="user-email"
    name="user[email]"
    aria-describedby={if @form[:email].errors != [], do: "user-email-error"}
    aria-invalid={@form[:email].errors != []}
    value={@form[:email].value}
  />
  <p :if={used_input?(@form[:email])} id="user-email-error" role="alert">
    {for {msg, _opts} <- @form[:email].errors, do: msg}
  </p>
</div>
```

Use `Phoenix.Component.used_input?/1` to show errors only for interacted fields.

### Error Summary

```heex
<div :if={@form.errors != []} role="alert" aria-labelledby="error-summary-title">
  <h3 id="error-summary-title">Please fix the following errors:</h3>
  <ul>
    <li :for={{field, {msg, _opts}} <- @form.errors}>
      <a href={"#user-#{field}"}>{Phoenix.Naming.humanize(field)}: {msg}</a>
    </li>
  </ul>
</div>
```

### Number Input

Avoid `type="number"` (known accessibility issues):

```heex
<input type="text" inputmode="numeric" pattern="[0-9]*" />
```

### Accessible Tabs

```heex
<div role="tablist" aria-label="Account settings">
  <button
    :for={tab <- @tabs}
    role="tab"
    id={"tab-#{tab.id}"}
    aria-selected={to_string(@active_tab == tab.id)}
    aria-controls={"panel-#{tab.id}"}
    tabindex={if @active_tab == tab.id, do: "0", else: "-1"}
    phx-click="select_tab"
    phx-value-tab={tab.id}
    phx-keydown="tab_keydown"
  >
    {tab.label}
  </button>
</div>

<div
  :for={tab <- @tabs}
  role="tabpanel"
  id={"panel-#{tab.id}"}
  aria-labelledby={"tab-#{tab.id}"}
  hidden={@active_tab != tab.id}
  tabindex="0"
>
  {render_slot(tab.content)}
</div>
```

Arrow key navigation:

```elixir
def handle_event("tab_keydown", %{"key" => "ArrowRight"}, socket) do
  {:noreply, assign(socket, active_tab: next_tab(socket.assigns))}
end

def handle_event("tab_keydown", %{"key" => "ArrowLeft"}, socket) do
  {:noreply, assign(socket, active_tab: prev_tab(socket.assigns))}
end
```

### Accessible Modal (Full Pattern)

```heex
<div id={@id} phx-mounted={@show && show_modal(@id)} class="relative z-50 hidden">
  <div id={"#{@id}-bg"} class="fixed inset-0 bg-black/50" aria-hidden="true" />

  <div class="fixed inset-0 overflow-y-auto"
    role="dialog" aria-modal="true"
    aria-labelledby={"#{@id}-title"} aria-describedby={"#{@id}-description"}>
    <.focus_wrap id={"#{@id}-wrap"}
      phx-window-keydown={hide_modal(@id) |> JS.pop_focus()}
      phx-key="escape">
      <div>
        <button phx-click={hide_modal(@id) |> JS.pop_focus()}
          aria-label={gettext("Close dialog")}>
          <.icon name="hero-x-mark" />
        </button>
        <h2 id={"#{@id}-title"}>{@title}</h2>
        <div id={"#{@id}-description"}>
          {render_slot(@inner_block)}
        </div>
      </div>
    </.focus_wrap>
  </div>
</div>
```

### Accessible Data Tables

```heex
<table>
  <caption class="sr-only">{@caption}</caption>
  <thead>
    <tr>
      <th :for={col <- @columns} scope="col"
        aria-sort={sort_direction(@sort_field, @sort_dir, col.field)}>
        <button :if={col.sortable} phx-click="sort" phx-value-field={col.field}>
          {col.label}
        </button>
      </th>
      <th><span class="sr-only">Actions</span></th>
    </tr>
  </thead>
</table>
```

### Accessible Dropdown

```heex
<div class="relative" id={"dropdown-#{@id}"}>
  <button id={"dropdown-#{@id}-trigger"}
    aria-haspopup="true" aria-expanded="false"
    phx-click={toggle_dropdown("dropdown-#{@id}")}>
    {@label}
  </button>

  <.focus_wrap id={"dropdown-#{@id}-wrap"}>
    <ul id={"dropdown-#{@id}-menu"} role="menu"
      aria-labelledby={"dropdown-#{@id}-trigger"} class="hidden"
      phx-keydown={close_dropdown("dropdown-#{@id}")} phx-key="escape">
      <li :for={item <- @items} role="menuitem">
        <.link navigate={item.href}>{item.label}</.link>
      </li>
    </ul>
  </.focus_wrap>
</div>
```

## Color Contrast

| Element | WCAG AA Minimum |
|---|---|
| Normal text | 4.5:1 |
| Large text (18pt+ / 14pt+ bold) | 3:1 |
| UI components & icons | 3:1 |
| Focus indicators | 3:1 between focused/unfocused |

### Focus Indicator Styling

```css
:focus-visible {
  outline: 2px solid currentColor;
  outline-offset: 2px;
}
```

## Reduced Motion

```heex
<div class="motion-safe:animate-fade-in motion-reduce:opacity-100">
  {render_slot(@inner_block)}
</div>
```

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Common LiveView A11y Mistakes

1. **Missing `aria-live`** on dynamic content — screen readers can't detect LiveView patches
2. **Lost focus after server events** — use `JS.focus` to restore
3. **Custom controls without roles** — `<div phx-click>` needs `role`, `aria-expanded`, keyboard handlers
4. **`role="menu"` for navigation** — use `<nav>` with `<ul>/<li>` instead
5. **No `@page_title` update** on live navigation — screen readers rely on it
6. **Form errors without `aria-describedby`** — visual proximity isn't enough
7. **Animations without `motion-safe:`** — accessibility violation
8. **Icon-only buttons without labels** — need `aria-label` or `sr-only` text
9. **Sortable tables without `aria-sort`** — screen readers can't determine sort state
10. **Modals without `<.focus_wrap>`** — tab escapes to background content
11. **Target size under 24x24px** — WCAG 2.2 requirement
