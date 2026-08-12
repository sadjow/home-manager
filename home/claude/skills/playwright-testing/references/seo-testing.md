# SEO Testing

## Meta Tags Validation

```typescript
import { test, expect } from '@playwright/test'

test.describe('SEO meta tags', () => {
  test('homepage has required meta tags', async ({ page }) => {
    await page.goto('/')

    await expect(page).toHaveTitle(/My App/)

    const description = page.locator('meta[name="description"]')
    await expect(description).toHaveAttribute('content', /.{50,160}/)

    const viewport = page.locator('meta[name="viewport"]')
    await expect(viewport).toHaveAttribute('content', /width=device-width/)

    const charset = page.locator('meta[charset]')
    await expect(charset).toHaveAttribute('charset', 'utf-8')
  })

  test('page has canonical URL', async ({ page }) => {
    await page.goto('/about')

    const canonical = page.locator('link[rel="canonical"]')
    await expect(canonical).toHaveAttribute('href', /\/about/)
  })

  test('robots meta allows indexing', async ({ page }) => {
    await page.goto('/')

    const robots = page.locator('meta[name="robots"]')
    const content = await robots.getAttribute('content')
    expect(content).not.toContain('noindex')
  })
})
```

## Open Graph Tags

```typescript
test.describe('Open Graph tags', () => {
  test('page has OG tags for social sharing', async ({ page }) => {
    await page.goto('/')

    await expect(page.locator('meta[property="og:title"]'))
      .toHaveAttribute('content', /.+/)

    await expect(page.locator('meta[property="og:description"]'))
      .toHaveAttribute('content', /.{50,}/)

    await expect(page.locator('meta[property="og:image"]'))
      .toHaveAttribute('content', /^https?:\/\//)

    await expect(page.locator('meta[property="og:url"]'))
      .toHaveAttribute('content', /^https?:\/\//)

    await expect(page.locator('meta[property="og:type"]'))
      .toHaveAttribute('content', /.+/)
  })
})
```

## Twitter Card Tags

```typescript
test('page has Twitter card tags', async ({ page }) => {
  await page.goto('/')

  await expect(page.locator('meta[name="twitter:card"]'))
    .toHaveAttribute('content', /summary|summary_large_image/)

  await expect(page.locator('meta[name="twitter:title"]'))
    .toHaveAttribute('content', /.+/)

  await expect(page.locator('meta[name="twitter:description"]'))
    .toHaveAttribute('content', /.+/)
})
```

## Structured Data (JSON-LD)

```typescript
test.describe('structured data', () => {
  test('homepage has Organization schema', async ({ page }) => {
    await page.goto('/')

    const jsonLd = await page.evaluate(() => {
      const scripts = document.querySelectorAll(
        'script[type="application/ld+json"]'
      )
      return Array.from(scripts).map((s) => JSON.parse(s.textContent || '{}'))
    })

    const orgSchema = jsonLd.find((s) => s['@type'] === 'Organization')
    expect(orgSchema).toBeTruthy()
    expect(orgSchema?.name).toBeTruthy()
    expect(orgSchema?.url).toBeTruthy()
  })

  test('product page has Product schema', async ({ page }) => {
    await page.goto('/products/example')

    const jsonLd = await page.evaluate(() => {
      const scripts = document.querySelectorAll(
        'script[type="application/ld+json"]'
      )
      return Array.from(scripts).map((s) => JSON.parse(s.textContent || '{}'))
    })

    const productSchema = jsonLd.find((s) => s['@type'] === 'Product')
    expect(productSchema).toBeTruthy()
    expect(productSchema?.name).toBeTruthy()
    expect(productSchema?.offers).toBeTruthy()
  })

  test('blog post has Article schema', async ({ page }) => {
    await page.goto('/blog/sample-post')

    const jsonLd = await page.evaluate(() => {
      const scripts = document.querySelectorAll(
        'script[type="application/ld+json"]'
      )
      return Array.from(scripts).map((s) => JSON.parse(s.textContent || '{}'))
    })

    const articleSchema = jsonLd.find((s) => s['@type'] === 'Article')
    expect(articleSchema).toBeTruthy()
    expect(articleSchema?.headline).toBeTruthy()
    expect(articleSchema?.datePublished).toBeTruthy()
    expect(articleSchema?.author).toBeTruthy()
  })
})
```

## Heading Hierarchy

```typescript
test('page has proper heading hierarchy', async ({ page }) => {
  await page.goto('/')

  const h1Count = await page.getByRole('heading', { level: 1 }).count()
  expect(h1Count, 'page should have exactly one h1').toBe(1)

  const headingLevels = await page.evaluate(() => {
    const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6')
    return Array.from(headings).map((h) => parseInt(h.tagName[1]))
  })

  for (let i = 1; i < headingLevels.length; i++) {
    const jump = headingLevels[i] - headingLevels[i - 1]
    expect(jump, `heading level jumps from h${headingLevels[i-1]} to h${headingLevels[i]}`).toBeLessThanOrEqual(1)
  }
})
```

## Link Validation

```typescript
test('internal links are valid', async ({ page }) => {
  await page.goto('/')

  const links = page.getByRole('link')
  const count = await links.count()

  for (let i = 0; i < count; i++) {
    const href = await links.nth(i).getAttribute('href')
    if (!href || href.startsWith('#') || href.startsWith('mailto:') || href.startsWith('tel:')) continue
    expect(href, `link ${i} has href`).toBeTruthy()
  }
})

test('external links have rel attributes', async ({ page }) => {
  await page.goto('/')

  const externalLinks = page.locator('a[target="_blank"]')
  const count = await externalLinks.count()

  for (let i = 0; i < count; i++) {
    const rel = await externalLinks.nth(i).getAttribute('rel')
    expect(rel, `external link ${i} should have rel`).toContain('noopener')
  }
})
```

## Image SEO

```typescript
test('images have alt text and lazy loading', async ({ page }) => {
  await page.goto('/')

  const images = page.locator('img')
  const count = await images.count()

  for (let i = 0; i < count; i++) {
    const img = images.nth(i)
    const alt = await img.getAttribute('alt')
    expect(alt, `image ${i} missing alt attribute`).not.toBeNull()

    // Below-the-fold images should use lazy loading
    const loading = await img.getAttribute('loading')
    const isAboveFold = await img.evaluate((el) => {
      const rect = el.getBoundingClientRect()
      return rect.top < window.innerHeight
    })

    if (!isAboveFold) {
      expect(loading, `below-fold image ${i} should lazy load`).toBe('lazy')
    }
  })
})
```

## Lighthouse Integration

Install: `npm install -D playwright-lighthouse`

```typescript
import { test } from '@playwright/test'
import { playAudit } from 'playwright-lighthouse'

test('lighthouse SEO and performance audit', async ({ page }) => {
  await page.goto('/')

  await playAudit({
    page,
    thresholds: {
      performance: 80,
      accessibility: 90,
      'best-practices': 85,
      seo: 90,
    },
    port: 9222,
  })
})
```

Note: Lighthouse integration requires launching Chromium with remote debugging. Configure in `playwright.config.ts`:

```typescript
{
  name: 'lighthouse',
  use: {
    ...devices['Desktop Chrome'],
    launchOptions: {
      args: ['--remote-debugging-port=9222'],
    },
  },
}
```

## Sitemap Validation

```typescript
test('sitemap.xml is valid and accessible', async ({ request }) => {
  const response = await request.get('/sitemap.xml')
  expect(response.status()).toBe(200)
  expect(response.headers()['content-type']).toContain('xml')

  const body = await response.text()
  expect(body).toContain('<urlset')
  expect(body).toContain('<loc>')
})

test('robots.txt references sitemap', async ({ request }) => {
  const response = await request.get('/robots.txt')
  expect(response.status()).toBe(200)

  const body = await response.text()
  expect(body.toLowerCase()).toContain('sitemap:')
})
```
