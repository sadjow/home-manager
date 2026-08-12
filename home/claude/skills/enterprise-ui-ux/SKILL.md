# Enterprise Information System UI/UX

Senior UI/UX engineer specializing in enterprise back-office information systems. Builds efficient, beautiful, accessible, and performant interfaces for daily-use corporate applications. Follows brand design guidelines while optimizing for power users, data density, and speed.

## When to Use

Use this skill when building or improving:
- Corporate back-office systems, admin panels, CRMs, ERPs
- Data-heavy interfaces (tables, grids, dashboards)
- Complex forms, multi-step workflows, approval processes
- Enterprise navigation, search, and notification patterns
- Any daily-use system where efficiency, brand consistency, and accessibility matter

## Core Philosophy

1. **Efficiency first** — minimize clicks, support keyboard shortcuts, respect power users
2. **Data density with clarity** — show more information without visual clutter
3. **Consistent and predictable** — same patterns everywhere, no surprises
4. **Accessible by default** — WCAG 2.2 AA, keyboard navigable, screen reader optimized
5. **Fast and responsive** — skeleton screens, optimistic updates, virtual scrolling
6. **Brand-aware** — CSS custom property theming for white-label and multi-brand support

## Quick Reference

| Area | Reference | Key Patterns |
|---|---|---|
| Data Tables | [references/data-tables.md](references/data-tables.md) | Sorting, filtering, pagination, inline editing, density modes, virtual scrolling, ARIA grid |
| Forms & Workflows | [references/forms-workflows.md](references/forms-workflows.md) | Layout, validation timing, multi-step wizards, approval flows, audit trails |
| Dashboards | [references/dashboards.md](references/dashboards.md) | KPI cards, chart accessibility, filters, drill-down, real-time data |
| Navigation & Search | [references/navigation-search-notifications.md](references/navigation-search-notifications.md) | Sidebar, command palette, notifications, breadcrumbs, keyboard shortcuts |
| Accessibility | [references/accessibility-enterprise-apps.md](references/accessibility-enterprise-apps.md) | WCAG 2.2, ARIA grids/trees, forced colors, APCA contrast, testing |
| Performance | [references/performance.md](references/performance.md) | Skeleton screens, optimistic UI, virtual scrolling, caching, Core Web Vitals |

## Enterprise UI Checklist

Before shipping any enterprise interface, verify:

- [ ] **Keyboard navigable** — all features accessible without mouse, logical tab order
- [ ] **Screen reader tested** — landmarks, headings hierarchy, live regions for dynamic content
- [ ] **Loading states** — skeleton screens for initial load, overlay for subsequent loads
- [ ] **Empty states** — clear messaging with recovery actions (first use + no results)
- [ ] **Error states** — inline errors with `aria-invalid`, form-level error summary, retry actions
- [ ] **Density modes** — compact/comfortable/spacious toggle for tables and lists
- [ ] **Responsive** — works on tablet (1024px), degrades gracefully on mobile
- [ ] **Brand tokens** — all colors, spacing, radii via CSS custom properties
- [ ] **Focus indicators** — 3px+ visible focus rings, 3:1 contrast (`:focus-visible`)
- [ ] **Status without color** — every status uses icon + text, never color alone
- [ ] **Reduced motion** — `prefers-reduced-motion` respected
- [ ] **High contrast** — `forced-colors` mode tested (Windows)
- [ ] **Performance** — LCP < 2.5s, INP < 200ms, CLS < 0.1

## Enterprise Layout Shell

```html
<body>
  <a href="#main" class="skip-link">Skip to main content</a>

  <div class="app-layout">
    <aside class="sidebar" role="navigation" aria-label="Main navigation">
      <div class="sidebar-header">
        <img src="/logo.svg" alt="Company" class="brand-logo" />
      </div>
      <nav><!-- sidebar navigation --></nav>
    </aside>

    <div class="app-body">
      <header class="top-bar" role="banner">
        <nav aria-label="Breadcrumb"><!-- breadcrumbs --></nav>
        <div class="top-bar-actions">
          <form role="search" aria-label="Global search">
            <input type="search" placeholder="Search... (Ctrl+K)" />
          </form>
          <button aria-label="Notifications" aria-haspopup="true">
            <!-- notification bell -->
          </button>
        </div>
      </header>

      <main id="main" tabindex="-1">
        <!-- Page content -->
      </main>
    </div>
  </div>
</body>
```

```css
:root {
  /* Brand tokens (override for white-label) */
  --brand-primary: #3b82f6;
  --brand-primary-hover: #2563eb;

  /* Surface tokens */
  --surface: #ffffff;
  --surface-secondary: #f9fafb;
  --border: #e5e7eb;
  --text: #1f2937;
  --text-secondary: #6b7280;

  /* Density tokens */
  --density-row-height: 48px;
  --density-cell-padding: 12px 16px;
  --density-font-size: 14px;

  /* Focus */
  --focus-ring: var(--brand-primary);
}

.app-layout {
  display: grid;
  grid-template-columns: var(--sidebar-width, 260px) 1fr;
  min-height: 100vh;
}

.app-body {
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

main {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
}

/* Focus indicators */
:focus-visible {
  outline: 3px solid var(--focus-ring);
  outline-offset: 2px;
}
:focus:not(:focus-visible) {
  outline: none;
}

/* Screen reader utility */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Skip link */
.skip-link {
  position: absolute;
  top: -100%;
  left: 0;
  z-index: 9999;
  padding: 12px 24px;
  background: var(--brand-primary);
  color: white;
}
.skip-link:focus { top: 0; }

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}

/* High contrast mode */
@media (forced-colors: active) {
  .status-badge { border: 1px solid ButtonText; }
  :focus-visible { outline-color: Highlight; }
}
```

## Status Badge Pattern

Every enterprise app needs consistent status indicators. Never rely on color alone:

```html
<span class="status-badge status-badge--active">
  <svg aria-hidden="true" class="status-icon"><use href="#icon-check-circle"/></svg>
  Active
</span>
```

```css
.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 2px 8px;
  border-radius: 9999px;
  font-size: 0.8125rem;
  font-weight: 600;
}

.status-badge--active  { background: #dcfce7; color: #166534; }
.status-badge--pending { background: #fef3c7; color: #92400e; }
.status-badge--error   { background: #fee2e2; color: #991b1b; }
.status-badge--draft   { background: #f3f4f6; color: #374151; }
```

## Common Patterns Quick Reference

### Skeleton Loading
```css
.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e8e8e8 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
}
@keyframes shimmer {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### Toast Notification
```html
<div role="status" aria-live="polite" class="toast">
  <span>3 items archived</span>
  <button aria-label="Undo: restore 3 items">Undo</button>
</div>
```

### Confirmation Dialog (Destructive Actions)
```html
<dialog aria-labelledby="dialog-title" aria-describedby="dialog-desc">
  <h2 id="dialog-title">Delete 47 records?</h2>
  <p id="dialog-desc">This action cannot be undone.</p>
  <button autofocus>Cancel</button>
  <button class="btn-danger">Delete 47 records</button>
</dialog>
```

## Tailwind CSS Integration

When using Tailwind, map enterprise tokens via `@theme`:

```css
@import "tailwindcss";

@theme {
  --color-brand: #3b82f6;
  --color-brand-hover: #2563eb;
  --color-surface: #ffffff;
  --color-surface-secondary: #f9fafb;
  --color-border: #e5e7eb;
  --color-text: #1f2937;
  --color-text-secondary: #6b7280;

  --spacing-density-compact: 6px 12px;
  --spacing-density-comfortable: 12px 16px;
  --spacing-density-spacious: 16px 20px;

  --radius-badge: 9999px;
  --radius-card: 12px;
  --radius-input: 8px;
  --radius-button: 8px;
}
```
