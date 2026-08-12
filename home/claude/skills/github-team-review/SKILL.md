---
name: github-team-review
description: Review GitHub organization team delivery, merged PRs, production deployment status, and open work. Use when the user asks to (1) review team work or delivery for a GitHub organization, (2) prepare a demo or sprint review summary, (3) check what's been deployed vs pending production, (4) see what PRs are open or in progress, (5) get a team member breakdown of contributions, (6) audit production vs main branch gaps across repos, (7) "what has the team done", "what's pending deploy", "prepare demo notes", "sprint summary".
---

# GitHub Team Review

Review team delivery across a GitHub organization using `gh` CLI. Produces a summary of merged PRs, production deployment gaps, open work, and per-team-member contributions.

## Prerequisites

- `gh` CLI authenticated (`gh auth status`)
- Access to the target GitHub organization

## Workflow

### 1. Determine Scope

Ask the user for:
- **Organization**: Which GitHub org to review. If not specified, list orgs the user has access to via `gh api user/orgs --jq '.[].login'` and ask.
- **Date range**: Since when. Default to last 30 days if not specified.
- **Specific repos**: Or all repos in the org (default: all).

### 2. List Repos

```bash
gh api orgs/{ORG}/repos --paginate --jq '.[].name'
```

Filter out archived repos if needed:
```bash
gh api orgs/{ORG}/repos --paginate --jq '.[] | select(.archived == false) | .name'
```

### 3. Collect Merged PRs

For each repo, fetch merged PRs in the date range:
```bash
gh pr list --repo {ORG}/{REPO} --state merged --search "merged:>{SINCE_DATE}" --json number,title,mergedAt,author,body --limit 100
```

Use subagents to parallelize across repos for speed.

### 4. Check Production Deployment Status

For each repo with activity, compare the default branch against the production branch. Common production branch names: `production`, `production_environment`, or the repo may not have one.

```bash
gh api repos/{ORG}/{REPO}/compare/production...main --jq '{ahead_by: .ahead_by, behind_by: .behind_by, status: .status}'
```

If `production` doesn't exist, try the repo's default branch name (`master` vs `main`) and check for other patterns.

Also check for open production release PRs:
```bash
gh pr list --repo {ORG}/{REPO} --state open --base production --json number,title,author
```

And get the last production release date:
```bash
gh pr list --repo {ORG}/{REPO} --state merged --base production --json mergedAt,title --limit 1
```

### 5. Collect Open PRs

For each active repo:
```bash
gh pr list --repo {ORG}/{REPO} --state open --json number,title,author,createdAt,headRefName,baseRefName --limit 20
```

### 6. Organize the Report

#### By Team Member

Group all work by PR author:
- **Delivered**: Merged PRs that reached production
- **Pending deploy**: Merged to main but not yet in production
- **In progress**: Open PRs

#### Production Status Table

Highlight repos where main is ahead of production, sorted by urgency:

| Repo | Commits Unreleased | Last Production Release | Open Release PR |
|---|---|---|---|

### 7. Output Format

Present a concise summary suitable for client/stakeholder demos:

```
## Team Delivery — {date range}

### {Team Member Name}
**Delivered:**
- {concise description of shipped work}

**Pending deploy:** {items awaiting production release}

**In progress:** {open PRs with brief description}

---

### Production Release Status
{table of repos with pending deployments}
```

## Tips

- Exclude production release PRs (merge-to-production PRs) from the "delivered" list since they are process artifacts, not features.
- Summarize PR titles into human-readable descriptions — strip ticket numbers and prefixes.
- When repos show production far ahead of main (diverged), flag it for investigation.
- Use natural language in the summary — this is for client presentation, not a technical audit.
