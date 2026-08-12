# Animation & Motion

## Performance Rules

Only animate these properties (GPU-composited, no layout/paint triggers):
- `transform` (translate, rotate, scale)
- `opacity`
- `filter` / `backdrop-filter`
- `clip-path`

```css
.animated {
  will-change: transform;
  contain: layout style paint;
}
```

Use `will-change` sparingly — only on elements about to animate. Remove after animation completes.

---

## Reduced Motion

Always respect user preferences:

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

Provide meaningful alternatives (opacity fade instead of sliding, instant state changes).

---

## Entry/Exit Animations with @starting-style

Animate elements entering from `display: none` without JavaScript:

```css
dialog[open] {
  opacity: 1;
  transform: translateY(0);
  transition: opacity 0.3s, transform 0.3s, display 0.3s allow-discrete;

  @starting-style {
    opacity: 0;
    transform: translateY(-1rem);
  }
}

/* Exit: define the "closed" state normally */
dialog:not([open]) {
  opacity: 0;
  transform: translateY(1rem);
}
```

### Popover Entry/Exit

```css
[popover] {
  opacity: 0;
  transform: translateY(3rem);
  transition: opacity 0.2s, transform 0.2s, display 0.2s allow-discrete;

  &:popover-open {
    opacity: 1;
    transform: none;

    @starting-style {
      opacity: 0;
      transform: translateY(-1rem);
    }
  }
}
```

`allow-discrete` on `display` transition keeps element visible during exit animation.

---

## Staggered Animations

Use CSS custom properties for scalable stagger:

```html
<ul style="--length: 6">
  <li style="--index: 0">Item 1</li>
  <li style="--index: 1">Item 2</li>
  <!-- ... -->
</ul>
```

```css
li {
  --index: 0;
  opacity: 0;
  transform: translateY(1rem);
  animation: fade-in 0.3s ease-out forwards;
  animation-delay: calc(0.05s * var(--index));
}

@keyframes fade-in {
  to { opacity: 1; transform: translateY(0); }
}
```

### Bidirectional Stagger (Reverse on Exit)

```css
.menu-item {
  /* Exit: reverse order */
  transition-delay: calc(0.025s * (var(--length) - (var(--index) + 1)));
}
.menu.is-open .menu-item {
  /* Enter: forward order */
  transition-delay: calc(0.025s * var(--index));
}
```

---

## Scroll-Driven Animations

### Progress Bar

```css
@keyframes grow-progress {
  from { transform: scaleX(0); }
  to   { transform: scaleX(1); }
}
.progress-bar {
  transform-origin: left;
  animation: grow-progress linear forwards;
  animation-timeline: scroll();
}
```

### Reveal on Scroll (View Timeline)

```css
@keyframes reveal {
  from { opacity: 0; clip-path: inset(45% 20% 45% 20%); }
  to   { opacity: 1; clip-path: inset(0); }
}
.reveal-on-scroll {
  animation: reveal 1s linear both;
  animation-timeline: view();
}
```

### Enter/Exit on Scroll

```css
@keyframes slide-in  { from { opacity: 0; transform: translateY(100%); } to { opacity: 1; transform: none; } }
@keyframes slide-out { from { opacity: 1; transform: none; } to { opacity: 0; transform: translateY(100%); } }

.scroll-item {
  animation: slide-in linear forwards, slide-out linear forwards;
  animation-timeline: view();
  animation-range: entry, exit;
}
```

### Named Scroll Timeline

```css
.scroll-container {
  overflow-x: scroll;
  scroll-timeline: --gallery inline;
}
.scroll-progress {
  animation: grow-progress linear forwards;
  animation-timeline: --gallery;
}
```

### Feature Detection

```css
@supports (animation-timeline: scroll()) {
  /* scroll-driven animation styles */
}
```

---

## Intersection Observer (Scroll-Triggered JS)

For browsers without scroll-driven animation support:

```javascript
const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.2, rootMargin: '0px 0px -50px 0px' }
);

document.querySelectorAll('.animate-on-scroll')
  .forEach(el => observer.observe(el));
```

```css
.animate-on-scroll {
  opacity: 0;
  transform: translateY(2rem);
  transition: opacity 0.6s, transform 0.6s;
}
.animate-on-scroll.visible {
  opacity: 1;
  transform: none;
}
```

---

## Spring-Like Easing

Use the `linear()` function to simulate spring physics:

```css
/* Bouncy spring (stiffness: 100, damping: 10) */
.spring-bounce {
  transition: transform 0.6s linear(
    0, 0.009, 0.035 2.1%, 0.141, 0.281 6.7%, 0.723 12.9%,
    0.938 16.7%, 1.017, 1.077, 1.121, 1.149 24.3%, 1.159,
    1.152, 1.128 31.6%, 1.042 37.5%, 1.001 43.7%, 0.988,
    0.984 52.4%, 0.998 61.2%, 1.004 71.2%, 1
  );
}

/* Gentle ease-out spring */
.spring-gentle {
  transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

---

## Micro-Interaction Patterns

### Button Press

```css
.button {
  transition: transform 0.1s, box-shadow 0.1s;
}
.button:active {
  transform: scale(0.97);
  box-shadow: none;
}
```

### Hover Lift

```css
.card {
  transition: transform 0.2s, box-shadow 0.2s;
}
.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px oklch(0% 0 0 / 0.12);
}
```

### Loading Skeleton

```css
.skeleton {
  background: linear-gradient(
    90deg,
    oklch(90% 0 0) 25%,
    oklch(95% 0 0) 50%,
    oklch(90% 0 0) 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 0.25rem;
}
@keyframes shimmer {
  from { background-position: 200% 0; }
  to   { background-position: -200% 0; }
}
```

### Smooth Counter / Number Transition

```css
@property --num {
  syntax: "<integer>";
  initial-value: 0;
  inherits: false;
}
.counter {
  counter-reset: num var(--num);
  animation: count 2s forwards;
}
.counter::after { content: counter(num); }
@keyframes count { to { --num: 100; } }
```
