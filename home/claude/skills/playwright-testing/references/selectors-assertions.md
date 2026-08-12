# Selectors & Assertions

## Locator Strategy (Priority Order)

### 1. Role-Based Locators (Preferred)

Reflect how users and assistive technology perceive the page. Most resilient to UI refactors.

```typescript
page.getByRole('button', { name: 'Add to cart' })
page.getByRole('heading', { name: 'Product Details', level: 2 })
page.getByRole('link', { name: 'View all products' })
page.getByRole('navigation', { name: 'Main' })
page.getByRole('textbox', { name: 'Search' })
page.getByRole('checkbox', { name: 'Remember me' })
page.getByRole('combobox', { name: 'Country' })
page.getByRole('tab', { name: 'Reviews' })
page.getByRole('alert')
page.getByRole('dialog', { name: 'Confirm deletion' })
```

### 2. Label/Placeholder (Form Elements)

```typescript
page.getByLabel('Email address')
page.getByLabel('Password')
page.getByPlaceholder('Search products...')
page.getByPlaceholder('Enter your email')
```

### 3. Text Content

```typescript
page.getByText('Welcome back, John')
page.getByText('No results found')
page.getByText(/total: \$\d+\.\d{2}/i)
```

### 4. Test IDs (Fallback)

Use when semantic locators aren't possible (canvas, complex widgets, generated content).

```typescript
page.getByTestId('chart-container')
page.getByTestId('drag-handle')
```

Configure custom test ID attribute:

```typescript
// playwright.config.ts
use: {
  testIdAttribute: 'data-test'
}
```

### 5. Chaining & Filtering

Narrow scope to avoid ambiguous matches:

```typescript
// Filter by text
page.getByRole('listitem').filter({ hasText: 'Product 2' })

// Filter by child locator
page.getByRole('listitem').filter({
  has: page.getByRole('button', { name: 'Buy' })
})

// Chain locators
page.getByRole('navigation').getByRole('link', { name: 'Home' })

// Nth element (avoid if possible)
page.getByRole('listitem').nth(0)
page.getByRole('listitem').first()
page.getByRole('listitem').last()
```

## Web-First Assertions

All assertions auto-retry until timeout (default 5s). Use `await expect(locator)` form.

### Visibility & Presence

```typescript
await expect(page.getByText('Success')).toBeVisible()
await expect(page.getByText('Loading')).toBeHidden()
await expect(page.getByRole('dialog')).toBeAttached()
await expect(page.getByTestId('overlay')).not.toBeAttached()
```

### Content

```typescript
await expect(page.getByRole('heading')).toHaveText('Dashboard')
await expect(page.getByRole('heading')).toContainText('Dash')
await expect(page.getByLabel('Name')).toHaveValue('John')
await expect(page.getByLabel('Name')).toBeEmpty()
await expect(page.getByRole('listitem')).toHaveCount(5)
```

### State

```typescript
await expect(page.getByRole('button')).toBeEnabled()
await expect(page.getByRole('button')).toBeDisabled()
await expect(page.getByRole('checkbox')).toBeChecked()
await expect(page.getByRole('textbox')).toBeEditable()
await expect(page.getByRole('textbox')).toBeFocused()
```

### Page-Level

```typescript
await expect(page).toHaveURL(/\/dashboard/)
await expect(page).toHaveURL('https://example.com/dashboard')
await expect(page).toHaveTitle('Dashboard - MyApp')
await expect(page).toHaveTitle(/Dashboard/)
```

### CSS

```typescript
await expect(page.getByRole('alert')).toHaveClass(/error/)
await expect(page.getByRole('alert')).toHaveCSS('color', 'rgb(255, 0, 0)')
await expect(page.getByTestId('box')).toHaveCSS('display', 'flex')
```

### Custom Timeout

```typescript
await expect(page.getByText('Loaded')).toBeVisible({ timeout: 10_000 })
```

## Soft Assertions

Non-blocking — collect all failures, report at test end:

```typescript
await expect.soft(page.getByTestId('status')).toHaveText('Active')
await expect.soft(page.getByTestId('role')).toHaveText('Admin')
await expect.soft(page.getByTestId('email')).toHaveText('user@test.com')
```

## Test Steps

Group related actions for better trace readability:

```typescript
test('checkout flow', async ({ page }) => {
  await test.step('add item to cart', async () => {
    await page.getByRole('button', { name: 'Add to cart' }).click()
    await expect(page.getByTestId('cart-count')).toHaveText('1')
  })

  await test.step('complete checkout', async () => {
    await page.getByRole('link', { name: 'Checkout' }).click()
    await page.getByLabel('Card number').fill('4242424242424242')
    await page.getByRole('button', { name: 'Pay' }).click()
  })

  await test.step('verify confirmation', async () => {
    await expect(page.getByRole('heading')).toHaveText('Order Confirmed')
  })
})
```
