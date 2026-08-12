# Accessibility (WCAG 2.2 / ADA)

## WCAG 2.2 New Criteria (Level AA)

### 2.4.11 Focus Not Obscured (Minimum)
Focused elements must not be completely hidden by sticky headers/footers.

```css
html {
  scroll-padding-top: 120px;  /* height of sticky header */
  scroll-padding-bottom: 80px; /* height of sticky footer */
}
a:focus, button:focus, input:focus, select:focus, textarea:focus {
  scroll-margin-top: 140px;
}
```

### 2.5.7 Dragging Movements
Every drag-and-drop must have a single-pointer alternative (click/tap/keyboard).

### 2.5.8 Target Size (Minimum)
Interactive elements: minimum 24x24 CSS pixels. Prefer 44x44 for primary actions.

```css
button, a, input, select, textarea {
  min-height: 44px;
  min-width: 44px;
}
/* Inline links are exempt */
```

### 3.2.6 Consistent Help
Help mechanisms (chat, contact links) must appear in the same relative order across pages.

### 3.3.7 Redundant Entry
Never ask users to enter the same information twice. Use "same as shipping" patterns, autocomplete attributes, pre-filled fields.

### 3.3.8 Accessible Authentication
No cognitive tests without alternatives. Enable password managers with `autocomplete="current-password"`. Offer email/SMS verification.

---

## Focus Management

### Visible Focus Indicators

```css
:focus-visible {
  outline: 3px solid oklch(55% 0.25 262);
  outline-offset: 2px;
}
/* Remove outline for mouse clicks */
:focus:not(:focus-visible) {
  outline: none;
}
```

WCAG 2.4.13 (AAA): focus ring must be 2px+ thick, 3:1 contrast against adjacent colors.

### Skip Navigation

```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

```css
.skip-link {
  position: absolute;
  left: -9999px;
  top: 0;
  z-index: 9999;
  padding: var(--space-2) var(--space-4);
  background: var(--surface);
  color: var(--on-surface);
}
.skip-link:focus {
  left: var(--space-2);
}
```

### Focus Trap (for Modals)

When a dialog opens, trap focus inside it. When it closes, return focus to the trigger element. Use the native `<dialog>` element which handles this automatically.

---

## Semantic HTML & Landmarks

```html
<header>   <!-- role="banner" -->
<nav>      <!-- role="navigation" -->
<main>     <!-- role="main" -->
<aside>    <!-- role="complementary" -->
<footer>   <!-- role="contentinfo" -->
<section aria-labelledby="heading-id">  <!-- role="region" when labeled -->
<search>   <!-- role="search" -->
```

ARIA's first rule: use native HTML elements with built-in semantics before adding explicit roles.

---

## ARIA Patterns for Common Components

### Accordion

```html
<h3>
  <button aria-expanded="false" aria-controls="panel-1" id="header-1">
    Section Title
  </button>
</h3>
<div id="panel-1" role="region" aria-labelledby="header-1" hidden>
  Panel content
</div>
```

Keyboard: Enter/Space to toggle. Optional: Arrow keys between headers.

### Tab Panel

```html
<div role="tablist" aria-label="Features">
  <button role="tab" aria-selected="true" aria-controls="tab-1" id="tab-btn-1">Tab 1</button>
  <button role="tab" aria-selected="false" aria-controls="tab-2" id="tab-btn-2" tabindex="-1">Tab 2</button>
</div>
<div role="tabpanel" id="tab-1" aria-labelledby="tab-btn-1">Content 1</div>
<div role="tabpanel" id="tab-2" aria-labelledby="tab-btn-2" hidden>Content 2</div>
```

Keyboard: Arrow keys between tabs, Tab into panel content.

### Modal Dialog

```html
<dialog aria-labelledby="dialog-title" aria-describedby="dialog-desc">
  <h2 id="dialog-title">Confirm Action</h2>
  <p id="dialog-desc">Are you sure you want to proceed?</p>
  <button autofocus>Confirm</button>
  <button>Cancel</button>
</dialog>
```

Use `<dialog>.showModal()` for automatic focus trap and Escape key handling.

### Combobox / Autocomplete

```html
<label for="search">Search</label>
<input id="search" role="combobox"
  aria-expanded="false"
  aria-controls="results"
  aria-autocomplete="list"
  aria-activedescendant="">
<ul id="results" role="listbox" hidden>
  <li role="option" id="opt-1">Option 1</li>
</ul>
```

DOM focus stays on input. `aria-activedescendant` moves visual focus in listbox.
Keyboard: Arrow keys navigate options, Enter selects, Escape closes.

---

## Form Accessibility

```html
<form>
  <div>
    <label for="email">Email (required)</label>
    <input id="email" type="email" required
      aria-describedby="email-error"
      autocomplete="email">
    <p id="email-error" role="alert" hidden>Please enter a valid email.</p>
  </div>
</form>
```

- Always associate labels with inputs via `for`/`id`
- Use `aria-describedby` for error messages and help text
- Use `role="alert"` or `aria-live="assertive"` for dynamic error messages
- Add `autocomplete` attributes for common fields

### Required Fields

```css
[aria-invalid="true"] {
  border-color: oklch(55% 0.25 25);
  outline: 2px solid oklch(55% 0.25 25);
}
```

---

## Live Regions

```html
<!-- Polite: announced after current speech -->
<div aria-live="polite" aria-atomic="true">
  3 results found
</div>

<!-- Assertive: interrupts current speech -->
<div role="alert">
  Error: form submission failed
</div>

<!-- Status: polite by default -->
<div role="status">
  Loading...
</div>
```

---

## Accessible Images

```html
<!-- Informative image -->
<img src="chart.png" alt="Revenue grew 45% from Q1 to Q4 2025">

<!-- Decorative image -->
<img src="decoration.svg" alt="" role="presentation">

<!-- Complex image with long description -->
<figure>
  <img src="data-viz.png" alt="Sales by region (details below)">
  <figcaption>
    North: $2.4M, South: $1.8M, East: $3.1M, West: $2.7M
  </figcaption>
</figure>
```

---

## Accessible SVG

```html
<!-- Informative SVG -->
<svg role="img" aria-labelledby="svg-title svg-desc">
  <title id="svg-title">Warning</title>
  <desc id="svg-desc">Yellow triangle with exclamation mark</desc>
  <!-- paths -->
</svg>

<!-- Decorative SVG -->
<svg aria-hidden="true" focusable="false">
  <!-- paths -->
</svg>
```

---

## Motion & Vestibular

```css
@media (prefers-reduced-motion: reduce) {
  .parallax { transform: none; }
  .auto-scroll { scroll-behavior: auto; }
  .animated { animation: none; }
}
```

Avoid: auto-playing video, rapid flashing (>3 per second), large parallax effects.
