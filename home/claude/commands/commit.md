---
description: Commit staged changes with a generated conventional commit message
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git commit:*)
---

Commit the currently staged changes with a conventional commit message.

## Your Task

1. **Check for staged changes**: Run `git diff --staged` to verify what's staged
2. **Verify there are changes**: If nothing is staged, inform the user
3. **Analyze the code changes**: Understand what actually changed
4. **Check recent commits**: Run `git log -5 --oneline` for style consistency
5. **Generate commit message**: Create a one-line conventional commit
6. **Show the message**: Display the commit message you're about to use
7. **Commit**: Execute `git commit -m "the message"`

## Commit Message Format

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

## Critical Rules

1. **One line only** - No multi-line commits
2. **No co-author** - Don't add "Co-Authored-By" or mention Claude/AI
3. **No dates** - Don't mention dates in commit messages
4. **Positive language** - Focus on what was added/improved
5. **Based on code** - Write about actual changes, not the conversation
6. **Don't mention clean code explicitly** - Just describe what changed
7. **Imperative mood** - "add feature" not "added" or "adds"
8. **Lowercase after colon**
9. **Be specific** - Avoid vague terms like "improve code"

## Workflow

1. Analyze staged changes
2. Generate appropriate commit message
3. Show the message to the user
4. Execute the commit
5. Confirm success with `git log -1 --oneline`

## Examples of Good Messages

- `feat: add user authentication with JWT`
- `fix: resolve payment timeout in checkout flow`
- `refactor: extract configuration constants to config file`
- `perf: optimize database queries with eager loading`
- `test: add integration tests for user registration`

## Output Format

1. Show the commit message you'll use
2. Execute the commit
3. Show confirmation of the commit
