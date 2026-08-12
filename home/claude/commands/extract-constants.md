---
description: Extract magic numbers and strings to constants, establishing SSOT (Single Source of Truth)
argument-hint: [file-path]
---

Extract magic numbers, strings, and configuration values from $ARGUMENTS into properly named constants, following SSOT principles.

## Your Task

Transform magic values into named constants with a single source of truth.

## What to Extract

### 1. Magic Numbers

```javascript
// ❌ BEFORE: Magic number
function processOrder(order) {
  if (order.amount > 100) {
    return order.amount * 0.9;
  }
  return order.amount;
}

// ✅ AFTER: Named constants
const DISCOUNT_THRESHOLD = 100;
const DISCOUNT_RATE = 0.9;

function processOrder(order) {
  if (order.amount > DISCOUNT_THRESHOLD) {
    return order.amount * DISCOUNT_RATE;
  }
  return order.amount;
}
```

### 2. Magic Strings

```python
# ❌ BEFORE: Magic strings
if user.status == "active" and user.role == "admin":
    grant_access()

# ✅ AFTER: Named constants
USER_STATUS_ACTIVE = "active"
USER_ROLE_ADMIN = "admin"

if user.status == USER_STATUS_ACTIVE and user.role == USER_ROLE_ADMIN:
    grant_access()
```

### 3. Configuration Values

```typescript
// ❌ BEFORE: Hardcoded config
const response = await fetch('https://api.example.com/users', {
  timeout: 5000,
  retries: 3
});

// ✅ AFTER: Config constants
const API_BASE_URL = 'https://api.example.com';
const DEFAULT_TIMEOUT = 5000;
const DEFAULT_RETRIES = 3;

const response = await fetch(`${API_BASE_URL}/users`, {
  timeout: DEFAULT_TIMEOUT,
  retries: DEFAULT_RETRIES
});
```

### 4. Business Rules

```ruby
# ❌ BEFORE: Business rule as magic number
def calculate_shipping(weight)
  weight * 2.5 + (weight > 50 ? 15 : 0)
end

# ✅ AFTER: Named business constants
SHIPPING_COST_PER_KG = 2.5
HEAVY_PACKAGE_THRESHOLD = 50
HEAVY_PACKAGE_SURCHARGE = 15

def calculate_shipping(weight)
  base_cost = weight * SHIPPING_COST_PER_KG
  surcharge = weight > HEAVY_PACKAGE_THRESHOLD ? HEAVY_PACKAGE_SURCHARGE : 0
  base_cost + surcharge
end
```

## Constant Naming Guidelines

### Pattern: `SCREAMING_SNAKE_CASE` or `PascalCase`

Use `SCREAMING_SNAKE_CASE` for:
- Primitive constants (numbers, strings, booleans)
- Configuration values
- Enums/status codes

Use `PascalCase` for:
- Configuration objects
- Enum-like structures (in languages that support them)

### Descriptive Names

Make names self-documenting:

```javascript
// ❌ BAD: Unclear
const MAX = 100;
const RATE = 0.15;

// ✅ GOOD: Clear intention
const MAX_LOGIN_ATTEMPTS = 100;
const TAX_RATE = 0.15;
```

## Where to Place Constants

### Strategy by Scope

**File-level constants** (used in one file):
```javascript
// At top of file
const DEFAULT_PAGE_SIZE = 20;
const MAX_RETRIES = 3;
```

**Module-level constants** (used in multiple files):
```javascript
// constants.js or config/constants.js
export const DEFAULT_TIMEOUT = 5000;
export const API_BASE_URL = 'https://api.example.com';
export const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
```

**Domain-specific constants** (grouped by domain):
```typescript
// config/payment.constants.ts
export const PAYMENT_TIMEOUT = 30000;
export const MIN_PAYMENT_AMOUNT = 1.00;
export const MAX_PAYMENT_AMOUNT = 10000.00;

// config/user.constants.ts
export const MIN_PASSWORD_LENGTH = 8;
export const MAX_LOGIN_ATTEMPTS = 5;
```

## SSOT Principle Application

When extracting constants:

1. **Identify all occurrences** of the value across the codebase
2. **Create single source** in appropriate location
3. **Replace all usages** with import/reference to the constant
4. **Group related constants** together

### Example: Establishing SSOT

```javascript
// ❌ VIOLATES SSOT: Timeout duplicated
// file1.js
const timeout = 5000;

// file2.js
const TIMEOUT = 5000;

// file3.js
setTimeout(callback, 5000);

// ✅ FOLLOWS SSOT: Single source
// config/constants.js
export const DEFAULT_TIMEOUT = 5000;

// file1.js
import { DEFAULT_TIMEOUT } from './config/constants';

// file2.js
import { DEFAULT_TIMEOUT } from './config/constants';

// file3.js
import { DEFAULT_TIMEOUT } from './config/constants';
setTimeout(callback, DEFAULT_TIMEOUT);
```

## What NOT to Extract

Don't extract:
- **0, 1, -1** in common contexts (array indices, increments)
- **Empty strings** (`''` for initialization)
- **Boolean literals** (`true`, `false`)
- **Values that will never change** and are universally understood (e.g., `2` in `radius * 2` for diameter)

## Output

Provide:

1. **Identified values** to extract with justification
2. **Suggested constant names** following naming guidelines
3. **Placement strategy** (file-level vs module-level vs config)
4. **Refactored code** with constants applied
5. **Import statements** if creating new constants file

If multiple files share values, create a constants module and update all references to establish SSOT.
