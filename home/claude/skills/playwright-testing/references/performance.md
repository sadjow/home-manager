# Performance Testing

## Core Web Vitals

### Measuring LCP (Largest Contentful Paint)

Target: < 2.5 seconds

```typescript
import { test, expect } from '@playwright/test'

test('LCP is under 2.5 seconds', async ({ page }) => {
  await page.goto('/')

  const lcp = await page.evaluate(() =>
    new Promise<number>((resolve) => {
      new PerformanceObserver((list) => {
        const entries = list.getEntries()
        const lastEntry = entries[entries.length - 1]
        resolve(lastEntry.startTime)
      }).observe({ type: 'largest-contentful-paint', buffered: true })
    })
  )

  expect(lcp).toBeLessThan(2500)
})
```

### Measuring CLS (Cumulative Layout Shift)

Target: < 0.1

```typescript
test('CLS is under 0.1', async ({ page }) => {
  await page.goto('/')

  // Scroll to trigger layout shifts
  await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight))
  await page.waitForTimeout(1000)

  const cls = await page.evaluate(() =>
    new Promise<number>((resolve) => {
      let clsValue = 0
      new PerformanceObserver((list) => {
        for (const entry of list.getEntries() as any[]) {
          if (!entry.hadRecentInput) {
            clsValue += entry.value
          }
        }
        resolve(clsValue)
      }).observe({ type: 'layout-shift', buffered: true })

      // Give observer time to collect entries
      setTimeout(() => resolve(clsValue), 2000)
    })
  )

  expect(cls).toBeLessThan(0.1)
})
```

### Measuring FCP (First Contentful Paint)

Target: < 1.8 seconds

```typescript
test('FCP is under 1.8 seconds', async ({ page }) => {
  await page.goto('/')

  const fcp = await page.evaluate(() => {
    const entry = performance.getEntriesByName('first-contentful-paint')[0]
    return entry?.startTime ?? -1
  })

  expect(fcp).toBeGreaterThan(0)
  expect(fcp).toBeLessThan(1800)
})
```

### Measuring TTFB (Time to First Byte)

Target: < 800ms

```typescript
test('TTFB is under 800ms', async ({ page }) => {
  await page.goto('/')

  const ttfb = await page.evaluate(() => {
    const nav = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming
    return nav.responseStart - nav.requestStart
  })

  expect(ttfb).toBeLessThan(800)
})
```

## Performance Budget

Define budgets and validate in tests:

```typescript
const PERFORMANCE_BUDGET = {
  lcp: 2500,
  fcp: 1800,
  cls: 0.1,
  ttfb: 800,
  totalPageSize: 3 * 1024 * 1024,   // 3MB
  totalRequests: 50,
  jsSize: 500 * 1024,               // 500KB
  imageSize: 1.5 * 1024 * 1024,     // 1.5MB
} as const

test('page stays within performance budget', async ({ page }) => {
  const resources: { size: number; type: string }[] = []

  page.on('response', async (response) => {
    const url = response.url()
    if (!url.startsWith('data:')) {
      const headers = response.headers()
      const size = parseInt(headers['content-length'] || '0')
      const type = headers['content-type'] || ''
      resources.push({ size, type })
    }
  })

  await page.goto('/')
  await page.waitForLoadState('networkidle')

  const totalSize = resources.reduce((sum, r) => sum + r.size, 0)
  expect(totalSize).toBeLessThan(PERFORMANCE_BUDGET.totalPageSize)
  expect(resources.length).toBeLessThan(PERFORMANCE_BUDGET.totalRequests)

  const jsSize = resources
    .filter((r) => r.type.includes('javascript'))
    .reduce((sum, r) => sum + r.size, 0)
  expect(jsSize).toBeLessThan(PERFORMANCE_BUDGET.jsSize)

  const imageSize = resources
    .filter((r) => r.type.includes('image'))
    .reduce((sum, r) => sum + r.size, 0)
  expect(imageSize).toBeLessThan(PERFORMANCE_BUDGET.imageSize)
})
```

## Network Performance

### Resource Timing

```typescript
test('critical resources load fast', async ({ page }) => {
  await page.goto('/')

  const resourceTimings = await page.evaluate(() => {
    const entries = performance.getEntriesByType('resource') as PerformanceResourceTiming[]
    return entries.map((e) => ({
      name: e.name,
      duration: e.duration,
      transferSize: e.transferSize,
      type: e.initiatorType,
    }))
  })

  const slowResources = resourceTimings.filter((r) => r.duration > 3000)
  expect(slowResources, 'resources taking over 3s').toEqual([])
})
```

### Request Count by Type

```typescript
test('reasonable number of requests per type', async ({ page }) => {
  const requestsByType = new Map<string, number>()

  page.on('request', (request) => {
    const type = request.resourceType()
    requestsByType.set(type, (requestsByType.get(type) || 0) + 1)
  })

  await page.goto('/')
  await page.waitForLoadState('networkidle')

  expect(requestsByType.get('script') || 0).toBeLessThan(15)
  expect(requestsByType.get('stylesheet') || 0).toBeLessThan(5)
  expect(requestsByType.get('image') || 0).toBeLessThan(30)
  expect(requestsByType.get('font') || 0).toBeLessThan(6)
})
```

## Tracing

Enable tracing for performance debugging:

```typescript
// playwright.config.ts
use: {
  trace: 'on-first-retry',  // Captures trace on failure
}
```

Manual tracing in tests:

```typescript
test('checkout performance trace', async ({ page, context }) => {
  await context.tracing.start({ screenshots: true, snapshots: true })

  await page.goto('/checkout')
  await page.getByLabel('Card number').fill('4242424242424242')
  await page.getByRole('button', { name: 'Pay' }).click()
  await expect(page.getByText('Confirmed')).toBeVisible()

  await context.tracing.stop({ path: 'checkout-trace.zip' })
})
```

View trace: `npx playwright show-trace checkout-trace.zip`

## Navigation Timing

```typescript
test('page load timing breakdown', async ({ page }) => {
  await page.goto('/')

  const timing = await page.evaluate(() => {
    const nav = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming
    return {
      dns: nav.domainLookupEnd - nav.domainLookupStart,
      tcp: nav.connectEnd - nav.connectStart,
      ttfb: nav.responseStart - nav.requestStart,
      download: nav.responseEnd - nav.responseStart,
      domParsing: nav.domInteractive - nav.responseEnd,
      domComplete: nav.domComplete - nav.domInteractive,
      total: nav.loadEventEnd - nav.startTime,
    }
  })

  expect(timing.total).toBeLessThan(5000)
  expect(timing.ttfb).toBeLessThan(800)
})
```

## Memory & CPU (Chromium Only)

```typescript
test('no memory leaks on navigation', async ({ page }) => {
  await page.goto('/')

  const initialMemory = await page.evaluate(
    () => (performance as any).memory?.usedJSHeapSize || 0
  )

  // Navigate back and forth
  for (let i = 0; i < 5; i++) {
    await page.goto('/about')
    await page.goto('/')
  }

  const finalMemory = await page.evaluate(
    () => (performance as any).memory?.usedJSHeapSize || 0
  )

  const memoryGrowth = finalMemory - initialMemory
  const growthMB = memoryGrowth / (1024 * 1024)
  expect(growthMB).toBeLessThan(50)
})
```

## Slow Network Simulation

```typescript
test('page loads within budget on 3G', async ({ page, context }) => {
  const cdp = await context.newCDPSession(page)
  await cdp.send('Network.emulateNetworkConditions', {
    offline: false,
    downloadThroughput: (1.6 * 1024 * 1024) / 8,  // 1.6 Mbps
    uploadThroughput: (750 * 1024) / 8,             // 750 Kbps
    latency: 150,
  })

  const start = Date.now()
  await page.goto('/', { waitUntil: 'domcontentloaded' })
  const loadTime = Date.now() - start

  expect(loadTime).toBeLessThan(10_000)
})
```
