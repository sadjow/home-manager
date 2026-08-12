# Responsive Design Testing (Mobile-First)

## Breakpoint Strategy

Test from smallest viewport upward. This matches mobile-first CSS methodology and catches layout issues at each breakpoint transition.

```typescript
const BREAKPOINTS = {
  mobile: { width: 375, height: 667 },
  mobileLarge: { width: 428, height: 926 },
  tablet: { width: 768, height: 1024 },
  laptop: { width: 1024, height: 768 },
  desktop: { width: 1280, height: 720 },
  wide: { width: 1920, height: 1080 },
} as const

type Breakpoint = keyof typeof BREAKPOINTS
```

## Device Emulation via Projects

Configure projects in `playwright.config.ts` for automatic multi-device testing:

```typescript
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  projects: [
    // Mobile-first order
    { name: 'mobile-chrome', use: { ...devices['Pixel 7'] } },
    { name: 'mobile-safari', use: { ...devices['iPhone 15'] } },
    { name: 'tablet', use: { ...devices['iPad (gen 7)'] } },
    { name: 'desktop-chrome', use: { ...devices['Desktop Chrome'] } },
    { name: 'desktop-firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'desktop-safari', use: { ...devices['Desktop Safari'] } },
  ],
})
```

Device profiles include: `viewport`, `userAgent`, `deviceScaleFactor`, `isMobile`, `hasTouch`.

## Touch vs. Non-Touch at Mobile Viewports

A mobile viewport does NOT mean touch. Users resize desktop browsers to small widths all the time — they have a mouse, no touch events, and expect horizontal scroll via mouse wheel, drag, or arrow buttons. Components that only work via touch swipe (carousels, trending sections, horizontal lists) will be completely broken for these users.

**Always test both scenarios:**

1. **Real device emulation** (touch, `isMobile: true`) — e.g. `devices['Pixel 7']`
2. **Desktop browser at mobile viewport** (mouse, no touch, `isMobile: false`) — desktop browser resized small

### Config: Desktop-at-Mobile-Viewport Project

```typescript
// playwright.config.ts — add alongside regular mobile/desktop projects
{
  name: 'desktop-small-viewport',
  use: {
    ...devices['Desktop Chrome'],
    viewport: { width: 375, height: 667 },
    // isMobile: false (default for Desktop Chrome)
    // hasTouch: false (default for Desktop Chrome)
  },
},
```

This catches the exact scenario where a user shrinks their desktop browser and touch-only UX patterns fail.

### What Breaks Without This

| Component | Touch device | Desktop at mobile viewport |
|---|---|---|
| Horizontal swipe carousel | Swipe works | No scroll, no swipe — **broken** |
| Pull-to-refresh | Pull gesture works | No equivalent — **broken** |
| Swipe-to-dismiss | Swipe works | No dismiss mechanism — **broken** |
| Horizontal scrollable list | Touch scroll works | Mouse wheel may not scroll horizontally — **broken** |
| Pinch-to-zoom | Pinch works | No equivalent (Ctrl+scroll zooms page) — **broken** |

### UX Requirements for Horizontal Scroll Components

When building or testing carousels, trending sections, or any horizontally scrollable content, ensure ALL of these work:

1. **Touch swipe** — standard for mobile devices
2. **CSS `overflow-x: auto`** — enables native horizontal scroll on all platforms
3. **Mouse wheel horizontal scroll** — some mice/trackpads send horizontal wheel events
4. **Arrow buttons** — visible prev/next buttons for mouse users
5. **Keyboard navigation** — arrow keys when focused, for accessibility
6. **Drag-to-scroll** (optional) — mouse click + drag as a swipe alternative
7. **Scroll snap** — `scroll-snap-type: x mandatory` for clean stopping points

## Per-Test Viewport Override

For testing specific breakpoint behavior within a single test:

```typescript
test('navigation collapses to hamburger on mobile', async ({ page }) => {
  await page.setViewportSize(BREAKPOINTS.mobile)
  await page.goto('/')

  await expect(page.getByRole('button', { name: 'Menu' })).toBeVisible()
  await expect(page.getByRole('navigation', { name: 'Main' })).toBeHidden()
})

test('navigation shows full links on desktop', async ({ page }) => {
  await page.setViewportSize(BREAKPOINTS.desktop)
  await page.goto('/')

  await expect(page.getByRole('button', { name: 'Menu' })).toBeHidden()
  await expect(page.getByRole('navigation', { name: 'Main' })).toBeVisible()
})
```

## Responsive Test Helper

Loop through all breakpoints to validate layout at each:

```typescript
import { test, expect } from '@playwright/test'

const BREAKPOINTS = {
  mobile: { width: 375, height: 667 },
  tablet: { width: 768, height: 1024 },
  desktop: { width: 1280, height: 720 },
} as const

for (const [name, viewport] of Object.entries(BREAKPOINTS)) {
  test(`homepage renders correctly at ${name} (${viewport.width}x${viewport.height})`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto('/')

    await expect(page.getByRole('heading', { level: 1 })).toBeVisible()
    await expect(page.getByRole('main')).toBeVisible()

    if (viewport.width < 768) {
      await expect(page.getByRole('button', { name: 'Menu' })).toBeVisible()
    } else {
      await expect(page.getByRole('navigation')).toBeVisible()
    }
  })
}
```

## Common Responsive Checks

### Layout Structure

```typescript
test('sidebar moves below content on mobile', async ({ page }) => {
  await page.setViewportSize(BREAKPOINTS.mobile)
  await page.goto('/dashboard')

  const main = page.getByRole('main')
  const sidebar = page.getByRole('complementary')
  const mainBox = await main.boundingBox()
  const sidebarBox = await sidebar.boundingBox()

  expect(sidebarBox!.y).toBeGreaterThan(mainBox!.y)
})
```

### Touch Interactions

```typescript
test('swipe to dismiss on mobile', async ({ page, context }) => {
  // Device profiles with isMobile: true enable touch events
  await page.goto('/notifications')

  const notification = page.getByRole('alert').first()
  const box = await notification.boundingBox()

  await page.touchscreen.tap(box!.x + box!.width / 2, box!.y + box!.height / 2)
})
```

### Image Responsiveness

```typescript
test('hero image uses correct srcset', async ({ page }) => {
  await page.setViewportSize(BREAKPOINTS.mobile)
  await page.goto('/')

  const img = page.getByRole('img', { name: 'Hero banner' })
  await expect(img).toBeVisible()

  const srcset = await img.getAttribute('srcset')
  expect(srcset).toBeTruthy()

  const currentSrc = await img.evaluate((el: HTMLImageElement) => el.currentSrc)
  expect(currentSrc).toContain('mobile')
})
```

### Typography Scaling

```typescript
test('heading font size adapts to viewport', async ({ page }) => {
  const heading = page.getByRole('heading', { level: 1 })

  await page.setViewportSize(BREAKPOINTS.mobile)
  await page.goto('/')
  const mobileFontSize = await heading.evaluate(
    (el) => parseFloat(getComputedStyle(el).fontSize)
  )

  await page.setViewportSize(BREAKPOINTS.desktop)
  await page.goto('/')
  const desktopFontSize = await heading.evaluate(
    (el) => parseFloat(getComputedStyle(el).fontSize)
  )

  expect(desktopFontSize).toBeGreaterThan(mobileFontSize)
})
```

### Overflow Detection

```typescript
test('no horizontal overflow at any breakpoint', async ({ page }) => {
  for (const [name, viewport] of Object.entries(BREAKPOINTS)) {
    await page.setViewportSize(viewport)
    await page.goto('/')

    const hasOverflow = await page.evaluate(() => {
      return document.documentElement.scrollWidth > document.documentElement.clientWidth
    })

    expect(hasOverflow, `horizontal overflow at ${name}`).toBe(false)
  }
})
```

## Horizontal Scroll / Carousel Testing (Touch vs. Non-Touch)

This is one of the most common responsive UX bugs: a carousel or trending section works via swipe on a phone but is completely unusable when a desktop user resizes their browser to a narrow viewport.

### Test: Horizontal Scroll Works WITHOUT Touch

```typescript
test.describe('horizontal scroll on desktop at mobile viewport', () => {
  test.use({
    viewport: { width: 375, height: 667 },
    // Desktop browser — no touch, no isMobile
  })

  test('trending section scrolls horizontally via overflow', async ({ page }) => {
    await page.goto('/')

    const scrollContainer = page.getByTestId('trending-scroll')
    await expect(scrollContainer).toBeVisible()

    const overflowX = await scrollContainer.evaluate(
      (el) => getComputedStyle(el).overflowX
    )
    expect(
      ['auto', 'scroll'].includes(overflowX),
      `overflow-x should be auto or scroll, got "${overflowX}"`
    ).toBe(true)
  })

  test('trending section is actually scrollable (content wider than container)', async ({ page }) => {
    await page.goto('/')

    const scrollContainer = page.getByTestId('trending-scroll')
    const { scrollWidth, clientWidth } = await scrollContainer.evaluate((el) => ({
      scrollWidth: el.scrollWidth,
      clientWidth: el.clientWidth,
    }))

    expect(
      scrollWidth,
      'content should be wider than container to enable scrolling'
    ).toBeGreaterThan(clientWidth)
  })

  test('trending section can scroll to reveal hidden items via mouse wheel', async ({ page }) => {
    await page.goto('/')

    const scrollContainer = page.getByTestId('trending-scroll')
    const initialScroll = await scrollContainer.evaluate((el) => el.scrollLeft)

    // Simulate horizontal wheel event (shift+wheel or trackpad horizontal scroll)
    await scrollContainer.hover()
    await page.mouse.wheel(200, 0)

    const newScroll = await scrollContainer.evaluate((el) => el.scrollLeft)
    expect(newScroll, 'horizontal scroll should have moved').toBeGreaterThan(initialScroll)
  })

  test('arrow buttons are visible for non-touch navigation', async ({ page }) => {
    await page.goto('/')

    const nextButton = page.getByRole('button', { name: /next/i })
    await expect(nextButton).toBeVisible()

    await nextButton.click()

    const scrollContainer = page.getByTestId('trending-scroll')
    const scrollLeft = await scrollContainer.evaluate((el) => el.scrollLeft)
    expect(scrollLeft).toBeGreaterThan(0)
  })

  test('keyboard arrow keys scroll when container is focused', async ({ page }) => {
    await page.goto('/')

    const scrollContainer = page.getByTestId('trending-scroll')
    await scrollContainer.focus()

    const initialScroll = await scrollContainer.evaluate((el) => el.scrollLeft)
    await page.keyboard.press('ArrowRight')

    const newScroll = await scrollContainer.evaluate((el) => el.scrollLeft)
    expect(newScroll).toBeGreaterThan(initialScroll)
  })
})
```

### Test: Touch Swipe Works on Mobile Device

```typescript
test.describe('horizontal scroll on touch device', () => {
  test.use({
    ...devices['Pixel 7'],
    // isMobile: true, hasTouch: true
  })

  test('trending section supports touch swipe', async ({ page }) => {
    await page.goto('/')

    const scrollContainer = page.getByTestId('trending-scroll')
    const box = await scrollContainer.boundingBox()

    // Swipe left
    await page.touchscreen.tap(box!.x + box!.width * 0.8, box!.y + box!.height / 2)
    await page.mouse.move(box!.x + box!.width * 0.8, box!.y + box!.height / 2)
    await page.mouse.down()
    await page.mouse.move(box!.x + box!.width * 0.2, box!.y + box!.height / 2, { steps: 10 })
    await page.mouse.up()

    const scrollLeft = await scrollContainer.evaluate((el) => el.scrollLeft)
    expect(scrollLeft).toBeGreaterThan(0)
  })
})
```

### Test: Both Scenarios in a Matrix

```typescript
const SCROLL_SCENARIOS = [
  {
    name: 'touch-mobile',
    use: { ...devices['Pixel 7'] },
    hasTouch: true,
  },
  {
    name: 'desktop-at-mobile-viewport',
    use: {
      ...devices['Desktop Chrome'],
      viewport: { width: 375, height: 667 },
    },
    hasTouch: false,
  },
] as const

for (const scenario of SCROLL_SCENARIOS) {
  test.describe(`horizontal scroll — ${scenario.name}`, () => {
    test.use(scenario.use)

    test('all trending items are reachable', async ({ page }) => {
      await page.goto('/')

      const scrollContainer = page.getByTestId('trending-scroll')
      const items = scrollContainer.getByRole('listitem')
      const itemCount = await items.count()

      expect(itemCount).toBeGreaterThan(0)

      // Scroll to the last item
      const lastItem = items.last()
      await lastItem.scrollIntoViewIfNeeded()
      await expect(lastItem).toBeVisible()
    })

    test('scroll snap stops cleanly on items', async ({ page }) => {
      await page.goto('/')

      const scrollContainer = page.getByTestId('trending-scroll')
      const snapType = await scrollContainer.evaluate(
        (el) => getComputedStyle(el).scrollSnapType
      )

      expect(snapType).toContain('x')
    })
  })
}
```

### CSS Requirements Checklist for Horizontal Scroll Components

When reviewing or building horizontal scroll UIs, verify these CSS properties:

```typescript
test('horizontal scroll container has correct CSS for universal support', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 })
  await page.goto('/')

  const scrollContainer = page.getByTestId('trending-scroll')
  const styles = await scrollContainer.evaluate((el) => {
    const s = getComputedStyle(el)
    return {
      display: s.display,
      overflowX: s.overflowX,
      scrollSnapType: s.scrollSnapType,
      WebkitOverflowScrolling: s.getPropertyValue('-webkit-overflow-scrolling'),
    }
  })

  expect(['auto', 'scroll']).toContain(styles.overflowX)

  // Flex for horizontal layout
  expect(['flex', 'inline-flex']).toContain(styles.display)
})
```

**Essential CSS for universal horizontal scroll:**

```css
.scroll-container {
  display: flex;
  overflow-x: auto;               /* enables scroll on ALL platforms */
  scroll-snap-type: x mandatory;  /* clean stopping points */
  -webkit-overflow-scrolling: touch; /* smooth momentum on iOS */
  gap: 1rem;
  scrollbar-width: thin;          /* visible but subtle scrollbar on desktop */
}

.scroll-container::-webkit-scrollbar {
  height: 6px;                    /* visible scrollbar hint on desktop */
}

.scroll-item {
  flex: 0 0 auto;                /* prevent items from shrinking */
  scroll-snap-align: start;
}
```

## Visual Regression Across Viewports

```typescript
for (const [name, viewport] of Object.entries(BREAKPOINTS)) {
  test(`visual snapshot at ${name}`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto('/')
    await expect(page).toHaveScreenshot(`homepage-${name}.png`, {
      fullPage: true,
      maxDiffPixelRatio: 0.01,
    })
  })
}
```
