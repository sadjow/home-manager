# Enterprise Application UI/UX Patterns: Comprehensive Research (2024-2026)

Best practices for corporate back-office systems used daily by professionals. This document covers navigation, search, notifications, page structure, keyboard shortcuts, wayfinding, responsive design, and brand integration, with concrete HTML/CSS examples and accessibility guidance.

---

## Table of Contents

1. [Navigation Patterns](#1-navigation-patterns)
2. [Search Patterns](#2-search-patterns)
3. [Notification Patterns](#3-notification-patterns)
4. [Page Structure](#4-page-structure)
5. [Keyboard Shortcuts](#5-keyboard-shortcuts)
6. [Wayfinding](#6-wayfinding)
7. [Responsive Navigation](#7-responsive-navigation)
8. [Brand Integration](#8-brand-integration)
9. [Information Density](#9-information-density)
10. [Power User Patterns](#10-power-user-patterns)

---

## 1. Navigation Patterns

### 1.1 Sidebar Navigation (Collapsible, Nested)

The sidebar is the dominant navigation pattern for enterprise applications. It provides persistent access to primary sections while keeping the main content area maximized.

**Key principles:**
- Combine icons with text labels; icons alone cause confusion for infrequent users
- Group related items logically by workflow, not by system architecture
- Support collapsible sections (accordion) for deep hierarchies
- Keep the sidebar fixed/sticky so it is always accessible during scroll
- Highlight active states with color, background, or left border indicator
- Provide a collapse-to-icons mode for power users who want more screen real estate

**When to use nested navigation:**
- Applications with 3+ levels of hierarchy
- Role-based access where different users see different sections
- Complex domains (finance, HR, operations) with many sub-modules

```html
<nav class="sidebar" aria-label="Main navigation" role="navigation">
  <div class="sidebar-header">
    <img src="/logo.svg" alt="Company Name" class="sidebar-logo" />
    <button
      class="sidebar-toggle"
      aria-label="Collapse sidebar"
      aria-expanded="true"
      aria-controls="sidebar-nav"
    >
      <svg aria-hidden="true"><!-- chevron icon --></svg>
    </button>
  </div>

  <ul id="sidebar-nav" class="sidebar-nav" role="list">
    <!-- Top-level item without children -->
    <li class="nav-item">
      <a href="/dashboard" class="nav-link active" aria-current="page">
        <svg class="nav-icon" aria-hidden="true"><!-- dashboard icon --></svg>
        <span class="nav-label">Dashboard</span>
      </a>
    </li>

    <!-- Expandable section with nested items -->
    <li class="nav-item has-children">
      <button
        class="nav-link nav-toggle"
        aria-expanded="false"
        aria-controls="nav-orders"
      >
        <svg class="nav-icon" aria-hidden="true"><!-- orders icon --></svg>
        <span class="nav-label">Orders</span>
        <svg class="nav-chevron" aria-hidden="true"><!-- chevron --></svg>
      </button>
      <ul id="nav-orders" class="nav-submenu" role="list" hidden>
        <li><a href="/orders/pending" class="nav-link sub-link">Pending</a></li>
        <li><a href="/orders/fulfilled" class="nav-link sub-link">Fulfilled</a></li>
        <li><a href="/orders/returns" class="nav-link sub-link">Returns</a></li>
      </ul>
    </li>

    <!-- Section divider with label -->
    <li class="nav-section-label" role="separator" aria-label="Settings">
      <span class="nav-section-text">Settings</span>
    </li>

    <li class="nav-item">
      <a href="/settings/general" class="nav-link">
        <svg class="nav-icon" aria-hidden="true"><!-- gear icon --></svg>
        <span class="nav-label">General</span>
      </a>
    </li>
  </ul>

  <!-- Bottom section for user/profile -->
  <div class="sidebar-footer">
    <button class="user-menu-trigger" aria-haspopup="menu" aria-expanded="false">
      <img src="/avatar.jpg" alt="" class="user-avatar" />
      <span class="user-name">Jane Doe</span>
    </button>
  </div>
</nav>
```

```css
.sidebar {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: 260px;
  background: var(--sidebar-bg, #1a1d23);
  color: var(--sidebar-text, #b0b7c3);
  display: flex;
  flex-direction: column;
  transition: width 200ms ease;
  z-index: 100;
  overflow-y: auto;
  overflow-x: hidden;
}

.sidebar.collapsed {
  width: 64px;
}

.sidebar.collapsed .nav-label,
.sidebar.collapsed .nav-chevron,
.sidebar.collapsed .nav-section-text,
.sidebar.collapsed .user-name {
  display: none;
}

.sidebar.collapsed .nav-submenu {
  display: none;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 16px;
  color: inherit;
  text-decoration: none;
  border-radius: 6px;
  margin: 2px 8px;
  font-size: 14px;
  line-height: 20px;
  transition: background 150ms ease, color 150ms ease;
  border: none;
  background: none;
  width: calc(100% - 16px);
  cursor: pointer;
  text-align: left;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.08);
  color: #ffffff;
}

.nav-link.active,
.nav-link[aria-current="page"] {
  background: rgba(59, 130, 246, 0.15);
  color: #60a5fa;
  font-weight: 500;
}

.nav-link:focus-visible {
  outline: 2px solid #60a5fa;
  outline-offset: -2px;
}

.nav-icon {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}

.nav-submenu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sub-link {
  padding-left: 48px;
  font-size: 13px;
}

.nav-section-label {
  padding: 20px 16px 6px;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--sidebar-muted, #6b7280);
}

.nav-chevron {
  margin-left: auto;
  width: 16px;
  height: 16px;
  transition: transform 200ms ease;
}

.nav-toggle[aria-expanded="true"] .nav-chevron {
  transform: rotate(90deg);
}
```

### 1.2 Top Bar Navigation

Used for global actions, user context, search, and notifications that should be accessible from every page.

```html
<header class="top-bar" role="banner">
  <div class="top-bar-left">
    <!-- Breadcrumbs or page title go here -->
    <nav aria-label="Breadcrumb" class="breadcrumb-nav">
      <ol class="breadcrumb-list">
        <li><a href="/orders" class="breadcrumb-link">Orders</a></li>
        <li aria-hidden="true" class="breadcrumb-separator">/</li>
        <li><a href="/orders/pending" class="breadcrumb-link" aria-current="page">Pending</a></li>
      </ol>
    </nav>
  </div>

  <div class="top-bar-center">
    <button
      class="global-search-trigger"
      aria-label="Search (Cmd+K)"
      aria-keyshortcuts="Meta+K"
    >
      <svg aria-hidden="true"><!-- search icon --></svg>
      <span class="search-placeholder">Search...</span>
      <kbd class="search-shortcut">&#8984;K</kbd>
    </button>
  </div>

  <div class="top-bar-right">
    <button
      class="notification-trigger"
      aria-label="Notifications, 3 unread"
      aria-haspopup="dialog"
    >
      <svg aria-hidden="true"><!-- bell icon --></svg>
      <span class="badge" aria-hidden="true">3</span>
    </button>

    <button class="user-menu-trigger" aria-haspopup="menu" aria-expanded="false">
      <img src="/avatar.jpg" alt="" class="avatar" />
      <span class="user-display-name">Jane Doe</span>
      <svg aria-hidden="true"><!-- chevron-down --></svg>
    </button>
  </div>
</header>
```

```css
.top-bar {
  position: fixed;
  top: 0;
  left: 260px; /* offset for sidebar */
  right: 0;
  height: 56px;
  background: var(--surface, #ffffff);
  border-bottom: 1px solid var(--border, #e5e7eb);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  z-index: 90;
}

.sidebar.collapsed ~ .top-bar {
  left: 64px;
}

.global-search-trigger {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background: var(--input-bg, #f3f4f6);
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 8px;
  cursor: pointer;
  min-width: 320px;
  color: var(--text-muted, #9ca3af);
  font-size: 14px;
  transition: border-color 150ms ease, box-shadow 150ms ease;
}

.global-search-trigger:hover {
  border-color: var(--border-hover, #d1d5db);
}

.global-search-trigger:focus-visible {
  outline: 2px solid var(--focus-ring, #3b82f6);
  outline-offset: 2px;
}

.search-shortcut {
  margin-left: auto;
  font-size: 12px;
  padding: 2px 6px;
  background: var(--kbd-bg, #e5e7eb);
  border-radius: 4px;
  font-family: inherit;
  border: none;
}

.badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  background: var(--danger, #ef4444);
  color: #ffffff;
  border-radius: 9px;
  font-size: 11px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
}
```

### 1.3 Tab-Based Navigation

Used for switching between related views within a single page or module.

```html
<div class="tabs" role="tablist" aria-label="Order views">
  <button
    role="tab"
    id="tab-all"
    aria-selected="true"
    aria-controls="panel-all"
    class="tab active"
  >
    All Orders
    <span class="tab-count">1,248</span>
  </button>
  <button
    role="tab"
    id="tab-pending"
    aria-selected="false"
    aria-controls="panel-pending"
    class="tab"
    tabindex="-1"
  >
    Pending
    <span class="tab-count">42</span>
  </button>
  <button
    role="tab"
    id="tab-fulfilled"
    aria-selected="false"
    aria-controls="panel-fulfilled"
    class="tab"
    tabindex="-1"
  >
    Fulfilled
    <span class="tab-count">1,106</span>
  </button>
</div>

<div role="tabpanel" id="panel-all" aria-labelledby="tab-all" tabindex="0">
  <!-- Tab content -->
</div>
<div role="tabpanel" id="panel-pending" aria-labelledby="tab-pending" tabindex="0" hidden>
  <!-- Tab content -->
</div>
```

```css
.tabs {
  display: flex;
  gap: 0;
  border-bottom: 1px solid var(--border, #e5e7eb);
  margin-bottom: 24px;
}

.tab {
  padding: 12px 16px;
  font-size: 14px;
  font-weight: 500;
  color: var(--text-muted, #6b7280);
  background: none;
  border: none;
  border-bottom: 2px solid transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: color 150ms ease, border-color 150ms ease;
  white-space: nowrap;
}

.tab:hover {
  color: var(--text, #111827);
}

.tab.active,
.tab[aria-selected="true"] {
  color: var(--primary, #3b82f6);
  border-bottom-color: var(--primary, #3b82f6);
}

.tab:focus-visible {
  outline: 2px solid var(--focus-ring, #3b82f6);
  outline-offset: -2px;
}

.tab-count {
  font-size: 12px;
  padding: 1px 8px;
  background: var(--badge-bg, #f3f4f6);
  border-radius: 10px;
  font-weight: 400;
}

.tab.active .tab-count {
  background: rgba(59, 130, 246, 0.1);
  color: var(--primary, #3b82f6);
}
```

**Keyboard behavior for tabs (required for accessibility):**
- Arrow Left/Right moves focus between tabs
- Home/End jumps to first/last tab
- Space or Enter activates the focused tab
- Tab key moves focus out of the tablist to the active panel

### 1.4 Mega Menu for Complex Applications

For applications with deeply nested feature sets (ERP, CRM), a mega menu provides a two-dimensional panel showing all options at once.

```html
<div class="mega-menu" role="menu" aria-label="Modules">
  <div class="mega-menu-column">
    <h3 class="mega-menu-heading" id="mm-finance">Finance</h3>
    <ul role="group" aria-labelledby="mm-finance">
      <li><a href="/finance/accounts" role="menuitem">Accounts</a></li>
      <li><a href="/finance/invoices" role="menuitem">Invoices</a></li>
      <li><a href="/finance/reports" role="menuitem">Reports</a></li>
      <li><a href="/finance/budgets" role="menuitem">Budgets</a></li>
    </ul>
  </div>
  <div class="mega-menu-column">
    <h3 class="mega-menu-heading" id="mm-hr">Human Resources</h3>
    <ul role="group" aria-labelledby="mm-hr">
      <li><a href="/hr/employees" role="menuitem">Employees</a></li>
      <li><a href="/hr/payroll" role="menuitem">Payroll</a></li>
      <li><a href="/hr/leave" role="menuitem">Leave Management</a></li>
      <li><a href="/hr/recruitment" role="menuitem">Recruitment</a></li>
    </ul>
  </div>
  <div class="mega-menu-column">
    <h3 class="mega-menu-heading" id="mm-ops">Operations</h3>
    <ul role="group" aria-labelledby="mm-ops">
      <li><a href="/ops/inventory" role="menuitem">Inventory</a></li>
      <li><a href="/ops/warehouse" role="menuitem">Warehouse</a></li>
      <li><a href="/ops/shipping" role="menuitem">Shipping</a></li>
      <li><a href="/ops/procurement" role="menuitem">Procurement</a></li>
    </ul>
  </div>
</div>
```

```css
.mega-menu {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: var(--surface, #ffffff);
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 12px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
  padding: 24px 32px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 32px;
  z-index: 200;
}

.mega-menu-heading {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--text-muted, #6b7280);
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--border, #e5e7eb);
}

.mega-menu ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.mega-menu a {
  display: block;
  padding: 8px 12px;
  border-radius: 6px;
  color: var(--text, #374151);
  text-decoration: none;
  font-size: 14px;
  transition: background 150ms ease;
}

.mega-menu a:hover {
  background: var(--hover-bg, #f3f4f6);
}

.mega-menu a:focus-visible {
  outline: 2px solid var(--focus-ring, #3b82f6);
  outline-offset: -2px;
}
```

---

## 2. Search Patterns

### 2.1 Global Search / Command Palette (Cmd+K)

The command palette is now an expected feature in high-quality enterprise software. Products like Linear, Vercel, Notion, Figma, GitHub, and Slack have made this pattern standard. It serves dual purposes: finding content and executing actions.

**Key principles:**
- Activated via Cmd+K (Mac) / Ctrl+K (Windows) or a visible search trigger in the top bar
- Opens as a centered modal overlay with a prominent text input
- Results appear instantly as the user types (debounced at ~150ms)
- Results are grouped by category (Pages, Actions, People, Recent)
- Keyboard navigation: Arrow Up/Down to move, Enter to select, Escape to close
- Show recent searches when the palette opens empty
- Support action prefixes (e.g., `>` for commands, `@` for people, `#` for tags)

```html
<!-- Trigger button in top bar -->
<button
  class="search-trigger"
  aria-label="Open command palette (Cmd+K)"
  aria-keyshortcuts="Meta+K"
  aria-haspopup="dialog"
>
  <svg aria-hidden="true"><!-- search icon --></svg>
  <span>Search or jump to...</span>
  <kbd aria-hidden="true">&#8984;K</kbd>
</button>

<!-- Command palette dialog -->
<div
  class="command-palette-overlay"
  role="presentation"
  hidden
>
  <dialog
    class="command-palette"
    role="dialog"
    aria-label="Command palette"
    aria-modal="true"
  >
    <div class="cp-input-wrapper">
      <svg class="cp-search-icon" aria-hidden="true"><!-- search icon --></svg>
      <input
        type="text"
        class="cp-input"
        placeholder="Type a command or search..."
        aria-label="Search commands and content"
        aria-controls="cp-results"
        aria-activedescendant=""
        aria-expanded="true"
        role="combobox"
        aria-autocomplete="list"
        autocomplete="off"
        spellcheck="false"
      />
      <kbd class="cp-escape" aria-hidden="true">ESC</kbd>
    </div>

    <div class="cp-results-container">
      <!-- Recent searches (shown when input is empty) -->
      <div class="cp-group" role="group" aria-label="Recent searches">
        <h3 class="cp-group-label">Recent</h3>
        <ul id="cp-results" role="listbox">
          <li
            role="option"
            id="cp-result-0"
            class="cp-result"
            aria-selected="false"
          >
            <svg class="cp-result-icon" aria-hidden="true"><!-- clock icon --></svg>
            <span class="cp-result-text">Order #1234</span>
            <span class="cp-result-meta">Viewed 2 hours ago</span>
          </li>
        </ul>
      </div>

      <!-- Categorized results (shown when typing) -->
      <div class="cp-group" role="group" aria-label="Pages">
        <h3 class="cp-group-label">Pages</h3>
        <ul role="listbox">
          <li
            role="option"
            id="cp-result-1"
            class="cp-result active"
            aria-selected="true"
          >
            <svg class="cp-result-icon" aria-hidden="true"><!-- page icon --></svg>
            <div class="cp-result-content">
              <span class="cp-result-text">Order Management</span>
              <span class="cp-result-path">Operations &rarr; Orders</span>
            </div>
            <kbd class="cp-result-shortcut" aria-hidden="true">&#8629;</kbd>
          </li>
        </ul>
      </div>

      <div class="cp-group" role="group" aria-label="Actions">
        <h3 class="cp-group-label">Actions</h3>
        <ul role="listbox">
          <li role="option" id="cp-result-2" class="cp-result" aria-selected="false">
            <svg class="cp-result-icon" aria-hidden="true"><!-- plus icon --></svg>
            <span class="cp-result-text">Create new order</span>
            <kbd class="cp-result-shortcut" aria-hidden="true">&#8984;N</kbd>
          </li>
        </ul>
      </div>
    </div>

    <footer class="cp-footer">
      <span class="cp-hint"><kbd>&uarr;</kbd><kbd>&darr;</kbd> navigate</span>
      <span class="cp-hint"><kbd>&#8629;</kbd> select</span>
      <span class="cp-hint"><kbd>esc</kbd> close</span>
    </footer>
  </dialog>
</div>
```

```css
.command-palette-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 15vh;
  z-index: 1000;
}

.command-palette {
  width: 100%;
  max-width: 640px;
  background: var(--surface, #ffffff);
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 12px;
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.2);
  overflow: hidden;
  padding: 0;
  color: var(--text, #1f2937);
}

.cp-input-wrapper {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid var(--border, #e5e7eb);
  gap: 12px;
}

.cp-search-icon {
  width: 20px;
  height: 20px;
  color: var(--text-muted, #9ca3af);
  flex-shrink: 0;
}

.cp-input {
  flex: 1;
  border: none;
  background: none;
  font-size: 16px;
  line-height: 24px;
  color: inherit;
  outline: none;
}

.cp-input::placeholder {
  color: var(--text-muted, #9ca3af);
}

.cp-escape {
  font-size: 11px;
  padding: 2px 6px;
  background: var(--kbd-bg, #f3f4f6);
  border-radius: 4px;
  color: var(--text-muted, #6b7280);
}

.cp-results-container {
  max-height: 400px;
  overflow-y: auto;
  padding: 8px;
}

.cp-group-label {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted, #6b7280);
  padding: 8px 12px 4px;
}

.cp-result {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 100ms ease;
}

.cp-result:hover,
.cp-result.active,
.cp-result[aria-selected="true"] {
  background: var(--hover-bg, #f3f4f6);
}

.cp-result-icon {
  width: 18px;
  height: 18px;
  color: var(--text-muted, #9ca3af);
  flex-shrink: 0;
}

.cp-result-content {
  flex: 1;
  min-width: 0;
}

.cp-result-text {
  font-size: 14px;
  font-weight: 500;
  color: var(--text, #1f2937);
}

.cp-result-path {
  font-size: 12px;
  color: var(--text-muted, #6b7280);
  display: block;
}

.cp-result-meta {
  font-size: 12px;
  color: var(--text-muted, #9ca3af);
  margin-left: auto;
}

.cp-result-shortcut {
  font-size: 11px;
  padding: 2px 6px;
  background: var(--kbd-bg, #f3f4f6);
  border-radius: 4px;
  color: var(--text-muted, #6b7280);
  margin-left: auto;
}

.cp-footer {
  display: flex;
  gap: 16px;
  padding: 8px 16px;
  border-top: 1px solid var(--border, #e5e7eb);
  background: var(--surface-subtle, #f9fafb);
  font-size: 12px;
  color: var(--text-muted, #6b7280);
}

.cp-hint kbd {
  display: inline-block;
  padding: 1px 5px;
  background: var(--kbd-bg, #e5e7eb);
  border-radius: 3px;
  font-size: 11px;
  margin-right: 4px;
}
```

### 2.2 Search with Filters

Enterprise applications require advanced filtering for precise results across large datasets.

**Key principles:**
- Show applied filters as dismissible chips/tags above results
- Provide a filter sidebar or dropdown panel with categorized options
- Support both AND and OR logic for multi-select filters
- Dynamically update result counts as filters are applied
- Persist filter state in the URL for shareability and back-button support
- Show "Clear all filters" when any filters are active
- Highlight which filters are currently active

```html
<div class="search-filters-bar">
  <div class="search-input-group">
    <svg class="search-icon" aria-hidden="true"><!-- search icon --></svg>
    <input
      type="search"
      class="search-input"
      placeholder="Search orders..."
      aria-label="Search orders"
      role="searchbox"
    />
  </div>

  <!-- Filter triggers -->
  <div class="filter-group" role="group" aria-label="Filters">
    <button
      class="filter-trigger has-value"
      aria-haspopup="listbox"
      aria-expanded="false"
    >
      Status: <strong>Pending</strong>
      <svg aria-hidden="true"><!-- chevron-down --></svg>
    </button>

    <button class="filter-trigger" aria-haspopup="listbox" aria-expanded="false">
      Date range
      <svg aria-hidden="true"><!-- chevron-down --></svg>
    </button>

    <button class="filter-trigger" aria-haspopup="listbox" aria-expanded="false">
      Assigned to
      <svg aria-hidden="true"><!-- chevron-down --></svg>
    </button>

    <button class="filter-more" aria-haspopup="menu">
      <svg aria-hidden="true"><!-- plus icon --></svg>
      More filters
    </button>
  </div>

  <!-- Applied filters as chips -->
  <div class="applied-filters" role="group" aria-label="Applied filters">
    <span class="filter-chip">
      Status: Pending
      <button aria-label="Remove Status: Pending filter" class="chip-remove">
        <svg aria-hidden="true"><!-- x icon --></svg>
      </button>
    </span>
    <button class="clear-all-filters">Clear all</button>
  </div>

  <!-- Result count -->
  <div class="search-results-meta" aria-live="polite">
    <span>Showing <strong>42</strong> of 1,248 orders</span>
  </div>
</div>
```

```css
.search-filters-bar {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px 0;
}

.search-input-group {
  display: flex;
  align-items: center;
  gap: 8px;
  background: var(--input-bg, #ffffff);
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 8px;
  padding: 8px 12px;
  max-width: 400px;
}

.search-input-group:focus-within {
  border-color: var(--primary, #3b82f6);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

.search-input {
  border: none;
  background: none;
  outline: none;
  font-size: 14px;
  flex: 1;
  color: var(--text, #1f2937);
}

.filter-group {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.filter-trigger {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  background: var(--surface, #ffffff);
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 6px;
  font-size: 13px;
  color: var(--text-muted, #6b7280);
  cursor: pointer;
  transition: border-color 150ms ease;
}

.filter-trigger:hover {
  border-color: var(--border-hover, #d1d5db);
}

.filter-trigger.has-value {
  border-color: var(--primary, #3b82f6);
  background: rgba(59, 130, 246, 0.05);
  color: var(--primary, #3b82f6);
}

.filter-trigger:focus-visible {
  outline: 2px solid var(--focus-ring, #3b82f6);
  outline-offset: 2px;
}

.applied-filters {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  align-items: center;
}

.filter-chip {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 8px 4px 12px;
  background: var(--chip-bg, #eff6ff);
  color: var(--primary, #3b82f6);
  border-radius: 16px;
  font-size: 13px;
}

.chip-remove {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  border: none;
  background: rgba(59, 130, 246, 0.15);
  color: var(--primary, #3b82f6);
  cursor: pointer;
  padding: 0;
}

.chip-remove:hover {
  background: rgba(59, 130, 246, 0.3);
}

.clear-all-filters {
  font-size: 13px;
  color: var(--text-muted, #6b7280);
  background: none;
  border: none;
  cursor: pointer;
  text-decoration: underline;
  padding: 4px;
}

.search-results-meta {
  font-size: 13px;
  color: var(--text-muted, #6b7280);
}
```

### 2.3 Search Results Preview

Provide inline previews so users can verify results without navigating away.

**Key principles:**
- Show document owner, last edit date, and status inline
- Highlight matching text in results
- Offer a "peek" or preview panel on hover or keyboard selection
- Support federated search across multiple data types (orders, customers, docs)

```html
<div class="search-results-preview">
  <div class="result-item" role="option" aria-selected="true">
    <div class="result-type-badge">Order</div>
    <div class="result-body">
      <span class="result-title">
        Order <mark>#1234</mark> - Acme Corporation
      </span>
      <span class="result-description">
        3 items, shipped on Dec 15 - <mark>Pending</mark> review
      </span>
      <div class="result-metadata">
        <span class="result-owner">Jane Doe</span>
        <span class="result-separator" aria-hidden="true">&middot;</span>
        <span class="result-date">Modified 2h ago</span>
        <span class="result-status status-warning">Pending</span>
      </div>
    </div>
    <svg class="result-arrow" aria-hidden="true"><!-- arrow-right --></svg>
  </div>
</div>
```

```css
.result-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  cursor: pointer;
  border: 1px solid transparent;
  transition: background 100ms ease, border-color 100ms ease;
}

.result-item:hover,
.result-item[aria-selected="true"] {
  background: var(--hover-bg, #f9fafb);
  border-color: var(--border, #e5e7eb);
}

.result-type-badge {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  padding: 2px 8px;
  border-radius: 4px;
  background: var(--badge-bg, #eff6ff);
  color: var(--primary, #3b82f6);
  white-space: nowrap;
  flex-shrink: 0;
  margin-top: 2px;
}

.result-title {
  font-size: 14px;
  font-weight: 500;
  color: var(--text, #1f2937);
  display: block;
}

.result-title mark,
.result-description mark {
  background: rgba(250, 204, 21, 0.3);
  color: inherit;
  border-radius: 2px;
  padding: 0 2px;
}

.result-description {
  font-size: 13px;
  color: var(--text-muted, #6b7280);
  display: block;
  margin-top: 2px;
}

.result-metadata {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 6px;
  font-size: 12px;
  color: var(--text-muted, #9ca3af);
}

.result-status {
  padding: 1px 8px;
  border-radius: 10px;
  font-weight: 500;
  font-size: 11px;
}

.status-warning {
  background: rgba(245, 158, 11, 0.1);
  color: #d97706;
}
```

---

## 3. Notification Patterns

### 3.1 Notification Center

A centralized panel (typically sliding from the right or dropping from a bell icon) that aggregates all notifications with grouping and priority.

**Key principles (from Smashing Magazine 2025 guidelines):**
- Categorize by priority: High (critical alerts), Medium (warnings, acknowledgments), Low (informational)
- Group notifications by type, time, or source to reduce visual clutter
- Offer predefined profiles: "Calm mode" (low frequency), "Regular", "Power-user" (all notifications)
- Support "snooze" (24h muting), time-based restrictions, and summary/digest modes
- Include "Mark all as read" and per-item "Mark as read"
- Unread indicator (dot or bold text) for unseen items
- Timestamp with relative formatting ("2 hours ago", not "14:32:01")
- Empty state messaging when there are no notifications

```html
<div
  class="notification-center"
  role="dialog"
  aria-label="Notification center"
  aria-modal="false"
>
  <header class="nc-header">
    <h2 class="nc-title">Notifications</h2>
    <div class="nc-actions">
      <button class="nc-action" aria-label="Notification settings">
        <svg aria-hidden="true"><!-- settings icon --></svg>
      </button>
      <button class="nc-action">Mark all as read</button>
    </div>
  </header>

  <!-- Category tabs -->
  <div class="nc-tabs" role="tablist" aria-label="Notification categories">
    <button role="tab" aria-selected="true" class="nc-tab active">
      All
      <span class="nc-tab-badge">12</span>
    </button>
    <button role="tab" aria-selected="false" class="nc-tab" tabindex="-1">
      Alerts
      <span class="nc-tab-badge urgent">3</span>
    </button>
    <button role="tab" aria-selected="false" class="nc-tab" tabindex="-1">
      Updates
    </button>
    <button role="tab" aria-selected="false" class="nc-tab" tabindex="-1">
      Messages
    </button>
  </div>

  <!-- Notification list -->
  <div class="nc-list" role="list" aria-label="Notifications">
    <!-- Grouped by time -->
    <div class="nc-time-group">
      <h3 class="nc-time-label">Today</h3>

      <!-- High priority / unread notification -->
      <article
        class="nc-item unread priority-high"
        role="listitem"
        aria-label="Critical: Server CPU at 95%. 10 minutes ago. Unread."
      >
        <div class="nc-priority-indicator" aria-hidden="true"></div>
        <div class="nc-item-icon high">
          <svg aria-hidden="true"><!-- alert-triangle icon --></svg>
        </div>
        <div class="nc-item-body">
          <p class="nc-item-title">Server CPU at 95%</p>
          <p class="nc-item-description">
            Production server us-east-1 has exceeded CPU threshold.
            Automatic scaling initiated.
          </p>
          <div class="nc-item-meta">
            <time datetime="2025-01-15T14:30:00Z" class="nc-time">10 minutes ago</time>
            <span class="nc-source">System Monitor</span>
          </div>
          <div class="nc-item-actions">
            <button class="nc-item-action primary">View Details</button>
            <button class="nc-item-action">Dismiss</button>
          </div>
        </div>
        <button
          class="nc-item-menu"
          aria-label="More actions"
          aria-haspopup="menu"
        >
          <svg aria-hidden="true"><!-- dots icon --></svg>
        </button>
      </article>

      <!-- Medium priority notification -->
      <article class="nc-item unread priority-medium" role="listitem">
        <div class="nc-priority-indicator" aria-hidden="true"></div>
        <div class="nc-item-icon medium">
          <svg aria-hidden="true"><!-- info icon --></svg>
        </div>
        <div class="nc-item-body">
          <p class="nc-item-title">Order #5678 requires approval</p>
          <p class="nc-item-description">
            Submitted by John Smith. Total: $12,450.00
          </p>
          <div class="nc-item-meta">
            <time datetime="2025-01-15T13:00:00Z" class="nc-time">1 hour ago</time>
            <span class="nc-source">Order Management</span>
          </div>
        </div>
        <button class="nc-item-menu" aria-label="More actions" aria-haspopup="menu">
          <svg aria-hidden="true"><!-- dots icon --></svg>
        </button>
      </article>

      <!-- Read notification -->
      <article class="nc-item read priority-low" role="listitem">
        <div class="nc-item-icon low">
          <svg aria-hidden="true"><!-- check icon --></svg>
        </div>
        <div class="nc-item-body">
          <p class="nc-item-title">Weekly report generated</p>
          <p class="nc-item-description">
            Your Q4 sales report is ready for download.
          </p>
          <div class="nc-item-meta">
            <time datetime="2025-01-15T09:00:00Z" class="nc-time">5 hours ago</time>
          </div>
        </div>
        <button class="nc-item-menu" aria-label="More actions" aria-haspopup="menu">
          <svg aria-hidden="true"><!-- dots icon --></svg>
        </button>
      </article>
    </div>

    <div class="nc-time-group">
      <h3 class="nc-time-label">Yesterday</h3>
      <!-- More notification items... -->
    </div>
  </div>
</div>
```

```css
.notification-center {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  width: 420px;
  max-width: 100vw;
  background: var(--surface, #ffffff);
  border-left: 1px solid var(--border, #e5e7eb);
  box-shadow: -8px 0 30px rgba(0, 0, 0, 0.08);
  display: flex;
  flex-direction: column;
  z-index: 200;
}

.nc-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border, #e5e7eb);
}

.nc-title {
  font-size: 16px;
  font-weight: 600;
  margin: 0;
}

.nc-actions {
  display: flex;
  gap: 8px;
  align-items: center;
}

.nc-action {
  font-size: 13px;
  color: var(--primary, #3b82f6);
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
}

.nc-action:hover {
  background: var(--hover-bg, #f3f4f6);
}

.nc-tabs {
  display: flex;
  gap: 0;
  padding: 0 20px;
  border-bottom: 1px solid var(--border, #e5e7eb);
}

.nc-tab {
  padding: 10px 12px;
  font-size: 13px;
  font-weight: 500;
  color: var(--text-muted, #6b7280);
  background: none;
  border: none;
  border-bottom: 2px solid transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 6px;
}

.nc-tab.active {
  color: var(--text, #1f2937);
  border-bottom-color: var(--primary, #3b82f6);
}

.nc-tab-badge {
  font-size: 11px;
  padding: 1px 6px;
  background: var(--badge-bg, #f3f4f6);
  border-radius: 10px;
}

.nc-tab-badge.urgent {
  background: var(--danger, #ef4444);
  color: #ffffff;
}

.nc-list {
  flex: 1;
  overflow-y: auto;
  padding: 8px 12px;
}

.nc-time-label {
  font-size: 12px;
  font-weight: 600;
  color: var(--text-muted, #6b7280);
  padding: 12px 8px 4px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.nc-item {
  display: flex;
  gap: 12px;
  padding: 12px 8px;
  border-radius: 8px;
  position: relative;
  transition: background 100ms ease;
}

.nc-item:hover {
  background: var(--hover-bg, #f9fafb);
}

.nc-item.unread {
  background: rgba(59, 130, 246, 0.03);
}

.nc-priority-indicator {
  position: absolute;
  left: 0;
  top: 16px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

.priority-high .nc-priority-indicator {
  background: var(--danger, #ef4444);
}

.priority-medium .nc-priority-indicator {
  background: var(--warning, #f59e0b);
}

.nc-item-icon {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.nc-item-icon.high {
  background: rgba(239, 68, 68, 0.1);
  color: var(--danger, #ef4444);
}

.nc-item-icon.medium {
  background: rgba(245, 158, 11, 0.1);
  color: var(--warning, #f59e0b);
}

.nc-item-icon.low {
  background: rgba(34, 197, 94, 0.1);
  color: var(--success, #22c55e);
}

.nc-item-title {
  font-size: 14px;
  font-weight: 500;
  color: var(--text, #1f2937);
  margin: 0 0 2px;
}

.unread .nc-item-title {
  font-weight: 600;
}

.nc-item-description {
  font-size: 13px;
  color: var(--text-muted, #6b7280);
  margin: 0 0 6px;
  line-height: 1.4;
}

.nc-item-meta {
  display: flex;
  gap: 8px;
  font-size: 12px;
  color: var(--text-muted, #9ca3af);
}

.nc-item-actions {
  display: flex;
  gap: 8px;
  margin-top: 8px;
}

.nc-item-action {
  font-size: 12px;
  padding: 4px 12px;
  border-radius: 6px;
  border: 1px solid var(--border, #e5e7eb);
  background: var(--surface, #ffffff);
  color: var(--text, #374151);
  cursor: pointer;
}

.nc-item-action.primary {
  background: var(--primary, #3b82f6);
  border-color: var(--primary, #3b82f6);
  color: #ffffff;
}
```

### 3.2 Toast / Snackbar Notifications

Transient, auto-dismissing messages for feedback on user actions.

**Key principles:**
- Toasts are purely informational and auto-dismiss (3-8 seconds)
- Snackbars may include a single action (e.g., "Undo") and optionally a dismiss button
- Position: top-right or bottom-right on desktop; full-width top or bottom on mobile
- Stack multiple toasts vertically with newest on top
- Use `role="status"` and `aria-live="polite"` for screen reader announcement
- For errors or critical alerts, use `role="alert"` and `aria-live="assertive"`
- Respect WCAG 2.2.1 (Timing Adjustable): provide a way to extend or pause auto-dismiss
- Keep messages concise: 1-2 lines maximum

```html
<!-- Toast container - positioned fixed -->
<div
  class="toast-container"
  aria-label="Notifications"
  aria-live="polite"
  aria-relevant="additions"
>
  <!-- Success toast -->
  <output class="toast toast-success" role="status">
    <svg class="toast-icon" aria-hidden="true"><!-- check-circle icon --></svg>
    <div class="toast-content">
      <p class="toast-message">Order #1234 saved successfully</p>
    </div>
    <button class="toast-close" aria-label="Dismiss notification">
      <svg aria-hidden="true"><!-- x icon --></svg>
    </button>
    <div class="toast-progress" aria-hidden="true"></div>
  </output>

  <!-- Error toast (uses role="alert" for immediate announcement) -->
  <output class="toast toast-error" role="alert">
    <svg class="toast-icon" aria-hidden="true"><!-- alert-circle icon --></svg>
    <div class="toast-content">
      <p class="toast-message">Failed to save changes</p>
      <p class="toast-description">Network error. Please try again.</p>
    </div>
    <button class="toast-action">Retry</button>
    <button class="toast-close" aria-label="Dismiss notification">
      <svg aria-hidden="true"><!-- x icon --></svg>
    </button>
  </output>

  <!-- Warning toast with undo action (snackbar pattern) -->
  <output class="toast toast-warning" role="status">
    <svg class="toast-icon" aria-hidden="true"><!-- alert-triangle icon --></svg>
    <div class="toast-content">
      <p class="toast-message">3 items archived</p>
    </div>
    <button class="toast-action">Undo</button>
    <button class="toast-close" aria-label="Dismiss notification">
      <svg aria-hidden="true"><!-- x icon --></svg>
    </button>
  </output>
</div>
```

```css
.toast-container {
  position: fixed;
  top: 16px;
  right: 16px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  z-index: 9999;
  max-width: 420px;
  width: 100%;
  pointer-events: none;
}

.toast {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 14px 16px;
  background: var(--surface, #ffffff);
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 10px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  pointer-events: auto;
  position: relative;
  overflow: hidden;
  animation: toast-slide-in 300ms ease forwards;
}

@keyframes toast-slide-in {
  from {
    opacity: 0;
    transform: translateX(100%);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.toast.dismissing {
  animation: toast-slide-out 200ms ease forwards;
}

@keyframes toast-slide-out {
  to {
    opacity: 0;
    transform: translateX(100%);
  }
}

.toast-icon {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
  margin-top: 1px;
}

.toast-success .toast-icon { color: var(--success, #22c55e); }
.toast-error .toast-icon { color: var(--danger, #ef4444); }
.toast-warning .toast-icon { color: var(--warning, #f59e0b); }
.toast-info .toast-icon { color: var(--info, #3b82f6); }

.toast-success { border-left: 3px solid var(--success, #22c55e); }
.toast-error { border-left: 3px solid var(--danger, #ef4444); }
.toast-warning { border-left: 3px solid var(--warning, #f59e0b); }
.toast-info { border-left: 3px solid var(--info, #3b82f6); }

.toast-content {
  flex: 1;
  min-width: 0;
}

.toast-message {
  font-size: 14px;
  font-weight: 500;
  color: var(--text, #1f2937);
  margin: 0;
}

.toast-description {
  font-size: 13px;
  color: var(--text-muted, #6b7280);
  margin: 4px 0 0;
}

.toast-action {
  font-size: 13px;
  font-weight: 600;
  color: var(--primary, #3b82f6);
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
  white-space: nowrap;
  flex-shrink: 0;
}

.toast-action:hover {
  background: rgba(59, 130, 246, 0.1);
}

.toast-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border-radius: 4px;
  border: none;
  background: none;
  color: var(--text-muted, #9ca3af);
  cursor: pointer;
  flex-shrink: 0;
  padding: 0;
}

.toast-close:hover {
  background: var(--hover-bg, #f3f4f6);
  color: var(--text, #374151);
}

.toast-progress {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  background: currentColor;
  opacity: 0.2;
  animation: toast-progress 5s linear forwards;
}

@keyframes toast-progress {
  from { width: 100%; }
  to { width: 0%; }
}

/* Pause auto-dismiss on hover (accessibility) */
.toast:hover .toast-progress,
.toast:focus-within .toast-progress {
  animation-play-state: paused;
}
```

### 3.3 Badge Counts

**Key principles:**
- Use numeric badges when the exact count matters to the user
- Cap display at "99+" to prevent layout shifts
- Use a dot indicator (no number) for general "new activity" signals
- Hide the badge entirely when count is zero
- Use color to encode urgency: red for critical, blue for informational

```html
<!-- Numeric badge -->
<button class="icon-button" aria-label="Notifications, 12 unread">
  <svg aria-hidden="true"><!-- bell icon --></svg>
  <span class="badge-count" aria-hidden="true">12</span>
</button>

<!-- Overflow badge -->
<button class="icon-button" aria-label="Messages, 99+ unread">
  <svg aria-hidden="true"><!-- message icon --></svg>
  <span class="badge-count overflow" aria-hidden="true">99+</span>
</button>

<!-- Dot indicator (no count) -->
<button class="icon-button" aria-label="Tasks, new activity">
  <svg aria-hidden="true"><!-- tasks icon --></svg>
  <span class="badge-dot" aria-hidden="true"></span>
</button>

<!-- Navigation item with badge -->
<a href="/inbox" class="nav-link" aria-label="Inbox, 5 new messages">
  <svg class="nav-icon" aria-hidden="true"><!-- inbox icon --></svg>
  <span class="nav-label">Inbox</span>
  <span class="nav-badge" aria-hidden="true">5</span>
</a>
```

```css
.icon-button {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  border: none;
  background: none;
  color: var(--text-muted, #6b7280);
  cursor: pointer;
}

.badge-count {
  position: absolute;
  top: 2px;
  right: 2px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  background: var(--danger, #ef4444);
  color: #ffffff;
  border-radius: 9px;
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  border: 2px solid var(--surface, #ffffff);
}

.badge-count.overflow {
  font-size: 10px;
  padding: 0 4px;
}

.badge-dot {
  position: absolute;
  top: 6px;
  right: 6px;
  width: 10px;
  height: 10px;
  background: var(--danger, #ef4444);
  border-radius: 50%;
  border: 2px solid var(--surface, #ffffff);
}

.nav-badge {
  margin-left: auto;
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  background: rgba(59, 130, 246, 0.1);
  color: var(--primary, #3b82f6);
  border-radius: 10px;
  font-size: 12px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
}
```

---

## 4. Page Structure

### 4.1 Full Enterprise Layout

The canonical enterprise app layout consists of: a fixed sidebar on the left, a fixed top bar, the main content area, and an optional right detail drawer.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Enterprise App</title>
</head>
<body class="app-layout">
  <!-- Skip navigation link (accessibility) -->
  <a href="#main-content" class="skip-link">Skip to main content</a>

  <!-- Sidebar navigation -->
  <nav class="sidebar" aria-label="Main navigation">
    <div class="sidebar-header">
      <img src="/logo.svg" alt="Company Name" class="sidebar-logo" />
    </div>
    <ul class="sidebar-nav" role="list">
      <!-- Navigation items -->
    </ul>
    <div class="sidebar-footer">
      <!-- User menu -->
    </div>
  </nav>

  <!-- Main wrapper (everything except sidebar) -->
  <div class="main-wrapper">
    <!-- Top bar -->
    <header class="top-bar" role="banner">
      <nav aria-label="Breadcrumb" class="breadcrumb-nav">
        <ol class="breadcrumb-list">
          <li><a href="/">Home</a></li>
          <li aria-hidden="true">/</li>
          <li><a href="/orders">Orders</a></li>
          <li aria-hidden="true">/</li>
          <li aria-current="page">Order #1234</li>
        </ol>
      </nav>
      <div class="top-bar-actions">
        <!-- Search, notifications, user menu -->
      </div>
    </header>

    <!-- Page content area -->
    <div class="page-container">
      <!-- Main content -->
      <main id="main-content" class="main-content" role="main">
        <!-- Page header -->
        <div class="page-header">
          <div class="page-header-left">
            <h1 class="page-title">Order #1234</h1>
            <span class="page-status status-pending">Pending Review</span>
          </div>
          <div class="page-header-actions">
            <button class="btn btn-secondary">Export</button>
            <button class="btn btn-primary">Approve Order</button>
          </div>
        </div>

        <!-- Page body / content area -->
        <div class="page-body">
          <!-- Content sections, tables, forms, etc. -->
        </div>
      </main>

      <!-- Optional: Right detail drawer / panel -->
      <aside
        class="detail-drawer"
        role="complementary"
        aria-label="Order details"
      >
        <header class="drawer-header">
          <h2 class="drawer-title">Item Details</h2>
          <button class="drawer-close" aria-label="Close details panel">
            <svg aria-hidden="true"><!-- x icon --></svg>
          </button>
        </header>
        <div class="drawer-body">
          <!-- Detail content -->
        </div>
      </aside>
    </div>
  </div>
</body>
</html>
```

```css
*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
}

:root {
  /* Semantic color tokens */
  --primary: #3b82f6;
  --primary-hover: #2563eb;
  --danger: #ef4444;
  --warning: #f59e0b;
  --success: #22c55e;
  --info: #3b82f6;

  /* Surface colors */
  --surface: #ffffff;
  --surface-subtle: #f9fafb;
  --surface-muted: #f3f4f6;

  /* Text colors */
  --text: #1f2937;
  --text-secondary: #4b5563;
  --text-muted: #6b7280;
  --text-placeholder: #9ca3af;

  /* Border */
  --border: #e5e7eb;
  --border-hover: #d1d5db;

  /* Focus */
  --focus-ring: #3b82f6;

  /* Sidebar */
  --sidebar-bg: #111827;
  --sidebar-text: #d1d5db;
  --sidebar-width: 260px;
  --sidebar-collapsed-width: 64px;

  /* Top bar */
  --topbar-height: 56px;

  /* Spacing */
  --page-padding: 32px;
}

/* Accessibility: Skip link */
.skip-link {
  position: absolute;
  top: -100%;
  left: 16px;
  z-index: 10000;
  padding: 8px 16px;
  background: var(--primary);
  color: #ffffff;
  border-radius: 0 0 8px 8px;
  font-weight: 600;
  text-decoration: none;
}

.skip-link:focus {
  top: 0;
}

/* Layout grid */
.app-layout {
  display: grid;
  grid-template-columns: var(--sidebar-width) 1fr;
  grid-template-rows: 1fr;
  min-height: 100vh;
  background: var(--surface-subtle);
}

.app-layout.sidebar-collapsed {
  grid-template-columns: var(--sidebar-collapsed-width) 1fr;
}

.sidebar {
  grid-row: 1;
  grid-column: 1;
  position: sticky;
  top: 0;
  height: 100vh;
  background: var(--sidebar-bg);
  color: var(--sidebar-text);
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  z-index: 100;
}

.main-wrapper {
  grid-row: 1;
  grid-column: 2;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  min-width: 0; /* prevent overflow */
}

.top-bar {
  position: sticky;
  top: 0;
  height: var(--topbar-height);
  background: var(--surface);
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 var(--page-padding);
  z-index: 90;
}

.page-container {
  flex: 1;
  display: flex;
  overflow: hidden;
}

.main-content {
  flex: 1;
  padding: var(--page-padding);
  overflow-y: auto;
  min-width: 0;
}

.page-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 24px;
  gap: 16px;
}

.page-title {
  font-size: 24px;
  font-weight: 700;
  color: var(--text);
  line-height: 1.3;
}

.page-header-actions {
  display: flex;
  gap: 8px;
  flex-shrink: 0;
}

/* Detail drawer / right panel */
.detail-drawer {
  width: 400px;
  background: var(--surface);
  border-left: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  flex-shrink: 0;
}

.detail-drawer[hidden] {
  display: none;
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border);
}

.drawer-title {
  font-size: 16px;
  font-weight: 600;
}

.drawer-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 6px;
  border: none;
  background: none;
  color: var(--text-muted);
  cursor: pointer;
}

.drawer-close:hover {
  background: var(--surface-muted);
}

.drawer-body {
  padding: 20px;
  flex: 1;
}

/* Buttons */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  border: 1px solid transparent;
  cursor: pointer;
  transition: background 150ms ease, border-color 150ms ease, box-shadow 150ms ease;
  white-space: nowrap;
}

.btn:focus-visible {
  outline: 2px solid var(--focus-ring);
  outline-offset: 2px;
}

.btn-primary {
  background: var(--primary);
  color: #ffffff;
  border-color: var(--primary);
}

.btn-primary:hover {
  background: var(--primary-hover);
}

.btn-secondary {
  background: var(--surface);
  color: var(--text);
  border-color: var(--border);
}

.btn-secondary:hover {
  background: var(--surface-muted);
  border-color: var(--border-hover);
}

/* Status badge */
.page-status {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 600;
}

.status-pending {
  background: rgba(245, 158, 11, 0.1);
  color: #b45309;
}
```

### 4.2 ARIA Landmark Regions Summary

Every enterprise app page should include these landmark regions:

| HTML Element | ARIA Role | Purpose |
|---|---|---|
| `<header>` (child of body) | `banner` | Site-wide header, logo, global navigation |
| `<nav>` | `navigation` | Groups of navigation links |
| `<main>` | `main` | Primary page content |
| `<aside>` | `complementary` | Supporting content (detail panels, contextual help) |
| `<footer>` (child of body) | `contentinfo` | Footer with copyright, links |
| `<form>` with `role="search"` | `search` | Search functionality |

**Rules:**
- Each page should have exactly one `main` landmark
- Each page may have one `banner` and one `contentinfo`
- Multiple `navigation` landmarks require unique `aria-label` values
- All perceivable content should live inside a landmark region

---

## 5. Keyboard Shortcuts

### 5.1 Command Palette (Cmd+K Pattern)

See Section 2.1 for the full implementation. The command palette is the primary keyboard-driven interface.

### 5.2 Shortcut Conventions

Follow established conventions to leverage existing muscle memory:

| Shortcut | Action | Context |
|---|---|---|
| `Cmd/Ctrl + K` | Open command palette | Global |
| `Cmd/Ctrl + /` | Show keyboard shortcuts help | Global |
| `Cmd/Ctrl + F` | Find/search within page | Page-level |
| `Cmd/Ctrl + S` | Save current form/document | Forms |
| `Cmd/Ctrl + N` | Create new item | Module-level |
| `Cmd/Ctrl + Enter` | Submit form / confirm action | Forms, dialogs |
| `Escape` | Close modal/drawer/palette | Global |
| `?` | Show shortcuts cheat sheet | Global (when no input focused) |
| `G then D` | Go to Dashboard | Navigation (Vim-style sequences) |
| `G then O` | Go to Orders | Navigation |
| `J / K` | Move down / up in lists | Lists, tables |

### 5.3 Shortcut Discoverability

**Strategies:**
1. Display shortcuts next to menu commands and in tooltips
2. Provide a keyboard shortcuts dialog (`Cmd+/` or `?`)
3. Show hints in the command palette footer
4. Use onboarding toasts to introduce key shortcuts to new users
5. Show shortcut badges on frequently used actions in the UI

```html
<!-- Keyboard shortcuts dialog -->
<dialog class="shortcuts-dialog" aria-label="Keyboard shortcuts" aria-modal="true">
  <header class="shortcuts-header">
    <h2>Keyboard Shortcuts</h2>
    <button class="shortcuts-close" aria-label="Close">
      <svg aria-hidden="true"><!-- x icon --></svg>
    </button>
  </header>

  <div class="shortcuts-body">
    <div class="shortcuts-section">
      <h3 class="shortcuts-section-title">General</h3>
      <dl class="shortcuts-list">
        <div class="shortcut-item">
          <dt class="shortcut-label">Open command palette</dt>
          <dd class="shortcut-keys">
            <kbd>&#8984;</kbd><kbd>K</kbd>
          </dd>
        </div>
        <div class="shortcut-item">
          <dt class="shortcut-label">Show keyboard shortcuts</dt>
          <dd class="shortcut-keys">
            <kbd>&#8984;</kbd><kbd>/</kbd>
          </dd>
        </div>
        <div class="shortcut-item">
          <dt class="shortcut-label">Search within page</dt>
          <dd class="shortcut-keys">
            <kbd>&#8984;</kbd><kbd>F</kbd>
          </dd>
        </div>
      </dl>
    </div>

    <div class="shortcuts-section">
      <h3 class="shortcuts-section-title">Navigation</h3>
      <dl class="shortcuts-list">
        <div class="shortcut-item">
          <dt class="shortcut-label">Go to Dashboard</dt>
          <dd class="shortcut-keys">
            <kbd>G</kbd> <span class="shortcut-then">then</span> <kbd>D</kbd>
          </dd>
        </div>
        <div class="shortcut-item">
          <dt class="shortcut-label">Go to Orders</dt>
          <dd class="shortcut-keys">
            <kbd>G</kbd> <span class="shortcut-then">then</span> <kbd>O</kbd>
          </dd>
        </div>
      </dl>
    </div>

    <div class="shortcuts-section">
      <h3 class="shortcuts-section-title">Lists &amp; Tables</h3>
      <dl class="shortcuts-list">
        <div class="shortcut-item">
          <dt class="shortcut-label">Move down</dt>
          <dd class="shortcut-keys"><kbd>J</kbd> or <kbd>&darr;</kbd></dd>
        </div>
        <div class="shortcut-item">
          <dt class="shortcut-label">Move up</dt>
          <dd class="shortcut-keys"><kbd>K</kbd> or <kbd>&uarr;</kbd></dd>
        </div>
        <div class="shortcut-item">
          <dt class="shortcut-label">Open item</dt>
          <dd class="shortcut-keys"><kbd>Enter</kbd></dd>
        </div>
        <div class="shortcut-item">
          <dt class="shortcut-label">Select item</dt>
          <dd class="shortcut-keys"><kbd>X</kbd></dd>
        </div>
      </dl>
    </div>
  </div>
</dialog>
```

```css
.shortcuts-dialog {
  width: 100%;
  max-width: 560px;
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 16px;
  padding: 0;
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.15);
  background: var(--surface, #ffffff);
}

.shortcuts-dialog::backdrop {
  background: rgba(0, 0, 0, 0.4);
  backdrop-filter: blur(4px);
}

.shortcuts-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 24px;
  border-bottom: 1px solid var(--border, #e5e7eb);
}

.shortcuts-header h2 {
  font-size: 18px;
  font-weight: 600;
}

.shortcuts-body {
  padding: 16px 24px 24px;
  max-height: 60vh;
  overflow-y: auto;
}

.shortcuts-section {
  margin-bottom: 24px;
}

.shortcuts-section:last-child {
  margin-bottom: 0;
}

.shortcuts-section-title {
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted, #6b7280);
  margin-bottom: 12px;
}

.shortcuts-list {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.shortcut-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid var(--border, #f3f4f6);
}

.shortcut-item:last-child {
  border-bottom: none;
}

.shortcut-label {
  font-size: 14px;
  color: var(--text, #374151);
}

.shortcut-keys {
  display: flex;
  align-items: center;
  gap: 4px;
}

.shortcut-keys kbd {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 24px;
  height: 24px;
  padding: 0 6px;
  background: var(--surface-muted, #f3f4f6);
  border: 1px solid var(--border, #e5e7eb);
  border-radius: 5px;
  font-size: 12px;
  font-weight: 500;
  font-family: inherit;
  color: var(--text-secondary, #4b5563);
  box-shadow: 0 1px 0 var(--border, #d1d5db);
}

.shortcut-then {
  font-size: 11px;
  color: var(--text-muted, #9ca3af);
  padding: 0 2px;
}
```

---

## 6. Wayfinding

### 6.1 Breadcrumbs

Breadcrumbs are a secondary navigation aid showing hierarchical position. They are essential in enterprise apps where users frequently land on deep pages via search or bookmarks.

**Key principles:**
- Place breadcrumbs above the page title, below the top bar
- Use right-pointing chevrons or slashes as separators
- All items except the current page should be clickable links
- Omit the current page label if the page title is directly below
- On mobile, show only the parent link with a back arrow, or use horizontal scroll
- Support dropdown "sideways navigation" to show sibling pages at each level

```html
<nav aria-label="Breadcrumb" class="breadcrumb">
  <ol class="breadcrumb-list">
    <li class="breadcrumb-item">
      <a href="/" class="breadcrumb-link">
        <svg class="breadcrumb-home-icon" aria-hidden="true"><!-- home icon --></svg>
        <span class="sr-only">Home</span>
      </a>
    </li>
    <li class="breadcrumb-separator" aria-hidden="true">
      <svg><!-- chevron-right --></svg>
    </li>
    <li class="breadcrumb-item">
      <a href="/operations" class="breadcrumb-link">Operations</a>
    </li>
    <li class="breadcrumb-separator" aria-hidden="true">
      <svg><!-- chevron-right --></svg>
    </li>
    <li class="breadcrumb-item">
      <a href="/operations/orders" class="breadcrumb-link">Orders</a>
    </li>
    <li class="breadcrumb-separator" aria-hidden="true">
      <svg><!-- chevron-right --></svg>
    </li>
    <li class="breadcrumb-item current" aria-current="page">
      <span class="breadcrumb-text">Order #1234</span>
    </li>
  </ol>
</nav>
```

```css
.breadcrumb-list {
  display: flex;
  align-items: center;
  gap: 0;
  list-style: none;
  padding: 0;
  margin: 0;
}

.breadcrumb-item {
  display: flex;
  align-items: center;
}

.breadcrumb-link {
  font-size: 13px;
  color: var(--text-muted, #6b7280);
  text-decoration: none;
  padding: 4px 2px;
  border-radius: 4px;
  transition: color 150ms ease;
}

.breadcrumb-link:hover {
  color: var(--primary, #3b82f6);
}

.breadcrumb-link:focus-visible {
  outline: 2px solid var(--focus-ring, #3b82f6);
  outline-offset: 2px;
}

.breadcrumb-separator {
  color: var(--text-muted, #d1d5db);
  padding: 0 4px;
  display: flex;
  align-items: center;
}

.breadcrumb-separator svg {
  width: 14px;
  height: 14px;
}

.breadcrumb-item.current .breadcrumb-text {
  font-size: 13px;
  color: var(--text, #1f2937);
  font-weight: 500;
}

.breadcrumb-home-icon {
  width: 16px;
  height: 16px;
}

/* Screen reader only utility */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
```

### 6.2 Active States and Context Preservation

**Active states:**
- Sidebar: highlight the current section with background color and/or left border accent
- Tabs: underline or bottom border on the active tab
- Breadcrumbs: bold or non-link styling for current page
- Top bar: highlight the active module area

**Context preservation on navigation:**
- Preserve scroll position when navigating back
- Maintain filter/search state via URL query parameters
- Use browser history API to enable back/forward navigation
- Store draft form state in sessionStorage
- When opening a detail drawer, keep the main list visible and selected row highlighted

---

## 7. Responsive Navigation

### 7.1 Sidebar Collapse to Icons

On medium screens (tablet landscape), collapse the sidebar to show only icons. On small screens, hide it entirely behind a hamburger menu.

```css
/* Tablet: collapse to icons */
@media (max-width: 1024px) {
  :root {
    --sidebar-width: var(--sidebar-collapsed-width);
  }

  .sidebar {
    width: var(--sidebar-collapsed-width);
  }

  .sidebar .nav-label,
  .sidebar .nav-chevron,
  .sidebar .nav-section-text,
  .sidebar .user-name,
  .sidebar .sidebar-logo-text {
    display: none;
  }

  .sidebar .nav-submenu {
    /* Convert to popup/tooltip on hover */
    position: absolute;
    left: 100%;
    top: 0;
    background: var(--sidebar-bg);
    border-radius: 8px;
    padding: 8px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
    min-width: 180px;
    display: none;
  }

  .sidebar .has-children:hover .nav-submenu,
  .sidebar .has-children:focus-within .nav-submenu {
    display: block;
  }

  .nav-link {
    justify-content: center;
    padding: 10px;
    margin: 2px 6px;
  }

  .sidebar .nav-icon {
    margin: 0;
  }
}

/* Mobile: off-canvas drawer */
@media (max-width: 768px) {
  .app-layout {
    grid-template-columns: 1fr;
  }

  .sidebar {
    position: fixed;
    transform: translateX(-100%);
    width: 280px;
    transition: transform 300ms ease;
    z-index: 200;
  }

  .sidebar.open {
    transform: translateX(0);
  }

  /* Restore full labels on mobile when open */
  .sidebar.open .nav-label,
  .sidebar.open .nav-chevron,
  .sidebar.open .user-name {
    display: inline;
  }

  .sidebar-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 199;
    opacity: 0;
    visibility: hidden;
    transition: opacity 300ms ease;
  }

  .sidebar.open ~ .sidebar-overlay {
    opacity: 1;
    visibility: visible;
  }

  .top-bar {
    padding-left: 16px;
  }

  /* Show hamburger menu button */
  .mobile-menu-btn {
    display: flex;
  }

  .main-content {
    padding: 16px;
  }

  /* Stack page header on mobile */
  .page-header {
    flex-direction: column;
  }

  /* Full-width detail drawer on mobile */
  .detail-drawer {
    position: fixed;
    inset: 0;
    width: 100%;
    z-index: 150;
    transform: translateX(100%);
    transition: transform 300ms ease;
  }

  .detail-drawer.open {
    transform: translateX(0);
  }
}
```

### 7.2 Mobile Hamburger + Overlay

```html
<!-- Hamburger button (visible only on mobile) -->
<button
  class="mobile-menu-btn"
  aria-label="Open navigation menu"
  aria-expanded="false"
  aria-controls="sidebar"
  hidden
>
  <svg aria-hidden="true"><!-- menu/hamburger icon --></svg>
</button>

<!-- Overlay behind sidebar on mobile -->
<div
  class="sidebar-overlay"
  role="presentation"
  aria-hidden="true"
></div>
```

### 7.3 Responsive Detail Drawer

On mobile, the detail drawer overlays the full screen with a back button.

```html
<aside
  class="detail-drawer"
  role="complementary"
  aria-label="Item details"
>
  <header class="drawer-header">
    <!-- Back button (visible on mobile) -->
    <button class="drawer-back mobile-only" aria-label="Back to list">
      <svg aria-hidden="true"><!-- arrow-left --></svg>
    </button>
    <h2 class="drawer-title">Item Details</h2>
    <button class="drawer-close desktop-only" aria-label="Close panel">
      <svg aria-hidden="true"><!-- x icon --></svg>
    </button>
  </header>
  <div class="drawer-body">
    <!-- Content -->
  </div>
</aside>
```

```css
.mobile-only { display: none; }
.desktop-only { display: flex; }

@media (max-width: 768px) {
  .mobile-only { display: flex; }
  .desktop-only { display: none; }
}
```

---

## 8. Brand Integration

### 8.1 Logo Placement

**Standard placements:**
- **Sidebar header**: the most common position; logo sits at the top of the sidebar
- **Top-left of top bar**: when using a horizontal-only navigation
- **Collapsed state**: switch to a logomark (icon-only) version when sidebar collapses

```html
<div class="sidebar-header">
  <!-- Full logo (shown when sidebar is expanded) -->
  <a href="/" class="sidebar-brand" aria-label="Go to home page">
    <img
      src="/logo-full.svg"
      alt="Company Name"
      class="brand-logo-full"
      width="140"
      height="32"
    />
    <!-- Icon-only logo (shown when sidebar is collapsed) -->
    <img
      src="/logo-icon.svg"
      alt=""
      class="brand-logo-icon"
      width="32"
      height="32"
      aria-hidden="true"
    />
  </a>
</div>
```

```css
.sidebar-header {
  padding: 20px 16px 12px;
  display: flex;
  align-items: center;
}

.sidebar-brand {
  display: flex;
  align-items: center;
  text-decoration: none;
}

.brand-logo-full {
  display: block;
  height: 28px;
  width: auto;
}

.brand-logo-icon {
  display: none;
  height: 28px;
  width: 28px;
}

.sidebar.collapsed .brand-logo-full {
  display: none;
}

.sidebar.collapsed .brand-logo-icon {
  display: block;
}
```

### 8.2 Theming with CSS Custom Properties

Use CSS custom properties as the single source of truth for all brand colors and tokens. This approach enables white-labeling by simply overriding the root variables.

```css
/* Default brand theme */
:root {
  /* Brand colors */
  --brand-primary: #3b82f6;
  --brand-primary-hover: #2563eb;
  --brand-primary-light: rgba(59, 130, 246, 0.1);
  --brand-primary-contrast: #ffffff;

  /* Sidebar theming */
  --sidebar-bg: #111827;
  --sidebar-text: #d1d5db;
  --sidebar-active-bg: var(--brand-primary-light);
  --sidebar-active-text: var(--brand-primary);
  --sidebar-hover-bg: rgba(255, 255, 255, 0.06);

  /* Top bar theming */
  --topbar-bg: #ffffff;
  --topbar-border: #e5e7eb;

  /* Focus ring */
  --focus-ring: var(--brand-primary);

  /* Buttons */
  --btn-primary-bg: var(--brand-primary);
  --btn-primary-hover: var(--brand-primary-hover);
  --btn-primary-text: var(--brand-primary-contrast);

  /* Typography */
  --font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace;

  /* Border radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
}

/* White-label override example: "Acme Corp" brand */
[data-theme="acme"] {
  --brand-primary: #7c3aed;
  --brand-primary-hover: #6d28d9;
  --brand-primary-light: rgba(124, 58, 237, 0.1);

  --sidebar-bg: #1e1b4b;
  --sidebar-text: #c4b5fd;
  --sidebar-active-text: #a78bfa;
}

/* Dark mode (applied via class or media query) */
[data-mode="dark"],
@media (prefers-color-scheme: dark) {
  :root {
    --surface: #1f2937;
    --surface-subtle: #111827;
    --surface-muted: #374151;

    --text: #f9fafb;
    --text-secondary: #d1d5db;
    --text-muted: #9ca3af;

    --border: #374151;
    --border-hover: #4b5563;

    --topbar-bg: #1f2937;
    --topbar-border: #374151;
  }
}

/* High contrast mode for accessibility */
@media (prefers-contrast: high) {
  :root {
    --text: #000000;
    --text-muted: #333333;
    --border: #000000;
    --focus-ring: #000000;
  }
}

/* Reduced motion preference */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

### 8.3 White-Label Support Checklist

For multi-tenant enterprise applications, support these configurable brand elements:

| Element | CSS Variable | Admin Setting |
|---|---|---|
| Primary color | `--brand-primary` | Color picker |
| Logo (full) | Image URL | File upload |
| Logo (icon) | Image URL | File upload |
| Sidebar background | `--sidebar-bg` | Color picker |
| Sidebar text | `--sidebar-text` | Color picker |
| Font family | `--font-family` | Dropdown |
| Favicon | `<link>` tag | File upload |
| App name | Document title | Text input |
| Login page background | Background image/color | File upload + color |
| Email templates | Brand tokens | Template editor |

---

## 9. Information Density

Enterprise users working with data-dense applications (finance, operations, analytics) need higher information density than consumer apps.

### 9.1 Density Levels

Offer configurable density modes:

```css
/* Comfortable (default, good for onboarding) */
:root {
  --density-row-height: 48px;
  --density-cell-padding: 12px 16px;
  --density-font-size: 14px;
  --density-spacing: 16px;
}

/* Compact (for power users and data-heavy views) */
[data-density="compact"] {
  --density-row-height: 36px;
  --density-cell-padding: 6px 12px;
  --density-font-size: 13px;
  --density-spacing: 8px;
}

/* Spacious (for readability-focused tasks) */
[data-density="spacious"] {
  --density-row-height: 56px;
  --density-cell-padding: 16px 20px;
  --density-font-size: 15px;
  --density-spacing: 20px;
}

/* Apply to data tables */
.data-table td,
.data-table th {
  padding: var(--density-cell-padding);
  font-size: var(--density-font-size);
  height: var(--density-row-height);
}

.data-table th {
  font-weight: 600;
  color: var(--text-muted);
  text-align: left;
  border-bottom: 2px solid var(--border);
  white-space: nowrap;
}

.data-table td {
  border-bottom: 1px solid var(--border);
  color: var(--text);
}

.data-table tbody tr:hover {
  background: var(--hover-bg, #f9fafb);
}
```

### 9.2 Progressive Disclosure

Show essential information upfront and provide drill-down mechanisms for details:

- **Summary cards** at the top of dashboards with key metrics
- **Expandable table rows** for inline details
- **Detail drawers** for full item information without page navigation
- **Tooltips** for supplementary data on hover
- **Collapsible sections** within forms and detail views

```html
<!-- Expandable table row example -->
<table class="data-table" role="grid">
  <thead>
    <tr>
      <th scope="col" style="width: 40px">
        <span class="sr-only">Expand</span>
      </th>
      <th scope="col">Order ID</th>
      <th scope="col">Customer</th>
      <th scope="col">Amount</th>
      <th scope="col">Status</th>
    </tr>
  </thead>
  <tbody>
    <tr class="expandable-row" aria-expanded="false">
      <td>
        <button
          class="expand-toggle"
          aria-expanded="false"
          aria-controls="detail-row-1"
          aria-label="Show details for Order #1234"
        >
          <svg class="expand-icon" aria-hidden="true"><!-- chevron-right --></svg>
        </button>
      </td>
      <td><a href="/orders/1234" class="table-link">#1234</a></td>
      <td>Acme Corporation</td>
      <td>$12,450.00</td>
      <td><span class="status-badge status-pending">Pending</span></td>
    </tr>
    <tr id="detail-row-1" class="detail-row" hidden>
      <td colspan="5">
        <div class="detail-row-content">
          <!-- Expanded details: line items, notes, timeline, etc. -->
          <dl class="detail-list">
            <div class="detail-pair">
              <dt>Created</dt>
              <dd>Jan 10, 2025</dd>
            </div>
            <div class="detail-pair">
              <dt>Assigned to</dt>
              <dd>Jane Doe</dd>
            </div>
            <div class="detail-pair">
              <dt>Items</dt>
              <dd>Widget A (x3), Widget B (x1)</dd>
            </div>
          </dl>
        </div>
      </td>
    </tr>
  </tbody>
</table>
```

```css
.expand-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border: none;
  background: none;
  border-radius: 4px;
  cursor: pointer;
  color: var(--text-muted);
  transition: background 150ms ease;
}

.expand-toggle:hover {
  background: var(--surface-muted);
}

.expand-icon {
  width: 16px;
  height: 16px;
  transition: transform 200ms ease;
}

.expand-toggle[aria-expanded="true"] .expand-icon {
  transform: rotate(90deg);
}

.detail-row-content {
  padding: 16px 24px;
  background: var(--surface-subtle, #f9fafb);
  border-radius: 6px;
  margin: 4px 0;
}

.detail-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.detail-pair dt {
  font-size: 12px;
  font-weight: 600;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.04em;
  margin-bottom: 2px;
}

.detail-pair dd {
  font-size: 14px;
  color: var(--text);
  margin: 0;
}
```

---

## 10. Power User Patterns

### 10.1 Bulk Actions

Allow selecting multiple items and performing batch operations.

```html
<div class="bulk-actions-bar" role="toolbar" aria-label="Bulk actions">
  <span class="bulk-count">
    <strong>12</strong> items selected
  </span>
  <div class="bulk-buttons">
    <button class="btn btn-sm btn-secondary">
      <svg aria-hidden="true"><!-- edit icon --></svg>
      Edit
    </button>
    <button class="btn btn-sm btn-secondary">
      <svg aria-hidden="true"><!-- archive icon --></svg>
      Archive
    </button>
    <button class="btn btn-sm btn-secondary">
      <svg aria-hidden="true"><!-- tag icon --></svg>
      Add Tag
    </button>
    <button class="btn btn-sm btn-danger">
      <svg aria-hidden="true"><!-- trash icon --></svg>
      Delete
    </button>
  </div>
  <button class="bulk-deselect" aria-label="Deselect all">
    <svg aria-hidden="true"><!-- x icon --></svg>
    Deselect all
  </button>
</div>
```

```css
.bulk-actions-bar {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 8px 16px;
  background: var(--primary);
  color: #ffffff;
  border-radius: 10px;
  position: sticky;
  bottom: 16px;
  margin: 16px;
  box-shadow: 0 8px 30px rgba(59, 130, 246, 0.3);
  animation: slide-up 200ms ease;
  z-index: 50;
}

@keyframes slide-up {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
}

.bulk-count {
  font-size: 14px;
  white-space: nowrap;
}

.bulk-buttons {
  display: flex;
  gap: 6px;
}

.btn-sm {
  padding: 6px 12px;
  font-size: 13px;
}

.bulk-deselect {
  margin-left: auto;
  display: flex;
  align-items: center;
  gap: 4px;
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  font-size: 13px;
  padding: 4px 8px;
  border-radius: 4px;
}

.bulk-deselect:hover {
  color: #ffffff;
  background: rgba(255, 255, 255, 0.15);
}
```

### 10.2 Customizable Columns and Views

Power users need to control which columns are visible and in what order.

```html
<div class="view-controls" role="toolbar" aria-label="View options">
  <div class="view-tabs" role="group" aria-label="Saved views">
    <button class="view-tab active" aria-pressed="true">Default View</button>
    <button class="view-tab" aria-pressed="false">My Custom View</button>
    <button class="view-tab" aria-pressed="false">Manager View</button>
    <button class="view-tab add-view" aria-label="Create new view">
      <svg aria-hidden="true"><!-- plus icon --></svg>
    </button>
  </div>

  <div class="view-actions">
    <button class="btn-icon" aria-label="Configure columns" aria-haspopup="dialog">
      <svg aria-hidden="true"><!-- columns icon --></svg>
    </button>
    <button class="btn-icon" aria-label="Sort" aria-haspopup="menu">
      <svg aria-hidden="true"><!-- sort icon --></svg>
    </button>
    <button class="btn-icon" aria-label="Toggle density" aria-haspopup="menu">
      <svg aria-hidden="true"><!-- density icon --></svg>
    </button>
  </div>
</div>
```

### 10.3 Inline Editing

Allow editing data directly in tables or lists without navigating to a separate form.

```html
<td class="editable-cell" role="gridcell">
  <button
    class="cell-display"
    aria-label="Edit customer name: Acme Corporation"
    role="button"
  >
    <span class="cell-value">Acme Corporation</span>
    <svg class="cell-edit-icon" aria-hidden="true"><!-- pencil icon --></svg>
  </button>

  <!-- Shown when editing (replaces button above) -->
  <div class="cell-editor" hidden>
    <input
      type="text"
      class="cell-input"
      value="Acme Corporation"
      aria-label="Customer name"
    />
    <div class="cell-editor-actions">
      <button class="cell-save" aria-label="Save">
        <svg aria-hidden="true"><!-- check icon --></svg>
      </button>
      <button class="cell-cancel" aria-label="Cancel">
        <svg aria-hidden="true"><!-- x icon --></svg>
      </button>
    </div>
  </div>
</td>
```

```css
.editable-cell {
  position: relative;
}

.cell-display {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  padding: 4px 8px;
  background: none;
  border: 1px solid transparent;
  border-radius: 4px;
  cursor: pointer;
  text-align: left;
  font-size: inherit;
  color: inherit;
}

.cell-display:hover {
  border-color: var(--border, #e5e7eb);
  background: var(--surface-subtle, #f9fafb);
}

.cell-edit-icon {
  width: 14px;
  height: 14px;
  color: var(--text-muted, #9ca3af);
  opacity: 0;
  transition: opacity 150ms ease;
}

.cell-display:hover .cell-edit-icon {
  opacity: 1;
}

.cell-editor {
  display: flex;
  gap: 4px;
  align-items: center;
}

.cell-input {
  flex: 1;
  padding: 4px 8px;
  border: 1px solid var(--primary, #3b82f6);
  border-radius: 4px;
  font-size: inherit;
  color: var(--text);
  outline: none;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

.cell-save,
.cell-cancel {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
}

.cell-save {
  background: var(--primary, #3b82f6);
  color: #ffffff;
}

.cell-cancel {
  background: var(--surface-muted, #f3f4f6);
  color: var(--text-muted, #6b7280);
}
```

---

## Accessibility Checklist for Enterprise Apps

| Requirement | Implementation |
|---|---|
| **Skip navigation link** | Add `<a href="#main-content" class="skip-link">` as first body element |
| **Landmark regions** | Use semantic HTML (`<nav>`, `<main>`, `<aside>`, `<header>`, `<footer>`) |
| **ARIA labels** | Label all landmarks, especially when multiple `<nav>` exist |
| **Focus management** | Visible focus rings on all interactive elements (`:focus-visible`) |
| **Keyboard navigation** | All functionality accessible via keyboard; logical tab order |
| **Color contrast** | Minimum 4.5:1 for text, 3:1 for large text and UI components (WCAG AA) |
| **Screen reader support** | `aria-live` regions for dynamic content, `aria-current` for active items |
| **Reduced motion** | Respect `prefers-reduced-motion` media query |
| **High contrast** | Support `prefers-contrast: high` |
| **Toast accessibility** | Use `role="status"` / `role="alert"` with `aria-live`; pause timers on hover/focus |
| **Dialog accessibility** | `aria-modal="true"`, trap focus, return focus on close |
| **Form labels** | Every input has an associated `<label>` or `aria-label` |
| **Error messages** | Use `aria-describedby` to link error messages to inputs |
| **Table accessibility** | Use `<th scope="col/row">`, `role="grid"` for interactive tables |
| **Expandable sections** | `aria-expanded`, `aria-controls` on toggle buttons |
| **Tab panels** | Proper `role="tablist"`, `role="tab"`, `role="tabpanel"` with arrow key navigation |

---

## Sources

### Navigation
- [Best UX Practices for Sidebar Menu Design in 2025](https://uiuxdesigntrends.com/best-ux-practices-for-sidebar-menu-in-2025/)
- [Best Sidebar Menu Design Examples of 2025](https://www.navbar.gallery/blog/best-side-bar-navigation-menu-design-examples)
- [Enterprise UX Design in 2026: Challenges and Best Practices](https://www.wearetenet.com/blog/enterprise-ux-design)
- [Multilevel Menu Design Best Practices](https://www.toptal.com/designers/ux/multilevel-menu-design)
- [Enterprise UI Guide for 2026](https://www.superblocks.com/blog/enterprise-ui)
- [Top 7 Enterprise UX Design Patterns](https://www.onething.design/post/top-7-enterprise-ux-design-patterns)

### Search & Command Palette
- [Command Palette UI Design (Mobbin)](https://mobbin.com/glossary/command-palette)
- [Command Palette Interfaces](https://philipcdavis.com/writing/command-palette-interfaces)
- [Command Palette Pattern](https://uxpatterns.dev/patterns/advanced/command-palette)
- [Enterprise Filtering UX Patterns](https://www.pencilandpaper.io/articles/ux-pattern-analysis-enterprise-filtering)
- [Search UX Best Practices](https://www.pencilandpaper.io/articles/search-ux)
- [Search UX Best Practices for 2026](https://www.designrush.com/best-designs/websites/trends/search-ux-best-practices)
- [Advanced Search UI for Enterprise Products](https://cieden.com/book/atoms/search/advanced-search-ui)

### Notifications
- [Design Guidelines For Better Notifications UX (Smashing Magazine)](https://www.smashingmagazine.com/2025/07/design-guidelines-better-notifications-ux/)
- [Notification Design Guide (Toptal)](https://www.toptal.com/designers/ux/notification-design)
- [Toast Notification Best Practices (LogRocket)](https://blog.logrocket.com/ux-design/toast-notifications/)
- [Snackbar vs Toast in Design Systems](https://medium.com/design-bootcamp/ux-blueprint-01-snackbar-vs-toast-decoding-the-subtle-differences-in-design-systems-8ad82ff61115)
- [PatternFly Notification Drawer](https://www.patternfly.org/components/notification-drawer/design-guidelines/)
- [PatternFly Notification Badge](https://www.patternfly.org/components/notification-badge/design-guidelines/)
- [Carbon Design System Notification Pattern](https://carbondesignsystem.com/patterns/notification-pattern/)

### Page Structure & Layout
- [PatternFly Primary-Detail Pattern](https://www.patternfly.org/patterns/primary-detail/design-guidelines/)
- [Cloudscape Split View Pattern](https://cloudscape.design/patterns/resource-management/view/split-view/)
- [Side Drawer UI Guide](https://www.designmonks.co/blog/side-drawer-ui)
- [How to Design Backoffice Systems](https://aronnegyesi.medium.com/how-to-design-backoffice-systems-b39cc1b196e2)

### Keyboard Shortcuts
- [The UX of Keyboard Shortcuts](https://medium.com/design-bootcamp/the-art-of-keyboard-shortcuts-designing-for-speed-and-efficiency-9afd717fc7ed)
- [Keyboard Shortcuts Design Pattern](https://ui-patterns.com/patterns/keyboard-shortcuts)
- [Enterprise UX Design Trends 2025](https://www.aufaitux.com/blog/enterprise-ux-design-trends/)

### Wayfinding & Breadcrumbs
- [Designing Better Breadcrumbs UX](https://smart-interface-design-patterns.com/articles/breadcrumbs-ux/)
- [Breadcrumbs: 11 Design Guidelines (NN/g)](https://www.nngroup.com/articles/breadcrumbs/)
- [Breadcrumb Pattern](https://uxpatterns.dev/patterns/navigation/breadcrumb)

### Accessibility
- [WAI-ARIA Landmark Regions (W3C)](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/)
- [ARIA Navigation Role (MDN)](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/navigation_role)
- [Accessible Toast Notifications](https://www.scottohara.me/blog/2019/07/08/a-toast-to-a11y-toasts.html)

### Information Density
- [Designing for Data Density](https://paulwallas.medium.com/designing-for-data-density-what-most-ui-tutorials-wont-teach-you-091b3e9b51f4)
- [Designing for Information Density (UX Collective)](https://uxdesign.cc/designing-for-information-density-69775165a18e)
- [Density Foundations (Basis Design System)](https://design.basis.com/foundations/density)

### Brand & Theming
- [Guide to White Label Integration for Enterprises](https://boomi.com/blog/enterprise-guide-to-whitelabel-integration/)
- [Building a White Label App (2026)](https://relevant.software/blog/building-white-label-app-architecture/)
