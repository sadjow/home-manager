# GitHub PR Review Commands

This document provides comprehensive instructions for retrieving and managing GitHub pull request comments, reviews, and their resolution status using custom shell commands configured in this home-manager setup.

## Overview

These commands help you efficiently manage PR reviews by:
- Fetching all review comments and their status
- Checking if review threads are resolved
- Getting comprehensive PR review summaries
- Identifying unresolved comments that need attention

## Available Commands

### Core Functions

#### `gh-pr-comments [PR_NUMBER]`
Fetches all review comments on a pull request.
- Shows reviewer, file location, and comment preview
- Auto-detects current branch's PR if no number provided
- Uses REST API for comprehensive comment retrieval

#### `gh-pr-reviews [PR_NUMBER]`
Retrieves all reviews on a pull request.
- Displays review state (APPROVED, CHANGES_REQUESTED, COMMENTED)
- Shows reviewer and review summary
- Useful for understanding overall review status

#### `gh-pr-threads [PR_NUMBER]`
Gets all review threads with resolution status.
- Uses GraphQL API to fetch thread resolution state
- Shows ✅ for resolved threads, ❌ for unresolved
- Displays file path, line number, and first comment

#### `gh-pr-unresolved [PR_NUMBER]`
Shows only unresolved review threads.
- Filters to display only threads needing attention
- Returns "All review threads are resolved!" if none found
- Perfect for pre-merge checks

#### `gh-pr-resolved [PR_NUMBER]`
Shows only resolved review threads.
- Useful for verifying which comments have been addressed
- Helps track review progress

#### `gh-pr-status [PR_NUMBER]`
Comprehensive PR review status summary.
- Shows PR title, state, and review decision
- Counts total, resolved, and unresolved threads
- Lists all reviews with their states
- Provides complete overview in one command

### Quick Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `gpr` | `gh pr view --comments` | Quick PR view with comments |
| `gpru` | `gh-pr-unresolved` | Show unresolved review threads |
| `gprs` | `gh-pr-status` | Show PR review status summary |
| `gprt` | `gh-pr-threads` | Show all review threads |
| `gprc` | `gh-pr-comments` | Show all review comments |
| `gprr` | `gh-pr-reviews` | Show all reviews |
| `gprh` | `gh-pr-help` | Show help for PR commands |

## Common Workflows

### Check if All Comments Are Addressed

```bash
# Quick check for unresolved comments
gpru

# Or with specific PR number
gh-pr-unresolved 123
```

If output shows "All review threads are resolved!", the PR is ready for merge from a review perspective.

### Get Complete PR Review Status

```bash
# Full status of current branch's PR
gprs

# Or for specific PR
gh-pr-status 456
```

This provides a comprehensive overview including:
- Review decision (APPROVED, CHANGES_REQUESTED, etc.)
- Thread resolution statistics
- Individual review states

### Review Comments by Thread

```bash
# See all threads with resolution status
gprt

# This shows each thread marked as:
# ✅ RESOLVED - Already addressed
# ❌ UNRESOLVED - Needs attention
```

### Workflow for Addressing Reviews

1. **Check unresolved comments**: `gpru`
2. **Address each unresolved comment** in your code
3. **Mark threads as resolved** on GitHub
4. **Verify all resolved**: `gpru` (should show "All review threads are resolved!")
5. **Get final status**: `gprs`

## Using with GitHub CLI

These commands integrate with the GitHub CLI (`gh`) and use both REST and GraphQL APIs:

### REST API Commands
Used for fetching comments and reviews:
```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments
gh api repos/{owner}/{repo}/pulls/{number}/reviews
```

### GraphQL Queries
Used for thread resolution status:
```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        reviewThreads(first: 100) {
          nodes {
            isResolved
            # ... other fields
          }
        }
      }
    }
  }'
```

## Auto-Detection Features

### Repository Detection
Commands automatically detect the current repository from git remote:
- Supports both SSH (`git@github.com:owner/repo.git`) and HTTPS formats
- No need to specify repository manually

### PR Number Detection
If no PR number is provided, commands attempt to detect the current branch's PR:
- Uses `gh pr view` to find associated PR
- Falls back to error message if no PR exists for current branch

## Troubleshooting

### "No PR found for current branch"
- Ensure you have a PR open for your current branch
- Or provide PR number explicitly: `gh-pr-status 123`

### "Could not parse GitHub repository"
- Check that you're in a git repository
- Verify remote origin points to GitHub

### Empty or No Output
- Ensure you're authenticated with GitHub CLI: `gh auth status`
- Check repository access permissions

## Implementation Details

These commands are defined in `home/shell.nix` as shell functions and aliases. They:
- Use Zsh regex matching for parsing git remotes
- Leverage jq for JSON processing
- Support pagination for large result sets
- Handle both SSH and HTTPS repository URLs

## Examples

### Example: Pre-Merge Checklist
```bash
# 1. Check PR status
gprs

# 2. Verify no unresolved comments
gpru

# 3. View all reviews
gprr

# 4. If all clear, ready to merge!
```

### Example: Reviewing Someone Else's PR
```bash
# Get overview of PR 789
gh-pr-status 789

# Check what needs addressing
gh-pr-unresolved 789

# See all review threads
gh-pr-threads 789
```

### Example: Quick Status Check
```bash
# Am I good to merge?
gpru  # Shows unresolved items or confirms all resolved
```

## Notes

- All commands work with private repositories (requires appropriate GitHub access)
- Thread resolution status requires repository write access to modify
- Commands respect GitHub API rate limits
- Large PRs with 100+ threads may need pagination adjustments