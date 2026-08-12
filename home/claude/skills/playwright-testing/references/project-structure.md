# Project Structure

## Recommended Directory Layout

```
e2e/
├── fixtures/
│   ├── base.ts              # Extended test with custom fixtures
│   └── index.ts             # Re-export all fixtures
├── pages/
│   ├── base.page.ts         # Base page with shared methods
│   ├── home.page.ts
│   ├── login.page.ts
│   └── dashboard.page.ts
├── tests/
│   ├── auth/
│   │   └── login.spec.ts
│   ├── dashboard/
│   │   └── dashboard.spec.ts
│   ├── responsive/
│   │   └── layout.spec.ts
│   ├── a11y/
│   │   └── accessibility.spec.ts
│   ├── seo/
│   │   └── meta-tags.spec.ts
│   └── performance/
│       └── web-vitals.spec.ts
├── helpers/
│   ├── breakpoints.ts        # Viewport constants
│   └── test-data.ts          # Test data factories
└── playwright.config.ts
```

## Page Object Model

### Base Page

```typescript
// e2e/pages/base.page.ts
import { type Page, type Locator } from '@playwright/test'

export abstract class BasePage {
  constructor(protected readonly page: Page) {}

  abstract readonly path: string

  async goto() {
    await this.page.goto(this.path)
  }

  async waitForPageReady() {
    await this.page.waitForLoadState('domcontentloaded')
  }
}
```

### Concrete Page

```typescript
// e2e/pages/login.page.ts
import { type Page, expect } from '@playwright/test'
import { BasePage } from './base.page'

export class LoginPage extends BasePage {
  readonly path = '/login'

  private readonly emailInput = this.page.getByLabel('Email')
  private readonly passwordInput = this.page.getByLabel('Password')
  private readonly submitButton = this.page.getByRole('button', { name: 'Sign in' })
  private readonly errorAlert = this.page.getByRole('alert')

  constructor(page: Page) {
    super(page)
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email)
    await this.passwordInput.fill(password)
    await this.submitButton.click()
  }

  async expectError(message: string) {
    await expect(this.errorAlert).toContainText(message)
  }

  async expectRedirectToDashboard() {
    await expect(this.page).toHaveURL(/\/dashboard/)
  }
}
```

### Page with Components

```typescript
// e2e/pages/dashboard.page.ts
import { type Page, type Locator, expect } from '@playwright/test'
import { BasePage } from './base.page'

export class DashboardPage extends BasePage {
  readonly path = '/dashboard'

  private readonly heading = this.page.getByRole('heading', { name: 'Dashboard' })
  private readonly sidebar = this.page.getByRole('complementary')
  private readonly mainContent = this.page.getByRole('main')
  private readonly userMenu = this.page.getByRole('button', { name: /user menu/i })
  private readonly logoutLink = this.page.getByRole('menuitem', { name: 'Logout' })

  constructor(page: Page) {
    super(page)
  }

  async expectLoaded() {
    await expect(this.heading).toBeVisible()
  }

  async logout() {
    await this.userMenu.click()
    await this.logoutLink.click()
  }

  async expectSidebarVisible() {
    await expect(this.sidebar).toBeVisible()
  }

  async expectSidebarHidden() {
    await expect(this.sidebar).toBeHidden()
  }
}
```

## Fixtures

### Custom Fixtures with Page Objects

```typescript
// e2e/fixtures/base.ts
import { test as base } from '@playwright/test'
import { LoginPage } from '../pages/login.page'
import { DashboardPage } from '../pages/dashboard.page'

type Fixtures = {
  loginPage: LoginPage
  dashboardPage: DashboardPage
}

export const test = base.extend<Fixtures>({
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page))
  },
  dashboardPage: async ({ page }, use) => {
    await use(new DashboardPage(page))
  },
})

export { expect } from '@playwright/test'
```

### Authenticated Fixture

```typescript
// e2e/fixtures/base.ts
import { test as base } from '@playwright/test'

export const test = base.extend<{
  authenticatedPage: Page
}>({
  authenticatedPage: async ({ page }, use) => {
    await page.goto('/login')
    await page.getByLabel('Email').fill('test@example.com')
    await page.getByLabel('Password').fill('password123')
    await page.getByRole('button', { name: 'Sign in' }).click()
    await page.waitForURL('/dashboard')
    await use(page)
  },
})
```

### Shared Authentication State (Setup Project)

```typescript
// playwright.config.ts
export default defineConfig({
  projects: [
    {
      name: 'setup',
      testMatch: /.*\.setup\.ts/,
    },
    {
      name: 'desktop-chrome',
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'e2e/.auth/user.json',
      },
      dependencies: ['setup'],
    },
  ],
})

// e2e/tests/auth.setup.ts
import { test as setup, expect } from '@playwright/test'

const authFile = 'e2e/.auth/user.json'

setup('authenticate', async ({ page }) => {
  await page.goto('/login')
  await page.getByLabel('Email').fill('test@example.com')
  await page.getByLabel('Password').fill('password123')
  await page.getByRole('button', { name: 'Sign in' }).click()
  await page.waitForURL('/dashboard')
  await page.context().storageState({ path: authFile })
})
```

## Test File Structure

```typescript
// e2e/tests/auth/login.spec.ts
import { test, expect } from '../../fixtures/base'

test.describe('login', () => {
  test.beforeEach(async ({ loginPage }) => {
    await loginPage.goto()
  })

  test('redirects to dashboard on valid credentials', async ({ loginPage }) => {
    await loginPage.login('user@test.com', 'validpass')
    await loginPage.expectRedirectToDashboard()
  })

  test('shows error on invalid credentials', async ({ loginPage }) => {
    await loginPage.login('user@test.com', 'wrongpass')
    await loginPage.expectError('Invalid credentials')
  })
})
```

## Shared Constants

```typescript
// e2e/helpers/breakpoints.ts
export const BREAKPOINTS = {
  mobile: { width: 375, height: 667 },
  mobileLarge: { width: 428, height: 926 },
  tablet: { width: 768, height: 1024 },
  laptop: { width: 1024, height: 768 },
  desktop: { width: 1280, height: 720 },
  wide: { width: 1920, height: 1080 },
} as const

export type Breakpoint = keyof typeof BREAKPOINTS
```

## Full Config Template

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './e2e/tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ...(process.env.CI ? [['github' as const]] : []),
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  expect: {
    toHaveScreenshot: {
      maxDiffPixelRatio: 0.01,
      animations: 'disabled',
    },
  },
  projects: [
    { name: 'setup', testMatch: /.*\.setup\.ts/ },
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 7'], storageState: 'e2e/.auth/user.json' },
      dependencies: ['setup'],
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 15'], storageState: 'e2e/.auth/user.json' },
      dependencies: ['setup'],
    },
    {
      name: 'tablet',
      use: { ...devices['iPad (gen 7)'], storageState: 'e2e/.auth/user.json' },
      dependencies: ['setup'],
    },
    {
      name: 'desktop-chrome',
      use: { ...devices['Desktop Chrome'], storageState: 'e2e/.auth/user.json' },
      dependencies: ['setup'],
    },
    {
      name: 'desktop-firefox',
      use: { ...devices['Desktop Firefox'], storageState: 'e2e/.auth/user.json' },
      dependencies: ['setup'],
    },
    {
      name: 'desktop-safari',
      use: { ...devices['Desktop Safari'], storageState: 'e2e/.auth/user.json' },
      dependencies: ['setup'],
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
```

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/e2e.yml
name: E2E Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test
      - uses: actions/upload-artifact@v4
        if: ${{ !cancelled() }}
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30
```

### Sharding for Faster CI

```yaml
jobs:
  test:
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - run: npx playwright test --shard=${{ matrix.shard }}/4
```

## API Mocking

```typescript
// e2e/helpers/mocks.ts
import { type Page } from '@playwright/test'

export async function mockUserApi(page: Page, userData: Record<string, unknown>) {
  await page.route('/api/user', (route) =>
    route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(userData),
    })
  )
}

export async function mockApiError(page: Page, path: string, status = 500) {
  await page.route(`/api${path}`, (route) =>
    route.fulfill({
      status,
      contentType: 'application/json',
      body: JSON.stringify({ error: 'Internal Server Error' }),
    })
  )
}
```

Usage in tests:

```typescript
test('handles API errors gracefully', async ({ page }) => {
  await mockApiError(page, '/dashboard/stats')
  await page.goto('/dashboard')
  await expect(page.getByRole('alert')).toContainText('Failed to load')
})
```
