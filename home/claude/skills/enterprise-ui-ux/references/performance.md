# Enterprise UI/UX Performance and Perceived Performance Patterns (2024-2026)

A comprehensive reference for building high-performance enterprise information systems that handle large datasets and complex interactions.

---

## Table of Contents

1. [Perceived Performance](#1-perceived-performance)
2. [Loading Patterns](#2-loading-patterns)
3. [Large Dataset Handling](#3-large-dataset-handling)
4. [Caching Strategies](#4-caching-strategies)
5. [Debounce, Throttle, and Observer APIs](#5-debounce-throttle-and-observer-apis)
6. [CSS Performance](#6-css-performance)
7. [Image and Asset Optimization](#7-image-and-asset-optimization)
8. [Core Web Vitals for Enterprise SPAs](#8-core-web-vitals-for-enterprise-spas)

---

## 1. Perceived Performance

Perceived performance is how fast a user *feels* the application is, which matters more than raw milliseconds. Enterprise users interact with systems 8+ hours per day, so every friction point compounds.

### 1.1 Skeleton Screens

Skeleton screens show a wireframe-like placeholder that mirrors the layout of the incoming content, forming the user's mental model before data arrives.

**Nielsen Norman Group research findings:**
- Use skeleton screens for page loads under 10 seconds
- Use spinners/progress bars for 2-10 second waits on single modules
- Omit loading indicators entirely for loads under 1 second
- Skeleton screens reduce perceived loading time by up to 40% compared to spinners

**When to use:** Full-page loads, data tables, card grids, dashboards, list views.
**When NOT to use:** Small UI components like buttons, form fields, labels (they suggest immediate interactivity and skeleton states mislead users into attempting interaction).

```html
<!-- Skeleton Screen for a Data Table -->
<div class="skeleton-table" aria-busy="true" aria-label="Loading data">
  <div class="skeleton-header">
    <div class="skeleton-cell skeleton-cell--header"></div>
    <div class="skeleton-cell skeleton-cell--header"></div>
    <div class="skeleton-cell skeleton-cell--header"></div>
    <div class="skeleton-cell skeleton-cell--header"></div>
  </div>
  <div class="skeleton-row" aria-hidden="true">
    <div class="skeleton-cell skeleton-cell--avatar"></div>
    <div class="skeleton-cell skeleton-cell--text skeleton-cell--wide"></div>
    <div class="skeleton-cell skeleton-cell--text skeleton-cell--medium"></div>
    <div class="skeleton-cell skeleton-cell--text skeleton-cell--narrow"></div>
  </div>
  <div class="skeleton-row" aria-hidden="true">
    <div class="skeleton-cell skeleton-cell--avatar"></div>
    <div class="skeleton-cell skeleton-cell--text skeleton-cell--wide"></div>
    <div class="skeleton-cell skeleton-cell--text skeleton-cell--medium"></div>
    <div class="skeleton-cell skeleton-cell--text skeleton-cell--narrow"></div>
  </div>
  <!-- Repeat rows to match expected content volume -->
</div>
```

```css
/* Skeleton Screen Styles */
.skeleton-table {
  width: 100%;
}

.skeleton-header,
.skeleton-row {
  display: grid;
  grid-template-columns: 48px 2fr 1fr 0.5fr;
  gap: 16px;
  padding: 12px 16px;
  align-items: center;
}

.skeleton-cell {
  background: var(--skeleton-base, #e2e8f0);
  border-radius: 4px;
}

.skeleton-cell--header {
  height: 14px;
  background: var(--skeleton-header, #cbd5e1);
}

.skeleton-cell--avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
}

.skeleton-cell--text {
  height: 12px;
}

.skeleton-cell--wide { width: 85%; }
.skeleton-cell--medium { width: 60%; }
.skeleton-cell--narrow { width: 40%; }

/* Pulsating animation */
.skeleton-cell {
  animation: skeleton-pulse 1.5s ease-in-out infinite;
}

@keyframes skeleton-pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

/* Wave/shimmer animation (alternative) */
.skeleton-cell--shimmer {
  background: linear-gradient(
    90deg,
    var(--skeleton-base, #e2e8f0) 25%,
    var(--skeleton-highlight, #f1f5f9) 37%,
    var(--skeleton-base, #e2e8f0) 63%
  );
  background-size: 400% 100%;
  animation: skeleton-shimmer 1.4s ease infinite;
}

@keyframes skeleton-shimmer {
  0% { background-position: 100% 50%; }
  100% { background-position: 0 50%; }
}

/* Accessibility: respect reduced motion */
@media (prefers-reduced-motion: reduce) {
  .skeleton-cell,
  .skeleton-cell--shimmer {
    animation: none;
  }
}
```

### 1.2 Progressive Loading

Load content in priority batches rather than all at once.

```
Batch 1 (immediate):  Page skeleton + navigation chrome
Batch 2 (< 200ms):    Above-the-fold text content + critical data
Batch 3 (< 500ms):    Images, charts, secondary data
Batch 4 (deferred):   Below-fold content, analytics, non-critical features
```

```javascript
// Progressive loading with priority levels
class ProgressiveLoader {
  #queues = { critical: [], high: [], normal: [], low: [] };
  #isProcessing = false;

  enqueue(priority, loadFn) {
    this.#queues[priority].push(loadFn);
    this.#process();
  }

  async #process() {
    if (this.#isProcessing) return;
    this.#isProcessing = true;

    for (const priority of ['critical', 'high', 'normal', 'low']) {
      const queue = this.#queues[priority];
      while (queue.length > 0) {
        const loadFn = queue.shift();
        await loadFn();

        // Yield to the main thread between low-priority items
        if (priority === 'low' || priority === 'normal') {
          await new Promise(resolve => setTimeout(resolve, 0));
        }
      }
    }

    this.#isProcessing = false;
  }
}

// Usage in an enterprise dashboard
const loader = new ProgressiveLoader();

loader.enqueue('critical', () => renderNavigationShell());
loader.enqueue('critical', () => renderPageSkeleton());
loader.enqueue('high', () => fetchAndRenderKPICards());
loader.enqueue('normal', () => fetchAndRenderDataTable());
loader.enqueue('normal', () => fetchAndRenderCharts());
loader.enqueue('low', () => prefetchNextPageData());
loader.enqueue('low', () => loadAnalyticsScripts());
```

### 1.3 Optimistic UI Updates

Update the UI immediately assuming the server operation will succeed, and roll back if it fails. Binary actions (like/unlike, toggle, approve/reject) are ideal candidates.

```javascript
// React 19+ useOptimistic pattern
import { startTransition, useOptimistic, useState } from "react";

function ApprovalButton({ requestId, initialStatus = "pending" }) {
  const [status, setStatus] = useState(initialStatus);
  const [optimisticStatus, setOptimisticStatus] = useOptimistic(
    status,
    (_current, newStatus) => newStatus
  );

  async function handleApprove() {
    setOptimisticStatus("approved");
    try {
      await approveRequest(requestId);
      setStatus("approved");
    } catch {
      // Rollback: reset to actual server state
      setStatus(prev => prev);
    }
  }

  return (
    <button
      onClick={() => startTransition(() => handleApprove())}
      disabled={optimisticStatus === "approved"}
      data-status={optimisticStatus}
    >
      {optimisticStatus === "approved" ? "Approved" : "Approve"}
    </button>
  );
}
```

```javascript
// Framework-agnostic optimistic update with rollback
class OptimisticUpdate {
  static async execute({ updateUI, revertUI, serverCall }) {
    updateUI();

    try {
      const result = await serverCall();
      return result;
    } catch (error) {
      revertUI();
      throw error;
    }
  }
}

// Usage: toggling a row status in a data grid
const row = document.querySelector(`[data-row-id="${rowId}"]`);
const previousStatus = row.dataset.status;

await OptimisticUpdate.execute({
  updateUI: () => {
    row.dataset.status = "active";
    row.querySelector(".status-badge").textContent = "Active";
    row.querySelector(".status-badge").classList.replace("badge--inactive", "badge--active");
  },
  revertUI: () => {
    row.dataset.status = previousStatus;
    row.querySelector(".status-badge").textContent = "Inactive";
    row.querySelector(".status-badge").classList.replace("badge--active", "badge--inactive");
    showToast("Failed to update status. Please try again.");
  },
  serverCall: () => api.patch(`/items/${rowId}`, { status: "active" }),
});
```

### 1.4 Instant Feedback / Micro-Interactions

Keep animations under 300ms. Gartner predicts by end of 2025, 75% of customer-facing applications incorporate micro-interactions as standard practice.

```css
/* Instant button feedback */
.btn-action {
  transition: transform 80ms ease-out, box-shadow 80ms ease-out;
}

.btn-action:active {
  transform: scale(0.97);
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.12);
}

/* Inline form validation feedback */
.form-field {
  border: 2px solid var(--border-default, #d1d5db);
  transition: border-color 150ms ease;
}

.form-field:focus {
  border-color: var(--border-focus, #3b82f6);
  outline: 2px solid var(--ring-focus, rgba(59, 130, 246, 0.3));
  outline-offset: 1px;
}

.form-field[aria-invalid="true"] {
  border-color: var(--border-error, #ef4444);
}

.form-field[data-valid="true"] {
  border-color: var(--border-success, #22c55e);
}

/* Save confirmation animation */
.save-indicator {
  opacity: 0;
  transform: translateY(4px);
  transition: opacity 200ms ease, transform 200ms ease;
}

.save-indicator.visible {
  opacity: 1;
  transform: translateY(0);
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
  .btn-action,
  .form-field,
  .save-indicator {
    transition-duration: 0.01ms;
  }
}
```

```javascript
// Inline save feedback
async function saveField(input) {
  const indicator = input.closest(".field-wrapper").querySelector(".save-indicator");

  indicator.textContent = "Saving...";
  indicator.classList.add("visible");

  try {
    await api.patch(`/records/${input.dataset.recordId}`, {
      [input.name]: input.value,
    });
    indicator.textContent = "Saved";
    setTimeout(() => indicator.classList.remove("visible"), 1500);
  } catch {
    indicator.textContent = "Save failed";
    indicator.classList.add("error");
  }
}
```

---

## 2. Loading Patterns

### 2.1 Choosing the Right Pattern

| Duration     | Pattern              | Use Case                                      |
|-------------|----------------------|-----------------------------------------------|
| < 1s        | No indicator         | Fast enough that indicators cause flicker     |
| 1-3s        | Skeleton screen      | Page sections, card grids, table rows         |
| 1-3s        | Inline spinner       | Single component reload (button, field)       |
| 3-10s       | Progress bar         | File uploads, batch operations                |
| > 10s       | Progress bar + ETA   | Report generation, data exports               |
| Indefinite  | Background task + notification | Long-running server jobs              |

### 2.2 Above-the-Fold Priority

```html
<!-- Prioritize visible content; defer everything below the fold -->
<main>
  <!-- CRITICAL: loads immediately -->
  <section class="dashboard-kpis" data-priority="critical">
    <div class="kpi-card"><!-- Server-rendered or cached --></div>
    <div class="kpi-card"><!-- Server-rendered or cached --></div>
  </section>

  <!-- HIGH: loads after KPIs are painted -->
  <section class="dashboard-table" data-priority="high">
    <div class="skeleton-table" aria-busy="true"><!-- skeleton --></div>
  </section>

  <!-- DEFERRED: loads only when scrolled into view -->
  <section class="dashboard-charts" data-priority="deferred">
    <div class="skeleton-chart" aria-busy="true"><!-- skeleton --></div>
  </section>
</main>
```

```javascript
// Load deferred sections only when visible
const deferredSections = document.querySelectorAll('[data-priority="deferred"]');

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        loadSection(entry.target);
        observer.unobserve(entry.target);
      }
    });
  },
  { rootMargin: "200px" } // start loading 200px before visible
);

deferredSections.forEach((section) => observer.observe(section));
```

### 2.3 Content Prioritization in Data Tables

```javascript
// Render visible columns first, then off-screen columns
function renderTableProgressive(data, columns, containerEl) {
  const visibleColumns = columns.filter((col) => col.priority === "visible");
  const deferredColumns = columns.filter((col) => col.priority === "deferred");

  // Phase 1: render table with visible columns only
  const table = buildTable(data, visibleColumns);
  containerEl.innerHTML = "";
  containerEl.appendChild(table);

  // Phase 2: add deferred columns after next frame
  requestAnimationFrame(() => {
    setTimeout(() => {
      deferredColumns.forEach((col) => addColumnToTable(table, data, col));
    }, 0);
  });
}
```

---

## 3. Large Dataset Handling

### 3.1 Virtual Scrolling / Windowing

Only render items visible in the viewport. This enables 60 FPS scrolling with millions of rows.

**Libraries (2025):**
- **TanStack Virtual** -- Framework-agnostic, full control over markup (recommended for enterprise)
- **React Virtuoso** -- Automatic dynamic height handling, grouping, sticky headers
- **React Window** -- Lightweight, fixed/variable size lists and grids

```javascript
// Vanilla JS virtual scroll implementation
class VirtualScroller {
  #container;
  #content;
  #data;
  #rowHeight;
  #visibleCount;
  #buffer;

  constructor(container, data, rowHeight = 40, buffer = 5) {
    this.#container = container;
    this.#data = data;
    this.#rowHeight = rowHeight;
    this.#buffer = buffer;
    this.#visibleCount = Math.ceil(container.clientHeight / rowHeight);

    this.#content = document.createElement("div");
    this.#content.style.height = `${data.length * rowHeight}px`;
    this.#content.style.position = "relative";
    container.appendChild(this.#content);
    container.style.overflow = "auto";

    container.addEventListener("scroll", () => this.#render(), { passive: true });
    this.#render();
  }

  #render() {
    const scrollTop = this.#container.scrollTop;
    const startIndex = Math.max(0, Math.floor(scrollTop / this.#rowHeight) - this.#buffer);
    const endIndex = Math.min(
      this.#data.length,
      startIndex + this.#visibleCount + this.#buffer * 2
    );

    // Clear and re-render only visible rows
    this.#content.innerHTML = "";
    for (let i = startIndex; i < endIndex; i++) {
      const row = this.#createRow(this.#data[i], i);
      row.style.position = "absolute";
      row.style.top = `${i * this.#rowHeight}px`;
      row.style.height = `${this.#rowHeight}px`;
      row.style.width = "100%";
      this.#content.appendChild(row);
    }
  }

  #createRow(item, index) {
    const row = document.createElement("div");
    row.className = "virtual-row";
    row.textContent = `Row ${index}: ${item.name}`;
    return row;
  }
}

// Usage
const container = document.getElementById("scroll-container");
const data = Array.from({ length: 100_000 }, (_, i) => ({ name: `Item ${i}` }));
new VirtualScroller(container, data);
```

```javascript
// TanStack Virtual (React) -- enterprise data grid
import { useVirtualizer } from "@tanstack/react-virtual";

function DataGrid({ rows, columns }) {
  const parentRef = useRef(null);

  const rowVirtualizer = useVirtualizer({
    count: rows.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 40,
    overscan: 10,
  });

  return (
    <div ref={parentRef} style={{ height: "600px", overflow: "auto" }}>
      <div style={{ height: `${rowVirtualizer.getTotalSize()}px`, position: "relative" }}>
        {rowVirtualizer.getVirtualItems().map((virtualRow) => {
          const row = rows[virtualRow.index];
          return (
            <div
              key={virtualRow.key}
              style={{
                position: "absolute",
                top: 0,
                left: 0,
                width: "100%",
                height: `${virtualRow.size}px`,
                transform: `translateY(${virtualRow.start}px)`,
              }}
            >
              {columns.map((col) => (
                <span key={col.key} className="cell">
                  {row[col.key]}
                </span>
              ))}
            </div>
          );
        })}
      </div>
    </div>
  );
}
```

### 3.2 Pagination vs Infinite Scroll vs Load More

| Pattern         | Best For                           | Enterprise Recommendation      |
|----------------|------------------------------------|-------------------------------|
| Pagination     | Structured data, reports, auditing | Primary pattern for data grids |
| Load More      | Feeds, activity logs               | Good hybrid approach           |
| Infinite Scroll| Content browsing, discovery        | Avoid for task-oriented UIs    |

**Pagination is preferred for enterprise** because users need to:
- Return to a specific position reliably
- Share links to specific pages
- Understand dataset boundaries
- Maintain audit trails

```javascript
// Cursor-based pagination (more performant than offset for large datasets)
class CursorPaginator {
  #pageSize;
  #currentCursor = null;
  #hasNextPage = true;

  constructor(pageSize = 50) {
    this.#pageSize = pageSize;
  }

  async fetchPage(direction = "next") {
    if (direction === "next" && !this.#hasNextPage) return null;

    const params = new URLSearchParams({
      limit: this.#pageSize,
      ...(this.#currentCursor && { cursor: this.#currentCursor }),
    });

    const response = await fetch(`/api/records?${params}`);
    const { data, nextCursor, hasMore } = await response.json();

    this.#currentCursor = nextCursor;
    this.#hasNextPage = hasMore;

    return data;
  }
}
```

```javascript
// Load More pattern with IntersectionObserver trigger
function setupLoadMore(container, loadFn) {
  const sentinel = document.createElement("div");
  sentinel.className = "load-more-sentinel";
  sentinel.setAttribute("aria-hidden", "true");
  container.appendChild(sentinel);

  let isLoading = false;

  const observer = new IntersectionObserver(
    async ([entry]) => {
      if (!entry.isIntersecting || isLoading) return;

      isLoading = true;
      sentinel.textContent = "Loading more...";

      const { items, hasMore } = await loadFn();

      items.forEach((item) => {
        container.insertBefore(createItemElement(item), sentinel);
      });

      if (!hasMore) {
        observer.disconnect();
        sentinel.remove();
      }

      isLoading = false;
      sentinel.textContent = "";
    },
    { rootMargin: "300px" }
  );

  observer.observe(sentinel);
}
```

---

## 4. Caching Strategies

### 4.1 Stale-While-Revalidate (SWR)

Serve cached data immediately, then revalidate in the background. The user sees instant results while fresh data loads silently.

**HTTP header approach:**
```
Cache-Control: max-age=60, stale-while-revalidate=3600
```
This means: content is fresh for 60 seconds, and can continue to be served stale for an additional 3600 seconds while being revalidated in the background.

```javascript
// Client-side SWR implementation
class SWRCache {
  #cache = new Map();

  async get(key, fetchFn, { maxAge = 60_000, staleWhileRevalidate = 300_000 } = {}) {
    const cached = this.#cache.get(key);
    const now = Date.now();

    // Cache hit: data is fresh
    if (cached && now - cached.timestamp < maxAge) {
      return cached.data;
    }

    // Cache hit but stale: return stale data, revalidate in background
    if (cached && now - cached.timestamp < maxAge + staleWhileRevalidate) {
      this.#revalidate(key, fetchFn);
      return cached.data;
    }

    // Cache miss or expired: fetch and wait
    return this.#revalidate(key, fetchFn);
  }

  async #revalidate(key, fetchFn) {
    try {
      const data = await fetchFn();
      this.#cache.set(key, { data, timestamp: Date.now() });
      return data;
    } catch (error) {
      const cached = this.#cache.get(key);
      if (cached) return cached.data; // fall back to stale data on error
      throw error;
    }
  }
}

// Usage in an enterprise dashboard
const cache = new SWRCache();

async function loadDashboardMetrics() {
  return cache.get(
    "dashboard-metrics",
    () => fetch("/api/metrics").then((r) => r.json()),
    { maxAge: 30_000, staleWhileRevalidate: 300_000 }
  );
}
```

### 4.2 TanStack Query / SWR Library Integration

```javascript
// TanStack Query with stale time and background refetching
import { useQuery, QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,          // data is fresh for 30 seconds
      gcTime: 5 * 60_000,         // garbage collect after 5 minutes
      refetchOnWindowFocus: true,  // revalidate when user returns to tab
      retry: 2,
    },
  },
});

function OrdersTable() {
  const { data, isLoading, isStale, isFetching } = useQuery({
    queryKey: ["orders", filters],
    queryFn: () => fetchOrders(filters),
    staleTime: 60_000,
    placeholderData: keepPreviousData, // show old data while fetching new page
  });

  return (
    <div>
      {isFetching && !isLoading && (
        <div className="refetch-indicator">Updating...</div>
      )}
      {isLoading ? <TableSkeleton /> : <Table data={data} />}
    </div>
  );
}
```

### 4.3 Optimistic Cache Updates

```javascript
// TanStack Query optimistic mutation
import { useMutation, useQueryClient } from "@tanstack/react-query";

function useUpdateOrder() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (updatedOrder) =>
      fetch(`/api/orders/${updatedOrder.id}`, {
        method: "PATCH",
        body: JSON.stringify(updatedOrder),
      }),

    onMutate: async (updatedOrder) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ["orders"] });

      // Snapshot previous value for rollback
      const previousOrders = queryClient.getQueryData(["orders"]);

      // Optimistically update cache
      queryClient.setQueryData(["orders"], (old) =>
        old.map((order) =>
          order.id === updatedOrder.id ? { ...order, ...updatedOrder } : order
        )
      );

      return { previousOrders };
    },

    onError: (_err, _updatedOrder, context) => {
      // Rollback on error
      queryClient.setQueryData(["orders"], context.previousOrders);
    },

    onSettled: () => {
      // Refetch to ensure server consistency
      queryClient.invalidateQueries({ queryKey: ["orders"] });
    },
  });
}
```

### 4.4 Local-First / Offline-First Patterns

The local device acts as the primary source of truth; the network is an optimization, not a requirement. Notion, Obsidian, and Linear use this pattern.

```javascript
// Local-first with IndexedDB and background sync
class LocalFirstStore {
  #dbName;
  #storeName;
  #syncQueue = [];
  #db = null;

  constructor(dbName, storeName) {
    this.#dbName = dbName;
    this.#storeName = storeName;
  }

  async init() {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.#dbName, 1);

      request.onupgradeneeded = (event) => {
        const db = event.target.result;
        if (!db.objectStoreNames.contains(this.#storeName)) {
          db.createObjectStore(this.#storeName, { keyPath: "id" });
        }
        if (!db.objectStoreNames.contains("syncQueue")) {
          db.createObjectStore("syncQueue", { autoIncrement: true });
        }
      };

      request.onsuccess = (event) => {
        this.#db = event.target.result;
        resolve();
      };

      request.onerror = () => reject(request.error);
    });
  }

  async write(record) {
    // Write locally immediately
    await this.#putLocal(record);

    // Queue for server sync
    await this.#enqueueSync({ type: "write", record, timestamp: Date.now() });

    // Attempt background sync
    this.#trySync();

    return record;
  }

  async read(id) {
    return this.#getLocal(id);
  }

  async #trySync() {
    if (!navigator.onLine) return;

    const pendingOps = await this.#getPendingSyncOps();
    for (const op of pendingOps) {
      try {
        await fetch(`/api/${this.#storeName}/${op.record.id}`, {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(op.record),
        });
        await this.#removeSyncOp(op.key);
      } catch {
        break; // stop syncing on first failure, retry later
      }
    }
  }

  // ... IndexedDB helper methods omitted for brevity
}

// Sync when connectivity returns
window.addEventListener("online", () => store.trySync());
```

---

## 5. Debounce, Throttle, and Observer APIs

### 5.1 Debounce for Search Input

Debounce waits until the user stops typing before firing. A skilled typist generates ~6 keypress events per second; debouncing reduces this to 1-2 API calls.

```javascript
// Reusable debounce function
function debounce(fn, delay = 300) {
  let timerId;
  return function (...args) {
    clearTimeout(timerId);
    timerId = setTimeout(() => fn.apply(this, args), delay);
  };
}

// Enterprise search with debounce
const searchInput = document.getElementById("global-search");
const resultsList = document.getElementById("search-results");

const performSearch = debounce(async (query) => {
  if (query.length < 2) {
    resultsList.innerHTML = "";
    return;
  }

  resultsList.setAttribute("aria-busy", "true");

  try {
    const results = await fetch(`/api/search?q=${encodeURIComponent(query)}`).then((r) =>
      r.json()
    );
    renderResults(results);
  } finally {
    resultsList.setAttribute("aria-busy", "false");
  }
}, 300);

searchInput.addEventListener("input", (e) => performSearch(e.target.value));
```

```javascript
// React hook for debounced values
import { useState, useEffect, useRef } from "react";

function useDebouncedValue(value, delay = 300) {
  const [debouncedValue, setDebouncedValue] = useState(value);
  const timerRef = useRef(null);

  useEffect(() => {
    timerRef.current = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timerRef.current);
  }, [value, delay]);

  return debouncedValue;
}

// Usage in a search component
function GlobalSearch() {
  const [query, setQuery] = useState("");
  const debouncedQuery = useDebouncedValue(query, 300);

  const { data } = useQuery({
    queryKey: ["search", debouncedQuery],
    queryFn: () => searchAPI(debouncedQuery),
    enabled: debouncedQuery.length >= 2,
  });

  return <input value={query} onChange={(e) => setQuery(e.target.value)} />;
}
```

### 5.2 Throttle for Scroll and Resize

Throttle executes at a regular interval regardless of event frequency.

```javascript
// Reusable throttle function
function throttle(fn, delay = 100) {
  let timerId;
  return function (...args) {
    if (timerId) return;
    timerId = setTimeout(() => {
      fn.apply(this, args);
      timerId = null;
    }, delay);
  };
}

// Throttled scroll position tracking
const scrollContainer = document.getElementById("data-grid");

const trackScrollPosition = throttle((scrollTop) => {
  const progress = scrollTop / (scrollContainer.scrollHeight - scrollContainer.clientHeight);
  document.getElementById("scroll-progress").style.width = `${progress * 100}%`;
}, 100);

scrollContainer.addEventListener(
  "scroll",
  (e) => trackScrollPosition(e.target.scrollTop),
  { passive: true } // always use passive for scroll listeners
);
```

### 5.3 ResizeObserver and IntersectionObserver

Observers are specifically designed to minimize layout recalculations and are preferred over scroll/resize event listeners.

```javascript
// ResizeObserver for responsive data grid columns
const grid = document.getElementById("enterprise-grid");

const resizeObserver = new ResizeObserver((entries) => {
  for (const entry of entries) {
    const width = entry.contentRect.width;

    if (width < 768) {
      grid.dataset.layout = "compact";
    } else if (width < 1200) {
      grid.dataset.layout = "standard";
    } else {
      grid.dataset.layout = "expanded";
    }
  }
});

resizeObserver.observe(grid);
```

```css
/* Responsive grid columns based on data-layout attribute */
[data-layout="compact"] .grid-cell--secondary {
  display: none;
}

[data-layout="standard"] .grid-row {
  grid-template-columns: 48px 2fr 1fr 1fr 120px;
}

[data-layout="expanded"] .grid-row {
  grid-template-columns: 48px 2fr 1fr 1fr 1fr 1fr 120px;
}
```

```javascript
// IntersectionObserver for lazy-loading table sections
const sections = document.querySelectorAll(".data-section[data-src]");

const lazyLoader = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;

      const section = entry.target;
      loadSectionData(section.dataset.src).then((html) => {
        section.innerHTML = html;
        section.removeAttribute("data-src");
      });

      lazyLoader.unobserve(section);
    });
  },
  { rootMargin: "200px 0px" }
);

sections.forEach((section) => lazyLoader.observe(section));
```

---

## 6. CSS Performance

### 6.1 `content-visibility: auto`

Tells the browser to skip rendering off-screen content. Achieves up to 7x rendering performance improvement on initial load. Now Baseline Newly available in all major browsers (2025).

```css
/* Apply to repeating content sections like list items or table rows */
.data-section {
  content-visibility: auto;
  contain-intrinsic-size: auto 500px; /* estimated height; 'auto' remembers rendered size */
}

/* Enterprise data table rows */
.table-row-group {
  content-visibility: auto;
  contain-intrinsic-size: auto 200px;
}

/* Dashboard widget cards */
.dashboard-card {
  content-visibility: auto;
  contain-intrinsic-size: auto 320px;
}

/* Feed or activity log entries */
.activity-entry {
  content-visibility: auto;
  contain-intrinsic-size: auto 80px;
}
```

```html
<!-- Long page with content-visibility for off-screen sections -->
<main>
  <section class="kpi-section">
    <!-- Always rendered: above the fold -->
  </section>

  <section class="data-section">
    <!-- Rendered when approaching viewport -->
    <table><!-- 100+ rows --></table>
  </section>

  <section class="data-section">
    <!-- Skipped until user scrolls here -->
    <div class="chart-container"><!-- Complex chart --></div>
  </section>

  <section class="data-section">
    <!-- Skipped until user scrolls here -->
    <div class="audit-log"><!-- Hundreds of log entries --></div>
  </section>
</main>
```

### 6.2 CSS Containment (`contain`)

Provides predictable isolation of a DOM subtree so the browser can optimize rendering.

```css
/* Layout containment: changes inside won't affect outside layout */
.widget-card {
  contain: layout;
}

/* Size containment: element size is fixed, doesn't depend on children */
.fixed-panel {
  contain: size layout;
  width: 300px;
  height: 400px;
}

/* Paint containment: content won't overflow, browser can skip off-screen painting */
.scrollable-list {
  contain: paint;
  overflow: auto;
}

/* Strict containment: all types combined (most restrictive, most performant) */
.isolated-widget {
  contain: strict;
  width: 100%;
  height: 400px;
}

/* Content containment: layout + paint (commonly used for reusable components) */
.data-card {
  contain: content;
}
```

### 6.3 `will-change`

Hints to the browser about upcoming property changes so it can prepare GPU layers. Use it as a last resort for specific performance problems.

```css
/* CORRECT: Apply before animation, remove after */
.modal-overlay {
  opacity: 0;
  pointer-events: none;
  transition: opacity 200ms ease;
}

.modal-overlay.opening {
  will-change: opacity;
}

.modal-overlay.open {
  opacity: 1;
  pointer-events: auto;
  will-change: auto; /* remove after transition */
}
```

```javascript
// Best practice: toggle will-change via JavaScript
const sidebar = document.querySelector(".sidebar");

sidebar.addEventListener("mouseenter", () => {
  sidebar.style.willChange = "transform";
});

sidebar.addEventListener("transitionend", () => {
  sidebar.style.willChange = "auto";
});
```

```css
/* WRONG: do not blanket-apply will-change */
/* This wastes GPU memory and hurts performance */
* {
  will-change: transform, opacity; /* NEVER do this */
}
```

### 6.4 CSS Cascade Layers (`@layer`)

Control specificity without escalating to `!important`. Reduces style conflicts in large enterprise codebases with design systems and third-party components.

```css
/* Declare layer order: lowest to highest priority */
@layer reset, base, components, utilities, overrides;

@layer reset {
  *,
  *::before,
  *::after {
    box-sizing: border-box;
    margin: 0;
  }
}

@layer base {
  body {
    font-family: var(--font-sans);
    color: var(--text-primary);
    line-height: 1.5;
  }

  table {
    border-collapse: collapse;
    width: 100%;
  }
}

@layer components {
  .btn {
    padding: 8px 16px;
    border-radius: 6px;
    font-weight: 500;
  }

  .data-grid {
    border: 1px solid var(--border-default);
  }

  .data-grid th {
    background: var(--surface-secondary);
    font-weight: 600;
  }
}

@layer utilities {
  .sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
  }

  .truncate {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

@layer overrides {
  /* Third-party component style fixes */
  .vendor-datepicker .input {
    border: 1px solid var(--border-default);
    font-family: inherit;
  }
}
```

---

## 7. Image and Asset Optimization

### 7.1 Modern Formats: AVIF and WebP

AVIF offers up to 50% better compression than JPEG and 20% better than WebP. Browser support is now near-universal in 2025.

```html
<!-- Progressive format fallback with picture element -->
<picture>
  <source srcset="report-chart.avif" type="image/avif">
  <source srcset="report-chart.webp" type="image/webp">
  <img src="report-chart.jpg" alt="Q4 Revenue by Region" loading="lazy" decoding="async">
</picture>
```

### 7.2 Responsive Images with `srcset` and `sizes`

```html
<!-- Serve appropriately sized images based on viewport -->
<img
  src="dashboard-hero-800.jpg"
  srcset="
    dashboard-hero-400.jpg   400w,
    dashboard-hero-800.jpg   800w,
    dashboard-hero-1200.jpg 1200w,
    dashboard-hero-1600.jpg 1600w
  "
  sizes="(max-width: 600px) 100vw,
         (max-width: 1200px) 800px,
         1200px"
  alt="Dashboard overview"
  loading="eager"
  fetchpriority="high"
>
```

### 7.3 Preloading Critical Images

```html
<!-- Preload the LCP image to improve Largest Contentful Paint -->
<head>
  <link
    rel="preload"
    as="image"
    href="hero-chart.avif"
    type="image/avif"
    imagesrcset="hero-chart-400.avif 400w, hero-chart-800.avif 800w"
    imagesizes="(max-width: 600px) 100vw, 800px"
  >
</head>
```

### 7.4 Lazy Loading with Blur-Up Placeholder (LQIP)

Low-Quality Image Placeholder prevents layout shift and gives users immediate visual context.

```html
<div class="image-wrapper">
  <!-- Inline tiny base64 placeholder for instant render -->
  <img
    src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQ..."
    data-src="full-resolution-chart.avif"
    alt="Sales trend chart"
    class="lazy-image"
    width="800"
    height="450"
    loading="lazy"
    decoding="async"
  >
</div>
```

```css
.image-wrapper {
  position: relative;
  overflow: hidden;
  background: var(--surface-secondary);
}

.lazy-image {
  width: 100%;
  height: auto;
  filter: blur(20px);
  transform: scale(1.05); /* slight scale to hide blur edges */
  transition: filter 300ms ease, transform 300ms ease;
}

.lazy-image.loaded {
  filter: blur(0);
  transform: scale(1);
}
```

```javascript
// Lazy load images with blur-up effect
const lazyImages = document.querySelectorAll(".lazy-image[data-src]");

const imageObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;

      const img = entry.target;
      const fullSrc = img.dataset.src;

      // Preload the full image
      const preloader = new Image();
      preloader.onload = () => {
        img.src = fullSrc;
        img.classList.add("loaded");
        img.removeAttribute("data-src");
      };
      preloader.src = fullSrc;

      imageObserver.unobserve(img);
    });
  },
  { rootMargin: "200px 0px" }
);

lazyImages.forEach((img) => imageObserver.observe(img));
```

### 7.5 Native Lazy Loading Guidance

```html
<!-- ABOVE THE FOLD: never lazy-load; it hurts LCP -->
<img src="hero.avif" alt="..." loading="eager" fetchpriority="high">

<!-- BELOW THE FOLD: always lazy-load -->
<img src="chart.avif" alt="..." loading="lazy" decoding="async">

<!-- IFRAMES: lazy-load embedded content -->
<iframe src="/reports/embed/42" loading="lazy" title="Embedded report"></iframe>
```

---

## 8. Core Web Vitals for Enterprise SPAs

As of 2025, the three Core Web Vitals are:
- **LCP** (Largest Contentful Paint): < 2.5 seconds
- **INP** (Interaction to Next Paint): < 200 milliseconds
- **CLS** (Cumulative Layout Shift): < 0.1

Only 47% of sites meet all thresholds. Sites meeting them see 8-35% improvements in conversions.

### 8.1 Optimizing LCP

The largest visible element (hero image, heading, data table) must render within 2.5 seconds.

```html
<head>
  <!-- Preload critical resources -->
  <link rel="preload" href="/fonts/inter-var.woff2" as="font" type="font/woff2" crossorigin>
  <link rel="preload" href="/api/dashboard/kpis" as="fetch" crossorigin>

  <!-- Preconnect to API servers -->
  <link rel="preconnect" href="https://api.example.com">
  <link rel="dns-prefetch" href="https://cdn.example.com">

  <!-- Inline critical CSS -->
  <style>
    /* Only styles needed for above-the-fold content */
    .dashboard-shell { display: grid; grid-template-rows: 64px 1fr; min-height: 100vh; }
    .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px; }
  </style>

  <!-- Defer non-critical CSS -->
  <link rel="preload" href="/styles/main.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
  <noscript><link rel="stylesheet" href="/styles/main.css"></noscript>
</head>
```

```javascript
// Server-side: set optimal cache headers for API responses
// Cache-Control: public, max-age=30, stale-while-revalidate=600

// Client-side: prefetch data before navigation
function prefetchRoute(route) {
  const link = document.createElement("link");
  link.rel = "prefetch";
  link.href = `/api${route}`;
  link.as = "fetch";
  link.crossOrigin = "anonymous";
  document.head.appendChild(link);
}

// Prefetch likely next pages on hover
document.querySelectorAll("[data-route]").forEach((link) => {
  link.addEventListener("mouseenter", () => prefetchRoute(link.dataset.route), { once: true });
});
```

### 8.2 Optimizing INP

Every interaction must produce a visual update within 200ms. This is the most challenging metric for enterprise SPAs with heavy JavaScript.

```javascript
// PATTERN 1: Yield to main thread between tasks
async function processLargeDataset(records) {
  const CHUNK_SIZE = 100;

  for (let i = 0; i < records.length; i += CHUNK_SIZE) {
    const chunk = records.slice(i, i + CHUNK_SIZE);
    processChunk(chunk);

    // Yield to let the browser handle pending interactions
    await new Promise((resolve) => setTimeout(resolve, 0));
  }
}

// PATTERN 2: Separate visual updates from heavy computation
textInput.addEventListener("input", (event) => {
  // Do render-critical work synchronously
  updateInputDisplay(event.target.value);

  // Defer heavy computation
  requestAnimationFrame(() => {
    setTimeout(() => {
      runValidation(event.target.value);
      updateFilteredResults(event.target.value);
      syncToServer(event.target.value);
    }, 0);
  });
});

// PATTERN 3: Use Web Workers for CPU-intensive operations
const worker = new Worker("/workers/data-processor.js");

function sortLargeDataset(data, sortConfig) {
  return new Promise((resolve) => {
    worker.onmessage = (e) => resolve(e.data);
    worker.postMessage({ type: "sort", data, sortConfig });
  });
}

// In data-processor.js:
// self.onmessage = (e) => {
//   if (e.data.type === 'sort') {
//     const sorted = e.data.data.sort(compareFn(e.data.sortConfig));
//     self.postMessage(sorted);
//   }
// };
```

```javascript
// PATTERN 4: Avoid layout thrashing
// BAD: forces synchronous layout between read and write
function resizeColumns() {
  columns.forEach((col) => {
    const width = col.offsetWidth;     // READ (forces layout)
    col.style.width = width + 10 + "px"; // WRITE (invalidates layout)
  });
}

// GOOD: batch reads, then batch writes
function resizeColumns() {
  const widths = columns.map((col) => col.offsetWidth); // all READS first

  columns.forEach((col, i) => {
    col.style.width = widths[i] + 10 + "px"; // all WRITES after
  });
}
```

### 8.3 Optimizing CLS

Prevent unexpected layout shifts. Enterprise apps with dynamic data are especially prone.

```css
/* Reserve space for dynamic content */
.kpi-card {
  min-height: 120px; /* prevents shift when data loads */
}

.data-table-container {
  min-height: 400px; /* prevents shift when table renders */
}

/* Always set dimensions on media */
img, video, iframe {
  max-width: 100%;
  height: auto;
}

/* Reserve space for web fonts */
@font-face {
  font-family: "Inter";
  src: url("/fonts/inter-var.woff2") format("woff2");
  font-display: swap;
  size-adjust: 107%; /* match fallback font metrics */
}

/* Prevent shift from dynamic banners/alerts */
.notification-bar {
  min-height: 48px;
  contain: layout;
}
```

```javascript
// Prevent CLS from dynamically inserted content
function insertNotification(message) {
  const container = document.getElementById("notification-area");

  // Container already has reserved space via min-height
  // Content appears inside reserved space, no layout shift
  container.innerHTML = `<div class="notification" role="alert">${message}</div>`;
}

// Prevent CLS from late-loading ads or third-party widgets
function reserveWidgetSpace(containerId, expectedHeight) {
  const container = document.getElementById(containerId);
  container.style.minHeight = `${expectedHeight}px`;
  container.style.contain = "layout";
}
```

### 8.4 SPA-Specific Considerations

```javascript
// Track soft navigations (SPA route changes) for Core Web Vitals
// The web-vitals library supports SPA measurement
import { onLCP, onINP, onCLS } from "web-vitals";

function reportWebVitals(metric) {
  const payload = {
    name: metric.name,
    value: metric.value,
    rating: metric.rating,         // "good" | "needs-improvement" | "poor"
    delta: metric.delta,
    navigationType: metric.navigationType,
    url: window.location.pathname,
  };

  // Send to analytics endpoint
  navigator.sendBeacon("/api/analytics/web-vitals", JSON.stringify(payload));
}

onLCP(reportWebVitals);
onINP(reportWebVitals);
onCLS(reportWebVitals);
```

```javascript
// Route transition with skeleton and progressive loading
async function navigateToRoute(route) {
  // 1. Show skeleton immediately
  renderRouteSkeleton(route);

  // 2. Update URL without blocking
  history.pushState(null, "", route);

  // 3. Fetch data
  const data = await fetchRouteData(route);

  // 4. Render above-the-fold content first
  renderCriticalContent(data);

  // 5. Defer below-the-fold rendering
  requestAnimationFrame(() => {
    setTimeout(() => renderDeferredContent(data), 0);
  });
}
```

---

## Quick Reference: Decision Matrix

| Scenario | Pattern | Implementation |
|---|---|---|
| Page load | Skeleton screen + progressive loading | HTML skeleton, CSS animation, JS priority loader |
| Search input | Debounce (300ms) | `setTimeout`/`clearTimeout` wrapper |
| Scroll tracking | Throttle (100ms) | `setTimeout` gate |
| Element visibility | IntersectionObserver | Native API, passive |
| Container resize | ResizeObserver | Native API |
| Data freshness | Stale-while-revalidate | TanStack Query / SWR library |
| Toggle actions | Optimistic UI | Immediate update + rollback on error |
| 100K+ rows | Virtual scrolling | TanStack Virtual / React Virtuoso |
| Paginated data | Cursor-based pagination | API cursor tokens |
| Off-screen content | `content-visibility: auto` | CSS only |
| Component isolation | CSS `contain` | CSS only |
| Animation prep | `will-change` (temporary) | JS toggle on hover/focus |
| Style specificity | `@layer` cascade layers | CSS only |
| Images below fold | `loading="lazy"` + LQIP | Native + IntersectionObserver |
| Hero images | Preload + `fetchpriority="high"` | `<link rel="preload">` |
| Image formats | AVIF > WebP > JPEG fallback | `<picture>` element |
| Long tasks | Break into chunks + yield | `setTimeout(fn, 0)` |
| Heavy computation | Web Workers | Separate thread |
| Form saves | Inline feedback (< 300ms) | CSS transitions + status text |

---

## Sources

- [Enterprise UX Design in 2026: Challenges and Best Practices](https://www.wearetenet.com/blog/enterprise-ux-design)
- [10 UX/UI Best Practices for Modern Digital Products in 2025](https://devpulse.com/insights/ux-ui-design-best-practices-2025-enterprise-applications/)
- [Skeleton loading screen design - LogRocket](https://blog.logrocket.com/ux-design/skeleton-loading-screen-design/)
- [Skeleton Screens 101 - Nielsen Norman Group](https://www.nngroup.com/articles/skeleton-screens/)
- [Skeleton Screens: What They Are & Why They Improve UX](https://clay.global/blog/skeleton-screen)
- [Loading patterns - Carbon Design System](https://carbondesignsystem.com/patterns/loading-pattern/)
- [Optimize Large Data Grids with Virtual Scrolling](https://www.componentsource.com/news/2025/12/17/optimize-large-data-grids-virtual-scrolling)
- [TanStack Virtual Overview](https://deepwiki.com/TanStack/virtual/1-overview)
- [How To Render Large Datasets In React - Syncfusion](https://www.syncfusion.com/blogs/post/render-large-datasets-in-react)
- [How to Use the Optimistic UI Pattern - freeCodeCamp](https://www.freecodecamp.org/news/how-to-use-the-optimistic-ui-pattern-with-the-useoptimistic-hook-in-react/)
- [Understanding optimistic UI - LogRocket](https://blog.logrocket.com/understanding-optimistic-ui-react-useoptimistic-hook/)
- [Building an Optimistic UI with RxDB](https://rxdb.info/articles/optimistic-ui.html)
- [When to use optimistic updates](https://dnlytras.com/blog/optimistic-updates)
- [Stale-While-Revalidate - web.dev](https://web.dev/articles/stale-while-revalidate)
- [Stale-While-Revalidate: The Caching Strategy That Makes the Web Feel Instant](https://medium.com/@paul.schon/stale-while-revalidate-the-caching-strategy-that-makes-the-web-feel-instant-7e9c78b3173c)
- [React Query vs TanStack Query vs SWR: 2025 Comparison](https://refine.dev/blog/react-query-vs-tanstack-query-vs-swr-2025/)
- [Caching clash: SWR vs. TanStack Query - LogRocket](https://blog.logrocket.com/swr-vs-tanstack-query-react/)
- [Offline-first frontend apps in 2025 - LogRocket](https://blog.logrocket.com/offline-first-frontend-apps-2025-indexeddb-sqlite/)
- [Local-first web application architecture](https://plainvanillaweb.com/blog/articles/2025-07-16-local-first-architecture/)
- [Debouncing and Throttling in JavaScript - Telerik](https://www.telerik.com/blogs/debouncing-and-throttling-in-javascript)
- [Debouncing in React - DeveloperWay](https://www.developerway.com/posts/debouncing-in-react)
- [IntersectionObserver, ResizeObserver, and Reactive Layouts](https://medium.com/@sonali.nogja.08/intersectionobserver-resizeobserver-and-the-new-age-of-reactive-layouts-c7782fa72c6e)
- [content-visibility: the new CSS property - web.dev](https://web.dev/articles/content-visibility)
- [CSS content-visibility is now Baseline - web.dev](https://web.dev/blog/css-content-visibility-baseline)
- [Faster Rendering with content-visibility - DebugBear](https://www.debugbear.com/blog/content-visibility-api)
- [When and how to use CSS will-change - LogRocket](https://blog.logrocket.com/when-how-use-css-will-change/)
- [CSS Cascade Layers - Smashing Magazine](https://www.smashingmagazine.com/2025/06/css-cascade-layers-bem-utility-classes-specificity-control/)
- [Integrating CSS Cascade Layers - Smashing Magazine](https://www.smashingmagazine.com/2025/09/integrating-css-cascade-layers-existing-project/)
- [Image Optimization in 2025: WebP/AVIF, srcset, and Preload](https://aibudwp.com/image-optimization-in-2025-webp-avif-srcset-and-preload/)
- [Modern Image Optimization Techniques 2025 - FrontendTools](https://www.frontendtools.tech/blog/modern-image-optimization-techniques-2025)
- [Core Web Vitals Optimization Guide 2025](https://www.ateamsoftsolutions.com/core-web-vitals-optimization-guide-2025-showing-lcp-inp-cls-metrics-and-performance-improvement-strategies-for-web-applications/)
- [The Most Important Core Web Vitals Metrics in 2026](https://nitropack.io/blog/most-important-core-web-vitals-metrics/)
- [Optimize Interaction to Next Paint - web.dev](https://web.dev/articles/optimize-inp)
- [Interaction to Next Paint - web.dev](https://web.dev/articles/inp)
- [Micro Interactions in Web Design 2025](https://www.stan.vision/journal/micro-interactions-2025-in-web-design)
- [UX Strategies For Real-Time Dashboards - Smashing Magazine](https://www.smashingmagazine.com/2025/09/ux-strategies-real-time-dashboards/)
- [Progressive Loading - UX Patterns for Devs](https://uxpatterns.dev/glossary/progressive-loading)
- [Pagination vs. Infinite Scroll vs. Load More - LogRocket](https://blog.logrocket.com/ux-design/pagination-vs-infinite-scroll-ux/)
