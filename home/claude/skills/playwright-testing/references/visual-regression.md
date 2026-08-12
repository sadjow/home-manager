# Visual Regression Testing

## Basic Screenshot Comparison

```typescript
import { test, expect } from '@playwright/test'

test('homepage visual regression', async ({ page }) => {
  await page.goto('/')
  await expect(page).toHaveScreenshot('homepage.png')
})

test('component visual regression', async ({ page }) => {
  await page.goto('/components')
  const card = page.getByTestId('product-card')
  await expect(card).toHaveScreenshot('product-card.png')
})
```

First run creates baseline snapshots. Subsequent runs compare against them.

## Configuration Options

```typescript
await expect(page).toHaveScreenshot('page.png', {
  fullPage: true,                    // Capture entire scrollable page
  maxDiffPixels: 100,                // Allow up to 100 differing pixels
  maxDiffPixelRatio: 0.01,           // Or 1% of total pixels
  threshold: 0.2,                    // Per-pixel color diff tolerance (0-1)
  animations: 'disabled',           // Freeze CSS animations
  mask: [page.getByTestId('date')], // Mask dynamic content
  maskColor: '#FF00FF',             // Mask overlay color
  omitBackground: true,             // Transparent background (PNG only)
  scale: 'css',                     // 'css' or 'device' pixel scale
})
```

## Masking Dynamic Content

Hide elements that change between runs (timestamps, avatars, ads):

```typescript
test('dashboard without dynamic content', async ({ page }) => {
  await page.goto('/dashboard')

  await expect(page).toHaveScreenshot('dashboard.png', {
    mask: [
      page.getByTestId('current-time'),
      page.getByTestId('user-avatar'),
      page.getByTestId('live-chart'),
    ],
  })
})
```

## Custom Stylesheets for Stability

Hide animations and dynamic content via CSS:

```typescript
test('stable visual snapshot', async ({ page }) => {
  await page.goto('/')

  await page.addStyleTag({
    content: `
      *, *::before, *::after {
        animation-duration: 0s !important;
        transition-duration: 0s !important;
        animation-delay: 0s !important;
      }
      .dynamic-banner, .live-counter { visibility: hidden !important; }
    `,
  })

  await expect(page).toHaveScreenshot('stable-page.png')
})
```

## Multi-Viewport Visual Testing

```typescript
const VIEWPORTS = {
  mobile: { width: 375, height: 667 },
  tablet: { width: 768, height: 1024 },
  desktop: { width: 1280, height: 720 },
} as const

for (const [name, viewport] of Object.entries(VIEWPORTS)) {
  test(`homepage at ${name}`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto('/')

    await expect(page).toHaveScreenshot(`homepage-${name}.png`, {
      fullPage: true,
      animations: 'disabled',
      maxDiffPixelRatio: 0.01,
    })
  })
}
```

## Color Scheme Variants

```typescript
for (const scheme of ['light', 'dark'] as const) {
  test(`homepage in ${scheme} mode`, async ({ page }) => {
    await page.emulateMedia({ colorScheme: scheme })
    await page.goto('/')

    await expect(page).toHaveScreenshot(`homepage-${scheme}.png`, {
      fullPage: true,
    })
  })
}
```

## Component-Level Snapshots

More stable than full-page screenshots:

```typescript
test('button states', async ({ page }) => {
  await page.goto('/components/buttons')

  const button = page.getByRole('button', { name: 'Primary' })

  // Default state
  await expect(button).toHaveScreenshot('btn-default.png')

  // Hover state
  await button.hover()
  await expect(button).toHaveScreenshot('btn-hover.png')

  // Focus state
  await button.focus()
  await expect(button).toHaveScreenshot('btn-focus.png')

  // Disabled state
  const disabledBtn = page.getByRole('button', { name: 'Disabled' })
  await expect(disabledBtn).toHaveScreenshot('btn-disabled.png')
})
```

## Snapshot Management

### Update Baselines

```bash
npx playwright test --update-snapshots
```

### Snapshot Storage

Snapshots stored at: `{test-file}-snapshots/{snapshot-name}-{project}-{platform}.png`

Configure custom path in `playwright.config.ts`:

```typescript
export default defineConfig({
  snapshotPathTemplate: '{testDir}/__snapshots__/{testFilePath}/{arg}{ext}',
})
```

### CI Considerations

- Generate baseline snapshots on the same OS as CI (Linux recommended)
- Use Docker for consistent rendering across environments
- Store snapshots in version control

```typescript
// playwright.config.ts
expect: {
  toHaveScreenshot: {
    maxDiffPixelRatio: 0.01,
    animations: 'disabled',
    scale: 'css',
  },
},
```

## Waiting for Stable State

Ensure page is fully rendered before capturing:

```typescript
test('page fully loaded before snapshot', async ({ page }) => {
  await page.goto('/')
  await page.waitForLoadState('networkidle')

  // Wait for specific content
  await expect(page.getByRole('main')).toBeVisible()

  // Wait for fonts
  await page.evaluate(() => document.fonts.ready)

  // Wait for images
  await page.evaluate(async () => {
    const images = document.querySelectorAll('img')
    await Promise.all(
      Array.from(images)
        .filter((img) => !img.complete)
        .map((img) => new Promise((resolve) => {
          img.addEventListener('load', resolve)
          img.addEventListener('error', resolve)
        }))
    )
  })

  await expect(page).toHaveScreenshot('fully-loaded.png')
})
```
