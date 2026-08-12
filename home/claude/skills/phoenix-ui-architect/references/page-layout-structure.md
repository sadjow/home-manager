# Page & Layout Structure

## Layout System

### Root Layout vs App Layout

- **Root layout** (`root.html.heex`): `<html>`, `<head>`, `<body>`. Rendered once per HTTP request. Persists across live navigation. Has `@conn`.
- **App layout**: Dynamic portion (menus, sidebars, flash). Updates during live navigation.

Both live in `lib/my_app_web/components/layouts/`.

### Phoenix 1.8: Layouts as Function Components

Layouts are explicit function component calls in `render/1`:

```elixir
def render(assigns) do
  ~H"""
  <Layouts.app flash={@flash}>
    <.header>My Page</.header>
  </Layouts.app>
  """
end
```

### Multiple Layouts

```elixir
defmodule MyAppWeb.Layouts do
  attr :flash, :map, required: true
  slot :inner_block, required: true

  def admin(assigns) do
    ~H"""
    <main class="admin-layout">
      <.admin_sidebar />
      <div class="admin-content">{render_slot(@inner_block)}</div>
    </main>
    <.flash_group flash={@flash} />
    """
  end
end
```

Usage:

```elixir
def render(assigns) do
  ~H"""
  <Layouts.admin flash={@flash}>
    ...
  </Layouts.admin>
  """
end
```

### Root Layout per live_session

```elixir
live_session :admin, root_layout: {MyAppWeb.Layouts, :admin_root} do
  live "/admin", AdminLive.Index
end
```

## Live Sessions and on_mount

### Grouping Routes

```elixir
live_session :authenticated, on_mount: [{MyAppWeb.UserAuth, :ensure_authenticated}] do
  live "/dashboard", DashboardLive
  live "/settings", SettingsLive
end

live_session :admin, on_mount: [{MyAppWeb.UserAuth, :ensure_admin}] do
  live "/admin", AdminLive.Index
end
```

Navigation within a session uses WebSocket. Navigation between sessions triggers full page reload.

### on_mount Hooks

```elixir
defmodule MyAppWeb.UserAuth do
  import Phoenix.LiveView

  def on_mount(:ensure_authenticated, _params, %{"user_token" => token}, socket) do
    case Accounts.get_user_by_session_token(token) do
      nil -> {:halt, redirect(socket, to: "/login")}
      user -> {:cont, assign(socket, current_user: user)}
    end
  end
end
```

Plugs only protect HTTP requests. on_mount hooks cover WebSocket navigation.

## Feature-Based Directory Structure

```
lib/my_app_web/
  components/
    core_components.ex           # Auto-imported UI primitives
    layouts.ex                   # Layout function components
    layouts/
      root.html.heex
  live/
    accounts/
      login_live.ex
      register_live.ex
      settings_live.ex
      components/
        user_form.ex
    catalog/
      index_live.ex
      index_live.html.heex
      show_live.ex
      show_live.html.heex
      components/
        product_card.ex
        filter_bar.ex
    admin/
      dashboard_live.ex
      users_live.ex
      components/
        stats_card.ex
  controllers/
  endpoint.ex
  router.ex
```

### Naming Conventions

- **LiveView modules**: `MyAppWeb.CatalogLive.Index`, `MyAppWeb.CatalogLive.Show`
- **LiveComponent modules**: `MyAppWeb.CatalogLive.ProductCard` (or `Component` suffix)
- **Function component modules**: `MyAppWeb.Components.Buttons`, `MyAppWeb.Components.Forms`

### Colocated Templates

Templates alongside their LiveView:

```
lib/my_app_web/live/catalog/
  index_live.ex
  index_live.html.heex
```

Or inline in `render/1` for simpler pages.

## Assigns Management

### Keep Assigns Lean

```elixir
# Store only rendering-relevant fields
socket = assign(socket, user_name: user.name, user_email: user.email)
```

### handle_params for URL-Driven State

```elixir
def handle_params(params, _uri, socket) do
  page = String.to_integer(params["page"] || "1")
  products = Catalog.list_products(page: page)

  {:noreply,
   socket
   |> assign(page: page)
   |> stream(:products, products)}
end
```

Ensures state stays in sync with URL across mount and live navigation.

### Streams for Large Collections

```elixir
def mount(_params, _session, socket) do
  {:ok, stream(socket, :messages, [])}
end

def handle_info({:new_message, message}, socket) do
  {:noreply, stream_insert(socket, :messages, message)}
end
```

Streams free items from server memory after rendering.

### temporary_assigns for Transient Data

```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, results: []), temporary_assigns: [results: []]}
end
```

### assign_new for Conditional Loading

```elixir
def mount(_params, _session, socket) do
  {:ok, assign_new(socket, :current_user, fn -> fetch_user(socket) end)}
end
```

Only evaluates if the key doesn't already exist.

## Splitting Large LiveViews

### Step 1: Extract Function Components

```elixir
def render(assigns) do
  ~H"""
  <div class="dashboard">
    <.sidebar current_user={@current_user} nav_items={@nav_items} />
    <.main_content products={@products} />
    <.dashboard_footer stats={@stats} />
  </div>
  """
end
```

### Step 2: Extract LiveComponents (When Needed)

Only when a section needs encapsulated state + events:

```elixir
def render(assigns) do
  ~H"""
  <.live_component module={SearchForm} id="search" />
  <.live_component module={ProductTable} id="products" products={@products} />
  """
end
```

### Step 3: Extract Helper Functions

```elixir
def handle_event("filter", params, socket) do
  {:noreply, apply_filters(socket, params)}
end

defp apply_filters(socket, %{"category" => cat}) do
  products = Catalog.list_products(category: cat)
  stream(socket, :products, products, reset: true)
end
```

### LiveView is a Thin Presentation Layer

```elixir
def handle_event("checkout", _params, socket) do
  case Orders.create_order(socket.assigns.current_user, socket.assigns.cart) do
    {:ok, order} -> {:noreply, push_navigate(socket, to: ~p"/orders/#{order}")}
    {:error, changeset} -> {:noreply, assign(socket, form: to_form(changeset))}
  end
end
```

Business logic lives in context modules, not LiveViews.

## Phoenix 1.8 Scopes

Scopes thread user context through context functions:

```elixir
%MyApp.Scope{user: current_user}

def list_posts(scope) do
  Post |> where(user_id: ^scope.user.id) |> Repo.all()
end
```

Prevents broken access control by default.

## Component Organization

### CoreComponents (Auto-Generated)

- Auto-imported everywhere via `use MyAppWeb, :html`
- Provides: modals, tables, forms, inputs, flash messages
- Customize for your design system
- Keep generator-compatible base here

### Application Components

```elixir
defmodule MyAppWeb.AppComponents do
  use Phoenix.Component

  attr :user, :map, required: true
  def avatar(assigns) do
    ~H"""
    <img src={@user.avatar_url} class="rounded-full w-8 h-8" />
    """
  end
end
```

Import in web module:

```elixir
defp html_helpers do
  quote do
    import MyAppWeb.CoreComponents
    import MyAppWeb.AppComponents
  end
end
```

### Parent-Child Communication (LiveComponents)

```elixir
# LiveComponent sends to parent
def handle_event("save", params, socket) do
  send(self(), {:item_saved, params})
  {:noreply, socket}
end

# Parent handles it
def handle_info({:item_saved, params}, socket) do
  {:noreply, update_state(socket, params)}
end
```

## Anti-Patterns

1. **Business logic in LiveViews** — push into context modules
2. **LiveComponents for code organization only** — adds lifecycle overhead; use function components
3. **Passing socket to business logic** — extract data, pass only what's needed
4. **Storing too much in assigns** — use streams, temporary_assigns
5. **Blocking the LiveView process** — push heavy ops to `Task.async`
6. **N+1 in LiveComponent loops** — use `update_many/1` to batch queries
7. **Not updating `@page_title`** — screen readers and browser tabs need it
8. **Excessive pattern matching in function heads** — match only what determines the code path

## Key Principles

1. Root layout is static, app layout is dynamic
2. Phoenix 1.8: layouts are explicit function component calls
3. `live_session` + `on_mount` for shared concerns
4. Organize by feature, not by type
5. LiveView is a thin presentation layer
6. Prefer function components over LiveComponents
7. `handle_params` for URL-driven state
8. Keep assigns lean (streams, temporary_assigns)
9. Scopes (Phoenix 1.8) for secure data access
10. Split large LiveViews progressively (function components first)
