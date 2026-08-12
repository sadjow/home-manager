# Enterprise Application Accessibility: WCAG 2.2 Best Practices (2024-2026)

Comprehensive reference for accessibility patterns specific to enterprise/back-office information systems. Covers ADA/WCAG 2.2 compliance with emphasis on complex widgets, keyboard navigation, screen reader optimization, and testing strategies unique to enterprise contexts.

---

## Table of Contents

1. [WCAG 2.2 Enterprise-Relevant Criteria](#1-wcag-22-enterprise-relevant-criteria)
2. [Complex Widget Accessibility](#2-complex-widget-accessibility)
3. [Enterprise-Specific ARIA Patterns](#3-enterprise-specific-aria-patterns)
4. [Keyboard Navigation](#4-keyboard-navigation)
5. [High Contrast and Forced Colors](#5-high-contrast-and-forced-colors)
6. [Screen Reader Optimization](#6-screen-reader-optimization)
7. [Color, Contrast, and Data Visualization](#7-color-contrast-and-data-visualization)
8. [Cognitive Accessibility](#8-cognitive-accessibility)
9. [Testing Strategy](#9-testing-strategy)

---

## 1. WCAG 2.2 Enterprise-Relevant Criteria

WCAG 2.2 (W3C Recommendation, October 2023; ISO/IEC 40500:2025) adds nine success criteria. The following are especially impactful for enterprise applications:

### 1.1 Target Size (Minimum) -- SC 2.5.8 (Level AA)

All interactive targets must be at least **24x24 CSS pixels**, or have sufficient spacing from adjacent targets. Critical for dense enterprise UIs with many buttons, icons, and action controls.

```css
/* Ensure minimum target size for icon buttons */
.action-icon-btn {
  min-width: 24px;
  min-height: 24px;
  padding: 4px;
}

/* For inline actions in tables, use padding to meet 24px minimum */
.table-action {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 24px;
  min-height: 24px;
}
```

### 1.2 Dragging Movements -- SC 2.5.7 (Level AA)

Every drag operation must have a single-pointer alternative. Affects kanban boards, sortable lists, panel resizers, and file uploads.

```html
<!-- Sortable list with drag AND button alternatives -->
<ul role="listbox" aria-label="Task priority">
  <li role="option" draggable="true" aria-grabbed="false">
    <span class="item-label">Review PR #42</span>
    <span class="reorder-controls">
      <button aria-label="Move Review PR #42 up">Up</button>
      <button aria-label="Move Review PR #42 down">Down</button>
    </span>
  </li>
</ul>
```

### 1.3 Focus Appearance -- SC 2.4.11 (Level AA)

Focus indicators must have a minimum area of the focused element's perimeter times 2 CSS pixels, with at least 3:1 contrast against adjacent colors.

```css
/* Enterprise-grade focus indicator */
:focus-visible {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
  border-radius: 2px;
}

/* High-visibility for dark backgrounds */
.dark-panel :focus-visible {
  outline: 2px solid #7cb3ff;
  outline-offset: 2px;
  box-shadow: 0 0 0 4px rgba(0, 95, 204, 0.3);
}
```

### 1.4 Consistent Help -- SC 3.2.6 (Level A)

Help mechanisms (chat widgets, contact links, FAQs) must appear in the same relative order across pages. Enterprise apps should place help consistently in the header or sidebar.

### 1.5 Redundant Entry -- SC 3.3.7 (Level A)

Information previously entered by the user must be auto-populated or selectable. Applies to multi-step enterprise workflows (onboarding forms, multi-page wizards, repeated address fields).

---

## 2. Complex Widget Accessibility

### 2.1 Data Grids

Data grids are the backbone of enterprise UIs. The W3C APG grid pattern treats them as two-dimensional navigable containers.

#### HTML Structure with ARIA

```html
<div role="grid"
     aria-label="Employee directory"
     aria-rowcount="1250"
     aria-colcount="6">

  <!-- Column headers -->
  <div role="row" aria-rowindex="1">
    <span role="columnheader" aria-colindex="1" aria-sort="ascending">
      <button>
        Name
        <svg aria-hidden="true" class="sort-icon"><use href="#icon-sort-asc"/></svg>
      </button>
    </span>
    <span role="columnheader" aria-colindex="2" aria-sort="none">
      <button>
        Department
        <svg aria-hidden="true" class="sort-icon"><use href="#icon-sort-none"/></svg>
      </button>
    </span>
    <span role="columnheader" aria-colindex="3">Email</span>
    <span role="columnheader" aria-colindex="4">Status</span>
    <span role="columnheader" aria-colindex="5">Role</span>
    <span role="columnheader" aria-colindex="6">Actions</span>
  </div>

  <!-- Data rows (virtualized -- only visible rows in DOM) -->
  <div role="row" aria-rowindex="2" aria-selected="false">
    <span role="gridcell" aria-colindex="1" tabindex="-1">Jane Smith</span>
    <span role="gridcell" aria-colindex="2" tabindex="-1">Engineering</span>
    <span role="gridcell" aria-colindex="3" tabindex="-1">
      <a href="mailto:jane@co.com">jane@co.com</a>
    </span>
    <span role="gridcell" aria-colindex="4" tabindex="-1">
      <span class="status status--active">
        <svg aria-hidden="true"><use href="#icon-check"/></svg>
        Active
      </span>
    </span>
    <span role="gridcell" aria-colindex="5" tabindex="-1">Senior Engineer</span>
    <span role="gridcell" aria-colindex="6" tabindex="-1">
      <button aria-label="Edit Jane Smith" tabindex="-1">Edit</button>
      <button aria-label="Delete Jane Smith" tabindex="-1">Delete</button>
    </span>
  </div>
</div>

<!-- Live region for sort announcements -->
<div aria-live="polite" aria-atomic="true" class="sr-only" id="grid-status"></div>
```

#### Keyboard Interaction (Data Grid)

| Key | Action |
|-----|--------|
| `Right Arrow` | Move focus one cell right |
| `Left Arrow` | Move focus one cell left |
| `Down Arrow` | Move focus one cell down |
| `Up Arrow` | Move focus one cell up |
| `Home` | Move focus to first cell in row |
| `End` | Move focus to last cell in row |
| `Ctrl + Home` | Move focus to first cell of first row |
| `Ctrl + End` | Move focus to last cell of last row |
| `Page Down` | Scroll down by visible page height |
| `Page Up` | Scroll up by visible page height |
| `Space` | Select current row (if selection enabled) |
| `Shift + Space` | Select range from anchor to current |
| `Ctrl + Space` | Toggle selection of current row |
| `Ctrl + A` | Select all rows |
| `Enter` | Activate cell content / enter edit mode |
| `F2` | Toggle edit mode on editable cells |
| `Escape` | Exit edit mode, restore previous value |

#### JavaScript: Roving Tabindex for Grid Navigation

```javascript
class AccessibleGrid {
  constructor(gridEl) {
    this.grid = gridEl;
    this.rows = [];
    this.currentRow = 0;
    this.currentCol = 0;
    this.init();
  }

  init() {
    this.rows = Array.from(this.grid.querySelectorAll('[role="row"]'));
    this.getCells(0)[0]?.setAttribute('tabindex', '0');

    this.grid.addEventListener('keydown', (e) => this.handleKeydown(e));
  }

  getCells(rowIndex) {
    return Array.from(
      this.rows[rowIndex]?.querySelectorAll('[role="gridcell"], [role="columnheader"]') ?? []
    );
  }

  moveFocus(newRow, newCol) {
    const currentCells = this.getCells(this.currentRow);
    const currentCell = currentCells[this.currentCol];
    currentCell?.setAttribute('tabindex', '-1');

    const clampedRow = Math.max(0, Math.min(newRow, this.rows.length - 1));
    const targetCells = this.getCells(clampedRow);
    const clampedCol = Math.max(0, Math.min(newCol, targetCells.length - 1));

    const targetCell = targetCells[clampedCol];
    targetCell?.setAttribute('tabindex', '0');
    targetCell?.focus();

    this.currentRow = clampedRow;
    this.currentCol = clampedCol;
  }

  handleKeydown(e) {
    const { key, ctrlKey, shiftKey } = e;
    const totalCols = this.getCells(this.currentRow).length;

    const actions = {
      ArrowRight: () => this.moveFocus(this.currentRow, this.currentCol + 1),
      ArrowLeft:  () => this.moveFocus(this.currentRow, this.currentCol - 1),
      ArrowDown:  () => this.moveFocus(this.currentRow + 1, this.currentCol),
      ArrowUp:    () => this.moveFocus(this.currentRow - 1, this.currentCol),
      Home:       () => this.moveFocus(ctrlKey ? 0 : this.currentRow, 0),
      End:        () => this.moveFocus(
        ctrlKey ? this.rows.length - 1 : this.currentRow,
        totalCols - 1
      ),
      PageDown:   () => this.moveFocus(
        Math.min(this.currentRow + this.pageSize(), this.rows.length - 1),
        this.currentCol
      ),
      PageUp:     () => this.moveFocus(
        Math.max(this.currentRow - this.pageSize(), 0),
        this.currentCol
      ),
    };

    if (actions[key]) {
      e.preventDefault();
      actions[key]();
    }
  }

  pageSize() {
    const gridRect = this.grid.getBoundingClientRect();
    const rowHeight = this.rows[1]?.getBoundingClientRect().height ?? 40;
    return Math.floor(gridRect.height / rowHeight);
  }
}
```

### 2.2 Tree Views

File explorers, org charts, and navigation hierarchies in enterprise apps.

#### HTML Structure

```html
<h3 id="tree-label">Project Files</h3>
<ul role="tree" aria-labelledby="tree-label">
  <li role="treeitem"
      aria-expanded="true"
      aria-level="1"
      aria-setsize="3"
      aria-posinset="1"
      tabindex="0">
    <span class="tree-node">
      <svg aria-hidden="true"><use href="#icon-folder-open"/></svg>
      src
    </span>
    <ul role="group">
      <li role="treeitem"
          aria-level="2"
          aria-setsize="2"
          aria-posinset="1"
          tabindex="-1">
        <span class="tree-node">
          <svg aria-hidden="true"><use href="#icon-file"/></svg>
          index.ts
        </span>
      </li>
      <li role="treeitem"
          aria-expanded="false"
          aria-level="2"
          aria-setsize="2"
          aria-posinset="2"
          tabindex="-1">
        <span class="tree-node">
          <svg aria-hidden="true"><use href="#icon-folder"/></svg>
          components
        </span>
        <!-- Children hidden because aria-expanded="false" -->
        <ul role="group" hidden>
          <li role="treeitem" aria-level="3" tabindex="-1">
            <span class="tree-node">Button.tsx</span>
          </li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
```

#### Keyboard Interaction (Tree View)

| Key | Action |
|-----|--------|
| `Right Arrow` | Expand closed node; if open, move to first child; no action on leaf |
| `Left Arrow` | Collapse open node; if closed/leaf, move to parent |
| `Down Arrow` | Move to next visible treeitem |
| `Up Arrow` | Move to previous visible treeitem |
| `Home` | Move to first node |
| `End` | Move to last visible node |
| `Enter` | Activate the node (open file, navigate, etc.) |
| `Space` | Toggle selection (in multi-select trees) |
| `*` (asterisk) | Expand all siblings at current level |
| Type-ahead | Focus the next node matching typed characters |

### 2.3 Accessible Drag and Drop

Enterprise kanban boards, task prioritization, and layout customization.

#### Keyboard-Driven Alternative Pattern

```html
<!-- Kanban column with accessible drag and drop -->
<div role="listbox"
     aria-label="In Progress tasks"
     aria-describedby="dnd-instructions">
  <div role="option"
       aria-selected="false"
       tabindex="0"
       aria-describedby="dnd-hint"
       data-draggable="true">
    <span class="task-title">Implement search feature</span>
    <div class="task-actions">
      <button aria-label="Move Implement search feature to previous column">
        <svg aria-hidden="true"><use href="#icon-arrow-left"/></svg>
      </button>
      <button aria-label="Move Implement search feature up">
        <svg aria-hidden="true"><use href="#icon-arrow-up"/></svg>
      </button>
      <button aria-label="Move Implement search feature down">
        <svg aria-hidden="true"><use href="#icon-arrow-down"/></svg>
      </button>
      <button aria-label="Move Implement search feature to next column">
        <svg aria-hidden="true"><use href="#icon-arrow-right"/></svg>
      </button>
    </div>
  </div>
</div>

<div id="dnd-instructions" class="sr-only">
  Press Enter to start dragging. Use Tab to navigate between drop targets.
  Press Enter to drop or Escape to cancel.
</div>
<div id="dnd-hint" class="sr-only">Draggable item. Press Enter to drag.</div>

<!-- Live region for drag announcements -->
<div id="dnd-live" aria-live="assertive" aria-atomic="true" class="sr-only"></div>
```

#### Drag and Drop Announcements

```javascript
function announceDragStart(item, liveRegion) {
  liveRegion.textContent =
    `Started dragging ${item.label}. Use Tab to navigate to drop targets. ` +
    `Press Enter to drop or Escape to cancel.`;
}

function announceDragOver(item, target, liveRegion) {
  liveRegion.textContent =
    `${item.label} over ${target.label}. Press Enter to drop here.`;
}

function announceDropComplete(item, target, liveRegion) {
  liveRegion.textContent =
    `${item.label} dropped into ${target.label}.`;
}

function announceDragCancel(item, liveRegion) {
  liveRegion.textContent =
    `Dragging cancelled. ${item.label} returned to original position.`;
}
```

### 2.4 Resizable Split Panes

IDE-style layouts, admin dashboards with adjustable panels.

```html
<div class="split-layout">
  <div id="left-panel"
       role="region"
       aria-label="Navigation panel"
       style="flex-basis: 300px;">
    <!-- Panel content -->
  </div>

  <div role="separator"
       aria-orientation="vertical"
       aria-valuenow="300"
       aria-valuemin="150"
       aria-valuemax="600"
       aria-label="Resize navigation panel"
       tabindex="0">
    <span class="resize-handle" aria-hidden="true"></span>
  </div>

  <div id="right-panel"
       role="region"
       aria-label="Main content">
    <!-- Panel content -->
  </div>
</div>
```

#### Separator Keyboard Interaction

| Key | Action |
|-----|--------|
| `Left Arrow` or `Up Arrow` | Decrease panel size by small step |
| `Right Arrow` or `Down Arrow` | Increase panel size by small step |
| `Page Up` | Decrease panel size by large step |
| `Page Down` | Increase panel size by large step |
| `Home` | Collapse to minimum size |
| `End` | Expand to maximum size |
| `Enter` | Toggle between previous size and collapsed |

```javascript
class AccessibleSplitter {
  constructor(separator, panel) {
    this.separator = separator;
    this.panel = panel;
    this.step = 10;
    this.largeStep = 50;
    this.min = parseInt(separator.getAttribute('aria-valuemin'));
    this.max = parseInt(separator.getAttribute('aria-valuemax'));
    this.previousSize = null;

    this.separator.addEventListener('keydown', (e) => this.handleKey(e));
  }

  resize(newSize) {
    const clamped = Math.max(this.min, Math.min(newSize, this.max));
    this.panel.style.flexBasis = `${clamped}px`;
    this.separator.setAttribute('aria-valuenow', String(clamped));
  }

  handleKey(e) {
    const current = parseInt(this.separator.getAttribute('aria-valuenow'));

    const actions = {
      ArrowLeft:  () => this.resize(current - this.step),
      ArrowRight: () => this.resize(current + this.step),
      PageUp:     () => this.resize(current - this.largeStep),
      PageDown:   () => this.resize(current + this.largeStep),
      Home:       () => this.resize(this.min),
      End:        () => this.resize(this.max),
      Enter:      () => {
        if (current <= this.min) {
          this.resize(this.previousSize ?? (this.max / 2));
        } else {
          this.previousSize = current;
          this.resize(this.min);
        }
      },
    };

    if (actions[e.key]) {
      e.preventDefault();
      actions[e.key]();
    }
  }
}
```

---

## 3. Enterprise-Specific ARIA Patterns

### 3.1 Sortable Tables with Screen Readers

```html
<table aria-label="Invoices">
  <caption>
    Invoice list.
    <span class="sr-only">
      Buttons in column headers sort the table. Current sort: Amount, descending.
    </span>
  </caption>
  <thead>
    <tr>
      <th scope="col" aria-sort="none">
        <button aria-describedby="sort-help">
          Invoice #
          <span class="sort-indicator" aria-hidden="true"></span>
        </button>
      </th>
      <th scope="col" aria-sort="descending">
        <button aria-describedby="sort-help">
          Amount
          <span class="sort-indicator sort-desc" aria-hidden="true"></span>
        </button>
      </th>
      <th scope="col" aria-sort="none">
        <button aria-describedby="sort-help">
          Date
          <span class="sort-indicator" aria-hidden="true"></span>
        </button>
      </th>
      <th scope="col">Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>INV-2025-001</td>
      <td>$12,450.00</td>
      <td><time datetime="2025-01-15">Jan 15, 2025</time></td>
      <td>
        <span class="status status--paid">
          <svg aria-hidden="true"><use href="#icon-check-circle"/></svg>
          Paid
        </span>
      </td>
    </tr>
  </tbody>
</table>
<div id="sort-help" class="sr-only">Activates sorting for this column</div>
<div id="sort-live" aria-live="polite" class="sr-only"></div>
```

#### Sort Handler with Screen Reader Announcement

```javascript
function handleSort(columnHeader, direction) {
  // Remove aria-sort from all headers
  document.querySelectorAll('th[aria-sort]').forEach(th => {
    th.setAttribute('aria-sort', 'none');
  });

  columnHeader.setAttribute('aria-sort', direction);

  const columnName = columnHeader.querySelector('button').textContent.trim();
  const liveRegion = document.getElementById('sort-live');
  liveRegion.textContent = `Table sorted by ${columnName}, ${direction}`;

  // Clear after announcement
  setTimeout(() => { liveRegion.textContent = ''; }, 1500);
}
```

### 3.2 Filterable Lists with Search

Common in enterprise: user pickers, tag selectors, permission assignments.

```html
<div class="filterable-list" role="group" aria-labelledby="filter-label">
  <label id="filter-label" for="user-search">Assign team members</label>
  <div role="combobox"
       aria-expanded="true"
       aria-haspopup="listbox"
       aria-owns="user-listbox">
    <input id="user-search"
           type="text"
           role="searchbox"
           aria-autocomplete="list"
           aria-controls="user-listbox"
           aria-activedescendant=""
           placeholder="Search by name or email">
    <span id="filter-count" aria-live="polite" class="sr-only">
      5 results available
    </span>
  </div>

  <ul id="user-listbox"
      role="listbox"
      aria-multiselectable="true"
      aria-label="Team members">
    <li role="option"
        id="user-1"
        aria-selected="true"
        tabindex="-1">
      <svg aria-hidden="true"><use href="#icon-check"/></svg>
      <span class="user-name">Alice Johnson</span>
      <span class="user-email">alice@company.com</span>
    </li>
    <li role="option"
        id="user-2"
        aria-selected="false"
        tabindex="-1">
      <span class="user-name">Bob Williams</span>
      <span class="user-email">bob@company.com</span>
    </li>
  </ul>

  <!-- Selected tags (removable) -->
  <div aria-label="Selected team members" role="group">
    <span role="listitem">
      Alice Johnson
      <button aria-label="Remove Alice Johnson from selection">
        <svg aria-hidden="true"><use href="#icon-x"/></svg>
      </button>
    </span>
  </div>
</div>
```

#### Filter Results Announcement

```javascript
function updateFilterResults(count) {
  const announcement = count === 0
    ? 'No results found'
    : `${count} result${count === 1 ? '' : 's'} available`;

  document.getElementById('filter-count').textContent = announcement;
}
```

### 3.3 Status Dashboard Widgets

Enterprise monitoring dashboards with real-time metrics.

```html
<section aria-labelledby="dashboard-heading">
  <h2 id="dashboard-heading">System Health Dashboard</h2>

  <!-- Status card with live data -->
  <div role="status"
       aria-label="Server uptime"
       aria-live="polite"
       aria-atomic="true"
       class="metric-card">
    <span class="metric-label">Server Uptime</span>
    <span class="metric-value">99.97%</span>
    <span class="metric-trend" aria-label="trending up by 0.02%">
      <svg aria-hidden="true"><use href="#icon-trend-up"/></svg>
      +0.02%
    </span>
  </div>

  <!-- Alert status (uses assertive only for critical) -->
  <div role="alert"
       class="alert-card alert--critical">
    <svg aria-hidden="true"><use href="#icon-warning"/></svg>
    <span>Database connection pool at 95% capacity</span>
    <button>Acknowledge</button>
  </div>

  <!-- Progress indicator for long-running operations -->
  <div role="progressbar"
       aria-valuenow="67"
       aria-valuemin="0"
       aria-valuemax="100"
       aria-label="Data migration progress: 67%">
    <div class="progress-fill" style="width: 67%"></div>
  </div>

  <!-- Aggregate status region (batched updates) -->
  <div id="batch-status" aria-live="polite" aria-atomic="true" class="sr-only"></div>
</section>
```

#### Batched Live Region Updates

```javascript
class DashboardAnnouncer {
  constructor(liveRegionId) {
    this.liveRegion = document.getElementById(liveRegionId);
    this.pendingUpdates = [];
    this.debounceTimer = null;
    this.debounceMs = 3000;
  }

  queueUpdate(message) {
    this.pendingUpdates.push(message);
    clearTimeout(this.debounceTimer);
    this.debounceTimer = setTimeout(() => this.flush(), this.debounceMs);
  }

  flush() {
    if (this.pendingUpdates.length === 0) return;

    const summary = this.pendingUpdates.length === 1
      ? this.pendingUpdates[0]
      : `${this.pendingUpdates.length} status updates: ${this.pendingUpdates.join('. ')}`;

    this.liveRegion.textContent = summary;
    this.pendingUpdates = [];

    setTimeout(() => { this.liveRegion.textContent = ''; }, 5000);
  }
}

// Usage: avoid flooding screen readers with rapid metric changes
const announcer = new DashboardAnnouncer('batch-status');
announcer.queueUpdate('CPU usage exceeded 80%');
announcer.queueUpdate('Memory usage stable at 65%');
// After 3s debounce: "2 status updates: CPU usage exceeded 80%. Memory usage stable at 65%."
```

### 3.4 Multi-Select with Search (Tag Picker / Token Input)

```html
<div class="token-input-wrapper">
  <label id="tags-label" for="tags-input">Assign labels</label>
  <div class="token-input-container"
       role="combobox"
       aria-expanded="false"
       aria-haspopup="listbox"
       aria-owns="tags-suggestions">

    <!-- Selected tokens -->
    <span class="token" role="listitem">
      bug
      <button aria-label="Remove bug label" tabindex="-1">x</button>
    </span>
    <span class="token" role="listitem">
      priority-high
      <button aria-label="Remove priority-high label" tabindex="-1">x</button>
    </span>

    <input id="tags-input"
           type="text"
           aria-autocomplete="list"
           aria-controls="tags-suggestions"
           aria-activedescendant=""
           aria-describedby="tags-selection-status">
  </div>

  <ul id="tags-suggestions"
      role="listbox"
      aria-label="Available labels"
      hidden>
    <li role="option" id="tag-enhancement" aria-selected="false">enhancement</li>
    <li role="option" id="tag-documentation" aria-selected="false">documentation</li>
    <li role="option" id="tag-help-wanted" aria-selected="false">help-wanted</li>
  </ul>

  <div id="tags-selection-status" aria-live="polite" class="sr-only">
    2 labels selected: bug, priority-high
  </div>
</div>
```

---

## 4. Keyboard Navigation

### 4.1 Roving Tabindex Pattern

For composite widgets (toolbars, tab lists, grids), only one child is in the tab order at a time.

```javascript
class RovingTabindex {
  constructor(container, itemSelector, orientation = 'horizontal') {
    this.container = container;
    this.itemSelector = itemSelector;
    this.orientation = orientation;
    this.items = Array.from(container.querySelectorAll(itemSelector));
    this.currentIndex = 0;

    this.init();
  }

  get nextKey() {
    return this.orientation === 'horizontal' ? 'ArrowRight' : 'ArrowDown';
  }

  get prevKey() {
    return this.orientation === 'horizontal' ? 'ArrowLeft' : 'ArrowUp';
  }

  init() {
    this.items.forEach((item, i) => {
      item.setAttribute('tabindex', i === 0 ? '0' : '-1');
    });

    this.container.addEventListener('keydown', (e) => this.handleKeydown(e));
  }

  focus(index) {
    this.items[this.currentIndex].setAttribute('tabindex', '-1');
    this.currentIndex = index;
    this.items[this.currentIndex].setAttribute('tabindex', '0');
    this.items[this.currentIndex].focus();
  }

  handleKeydown(e) {
    const { key } = e;
    const lastIndex = this.items.length - 1;

    const actions = {
      [this.nextKey]: () => this.focus(
        this.currentIndex < lastIndex ? this.currentIndex + 1 : 0
      ),
      [this.prevKey]: () => this.focus(
        this.currentIndex > 0 ? this.currentIndex - 1 : lastIndex
      ),
      Home: () => this.focus(0),
      End:  () => this.focus(lastIndex),
    };

    if (actions[key]) {
      e.preventDefault();
      actions[key]();
    }
  }
}

// Usage
const toolbar = new RovingTabindex(
  document.querySelector('[role="toolbar"]'),
  'button',
  'horizontal'
);
```

### 4.2 Focus Management in Single-Page Applications

Route changes in SPAs do not trigger a page load, so screen readers do not announce navigation. You must manage this manually.

#### Route Change Announcer

```html
<!-- Place at the top of your app, always in the DOM -->
<div id="route-announcer"
     role="status"
     aria-live="assertive"
     aria-atomic="true"
     class="sr-only"></div>
```

```javascript
class RouteAnnouncer {
  constructor() {
    this.announcer = document.getElementById('route-announcer');
    this.isFirstLoad = true;
  }

  onRouteChange(pageTitle) {
    // Skip announcement on initial page load (browser handles that)
    if (this.isFirstLoad) {
      this.isFirstLoad = false;
      return;
    }

    document.title = pageTitle;

    this.announcer.textContent = '';
    requestAnimationFrame(() => {
      this.announcer.textContent = `Navigated to ${pageTitle}`;
    });

    // Move focus to the main heading
    const heading = document.querySelector('main h1');
    if (heading) {
      heading.setAttribute('tabindex', '-1');
      heading.focus();
      heading.addEventListener('blur', () => {
        heading.removeAttribute('tabindex');
      }, { once: true });
    }
  }
}
```

### 4.3 Focus Trap for Modals and Dialogs

Enterprise apps heavily use modal dialogs for confirmations, forms, and detail views.

```javascript
class FocusTrap {
  constructor(container) {
    this.container = container;
    this.previousFocus = null;
  }

  activate() {
    this.previousFocus = document.activeElement;
    this.container.addEventListener('keydown', this.handleTab);

    const focusable = this.getFocusableElements();
    if (focusable.length > 0) {
      focusable[0].focus();
    }
  }

  deactivate() {
    this.container.removeEventListener('keydown', this.handleTab);
    this.previousFocus?.focus();
  }

  handleTab = (e) => {
    if (e.key !== 'Tab') return;

    const focusable = this.getFocusableElements();
    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  };

  getFocusableElements() {
    const selector = [
      'a[href]',
      'button:not([disabled])',
      'input:not([disabled]):not([type="hidden"])',
      'select:not([disabled])',
      'textarea:not([disabled])',
      '[tabindex]:not([tabindex="-1"])',
    ].join(', ');

    return Array.from(this.container.querySelectorAll(selector))
      .filter(el => !el.closest('[hidden]') && !el.closest('[aria-hidden="true"]'));
  }
}
```

### 4.4 Skip Links for Enterprise Layouts

Enterprise apps often have sidebars, toolbars, and breadcrumbs before the main content.

```html
<body>
  <nav class="skip-links" aria-label="Skip navigation">
    <a href="#main-content" class="skip-link">Skip to main content</a>
    <a href="#sidebar-nav" class="skip-link">Skip to navigation</a>
    <a href="#search" class="skip-link">Skip to search</a>
  </nav>

  <header role="banner"><!-- App bar --></header>
  <nav id="sidebar-nav" role="navigation" aria-label="Main navigation">
    <!-- Sidebar -->
  </nav>
  <main id="main-content" tabindex="-1">
    <!-- Main content -->
  </main>
</body>
```

```css
.skip-link {
  position: absolute;
  top: -100%;
  left: 16px;
  z-index: 10000;
  padding: 8px 16px;
  background: #005fcc;
  color: #fff;
  text-decoration: none;
  border-radius: 0 0 4px 4px;
  font-weight: 600;
}

.skip-link:focus {
  top: 0;
}
```

---

## 5. High Contrast and Forced Colors

Windows High Contrast Mode (now standardized as Forced Colors Mode) is widely used in enterprise environments, especially in government and healthcare.

### 5.1 CSS System Colors Reference

| Keyword | Use Case |
|---------|----------|
| `Canvas` | Page background |
| `CanvasText` | Regular text |
| `LinkText` | Hyperlinks |
| `ButtonFace` | Button backgrounds |
| `ButtonText` | Button text |
| `ButtonBorder` | Button borders |
| `Field` | Input field backgrounds |
| `FieldText` | Input field text |
| `Highlight` | Selected item background |
| `HighlightText` | Selected item text |
| `GrayText` | Disabled text |
| `Mark` | Highlighted text background |
| `MarkText` | Highlighted text foreground |

### 5.2 Forced Colors Adaptation

```css
/* Shadows and gradients are removed in forced colors -- use borders instead */
.card {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid transparent;
}

@media (forced-colors: active) {
  .card {
    border-color: CanvasText;
  }
}

/* Preserve custom focus indicators */
.interactive-element:focus-visible {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
}

@media (forced-colors: active) {
  .interactive-element:focus-visible {
    outline-color: Highlight;
  }
}

/* Status badges that rely on color need borders/text in forced colors */
.badge {
  background-color: #e8f5e9;
  color: #2e7d32;
  border: 1px solid transparent;
  border-radius: 4px;
  padding: 2px 8px;
}

.badge--warning {
  background-color: #fff3e0;
  color: #e65100;
}

.badge--error {
  background-color: #fce4ec;
  color: #c62828;
}

@media (forced-colors: active) {
  .badge {
    border-color: CanvasText;
    forced-color-adjust: none;
    background: Canvas;
    color: CanvasText;
  }

  .badge--warning {
    border-color: ButtonText;
    border-style: dashed;
  }

  .badge--error {
    border-color: LinkText;
    border-width: 2px;
  }
}

/* Data grid row selection in forced colors */
.grid-row[aria-selected="true"] {
  background: #e3f2fd;
}

@media (forced-colors: active) {
  .grid-row[aria-selected="true"] {
    background: Highlight;
    color: HighlightText;
  }

  .grid-row[aria-selected="true"] a {
    color: HighlightText;
  }
}

/* Disabled states must use GrayText */
@media (forced-colors: active) {
  button:disabled,
  input:disabled {
    color: GrayText;
    border-color: GrayText;
  }
}

/* SVG icons in forced colors need explicit color assignment */
@media (forced-colors: active) {
  .icon {
    forced-color-adjust: auto;
  }

  .icon--action {
    fill: ButtonText;
  }

  .icon--link {
    fill: LinkText;
  }

  .icon--disabled {
    fill: GrayText;
  }
}

/* Separator / divider lines */
.divider {
  border-top: 1px solid #e0e0e0;
}

@media (forced-colors: active) {
  .divider {
    border-top-color: CanvasText;
  }
}
```

### 5.3 The `forced-color-adjust` Property

```css
/* Allow an element to bypass forced colors (use sparingly) */
.brand-logo {
  forced-color-adjust: none;
}

/* Preserve custom chart colors -- but add borders for visibility */
@media (forced-colors: active) {
  .chart-container {
    forced-color-adjust: none;
  }

  .chart-container svg path {
    stroke: CanvasText;
    stroke-width: 1px;
  }
}
```

### 5.4 Increased Contrast Preference

Separate from forced colors, users may prefer increased contrast without full forced-color mode.

```css
@media (prefers-contrast: more) {
  :root {
    --border-color: #333;
    --text-secondary: #444;
    --bg-hover: #ddd;
  }

  .subtle-text {
    color: var(--text-secondary);
  }

  .table-row:hover {
    background-color: var(--bg-hover);
  }
}
```

---

## 6. Screen Reader Optimization

### 6.1 Live Regions for Real-Time Data

#### Choosing the Right Strategy

| Update Type | `aria-live` | `role` | Frequency |
|-------------|-------------|--------|-----------|
| Form validation | `polite` | `status` | On blur / submit |
| Toast notification | `polite` | `status` | On event |
| Critical alert | `assertive` | `alert` | Rare |
| Loading state | `polite` | `status` | Start/end |
| Real-time metric | `polite` | (none) | Debounced (3-5s) |
| Chat message | `polite` | `log` | On receive |
| Error banner | `assertive` | `alert` | On error |
| Progress | `polite` | `progressbar` | On milestones |

#### Implementation Patterns

```html
<!-- role="status" implies aria-live="polite" -->
<div role="status" class="sr-only" id="search-status">
  Showing 42 of 1,250 results
</div>

<!-- role="alert" implies aria-live="assertive" -->
<div role="alert" id="save-error" hidden>
  Failed to save changes. Please try again.
</div>

<!-- role="log" for sequential updates (chat, activity feed) -->
<div role="log" aria-label="Activity log" aria-live="polite">
  <div>10:42 AM - Jane approved PR #127</div>
  <div>10:45 AM - Build #3847 completed</div>
</div>

<!-- aria-busy prevents premature announcements during bulk updates -->
<div id="results-container"
     role="region"
     aria-label="Search results"
     aria-live="polite"
     aria-busy="true">
  <!-- Content loading... -->
</div>
```

```javascript
function setBusy(container, busy) {
  container.setAttribute('aria-busy', String(busy));
}

async function loadResults(container) {
  setBusy(container, true);
  const data = await fetchResults();
  container.innerHTML = renderResults(data);
  setBusy(container, false);
  // Screen reader now announces the updated content
}
```

### 6.2 Meaningful Table Summaries

```html
<table aria-label="Q4 2025 Revenue by Region">
  <caption>
    Quarterly revenue breakdown across 4 regions.
    <span class="sr-only">
      Table has 4 columns: Region, Q3 Revenue, Q4 Revenue, and Change.
      5 rows including totals.
    </span>
  </caption>
  <thead>
    <tr>
      <th scope="col">Region</th>
      <th scope="col">Q3 Revenue</th>
      <th scope="col">Q4 Revenue</th>
      <th scope="col">Change</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">North America</th>
      <td>$2.4M</td>
      <td>$2.8M</td>
      <td>
        <span aria-label="increased by 16.7%">
          <svg aria-hidden="true"><use href="#icon-up"/></svg>
          +16.7%
        </span>
      </td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th scope="row">Total</th>
      <td>$8.1M</td>
      <td>$9.3M</td>
      <td>
        <span aria-label="total increased by 14.8%">+14.8%</span>
      </td>
    </tr>
  </tfoot>
</table>
```

### 6.3 Progressive Disclosure Announcements

Collapsible sections, accordions, and detail panels in enterprise UIs.

```html
<div class="disclosure-group">
  <button aria-expanded="false"
          aria-controls="advanced-filters"
          id="filter-toggle">
    Advanced Filters
    <svg aria-hidden="true" class="chevron"><use href="#icon-chevron"/></svg>
  </button>
  <div id="advanced-filters"
       role="region"
       aria-labelledby="filter-toggle"
       hidden>
    <!-- Filter controls -->
    <div class="filter-row">
      <label for="date-from">Date from</label>
      <input id="date-from" type="date">
    </div>
  </div>
</div>
```

```javascript
function toggleDisclosure(button) {
  const expanded = button.getAttribute('aria-expanded') === 'true';
  const panel = document.getElementById(button.getAttribute('aria-controls'));

  button.setAttribute('aria-expanded', String(!expanded));
  panel.hidden = expanded;

  if (!expanded) {
    const firstFocusable = panel.querySelector(
      'input, select, textarea, button, [tabindex="0"]'
    );
    firstFocusable?.focus();
  }
}
```

---

## 7. Color, Contrast, and Data Visualization

### 7.1 APCA Contrast Algorithm (WCAG 3.0 Draft)

APCA (Accessible Perceptual Contrast Algorithm) replaces the WCAG 2.x contrast ratio with perceptually uniform Lc (Lightness Contrast) values. It better handles dark mode, small text, and real-world reading conditions.

#### APCA Lc Thresholds

| Lc Value | Use Case | Minimum Font |
|----------|----------|--------------|
| **Lc 90** | Body text (preferred) | 14px/400, 18px/300 |
| **Lc 75** | Body text (minimum) | 18px/400, 16px/500, 14px/700 |
| **Lc 60** | Content text (non-body) | 24px/400, 18px/600, 16px/700 |
| **Lc 45** | Headlines, large text | 36px normal, 24px bold |
| **Lc 30** | Placeholder, disabled text | Large sizes only |
| **Lc 15** | Non-semantic decorations | Treat as invisible to many users |

#### Why APCA Matters for Enterprise

- WCAG 2.x overstates contrast for dark text on dark backgrounds (common in dark-mode enterprise themes)
- APCA accounts for font weight and size, allowing lighter weight fonts at larger sizes
- In testing of 500 random color pairs, 50% of WCAG-approved pairs were not actually accessible
- Enterprise dashboards with dense data benefit from APCA's per-use-case thresholds

### 7.2 Status Indicators Without Color Dependency

Every status must be distinguishable by shape, icon, text, or pattern -- not color alone (WCAG 1.4.1).

```html
<!-- Status indicators with icon + text + color -->
<span class="status status--success" role="img" aria-label="Status: Active">
  <svg aria-hidden="true" class="status-icon">
    <use href="#icon-check-circle"/>
  </svg>
  <span class="status-text">Active</span>
</span>

<span class="status status--warning" role="img" aria-label="Status: Pending review">
  <svg aria-hidden="true" class="status-icon">
    <use href="#icon-clock"/>
  </svg>
  <span class="status-text">Pending</span>
</span>

<span class="status status--error" role="img" aria-label="Status: Failed">
  <svg aria-hidden="true" class="status-icon">
    <use href="#icon-x-circle"/>
  </svg>
  <span class="status-text">Failed</span>
</span>

<span class="status status--inactive" role="img" aria-label="Status: Disabled">
  <svg aria-hidden="true" class="status-icon">
    <use href="#icon-minus-circle"/>
  </svg>
  <span class="status-text">Disabled</span>
</span>
```

```css
/* Each status has: distinct icon + distinct color + text label */
.status {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 0.875rem;
  font-weight: 500;
}

.status--success { color: #1b7a3d; }
.status--warning { color: #9a6700; }
.status--error   { color: #c4320a; }
.status--inactive { color: #636c76; }

/* In charts: use pattern fills alongside color */
.chart-bar--success {
  fill: #2da44e;
  /* Stripe pattern for colorblind differentiation */
}

.chart-bar--warning {
  fill: #bf8700;
  /* Dot pattern */
}

.chart-bar--error {
  fill: #cf222e;
  /* Cross-hatch pattern */
}
```

### 7.3 Accessible Data Visualization

```html
<!-- Chart with accessible alternative -->
<figure role="img" aria-labelledby="chart-title chart-desc">
  <figcaption>
    <span id="chart-title">Monthly Active Users (2025)</span>
    <span id="chart-desc" class="sr-only">
      Bar chart showing user growth from 12,000 in January to 18,500 in December,
      with steady increase each month. Largest jump in March (2,100 new users).
    </span>
  </figcaption>

  <!-- Visual chart (canvas/SVG) -->
  <div class="chart-visual" aria-hidden="true">
    <!-- Chart renders here -->
  </div>

  <!-- Accessible data table alternative -->
  <details>
    <summary>View data table</summary>
    <table aria-label="Monthly Active Users data">
      <thead>
        <tr>
          <th scope="col">Month</th>
          <th scope="col">Users</th>
          <th scope="col">Change</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th scope="row">January</th>
          <td>12,000</td>
          <td>--</td>
        </tr>
        <tr>
          <th scope="row">February</th>
          <td>13,200</td>
          <td aria-label="increased by 1,200">+1,200</td>
        </tr>
      </tbody>
    </table>
  </details>
</figure>
```

#### SVG Chart Pattern Fills for Colorblind Users

```html
<svg>
  <defs>
    <!-- Distinct patterns for chart series -->
    <pattern id="pattern-stripe" patternUnits="userSpaceOnUse"
             width="6" height="6" patternTransform="rotate(45)">
      <line x1="0" y1="0" x2="0" y2="6"
            stroke="currentColor" stroke-width="2"/>
    </pattern>

    <pattern id="pattern-dot" patternUnits="userSpaceOnUse"
             width="8" height="8">
      <circle cx="4" cy="4" r="2" fill="currentColor"/>
    </pattern>

    <pattern id="pattern-crosshatch" patternUnits="userSpaceOnUse"
             width="8" height="8">
      <path d="M0,0 L8,8 M8,0 L0,8"
            stroke="currentColor" stroke-width="1.5"/>
    </pattern>
  </defs>

  <!-- Series 1: solid color + stripe pattern -->
  <rect fill="#2da44e" width="40" height="120"/>
  <rect fill="url(#pattern-stripe)" width="40" height="120" opacity="0.3"/>

  <!-- Series 2: solid color + dot pattern -->
  <rect fill="#bf8700" x="50" width="40" height="90"/>
  <rect fill="url(#pattern-dot)" x="50" width="40" height="90" opacity="0.3"/>
</svg>
```

---

## 8. Cognitive Accessibility

### 8.1 Consistent Navigation

Enterprise apps must maintain the same navigation order across all pages (WCAG 3.2.3). Sidebar items, toolbar buttons, and breadcrumbs should appear in the same relative position.

```html
<!-- Consistent landmark structure across all pages -->
<body>
  <a href="#main" class="skip-link">Skip to main content</a>

  <header role="banner">
    <!-- Always: logo, search, user menu -- in this order -->
    <div class="app-bar">
      <a href="/" aria-label="Home">Logo</a>
      <form role="search" aria-label="Global search">
        <input type="search" aria-label="Search">
      </form>
      <nav aria-label="User menu">
        <button aria-haspopup="true" aria-expanded="false">
          Jane Smith
        </button>
      </nav>
    </div>
  </header>

  <nav role="navigation" aria-label="Main navigation">
    <!-- Same order on every page -->
  </nav>

  <main id="main" tabindex="-1">
    <nav aria-label="Breadcrumb">
      <ol>
        <li><a href="/">Home</a></li>
        <li><a href="/projects">Projects</a></li>
        <li aria-current="page">Project Alpha</li>
      </ol>
    </nav>

    <!-- Page content -->
  </main>

  <footer role="contentinfo">
    <!-- Consistent help link placement -->
    <a href="/help">Help</a>
    <a href="/support">Contact Support</a>
  </footer>
</body>
```

### 8.2 Predictable Behavior

No unexpected context changes on focus or input (WCAG 3.2.1, 3.2.2). Enterprise forms should never auto-submit or navigate on selection change.

```html
<!-- Explicit submit required -- never auto-submit on filter change -->
<form aria-label="Report filters">
  <fieldset>
    <legend>Date Range</legend>
    <label for="date-start">Start</label>
    <input id="date-start" type="date">
    <label for="date-end">End</label>
    <input id="date-end" type="date">
  </fieldset>

  <fieldset>
    <legend>Department</legend>
    <select id="department" aria-describedby="dept-hint">
      <option value="">All departments</option>
      <option value="eng">Engineering</option>
      <option value="sales">Sales</option>
    </select>
    <span id="dept-hint" class="hint">
      Select a department to filter results
    </span>
  </fieldset>

  <!-- Explicit action -- no auto-filtering on change -->
  <button type="submit">Apply Filters</button>
  <button type="reset">Clear Filters</button>
</form>
```

### 8.3 Error Prevention and Recovery

For irreversible or high-impact enterprise operations.

```html
<!-- Destructive action confirmation pattern -->
<dialog id="delete-confirm"
        aria-labelledby="dialog-title"
        aria-describedby="dialog-desc">
  <h2 id="dialog-title">Delete 47 records?</h2>
  <p id="dialog-desc">
    This will permanently delete 47 invoice records from Q3 2025.
    This action cannot be undone.
  </p>

  <div class="dialog-actions">
    <!-- Safe action is visually primary; destructive action is secondary -->
    <button autofocus type="button" data-action="cancel">
      Cancel
    </button>
    <button type="button" data-action="confirm" class="btn--danger">
      Delete 47 records
    </button>
  </div>
</dialog>
```

#### Undo Pattern for Reversible Operations

```html
<!-- Toast with undo capability -->
<div role="status" aria-live="polite" class="toast-container">
  <div class="toast">
    <span>3 items moved to archive</span>
    <button class="toast-undo" aria-label="Undo: restore 3 items from archive">
      Undo
    </button>
    <!-- Visual countdown, not announced -->
    <div class="toast-timer" aria-hidden="true"></div>
  </div>
</div>
```

```javascript
class UndoableAction {
  constructor(action, undoAction, timeoutMs = 10000) {
    this.action = action;
    this.undoAction = undoAction;
    this.timeoutMs = timeoutMs;
    this.timer = null;
    this.committed = false;
  }

  execute() {
    this.action();
    this.timer = setTimeout(() => this.commit(), this.timeoutMs);
    return this;
  }

  undo() {
    if (this.committed) return false;
    clearTimeout(this.timer);
    this.undoAction();
    return true;
  }

  commit() {
    this.committed = true;
    clearTimeout(this.timer);
  }
}
```

### 8.4 Reduced Motion

Enterprise users may have vestibular disorders. Respect `prefers-reduced-motion`.

```css
/* Default: use transitions for visual feedback */
.sidebar {
  transition: transform 300ms ease;
}

.data-row-enter {
  animation: fadeSlideIn 200ms ease;
}

/* Respect user preference */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

---

## 9. Testing Strategy

### 9.1 Automated Testing with axe-core

axe-core catches approximately 57% of WCAG issues automatically. It covers WCAG 2.0, 2.1, and 2.2 at levels A, AA, and AAA.

#### Integration in Unit Tests

```javascript
// Jest + jsdom + axe-core
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

describe('InvoiceTable', () => {
  it('has no accessibility violations', async () => {
    const { container } = render(<InvoiceTable invoices={mockInvoices} />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('has no violations when sorted', async () => {
    const { container, getByText } = render(<InvoiceTable invoices={mockInvoices} />);
    fireEvent.click(getByText('Amount'));
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('has no violations with row selected', async () => {
    const { container } = render(<InvoiceTable invoices={mockInvoices} />);
    fireEvent.click(container.querySelector('[role="row"]'));
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

#### Integration in E2E Tests (Playwright)

```javascript
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('Dashboard accessibility', () => {
  test('main dashboard has no violations', async ({ page }) => {
    await page.goto('/dashboard');
    await page.waitForSelector('[role="grid"]');

    const results = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag22aa'])
      .analyze();

    expect(results.violations).toEqual([]);
  });

  test('modal dialog has no violations', async ({ page }) => {
    await page.goto('/settings');
    await page.click('button:text("Delete Account")');
    await page.waitForSelector('[role="dialog"]');

    const results = await new AxeBuilder({ page })
      .include('[role="dialog"]')
      .withTags(['wcag2a', 'wcag2aa'])
      .analyze();

    expect(results.violations).toEqual([]);
  });

  test('data grid keyboard navigation works', async ({ page }) => {
    await page.goto('/users');
    const grid = page.locator('[role="grid"]');
    const firstCell = grid.locator('[role="gridcell"]').first();

    await firstCell.focus();
    await page.keyboard.press('ArrowRight');

    const focused = await page.evaluate(() =>
      document.activeElement?.getAttribute('aria-colindex')
    );
    expect(focused).toBe('2');
  });
});
```

#### CI Pipeline Integration

```yaml
# GitHub Actions example
- name: Run accessibility audit
  run: |
    npx start-server-and-test \
      'yarn dev' http://localhost:3000 \
      'npx playwright test --grep @a11y'

- name: Lighthouse accessibility audit
  uses: treosh/lighthouse-ci-action@v11
  with:
    urls: |
      http://localhost:3000/dashboard
      http://localhost:3000/users
      http://localhost:3000/reports
    budgetPath: .lighthouserc.json
```

### 9.2 Manual Testing Checklist for Enterprise Apps

#### Keyboard Navigation

- [ ] All interactive elements are reachable via Tab/Shift+Tab
- [ ] Tab order follows visual reading order
- [ ] Focus indicator is visible on every focused element (2px minimum, 3:1 contrast)
- [ ] No keyboard traps (except modals with proper escape)
- [ ] Grid navigation works with arrow keys (two-dimensional)
- [ ] Tree view expands/collapses with Right/Left arrows
- [ ] Escape closes modals, dropdowns, popovers, and returns focus
- [ ] Skip links work and target correct landmarks
- [ ] All drag-and-drop operations have keyboard alternatives

#### Screen Reader (test with NVDA + Chrome, VoiceOver + Safari, JAWS + Chrome)

- [ ] Page title announced on navigation
- [ ] Landmarks identified (banner, navigation, main, contentinfo)
- [ ] Headings form logical hierarchy (h1 > h2 > h3)
- [ ] Data tables announce row/column headers when navigating cells
- [ ] Sortable columns announce sort state
- [ ] Form labels are associated with inputs
- [ ] Error messages are announced when they appear
- [ ] Status updates are announced via live regions
- [ ] Loading states are announced (start and end)
- [ ] Modal dialogs announce their title on open
- [ ] Images/icons have appropriate alt text or are hidden from AT

#### Visual

- [ ] Text contrast meets 4.5:1 (normal) or 3:1 (large text) per WCAG 2.2
- [ ] Non-text contrast meets 3:1 for UI components and graphics
- [ ] Content is usable at 200% zoom
- [ ] Content reflows at 320px viewport width (no horizontal scrolling)
- [ ] Status indicators use icon + text, not color alone
- [ ] Forced colors mode (Windows High Contrast) preserves usability
- [ ] `prefers-reduced-motion` is respected

#### Cognitive

- [ ] Navigation is consistent across pages
- [ ] Help mechanisms appear in the same location
- [ ] Forms do not auto-submit on selection change
- [ ] Destructive actions require confirmation
- [ ] Error messages suggest specific corrections
- [ ] Multi-step workflows show progress and allow going back
- [ ] Previously entered data is preserved in multi-step forms
- [ ] Timeout warnings appear before session expires (with option to extend)

### 9.3 Recommended Testing Tools

| Tool | Type | Coverage |
|------|------|----------|
| [axe-core](https://github.com/dequelabs/axe-core) | Automated (unit/E2E) | ~57% of WCAG issues, zero false positives |
| [Lighthouse](https://developer.chrome.com/docs/lighthouse/) | Automated (CI) | Built on axe-core, includes performance audit |
| [axe DevTools](https://www.deque.com/axe/devtools/) | Browser extension | Interactive auditing with guided fixes |
| [Playwright + @axe-core/playwright](https://playwright.dev) | E2E automated | Full page and component-scoped scanning |
| NVDA | Screen reader (Windows) | Free, widely used, good ARIA support |
| JAWS | Screen reader (Windows) | Industry standard for enterprise, best ARIA support |
| VoiceOver | Screen reader (macOS/iOS) | Built-in, test Safari/mobile |
| [Colour Contrast Analyser](https://www.tpgi.com/color-contrast-checker/) | Manual | Eyedropper-based contrast checking |
| [APCA Contrast Calculator](https://www.myndex.com/APCA/) | Manual | WCAG 3.0 draft contrast validation |
| Windows High Contrast Mode | Manual | Toggle in Windows Settings > Accessibility |

---

## Key Sources

- [W3C WCAG 2.2 Specification](https://www.w3.org/TR/WCAG22/)
- [W3C ARIA Authoring Practices Guide (APG)](https://www.w3.org/WAI/ARIA/apg/)
- [APG Grid Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/grid/)
- [APG Tree View Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/treeview/)
- [APG Combobox Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/)
- [APG Listbox Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/listbox/)
- [APG Keyboard Interface Practices](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/)
- [APG Data Grid Examples](https://www.w3.org/WAI/ARIA/apg/patterns/grid/examples/data-grids/)
- [APG Sortable Table Example](https://www.w3.org/WAI/ARIA/apg/patterns/table/examples/sortable-table/)
- [MDN: ARIA Live Regions](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Guides/Live_regions)
- [MDN: forced-colors media query](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/forced-colors)
- [MDN: aria-sort attribute](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-sort)
- [Adrian Roselli: Sortable Table Columns](https://adrianroselli.com/2021/04/sortable-table-columns.html)
- [Smashing Magazine: Windows High Contrast Mode and CSS Custom Properties](https://www.smashingmagazine.com/2022/03/windows-high-contrast-colors-mode-css-custom-properties/)
- [Microsoft Edge: Forced Colors in Edge](https://blogs.windows.com/msedgedev/2020/09/17/styling-for-windows-high-contrast-with-new-standards-for-forced-colors/)
- [APCA Contrast Algorithm Documentation](https://git.apcacontrast.com/documentation/APCA_in_a_Nutshell.html)
- [APCA GitHub Repository](https://github.com/Myndex/SAPC-APCA)
- [Datawrapper: Color Contrast for Data Visualization](https://www.datawrapper.de/blog/color-contrast-check-data-vis-wcag-apca)
- [React Aria: Accessible Drag and Drop](https://react-aria.adobe.com/blog/drag-and-drop)
- [dnd-kit Accessibility Guide](https://docs.dndkit.com/guides/accessibility)
- [Salesforce: Drag and Drop Accessibility Patterns](https://salesforce-ux.github.io/dnd-a11y-patterns/)
- [GitHub Blog: Tree View Accessibility](https://github.blog/engineering/user-experience/considerations-for-making-a-tree-view-component-accessible/)
- [Sara Soueidan: Accessible Notifications with ARIA Live Regions](https://www.sarasoueidan.com/blog/accessible-notifications-with-aria-live-regions-part-1/)
- [axe-core by Deque](https://github.com/dequelabs/axe-core)
- [WCAG 2.2 ISO Standard Announcement](https://adaquickscan.com/blog/wcag-2-2-iso-standard-2025)
