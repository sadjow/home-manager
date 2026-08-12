---
description: Generate tests for code using real implementations, avoiding mocks/stubs
argument-hint: [file-path]
---

Generate comprehensive tests for $ARGUMENTS following a testing philosophy that minimizes mocks and stubs.

## Your Task

Write tests that:

1. **Use Real Implementations** - Prefer actual objects over mocks
2. **Test Public APIs** - Focus on behavior, not implementation details
3. **Use Test Doubles Sparingly** - Only when necessary (external APIs, databases)
4. **In-Memory Alternatives** - Use test databases, in-memory stores when available

## Testing Philosophy (No Excessive Mocking)

### Prefer Real Implementations

```javascript
// ❌ AVOID: Excessive mocking
const userService = {
  getUser: jest.fn().mockResolvedValue({ id: 1, name: 'Test' }),
  updateUser: jest.fn().mockResolvedValue(true)
};

// ✅ PREFER: Real implementation with test data
const userService = new UserService(testDatabase);
await userService.createUser({ id: 1, name: 'Test' });
```

### Use Test Doubles Only When Necessary

Mock/stub only for:
- External HTTP APIs (third-party services)
- File system operations (where in-memory alternative doesn't exist)
- Time-dependent code (Date.now(), timers)
- Random number generation
- Hardware interactions

### In-Memory Test Alternatives

Use these instead of mocks:
- **Database**: In-memory SQLite, PostgreSQL with test database
- **Cache**: In-memory cache implementation
- **Queue**: In-memory queue
- **Storage**: In-memory file system (memfs)
- **HTTP**: Test server (supertest, httptest)

## Test Structure

### Arrange-Act-Assert Pattern

```language
test('descriptive test name', () => {
  // Arrange: Set up test data and dependencies
  const user = createTestUser({ name: 'Alice' });

  // Act: Execute the code under test
  const result = processUser(user);

  // Assert: Verify the outcome
  expect(result.status).toBe('processed');
});
```

### Test Coverage Focus

1. **Happy Path** - Normal, expected usage
2. **Edge Cases** - Boundary conditions, empty inputs, nulls
3. **Error Cases** - Invalid inputs, error conditions
4. **Integration Points** - How components work together

## Test Naming Convention

Use descriptive names that explain the scenario:

```
// Pattern: "should [expected behavior] when [condition]"
test('should return user when valid ID provided', ...)
test('should throw error when user not found', ...)
test('should apply discount when coupon is valid', ...)
```

## Language-Specific Frameworks

Adapt to the file's language:
- **JavaScript/TypeScript**: Jest, Vitest, or project's testing framework
- **Python**: pytest or unittest
- **Ruby**: RSpec or Minitest
- **Java**: JUnit
- **Elixir**: ExUnit
- **Go**: testing package

## Output

Generate:

1. **Test file** with appropriate naming convention (`*.test.js`, `*_test.py`, `*_spec.rb`, etc.)
2. **Setup/teardown** if needed (database cleanup, test data)
3. **Helper functions** for creating test data (factories, builders)
4. **Tests** covering main scenarios and edge cases
5. **Comments** only for "why" (non-obvious business rules), not "what"

Run the tests after generating to ensure they pass.
