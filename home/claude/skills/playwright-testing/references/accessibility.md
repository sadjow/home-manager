# Accessibility Testing

## Setup

Install axe-core integration:

```bash
npm install -D @axe-core/playwright
# or
yarn add -D @axe-core/playwright
```

## Basic Accessibility Scan

```typescript
import { test, expect } from '@playwright/test'
import AxeBuilder from '@axe-core/playwright'

test('homepage has no accessibility violations', async ({ page }) => {
  await page.goto('/')
  const results = await new AxeBuilder({ page }).analyze()
  expect(results.violations).toEqual([])
})
```

## WCAG 2.1 AA Compliance

Filter to WCAG A and AA rules:

```typescript
test('page meets WCAG 2.1 AA', async ({ page }) => {
  await page.goto('/')
  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
    .analyze()
  expect(results.violations).toEqual([])
})
```

Available tag groups:
- `wcag2a` — WCAG 2.0 Level A
- `wcag2aa` — WCAG 2.0 Level AA
- `wcag21a` — WCAG 2.1 Level A
- `wcag21aa` — WCAG 2.1 Level AA
- `best-practice` — Common accessibility best practices

## Targeted Scanning

Scan specific sections:

```typescript
test('navigation is accessible', async ({ page }) => {
  await page.goto('/')
  const results = await new AxeBuilder({ page })
    .include('nav')
    .analyze()
  expect(results.violations).toEqual([])
})
```

Exclude known problematic areas (temporary — track resolution):

```typescript
const results = await new AxeBuilder({ page })
  .exclude('.third-party-widget')
  .analyze()
```

## Reusable Fixture

Create a shared fixture for consistent config across all tests:

```typescript
// e2e/fixtures.ts
import { test as base, expect } from '@playwright/test'
import AxeBuilder from '@axe-core/playwright'

type AxeFixture = {
  makeAxeBuilder: () => AxeBuilder
}

export const test = base.extend<AxeFixture>({
  makeAxeBuilder: async ({ page }, use) => {
    const makeAxeBuilder = () =>
      new AxeBuilder({ page })
        .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
        .exclude('.known-issue-banner')
    await use(makeAxeBuilder)
  },
})

export { expect }
```

Usage:

```typescript
import { test, expect } from './fixtures'

test('dashboard is accessible', async ({ page, makeAxeBuilder }) => {
  await page.goto('/dashboard')
  const results = await makeAxeBuilder().analyze()
  expect(results.violations).toEqual([])
})
```

## Handling Known Violations

### Disable Specific Rules

When addressing preexisting issues incrementally:

```typescript
const results = await new AxeBuilder({ page })
  .disableRules(['color-contrast', 'heading-order'])
  .analyze()
```

### Snapshot Known Violations

Track known issues to prevent regression:

```typescript
test('no new accessibility violations', async ({ page }) => {
  await page.goto('/')
  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
    .analyze()

  const violationFingerprints = results.violations.map(
    ({ id, nodes }) => ({
      rule: id,
      targets: nodes.map((n) => n.target),
    })
  )

  expect(violationFingerprints).toMatchSnapshot('a11y-violations.json')
})
```

## Attaching Results to Test Report

Include full results in HTML report for debugging:

```typescript
test('accessible page', async ({ page }, testInfo) => {
  await page.goto('/')
  const results = await new AxeBuilder({ page }).analyze()

  await testInfo.attach('accessibility-scan', {
    body: JSON.stringify(results, null, 2),
    contentType: 'application/json',
  })

  expect(results.violations).toEqual([])
})
```

## Accessibility After Interactions

Scan dynamic content after user actions:

```typescript
test('modal is accessible when opened', async ({ page, makeAxeBuilder }) => {
  await page.goto('/')
  await page.getByRole('button', { name: 'Open settings' }).click()

  const dialog = page.getByRole('dialog', { name: 'Settings' })
  await expect(dialog).toBeVisible()

  const results = await makeAxeBuilder().include('[role="dialog"]').analyze()
  expect(results.violations).toEqual([])
})
```

## Manual Accessibility Checks

Automated scanning catches ~30-40% of WCAG issues. Complement with:

```typescript
test('focus trap works in modal', async ({ page }) => {
  await page.getByRole('button', { name: 'Open menu' }).click()
  const dialog = page.getByRole('dialog')
  await expect(dialog).toBeVisible()

  // Focus should be trapped within dialog
  await page.keyboard.press('Tab')
  const focused = page.locator(':focus')
  await expect(focused).toBeVisible()

  // Check focus is inside dialog
  const focusedInDialog = await focused.evaluate(
    (el) => el.closest('[role="dialog"]') !== null
  )
  expect(focusedInDialog).toBe(true)
})

test('skip navigation link works', async ({ page }) => {
  await page.goto('/')
  await page.keyboard.press('Tab')
  const skipLink = page.getByRole('link', { name: /skip to/i })
  await expect(skipLink).toBeFocused()

  await page.keyboard.press('Enter')
  const main = page.getByRole('main')
  const focused = page.locator(':focus')
  await expect(focused).toHaveAttribute('id', await main.getAttribute('id') || '')
})

test('images have alt text', async ({ page }) => {
  await page.goto('/')
  const images = page.getByRole('img')
  const count = await images.count()

  for (let i = 0; i < count; i++) {
    const alt = await images.nth(i).getAttribute('alt')
    expect(alt, `image ${i} missing alt text`).toBeTruthy()
  }
})

test('form error messages are announced', async ({ page }) => {
  await page.goto('/signup')
  await page.getByRole('button', { name: 'Submit' }).click()

  const errorMessage = page.getByRole('alert')
  await expect(errorMessage).toBeVisible()
  await expect(errorMessage).toHaveAttribute('aria-live', 'polite')
})
```

## Color Scheme Testing

```typescript
test('dark mode has no a11y issues', async ({ page, makeAxeBuilder }) => {
  await page.emulateMedia({ colorScheme: 'dark' })
  await page.goto('/')
  const results = await makeAxeBuilder().analyze()
  expect(results.violations).toEqual([])
})

test('reduced motion is respected', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await page.goto('/')

  const hasAnimations = await page.evaluate(() => {
    const elements = document.querySelectorAll('*')
    for (const el of elements) {
      const style = getComputedStyle(el)
      if (style.animationDuration !== '0s' && style.animationName !== 'none') {
        return true
      }
    }
    return false
  })

  expect(hasAnimations).toBe(false)
})
```
