# Animation Patterns for Phoenix LiveView + Tailwind

## Principles

- Every interaction deserves feedback (hover, press, focus, success, error)
- 200-300ms for micro-interactions, 300-500ms for layout shifts — shorter than 100ms is invisible, longer than 1s feels laggy
- `ease-out` for entrances, `ease-in` for exits — never `linear` for UI (feels robotic)
- Only animate GPU-friendly properties: `transform` and `opacity` for 60fps
- Respect `prefers-reduced-motion` — use `motion-safe:` prefix for non-essential animations
- Subtle > dramatic — the more an element changes, the more it risks seeming overdone

## Premium Easing Functions

```css
/* Standard — good default, slightly asymmetric */
transition-timing-function: cubic-bezier(0.25, 0.1, 0.25, 1); /* ease */

/* Snappy enter — fast arrival, gentle settle */
transition-timing-function: cubic-bezier(0.0, 0.0, 0.2, 1); /* ease-out */

/* Smooth exit — slow start, fast departure */
transition-timing-function: cubic-bezier(0.4, 0.0, 1, 1); /* ease-in */

/* Emphasized — for important state changes */
transition-timing-function: cubic-bezier(0.4, 0.0, 0.2, 1); /* ease-in-out */

/* Spring bounce (modern CSS, 88%+ browser support) */
transition-timing-function: linear(0, 0.63 5%, 1.01 15%, 0.97 25%, 1 50%, 1);

/* Custom "Apple-like" smooth */
transition-timing-function: cubic-bezier(0.22, 1, 0.36, 1);
```

Movement is as subjective as color. Custom easing is a branding tool — it defines how your app *feels*.

## Tailwind Micro-Interactions

```html
<!-- Button: lift + press -->
<button class="
  transition-all duration-150
  hover:scale-[1.02] hover:shadow-md
  active:scale-95 active:shadow-sm
">

<!-- Card: float on hover -->
<div class="
  transition-all duration-200
  hover:shadow-lg hover:-translate-y-0.5
  cursor-pointer
">

<!-- Icon: grow + rotate -->
<svg class="
  transition-transform duration-200
  group-hover:scale-110 group-hover:rotate-12
">

<!-- Like button: heartbeat on active -->
<button class="
  transition-all duration-200
  hover:text-pink-500 hover:scale-110
  active:scale-90
">

<!-- Link: underline animation -->
<a class="
  relative after:absolute after:bottom-0 after:left-0
  after:h-px after:w-0 after:bg-current
  after:transition-all after:duration-200
  hover:after:w-full
">

<!-- Focus ring (keyboard accessibility) -->
<button class="
  focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2
  focus-visible:ring-2
">
```

## Entrance Animations

```css
/* In app.css */

@keyframes slide-up {
  from { opacity: 0; transform: translateY(1rem); }
  to { opacity: 1; transform: translateY(0); }
}
.animate-slide-up {
  animation: slide-up 300ms cubic-bezier(0.22, 1, 0.36, 1);
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}
.animate-fade-in {
  animation: fade-in 200ms ease-out;
}

@keyframes scale-in {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
.animate-scale-in {
  animation: scale-in 200ms cubic-bezier(0.22, 1, 0.36, 1);
}

@keyframes slide-in-right {
  from { opacity: 0; transform: translateX(1rem); }
  to { opacity: 1; transform: translateX(0); }
}
.animate-slide-in-right {
  animation: slide-in-right 250ms ease-out;
}

/* Error shake — mimics human "no" head movement */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-4px); }
  75% { transform: translateX(4px); }
}
.animate-shake {
  animation: shake 300ms ease-in-out;
}

/* Success pop — brief scale up for confirmation */
@keyframes pop {
  0% { transform: scale(1); }
  50% { transform: scale(1.15); }
  100% { transform: scale(1); }
}
.animate-pop {
  animation: pop 300ms cubic-bezier(0.22, 1, 0.36, 1);
}
```

## LiveView JS Command Transitions

```elixir
# Show with scale-in
JS.show(transition: {
  "ease-out duration-200",
  "opacity-0 scale-95",
  "opacity-100 scale-100"
})

# Hide with scale-out
JS.hide(transition: {
  "ease-in duration-150",
  "opacity-100 scale-100",
  "opacity-0 scale-95"
})

# Toggle slide
JS.toggle(
  in: {"ease-out duration-300", "opacity-0 -translate-y-2", "opacity-100 translate-y-0"},
  out: {"ease-in duration-200", "opacity-100 translate-y-0", "opacity-0 -translate-y-2"}
)

# Dropdown menu
JS.show(
  to: "#dropdown",
  transition: {"ease-out duration-200", "opacity-0 scale-95 -translate-y-1", "opacity-100 scale-100 translate-y-0"}
)
```

## Loading States

```html
<!-- Skeleton screen (most professional loading pattern) -->
<div class="animate-pulse space-y-3">
  <div class="flex items-center gap-3">
    <div class="w-10 h-10 bg-gray-200 rounded-full"></div>
    <div class="flex-1 space-y-2">
      <div class="h-3 bg-gray-200 rounded w-1/3"></div>
      <div class="h-3 bg-gray-200 rounded w-2/3"></div>
    </div>
  </div>
  <div class="h-4 bg-gray-200 rounded w-3/4"></div>
  <div class="h-4 bg-gray-200 rounded w-1/2"></div>
</div>

<!-- Spinner -->
<svg class="animate-spin h-5 w-5" viewBox="0 0 24 24">
  <circle class="opacity-25" cx="12" cy="12" r="10"
    stroke="currentColor" stroke-width="4" fill="none"/>
  <path class="opacity-75" fill="currentColor"
    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
</svg>

<!-- Button loading (swap text for spinner, keep button width stable) -->
<button disabled class="relative min-w-[6rem]">
  <span class="opacity-0">Submit</span>
  <span class="absolute inset-0 flex items-center justify-center">
    <svg class="animate-spin h-4 w-4" .../>
  </span>
</button>

<!-- Inline progress indicator -->
<div class="h-1 bg-gray-200 rounded-full overflow-hidden">
  <div class="h-full bg-indigo-600 rounded-full transition-all duration-500"
    style={"width: #{@progress}%"}></div>
</div>
```

## Staggered List Animations

```css
.stagger-list > * {
  animation: slide-up 300ms cubic-bezier(0.22, 1, 0.36, 1) backwards;
}
.stagger-list > *:nth-child(1) { animation-delay: 0ms; }
.stagger-list > *:nth-child(2) { animation-delay: 50ms; }
.stagger-list > *:nth-child(3) { animation-delay: 100ms; }
.stagger-list > *:nth-child(4) { animation-delay: 150ms; }
.stagger-list > *:nth-child(5) { animation-delay: 200ms; }
.stagger-list > *:nth-child(n+6) { animation-delay: 250ms; }
```

## LiveView-Specific Patterns

```elixir
# Highlight newly added stream item then fade
push_event(socket, "highlight", %{id: item.id})
```

```javascript
// In app.js hook
this.handleEvent("highlight", ({id}) => {
  const el = document.getElementById(`item-${id}`)
  if (!el) return
  el.classList.add("bg-yellow-50", "transition-colors", "duration-1000")
  requestAnimationFrame(() => el.classList.remove("bg-yellow-50"))
})
```

```css
/* Animate stream inserts via phx-mounted */
[phx-mounted] { animation: slide-up 300ms cubic-bezier(0.22, 1, 0.36, 1); }
```

## Toast/Flash Animations

```css
.flash-enter {
  animation: slide-in-right 300ms ease-out, fade-out 300ms ease-in 4700ms forwards;
}

@keyframes fade-out {
  to { opacity: 0; transform: translateX(1rem); }
}
```

## Quick Reference

| Element | Hover | Active | Enter | Exit | Duration |
|---------|-------|--------|-------|------|----------|
| Button | `hover:bg-* scale-[1.02]` | `scale-95` | — | — | 150ms |
| Card | `shadow-lg -translate-y-0.5` | — | `slide-up` | — | 200ms |
| Modal | — | — | `scale-in` | `scale-95 opacity-0` | 200ms |
| Drawer | — | — | `slide-in-right` | `translateX(full)` | 250ms |
| List item | `bg-gray-50` | — | staggered `slide-up` | — | 300ms |
| Icon btn | `scale-110 rotate-12` | `scale-90` | — | — | 200ms |
| Toggle | `transition-colors` | — | — | — | 200ms |
| Tooltip | — | — | `fade-in` | `fade-out` | 150ms |
| Flash | — | — | `slide-in-right` | auto `fade-out` | 300ms |
| Success | — | — | `pop` | — | 300ms |
| Error | — | — | `shake` | — | 300ms |
