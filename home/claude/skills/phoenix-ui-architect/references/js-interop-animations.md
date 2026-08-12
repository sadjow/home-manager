# JavaScript Interop & Animations

## JS Commands (Phoenix.LiveView.JS)

Client-side DOM operations that are **DOM-patch aware** — operations stick across server patches.

### Command Reference

| Command | Purpose |
|---|---|
| `JS.show/1` | Show with optional transition |
| `JS.hide/1` | Hide with optional transition |
| `JS.toggle/1` | Toggle visibility |
| `JS.toggle_class/2` | Toggle CSS classes |
| `JS.add_class/2` | Add CSS classes with transition |
| `JS.remove_class/2` | Remove CSS classes with transition |
| `JS.transition/2` | Apply temporary animation classes |
| `JS.push/2` | Send event to server |
| `JS.dispatch/2` | Dispatch DOM event |
| `JS.set_attribute/2` | Set element attribute |
| `JS.remove_attribute/2` | Remove element attribute |
| `JS.toggle_attribute/2` | Toggle attribute values |
| `JS.focus/1` | Focus an element |
| `JS.focus_first/1` | Focus first focusable child |
| `JS.push_focus/1` | Save focus for later restoration |
| `JS.pop_focus/0` | Restore previously saved focus |
| `JS.exec/2` | Execute JS commands from element attribute |

### Transition Tuples

3-tuple: `{base_classes, start_classes, end_classes}`

```elixir
JS.show(to: "#modal",
  transition: {"ease-out duration-300", "opacity-0 scale-95", "opacity-100 scale-100"},
  time: 300
)

JS.hide(to: "#modal",
  transition: {"ease-in duration-200", "opacity-100 scale-100", "opacity-0 scale-95"},
  time: 200
)
```

### Command Chaining

All JS functions accept `%JS{}` as first argument:

```elixir
JS.push("modal-closed")
|> JS.remove_class("show", to: "#modal")
|> JS.hide(transition: "fade-out-scale", to: "#modal-content")
```

### Chainable Helper Functions

```elixir
defp show_modal(js \\ %JS{}, id) do
  js
  |> JS.show(to: "##{id}-bg", transition: "fade-in")
  |> JS.show(to: "##{id}-container", transition: "fade-in-scale")
  |> JS.focus_first(to: "##{id}-content")
end

defp hide_modal(js \\ %JS{}, id) do
  js
  |> JS.hide(to: "##{id}-bg", transition: "fade-out")
  |> JS.hide(to: "##{id}-container", transition: "fade-out-scale")
  |> JS.pop_focus()
end
```

### Client-Side Tabs (No Server Round-Trip)

```elixir
defp set_active_tab(js \\ %JS{}, tab) do
  js
  |> JS.remove_class("active-tab", to: "a.active-tab")
  |> JS.add_class("active-tab", to: tab)
end

defp show_active_content(js \\ %JS{}, to) do
  js
  |> JS.hide(to: "div.tab-content")
  |> JS.show(to: to)
end
```

```heex
<a phx-click={set_active_tab("#tab1") |> show_active_content("#content1")}>Tab 1</a>
```

## JavaScript Hooks (phx-hook)

### Lifecycle Callbacks

| Callback | When |
|---|---|
| `mounted()` | Element added to DOM, server LiveView mounted |
| `beforeUpdate()` | Element about to be updated (synchronous only) |
| `updated()` | Element updated in DOM by server |
| `destroyed()` | Element removed from page |
| `disconnected()` | Parent LiveView disconnected |
| `reconnected()` | Parent LiveView reconnected |

### Hook Registration

```javascript
let Hooks = {}

Hooks.Clipboard = {
  mounted() {
    this.el.addEventListener("click", () => {
      navigator.clipboard.writeText(this.el.dataset.clipboardText)
    })
  }
}

Hooks.InfiniteScroll = {
  mounted() {
    const observer = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting) {
        this.pushEvent("load_more", {})
      }
    })
    observer.observe(this.el)
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks
})
```

**Required**: `phx-hook` elements MUST have a unique `id` attribute.

### Server-Client Communication

```elixir
# Server pushes event to client
push_event(socket, "chart-update", %{points: get_points()})
```

```javascript
Hooks.Chart = {
  mounted() {
    this.handleEvent("chart-update", ({ points }) => {
      MyChartLib.updatePoints(this.el, points)
    })
  }
}
```

### Colocated Hooks (LiveView 1.1+, Phoenix 1.8+)

```elixir
def input(%{type: "phone-number"} = assigns) do
  ~H"""
  <input type="text" name={@name} id={@id} value={@value} phx-hook=".PhoneNumber" />
  <script :type={Phoenix.LiveView.ColocatedHook} name=".PhoneNumber">
    export default {
      mounted() {
        this.el.addEventListener("input", e => {
          let match = this.el.value.replace(/\D/g, "").match(/^(\d{3})(\d{3})(\d{4})$/)
          if(match) { this.el.value = `${match[1]}-${match[2]}-${match[3]}` }
        })
      }
    }
  </script>
  """
end
```

Colocated hook names start with `.` — at compile time they're prefixed with the module name.

## JS Commands vs Hooks Decision

| Use JS Commands | Use Hooks |
|---|---|
| Simple DOM toggles | Third-party JS libraries |
| Must survive server DOM patches | Complex DOM manipulation |
| No external JS needed | Persistent client-side state |
| Declarative, composable | IntersectionObserver, ResizeObserver |
| Purely visual changes | Bidirectional server-client communication |

Preference order: **Pure CSS** > **JS Commands** > **Hooks** > **Alpine.js**

## Animation Strategies

### Entry Animations with phx-mounted

```heex
<main class="opacity-0 transition-all duration-500"
  phx-mounted={JS.remove_class("opacity-0")}>
  Page content fades in
</main>
```

### Staggered List Animations with Streams

```heex
<div id="items" phx-update="stream">
  <div
    :for={{dom_id, item} <- @streams.items}
    id={dom_id}
    class="opacity-0 translate-x-4 transition-all duration-300"
    phx-mounted={JS.remove_class("opacity-0 translate-x-4")}
  >
    {item.name}
  </div>
</div>
```

Avoid flash on initial render by tracking mount state:

```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, mounted: false)}
end

def handle_info(:mark_mounted, socket) do
  {:noreply, assign(socket, mounted: true)}
end
```

```heex
<div
  :for={{dom_id, item} <- @streams.items}
  id={dom_id}
  class={if @mounted, do: "opacity-0 translate-x-4 transition-all duration-300"}
  phx-mounted={if @mounted, do: JS.remove_class("opacity-0 translate-x-4")}
>
```

### Deletion Animation

```elixir
defp fade_away_left(js \\ %JS{}, selector) do
  JS.transition(
    js,
    {"transition-all ease-in duration-300",
     "motion-safe:-translate-x-96 opacity-0",
     "hidden"},
    to: selector,
    time: 300
  )
end
```

### Page Transitions

```heex
<main class="px-4 py-20 transition-all duration-500 opacity-0"
  phx-mounted={JS.remove_class("opacity-0")}>
  {@inner_content}
</main>
```

```javascript
window.addEventListener("phx:page-loading-start", info => {
  if (info.detail.kind === "redirect") {
    document.querySelector("main").classList.add("phx-page-loading")
  }
})
```

### Server-Triggered JS Execution

```javascript
window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach(el => {
    liveSocket.execJS(el, el.getAttribute(detail.attr))
  })
})
```

```elixir
def loader(assigns) do
  ~H"""
  <div class="hidden" id={@id}
    data-show={JS.show(transition: {"ease-out duration-300", "opacity-0", "opacity-100"})}
    data-hide={JS.hide(transition: {"ease-in duration-300", "opacity-100", "opacity-0"})}>
    <.spinner />
  </div>
  """
end

# Trigger from server
push_event(socket, "js-exec", %{to: "#loader", attr: "data-show"})
```

## Alpine.js Integration (When Needed)

### Prerequisites

```javascript
const liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) { Alpine.cloneNode(from, to) }
    }
  }
})
```

### Key Patterns

1. **`phx-update="ignore"`** for Alpine-controlled sections
2. **`x-init`** for server data, not `x-data`
3. **`JSON.encode!`** for safe data interpolation
4. **Persistent IDs** for comparison, not references
5. **AlpineInit hook** to re-initialize Alpine trees after LiveView patches

### Responsibility Split

- **Alpine**: dropdowns, tooltips, client-only toggles, complex client animations
- **LiveView**: forms, data fetching, server state, real-time updates

## Anti-Patterns

1. **Hooks for simple show/hide** — JS commands are DOM-patch-aware
2. **Missing `id` on `phx-hook` elements** — required for hooks to function
3. **Async in `beforeUpdate`** — must be synchronous
4. **Raw DOM manipulation outside hooks** — server patches will overwrite
5. **Alpine without `onBeforeElUpdated`** — LiveView patches destroy Alpine state
6. **`setTimeout` hacks** — use JS command `:time` option
7. **`phx-update="ignore"` missing on third-party widget containers** — LiveView will clobber them
8. **Animations without `motion-safe:`** — accessibility violation
