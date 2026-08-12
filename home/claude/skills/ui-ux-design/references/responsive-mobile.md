# Responsive & Mobile-First Design

## Mobile-First Methodology

Start with base styles for smallest viewport, add complexity upward:

```css
/* Base: mobile (320px+) */
.grid { display: flex; flex-direction: column; gap: var(--space-4); }

/* Tablet (768px+) */
@media (min-width: 48rem) {
  .grid { flex-direction: row; flex-wrap: wrap; }
  .grid > * { flex: 1 1 calc(50% - var(--space-4)); }
}

/* Desktop (1024px+) */
@media (min-width: 64rem) {
  .grid > * { flex: 1 1 calc(33.333% - var(--space-4)); }
}
```

## Modern Breakpoints (2025)

```css
/* Mobile-first breakpoints */
--bp-sm: 36rem;   /* 576px - large phones */
--bp-md: 48rem;   /* 768px - tablets */
--bp-lg: 64rem;   /* 1024px - small desktops */
--bp-xl: 80rem;   /* 1280px - large desktops */
--bp-2xl: 96rem;  /* 1536px - ultra-wide */
```

Prefer content-based breakpoints over device-based. Set breakpoints where the layout breaks, not where a device dictates.

## Container Queries > Media Queries (for Components)

```css
.card-container { container-type: inline-size; }

.card { display: grid; gap: var(--space-2); }

@container (min-width: 25rem) {
  .card { grid-template-columns: 200px 1fr; }
}

@container (min-width: 50rem) {
  .card { grid-template-columns: 300px 1fr auto; }
}
```

---

## Viewport Units

### New Viewport Units (solve mobile toolbar issues)

| Unit | Behavior |
|---|---|
| `svh/svw` | Small viewport: toolbars expanded (smallest height) |
| `lvh/lvw` | Large viewport: toolbars retracted (largest height) |
| `dvh/dvw` | Dynamic: adapts as toolbars show/hide |

```css
/* Full-height mobile hero */
.hero {
  min-height: 100dvh;  /* adapts to toolbar state */
}

/* Fixed sidebar */
.sidebar {
  height: 100svh;  /* always accounts for expanded toolbars */
}

/* Fallback */
.hero {
  min-height: 100vh;
  min-height: 100dvh;
}
```

### Safe Area Insets (notch/island devices)

```css
body {
  padding-top: env(safe-area-inset-top);
  padding-bottom: env(safe-area-inset-bottom);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}

/* Bottom navigation accounting for home indicator */
.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding-bottom: calc(var(--space-2) + env(safe-area-inset-bottom));
}
```

---

## Responsive Images

### srcset with Sizes

```html
<img
  src="image-800.jpg"
  srcset="image-400.jpg 400w, image-800.jpg 800w, image-1200.jpg 1200w"
  sizes="(min-width: 64rem) 33vw, (min-width: 48rem) 50vw, 100vw"
  alt="Description"
  loading="lazy"
  decoding="async"
>
```

### Art Direction with Picture

```html
<picture>
  <source media="(min-width: 64rem)" srcset="hero-wide.webp" type="image/webp">
  <source media="(min-width: 48rem)" srcset="hero-medium.webp" type="image/webp">
  <img src="hero-mobile.jpg" alt="Hero image" loading="lazy">
</picture>
```

---

## Touch Interaction Design

### Touch Targets

```css
/* WCAG 2.2 minimum: 24x24px, recommended: 44x44px */
button, a, [role="button"] {
  min-height: 44px;
  min-width: 44px;
  padding: var(--space-2) var(--space-4);
}

/* Expand tap area without changing visual size */
.icon-button {
  position: relative;
}
.icon-button::after {
  content: '';
  position: absolute;
  inset: -8px;
}
```

### Thumb Zone Optimization

Place primary actions in the bottom 1/3 of the screen — the natural thumb reach area.

```css
.bottom-nav {
  position: fixed;
  bottom: 0;
  display: flex;
  justify-content: space-around;
  align-items: center;
  height: 56px;
  padding-bottom: env(safe-area-inset-bottom);
  background: var(--surface);
  border-top: 1px solid var(--border);
}
```

3-5 items max in bottom navigation. Each item: icon + label, minimum 48x48dp touch target.

---

## Mobile Navigation Patterns

### Bottom Navigation Bar

Best for: apps with 3-5 top-level destinations. Place most-used items center-right (right-thumb dominant).

### Hamburger Menu

Best for: content-rich sites with many sections. Always pair with a visible label ("Menu") for discoverability.

### Tab Bar

Best for: apps with parallel sections of equal importance. Highlight active tab with color, weight change, and subtle animation.

### Sheet / Bottom Sheet

Best for: contextual actions, filters, secondary navigation. Pull-to-dismiss gesture with visible drag handle.

---

## Responsive Tables

```css
/* Stack on mobile */
@media (max-width: 48rem) {
  table, thead, tbody, th, td, tr {
    display: block;
  }
  thead { display: none; }
  td {
    padding-left: 50%;
    position: relative;
  }
  td::before {
    content: attr(data-label);
    position: absolute;
    left: var(--space-2);
    font-weight: 600;
  }
}
```

---

## Fluid Spacing

```css
:root {
  --space-section: clamp(var(--space-8), 8vw, var(--space-24));
  --space-content: clamp(var(--space-4), 4vw, var(--space-8));
}
```

---

## Core Web Vitals Optimization

- **LCP (Largest Contentful Paint)**: preload hero image, use `fetchpriority="high"` on LCP element
- **CLS (Cumulative Layout Shift)**: set explicit `width`/`height` on images, reserve space for async content
- **INP (Interaction to Next Paint)**: debounce scroll handlers, use `content-visibility: auto` for off-screen content

```css
/* Reserve space to prevent layout shift */
.image-container {
  aspect-ratio: 16 / 9;
  background: oklch(90% 0 0);
}

/* Virtualize off-screen content */
.long-list-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px;
}
```
