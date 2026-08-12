---
description: Suggest a one-line conventional commit message for staged changes
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*)
---

Analyze the staged changes and suggest a conventional commit message.

## Your Task

1. **Check for staged changes**: Run `git diff --staged` to see what's staged
2. **Analyze the code**: Understand what actually changed in the code
3. **Check recent style**: Run `git log -5 --oneline` for consistency
4. **Generate message**: Create one line following conventional commit format

## Format

```
type: description
```

## Types

- `feat` - New feature or functionality
- `fix` - Bug fix
- `refactor` - Code restructuring without behavior change
- `perf` - Performance improvement
- `style` - Formatting changes
- `test` - Test changes
- `docs` - Documentation
- `build` - Build system or dependencies
- `ci` - CI configuration
- `chore` - Routine tasks, maintenance

## Rules

1. **One line only**
2. **No co-author or Claude mentions**
3. **No dates**
4. **Positive language** - what was added/improved
5. **Based on actual code changes** - not the conversation
6. **Lowercase after colon**
7. **Imperative mood** - "add" not "added" or "adds"
8. **Be specific** - avoid vague terms

## Examples

✅ Good:
- `feat: add JWT authentication middleware`
- `fix: resolve race condition in payment processing`
- `refactor: extract magic numbers to constants`
- `perf: optimize user query with database indexes`

❌ Bad:
- `feat: Add stuff` - too vague
- `Fixed bug on 2025-11-11` - has date, past tense, no type
- `refactor: clean code improvements` - vague

## Output

Provide ONLY the suggested commit message - one line, ready to copy/use.
