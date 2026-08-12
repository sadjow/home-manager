# Phoenix LiveView Page & Layout Structure Research

## 1. Layout System

### Two-Layout Architecture (Phoenix 1.7)

Phoenix 1.7 introduced a unified layout system shared across LiveViews and dead views:

- **Root Layout** (`root.html.heex`): Contains `<html>`, `<head>`, `<body>` tags. Rendered only on initial HTTP request. Persists across live navigation. Has access to `@conn`. Content injected via `{@inner_content}`.
- **App Layout** (`app.html.heex`): The dynamic portion including menus, sidebars, flash messages. Updates during live navigation.

Both layouts live in `lib/my_app_web/components/layouts/` and are embedded in `MyAppWeb.Layouts`.

Router configuration:
```elixir
plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
```

### Phoenix 1.8 Layout Evolution

Phoenix 1.8 simplified layouts significantly. The app layout is no longer a separate template but an **explicit function component call**:

```elixir
# In your LiveView render/1
def render(assigns) do
  ~H"""
  <Layouts.app flash={@flash}>
    <.header>My Page</.header>
    <!-- page content -->
  </Layouts.app>
  """
end
```

This approach treats layouts like any other component, making layout selection visible in the render function.

### Multiple/Custom Layouts

Define additional layouts as function components in the Layouts module:

```elixir
# lib/my_app_web/components/layouts.ex
attr :flash, :map, required: true
slot :inner_block, required: true

def admin(assigns) do
  ~H"""
  <main class="admin-layout">
    <.admin_sidebar />
    <div class="admin-content">
      {render_slot(@inner_block)}
    </div>
  </main>
  <.flash_group flash={@flash} />
  """
end
```

Usage in a LiveView:
```elixir
def render(assigns) do
  ~H"""
  <Layouts.admin flash={@flash}>
    <!-- admin page content -->
  </Layouts.admin>
  """
end
```

### Dynamic Page Titles

Since the root layout is static during live navigation, Phoenix provides special handling:

```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, page_title: "Dashboard")}
end
```

In root layout:
```heex
<title>{@page_title}</title>
```

Use `Phoenix.Component.live_title/1` for prefix/suffix patterns.

### Root Layout for LiveSessions

Root layouts can also be set per live_session:

```elixir
live_session :admin, root_layout: {MyAppWeb.Layouts, :admin_root} do
  live "/admin", AdminLive.Index
end
```

## 2. Live Sessions and on_mount Hooks

### live_session for Grouping Routes

`live_session/3` groups LiveView routes to enable navigation over WebSocket without HTTP requests:

```elixir
live_session :authenticated, on_mount: [{MyAppWeb.UserAuth, :ensure_authenticated}] do
  live "/dashboard", DashboardLive
  live "/settings", SettingsLive
  live "/profile", ProfileLive
end

live_session :admin, on_mount: [{MyAppWeb.UserAuth, :ensure_admin}] do
  live "/admin", AdminLive.Index
  live "/admin/users", AdminLive.Users
end
```

Navigation within a session uses WebSocket (no HTTP). Navigation between sessions triggers a full page reload through the plug pipeline.

### on_mount Hooks for Shared Concerns

Hooks attach to the mount lifecycle, returning `{:cont, socket}` or `{:halt, socket}`:

```elixir
defmodule MyAppWeb.UserAuth do
  import Phoenix.LiveView

  def on_mount(:ensure_authenticated, _params, %{"user_token" => token}, socket) do
    case Accounts.get_user_by_session_token(token) do
      nil -> {:halt, redirect(socket, to: "/login")}
      user -> {:cont, assign(socket, current_user: user)}
    end
  end

  def on_mount(:ensure_admin, _params, session, socket) do
    socket = on_mount(:ensure_authenticated, nil, session, socket)
    if socket.assigns.current_user.role == :admin do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/")}
    end
  end
end
```

Pattern matching allows grouping auth callbacks in a single module serving multiple live_sessions.

### Security Consideration

Plugs only protect initial HTTP requests and cross-session navigation. Within-session navigation skips the plug pipeline entirely, making on_mount hooks essential for complete authorization coverage.

## 3. Page Organization

### Default Phoenix Directory Structure

```
lib/
  my_app/                    # Business logic (contexts, schemas)
    accounts.ex
    accounts/
      user.ex
    catalog.ex
    catalog/
      product.ex
  my_app_web/                # Web layer (presentation)
    components/
      core_components.ex     # Auto-imported UI primitives
      layouts.ex             # Layout function components
      layouts/
        root.html.heex
    controllers/
    live/
    endpoint.ex
    router.ex
    telemetry.ex
```

### Feature-Based Organization (Recommended for Growing Apps)

Group LiveViews by domain feature rather than keeping them flat:

```
lib/my_app_web/live/
  accounts/
    login_live.ex
    register_live.ex
    settings_live.ex
    components/
      user_form.ex
  admin/
    dashboard_live.ex
    users_live.ex
    components/
      stats_card.ex
  catalog/
    index_live.ex
    show_live.ex
    components/
      product_card.ex
      filter_bar.ex
```

Each feature folder contains its LiveViews, feature-specific components, and colocated HEEx templates.

### Colocated Templates (Phoenix 1.7+/LiveView 0.18+)

Templates can live alongside their LiveView modules:

```
lib/my_app_web/live/catalog/
  index_live.ex
  index_live.html.heex
  show_live.ex
  show_live.html.heex
```

Or inline within the `render/1` function for simpler pages.

### Naming Conventions

- LiveView modules: `MyAppWeb.CatalogLive.Index`, `MyAppWeb.CatalogLive.Show`
- LiveComponent modules: `MyAppWeb.CatalogLive.ProductCard` (or with `Component` suffix)
- Generators produce: `_live` suffix pattern (`MyAppWeb.ProductLive.Index`)

## 4. Assigns and State Management

### Keep Assigns Lean

Store only what is needed for rendering:

```elixir
# Avoid: storing entire Ecto structs with preloaded associations
socket = assign(socket, user: Repo.get!(User, id) |> Repo.preload([:posts, :comments]))

# Prefer: store only rendering-relevant fields
socket = assign(socket, user_name: user.name, user_email: user.email)
```

### Prefer handle_params Over mount for URL-Driven State

```elixir
def mount(_params, _session, socket) do
  {:ok, socket}
end

def handle_params(params, _uri, socket) do
  page = String.to_integer(params["page"] || "1")
  sort_by = params["sort_by"] || "name"

  products = Catalog.list_products(page: page, sort_by: sort_by)

  {:noreply,
   socket
   |> assign(page: page, sort_by: sort_by)
   |> stream(:products, products)}
end
```

This pattern ensures state stays in sync with the URL and works correctly on both mount and live navigation.

### Streams for Large Collections

```elixir
def mount(_params, _session, socket) do
  {:ok, stream(socket, :messages, [])}
end

def handle_info({:new_message, message}, socket) do
  {:noreply, stream_insert(socket, :messages, message)}
end
```

Streams free items from server memory after rendering, ideal for chat messages, feeds, logs.

### temporary_assigns for Transient Data

```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, results: []), temporary_assigns: [results: []]}
end
```

Resets the assign after each render, preventing memory accumulation.

### assign_new for Conditional Loading

```elixir
def mount(_params, _session, socket) do
  {:ok, assign_new(socket, :current_user, fn -> fetch_user(socket) end)}
end
```

Only evaluates the function if the key doesn't already exist (useful when on_mount hooks already set the assign).

## 5. Component Organization

### CoreComponents (Auto-Generated)

`core_components.ex` is auto-imported everywhere and provides foundational UI:
- Modals, tables, forms, inputs, flash messages
- Uses `Phoenix.Component` (not the full web module to avoid circular deps)
- Meant to be customized for your project's design system

### Application-Specific Components

Create additional component modules organized by concern:

```elixir
# lib/my_app_web/components/app_components.ex
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

Import in your web module:
```elixir
defp html_helpers do
  quote do
    import MyAppWeb.CoreComponents
    import MyAppWeb.AppComponents
  end
end
```

### Component Type Decision Tree

1. **Function Components** (default choice): Stateless, receive assigns, return HEEx. Use for buttons, cards, badges, layout wrappers.
2. **LiveComponents** (when needed): Stateful with their own lifecycle. Use only when you need both encapsulated event handling AND internal state.

Prefer function components. LiveComponents add complexity and should not be used purely for code organization.

### Parent-Child Communication

LiveComponents communicate with parent via `send/2`:

```elixir
# In LiveComponent
def handle_event("save", params, socket) do
  send(self(), {:item_saved, params})
  {:noreply, socket}
end

# In parent LiveView
def handle_info({:item_saved, params}, socket) do
  {:noreply, update_state(socket, params)}
end
```

## 6. Splitting Large LiveViews

### Extract Function Components First

Move rendering logic into function components without state:

```elixir
# Before: everything in one LiveView
def render(assigns) do
  ~H"""
  <div class="dashboard">
    <!-- 200 lines of sidebar markup -->
    <!-- 300 lines of main content -->
    <!-- 150 lines of footer -->
  </div>
  """
end

# After: extracted into function components
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

### Extract LiveComponents for Stateful Sections

When a section needs its own event handling:

```elixir
def render(assigns) do
  ~H"""
  <.live_component module={SearchForm} id="search" />
  <.live_component module={ProductTable} id="products" products={@products} />
  """
end
```

### Extract Helper Functions for Event Handlers

```elixir
# Instead of one massive handle_event
def handle_event("filter", params, socket) do
  {:noreply, apply_filters(socket, params)}
end

def handle_event("sort", params, socket) do
  {:noreply, apply_sorting(socket, params)}
end

defp apply_filters(socket, %{"category" => cat}) do
  products = Catalog.list_products(category: cat)
  stream(socket, :products, products, reset: true)
end
```

### Use Contexts for Business Logic

Never put business logic in LiveViews:

```elixir
# LiveView: thin presentation layer
def handle_event("checkout", _params, socket) do
  case Orders.create_order(socket.assigns.current_user, socket.assigns.cart) do
    {:ok, order} -> {:noreply, push_navigate(socket, to: ~p"/orders/#{order}")}
    {:error, changeset} -> {:noreply, assign(socket, form: to_form(changeset))}
  end
end
```

## 7. Phoenix 1.8 Scopes Pattern

Phoenix 1.8 introduced scopes as a first-class pattern for secure data access:

```elixir
# Scope struct holds request context
%MyApp.Scope{user: current_user}

# Context functions receive scope
def list_posts(scope) do
  Post |> where(user_id: ^scope.user.id) |> Repo.all()
end
```

This ensures broken access control (OWASP #1 vulnerability) is prevented by default rather than relying on developer memory.

## 8. Anti-Patterns to Avoid

### Passing Socket to Business Logic

```elixir
# Bad: couples business logic to LiveView
defp calculate(socket) do
  MyApp.calculate(socket.assigns.items, socket.assigns.user)
end

# Good: extract data, pass only what's needed
defp calculate(socket) do
  result = MyApp.calculate(socket.assigns.items, socket.assigns.user)
  assign(socket, result: result)
end
```

### Function Head Pattern Matching Abuse

```elixir
# Bad: destructuring everything in function heads
def handle_event("save", %{"name" => name, "email" => email, "role" => role}, %{assigns: %{user: user, org: org}} = socket) do

# Good: match only what determines the code path
def handle_event("save", params, socket) do
  %{user: user, org: org} = socket.assigns
  # ...
end
```

### Using LiveComponents for Code Organization Only

LiveComponents add lifecycle overhead. If you don't need encapsulated state + events, use function components instead.

### N+1 Queries in LiveComponents

When rendering the same LiveComponent in a loop, use `update_many/1` to batch database queries.

### Storing Too Much in Assigns

Use streams for large collections, temporary_assigns for transient data, and only keep what's needed for the current render.

### Blocking the LiveView Process

Push heavy operations (API calls, file processing) to `Task.async` to keep the socket responsive.

## 9. Recommended File Structure (Full Example)

```
lib/
  my_app/
    accounts.ex                    # Context: public API
    accounts/
      user.ex                      # Schema
      user_token.ex                # Schema
      scope.ex                     # Scope struct (Phoenix 1.8)
    catalog.ex                     # Context
    catalog/
      product.ex
    orders.ex                      # Context
    orders/
      order.ex

  my_app_web/
    components/
      core_components.ex           # Foundational UI (auto-imported)
      layouts.ex                   # Layout function components
      layouts/
        root.html.heex             # Static root layout
    live/
      accounts/
        login_live.ex
        register_live.ex
        settings_live.ex
      catalog/
        index_live.ex
        index_live.html.heex
        show_live.ex
        show_live.html.heex
        components/
          product_card.ex
          filter_form.ex
      admin/
        dashboard_live.ex
        users_live.ex
      components/                  # Shared LiveComponents
        search_form.ex
    controllers/
    endpoint.ex
    router.ex
    telemetry.ex

test/
  my_app/                          # Unit tests for contexts
    accounts_test.exs
    catalog_test.exs
  my_app_web/
    live/                          # Integration tests for LiveViews
      catalog/
        index_live_test.exs
        show_live_test.exs
```

## 10. Key Principles Summary

1. **Root layout is static, app layout is dynamic** -- root renders once per HTTP request, app layout updates during live navigation.
2. **Phoenix 1.8 makes layouts explicit function components** -- call `<Layouts.app>` or `<Layouts.admin>` directly in render.
3. **Use live_session + on_mount for shared concerns** -- authentication, authorization, common assigns.
4. **Organize by feature, not by type** -- group related LiveViews, components, and templates together.
5. **LiveView is a thin presentation layer** -- push business logic into context modules.
6. **Prefer function components over LiveComponents** -- only use LiveComponents when you need encapsulated state + events.
7. **Use handle_params for URL-driven state** -- keeps state in sync with the URL across navigation.
8. **Keep assigns lean** -- use streams, temporary_assigns, and minimal data structures.
9. **Scopes (Phoenix 1.8) for secure data access** -- thread user context through context functions by default.
10. **Split large LiveViews progressively** -- extract function components first, then LiveComponents only when state encapsulation is needed.

## Sources

- [Live Layouts - Phoenix LiveView v1.1.22 Docs](https://hexdocs.pm/phoenix_live_view/live-layouts.html)
- [Directory Structure - Phoenix v1.8.3 Docs](https://hexdocs.pm/phoenix/directory_structure.html)
- [Components and HEEx - Phoenix v1.8.3 Docs](https://hexdocs.pm/phoenix/components.html)
- [Phoenix.LiveComponent - LiveView v1.1.22 Docs](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html)
- [Phoenix.LiveView - LiveView v1.1.22 Docs](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Multiple Layouts in Phoenix 1.8 - ElixirCasts](https://elixircasts.io/multiple-layouts-in-phoenix-1.8)
- [Phoenix 1.8.0 Released - Phoenix Blog](https://www.phoenixframework.org/blog/phoenix-1-8-released)
- [Live Sessions in Action - The Phoenix Files (Fly.io)](https://fly.io/phoenix-files/live-session/)
- [LiveView Design Patterns - Elixir School](https://elixirschool.com/blog/live-view-live-component)
- [Phoenix LiveView Anti Patterns - John Elm Labs](https://johnelmlabs.com/posts/anti-patterns-in-liveview)
- [Phoenix LiveView Best Practices - Hanso Group](https://www.hanso.group/weblog/phoenix-liveview-best-practices)
- [Structuring Phoenix LiveView Applications - Hex Shift](https://hexshift.medium.com/structuring-phoenix-liveview-applications-for-long-term-maintainability-and-team-collaboration-e1689c0933cb)
- [Things I Learned Using Phoenix LiveView in 2024 - DEV Community](https://dev.to/paugramming/things-i-learned-using-phoenix-liveview-in-2024-22mm)
- [Organizing Phoenix Code Through Context Structuring - Elixir Merge](https://elixirmerge.com/p/organizing-phoenix-application-code-through-context-structuring)
- [Security Considerations - Phoenix LiveView v1.1.22](https://hexdocs.pm/phoenix_live_view/security-model.html)
- [Phoenix.LiveView.Router - LiveView v1.1.17](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Router.html)
- [LiveView Naming and Dir Structure - Elixir Forum](https://elixirforum.com/t/liveview-naming-and-dir-structure/28955)
- [Phoenix Components: Reusable Building Blocks - Curiosum](https://www.curiosum.com/blog/phoenix-component)
