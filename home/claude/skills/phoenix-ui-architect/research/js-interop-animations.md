# Phoenix LiveView JavaScript Interop & Animations

## 1. LiveView JS Commands (Phoenix.LiveView.JS)

The `Phoenix.LiveView.JS` module provides client-side DOM operations that are **DOM-patch aware** -- operations stick to elements across server patches, unlike raw JS manipulations.

### Available Commands

| Command | Purpose |
|---------|---------|
| `JS.show/1` | Show hidden elements with optional transition |
| `JS.hide/1` | Hide visible elements with optional transition |
| `JS.toggle/1` | Toggle visibility based on current state |
| `JS.toggle_class/2` | Toggle CSS classes (added in v0.20.4) |
| `JS.add_class/2` | Add CSS classes with optional transition |
| `JS.remove_class/2` | Remove CSS classes with optional transition |
| `JS.transition/2` | Apply temporary animation classes |
| `JS.push/2` | Send event to server |
| `JS.dispatch/2` | Dispatch DOM event |
| `JS.set_attribute/2` | Set element attribute |
| `JS.remove_attribute/2` | Remove element attribute |
| `JS.toggle_attribute/2` | Toggle attribute between values |
| `JS.focus/1` | Focus an element |
| `JS.focus_first/1` | Focus first focusable child |
| `JS.push_focus/1` | Save focus for later restoration |
| `JS.pop_focus/0` | Restore previously saved focus |
| `JS.navigate/2` | Navigate with full page load |
| `JS.patch/2` | Update URL without full reload |
| `JS.exec/2` | Execute JS commands from element attribute |
| `JS.ignore_attributes/2` | Skip patching specified attributes |

### Transition Options

Transitions accept a string or a 3-tuple of `{base_classes, start_classes, end_classes}`:

```elixir
# Simple string transition
JS.show(to: "#modal", transition: "fade-in-scale")

# 3-tuple transition with Tailwind
JS.show(to: "#modal",
  transition: {"ease-out duration-300", "opacity-0", "opacity-100"},
  time: 300
)

JS.hide(to: "#modal",
  transition: {"ease-in duration-200", "opacity-100", "opacity-0"},
  time: 200
)
```

Common options for display commands:
- `:to` - DOM selector (string, `{:inner, selector}`, or `{:closest, selector}`)
- `:transition` - String or 3-tuple of CSS classes
- `:time` - Duration in ms (default: 200)
- `:blocking` - Block UI during transition (default: true)
- `:display` - CSS display value when showing (default: "block")

### Command Chaining

All JS functions accept an optional `%JS{}` struct as first argument, enabling composition:

```elixir
JS.push("modal-closed")
|> JS.remove_class("show", to: "#modal", transition: "fade-out")
|> JS.hide(transition: "fade-out-scale", to: "#modal-content")
```

Commands execute in order on the client. The client does NOT wait for server confirmation before executing the next command. However, multiple server-bound commands (`JS.push`) are guaranteed to execute in order since a LiveView handles one event at a time.

### Making Custom Functions Chainable

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
<a phx-click={set_active_tab("#tab2") |> show_active_content("#content2")}>Tab 2</a>
```

### toggle_class for Expandable Lists

```elixir
defp expand_item(item_id) do
  JS.toggle_class("hidden", to: "#item-#{item_id} > .expanded-content")
  |> JS.toggle_class("rotate-180", to: "#item-#{item_id} .chevron", time: 300)
end
```

```heex
<li :for={item <- @items} id={"item-#{item.id}"} phx-click={expand_item(item.id)}>
  <div class="title-content">{item.title}</div>
  <div class="expanded-content hidden">{item.details}</div>
</li>
```

### JS.push with Options

```elixir
# Send event with payload
JS.push("switch_profile", value: %{user_id: @profile.user_id}, target: "#player")

# With loading indicator
JS.push("save", loading: "#save-spinner", page_loading: true)
```

---

## 2. JavaScript Hooks (phx-hook)

Hooks provide full JavaScript lifecycle management for elements. Use them when JS commands are insufficient.

### Lifecycle Callbacks

| Callback | When |
|----------|------|
| `mounted()` | Element added to DOM and server LiveView has finished mounting |
| `beforeUpdate()` | Element about to be updated in DOM (must be synchronous) |
| `updated()` | Element has been updated in DOM by server |
| `destroyed()` | Element removed from page |
| `disconnected()` | Parent LiveView disconnected from server |
| `reconnected()` | Parent LiveView reconnected to server |

### Available Properties and Methods

| Property/Method | Purpose |
|----------------|---------|
| `this.el` | The bound DOM element |
| `this.pushEvent(event, payload, callback)` | Push event to server (returns promise if no callback) |
| `this.pushEventTo(target, event, payload, callback)` | Push event to specific component |
| `this.handleEvent(event, callback)` | Listen for server-pushed events |
| `this.removeHandleEvent(ref)` | Remove event handler |
| `this.upload(name, files)` | Inject files into uploader |
| `this.uploadTo(target, name, files)` | Inject files into targeted uploader |
| `this.liveSocket` | Reference to underlying LiveSocket |
| `this.js()` | Returns object for DOM manipulation that integrates with server patching |

### Hook Registration

```javascript
// assets/js/app.js
let Hooks = {}

Hooks.PhoneNumber = {
  mounted() {
    this.el.addEventListener("input", e => {
      let match = this.el.value.replace(/\D/g, "").match(/^(\d{3})(\d{3})(\d{4})$/)
      if (match) {
        this.el.value = `${match[1]}-${match[2]}-${match[3]}`
      }
    })
  }
}

Hooks.ScrollIntoView = {
  mounted() {
    setTimeout(() => this.el.scrollIntoView({ behavior: "smooth" }), 500)
  }
}

Hooks.Clipboard = {
  mounted() {
    this.el.addEventListener("click", () => {
      const text = this.el.dataset.clipboardText
      navigator.clipboard.writeText(text)
    })
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})
```

```heex
<input type="text" id="phone" phx-hook="PhoneNumber" />
```

**Required**: Elements with `phx-hook` MUST have a unique `id` attribute.

### Server-Client Communication via Hooks

**Client to server:**
```javascript
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
```

**Server to client:**
```elixir
# In LiveView
def handle_event("chart_data_requested", _, socket) do
  {:noreply, push_event(socket, "chart-update", %{points: get_points()})}
end
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

Write hooks alongside HEEx components instead of separate JS files:

```elixir
def input(%{type: "phone-number"} = assigns) do
  ~H"""
  <input type="text" name={@name} id={@id} value={@value} phx-hook=".PhoneNumber" />
  <script :type={Phoenix.LiveView.ColocatedHook} name=".PhoneNumber">
    export default {
      mounted() {
        this.el.addEventListener("input", e => {
          let match = this.el.value.replace(/\D/g, "").match(/^(\d{3})(\d{3})(\d{4})$/)
          if(match) {
            this.el.value = `${match[1]}-${match[2]}-${match[3]}`
          }
        })
      }
    }
  </script>
  """
end
```

Key rules:
- Hook names must start with a dot (e.g., `.PhoneNumber`)
- At compile time, names are prefixed with module name to prevent conflicts
- Import in app.js: `import {hooks} from "phoenix-colocated/my_app"`
- Pass to LiveSocket: `hooks: {...colocatedHooks, ...myHooks}`

---

## 3. JS Commands vs Hooks: Decision Guide

### Use JS Commands When:
- Simple DOM toggles (show/hide, add/remove class)
- Operations that must survive server DOM patches
- No external JS library integration needed
- Declarative, composable UI behavior
- Avoiding server round-trips for purely visual changes

### Use Hooks When:
- Integrating third-party JS libraries (charts, maps, editors)
- Complex DOM manipulation requiring element references
- Persistent client-side state (localStorage, cookies)
- Real-time event handling (IntersectionObserver, ResizeObserver)
- Bidirectional server-client communication
- Custom input formatting or validation

### Preference Order
1. **Pure CSS** (hover states, focus-within, etc.)
2. **JS Commands** (declarative, DOM-patch-aware)
3. **Hooks** (when JS commands are insufficient)
4. **Alpine.js** (only if hooks become too complex for client-only logic)

---

## 4. Server-Triggered JS Execution

A reusable pattern for triggering JS commands from the server:

### Generic Event Listener

```javascript
// app.js
window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach(el => {
    liveSocket.execJS(el, el.getAttribute(detail.attr))
  })
})
```

### Component with Embedded JS Commands

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
```

### Server-Side Triggering

```elixir
def handle_event("create_item", _params, socket) do
  send(self(), :process_creation)
  socket = push_event(socket, "js-exec", %{to: "#loader", attr: "data-show"})
  {:noreply, socket}
end

def handle_info(:process_creation, socket) do
  result = perform_creation()
  socket =
    socket
    |> assign(:items, result)
    |> push_event("js-exec", %{to: "#loader", attr: "data-hide"})
  {:noreply, socket}
end
```

---

## 5. Animation Strategies

### CSS Transitions with JS Commands

```elixir
# Fade-in modal
JS.show(to: "#modal",
  transition: {"transition-all ease-out duration-300", "opacity-0 scale-95", "opacity-100 scale-100"}
)

# Fade-out modal
JS.hide(to: "#modal",
  transition: {"transition-all ease-in duration-200", "opacity-100 scale-100", "opacity-0 scale-95"}
)
```

### phx-mounted for Entry Animations

```heex
<div phx-mounted={JS.transition("animate-ping", time: 500)}>
  Content that pings on mount
</div>

<main class="opacity-0 transition-all duration-500"
  phx-mounted={JS.remove_class("opacity-0")}>
  Page content that fades in
</main>
```

`phx-mounted` fires at the earliest opportunity:
- For elements outside LiveView: when `liveSocket.connect()` executes
- For elements inside LiveView: after initial socket connection and LiveView mount

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

To avoid flash on initial render (only animate new items added after mount):

```elixir
# Track whether initial mount has completed
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

### Row Entry and Exit Animations

**Slide-in from right:**
```elixir
<tr
  :for={{dom_id, row} <- @streams.rows}
  id={dom_id}
  class={[
    "group hover:bg-zinc-50",
    if(@new_row == row.id,
      do: "transition-all transform duration-500 motion-safe:translate-x-96"
    )
  ]}
  phx-mounted={
    if(@new_row == row.id,
      do: JS.remove_class("motion-safe:translate-x-96"))
  }
>
```

**Slide-out deletion:**
```elixir
defp fade_away_left(js \\ %JS{}, selector) do
  JS.transition(
    js,
    {"transition-all transform ease-in duration-300",
     "motion-safe:-translate-x-96 opacity-0",
     "hidden"},
    to: selector,
    time: 300
  )
end
```

### Page Transition Pattern

```heex
<main class="px-4 py-20 transition-all duration-500 opacity-0 phx-page-loading:opacity-0"
  phx-mounted={JS.remove_class("opacity-0")}>
  {@inner_content}
</main>
```

```javascript
// app.js - Loading state management
window.addEventListener("phx:page-loading-start", info => {
  if (info.detail.kind === "redirect") {
    document.querySelector("main").classList.add("phx-page-loading")
  }
})

window.addEventListener("phx:page-loading-stop", _info => {
  document.querySelector("main").classList.remove("phx-page-loading")
})
```

```javascript
// tailwind.config.js - Custom Tailwind variant
plugins: [
  plugin(({ addVariant }) =>
    addVariant("phx-page-loading",
      [".phx-page-loading&", ".phx-page-loading &"]
    )
  )
]
```

### View Transitions API (Experimental)

The View Transitions API can be integrated by wrapping DOM modifications with `document.startViewTransition()`. This requires modifying the LiveView client-side code:

```javascript
// app.js
if (document.startViewTransition) {
  liveSocket.enableProfiling()
  // Override the default DOM patching to use view transitions
}
```

```css
::view-transition-old(root) {
  animation: fade-out 0.15s ease-in;
}

::view-transition-new(root) {
  animation: fade-in 0.15s ease-out;
}
```

This is still experimental and browser support is limited. Prefer CSS transitions + JS commands for production.

### Accessibility: Respect Reduced Motion

Always use `motion-safe:` prefix with Tailwind for animations:

```heex
<div class="motion-safe:transition-all motion-safe:duration-300">
  Content
</div>
```

Or use CSS media query:
```css
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```

---

## 6. Alpine.js Integration (When Needed)

### When to Use Alpine.js with LiveView
- Complex client-only interactions (multi-step wizards, drag-and-drop)
- When hooks become too verbose for purely client-side logic
- Existing Alpine.js codebase being migrated

### Prerequisite: Preserve Alpine State

```javascript
// app.js
const liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        Alpine.cloneNode(from, to)
      }
    }
  }
})
```

### 5 Key Integration Patterns

**1. Use `phx-update="ignore"` for Alpine-controlled sections:**
```heex
<div x-data="{open: false}" phx-update="ignore" id="alpine-dropdown">
  <button x-on:click="open = !open">Toggle</button>
  <div x-show="open" x-transition>Dropdown content</div>
</div>
```

**2. Initialize server data in x-init, not x-data:**
```heex
<div x-data="{ count: 0 }" x-init={"count = #{@counter}"}>
  <span x-text="count"></span>
</div>
```

**3. Use JSON.encode! for safe data interpolation:**
```heex
<div x-init={"message = #{JSON.encode!(@user_message)}; tags = #{JSON.encode!(@tags)}"}>
  <p x-text="message"></p>
</div>
```

**4. Compare by persistent IDs, not references:**
```heex
<li x-on:click="selected = fruit">
  <span x-show="selected?.id === fruit.id">Selected</span>
</li>
```

**5. Re-initialize Alpine trees in hooks when LiveView adds new Alpine elements:**
```javascript
Hooks.AlpineInit = {
  mounted() { Alpine.initTree(this.el) },
  updated() { Alpine.initTree(this.el) }
}
```

### Responsibility Split
- **Alpine**: dropdowns, tooltips, client-only toggles, complex animations
- **LiveView**: forms, data fetching, server state, real-time updates

---

## 7. Anti-Patterns to Avoid

1. **Using hooks for simple show/hide** -- Use JS commands instead; they are DOM-patch-aware.

2. **Forgetting unique IDs on phx-hook elements** -- Hooks require a unique `id` attribute to function.

3. **Making async calls in beforeUpdate** -- `beforeUpdate` must be synchronous; async operations will not be awaited.

4. **Excessive hooks** -- Overuse leads to complex, hard-to-maintain client-side logic. Prefer JS commands and CSS.

5. **Not chaining JS commands** -- Defining separate event handlers instead of composing commands leads to multiple round-trips or duplicated logic.

6. **Raw DOM manipulation without hooks** -- Direct DOM changes outside hooks/JS commands will be overwritten by server patches.

7. **Using Alpine.js without `onBeforeElUpdated` config** -- LiveView patches will destroy Alpine state.

8. **Ignoring `motion-safe:`** -- Animations without reduced-motion support violate accessibility guidelines.

9. **Using `setTimeout` hacks for timing** -- Use JS command transitions with `:time` option instead.

10. **Not using `phx-update="ignore"` for third-party widget containers** -- LiveView will clobber third-party library DOM modifications.

---

## 8. Sources Consulted

- [Phoenix.LiveView.JS docs (v1.1.22)](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html)
- [JavaScript interoperability guide (v1.1.22)](https://hexdocs.pm/phoenix_live_view/js-interop.html)
- [Phoenix.LiveView.ColocatedHook docs](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.ColocatedHook.html)
- [Phoenix LiveView 1.1 release blog](https://www.phoenixframework.org/blog/phoenix-liveview-1-1-released)
- [Fly.io: Client-Side Tabs with JS Commands](https://fly.io/phoenix-files/tabs-with-js-commands/)
- [Fly.io: Server-Triggered JS in LiveView](https://fly.io/phoenix-files/server-triggered-js/)
- [Fly.io: toggle_class feature](https://fly.io/phoenix-files/my-favorite-new-liveview-feature/)
- [Fly.io: Pushing Events with JS.push](https://fly.io/phoenix-files/pushing-events-with-js-push/)
- [Alembic: LiveView Page Transitions](https://alembic.com.au/blog/improve-ux-with-liveview-page-transitions)
- [Mave.io: Page Transitions with LiveView](https://www.mave.io/blog/page-transitions-with-phoenix-liveview/)
- [ElixirMerge: View Transitions API with LiveView](https://elixirmerge.com/p/integrating-view-transitions-api-with-phoenix-liveview)
- [Curiosum: 5 Alpine.js & LiveView Integration Patterns](https://www.curiosum.com/blog/fix-alpine-phoenix-liveview-5-integration-patterns-2025)
- [WyeWorks: Integrating LiveView and JS](https://www.wyeworks.com/blog/2024/02/27/integrating-live-view-and-js/)
- [DockYard: Implementing a Client Hook in LiveView](https://dockyard.com/blog/2025/03/11/implementing-a-client-hook-in-liveview)
- [Elixir Streams: Animating with phx-mounted](https://www.elixirstreams.com/tips/animating-elements-on-page-load-with-liveview-phx-mounted-and-js-transition)
- [ElixirMerge: Mastering LiveView JS](https://elixirmerge.com/p/mastering-liveview-js-for-enhanced-phoenix-applications)
- [LiveView Bindings docs](https://hexdocs.pm/phoenix_live_view/bindings.html)
- [Elixir Forum: Animating List Items with Streams](https://elixirforum.com/t/animating-list-items-with-liveview-streams/60753)
- [phx-hook collection (elixir-saas)](https://github.com/elixir-saas/phx-hook)
- [LiveMotion animation library](https://github.com/benvp/live_motion)
