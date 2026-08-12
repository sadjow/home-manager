# Tailwind Theming & Design Tokens

## Tailwind v4 CSS-First Configuration

Phoenix 1.8+ uses Tailwind v4. Configuration moves from `tailwind.config.js` into CSS.

### app.css Organization Pattern

```css
/* 1. Tailwind import */
@import "tailwindcss" source(none);

/* 2. Source paths */
@source "../css";
@source "../js";
@source "../../lib/my_app_web";

/* 3. Plugins */
@plugin "../vendor/heroicons";

/* 4. Design tokens */
@theme {
  --font-sans: "Inter", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
  --font-display: "Cal Sans", sans-serif;

  --color-primary: oklch(0.70 0.213 47.604);
  --color-on-primary: oklch(0.98 0.016 73.684);
  --color-surface: oklch(0.98 0 0);
  --color-surface-alt: oklch(0.96 0.001 286);
  --color-surface-raised: oklch(1 0 0);
  --color-on-surface: oklch(0.21 0.006 285);
  --color-on-surface-muted: oklch(0.55 0.027 264);
  --color-border: oklch(0.92 0.004 286);
  --color-border-focus: oklch(0.70 0.213 47.604);
  --color-success: oklch(0.70 0.14 182);
  --color-warning: oklch(0.66 0.179 58);
  --color-error: oklch(0.58 0.253 17);
  --color-info: oklch(0.62 0.214 259);

  --animate-fade-in: fade-in 0.3s ease-out;
  --animate-slide-up: slide-up 0.2s ease-out;
  --animate-scale-in: scale-in 0.2s cubic-bezier(0.22, 1, 0.36, 1);

  @keyframes fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  @keyframes slide-up {
    from { opacity: 0; transform: translateY(0.5rem); }
    to { opacity: 1; transform: translateY(0); }
  }

  @keyframes scale-in {
    from { opacity: 0; transform: scale(0.95); }
    to { opacity: 1; transform: scale(1); }
  }
}

/* 5. Custom variants for LiveView */
@custom-variant phx-click-loading (.phx-click-loading&, .phx-click-loading &);
@custom-variant phx-submit-loading (.phx-submit-loading&, .phx-submit-loading &);
@custom-variant phx-change-loading (.phx-change-loading&, .phx-change-loading &);

/* 6. Layout fixes */
[data-phx-session], [data-phx-teleported-src] { display: contents }

/* 7. Component-level custom CSS (use sparingly) */
@layer components {
  .prose-content {
    p { font-size: var(--text-base); color: var(--color-on-surface); }
    h1 { font-size: var(--text-3xl); font-weight: var(--font-weight-bold); }
  }
}
```

## @theme Directive

Theme variables are CSS custom properties that automatically generate utility classes:

```css
@theme {
  --color-brand-500: oklch(0.72 0.11 178);
}
```

Generates: `bg-brand-500`, `text-brand-500`, `border-brand-500`, etc.

### Namespaces

| Namespace | Utilities Generated |
|---|---|
| `--color-*` | `bg-*`, `text-*`, `border-*`, `fill-*` |
| `--font-*` | `font-*` (families) |
| `--text-*` | `text-*` (sizes) |
| `--spacing-*` | `p-*`, `m-*`, `gap-*`, `w-*`, `h-*` |
| `--radius-*` | `rounded-*` |
| `--shadow-*` | `shadow-*` |
| `--animate-*` | `animate-*` |
| `--ease-*` | `ease-*` |
| `--breakpoint-*` | `sm:`, `md:`, `lg:` |

### Replacing Defaults

```css
@theme {
  --color-*: initial;        /* Remove all default colors */
  --color-primary: oklch(0.70 0.213 47.604);
  --color-surface: oklch(0.98 0 0);
}
```

### Referencing Other Variables

```css
@theme inline {
  --font-sans: var(--font-inter);
  --color-primary: var(--color-brand-500);
}
```

Use `inline` when a theme variable references another variable.

## Semantic Color Naming

Use semantic names, not literal colors. This enables theme switching without markup changes:

```css
@theme {
  /* Surfaces */
  --color-surface: oklch(0.98 0 0);
  --color-surface-alt: oklch(0.96 0.001 286);
  --color-surface-raised: oklch(1 0 0);

  /* Text on surfaces */
  --color-on-surface: oklch(0.21 0.006 285);
  --color-on-surface-muted: oklch(0.55 0.027 264);

  /* Actions */
  --color-primary: oklch(0.70 0.213 47.604);
  --color-on-primary: oklch(0.98 0.016 73.684);

  /* Feedback */
  --color-success: oklch(0.70 0.14 182);
  --color-warning: oklch(0.66 0.179 58);
  --color-error: oklch(0.58 0.253 17);

  /* Borders */
  --color-border: oklch(0.92 0.004 286);
  --color-border-focus: oklch(0.70 0.213 47.604);
}
```

## Dark Mode / Multi-Theme

### CSS Custom Properties Approach

```css
:root {
  --brand-primary: oklch(0.70 0.213 47.604);
  --brand-surface: oklch(0.98 0 0);
  --brand-text: oklch(0.21 0.006 285);
}

[data-theme="dark"] {
  --brand-primary: oklch(0.58 0.233 277);
  --brand-surface: oklch(0.25 0.014 253);
  --brand-text: oklch(0.98 0.029 256);
}
```

### Theme Toggle (JS)

```javascript
const applyTheme = (theme) => {
  document.documentElement.setAttribute("data-theme", theme);
  localStorage.setItem("theme", theme);
};

const savedTheme = localStorage.getItem("theme") ||
  (window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");
applyTheme(savedTheme);

window.addEventListener("phx:toggle-theme", () => {
  const current = document.documentElement.getAttribute("data-theme");
  applyTheme(current === "dark" ? "light" : "dark");
});
```

### Custom Dark Variant

```css
@custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));
```

## LiveView Loading State Variants

```heex
<button phx-click="save" class="btn bg-primary phx-click-loading:animate-pulse phx-click-loading:opacity-75">
  Save
</button>

<form phx-submit="create" class="phx-submit-loading:opacity-50 phx-submit-loading:pointer-events-none">
  ...
</form>
```

## Style Rules

1. **Use `@theme` for design tokens** — single source, generates utilities automatically
2. **Semantic color names** — `bg-primary` not `bg-blue-500`
3. **Utility classes in templates** — function components are the abstraction layer
4. **`@layer components` sparingly** — only for truly cross-cutting styles (prose blocks)
5. **oklch for colors** — perceptually uniform, easier palette generation
6. **Never `@apply` for component extraction** — use function components instead
7. **Never duplicate color values** — single source in `@theme`
8. **Define loading variants** — LiveView applies loading classes automatically; style them
