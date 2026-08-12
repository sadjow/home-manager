# Component Patterns for Phoenix LiveView + Tailwind

## Layout Principles

### Visual hierarchy through spacing

```
Tight spacing (gap-1, gap-2, p-2): related items within a group
Medium spacing (gap-3, gap-4, p-4): between groups
Large spacing (gap-6, gap-8, p-6): between sections
```

### Information density tiers

| Tier | Use case | Text | Spacing | Avatar |
|------|----------|------|---------|--------|
| Compact | Sidebars, panels, map overlays | `text-xs` / `text-sm` | `p-2` `gap-1` | `w-6 h-6` |
| Standard | Main content, cards | `text-sm` / `text-base` | `p-4` `gap-3` | `w-8 h-8` / `w-10 h-10` |
| Spacious | Hero, landing, focus views | `text-base` / `text-lg` | `p-6` `gap-4` | `w-12 h-12` |

### Responsive component pattern

Use a `compact` boolean attr to create density variants from a single component:

```elixir
attr :compact, :boolean, default: false

def my_component(assigns) do
  ~H"""
  <div class={[
    "flex items-center",
    if(@compact, do: "gap-2 p-2 text-xs", else: "gap-3 p-4 text-sm")
  ]}>
    ...
  </div>
  """
end
```

### Content-first layout

Structure pages around content priority, not around visual decoration:

```
1. Primary content area — maximum width, central position
2. Supporting context — sidebar or secondary section
3. Navigation — minimal, predictable placement
4. Actions — close to the content they act on
```

## Progressive Disclosure

Show what matters now, reveal details on demand. Reduces cognitive load and keeps interfaces clean.

### Patterns

```html
<!-- Expandable detail section -->
<div>
  <button phx-click={JS.toggle(to: "#details")}
    class="flex items-center gap-1 text-sm text-gray-600 hover:text-gray-900
      transition-colors duration-150">
    <svg class="w-4 h-4 transition-transform duration-200"
      id="chevron">...</svg>
    <span>More details</span>
  </button>
  <div id="details" class="hidden mt-2 pl-5 text-sm text-gray-600
    animate-slide-up">
    ...
  </div>
</div>

<!-- Truncated text with "Read more" -->
<p class="text-sm text-gray-700 line-clamp-3">
  Long content here...
</p>
<button class="text-sm text-indigo-600 hover:text-indigo-500 mt-1">
  Read more
</button>

<!-- Stepped form (show one section at a time) -->
<div :if={@step == 1}>Step 1 fields...</div>
<div :if={@step == 2}>Step 2 fields...</div>
<div :if={@step == 3}>Review & submit...</div>
```

### When to disclose progressively

- **Always show**: primary actions, critical status, navigation
- **On demand**: secondary details, advanced options, metadata
- **On hover/focus**: tooltips, preview content, helper text
- **On scroll**: lazy-loaded content, infinite lists

## Touch targets

Minimum 44x44px for mobile touch targets. Apply via padding:

```html
<!-- Icon button with proper touch target -->
<button class="p-2 -m-1 rounded-md hover:bg-gray-100">
  <svg class="w-4 h-4">...</svg>
</button>

<!-- Text button with proper touch target -->
<button class="px-3 py-2 text-sm rounded-md hover:bg-gray-100">
  Reply
</button>
```

Use negative margins (`-m-*`) to keep visual alignment while expanding hit area.

### Thumb zone design (mobile)

```
Easy reach:    bottom center of screen — primary actions go here
Stretch zone:  top corners — navigation, secondary actions
Hard reach:    top center — avoid placing frequent actions here
```

Place the most frequent actions at the bottom of the screen for thumb reachability on mobile.

## Card patterns

```html
<!-- Interactive card -->
<div class="
  bg-white rounded-xl border border-gray-200
  shadow-sm hover:shadow-md
  transition-all duration-200
  hover:-translate-y-0.5
">
  <div class="p-4">...</div>
</div>

<!-- Subtle card (lower visual weight) -->
<div class="bg-gray-50 rounded-lg p-4">...</div>

<!-- Bordered card (medium weight) -->
<div class="bg-white rounded-lg border border-gray-200 p-4">...</div>

<!-- Selected card (active state) -->
<div class={[
  "bg-white rounded-lg border-2 p-4 transition-all duration-200",
  if(@selected, do: "border-indigo-500 shadow-md", else: "border-gray-200")
]}>...</div>
```

## List patterns

```html
<!-- Interactive list with dividers -->
<ul class="divide-y divide-gray-100">
  <li :for={item <- @items}
    class="flex items-center gap-3 px-4 py-3
      hover:bg-gray-50 transition-colors duration-150 cursor-pointer">
    <div class="flex-1 min-w-0">
      <p class="text-sm font-medium text-gray-900 truncate">{item.title}</p>
      <p class="text-xs text-gray-500 truncate">{item.subtitle}</p>
    </div>
    <svg class="w-4 h-4 text-gray-400 flex-shrink-0"><!-- chevron --></svg>
  </li>
</ul>

<!-- Grouped list with section headers -->
<div :for={{group, items} <- @grouped_items} class="space-y-1">
  <h3 class="px-4 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wider">
    {group}
  </h3>
  <ul class="space-y-0.5">...</ul>
</div>
```

## Form patterns

```html
<!-- Input with animated label -->
<div class="relative">
  <input
    class="
      peer w-full px-3 pt-5 pb-2 rounded-lg border border-gray-300
      focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500
      placeholder-transparent text-sm
    "
    placeholder="Email"
  />
  <label class="
    absolute left-3 top-1 text-xs text-gray-500
    peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-sm
    peer-focus:top-1 peer-focus:text-xs peer-focus:text-indigo-600
    transition-all duration-200
  ">Email</label>
</div>

<!-- Inline form (compact, for embedded use) -->
<form class="flex items-center gap-2">
  <input class="flex-1 text-sm rounded-lg border-gray-300 px-3 py-2" />
  <button class="rounded-lg bg-gray-900 px-3 py-2 text-xs font-medium text-white
    hover:bg-gray-800 active:scale-95 transition-all duration-150">
    Submit
  </button>
</form>

<!-- Inline validation with real-time feedback -->
<div class="relative">
  <input phx-debounce="300" phx-change="validate"
    class={[
      "w-full px-3 py-2 rounded-lg border text-sm transition-colors duration-200",
      cond do
        @field_error -> "border-red-300 focus:border-red-500 focus:ring-red-500"
        @field_valid -> "border-green-300 focus:border-green-500 focus:ring-green-500"
        true -> "border-gray-300 focus:border-indigo-500 focus:ring-indigo-500"
      end
    ]} />
  <div :if={@field_error}
    class="mt-1 text-xs text-red-600 animate-fade-in">
    {@field_error}
  </div>
</div>
```

## Empty states

Empty states are opportunities — they guide users toward their first action.

```html
<!-- Standard empty state -->
<div class="flex flex-col items-center justify-center py-12 text-center">
  <div class="w-12 h-12 rounded-full bg-gray-100 flex items-center justify-center mb-4">
    <svg class="w-6 h-6 text-gray-400">...</svg>
  </div>
  <p class="text-sm font-medium text-gray-900">No items yet</p>
  <p class="text-xs text-gray-500 mt-1">Get started by creating your first item.</p>
  <button class="mt-4 text-sm font-medium text-indigo-600 hover:text-indigo-500
    transition-colors duration-150">
    Create item
  </button>
</div>

<!-- Compact empty state (for sidebars, panels) -->
<div class="py-6 text-center">
  <p class="text-xs text-gray-500">No items</p>
</div>

<!-- Search empty state -->
<div class="flex flex-col items-center justify-center py-8 text-center">
  <svg class="w-8 h-8 text-gray-300 mb-3"><!-- search icon --></svg>
  <p class="text-sm text-gray-600">No results for "{@query}"</p>
  <p class="text-xs text-gray-400 mt-1">Try a different search term</p>
</div>
```

## Feedback patterns

### Success feedback

```html
<!-- Flash with icon -->
<div class="flex items-center gap-2 p-3 rounded-lg bg-green-50 text-green-800 text-sm animate-slide-in-right">
  <svg class="w-4 h-4 flex-shrink-0"><!-- checkmark --></svg>
  <span>Saved successfully</span>
</div>

<!-- Inline success (replace button text temporarily) -->
<!-- Use push_event + JS to show "Saved!" then revert after 2s -->
```

### Error feedback

```html
<!-- Form field error -->
<input class="border-red-300 focus:border-red-500 focus:ring-red-500" />
<p class="mt-1 text-xs text-red-600 animate-fade-in">This field is required</p>

<!-- Shake animation for invalid submit -->
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-4px); }
  75% { transform: translateX(4px); }
}
.animate-shake { animation: shake 300ms ease-in-out; }
```

### Confirmation dialogs

```html
<!-- Destructive action confirmation -->
<div class="p-6 max-w-sm">
  <h3 class="text-base font-semibold text-gray-900">Delete this item?</h3>
  <p class="mt-2 text-sm text-gray-600">
    This action cannot be undone. This will permanently delete the item.
  </p>
  <div class="mt-4 flex gap-3 justify-end">
    <button class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300
      rounded-lg hover:bg-gray-50 transition-colors duration-150">
      Cancel
    </button>
    <button class="px-3 py-2 text-sm font-medium text-white bg-red-600
      rounded-lg hover:bg-red-700 active:scale-95 transition-all duration-150">
      Delete
    </button>
  </div>
</div>
```

### Optimistic updates

```elixir
# Immediately update UI, revert on error
def handle_event("toggle-like", _, socket) do
  socket = update(socket, :liked, &(!&1))
  case Posts.toggle_like(post, user_id) do
    {:ok, _, _} -> {:noreply, socket}
    {:error, _} ->
      {:noreply,
       socket
       |> update(:liked, &(!&1))
       |> put_flash(:error, "Could not process")}
  end
end
```

## Navigation patterns

### Breadcrumbs

```html
<nav class="flex items-center gap-1 text-sm text-gray-500">
  <a href="/" class="hover:text-gray-700 transition-colors duration-150">Home</a>
  <svg class="w-4 h-4"><!-- chevron-right --></svg>
  <a href="/posts" class="hover:text-gray-700 transition-colors duration-150">Posts</a>
  <svg class="w-4 h-4"><!-- chevron-right --></svg>
  <span class="text-gray-900 font-medium">Current Page</span>
</nav>
```

### Tab navigation

```html
<nav class="flex gap-1 border-b border-gray-200">
  <button :for={tab <- @tabs}
    phx-click="switch-tab" phx-value-tab={tab.id}
    class={[
      "px-3 py-2 text-sm font-medium border-b-2 -mb-px transition-colors duration-200",
      if(tab.id == @active_tab,
        do: "border-indigo-500 text-indigo-600",
        else: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300")
    ]}>
    {tab.label}
  </button>
</nav>
```

## Color system

### Semantic colors (use these, not raw colors)

| Purpose | Light | Dark | Hover |
|---------|-------|------|-------|
| Primary action | `bg-indigo-600 text-white` | — | `hover:bg-indigo-700` |
| Secondary action | `bg-gray-100 text-gray-700` | — | `hover:bg-gray-200` |
| Destructive | `text-red-600` | — | `hover:text-red-700 hover:bg-red-50` |
| Success | `bg-green-50 text-green-800` | — | — |
| Warning | `bg-yellow-50 text-yellow-800` | — | — |
| Info | `bg-blue-50 text-blue-800` | — | — |
| Muted text | `text-gray-500` | `text-gray-400` | — |
| Borders | `border-gray-200` | `border-gray-100` (subtle) | — |

### Color usage rules

- **Never use color as the only indicator** — always pair with icon, text, or shape
- **Limit palette**: 1 primary accent + neutrals + semantic colors (success, error, warning)
- **Consistent meaning**: once indigo means "action", it always means "action"
- **Muted by default, vivid on intent**: most UI is gray, color draws attention to what matters

### Depth via shadows

```
shadow-sm    → cards at rest
shadow-md    → cards on hover, dropdowns
shadow-lg    → modals, floating panels
shadow-xl    → popovers, overlays
shadow-2xl   → full-screen drawers
```

## Onboarding patterns

### Progressive onboarding (reveal as needed, not all at once)

```html
<!-- Tooltip hint on first use -->
<div :if={@show_hint} class="absolute -top-10 left-1/2 -translate-x-1/2
  px-3 py-1.5 bg-gray-900 text-white text-xs rounded-lg shadow-lg
  animate-fade-in whitespace-nowrap">
  Click here to create your first post
  <div class="absolute top-full left-1/2 -translate-x-1/2
    border-4 border-transparent border-t-gray-900"></div>
</div>

<!-- Contextual empty state (guides the user) -->
<div class="text-center py-8">
  <p class="text-sm text-gray-600">Welcome! Start by adding a location to the map.</p>
  <button class="mt-3 px-4 py-2 bg-indigo-600 text-white text-sm rounded-lg
    hover:bg-indigo-700 active:scale-95 transition-all duration-150">
    Add your first location
  </button>
</div>
```

### Onboarding rules

- **Never show a wall of instructions** — teach through interaction
- **One thing at a time** — highlight the next action, not all actions
- **Dismissible** — always let users skip or close onboarding hints
- **Contextual** — show hints where the action happens, not in a separate modal
