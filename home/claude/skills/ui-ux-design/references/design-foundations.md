# Design Foundations

## Color System (OKLCH)

OKLCH is the recommended color space. It is perceptually uniform: equal numeric changes produce visually equal changes.

```css
/* oklch(lightness chroma hue) */
/* L: 0-1 (or 0%-100%), C: 0-0.4, H: 0-360 */

:root {
  --brand-hue: 262;

  /* Generate palette by varying lightness, keep hue fixed */
  --brand-50:  oklch(95% 0.05 var(--brand-hue));
  --brand-100: oklch(90% 0.08 var(--brand-hue));
  --brand-200: oklch(80% 0.12 var(--brand-hue));
  --brand-300: oklch(70% 0.16 var(--brand-hue));
  --brand-400: oklch(62% 0.21 var(--brand-hue));
  --brand-500: oklch(52% 0.21 var(--brand-hue));
  --brand-600: oklch(42% 0.18 var(--brand-hue));
  --brand-700: oklch(32% 0.14 var(--brand-hue));
  --brand-800: oklch(22% 0.10 var(--brand-hue));
  --brand-900: oklch(12% 0.06 var(--brand-hue));
}
```

### color-mix() for Dynamic Variants

```css
.button:hover {
  background: color-mix(in oklch, var(--brand) 80%, black);
}
.button:active {
  background: color-mix(in oklch, var(--brand) 70%, black);
}
.surface-tinted {
  background: color-mix(in oklch, var(--brand) 10%, white);
}
```

### Dark Mode with light-dark()

```css
html { color-scheme: light dark; }

:root {
  --surface:    light-dark(oklch(98% 0 0), oklch(15% 0 0));
  --on-surface: light-dark(oklch(15% 0 0), oklch(90% 0 0));
  --primary:    light-dark(oklch(50% 0.2 262), oklch(72% 0.18 262));
}
```

### Text Contrast Hierarchy

```css
:root {
  --text-primary:   oklch(15% 0 0);      /* highest contrast */
  --text-secondary: oklch(40% 0 0);      /* reduced emphasis */
  --text-tertiary:  oklch(60% 0 0);      /* lowest emphasis */
  --text-accent:    oklch(55% 0.2 262);  /* brand color for CTAs */
}
```

### Contrast Preferences

```css
@media (prefers-contrast: more) {
  :root {
    --border: oklch(30% 0 0);
    --text-secondary: oklch(25% 0 0);
  }
}
```

### OKLCH Fallback

```css
@supports not (color: oklch(0% 0 0)) {
  :root { --brand: #5b21b6; }
}
```

---

## Typography

### Fluid Typography with clamp()

```css
h1   { font-size: clamp(2.44rem, 4vw + 0.5rem, 3.5rem); }
h2   { font-size: clamp(1.95rem, 2.5vw + 0.75rem, 2.5rem); }
h3   { font-size: clamp(1.56rem, 1.5vw + 0.75rem, 2rem); }
h4   { font-size: clamp(1.25rem, 1vw + 0.75rem, 1.5rem); }
body { font-size: clamp(1rem, 0.5vw + 0.875rem, 1.125rem); }
small { font-size: clamp(0.8rem, 0.3vw + 0.7rem, 0.875rem); }
```

**The clamp() formula:**
```
vw-coefficient = 100 * (max-size - min-size) / (max-viewport - min-viewport)
rem-offset = (min-vp * max-size - max-vp * min-size) / (min-vp - max-vp) / 16
```

Always use `rem` for min/max so fluid type respects user zoom (WCAG 1.4.4).

### Modular Type Scale

```css
:root {
  --type-base: 1rem;
  --type-ratio: 1.25; /* Major Third */

  --text-sm:   calc(var(--type-base) / var(--type-ratio));
  --text-base: var(--type-base);
  --text-lg:   calc(var(--type-base) * var(--type-ratio));
  --text-xl:   calc(var(--text-lg) * var(--type-ratio));
  --text-2xl:  calc(var(--text-xl) * var(--type-ratio));
  --text-3xl:  calc(var(--text-2xl) * var(--type-ratio));
}
```

Common ratios: Minor Third (1.2), Major Third (1.25), Perfect Fourth (1.333), Golden (1.618).

### Variable Fonts

```css
@font-face {
  font-family: 'Inter';
  src: url('Inter-Variable.woff2') format('woff2-variations');
  font-weight: 100 900;
  font-display: swap;
}

body { font-weight: 450; font-variation-settings: 'opsz' 16; }
h1   { font-weight: 680; font-variation-settings: 'opsz' 48; }
```

### Readability

```css
body {
  line-height: 1.6;
  max-inline-size: 65ch;
}
p, li, h1, h2, h3, h4 {
  overflow-wrap: break-word;
  hyphens: auto;
}
.headline { letter-spacing: -0.02em; }
.label    { letter-spacing: 0.04em; text-transform: uppercase; }
```

---

## Spacing (8pt Grid)

```css
:root {
  --space-0:  0;
  --space-1:  0.25rem;  /*  4px */
  --space-2:  0.5rem;   /*  8px */
  --space-3:  0.75rem;  /* 12px */
  --space-4:  1rem;     /* 16px */
  --space-5:  1.25rem;  /* 20px */
  --space-6:  1.5rem;   /* 24px */
  --space-8:  2rem;     /* 32px */
  --space-10: 2.5rem;   /* 40px */
  --space-12: 3rem;     /* 48px */
  --space-16: 4rem;     /* 64px */
  --space-20: 5rem;     /* 80px */
  --space-24: 6rem;     /* 96px */
}
```

**Internal <= External rule**: padding should be equal to or less than margin (Gestalt proximity).

```css
.card {
  padding: var(--space-4);       /* 16px internal */
  margin-bottom: var(--space-6); /* 24px external */
}
```

---

## Layout

### Container Queries

```css
.card-wrapper {
  container-type: inline-size;
  container-name: card;
}

.card { display: flex; flex-direction: column; }

@container card (min-width: 400px) {
  .card { flex-direction: row; gap: 1.5rem; }
}
```

Use `container-type: inline-size` (avoids block-size complications). Use container queries for component-level, media queries for page-level.

### CSS Subgrid (Align Content Across Cards)

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}
.card {
  display: grid;
  grid-row: span 4;
  grid-template-rows: subgrid;
  gap: 0;
}
```

### Full-Bleed Layout

```css
.page {
  display: grid;
  grid-template-columns:
    [full-start] minmax(var(--space-4), 1fr)
    [content-start] min(65ch, 100%)
    [content-end] minmax(var(--space-4), 1fr)
    [full-end];
}
.page > * { grid-column: content; }
.page > .full-bleed { grid-column: full; }
```

### Bento Grid

```css
.bento-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
}
.bento-grid .feature { grid-column: span 2; grid-row: span 2; }
.bento-grid .compact { grid-column: span 1; }
```

### Cascade Layers

```css
@layer reset, tokens, base, layout, components, utilities;

@layer utilities {
  .sr-only {
    position: absolute; width: 1px; height: 1px;
    clip: rect(0 0 0 0); overflow: hidden;
  }
}
```

Lower specificity in higher layers wins. Eliminates `!important` wars.
