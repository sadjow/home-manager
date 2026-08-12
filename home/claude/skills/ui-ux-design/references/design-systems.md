# Design Systems

## Token Architecture (Three-Tier)

```css
:root {
  /* TIER 1: Primitive tokens (raw values) */
  --color-blue-400: oklch(65% 0.18 250);
  --color-blue-500: oklch(55% 0.20 250);
  --color-blue-600: oklch(45% 0.20 250);
  --color-gray-100: oklch(95% 0.01 250);
  --color-gray-900: oklch(15% 0.01 250);
  --font-size-16: 1rem;
  --radius-4: 0.25rem;
  --radius-8: 0.5rem;

  /* TIER 2: Semantic tokens (contextual meaning) */
  --color-primary:       var(--color-blue-500);
  --color-primary-hover: var(--color-blue-600);
  --color-surface:       var(--color-gray-100);
  --color-on-surface:    var(--color-gray-900);
  --font-size-body:      var(--font-size-16);
  --radius-default:      var(--radius-8);

  /* TIER 3: Component tokens (scoped) */
  --button-bg:        var(--color-primary);
  --button-bg-hover:  var(--color-primary-hover);
  --button-radius:    var(--radius-default);
  --button-font-size: var(--font-size-body);
}
```

### Dark Theme (Override Semantic Layer Only)

```css
[data-theme="dark"] {
  --color-surface:    var(--color-gray-900);
  --color-on-surface: var(--color-gray-100);
  --color-primary:    var(--color-blue-400);
}
```

### Token Naming Convention

`[category]-[property]-[element]-[modifier]-[state]`

Examples:
- `--color-background-button-primary-active`
- `--color-text-heading-default`
- `--space-padding-card-default`

Only tokenize values used across multiple components. Keep one-off values as literals.

---

## OKLCH Color Scale Generation

Generate a complete 50-900 scale from a single base hue:

```css
:root {
  --hue: 262;  /* brand hue */
  --chroma-peak: 0.21;

  /* Low chroma at extremes, peak chroma at mid-tones */
  --brand-50:  oklch(97% 0.03 var(--hue));
  --brand-100: oklch(93% 0.06 var(--hue));
  --brand-200: oklch(85% 0.10 var(--hue));
  --brand-300: oklch(75% 0.15 var(--hue));
  --brand-400: oklch(65% 0.19 var(--hue));
  --brand-500: oklch(55% var(--chroma-peak) var(--hue));
  --brand-600: oklch(45% 0.19 var(--hue));
  --brand-700: oklch(35% 0.15 var(--hue));
  --brand-800: oklch(25% 0.10 var(--hue));
  --brand-900: oklch(15% 0.06 var(--hue));
  --brand-950: oklch(10% 0.03 var(--hue));
}
```

Steps feel evenly spaced by eye due to OKLCH perceptual uniformity. Change `--hue` to generate any color family.

---

## Spacing Scale

Use the 8pt grid with consistent token names:

```css
:root {
  --space-0:  0;
  --space-px: 1px;
  --space-0.5: 0.125rem;  /* 2px */
  --space-1:  0.25rem;    /* 4px */
  --space-2:  0.5rem;     /* 8px */
  --space-3:  0.75rem;    /* 12px */
  --space-4:  1rem;       /* 16px */
  --space-5:  1.25rem;    /* 20px */
  --space-6:  1.5rem;     /* 24px */
  --space-8:  2rem;       /* 32px */
  --space-10: 2.5rem;     /* 40px */
  --space-12: 3rem;       /* 48px */
  --space-16: 4rem;       /* 64px */
  --space-20: 5rem;       /* 80px */
  --space-24: 6rem;       /* 96px */
}
```

---

## Border Radius Scale

```css
:root {
  --radius-none: 0;
  --radius-sm:   0.125rem;  /* 2px */
  --radius-md:   0.375rem;  /* 6px */
  --radius-lg:   0.5rem;    /* 8px */
  --radius-xl:   0.75rem;   /* 12px */
  --radius-2xl:  1rem;      /* 16px */
  --radius-3xl:  1.5rem;    /* 24px */
  --radius-full: 9999px;
}
```

---

## Elevation / Shadow Scale

```css
:root {
  --shadow-color: 220deg 3% 15%;

  --shadow-xs: 0 1px 2px hsl(var(--shadow-color) / 0.15);
  --shadow-sm:
    0 1px 2px hsl(var(--shadow-color) / 0.1),
    0 2px 4px hsl(var(--shadow-color) / 0.1);
  --shadow-md:
    0 2px 4px hsl(var(--shadow-color) / 0.07),
    0 4px 8px hsl(var(--shadow-color) / 0.07),
    0 8px 16px hsl(var(--shadow-color) / 0.07);
  --shadow-lg:
    0 2px 4px hsl(var(--shadow-color) / 0.05),
    0 4px 8px hsl(var(--shadow-color) / 0.05),
    0 8px 16px hsl(var(--shadow-color) / 0.05),
    0 16px 32px hsl(var(--shadow-color) / 0.05);
  --shadow-xl:
    0 4px 8px hsl(var(--shadow-color) / 0.04),
    0 8px 16px hsl(var(--shadow-color) / 0.04),
    0 16px 32px hsl(var(--shadow-color) / 0.04),
    0 32px 64px hsl(var(--shadow-color) / 0.04);
}
```

Match `--shadow-color` hue to the background for natural appearance.

---

## Component States

Every interactive component should handle these states:

| State | Indicators |
|---|---|
| Default | base styling |
| Hover | subtle bg change, cursor: pointer |
| Focus | visible outline (2px+, 3:1 contrast) |
| Active/Pressed | scale(0.97), darker bg |
| Disabled | opacity: 0.5, cursor: not-allowed, pointer-events: none |
| Loading | spinner or skeleton, aria-busy="true" |
| Error | red border, error message, aria-invalid="true" |
| Success | green indicator, success message |

```css
.button {
  background: var(--button-bg);
  color: var(--button-text);
  transition: background 0.15s, transform 0.1s;
}
.button:hover:not(:disabled) {
  background: var(--button-bg-hover);
}
.button:active:not(:disabled) {
  transform: scale(0.97);
}
.button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}
.button[aria-busy="true"] {
  position: relative;
  color: transparent;
}
.button[aria-busy="true"]::after {
  content: '';
  position: absolute;
  inset: 0;
  margin: auto;
  width: 1.25em;
  height: 1.25em;
  border: 2px solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}
```

---

## Icon System

### Inline SVG with currentColor

```css
.icon {
  display: inline-block;
  width: 1em;
  height: 1em;
  vertical-align: middle;
  fill: currentColor;
}
```

Icons scale with font-size and inherit text color.

### SVG Sprite

```html
<svg style="display: none;">
  <defs>
    <symbol id="icon-search" viewBox="0 0 24 24">
      <path fill="currentColor" d="..." />
    </symbol>
  </defs>
</svg>

<svg class="icon" aria-hidden="true"><use href="#icon-search" /></svg>
```

---

## Multi-Theme Architecture

```css
:root {
  color-scheme: light dark;
}

/* Light (default) */
:root, [data-theme="light"] {
  --surface: oklch(98% 0.005 var(--brand-hue));
  --on-surface: oklch(15% 0.01 var(--brand-hue));
  --primary: oklch(50% 0.2 var(--brand-hue));
}

/* Dark */
[data-theme="dark"] {
  --surface: oklch(12% 0.01 var(--brand-hue));
  --on-surface: oklch(92% 0.01 var(--brand-hue));
  --primary: oklch(72% 0.16 var(--brand-hue));
}

/* Brand variant */
[data-theme="brand"] {
  --surface: oklch(25% 0.08 var(--brand-hue));
  --on-surface: oklch(95% 0.02 var(--brand-hue));
  --primary: oklch(80% 0.2 var(--brand-hue));
}
```

---

## Tailwind CSS Integration

### Design Tokens via @theme (Tailwind v4)

```css
@theme {
  --color-brand: oklch(62% 0.21 262);
  --color-surface: oklch(98% 0 0);
  --radius-card: 0.75rem;
  --font-size-display: clamp(2.5rem, 5vw + 1rem, 4.5rem);
}
```

### Style Dictionary Pipeline

```javascript
// style-dictionary.config.js
module.exports = {
  source: ['tokens/**/*.json'],
  platforms: {
    web: {
      transformGroup: 'web',
      buildPath: 'build/',
      files: [{
        destination: 'tokens.css',
        format: 'css/variables'
      }]
    }
  }
};
```

```json
// tokens/color.json
{
  "color": {
    "primary": { "value": "oklch(55% 0.20 250)", "type": "color" },
    "surface": { "value": "oklch(98% 0 0)", "type": "color" }
  }
}
```

One token source feeds web (CSS variables), mobile (platform formats), and documentation.
