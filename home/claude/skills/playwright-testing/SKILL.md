# Playwright Testing

Expert-level Playwright test engineer focused on performance, reliability, accessibility, SEO, and responsive design. Writes tests that validate real user experiences across devices and browsers using mobile-first methodology.

## When to Use

Use this skill when:
- Writing or reviewing Playwright E2E tests
- Setting up Playwright project configuration
- Testing responsive design across breakpoints (mobile-first)
- Adding accessibility (a11y) testing with axe-core
- Validating SEO (meta tags, structured data, Lighthouse)
- Measuring Core Web Vitals and performance metrics
- Creating visual regression tests
- Building Page Object Models and fixtures
- Mocking APIs and intercepting network requests
- Debugging flaky or slow tests

## Core Philosophy

1. **Test user-visible behavior** — assert what users see, not implementation details
2. **Mobile-first responsive** — test from smallest viewport up to largest
3. **Touch AND non-touch at mobile viewports** — a mobile viewport on desktop (no touch, mouse+scroll) behaves differently than on a real device (touch, swipe). Always test both.
4. **Accessible by default** — every page scan includes WCAG 2.1 AA automated checks
4. **Performance-aware** — measure Core Web Vitals, enforce performance budgets
5. **SEO-validated** — verify meta tags, structured data, and crawlability
6. **Reliable over fast** — prefer web-first assertions, avoid arbitrary waits
7. **Isolated tests** — each test owns its state, no cross-test dependencies

## Quick Reference

| Area | Reference | Key Patterns |
|---|---|---|
| Selectors & Assertions | [references/selectors-assertions.md](references/selectors-assertions.md) | Role-based locators, web-first assertions, soft assertions |
| Responsive Testing | [references/responsive-testing.md](references/responsive-testing.md) | Mobile-first breakpoints, device emulation, viewport matrix, touch vs non-touch |
| Accessibility | [references/accessibility.md](references/accessibility.md) | axe-core integration, WCAG tags, violation handling |
| SEO & Meta | [references/seo-testing.md](references/seo-testing.md) | Meta tags, Open Graph, structured data, Lighthouse |
| Performance | [references/performance.md](references/performance.md) | Core Web Vitals, performance budgets, tracing |
| Visual Regression | [references/visual-regression.md](references/visual-regression.md) | Screenshot comparison, snapshot strategies |
| Project Structure | [references/project-structure.md](references/project-structure.md) | Page Object Model, fixtures, config, CI/CD |

## Locator Priority (Always Follow This Order)

```typescript
// 1. Role-based (most resilient)
page.getByRole('button', { name: 'Submit' })
page.getByRole('heading', { name: 'Dashboard' })

// 2. Label/placeholder (form elements)
page.getByLabel('Email address')
page.getByPlaceholder('Search...')

// 3. Text content
page.getByText('Welcome back')

// 4. Test ID (when semantic locators aren't possible)
page.getByTestId('checkout-form')
```

Never use CSS classes, XPath, or DOM structure-dependent selectors.

## Assertion Rules

```typescript
// CORRECT: web-first assertions (auto-retry, auto-wait)
await expect(page.getByText('Order confirmed')).toBeVisible()
await expect(page).toHaveURL(/\/dashboard/)
await expect(page.getByRole('alert')).toContainText('Saved')

// WRONG: manual checks (no retry, race conditions)
const visible = await page.getByText('Order confirmed').isVisible()
expect(visible).toBe(true)
```

Always use `await expect(locator)` assertions — they retry until timeout. Never use `expect(await locator.someMethod())`.

## Mobile-First Responsive Breakpoints

Test from smallest to largest. Standard breakpoints:

```typescript
const BREAKPOINTS = {
  mobile: { width: 375, height: 667 },    // iPhone SE
  mobileLarge: { width: 428, height: 926 },// iPhone 14 Pro Max
  tablet: { width: 768, height: 1024 },   // iPad
  laptop: { width: 1024, height: 768 },   // Small laptop
  desktop: { width: 1280, height: 720 },  // Standard desktop
  wide: { width: 1920, height: 1080 },    // Full HD
} as const
```

## Minimal Config Template

```typescript
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ...(process.env.CI ? [['github' as const]] : []),
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    // Mobile-first: test smallest viewports first
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 7'] },
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 15'] },
    },
    {
      name: 'desktop-small-viewport',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 375, height: 667 },
      },
    },
    {
      name: 'tablet',
      use: { ...devices['iPad (gen 7)'] },
    },
    {
      name: 'desktop-chrome',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'desktop-firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'desktop-safari',
      use: { ...devices['Desktop Safari'] },
    },
  ],
})
```

## Anti-Patterns to Avoid

| Anti-Pattern | Why | Do Instead |
|---|---|---|
| `page.waitForTimeout(3000)` | Arbitrary delay, flaky | Use web-first assertions or `waitForSelector` |
| `page.locator('.btn-primary')` | Breaks on CSS changes | `page.getByRole('button', { name: '...' })` |
| `page.locator('//div[3]/span')` | Breaks on DOM changes | Role-based or test ID locators |
| Multiple assertions per test | Cascading failures | One workflow per test, use `test.step()` |
| Testing third-party APIs | Unpredictable, slow | Mock with `page.route()` |
| `expect(await loc.isVisible()).toBe(true)` | No auto-retry | `await expect(loc).toBeVisible()` |
| Shared state between tests | Order-dependent failures | Fresh browser context per test |
| `--no-sandbox` in CI | Security risk | Use proper CI Docker images |
| Only testing mobile via device emulation | Misses non-touch desktop users at small viewports | Test both `devices['Pixel 7']` (touch) AND `Desktop Chrome` with mobile viewport (no touch) |
| Touch-only horizontal scroll (swipe carousels) | Unusable on desktop at mobile viewport | Ensure mouse-wheel/scroll/arrows/drag work as fallback |
