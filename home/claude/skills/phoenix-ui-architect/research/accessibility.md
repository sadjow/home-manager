# Accessibility (ADA/WCAG 2.2) in Phoenix LiveView

## WCAG 2.2 Overview for LiveView

WCAG 2.2 became a W3C Recommendation in late 2023 and is the current legal baseline. It adds 9 new success criteria on top of WCAG 2.1, several directly relevant to LiveView's dynamic nature:

- **2.4.11 Focus Not Obscured (Minimum) - AA**: When an element receives keyboard focus, it must not be entirely hidden by author-created content (sticky headers, modals behind overlays, etc.)
- **2.4.12 Focus Not Obscured (Enhanced) - AAA**: No part of the focused element may be obscured
- **2.4.13 Focus Appearance - AAA**: Focus indicators must be at least 2px thick perimeter with 3:1 contrast ratio between focused/unfocused states
- **2.5.7 Dragging Movements - AA**: All drag operations must have a single-pointer alternative (relevant for sortable lists/tables)
- **2.5.8 Target Size (Minimum) - AA**: Interactive targets must be at least 24x24 CSS pixels

---

## 1. ARIA Roles and Dynamic Content

### First Rule of ARIA
Use native HTML elements whenever possible. Only add ARIA when native semantics are insufficient:

```heex
<%!-- Prefer native elements --%>
<nav aria-label="Main navigation">...</nav>
<main>...</main>
<button>Save</button>

<%!-- Only use ARIA when native elements won't work --%>
<div role="tablist" aria-label="Settings sections">...</div>
```

### ARIA Live Regions for Real-Time Updates

LiveView's server-rendered updates don't automatically announce to screen readers. Use `aria-live` regions to notify assistive technology:

```heex
<%!-- For non-urgent updates (most common) --%>
<div aria-live="polite" aria-atomic="true">
  <%= if @search_results_count do %>
    <%= @search_results_count %> results found
  <% end %>
</div>

<%!-- For urgent notifications (use sparingly) --%>
<div aria-live="assertive" role="alert">
  <%= if @error_message, do: @error_message %>
</div>
```

Key rules for live regions:
- The container with `aria-live` must exist in the DOM before content is injected
- Use `aria-live="polite"` for most updates (waits for screen reader to finish current sentence)
- Use `aria-live="assertive"` only for critical alerts (interrupts current speech)
- Use `aria-atomic="true"` when the entire region should be re-read on any change
- Keep live region content concise; screen readers read everything inside

### Flash Messages (Generated CoreComponents Pattern)

Phoenix's generated CoreComponents use `role="alert"` for flash messages:

```heex
<div role="alert" class="toast toast-top toast-end z-50">
  <div class="alert">
    <.icon :if={@kind == :info} name="hero-information-circle" />
    <span><%= msg %></span>
    <button type="button" aria-label={gettext("close")}>
      <.icon name="hero-x-mark" />
    </button>
  </div>
</div>
```

### Screen Reader-Only Content

Use Tailwind's `sr-only` class for content only screen readers should access:

```heex
<th>
  <span class="sr-only">Actions</span>
</th>

<button>
  <.icon name="hero-trash" />
  <span class="sr-only">Delete item</span>
</button>
```

---

## 2. Focus Management

### LiveView Focus Primitives (since 0.18)

LiveView provides built-in JS commands for programmatic focus management:

#### JS.focus/1 - Focus a Specific Element
```elixir
def close_dropdown(js \\ %JS{}, id) do
  js
  |> JS.hide(to: "##{id}-body", time: 200, transition: {"ease-out", "opacity-100", "opacity-0"})
  |> JS.focus(to: "##{id}")
end
```

#### JS.focus_first/1 - Focus First Focusable Child
```elixir
def open_dropdown(js \\ %JS{}, id) do
  js
  |> JS.show(to: "##{id}-body", transition: {"ease-in", "opacity-0", "opacity-100"})
  |> JS.focus_first(to: "##{id}-options")
end
```

#### JS.push_focus/0 and JS.pop_focus/0 - Focus Stack
Store and restore focus position (essential for modals):

```heex
<button phx-click={show_modal("confirm-dialog") |> JS.push_focus()}>
  Open Dialog
</button>

<%!-- Inside the modal close handler --%>
<button phx-click={hide_modal("confirm-dialog") |> JS.pop_focus()}>
  Close
</button>
```

### Focus During Live Navigation

When using `push_navigate` or `push_patch`, focus is not automatically managed. Best practices:

- Update `@page_title` on every navigation so screen readers announce the new context
- Use `handle_params/3` to set focus on the main content area after navigation
- Consider announcing route changes via an aria-live region

```elixir
def handle_params(_params, _uri, socket) do
  {:noreply, assign(socket, page_title: "Settings - Profile")}
end
```

In the root layout:
```heex
<title><%= assigns[:page_title] || "MyApp" %></title>
```

### phx-update="stream" and Focus

When using streams, LiveView patches the DOM incrementally. Be aware that:
- Focus can be lost when streamed items are re-rendered
- Place interactive elements inside streamed items (not outside)
- Use `JS.focus` in event handlers to restore focus after stream updates when needed

---

## 3. Keyboard Navigation

### Focus Wrapping (Modals/Dialogs)

The `focus_wrap/1` component constrains tab navigation within a container:

```heex
<.focus_wrap id="modal-content">
  <div role="dialog" aria-modal="true" aria-labelledby="modal-title">
    <h2 id="modal-title">Confirm Action</h2>
    <p>Are you sure you want to proceed?</p>
    <button phx-click={hide_modal("my-modal") |> JS.pop_focus()}>
      Cancel
    </button>
    <button phx-click="confirm">
      Confirm
    </button>
  </div>
</.focus_wrap>
```

### Escape Key Handling

Use `phx-keydown` with `phx-key` for keyboard shortcuts:

```heex
<div
  id="dropdown-menu"
  phx-keydown={close_dropdown("dropdown")}
  phx-key="escape"
  role="menu"
>
  <a role="menuitem" href="/profile">Profile</a>
  <a role="menuitem" href="/settings">Settings</a>
</div>
```

### ARIA Attribute Management with JS Commands

Toggle ARIA states client-side without server roundtrips:

```elixir
def toggle_dropdown(js \\ %JS{}, id) do
  js
  |> JS.toggle(to: "##{id}-menu")
  |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{id}-trigger")
end
```

Set/remove attributes:
```elixir
JS.set_attribute({"aria-expanded", "true"}, to: "#dropdown")
JS.remove_attribute("aria-expanded", to: "#dropdown")
```

### Skip Links and Landmark Regions

Implement skip links in the root layout:

```heex
<body>
  <a href="#main-content" class="sr-only focus:not-sr-only focus:absolute focus:z-50 focus:p-4 focus:bg-white focus:text-black">
    Skip to main content
  </a>
  <header role="banner">
    <nav aria-label="Main navigation">...</nav>
  </header>
  <main id="main-content" role="main" tabindex="-1">
    <%= @inner_content %>
  </main>
  <footer role="contentinfo">...</footer>
</body>
```

### Tab Order with Dynamic Content

- Avoid positive `tabindex` values; use `tabindex="0"` to add elements to natural tab order
- Use `tabindex="-1"` for elements that should be focusable programmatically but not via tab
- When dynamically adding content, ensure new interactive elements appear in logical DOM order

---

## 4. Accessible Component Patterns

### Accessible Forms with Ecto Changesets

#### Error Association Pattern
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
  <p :if={used_input?(@form[:email])} id="user-email-error" class="text-error" role="alert">
    <%= for {msg, _opts} <- @form[:email].errors do %>
      <%= msg %>
    <% end %>
  </p>
</div>
```

#### Progressive Error Display
Use `Phoenix.Component.used_input?/1` to only show errors for fields the user has interacted with:

```elixir
errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []
```

#### Error Summary Pattern
For forms with many fields, provide an error summary at the top:

```heex
<div :if={@form.errors != []} role="alert" aria-labelledby="error-summary-title">
  <h3 id="error-summary-title">Please fix the following errors:</h3>
  <ul>
    <li :for={{field, {msg, _opts}} <- @form.errors}>
      <a href={"#user-#{field}"}><%= Phoenix.Naming.humanize(field) %>: <%= msg %></a>
    </li>
  </ul>
</div>
```

#### Number Input Accessibility
Avoid `type="number"` (has known accessibility issues). Use instead:

```heex
<input type="text" inputmode="numeric" pattern="[0-9]*" />
```

### Accessible Tabs

```heex
<div>
  <div role="tablist" aria-label="Account settings">
    <button
      :for={{tab, index} <- Enum.with_index(@tabs)}
      role="tab"
      id={"tab-#{tab.id}"}
      aria-selected={to_string(@active_tab == tab.id)}
      aria-controls={"panel-#{tab.id}"}
      tabindex={if @active_tab == tab.id, do: "0", else: "-1"}
      phx-click="select_tab"
      phx-value-tab={tab.id}
      phx-keydown="tab_keydown"
    >
      <%= tab.label %>
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
    <%= render_slot(tab.content) %>
  </div>
</div>
```

Arrow key navigation for tabs:
```elixir
def handle_event("tab_keydown", %{"key" => "ArrowRight"}, socket) do
  next_tab = next_tab(socket.assigns.active_tab, socket.assigns.tabs)
  {:noreply, assign(socket, active_tab: next_tab)}
end

def handle_event("tab_keydown", %{"key" => "ArrowLeft"}, socket) do
  prev_tab = prev_tab(socket.assigns.active_tab, socket.assigns.tabs)
  {:noreply, assign(socket, active_tab: prev_tab)}
end
```

### Accessible Modals (Full Pattern)

```heex
<div
  id={@id}
  phx-mounted={@show && show_modal(@id)}
  phx-remove={hide_modal(@id)}
  class="relative z-50 hidden"
>
  <%!-- Backdrop --%>
  <div id={"#{@id}-bg"} class="fixed inset-0 bg-black/50" aria-hidden="true" />

  <div
    class="fixed inset-0 overflow-y-auto"
    role="dialog"
    aria-modal="true"
    aria-labelledby={"#{@id}-title"}
    aria-describedby={"#{@id}-description"}
    tabindex="0"
  >
    <.focus_wrap
      id={"#{@id}-wrap"}
      phx-window-keydown={hide_modal(@id) |> JS.pop_focus()}
      phx-key="escape"
    >
      <div class="modal-content">
        <button
          phx-click={hide_modal(@id) |> JS.pop_focus()}
          type="button"
          class="close-button"
          aria-label={gettext("Close dialog")}
        >
          <.icon name="hero-x-mark" />
        </button>

        <h2 id={"#{@id}-title"}><%= @title %></h2>
        <div id={"#{@id}-description"}>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </.focus_wrap>
  </div>
</div>
```

### Accessible Data Tables

```heex
<table>
  <caption class="sr-only"><%= @caption %></caption>
  <thead>
    <tr>
      <th
        :for={col <- @columns}
        scope="col"
        aria-sort={sort_direction(@sort_field, @sort_dir, col.field)}
      >
        <button :if={col.sortable} phx-click="sort" phx-value-field={col.field}>
          <%= col.label %>
          <span aria-hidden="true"><%= sort_icon(@sort_field, @sort_dir, col.field) %></span>
        </button>
        <span :if={!col.sortable}><%= col.label %></span>
      </th>
      <th><span class="sr-only">Actions</span></th>
    </tr>
  </thead>
  <tbody id={@id} phx-update={@streams && "stream"}>
    <tr :for={row <- @rows} id={row.id}>
      <td :for={col <- @columns}><%= render_slot(col, row) %></td>
      <td><%= render_slot(@action, row) %></td>
    </tr>
  </tbody>
</table>
```

Helper for `aria-sort`:
```elixir
defp sort_direction(current_field, direction, col_field) do
  cond do
    current_field != col_field -> "none"
    direction == :asc -> "ascending"
    direction == :desc -> "descending"
    true -> "none"
  end
end
```

### Accessible Dropdowns

```heex
<div class="relative" id={"dropdown-#{@id}"}>
  <button
    id={"dropdown-#{@id}-trigger"}
    aria-haspopup="true"
    aria-expanded="false"
    phx-click={toggle_dropdown("dropdown-#{@id}")}
  >
    <%= @label %>
  </button>

  <.focus_wrap id={"dropdown-#{@id}-wrap"}>
    <ul
      id={"dropdown-#{@id}-menu"}
      role="menu"
      aria-labelledby={"dropdown-#{@id}-trigger"}
      class="hidden"
      phx-keydown={close_dropdown("dropdown-#{@id}")}
      phx-key="escape"
    >
      <li :for={item <- @items} role="menuitem">
        <.link navigate={item.href}><%= item.label %></.link>
      </li>
    </ul>
  </.focus_wrap>
</div>
```

---

## 5. Color Contrast and Visual Accessibility

### WCAG AA Contrast Requirements
- Normal text (< 18pt / < 14pt bold): 4.5:1 minimum ratio
- Large text (>= 18pt / >= 14pt bold): 3:1 minimum ratio
- UI components and graphical objects: 3:1 minimum ratio
- Focus indicators (WCAG 2.2): 3:1 contrast between focused/unfocused states

### Tailwind Dark Mode with Contrast

```css
/* Ensure both light and dark themes meet contrast requirements */
:root {
  --color-text: theme('colors.zinc.900');       /* High contrast on light */
  --color-bg: theme('colors.white');
}

.dark {
  --color-text: theme('colors.zinc.100');        /* High contrast on dark */
  --color-bg: theme('colors.zinc.900');
}
```

Use Tailwind's dark mode:
```heex
<p class="text-zinc-900 dark:text-zinc-100">Accessible text</p>
```

### Focus Indicator Styling

```css
/* Meets WCAG 2.4.13 Focus Appearance (2px, 3:1 contrast) */
:focus-visible {
  outline: 2px solid currentColor;
  outline-offset: 2px;
}

/* Custom focus ring with Tailwind */
.focus-ring {
  @apply focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600;
}
```

---

## 6. Reduced Motion Preferences

### Tailwind motion-safe / motion-reduce

```heex
<%!-- Animation only when user allows motion --%>
<div class="motion-safe:animate-fade-in motion-reduce:opacity-100">
  <%= @content %>
</div>

<%!-- Transition only when safe --%>
<div class={[
  "transition-transform duration-300",
  "motion-safe:translate-y-0",
  "motion-reduce:transition-none"
]}>
  Content
</div>
```

### CSS Custom Approach

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### LiveView Transitions

When using JS.show/JS.hide transitions, provide reduced-motion alternatives:

```elixir
def show_modal(js \\ %JS{}, id) do
  js
  |> JS.show(
    to: "##{id}",
    transition: {"motion-safe:transition-opacity duration-300", "opacity-0", "opacity-100"}
  )
  |> JS.focus_first(to: "##{id}-content")
end
```

---

## 7. Common Accessibility Mistakes in LiveView

### 1. Missing aria-live for Dynamic Content
LiveView updates the DOM server-side. Without `aria-live`, screen readers won't announce changes. Always wrap dynamic status messages, counters, and notifications in live regions.

### 2. Lost Focus After Server Events
When `handle_event` triggers DOM changes, focus can jump to `<body>`. Use `JS.focus` or `JS.focus_first` in your event response to restore focus.

### 3. Inaccessible Custom Controls Without Roles
Building a dropdown with `<div>` and `phx-click` but no `role`, `aria-expanded`, or keyboard handlers. Always implement the WAI-ARIA Authoring Practices keyboard contract for any role you assign.

### 4. Using role="application" Incorrectly
This disables screen reader document browsing mode. Almost never appropriate for web apps. Avoid unless you are building a truly widget-heavy application with full keyboard control.

### 5. Using role="menu" for Navigation Links
`role="menu"` is for application menus (like desktop app menus), not for navigation link lists. Use `<nav>` with `<ul>/<li>` for site navigation.

### 6. Not Updating Page Title on Live Navigation
Screen reader users rely on page titles to understand context after navigation. Always update `@page_title` in `mount/3` and `handle_params/3`.

### 7. Form Errors Without ARIA Association
Rendering error text visually near an input is not enough. Use `aria-describedby` to programmatically link the error to its input, and `aria-invalid` to mark the field as invalid.

### 8. Animations Without Reduced Motion Support
LiveView transitions (show/hide) animate by default. Always include `motion-safe:` prefix or `prefers-reduced-motion` media query alternatives.

### 9. Missing Labels on Icon-Only Buttons
Buttons with only an icon (close, delete, menu) must have `aria-label` or a `sr-only` text span:

```heex
<button aria-label={gettext("Close dialog")}>
  <.icon name="hero-x-mark" />
</button>
```

### 10. Sortable Tables Without aria-sort
When implementing sortable columns, always include `aria-sort="ascending"`, `"descending"`, or `"none"` on `<th>` elements.

### 11. Focus Trapping Failures
Opening a modal without `focus_wrap` lets tab navigate to background content. Always use `<.focus_wrap>` for modals, dialogs, and slide-over panels.

### 12. Target Size Too Small
WCAG 2.2 requires 24x24px minimum for interactive targets. Ensure buttons, links, and clickable elements meet this minimum, especially on mobile.

---

## 8. Testing Accessibility in Phoenix

### Automated Testing

```elixir
# In your test helpers, verify ARIA attributes
assert has_element?(view, "[role='alert']")
assert has_element?(view, "[aria-live='polite']")
assert has_element?(view, "button[aria-label]")
assert has_element?(view, "input[aria-invalid='true']")
```

### Manual Testing Checklist
1. Tab through the entire page - can you reach all interactive elements?
2. Escape key closes modals/dropdowns and returns focus to trigger
3. Screen reader announces flash messages and dynamic updates
4. Page title updates on live navigation
5. Focus visible indicator is clear on all interactive elements
6. Error messages are announced when form validation fails
7. All images have alt text (or alt="" for decorative)
8. Color is not the only means of conveying information

### Recommended Tools
- **axe-core**: Automated accessibility testing (can integrate via Wallaby)
- **WAVE**: Browser extension for visual accessibility checks
- **VoiceOver** (macOS): Test actual screen reader experience
- **Lighthouse**: Accessibility audit in Chrome DevTools

---

## Sources Consulted

- [Using LiveView's new primitives for accessibility - Fly.io Phoenix Files](https://fly.io/phoenix-files/liveview-accessible-focus/)
- [Accessibility and Real-time Apps: Clearing Fog and Picking Fruit - Fly.io Blog](https://fly.io/blog/accessibility-clearing-the-fog/)
- [Phoenix.Component documentation - HexDocs](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html)
- [Phoenix.LiveView.JS documentation - HexDocs](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html)
- [Phoenix LiveView Form Bindings - HexDocs](https://hexdocs.pm/phoenix_live_view/form-bindings.html)
- [LiveView 0.18 Released - Phoenix Blog](https://www.phoenixframework.org/blog/phoenix-liveview-0.18-released)
- [What's New in WCAG 2.2 - W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/)
- [WCAG 2.2 Complete Guide 2025 - AllAccessible](https://www.allaccessible.org/blog/wcag-22-complete-guide-2025)
- [ARIA Live Regions - TPGi](https://www.tpgi.com/screen-reader-support-aria-live-regions/)
- [Using ARIA landmarks to identify regions - W3C](https://w3c.github.io/wcag/techniques/aria/ARIA11)
- [ARIA21: Using aria-invalid to Indicate An Error Field - W3C](https://www.w3.org/WAI/WCAG21/Techniques/aria/ARIA21)
- [Skip Navigation Links - A11Y Project](https://www.a11yproject.com/posts/skip-nav-links/)
- [Improving Modal Accessibility with Phoenix LiveView Helpers - Elixir Merge](https://elixirmerge.com/p/improving-modal-accessibility-with-phoenix-liveview-helpers)
- [Building Table Views with Phoenix LiveView - Pragmatic Programmers](https://pragprog.com/titles/puphoe/building-table-views-with-phoenix-liveview/)
- [Motion Safe Animations in Tailwind CSS - DEV Community](https://dev.to/hexshift/building-fluid-motion-safe-animations-in-tailwind-css-that-respect-user-preferences-3i6e)
- [Tailwind Contrast Checker - TWColors](https://tailwindcolor.tools/tailwind-contrast-checker)
- [Phoenix CoreComponents source - GitHub](https://github.com/phoenixframework/phoenix/blob/main/installer/templates/phx_web/components/core_components.ex)
