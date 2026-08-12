# Enterprise Data Tables

## Table Architecture

### Core Table Structure

```html
<div class="table-toolbar" role="toolbar" aria-label="Table actions">
  <div class="table-search">
    <label for="table-search" class="sr-only">Search</label>
    <input type="search" id="table-search" placeholder="Search..." aria-describedby="search-results">
    <span id="search-results" class="sr-only" aria-live="polite"></span>
  </div>
  <div class="table-actions">
    <button aria-label="Filter">Filter</button>
    <button aria-label="Export">Export</button>
    <button aria-label="Column settings">Columns</button>
  </div>
</div>

<div class="table-container" role="region" aria-label="Employee directory" tabindex="0">
  <table role="grid" aria-label="Employee directory" aria-rowcount="1247">
    <thead>
      <tr role="row">
        <th role="columnheader" aria-sort="ascending" aria-colindex="1">
          <button>Name <span aria-hidden="true">▲</span></button>
        </th>
        <th role="columnheader" aria-colindex="2">Department</th>
        <th role="columnheader" aria-colindex="3">Status</th>
      </tr>
    </thead>
    <tbody>
      <tr role="row" aria-rowindex="1" aria-selected="false">
        <td role="gridcell" aria-colindex="1">Jane Doe</td>
        <td role="gridcell" aria-colindex="2">Engineering</td>
        <td role="gridcell" aria-colindex="3">
          <span class="status-badge status-badge--active">Active</span>
        </td>
      </tr>
    </tbody>
  </table>
</div>
```

### When to Use `role="grid"` vs Regular `<table>`

- Use `role="grid"` when cells are interactive (editable, clickable, contain widgets)
- Use a regular `<table>` for read-only data presentation
- Grid provides two-dimensional arrow key navigation; table relies on tab navigation

---

## Sorting, Filtering, Pagination

### Sorting

```html
<th role="columnheader" aria-sort="ascending" aria-colindex="1">
  <button aria-label="Sort by Name, currently ascending">
    Name
    <svg aria-hidden="true" class="sort-icon"><!-- sort indicator --></svg>
  </button>
</th>
```

Announce sort changes to screen readers via live region:
```javascript
function announceSort(columnName, direction) {
  const region = document.getElementById('sort-announcement');
  region.textContent = `Table sorted by ${columnName}, ${direction}`;
}
```

```html
<div class="sr-only" aria-live="polite" aria-atomic="true" id="sort-announcement"></div>
```

### Filtering

```html
<div class="filter-bar" role="search" aria-label="Table filters">
  <div class="active-filters" aria-live="polite">
    <span class="filter-chip">
      Department: Engineering
      <button aria-label="Remove Department filter">&times;</button>
    </span>
    <button class="clear-filters">Clear all</button>
  </div>
</div>
```

Announce filter results: `"Showing 47 of 1,247 results"`

### Pagination vs Virtual Scroll

| Dataset Size | Recommended Approach |
|---|---|
| < 100 rows | Show all, no pagination |
| 100 - 1,000 rows | Client-side pagination (25-50 per page) |
| 1,000 - 10,000 rows | Client-side virtual scrolling |
| 10,000 - 100,000 rows | Server-side pagination + client virtualization |
| 100,000+ rows | Cursor-based server pagination + virtualization |

### Pagination Component

```html
<nav aria-label="Table pagination" class="pagination">
  <span class="pagination-info" aria-live="polite">
    Showing 1-25 of 1,247 results
  </span>
  <div class="pagination-controls">
    <button aria-label="Previous page" disabled>Previous</button>
    <button aria-current="page" aria-label="Page 1">1</button>
    <button aria-label="Page 2">2</button>
    <span aria-hidden="true">...</span>
    <button aria-label="Page 50">50</button>
    <button aria-label="Next page">Next</button>
  </div>
  <div class="pagination-size">
    <label for="page-size">Rows per page:</label>
    <select id="page-size">
      <option>25</option>
      <option>50</option>
      <option>100</option>
    </select>
  </div>
</nav>
```

---

## Data Density

### Density Modes

| Mode | Row Height | Padding | Use Case |
|---|---|---|---|
| Compact | 32-40px | 4-8px | Power users, large monitors |
| Comfortable (default) | 44-52px | 8-12px | General daily use |
| Spacious | 56-64px | 12-16px | Smaller screens, accessibility needs |

```css
.data-table[data-density="compact"] td    { padding: 4px 8px;  font-size: 0.8125rem; }
.data-table[data-density="comfortable"] td { padding: 8px 12px; font-size: 0.875rem;  }
.data-table[data-density="spacious"] td   { padding: 12px 16px; font-size: 0.9375rem; }
```

### Information Density Best Practices

- Right-align numeric columns, use `font-variant-numeric: tabular-nums`
- Left-align text columns (never center-align body text)
- Truncate long text with ellipsis and tooltip on hover/focus
- Allow column show/hide and persist preferences per user
- Use visual encoding (status badges, sparklines, progress bars) over text

### Row Division Styles

| Style | When to Use |
|---|---|
| Horizontal lines (1px borders) | Most enterprise tables (default) |
| Zebra stripes | Dense tables with many columns |
| Card rows | Low-density tables, mobile views |

---

## Inline Editing

### Click-to-Edit (Cell-Level)

```html
<td role="gridcell" tabindex="-1" class="editable"
    aria-label="Company name: Acme Corp (click to edit)">
  <span class="cell-display">Acme Corp</span>
  <input class="cell-input" type="text" value="Acme Corp"
         aria-label="Company name" hidden />
</td>
```

```css
.editable:hover::after,
.editable:focus-within::after {
  content: '';
  position: absolute;
  inset: 2px;
  border: 2px solid var(--color-primary);
  border-radius: 4px;
  pointer-events: none;
}
```

**Activation:** Click or Enter to edit. Escape cancels. Enter/Tab confirms and moves to next cell.

### Editing Best Practices

- Always show visual indicator that a cell is editable
- Inline validation with red border and tooltip
- Optimistic updates with brief green flash confirmation
- Provide undo via toast with "Undo" action
- Use modal/side panel for complex edits with many fields

### Inline Validation

```html
<td class="editable error">
  <input type="text" value="-5" aria-invalid="true" aria-describedby="qty-error" />
  <div id="qty-error" class="cell-error" role="alert">
    Quantity must be a positive number
  </div>
</td>
```

---

## Table States

### Loading State (Initial)

Show 3-5 skeleton rows mirroring the table structure:

```html
<table aria-label="Employee directory" aria-busy="true">
  <thead><!-- headers --></thead>
  <tbody>
    <tr class="skeleton-row" aria-hidden="true">
      <td><div class="skeleton-bone"></div></td>
      <td><div class="skeleton-bone"></div></td>
      <td><div class="skeleton-bone skeleton-bone--short"></div></td>
    </tr>
  </tbody>
</table>
<div class="sr-only" aria-live="polite">Loading employee data...</div>
```

```css
.skeleton-bone {
  height: 1rem;
  border-radius: 4px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e8e8e8 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### Loading State (Subsequent — Sorting/Filtering)

Semi-transparent overlay with spinner over existing content:
```css
.table-container[aria-busy="true"]::after {
  content: '';
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.6);
  z-index: 10;
}
```

### Empty State (No Data)

```html
<div class="empty-state" role="status">
  <svg aria-hidden="true"><!-- illustration --></svg>
  <h3>No employees added yet</h3>
  <p>Add your first employee to get started.</p>
  <button class="btn-primary">Add Employee</button>
</div>
```

### Empty State (No Results After Filtering)

Keep table header visible. Display message with recovery action:
```html
<tbody>
  <tr>
    <td colspan="6" class="empty-state">
      <p><strong>No results found</strong></p>
      <p>Try adjusting your search or filters.</p>
      <button>Clear all filters</button>
    </td>
  </tr>
</tbody>
```

### Error State

```html
<div class="error-state" role="alert">
  <svg aria-hidden="true"><!-- error icon --></svg>
  <h3>Unable to load data</h3>
  <p>Something went wrong. Please try again.</p>
  <button>Try again</button>
</div>
```

---

## Responsive Tables

### Strategy Selection

| Strategy | Best For |
|---|---|
| Horizontal scroll + sticky first column | Comparison tasks, wide tables |
| Column prioritization (hide columns) | When some columns are secondary |
| Card/stacked layout | Mobile devices |

### Horizontal Scroll with Sticky Column

```css
.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

td:first-child, th:first-child {
  position: sticky;
  left: 0;
  background: var(--surface);
  z-index: 2;
}
```

### Card Layout for Mobile

```css
@media (max-width: 768px) {
  table, thead, tbody, tr, td, th { display: block; }
  thead { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0,0,0,0); }
  tr {
    border: 1px solid var(--border);
    border-radius: 8px;
    margin-bottom: 0.75rem;
    padding: 0.75rem;
  }
  td {
    display: flex;
    justify-content: space-between;
    padding: 0.375rem 0;
  }
  td::before {
    content: attr(data-label);
    font-weight: 600;
    color: var(--text-secondary);
  }
}
```

### Column Prioritization

```css
@media (max-width: 1024px) { [data-priority="low"] { display: none; } }
@media (max-width: 768px)  { [data-priority="medium"] { display: none; } }
```

---

## Row Selection and Bulk Actions

### Selection Pattern

```html
<table role="grid" aria-multiselectable="true">
  <thead>
    <tr>
      <th>
        <input type="checkbox" aria-label="Select all rows"
               id="select-all" />
      </th>
      <th>Name</th>
    </tr>
  </thead>
  <tbody>
    <tr aria-selected="false">
      <td>
        <input type="checkbox" aria-label="Select Jane Doe" />
      </td>
      <td>Jane Doe</td>
    </tr>
  </tbody>
</table>
```

### Bulk Action Bar

Appears when 1+ rows selected. Sticky to bottom of viewport:

```html
<div class="bulk-actions" role="toolbar" aria-label="Bulk actions">
  <span><strong>12</strong> items selected</span>
  <button>Edit</button>
  <button>Archive</button>
  <button class="btn-danger">Delete</button>
  <button aria-label="Deselect all">Deselect all</button>
</div>
```

```css
.bulk-actions {
  position: sticky;
  bottom: 16px;
  background: var(--primary);
  color: white;
  border-radius: 10px;
  padding: 8px 16px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
  animation: slide-up 200ms ease;
}
```

---

## Keyboard Navigation

Full keyboard interaction model for data grids:

| Key | Action |
|---|---|
| Arrow keys | Move focus between cells |
| Page Down/Up | Move focus by one viewport |
| Home / End | First/last cell in row |
| Ctrl + Home/End | First/last cell in grid |
| Enter / F2 | Enter edit mode |
| Escape | Exit edit mode |
| Space | Toggle row selection |
| Tab | Move to next element outside grid |

Use roving tabindex: only focused cell has `tabindex="0"`, all others `tabindex="-1"`.

---

## Column Resizing

```css
th {
  position: relative;
  overflow: hidden;
}

.column-resizer {
  position: absolute;
  right: 0;
  top: 0;
  width: 4px;
  height: 100%;
  cursor: col-resize;
  background: transparent;
}

.column-resizer:hover,
.column-resizer:active {
  background: var(--color-primary);
}
```

Use CSS custom properties for column widths for efficient resizing (single style recalc):
```css
th:nth-child(1) { width: var(--col-1-width, 200px); }
th:nth-child(2) { width: var(--col-2-width, 150px); }
```

---

## Sticky Headers

```css
thead th {
  position: sticky;
  top: 0;
  background: var(--surface);
  z-index: 3;
  box-shadow: 0 1px 0 var(--border);
}
```

---

## Performance Checklist

- Memoize table body during column resize
- Use CSS custom properties for column widths
- Debounce search/filter inputs (250-300ms)
- Use `content-visibility: auto` on off-screen sections
- Implement `<colgroup>` for column-wide styling
- Update cell content via `textContent` (not `innerHTML`)
- Maintain buffer of 5-10 rows above/below viewport for virtual scrolling
- Use `will-change: transform` on scroll container
- Use `requestAnimationFrame` for scroll-driven updates

---

## Technology Recommendations

| Library | Best For |
|---|---|
| **TanStack Table** | Custom-designed tables, full UI control, < 50K rows |
| **AG Grid** | 100K+ rows, pivoting, tree data, Excel export |
| **TanStack Virtual** | Virtual scrolling companion for any table |

TanStack Table can use AG Grid as rendering layer via `@ag-grid-community/tanstack-table-adapter`.
