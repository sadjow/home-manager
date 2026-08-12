---
description: Identify comments that explain "what" (should be removed) vs "why" (should be kept)
argument-hint: [file-or-directory]
---

Review comments in $ARGUMENTS and categorize them as "what" comments (remove) or "why" comments (keep).

## Your Task

Analyze all comments and identify those that violate the clean code principle: **Comments should explain WHY, not WHAT**.

## Comment Categories

### ❌ "What" Comments (REMOVE)

These explain what the code does - information already visible in the code itself:

```javascript
// ❌ REMOVE: Explains what (obvious from code)
// Loop through users
for (const user of users) {
  // Check if user is active
  if (user.isActive) {
    // Send email
    sendEmail(user);
  }
}

// ✅ BETTER: No comments, self-documenting code
for (const user of activeUsers) {
  sendEmail(user);
}
```

```python
# ❌ REMOVE: Describes what's happening
# Calculate the total
total = price * quantity

# Add tax
total_with_tax = total * 1.08

# ❌ REMOVE: Method description matches method name
# This function validates the user input
def validate_user_input(data):
    pass
```

### ✅ "Why" Comments (KEEP)

These explain business reasons, non-obvious decisions, or context:

```javascript
// ✅ KEEP: Explains WHY (business requirement)
// Apply 15% surcharge for remote areas as required by 2024 logistics contract
if (distance > 1000) {
  cost *= 1.15;
}

// ✅ KEEP: Explains WHY (performance trade-off)
// Using bubble sort here because array is always < 10 items
// and we need stability. Complexity doesn't matter for this size.
bubbleSort(smallArray);

// ✅ KEEP: Explains WHY (workaround for external bug)
// GitHub API returns 404 for private repos with invalid tokens
// instead of 401. We treat 404 as auth error here.
if (response.status === 404) {
  throw new AuthenticationError();
}
```

```python
# ✅ KEEP: Regulatory requirement
# Per GDPR Article 17, user data must be anonymized after 90 days
retention_days = 90

# ✅ KEEP: Non-obvious algorithmic choice
# Using Haversine formula for distance calculation because
# we need to account for Earth's curvature at scales > 100km
distance = haversine_distance(point1, point2)
```

## Additional Comment Issues

### Commented-Out Code (REMOVE)

```javascript
// ❌ REMOVE: Dead code
// function oldImplementation() {
//   return legacy_behavior();
// }

function newImplementation() {
  return modern_behavior();
}
```

Version control preserves history - no need to keep commented code.

### TODO/FIXME Comments

```javascript
// Flag but don't necessarily remove
// TODO: Optimize this query
// FIXME: Handle edge case when user is null
// HACK: Temporary workaround for API bug
```

These are acceptable but should be tracked and addressed.

### Outdated Comments

```javascript
// ❌ REMOVE or UPDATE: Comment no longer matches code
// Returns list of active users
function getAllUsers() { // Now returns ALL users, not just active
  return users;
}
```

## Detection Patterns

Look for comments that:

1. **Describe the next line**: "Create variable", "Call function", "Return result"
2. **Repeat the code**: Comment says exactly what code says
3. **Explain obvious control flow**: "Loop through", "If condition", "Else"
4. **State the obvious**: "Initialize counter to 0"
5. **Describe method/variable names**: Comment just restates the name

## Good Comment Indicators

Keep comments that:

1. **Explain business rules**: Regulatory requirements, contract terms
2. **Justify non-obvious decisions**: Why one approach over another
3. **Document external constraints**: Third-party API quirks, browser bugs
4. **Provide context**: Historical reasons, future considerations
5. **Link to external resources**: RFCs, mathematical formulas, design docs

## Report Format

For each comment found, report:

```
Location: file.js:42

Current Comment:
  // Loop through all users

Category: WHAT (REMOVE)

Reason: Explains obvious loop operation

Suggested Action:
  Remove comment. If code is unclear, rename variable to `activeUsers`
  or extract to method `processActiveUsers()`

---
```

## Output Structure

Provide three sections:

### 1. Comments to Remove (WHAT comments)
- Location, current comment, and why it should be removed

### 2. Comments to Keep (WHY comments)
- Location, comment, and why it's valuable

### 3. Refactoring Suggestions
- If removing comment makes code unclear, suggest renaming or restructuring

### Summary Statistics
- Total comments found
- Comments to remove (%)
- Comments to keep (%)
- Commented-out code blocks found

Do NOT modify the files - just provide the analysis and recommendations.
