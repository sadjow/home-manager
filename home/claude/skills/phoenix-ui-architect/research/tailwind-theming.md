# Tailwind CSS Theming & Design Tokens for Phoenix

## 1. Tailwind v4 CSS-First Configuration (Phoenix 1.8+)

Phoenix 1.8 ships with Tailwind v4, which moves configuration from `tailwind.config.js` into CSS. The default generated `app.css` looks like:

```css
@import "tailwindcss" source(none);
@source "../css";
@source "../js";
@source "../../lib/my_app_web";

@plugin "../vendor/heroicons";

@plugin "../vendor/daisyui" {
  themes: false;
}

@plugin "../vendor/daisyui-theme" {
  name: "dark";
  default: false;
  prefersdark: true;
  color-scheme: "dark";
  --color-base-100: oklch(30.33% 0.016 252.42);
  --color-primary: oklch(58% 0.233 277.117);
  /* ... more color tokens ... */
  --radius-box: 0.5rem;
  --border: 1.5px;
  --depth: 1;
}

@plugin "../vendor/daisyui-theme" {
  name: "light";
  default: true;
  prefersdark: false;
  color-scheme: "light";
  --color-base-100: oklch(98% 0 0);
  --color-primary: oklch(70% 0.213 47.604);
  /* ... more color tokens ... */
}

@custom-variant phx-click-loading (.phx-click-loading&, .phx-click-loading &);
@custom-variant phx-submit-loading (.phx-submit-loading&, .phx-submit-loading &);
@custom-variant phx-change-loading (.phx-change-loading&, .phx-change-loading &);

@custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));

[data-phx-session], [data-phx-teleported-src] { display: contents }
```

### Key Directives

- **`@import "tailwindcss" source(none)`** - Import Tailwind without auto-detecting sources
- **`@source`** - Explicitly declare which directories to scan for utility classes
- **`@plugin`** - Load Tailwind plugins (replaces `plugins` array in config.js)
- **`@custom-variant`** - Define custom variants (replaces JavaScript plugin `addVariant` calls)
- **`@theme`** - Define design tokens that generate utility classes

## 2. The @theme Directive - Design Tokens

The `@theme` directive is Tailwind v4's primary mechanism for design tokens. Theme variables are CSS custom properties that generate utility classes.

### Extending the Default Theme

```css
@import "tailwindcss";

@theme {
  --font-display: "Cal Sans", sans-serif;
  --color-brand-500: oklch(0.72 0.11 178);
  --color-brand-600: oklch(0.62 0.12 178);
  --radius-pill: 9999px;
}
```

This generates utilities like `font-display`, `bg-brand-500`, `text-brand-600`, `rounded-pill`.

### Replacing a Namespace Entirely

```css
@theme {
  --color-*: initial;        /* Remove all default colors */
  --color-white: #fff;
  --color-black: #000;
  --color-brand: oklch(0.70 0.213 47.604);
  --color-brand-light: oklch(0.85 0.15 47.604);
  --color-brand-dark: oklch(0.55 0.213 47.604);
  --color-surface: oklch(0.98 0 0);
  --color-surface-dark: oklch(0.25 0.014 253);
  --color-text: oklch(0.21 0.006 285);
  --color-text-muted: oklch(0.55 0.027 264);
}
```

### Full Custom Theme (No Defaults)

```css
@theme {
  --*: initial;              /* Remove ALL defaults */
  --spacing: 4px;            /* Base spacing unit */
  --font-body: Inter, sans-serif;
  --font-heading: "Cal Sans", sans-serif;
  --color-primary: oklch(0.70 0.213 47.604);
  --color-secondary: oklch(0.55 0.027 264);
  --color-surface: oklch(0.98 0 0);
}
```

### Theme Variable Namespaces

| Namespace | Utilities Generated |
|---|---|
| `--color-*` | `bg-*`, `text-*`, `border-*`, `fill-*`, `stroke-*` |
| `--font-*` | `font-*` (font families) |
| `--text-*` | `text-*` (font sizes) |
| `--font-weight-*` | `font-*` (font weights) |
| `--tracking-*` | `tracking-*` (letter spacing) |
| `--leading-*` | `leading-*` (line height) |
| `--spacing-*` | `p-*`, `m-*`, `gap-*`, `w-*`, `h-*` |
| `--radius-*` | `rounded-*` |
| `--shadow-*` | `shadow-*` |
| `--breakpoint-*` | `sm:`, `md:`, `lg:` (responsive variants) |
| `--ease-*` | `ease-*` (transition timing) |
| `--animate-*` | `animate-*` (animations) |

### Animations in @theme

```css
@theme {
  --animate-fade-in: fade-in 0.3s ease-out;
  --animate-slide-up: slide-up 0.2s ease-out;

  @keyframes fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  @keyframes slide-up {
    from { opacity: 0; transform: translateY(0.5rem); }
    to { opacity: 1; transform: translateY(0); }
  }
}
```

### Referencing Other Variables with `inline`

```css
@theme inline {
  --font-sans: var(--font-inter);
  --color-primary: var(--color-brand-500);
}
```

Use `inline` when a theme variable references another variable, so resolution happens at the usage site.

## 3. Dark Mode & Multi-Theme Strategy

### Phoenix 1.8 Approach (daisyUI)

Phoenix 1.8 uses `data-theme` attribute on the HTML element with daisyUI themes:

```css
@custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));
```

Themes are defined via `@plugin "../vendor/daisyui-theme"` blocks with semantic color tokens (`--color-base-*`, `--color-primary`, `--color-secondary`, etc.).

### CSS Custom Properties Approach (Without daisyUI)

```css
:root {
  --brand-primary: oklch(0.70 0.213 47.604);
  --brand-surface: oklch(0.98 0 0);
  --brand-text: oklch(0.21 0.006 285);
  --brand-text-muted: oklch(0.55 0.027 264);
  --brand-border: oklch(0.92 0.004 286);
}

.dark, [data-theme="dark"] {
  --brand-primary: oklch(0.58 0.233 277);
  --brand-surface: oklch(0.25 0.014 253);
  --brand-text: oklch(0.98 0.029 256);
  --brand-text-muted: oklch(0.70 0.02 256);
  --brand-border: oklch(0.37 0.044 257);
}
```

Then use with `@theme`:

```css
@theme {
  --color-primary: var(--brand-primary);
  --color-surface: var(--brand-surface);
  --color-on-surface: var(--brand-text);
  --color-muted: var(--brand-text-muted);
}
```

### JavaScript Theme Toggle for LiveView

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

## 4. Phoenix-Specific Custom Variants

### LiveView Loading States

```css
@custom-variant phx-click-loading (.phx-click-loading&, .phx-click-loading &);
@custom-variant phx-submit-loading (.phx-submit-loading&, .phx-submit-loading &);
@custom-variant phx-change-loading (.phx-change-loading&, .phx-change-loading &);
```

Usage in templates:

```heex
<button phx-click="save" class="btn btn-primary phx-click-loading:animate-pulse">
  Save
</button>

<form phx-submit="create" class="phx-submit-loading:opacity-50 phx-submit-loading:pointer-events-none">
  <!-- form fields -->
</form>
```

### LiveView Wrapper Transparency

```css
[data-phx-session], [data-phx-teleported-src] { display: contents }
```

This makes LiveView's wrapper divs invisible to CSS layout.

## 5. Semantic Color Naming Strategy

### Recommended: Semantic Names Over Literal Colors

```css
@theme {
  /* Semantic surface colors */
  --color-surface: oklch(0.98 0 0);
  --color-surface-alt: oklch(0.96 0.001 286);
  --color-surface-raised: oklch(1 0 0);

  /* Semantic text colors */
  --color-on-surface: oklch(0.21 0.006 285);
  --color-on-surface-muted: oklch(0.55 0.027 264);

  /* Semantic action colors */
  --color-primary: oklch(0.70 0.213 47.604);
  --color-on-primary: oklch(0.98 0.016 73.684);

  /* Semantic feedback colors */
  --color-success: oklch(0.70 0.14 182);
  --color-warning: oklch(0.66 0.179 58);
  --color-error: oklch(0.58 0.253 17);
  --color-info: oklch(0.62 0.214 259);

  /* Semantic border colors */
  --color-border: oklch(0.92 0.004 286);
  --color-border-focus: oklch(0.70 0.213 47.604);
}
```

This allows theme switching without changing any component markup.

## 6. Typography Scale

```css
@theme {
  --font-sans: "Inter", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
  --font-display: "Cal Sans", sans-serif;

  --text-xs: 0.75rem;
  --text-xs--line-height: 1rem;
  --text-sm: 0.875rem;
  --text-sm--line-height: 1.25rem;
  --text-base: 1rem;
  --text-base--line-height: 1.5rem;
  --text-lg: 1.125rem;
  --text-lg--line-height: 1.75rem;
  --text-xl: 1.25rem;
  --text-xl--line-height: 1.75rem;
  --text-2xl: 1.5rem;
  --text-2xl--line-height: 2rem;
  --text-3xl: 1.875rem;
  --text-3xl--line-height: 2.25rem;
}
```

## 7. Spacing Scale

```css
@theme {
  --spacing: 0.25rem;  /* Base unit: 4px */
  /* Tailwind auto-generates: p-1 = 0.25rem, p-2 = 0.5rem, etc. */
}
```

Override specific spacing values if needed:

```css
@theme {
  --spacing-18: 4.5rem;
  --spacing-128: 32rem;
}
```

## 8. CSS Organization in Phoenix

### File Structure

```
assets/
  css/
    app.css           # Main entry point with @import, @theme, @plugin, @custom-variant
  js/
    app.js            # Main JS entry point
  vendor/
    heroicons/        # Heroicons plugin
    daisyui.js        # daisyUI plugin
    daisyui-theme.js  # daisyUI theme plugin
```

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
  --color-brand: oklch(0.70 0.213 47.604);
  --font-display: "Cal Sans", sans-serif;
  --animate-fade-in: fade-in 0.3s ease-out;

  @keyframes fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
  }
}

/* 5. Custom variants */
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
    h2 { font-size: var(--text-2xl); font-weight: var(--font-weight-semibold); }
  }
}
```

### Using Theme Variables in Custom CSS

```css
@layer components {
  .card-elevated {
    background: var(--color-surface-raised);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-box);
    box-shadow: var(--shadow-md);
  }
}
```

## 9. Sharing Theme Across Projects

Create a reusable theme file:

```css
/* packages/brand/theme.css */
@theme {
  --*: initial;
  --spacing: 4px;
  --font-body: Inter, sans-serif;
  --color-primary: oklch(0.70 0.213 47.604);
  --color-secondary: oklch(0.55 0.027 264);
}
```

Import in any project:

```css
@import "tailwindcss";
@import "../brand/theme.css";
```

## 10. Best Practices

1. **Use `@theme` for design tokens** - Define colors, fonts, spacing, radii in one place. These generate utility classes automatically.

2. **Use semantic color names** - `--color-primary`, `--color-surface`, `--color-on-surface` instead of `--color-blue-500`. This enables theme switching without markup changes.

3. **Prefer utility classes in templates** - Phoenix function components and HEEx templates are the "component layer." Use inline utilities there, not `@apply`.

4. **Use `@layer components` sparingly** - Only for truly cross-cutting styles like prose/typography blocks that can't be expressed as components.

5. **Keep app.css organized** - Follow the structure: imports, sources, plugins, theme, variants, layout fixes, then custom CSS.

6. **Use oklch for colors** - Phoenix 1.8 defaults to oklch color space, which provides perceptual uniformity and easier palette generation.

7. **Leverage daisyUI's semantic classes in Phoenix 1.8** - Use `btn`, `card`, `badge`, etc. for rapid prototyping, then customize through theme tokens.

8. **Define loading state feedback** - Always set up `phx-click-loading`, `phx-submit-loading`, `phx-change-loading` variants for proper LiveView UX.

## 11. Anti-Patterns to Avoid

1. **Using Tailwind's default color palette directly** - Always define semantic/brand colors. `bg-blue-500` scattered across templates makes theme changes painful.

2. **Overusing `@apply`** - In Phoenix, function components serve as the abstraction layer. Extract repeated styles into components, not `@apply` classes.

3. **Defining colors in multiple places** - Single source of truth: `@theme` block or daisyUI theme config. Never duplicate color values.

4. **Skipping custom variants for loading states** - Phoenix LiveView applies loading classes automatically; not styling them leaves users without feedback.

5. **Using `tailwind.config.js` with v4** - Tailwind v4 is CSS-first. Use `@theme`, `@plugin`, and `@custom-variant` instead of the JavaScript config.

6. **Neglecting dark mode from the start** - Use semantic color names and CSS custom properties from day one. Retrofitting dark mode is significantly harder.

7. **Putting domain styles in CSS** - Compose UI from pre-styled building blocks (components). Domain components should combine existing styled components, not introduce new CSS.

8. **Over-abstracting with excessive class extraction** - Three similar lines of utility classes in templates are better than a premature `.card-fancy` abstraction.

## Sources

- [Tailwind CSS Theme Variables Documentation](https://tailwindcss.com/docs/theme)
- [Install Tailwind CSS with Phoenix](https://tailwindcss.com/docs/installation/framework-guides/phoenix)
- [Phoenix 1.8.0 Release Blog](https://www.phoenixframework.org/blog/phoenix-1-8-released)
- [Phoenix LiveView Tailwind Variants (Fly.io)](https://fly.io/phoenix-files/phoenix-liveview-tailwind-variants/)
- [Tailwind CSS v4.0 Release Blog](https://tailwindcss.com/blog/tailwindcss-v4)
- [Tailwind CSS Best Practices 2025-2026 (FrontendTools)](https://www.frontendtools.tech/blog/tailwind-css-best-practices-design-system-patterns)
- [5 Tailwind CSS Anti-Patterns (Atomic Object)](https://spin.atomicobject.com/tailwind-css-anti-patterns/)
- [Tailwind CSS v4 @theme: Design Tokens Guide](https://medium.com/@sureshdotariya/tailwind-css-4-theme-the-future-of-design-tokens-at-2025-guide-48305a26af06)
- [Dynamic Theme Switching in Tailwind CSS (DEV)](https://dev.to/hexshift/dynamic-theme-switching-in-tailwind-css-without-rebuilding-stylesheets-1le5)
- [Phoenix Theme Light/Dark Mode (btihen)](https://btihen.dev/posts/elixir/phoenix_1_7_14_theme_light_dark/)
- [Typesafe Design Tokens in Tailwind 4 (DEV)](https://dev.to/wearethreebears/exploring-typesafe-design-tokens-in-tailwind-4-372d)
- [phoenixframework/tailwind GitHub](https://github.com/phoenixframework/tailwind)
- [daisyUI Install for Phoenix](https://daisyui.com/docs/install/phoenix/)
- [Phoenix Tailwind v4 Gist (frankdugan3)](https://gist.github.com/frankdugan3/8f46f6d6aeb7bfcb95c6b9fc041e0b2a)
- [Tailwind CSS Reusing Styles](https://tailwindcss.com/docs/reusing-styles)
- [Tailwind v4 Migration Guide](https://tailwindcss.com/docs/upgrade-guide)
